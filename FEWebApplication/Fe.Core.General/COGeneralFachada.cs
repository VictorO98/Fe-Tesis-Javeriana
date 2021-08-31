using Fe.Core.General.Datos;
using Fe.Core.General.Negocio;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Fe.Core.General
{
    public class COGeneralFachada   
    {
        private readonly COGeneralBiz _cOGeneralBiz;

        public COGeneralFachada(COGeneralBiz coGeneralBiz)
        {
            _cOGeneralBiz = coGeneralBiz;
        }

        public DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            return _cOGeneralBiz.GetDemografiaPorId(idDemografia);
        }

        public DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            return _cOGeneralBiz.GetDemografiaPorEmail(emailDemografia);
        }

        public List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            return _cOGeneralBiz.GetEstadoPoblacion();
        }

        public List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            return _cOGeneralBiz.GetPoblacionPorIdEstado(idEstado);
        }

        public TipoDocumentoCor GetTipoDocumentoPorId(int idTipoDocumento)
        {
            return _cOGeneralBiz.GetTipoDocumentoPorId(idTipoDocumento);
        }

        public List<TipoDocumentoCor> GetTipoDocumento()
        {
            return _cOGeneralBiz.GetTipoDocumento();
        }

        public async Task<RespuestaDatos> GuardarDemografia(DemografiaCor demografia)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.GuardarDemografia(demografia);
            }
            catch(COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> GuardarFaqCor(FaqCor faq)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.GuardarFaqCor(faq);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public FaqCor GetFaqCorPorId(int idFaqCor)
        {
            return _cOGeneralBiz.GetFaqCorPorId(idFaqCor);
        }

        public List<FaqCor> GetTodasFaqCor()
        {
            return _cOGeneralBiz.GetTodasFaqCor();
        }

        public async Task<RespuestaDatos> ModificarFaqCor(FaqCor faq)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.ModificarFaqCor(faq);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> RemoverFaqCor(int idFaqCor)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.RemoverFaqCor(idFaqCor);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> GuardarDemografiaReportada(DemografiaReportadaCor demografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                DemografiaCor demografiaCor = _cOGeneralBiz.GetDemografiaPorId(demografiaReportada.Iddemografia);
                respuestaDatos = await _cOGeneralBiz.GuardarDemografiaReportada(demografiaReportada, demografiaCor);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public DemografiaReportadaCor GetDemografiaReportadaPorId(int idDemografiaReportada)
        {
            return _cOGeneralBiz.GetDemografiaReportadaPorId(idDemografiaReportada);
        }

        public List<DemografiaReportadaCor> GetTodasDemografiaReportada()
        {
            return _cOGeneralBiz.GetTodasDemografiaReportada();
        }

        public async Task<RespuestaDatos> ModificarDemografiaReportada(DemografiaReportadaCor demografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.ModificarDemografiaReportada(demografiaReportada);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> RemoverDemografiaReportada(int idDemografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.RemoverDemografiaReportada(idDemografiaReportada);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> GuardarRazonSocial(RazonSocialCor razonSocial)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.GuardarRazonSocial(razonSocial);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public RazonSocialCor GetRazonSocialPorId(int idRazonSocial)
        {
            return _cOGeneralBiz.GetRazonSocialPorId(idRazonSocial);
        }

        public List<RazonSocialCor> GetTodasRazonSocial()
        {
            return _cOGeneralBiz.GetTodasRazonSocial();
        }

        public async Task<RespuestaDatos> ModificarRazonSocial(RazonSocialCor razonSocial)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.ModificarRazonSocial(razonSocial);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> RemoverRazonSocial(int idRazonSocial)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.RemoverRazonSocial(idRazonSocial);
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw e;
            }
            return respuestaDatos;
        }

        public List<NotificacionesCor> GetNotificaciones()
        {
            return _cOGeneralBiz.GetNotificaciones();
        }
        
        public List<NotificacionesCor> GetNotificacionesPorIdDemografia(int idDemografia)
        {
            return _cOGeneralBiz.GetNotificacionesPorIdDemografia(idDemografia);
        }

        public NotificacionesCor GetNotificacionPorIdNotificacion(int idNotificacion)
        {
            return _cOGeneralBiz.GetNotificacionPorIdNotificacion(idNotificacion);
        }

        public async Task<RespuestaDatos> GuardarNotificacion(NotificacionesCor notificacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                DemografiaCor demografiaCor = GetDemografiaPorId(notificacion.Idusuario);
                respuestaDatos = respuestaDatos = await _cOGeneralBiz.GuardarNotificacion(notificacion, demografiaCor);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> RemoverNotificacion(int idNotificacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.RemoverNotificacion(idNotificacion);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
