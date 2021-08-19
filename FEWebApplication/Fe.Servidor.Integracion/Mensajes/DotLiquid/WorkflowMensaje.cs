using DotLiquid;
using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Servidor.Integracion.Email;
using Fe.Servidor.Middleware.Contratos.Core;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Servidor.Integracion.Mensajes.DotLiquid
{
    public class WorkflowMensaje
    {
        private readonly EmailSender _emailSender;
        private readonly IConfiguration _configuration;
        private readonly RepoTemplateMensaje _repoTemplateMensaje;

        public WorkflowMensaje(EmailSender emailSender, IConfiguration configuration, RepoTemplateMensaje repoTemplateMensaje)
        {
            _emailSender = emailSender;
            _configuration = configuration;
            _repoTemplateMensaje = repoTemplateMensaje;
        }

        /// <summary>
        /// Envia el mensaje o notificación de un nuevo registro
        /// </summary>
        /// <param name="demografiaDatos"></param>
        /// <param name="linkConfirmation"></param>
        /// <returns></returns>
        public async Task EnviarMensajeRegistro(DemografiaDatos demografiaDatos, string linkConfirmation)
        {
            try
            {
                LiquidObject liquidObject = new LiquidObject
                {
                    ClienteLiquid = new ClienteLiquid(demografiaDatos),
                    AppLiquid = GetInfoApp()
                };

                var messageTemplate = _repoTemplateMensaje.GetTemplatePorNombre(COCodigoTemplate.REGISTRO_CUENTA);

                if (messageTemplate == null)
                    throw new Exception("No se encontró el template, " + COCodigoTemplate.REGISTRO_CUENTA);

                Template template = Template.Parse(messageTemplate.Contenido);
                string templateConDatos = template.Render(Hash.FromAnonymousObject(new { Cliente = liquidObject.ClienteLiquid, linkConfirmation, App = liquidObject.AppLiquid }));

                var emailAccount = _configuration.GetSection("Email").Get<MailOptions>();

                await _emailSender.SendEmail(
                    emailAccount, GetSubjectTemplate(messageTemplate.Subject, liquidObject.AppLiquid),
                    templateConDatos, emailAccount.SenderEmail,
                    emailAccount.SenderName, demografiaDatos.Email, demografiaDatos.Nombres);

            }
            catch (Exception e)
            {
                throw new Exception("Problema en el envío del correo. " + e.Message);
            }
        }

        /// <summary>
        /// Obtiene el subject con los datos parseados
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="appLiquid"></param>
        /// <returns></returns>
        private string GetSubjectTemplate(string subject, Drop appLiquid)
        {
            Template template = Template.Parse(subject);
            return template.Render(Hash.FromAnonymousObject(new { App = appLiquid }));
        }

        /// <summary>
        /// Obtiene la información de la App
        /// </summary>
        /// <returns></returns>
        private Drop GetInfoApp()
        {
            var app = _configuration.GetSection("App").Get<AppDatos>();
            app.Descripcion = "¡Número uno en el comercio de emprendedores!";
            return new AppLiquid(app);
        }
    }
}
