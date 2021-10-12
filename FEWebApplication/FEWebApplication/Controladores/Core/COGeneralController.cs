using Fe.Core.General;
using Fe.Core.General.Datos;
using Fe.Core.General.Negocio;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Core
{
    /// <summary>
    /// Servicios para guardar, modificar o borrar población, documento, demografía, demografía reportada, FAQ y razón social
    /// </summary>
    [Route("core/[controller]")]
    public class COGeneralController : COApiController
    {
        private readonly COGeneralFachada _cOGeneralFachada;

        /// <summary>
        /// Controlador de general
        /// </summary>
        public COGeneralController(COGeneralFachada cOGeneralFachada)
        {
            _cOGeneralFachada = cOGeneralFachada;
        }

        /// <summary>
        /// Versión servidor
        /// </summary>
        [Route("GetVersionServer")]
        [HttpGet]
        public string GetVersionServer()
        {
            return "1.0.0";
        }

        [Route("GetEstadoPoblacion")]
        [HttpGet]
        public List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            return _cOGeneralFachada.GetEstadoPoblacion();
        }

        [Route("GetPoblacionPorIdEstado")]
        [HttpGet]
        public List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            return _cOGeneralFachada.GetPoblacionPorIdEstado(idEstado);
        }

        [Route("GetTipoDocumento")]
        [HttpGet]
        public List<TipoDocumentoCor> GetTipoDocumento()
        {
            return _cOGeneralFachada.GetTipoDocumento();
        }

        [Route("GetDemografiaPorEmail")]
        [HttpGet]
        public DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            return _cOGeneralFachada.GetDemografiaPorEmail(emailDemografia);
        }

        [Route("GetDemografiaPorId")]
        [HttpGet]
        public DemografiaCor GetDemografiaPorEmail(int idDemografia)
        {
            return _cOGeneralFachada.GetDemografiaPorId(idDemografia);
        }

        [Route("GetTipoDocumentoPorId")]
        [HttpGet]
        public TipoDocumentoCor GetTipoDocumentoPorId(int idTipoDocumento)
        {
            return _cOGeneralFachada.GetTipoDocumentoPorId(idTipoDocumento);
        }

        [Route("GetTipoDocumentoPorId")]
        [HttpPost]
        public async Task<RespuestaDatos> GetTipoDocumentoPorId([FromBody] DemografiaCor demografia)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.GuardarDemografia(demografia);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Almacena la FAQ en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción de la FAQ</returns>
        /// <param name="faq">FAQ que se desea almacenar en la base de datos</param>
        [Route("GuardarFaqCor")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarFaqCor([FromBody] FaqCor faq)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.GuardarFaqCor(faq);
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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Obtienen la FAQ asociada al ID
        /// </summary>
        /// <returns>FAQ asociada al ID</returns>
        /// <param name="idFaqCor">Id FAQ que se desea obtener</param>
        [Route("GetFaqCorPorId")]
        [HttpGet]
        public FaqCor GetFaqCorPorId(int idFaqCor)
        {
            return _cOGeneralFachada.GetFaqCorPorId(idFaqCor);
        }

        /// <summary>
        /// Obtiene todas las FAQ de la base de datos
        /// </summary>
        /// <returns>Lista de todas las FAQ de la base de datos</returns>
        [Route("GetTodasFaqCor")]
        [HttpGet]
        public List<FaqCor> GetTodasFaqCor()
        {
            return _cOGeneralFachada.GetTodasFaqCor();
        }

        /// <summary>
        /// Modifica la FAQ en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la modificación de la FAQ</returns>
        /// <param name="faq">FAQ que se desea modificar en la base de datos</param>
        [Route("ModificarFaqCor")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarFaqCor([FromBody] FaqCor faq)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.ModificarFaqCor(faq);
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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Elimina la FAQ en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la eliminación de la FAQ</returns>
        /// <param name="idFaqCor">FAQ que se desea eliminar en la base de datos</param>
        [Route("RemoverFaqCor")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverFaqCorPor(int idFaqCor)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.RemoverFaqCor(idFaqCor);
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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Almacena la demografía reportada en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción de la demografía reportada</returns>
        /// <param name="demografiaReportada">Demografía reportada que se desea almacenar en la base de datos</param>
        [Route("GuardarDemografiaReportada")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarDemografiaReportada([FromBody] DemografiaReportadaCor demografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.GuardarDemografiaReportada(demografiaReportada);
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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Obtiene la demografía reportada asociada al ID
        /// </summary>
        /// <returns>Demografía reportada asociada al Id</returns>
        /// <param name="idDemografiaReportada">Id demografía reportada que se desea obtener</param>
        [Route("GetDemografiaReportadaPorId")]
        [HttpGet]
        public DemografiaReportadaCor GetDemografiaReportadaPorId(int idDemografiaReportada)
        {
            return _cOGeneralFachada.GetDemografiaReportadaPorId(idDemografiaReportada);
        }

        /// <summary>
        /// Obtiene todas las demografías reportadas de la base de datos
        /// </summary>
        /// <returns>Lista de todas las demografías reportadas de la base de datos</returns>
        [Route("GetTodasDemografiaReportada")]
        [HttpGet]
        public List<DemografiaReportadaCor> GetTodasDemografiaReportada()
        {
            return _cOGeneralFachada.GetTodasDemografiaReportada();
        }

        /// <summary>
        /// Modifica la demografía reportada en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la modificación de la demografía reportada en la base de datos</returns>
        /// <param name="demografiaReportada">Demografía reportada que se desea modificar</param>
        [Route("ModificarDemografiaReportada")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarDemografiaReportada([FromBody] DemografiaReportadaCor demografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.ModificarDemografiaReportada(demografiaReportada);
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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Elimina la demografía reportada en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la eliminación de la demografía reportada en la base de datos</returns>
        /// <param name="idDemografiaReportada">Demografía reportada que se desea eliminar</param>
        [Route("RemoverDemografiaReportada")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverDemografiaReportada(int idDemografiaReportada)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.RemoverDemografiaReportada(idDemografiaReportada);
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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Obtiene todas las notificaciones de la base de datos
        /// </summary>
        /// <returns>Lista con todas las notificaciones de la base de datos</returns>
        [Route("GetNotificaciones")]
        [HttpGet]
        public List<NotificacionesCor> GetNotificaciones()
        {
            return _cOGeneralFachada.GetNotificaciones();
        }

        /// <summary>
        /// Obtiene todas las notificaciones asociadas a un usuario de la base de datos
        /// </summary>
        /// <returns>Lista con todas las notificaciones asociadas a un usuario de la base de datos</returns>
        /// <param name="idDemografia">Id de la demografía que se desea modificar</param>
        [Route("GetNotificacionesPorIdDemografia")]
        [HttpGet]
        public List<NotificacionesCor> GetNotificacionesPorIdDemografia(int idDemografia)
        {
            return _cOGeneralFachada.GetNotificacionesPorIdDemografia(idDemografia);
        }

        /// <summary>
        /// Obtiene una notificación asociada a un id de la base de datos
        /// </summary>
        /// <returns>Notificación asociada a un id de la base de datos</returns>
        /// <param name="idNotificacion">Id de la notificación que se desea modificar</param>
        [Route("GetNotificacionesPorIdNotificacion")]
        [HttpGet]
        public NotificacionesCor GetNotificacionPorIdNotificacion(int idNotificacion)
        {
            return _cOGeneralFachada.GetNotificacionPorIdNotificacion(idNotificacion);
        }

        /// <summary>
        /// Almacena la notificación en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción de la notificación en la base de datos</returns>
        /// <param name="notificacion">Notificación que se desea almacenar</param>
        [Route("GuardarNotificacion")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarNotificacion([FromBody] NotificacionesCor notificacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.GuardarNotificacion(notificacion);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Elimina la notificación de la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la elimicación de la notificación de la base de datos</returns>
        /// <param name="idNotificacion">Notificación que se desea eliminar</param>
        [Route("RemoverNotificacion")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverNotificacion(int idNotificacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.RemoverNotificacion(idNotificacion);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }
    }
}
