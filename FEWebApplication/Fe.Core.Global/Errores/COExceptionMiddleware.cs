using Fe.Core.Global.Constantes;
using Fe.Servidor.Middleware.Contratos.Core;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Globalization;
using System.Net;
using System.Threading.Tasks;

namespace Fe.Core.Global.Errores
{
    public class COExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        public COExceptionMiddleware(RequestDelegate next)
        {
            _next = next;
        }
        public async Task InvokeAsync(HttpContext httpContext)
        {
            try
            {
                await _next(httpContext);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(httpContext, ex);
            }
        }
        private Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            var serializerSettings = new JsonSerializerSettings();
            serializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
            serializerSettings.Culture = new CultureInfo("es-ES");
            serializerSettings.StringEscapeHandling = StringEscapeHandling.EscapeNonAscii;
            context.Response.ContentType = "application/json";
            if (exception.GetType().Name == "UnauthorizedAccessException")
            {
                context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                return context.Response.WriteAsync(JsonConvert.SerializeObject(new RespuestaDatos
                {
                    Codigo = COCodigoRespuesta.UNAUTHORIZED,
                    Mensaje = "No tiene acceso al aplicativo. "
                }, serializerSettings));
            }



            if (exception.GetType().Name == "COExcepcion")
            {
                context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                return context.Response.WriteAsync(JsonConvert.SerializeObject(new RespuestaDatos
                {
                    Codigo = COCodigoRespuesta.ERROR,
                    Mensaje = exception.Message
                }, serializerSettings));
            }

            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            Console.WriteLine("ERROR: " + exception.Message);
            Console.WriteLine("¡------------------------------------------");
            Console.WriteLine("ERROR TRAZA: " + exception.StackTrace);
            Console.WriteLine("------------------------------------------!");
            return context.Response.WriteAsync(JsonConvert.SerializeObject(new RespuestaDatos
            {
                Codigo = COCodigoRespuesta.ERROR_SERVER,
                Mensaje = "Ocurrió un problema con el servidor."
            }, serializerSettings));

        }
    }
}
