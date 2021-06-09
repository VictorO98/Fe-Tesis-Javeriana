using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.Seguridad.Negocio
{
    public class COSeguridadBiz
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RepoDemografia _repoDemografia;
        private readonly RepoDocumento _repoDocumento;
        private readonly IConfiguration _configuration;

        public COSeguridadBiz(UserManager<IdentityUser> userManager, RepoDemografia repoDemografia, RepoDocumento repoDocumento, IConfiguration configuration) 
        {
            _userManager = userManager;
            _repoDemografia = repoDemografia;
            _repoDocumento = repoDocumento;
            _configuration = configuration;
        }

        public async Task<RespuestaLogin> RefreshToken(string token)
        {
            JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
            var tokenS = handler.ReadToken(token) as JwtSecurityToken;
            var email = tokenS.Claims.First(claim => claim.Type == "email").Value;
            if (string.IsNullOrEmpty(email))
                throw new COExcepcion("El token no es válido");

            var jwtToken = await GenerarTokenAcceso(await _userManager.FindByEmailAsync(email));

            return new RespuestaLogin
            {
                Codigo = COCodigoRespuesta.OK,
                Mensaje = "Se refrescó el token correctamente. ",
                Token = new JwtSecurityTokenHandler().WriteToken(jwtToken),
                Expire = jwtToken.ValidTo
            };
        }

        private async Task<JwtSecurityToken> GenerarTokenAcceso(IdentityUser user)
        {
            var userRoles = await _userManager.GetRolesAsync(user);
            var demografia = _repoDemografia.GetDemografiaPorEmail(user.Email);
            var tipoDocumento = _repoDocumento.GetTipoDocumentoPorId(demografia.Tipodocumentocorid);
            var authClaims = new List<Claim>
                {
                    new Claim("email", user.Email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim("nombres", demografia.Nombre),
                    new Claim("apellidos", demografia.Apellido),
                    new Claim("telefono", demografia.Telefono.ToString()),
                    new Claim("id", demografia.Id.ToString()),
                    new Claim("tipoDocumento", tipoDocumento.Nombre),
                    new Claim("documento", demografia.Numerodocumento.ToString())

                };
             
            foreach (var userRole in userRoles)
            {
                authClaims.Add(new Claim("roles", userRole));
            }

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWT:Secret"]));

            return new JwtSecurityToken(
                issuer: _configuration["JWT:ValidIssuer"],
                audience: _configuration["JWT:ValidAudience"],
                expires: DateTime.Now.AddDays(60),
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
                );
        }

        public async Task<RespuestaLogin> Login(LoginDatos model)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);

            if (user == null)
                throw new COExcepcion("El email no se encuentra registrado. ");

            if (await _userManager.CheckPasswordAsync(user, model.Password))
            {
                // TODO : Queda pendiente resolver la confirmación del usuario para desbloquear esta validación
                /*if (!user.EmailConfirmed)
                     return new RespuestaLogin
                     {
                         Codigo = 11,
                         Mensaje = "Por favor confirme la cuenta. El email fue enviado a su correo electrónico. ¿Desea reenviar el mensaje de confirmación?"
                     };*/
                var token = await GenerarTokenAcceso(user);

                return new RespuestaLogin
                {
                    Codigo = COCodigoRespuesta.OK,
                    Mensaje = "Se inició sesión correctamente",
                    Token = new JwtSecurityTokenHandler().WriteToken(token),
                    Expire = token.ValidTo
                };
            }
            throw new COExcepcion("La contraseña es incorrecta. ");
        }

        

        public async Task<ApplicationUser> RegistrarUsuario(RegisterDatos model)
        {
            try
            {
                ValidarDatosRegistro(model);

                if (!model.IsAceptaTerminosYCondiciones)
                    throw new COExcepcion("No aceptó los términos y condiciones. ");

                if (model.IdTipoCliente == CORol.ADMIN)
                    throw new COExcepcion("Este rol no tiene permiso para registro. ");

                var rolIdentity = CORol.GetIdentityRolPorId(model.IdTipoCliente);
                if (rolIdentity == null)
                    throw new COExcepcion("El rol no existe");

                var userExists = await _userManager.FindByEmailAsync(model.Email);
                if (userExists != null)
                    throw new COExcepcion("Este correo electrónico ya se encuentra registrado. ");

                ApplicationUser user = new ApplicationUser()
                {
                    Email = model.Email,
                    SecurityStamp = Guid.NewGuid().ToString(),
                    UserName = model.Email,
                    PhoneNumber = model.NumeroTelefonico.ToString()
                };

                var result = await _userManager.CreateAsync(user, model.Password);

                if (!result.Succeeded)
                {
                    StringBuilder sb = new StringBuilder();
                    result.Errors.ToList().ForEach(err =>
                    {
                        sb.Append($@" - {err.Description}");
                    });

                    throw new COExcepcion(sb.ToString());
                }

                if (result == IdentityResult.Success)
                {
                    await _userManager.AddToRoleAsync(user, rolIdentity);

                    var demografia = new DemografiaCor
                    {
                        Aceptoterminoscondiciones = 1,
                        Email = model.Email,
                        Nombre = model.Nombres,
                        Apellido = model.Apellidos,
                        Estado = COEstados.VIGENTE,
                        Tipodocumentocorid = model.IdTipoDocumento,
                        Numerodocumento = int.Parse(model.NumeroDocumento),
                        Creacion = DateTime.Now,
                        Codigotelefonopais = model.CodigoTelefonoPais,
                        Telefono = int.Parse(model.NumeroTelefonico),
                        Rolcorid = model.IdTipoCliente,
                        Modificacion = DateTime.Now,
                        Direccion = model.Direccion,
                        Idpoblacion = int.Parse(model.IdPoblacion),
                    };

                    _repoDemografia.GuardarDemografia(demografia);
                }
                else
                {
                    StringBuilder sb = new StringBuilder();
                    result.Errors.ToList().ForEach(err =>
                    {
                        sb.Append($@" - {err.Description}");
                    });
                    RepoErrorLog.AddErrorLog(new ErrorLog
                    {
                        Usuario = user.Email,
                        Mensaje = $@"No se logro registrar al usuario en IdentityServer. {sb}",
                        Tipoerror = COErrorLog.NO_SE_INSERTO_USUARIO_IDENTITY_SERVER,
                        Creacion = DateTime.Now
                    });

                    throw new COExcepcion("No se logro registrar el usuario en el sistema. ");
                }
                return user;
            }
            catch (COExcepcion e)
            {
                throw new COExcepcion("Ocurrió un problema al realizar el registro. " + e.Message);
            }
        }

        private void ValidarDatosRegistro(RegisterDatos registroDatos) 
        {
            bool isDatosCorrectos = true;
            StringBuilder mensajeDeError = new StringBuilder();
            mensajeDeError.Append("Los datos diligenciados son incorrectos:");

            if (string.IsNullOrEmpty(registroDatos.Nombres) || string.IsNullOrWhiteSpace(registroDatos.Nombres))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Nombres");
            }
            else
            {
                registroDatos.Nombres = registroDatos.Nombres.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.Apellidos) || string.IsNullOrWhiteSpace(registroDatos.Apellidos))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Apellidos");
            }
            else
            {
                registroDatos.Apellidos = registroDatos.Apellidos.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.Email) || string.IsNullOrWhiteSpace(registroDatos.Email))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Correo electrónico");
            }
            else
            {
                registroDatos.Email = registroDatos.Email.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.NumeroDocumento) || string.IsNullOrWhiteSpace(registroDatos.NumeroDocumento))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Número de documento");
            }
            else
            {
                registroDatos.NumeroDocumento = registroDatos.NumeroDocumento.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.CodigoTelefonoPais) || string.IsNullOrWhiteSpace(registroDatos.CodigoTelefonoPais))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Código telèfonico");
            }
            else
            {
                registroDatos.CodigoTelefonoPais = registroDatos.CodigoTelefonoPais.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.NumeroTelefonico) || string.IsNullOrWhiteSpace(registroDatos.NumeroTelefonico))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Número de teléfonico");
            }
            else
            {
                registroDatos.NumeroTelefonico = registroDatos.NumeroTelefonico.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.ConfirmPassword) || string.IsNullOrWhiteSpace(registroDatos.ConfirmPassword))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Confirmación de contraseña");
            }
            else
            {
                registroDatos.ConfirmPassword = registroDatos.ConfirmPassword.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.Password) || string.IsNullOrWhiteSpace(registroDatos.Password))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Contraseña");
            }
            else
            {
                registroDatos.Password = registroDatos.Password.Trim();
            }

            if (string.IsNullOrEmpty(registroDatos.Direccion) || string.IsNullOrWhiteSpace(registroDatos.Direccion))
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Direccion");
            }
            else
            {
                registroDatos.Direccion = registroDatos.Direccion.Trim();
            }


            if (registroDatos.IdTipoCliente <= 0)
            {
                isDatosCorrectos = false;
                mensajeDeError.Append(" - Tipo de cliente");
            }

            if (!isDatosCorrectos)
                throw new COExcepcion(mensajeDeError.ToString());

            if (!registroDatos.ConfirmPassword.Equals(registroDatos.Password))
                throw new COExcepcion("La confirmación y la contraseña no coinciden. ");

            if (registroDatos.Password.Length < 8)
                throw new COExcepcion("La contraseña es muy corta");
        }
    }
}
