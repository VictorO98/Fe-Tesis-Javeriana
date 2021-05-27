using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Identity;
using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.Seguridad.Negocio
{
    public class COSeguridadBiz
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RepoDemografia _repoDemografia;

        public COSeguridadBiz(UserManager<IdentityUser> userManager, RepoDemografia repoDemografia) 
        {
            _userManager = userManager;
            _repoDemografia = repoDemografia;
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
