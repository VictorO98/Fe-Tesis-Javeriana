using Fe.Core.General;
using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Core.Seguridad;
using Fe.Core.Seguridad.Negocio;
using Fe.Servidor.Integracion.Mensajes.DotLiquid;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace FEWebApplication.Authentication
{
    /// <summary>
    /// Servicios para iniciar sesión y registrarse
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticateController : ControllerBase
    {
        private readonly COSeguridadBiz _seguridadBiz;
        private readonly SEFachada _sEFachada;
        private readonly IConfiguration _configuration;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly WorkflowMensaje _workflowMensaje;

        public AuthenticateController(COSeguridadBiz seguridadBiz, IConfiguration configuration, SEFachada sEFachada
            , UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager, WorkflowMensaje workflowMensaje)
        {
            _seguridadBiz = seguridadBiz;
            _sEFachada = sEFachada;
            _configuration = configuration;
            _userManager = userManager;
            _roleManager = roleManager;
            _workflowMensaje = workflowMensaje;
        }

        /// <summary>
        /// Crea los roles en identity Role !NO EJECUTAR!
        /// </summary>
        [HttpGet]
        [Route("CreateRole")]
        public async Task CreateRole()
        {
            if (ModelState.IsValid)
            {
                bool x = await _roleManager.RoleExistsAsync("Administrador");
                if (!x)
                {
                    var role = new IdentityRole();
                    role.Name = "Administrador";
                    await _roleManager.CreateAsync(role);
                }

                x = await _roleManager.RoleExistsAsync("Emprendedor");
                if (!x)
                {
                    var role = new IdentityRole();
                    role.Name = "Emprendedor";
                    await _roleManager.CreateAsync(role);
                }

                x = await _roleManager.RoleExistsAsync("Usuario");
                if (!x)
                {
                    var role = new IdentityRole();
                    role.Name = "Usuario";
                    await _roleManager.CreateAsync(role);
                }
            }

            
        }

        /// <summary>
        /// Retorna todos los roles de la base de datos.
        /// </summary>
        /// <returns>Una lista en formato JSON con todos los roles disponibles en la app.</returns>
        [HttpGet]
        [Route("GetRoles")]       
        public List<RolCor> GetRoles()
        {
            return _seguridadBiz.GetRoles();
        }

        /// <summary>
        /// Método para loguearse en la aplicación
        /// </summary>
        /// <returns>Retorna un JWT o un accesso denegado.</returns>
        [HttpPost]
        [Route("Login")]
        public async Task<RespuestaLogin> Login([FromBody] LoginDatos model)
        {
            return await _seguridadBiz.Login(model);
        }

        /// <summary>
        /// Método para subir documentos de los emprendedores
        /// </summary>
        /// <returns>Respuesta datos. </returns>
        [HttpPost]
        [Route("SubirDocumentosEmprendedor")]
        public async Task<RespuestaDatos> SubirDocumentosEmprendedor(IFormCollection collection)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                var formData = Request.Form;
                var files = Request.Form.Files;
                Claim claimId = User.Claims.Where(c => c.Type == "id").FirstOrDefault();
                formData = Request.Form;
                if (files.Count == 0)
                    throw new COExcepcion("No se adjuntaron archivos. ");

                if (formData == null)
                    throw new COExcepcion("El formulario de la petición enviada se encuentra vacío. ");

                var correoUsuario = Request.Form["Correo"].ToString();
                var razonSocial = Request.Form["RazonSocial"].ToString();

                respuestaDatos = await _sEFachada.SubirDocumentosEmprendedor(correoUsuario, razonSocial, files);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [HttpPost]
        [Route("SubirImagenSocial")]
        public async Task<RespuestaDatos> SubirImagenSocial(IFormCollection collection)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                var formData = Request.Form;
                var files = Request.Form.Files;
                Claim claimId = User.Claims.Where(c => c.Type == "id").FirstOrDefault();
                formData = Request.Form;
                if (files.Count == 0)
                    throw new COExcepcion("No se adjuntaron archivos. ");

                if (formData == null)
                    throw new COExcepcion("El formulario de la petición enviada se encuentra vacío. ");

                var correoUsuario = Request.Form["Correo"].ToString();

                respuestaDatos = await _sEFachada.SubirImagenSocial(correoUsuario, files);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Método para registrarse en la aplicación
        /// </summary>
        //TODO: Implementar el envio de correos para los usuarios que se registran.
        [HttpPost]
        [Route("Register")]
        public async Task<RespuestaDatos> Register([FromBody] RegisterDatos model)
        {
            // Registra el usuario en el aplicativo
            ApplicationUser user = await _seguridadBiz.RegistrarUsuario(model);

            try
            {
                var urlApp = _configuration["App:Url"];
                //Generar token de confirmación
                var code = await _userManager.GenerateEmailConfirmationTokenAsync(user);
                var linkConfirmation = urlApp + $@"/ConfirmarCuenta/{user.Email}/{code}";

                Console.WriteLine($@"A1 - {linkConfirmation}");


                //Envia mensaje de registro
                await _workflowMensaje.EnviarMensajeRegistro(new DemografiaDatos
                {
                    Nombres = model.Nombres,
                    Apellidos = model.Apellidos,
                    Email = model.Email
                }, linkConfirmation);

                return new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = $@"Hemos enviado a su correo electrónico un enlace de confirmación, por favor revise su bandeja de entrada y siga las instrucciones para activar su cuenta en {_configuration["App:Nombre"]}." };
            
            }
            catch (Exception e)
            {
                try
                {
                    RepoErrorLog.AddErrorLog(new ErrorLog
                    {
                        Mensaje = e.Message,
                        Traza = e.StackTrace,
                        Usuario = user.Email,
                        Creacion = DateTime.Now,
                        Tipoerror = COErrorLog.ENVIO_CORREO
                    });
                    return new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = $@"Se completo el registro!! Ocurrió un problema al enviar el correo de confirmación. Pongase en contacto con servicio al cliente" };
                }
                catch (Exception e1)
                {
                    return new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = $@"Se completo el registro!! Ocurrió un problema al enviar el correo de confirmación. Pongase en contacto con servicio al cliente" };
                }
            }
        }

        /// <summary>
        /// Método para modificar la demografia
        /// </summary>
        [HttpPut]
        [Route("ModificarDemografia")]
        public async Task<RespuestaDatos> ModificarDemografia([FromBody] ModificarDemografia model)
        {
            // TODO: Cambiar en la tabla identity el número
            try
            {
                return await _sEFachada.ModificarDemografia(model);
            }
            catch (Exception e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = model.Correo,
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.MODIFICAR_USUARIO
                });
                return new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = $@" Ocurrió un problema al modificar el usuario" };
            }
        }
    }
}
