using Fe.Core.General;
using Fe.Core.General.Datos;
using Fe.Core.General.Negocio;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Core
{
    [Route("core/[controller]")]
    public class COGeneralController : COApiController
    {
        private readonly COGeneralFachada _cOGeneralFachada;

        public COGeneralController(COGeneralFachada cOGeneralFachada)
        {
            _cOGeneralFachada = cOGeneralFachada;
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
    }
}
