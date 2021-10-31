using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.General.Negocio
{
    public class COGeneralBiz
    {
        RepoDemografia _repoDemografia;
        RepoDocumento _repoDocumento;
        RepoPoblacion _repoPoblacion;
        RepoFaqCor _repoFaqCor;
        RepoDemografiaReportada _repoDemografiaReportada;
        RepoNotificacion _repoNotificacion;

        public COGeneralBiz(RepoDemografia repoDemografia, RepoDocumento repoDocumento, RepoPoblacion repoPoblacion, RepoFaqCor repoFaqCor, RepoDemografiaReportada repoDemografiaReportada, RepoNotificacion repoNotificacion)
        {
            _repoDemografia = repoDemografia;
            _repoDocumento = repoDocumento;
            _repoPoblacion = repoPoblacion;
            _repoFaqCor = repoFaqCor;
            _repoDemografiaReportada = repoDemografiaReportada;
            _repoNotificacion = repoNotificacion;
        }
        internal DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            return _repoDemografia.GetDemografiaPorId(idDemografia);
        }

        internal DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            return _repoDemografia.GetDemografiaPorEmail(emailDemografia);
        }

        internal List<BancosPermitidosCor> GetBancos()
        {
            return _repoPoblacion.GetBancos();
        }

        internal TipoDocumentoCor GetTipoDocumentoPorId(int idTipoDocumento)
        {
            return _repoDocumento.GetTipoDocumentoPorId(idTipoDocumento);
        }

        internal List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            return _repoPoblacion.GetPoblacionPorIdEstado(idEstado);
        }

        internal List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            return _repoPoblacion.GetEstadoPoblacion();
        }

        internal List<TipoDocumentoCor> GetTipoDocumento()
        {
            return _repoDocumento.GetTipoDocumento();
        }

        internal async Task<RespuestaDatos> GuardarDemografia(DemografiaCor demografia)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoDemografia.GuardarDemografia(demografia);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> GuardarFaqCor(FaqCor faq)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoFaqCor.GuardarFaqCor(faq);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal FaqCor GetFaqCorPorId(int idFaqCor)
        {
            return _repoFaqCor.GetFaqCorPorId(idFaqCor);
        }

        internal List<FaqCor> GetTodasFaqCor()
        {
            return _repoFaqCor.GetTodasFaqCor();
        }

        internal async Task<RespuestaDatos> ModificarFaqCor(FaqCor faq)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoFaqCor.ModificarFaqCor(faq);
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

        internal async Task<RespuestaDatos> RemoverFaqCor(int idFaqCor)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoFaqCor.RemoverFaqCor(idFaqCor);
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

        internal async Task<RespuestaDatos> GuardarDemografiaReportada(DemografiaReportadaCor demografiaReportada, DemografiaCor demografiaCor)
        {
            RespuestaDatos respuestaDatos;
            if (demografiaCor != null)
            {
                if (GetDemografiaPorId(demografiaCor.Id) != null)
                {
                    try
                    {
                        respuestaDatos = await _repoDemografiaReportada.GuardarDemografiaReportada(demografiaReportada);
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
                }
                else { throw new COExcepcion("La demogradía que desea reportar no existe."); }
            }
            else { throw new COExcepcion("La demografía no existe."); }
            return respuestaDatos;
        }

        internal DemografiaReportadaCor GetDemografiaReportadaPorId(int idDemografiaReportada)
        {
            return _repoDemografiaReportada.GetDemografiaReportadaPorId(idDemografiaReportada);
        }

        internal List<DemografiaReportadaCor> GetTodasDemografiaReportada()
        {
            return _repoDemografiaReportada.GetTodasDemografiaReportada();
        }

        internal async Task<RespuestaDatos> ModificarDemografiaReportada(DemografiaReportadaCor demografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoDemografiaReportada.ModificarDemografiaReportada(demografiaReportada);
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

        internal async Task<RespuestaDatos> RemoverDemografiaReportada(int idDemografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoDemografiaReportada.RemoverDemografiaReportada(idDemografiaReportada);
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

        internal List<NotificacionesCor> GetNotificaciones()
        {
            return _repoNotificacion.GetNotificaciones();
        }

        internal List<NotificacionesCor> GetNotificacionesPorIdDemografia(int idDemografia)
        {
            return _repoNotificacion.GetNotificacionesPorIdDemografia(idDemografia);
        }

        internal NotificacionesCor GetNotificacionPorIdNotificacion(int idNotificacion)
        {
            return _repoNotificacion.GetNotificacionPorIdNotificacion(idNotificacion);
        }

        internal async Task<RespuestaDatos> GuardarNotificacion(NotificacionesCor notificacion, DemografiaCor demografia)
        {
            RespuestaDatos respuestaDatos;
            if (demografia != null)
            {
                try
                {
                    respuestaDatos = await _repoNotificacion.GuardarNotificacion(notificacion);
                }
                catch (COExcepcion e)
                {
                    throw e;
                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverNotificacion(int idNotificacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoNotificacion.RemoverNotificacion(idNotificacion);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
