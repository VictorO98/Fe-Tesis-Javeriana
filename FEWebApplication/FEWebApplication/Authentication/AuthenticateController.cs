using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Seguridad.Negocio;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Threading.Tasks;

namespace FEWebApplication.Authentication
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticateController : ControllerBase
    {
        private readonly COSeguridadBiz _seguridadBiz;
        private readonly IConfiguration _configuration;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        //private readonly WorkflowMensaje _workflowMensaje;

        public AuthenticateController(COSeguridadBiz seguridadBiz, IConfiguration configuration
            , UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager)
        {
            _seguridadBiz = seguridadBiz;
            _configuration = configuration;
            _userManager = userManager;
            _roleManager = roleManager;
        }

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

        [HttpGet]
        [Route("Login")]
        public async Task<RespuestaLogin> Login()
        {
            return null; 
        }

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
                /*var code = await _userManager.GenerateEmailConfirmationTokenAsync(user);
                var linkConfirmation = urlApp + Url.Action("ConfirmarCuenta", "Authenticate", new
                {
                    userId = user.Email,
                    code
                });
                Console.WriteLine($@"A1 - {linkConfirmation}");

                //Envia mensaje de registro
                await _workflowMensaje.EnviarMensajeRegistro(new DemografiaDatos
                {
                    Nombres = model.Nombres,
                    Apellidos = model.Apellidos,
                    Email = model.Email
                }, linkConfirmation);
            */
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
                    return new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = $@"Ocurrió un problema al enviar el correo de confirmación. Pongase en contacto con servicio al cliente" };
                }
                catch (Exception e1)
                {
                    return new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = $@"Ocurrió un problema al enviar el correo de confirmación. Pongase en contacto con servicio al cliente" };
                }
            }
        }
    }
}
