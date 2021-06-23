using Fe.Dominio.contenido;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using FEWebApplication.Controladores.Core;
using Fe.Servidor.Middleware.Contratos.Core;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Dominio.Pedidos;
using Fe.Dominio.pedidos;

namespace FEWebApplication.Controladores.Dominio.Pedido
{
    [Route("dominio/[controller]")]
    public class PEPedidoController : COApiController
    {
        private readonly PEFachada _peFachada;

        public PEPedidoController(PEFachada pEFachada)
        {
            _peFachada = pEFachada;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("GuardarPedido")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarPedido([FromBody] PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _peFachada.GuardarPedido(pedido);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GetPedidoPorId")]
        [HttpGet]
        public PedidosPed GetPedidoPorId(int idPedido)
        {
            return _peFachada.GetPedidoPorId(idPedido);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("RemoverPedido")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverPedido(int idPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _peFachada.RemoverPedido(idPedido);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("ModificarPedido")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarPedido([FromBody] PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _peFachada.ModificarPedido(pedido);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GuardarProductoPedido")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarProductoPedido([FromBody] ProdSerXVendidosPed productoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _peFachada.GuardarProductoPedido(productoPedido);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("GetProductoPedidoPorId")]
        [HttpGet]
        public ProdSerXVendidosPed GetPrductoPedidoPorId(int idProductoPedido)
        {
            return _peFachada.GetProductoPedidoPorId(idProductoPedido);
        }

        [Route("GetProductosPedidosPorIdPedido")]
        [HttpGet]
        public List<ProdSerXVendidosPed> GetProductosPedidosPorIdPedido(int idPedido)
        {
            return _peFachada.GetProductosPedidosPorIdPedido(idPedido);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("RemoverProductoPedido")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverProductoPedido(int idProductoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _peFachada.RemoverProductoPedido(idProductoPedido);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("ModificarProductoPedido")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarProductoPedido([FromBody] ProdSerXVendidosPed productoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _peFachada.ModificarProductoPedido(productoPedido);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("DetalleProductoPedido")]
        [HttpGet]
        public ContratoDetallesPedido DetalleProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            return _peFachada.DetalleProductoPedido(productoPedido);
        }

        [Route("ListarDetallesPedido")]
        [HttpGet]
        public List<ContratoDetallesPedido> ListarDetallesPedido(PedidosPed pedido)
        {
            try
            {
                return _peFachada.ListarDetallesPedido(pedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        [Route("CabeceraPedido")]
        [HttpGet]
        public ContratoPedidos Cabecera([FromBody] PedidosPed pedido)
        {
            try
            {
                return _peFachada.CabeceraPedido(pedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
        }

    }
}
