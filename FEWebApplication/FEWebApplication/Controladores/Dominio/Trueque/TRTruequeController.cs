using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Dominio.trueques;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using FEWebApplication.Controladores.Core;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Dominio.Trueque
{
    [Route("trueque/[controller]")]
    public class TRTruequeController : COApiController
    {
        private readonly TRFachada _tRFachada;
        public TRTruequeController(TRFachada tRFachada)
        {
            _tRFachada = tRFachada;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("GuardarTrueque")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarTrueque([FromBody] ProdSerTruequeTrue detalle)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _tRFachada.GuardarTruequeDetalle(detalle);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("ModificarTrueque")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarTrueque([FromBody] TruequesPedidoTrue trueque)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _tRFachada.ModificarTrueque(trueque);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GetTrueques")]
        [HttpGet]
        public List<TruequesPedidoTrue> GetTrueques()
        {
            return _tRFachada.GetTrueques();
        }

        [Route("GetTruequesPorIdComprador")]
        [HttpGet]
        public List<TruequesPedidoTrue> GetTruequesPorIdComprador(int idComprador)
        {
            return _tRFachada.GetTruequesPorIdComprador(idComprador);
        }

        [Route("GetTruequesPorIdVendedor")]
        [HttpGet]
        public List<TruequesPedidoTrue> GetTruequesPorIdVendedor(int idVendedor)
        {
            return _tRFachada.GetTruequesPorIdVendedor(idVendedor);
        }

        [Route("GetDetallePorIdTrueque")]
        [HttpGet]
        public ProdSerTruequeTrue GetDetallePorIdTrueque(int idTrueque)
        {
            return _tRFachada.GetDetallePorIdTrueque(idTrueque);
        }
    }
}
