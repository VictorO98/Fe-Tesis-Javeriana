using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.General.Datos
{
    public class RepoNotificacion
    {
        public List<NotificacionesCor> GetNotificaciones()
        {
            using FeContext feContext = new FeContext();
            return feContext.NotificacionesCors.ToList();
        }

        public NotificacionesCor GetNotificacionPorIdNotificacion(int idNotificacion)
        {
            using FeContext context = new FeContext();
            return context.NotificacionesCors.SingleOrDefault(n => n.Id == idNotificacion);
        }

        public List<NotificacionesCor> GetNotificacionesPorIdDemografia(int idDemografia)
        {
            using FeContext context = new FeContext();
            return context.NotificacionesCors.Where(n => n.Idusuario == idDemografia && n.Estado == COEstados.VIGENTE).ToList();
        }

        public async Task<RespuestaDatos> GuardarNotificacion(NotificacionesCor notificacion)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                notificacion.Creacion = DateTime.Now;
                notificacion.Estado = COEstados.VIGENTE;
                context.Add(notificacion);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Notificación creada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar la notificacion.");
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> RemoverNotificacion(int idNotificacion)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            NotificacionesCor notificacion = GetNotificacionPorIdNotificacion(idNotificacion);
            if (notificacion != null)
            {
                try
                {
                    context.Attach(notificacion);
                    notificacion.Estado = COEstados.INACTIVO;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Notificación eliminada exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar eliminar la notificación.");
                }
            }
            else
            {
                throw new COExcepcion("La notificación no existe");
            }
            return respuestaDatos;
        }
    }
}
