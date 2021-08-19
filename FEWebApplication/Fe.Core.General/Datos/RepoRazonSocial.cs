using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;


namespace Fe.Core.General.Datos
{
    public class RepoRazonSocial
    {
        public async Task<RespuestaDatos> GuardarRazonSocial(RazonSocialCor razonSocial)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(razonSocial);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Razón social creada exitosamente." };
            }
            catch (Exception e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw new COExcepcion("Ocurrió un problema al intentar agregar la razón social.");
            }
            return respuestaDatos;
        }

        internal RazonSocialCor GetRazonSocialPorId(int idRazonSocial)
        {
            using FeContext context = new FeContext();
            return context.RazonSocialCors.Where(rs => rs.Id == idRazonSocial).FirstOrDefault();
        }

        public List<RazonSocialCor> GetTodasRazonSocial()
        {
            using FeContext context = new FeContext();
            return context.RazonSocialCors.ToList();
        }

        internal async Task<RespuestaDatos> ModificarRazonSocial(RazonSocialCor razonSocial)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            RazonSocialCor rs = GetRazonSocialPorId(razonSocial.Id);
            if (rs != null)
            {
                try
                {
                    context.Attach(rs);
                    rs.Nombre = razonSocial.Nombre;
                    //rs.DireccionDocumento = razonSocial.DireccionDocumento;
                    rs.Telefono = razonSocial.Telefono;
                    rs.Estado = razonSocial.Estado;
                    rs.Nit = razonSocial.Nit;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "FAQ modificada exitosamente." };
                }
                catch (Exception e)
                {
                    RepoErrorLog.AddErrorLog(new ErrorLog
                    {
                        Mensaje = e.Message,
                        Traza = e.StackTrace,
                        Usuario = "no_aplica",
                        Creacion = DateTime.Now,
                        Tipoerror = COErrorLog.ENVIO_CORREO
                    });
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la razón social.");
                }
            }
            else
            {
                throw new COExcepcion("La razón social no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverRazonSocial(int idRazonSocial)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                RazonSocialCor rs = new RazonSocialCor { Id = idRazonSocial };
                context.RazonSocialCors.Attach(rs);
                context.RazonSocialCors.Remove(rs);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Razon social eliminada con éxito." };
            }
            catch (Exception e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw new COExcepcion("Ocurrió un problema al intentar eliminar la razon social");
            }
            return respuestaDatos;
        }
    }
}
