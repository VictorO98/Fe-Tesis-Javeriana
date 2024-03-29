﻿using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Core.Seguridad.Datos;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Fe.Core.Seguridad.Negocio
{
    public class COSeguridadBiz
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RepoDemografia _repoDemografia;
        private readonly RepoDocumento _repoDocumento;
        private readonly RepoDatosBancarios _repoDatosBancarios;
        private readonly RepoRoles _repoRoles;
        private readonly RepoDocumentosEmprendedor _repoDocumentosEmprendedor;
        private readonly RepoPoblacion _repoPoblacion;
        private readonly IConfiguration _configuration;

        public COSeguridadBiz(UserManager<IdentityUser> userManager, RepoDemografia repoDemografia, RepoDocumento repoDocumento, RepoDatosBancarios repoDatosBancarios,
                            RepoRoles repoRoles, IConfiguration configuration, RepoPoblacion repoPoblacion, RepoDocumentosEmprendedor repoDocumentosEmprendedor) 
        {
            _userManager = userManager;
            _repoDemografia = repoDemografia;
            _repoDocumento = repoDocumento;
            _repoDatosBancarios = repoDatosBancarios;
            _configuration = configuration;
            _repoRoles = repoRoles;
            _repoPoblacion = repoPoblacion;
            _repoDocumentosEmprendedor = repoDocumentosEmprendedor;
        }

        internal async Task<RespuestaDatos> SubirImagenSocial(IFormFileCollection files, DemografiaCor demografiaCor)
        {
            if (demografiaCor != null)
            {
                try
                {    
                    string directorio = _configuration["ImageSociales:DirectorioSocial"];
                    directorio = directorio + "/" + "Social";

                    if (string.IsNullOrEmpty(directorio))
                    {
                        RepoErrorLog.AddErrorLog(new ErrorLog
                        {
                            Mensaje = "No se encuentra definida la ruta para las imagenes de evidencia. ",
                            Traza = null,
                            Usuario = demografiaCor.Email,
                            Creacion = DateTime.Now,
                            Tipoerror = COErrorLog.RUTA_NO_ENCONTRADA
                        });
                        throw new COExcepcion("Problema con las rutas. Por favor contacte a servicio al cliente. ");
                    }


                    var folderName = Path.Combine(directorio);
                    if (files.Count == 0)
                        throw new COExcepcion("No hay documento a subir. ");

                    if (files.Count > 4)
                        throw new COExcepcion("Solo se puede subir un máximo de 1 documento. ");

                    string[] permittedExtensions = { ".jpg", ".jpeg", ".png" };
                    List<string> listadoDeRutaFotos = new List<string>();
                    var folderDocument = directorio;
                    var indexDocumentos = 1;

                    foreach (var file in files)
                    {

                        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
                        if (string.IsNullOrEmpty(ext) || !permittedExtensions.Contains(ext))
                            throw new COExcepcion("Solo se aceptan imágenes JPG y PNG. ");

                        var fileName = $@"imagen-usuario-buya-{demografiaCor.Id}{ext}";
                        demografiaCor.UrlImagenPersonal = fileName;
                        var fullPath = Path.Combine(folderName, fileName);
                        using var stream = new FileStream(fullPath, FileMode.Create);
                        file.CopyTo(stream);
                        listadoDeRutaFotos.Add(fullPath);
                        indexDocumentos += 1;
                    }

                    if (listadoDeRutaFotos.Count == 0)
                        throw new COExcepcion("No se almacenó ninguna imagen.");

                    _repoDemografia.SubirImagenSocial(demografiaCor);

                    return new RespuestaDatos
                    {
                        Codigo = COCodigoRespuesta.OK,
                        Mensaje = "Se guardo correctamente la imagen."
                    };

                }
                catch (COExcepcion e)
                {
                    throw e;
                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
        }

        internal CuentaBancariaEmprendedor ObtenerDatosbancarios(DemografiaCor demografiaCor)
        {
            if (demografiaCor == null)
                throw new COExcepcion("El usuario no existe. ");

            return _repoDatosBancarios.ObtenerDatosbancarios(demografiaCor.Id);
        }

        public async Task<RespuestaDatos> ConfirmAccount(ConfirmarCuentaDatos confirmarCuentaDatos)
        {
            if (confirmarCuentaDatos.Email == null || confirmarCuentaDatos.Code == null)
                throw new COExcepcion("No se confirmo la cuenta.");

            var userExists = await _userManager.FindByEmailAsync(confirmarCuentaDatos.Email);
            if (userExists == null)
                throw new COExcepcion("Este correo electrónico no se enceuntra registrado. ");

            string decodedTokenString = confirmarCuentaDatos.Code;
            var result = await _userManager.ConfirmEmailAsync(userExists, decodedTokenString);
            if (result.Succeeded)
                return new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Usuario confirmado correctamente." };

            StringBuilder sb = new StringBuilder();
            result.Errors.ToList().ForEach(err => sb.Append($@" - {err.Description}"));
            throw new COExcepcion(sb.ToString());
        }

        internal async Task<bool> IsImagen(DemografiaCor demografiaCor)
        {
            var respuesta = false;
            if (demografiaCor.UrlImagenPersonal != null)
                respuesta = true;
            return respuesta;
        }

        internal async Task<string> GetImagenSocial(DemografiaCor demografiaCor)
        {
            try
            {
                if (demografiaCor == null)
                    throw new COExcepcion("El usuario no existe ");

                string fileName = demografiaCor.UrlImagenPersonal;

                if (!fileName.Contains($@"imagen-usuario-buya-{demografiaCor.Id}"))
                    throw new COExcepcion("No tiene acceso a esta imagen. ");

                string directorio = _configuration["ImageSociales:DirectorioSocial"] + "/Social";

                return  Path.Combine(directorio, Path.GetFileName(fileName));

            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = demografiaCor.Email,
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.MODIFICAR_USUARIO
                });
                throw e;
            }
        }

        internal async Task<RespuestaDatos> SubirDocumentosEmprendedor(DemografiaCor demografiaCor, string RazonsSocial, IFormFileCollection files)
        {
            if (demografiaCor != null)
            {
                try
                {
                    DocumentosDemografiaCor documentosDemografiaCor = new DocumentosDemografiaCor();
                    documentosDemografiaCor.Iddemografia = demografiaCor.Id;
                    documentosDemografiaCor.Razonsocial = RazonsSocial;
                    documentosDemografiaCor.Creacion = DateTime.Now;
                    string directorio = _configuration["ImageDocumentos:DirectorioDocumentos"];
                    directorio = directorio + "/" + "Documentos";

                    if (string.IsNullOrEmpty(directorio))
                    {
                        RepoErrorLog.AddErrorLog(new ErrorLog
                        {
                            Mensaje = "No se encuentra definida la ruta para las imagenes de evidencia. ",
                            Traza = null,
                            Usuario = demografiaCor.Email,
                            Creacion = DateTime.Now,
                            Tipoerror = COErrorLog.RUTA_NO_ENCONTRADA
                        });
                        throw new COExcepcion("Problema con las rutas. Por favor contacte a servicio al cliente. ");
                    }


                        var folderName = Path.Combine(directorio);
                        if (files.Count == 0)
                            throw new COExcepcion("No hay documento a subir. ");

                        if (files.Count > 4)
                            throw new COExcepcion("Solo se puede subir un máximo de 4 documento. ");

                        string[] permittedExtensions = { ".jpg", ".jpeg", ".png" };
                        List<string> listadoDeRutaFotos = new List<string>();
                        var folderDocument = directorio;
                        var indexDocumentos = 1;

                        foreach (var file in files)
                        {

                            var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
                            if (string.IsNullOrEmpty(ext) || !permittedExtensions.Contains(ext))
                                throw new COExcepcion("Solo se aceptan imágenes JPG y PNG. ");

                            var fileName = $@"imagen-documento-{demografiaCor.Id}-{indexDocumentos}{ext}";
                            documentosDemografiaCor.Urlimagen = fileName;
                            var fullPath = Path.Combine(folderName, fileName);
                            using var stream = new FileStream(fullPath, FileMode.Create);
                            file.CopyTo(stream);
                            listadoDeRutaFotos.Add(fullPath);
                            indexDocumentos += 1;
                        }

                    if (listadoDeRutaFotos.Count == 0)
                            throw new COExcepcion("No se almacenó ninguna imagen.");
                        
                    await _repoDocumentosEmprendedor.SubirDocumentosEmprendedor(documentosDemografiaCor);

                    return new RespuestaDatos
                    {
                        Codigo = COCodigoRespuesta.OK,
                        Mensaje = "Se guardo correctamente la publicación."
                    };

                }
                catch (COExcepcion e)
                {
                    throw e;
                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
        }

        public async Task<RespuestaDatos> GuardarDatosBancarios(DatosBancariosDemografia model, DemografiaCor demografiaCor)
        {
            try
            {
                if (demografiaCor.Rolcorid == CORol.EMPRENDEDOR)
                {
                    var datosBancarios = new CuentasBancariasDemografiaCor
                    {
                        IdDemografia = demografiaCor.Id,
                        Numero = Convert.ToInt64(model.NumeroCuentaBancaria),
                        Tipocuenta = model.TipoDeCuenta,
                        Identidadbancaria = model.EntidadBancaria,
                        Creacion = DateTime.Now,
                        Modificacion = DateTime.Now
                    };
                    return await _repoDatosBancarios.GuardarDatosBancariosDemografia(datosBancarios);
                }
                return null;
            }
            catch(COExcepcion e)
            {
                throw e;
            }
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
            var poblacion = _repoPoblacion.GetPoblacionPorIdPoblacion(demografia.Idpoblacion);
            var estado = _repoPoblacion.GetEstadoPorIdPoblacion(demografia.Idpoblacion);
            var authClaims = new List<Claim>
                {
                    new Claim("email", user.Email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim("nombres", demografia.Nombre),
                    new Claim("apellidos", demografia.Apellido),
                    new Claim("telefono", demografia.Telefono.ToString()),
                    new Claim("id", demografia.Id.ToString()),
                    new Claim("tipoDocumento", tipoDocumento.Nombre),
                    new Claim("documento", demografia.Numerodocumento.ToString()),
                    new Claim("direccion", demografia.Direccion.ToString()),
                    new Claim("poblacion", poblacion.Nombre.ToString()),
                    new Claim("estado", estado.Nombre.ToString())
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

        public async Task<RespuestaDatos> ModificarDemografia(ModificarDemografia model, DemografiaCor demografiaCor)
        {
            if (demografiaCor == null)
                throw new COExcepcion("El usuario no existe");

            try
            {
                return await _repoDemografia.ModificarDemografia(demografiaCor, model);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = model.Correo,
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.MODIFICAR_USUARIO
                });
                throw new COExcepcion("Ocurrió un problema al modificar el usuario.");
            }
        }

        public List<RolCor> GetRoles()
        {
            return _repoRoles.GetRoles();
        }

        public async Task<RespuestaLogin> Login(LoginDatos model)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);

            if (user == null)
                throw new COExcepcion("El email no se encuentra registrado. ");

            if (await _userManager.CheckPasswordAsync(user, model.Password))
            {
                // TODO : Queda pendiente resolver la confirmación del usuario para desbloquear esta validación
               /* if (!user.EmailConfirmed)
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

                StringBuilder sbPassword = new StringBuilder();

                var hasNumber = new Regex(@"[0-9]+");
                var hasUpperChar = new Regex(@"[A-Z]+");
                var hasLowerChar = new Regex(@"[a-z]+");
                var hasSymbols = new Regex(@"[!@#$%^&*()_+=\[{\]};:<>|./?,-]");

                if (!hasLowerChar.IsMatch(model.Password))
                {
                    sbPassword.Append($@" - La contraseña debe contener al menos una letra minúscula");
                    throw new COExcepcion(sbPassword.ToString());
                }
                else if (!hasUpperChar.IsMatch(model.Password))
                {
                    sbPassword.Append($@" - La contraseña debe contener al menos una letra mayúscula");
                    throw new COExcepcion(sbPassword.ToString());
                }
                else if (!hasNumber.IsMatch(model.Password))
                {
                    sbPassword.Append($@" - La contraseña debe contener al menos un valor numérico");
                    throw new COExcepcion(sbPassword.ToString());
                }

                else if (!hasSymbols.IsMatch(model.Password))
                {
                    sbPassword.Append($@" - La contraseña debe contener al menos un carácter de caso especial");
                    throw new COExcepcion(sbPassword.ToString());
                }
                else
                {
              
                }

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
                        Numerodocumento = Convert.ToInt64(model.NumeroDocumento),
                        Creacion = DateTime.Now,
                        Codigotelefonopais = model.CodigoTelefonoPais,
                        Telefono = Convert.ToInt64(model.NumeroTelefonico),
                        Rolcorid = model.IdTipoCliente,
                        Modificacion = DateTime.Now,
                        Direccion = model.Direccion,
                        Idpoblacion = int.Parse(model.IdPoblacion),
                    };

                    await _repoDemografia.GuardarDemografia(demografia);
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
