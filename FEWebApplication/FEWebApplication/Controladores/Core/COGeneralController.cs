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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GetFaqCorPorId")]
        [HttpGet]
        public FaqCor GetFaqCorPorId(int idFaqCor)
        {
            return _cOGeneralFachada.GetFaqCorPorId(idFaqCor);
        }

        [Route("GetTodasFaqCor")]
        [HttpGet]
        public List<FaqCor> GetTodasFaqCor()
        {
            return _cOGeneralFachada.GetTodasFaqCor();
        }

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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GetDemografiaReportadaPorId")]
        [HttpGet]
        public DemografiaReportadaCor GetDemografiaReportadaPorId(int idDemografiaReportada)
        {
            return _cOGeneralFachada.GetDemografiaReportadaPorId(idDemografiaReportada);
        }

        [Route("GetTodasDemografiaReportada")]
        [HttpGet]
        public List<DemografiaReportadaCor> GetTodasDemografiaReportada()
        {
            return _cOGeneralFachada.GetTodasDemografiaReportada();
        }

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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

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
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GuardarRazonSocial")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarRazonSocial([FromBody] RazonSocialCor razonSocial)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.GuardarRazonSocial(razonSocial);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GetRazonSocialPorId")]
        [HttpGet]
        public RazonSocialCor GetRazonSocialPorId(int idRazonSocial)
        {
            return _cOGeneralFachada.GetRazonSocialPorId(idRazonSocial);
        }

        [Route("GetTodasRazonSocial")]
        [HttpGet]
        public List<RazonSocialCor> GetTodasRazonSocial()
        {
            return _cOGeneralFachada.GetTodasRazonSocial();
        }

        [Route("ModificarRazonSocial")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarRazonSocial([FromBody] RazonSocialCor razonSocial)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.ModificarRazonSocial(razonSocial);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("RemoverRazonSocial")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverRazonSocial(int idRazonSocial)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralFachada.RemoverRazonSocial(idRazonSocial);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }
    }
}
