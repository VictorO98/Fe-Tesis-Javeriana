using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido.Datos;
using System.Collections.Generic;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using System;
using Fe.Servidor.Middleware.Contratos.Dominio.Contenido;
using Fe.Dominio.pedidos.Datos;

namespace Fe.Dominio.pedidos
{
    public class PEPedidoBiz
    {
        private readonly RepoPedidosPed _repoPedidosPed;
        private readonly RepoProdSerXVendidosPed _repoProdSerXVendidosPed;

        public PEPedidoBiz(RepoPedidosPed repoPedidosPed, RepoProdSerXVendidosPed repoProdSerXVendidosPed)
        {
            _repoPedidosPed = repoPedidosPed;
            _repoProdSerXVendidosPed = repoProdSerXVendidosPed;
        }

        internal async Task<RespuestaDatos> GuardarPedido(PedidosPed pedido, DemografiaCor demografiaCor)
        {
            RespuestaDatos respuestaDatos;
            if (demografiaCor != null)
            {
                try
                {
                    respuestaDatos = await _repoPedidosPed.GuardarPedido(pedido);
                }
                catch (COExcepcion e)
                {
                    throw e;
                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return respuestaDatos;
        }

        internal PedidosPed GetPedidoPorId(int idPedido)
        {
            return _repoPedidosPed.GetPedidoPorId(idPedido);
        }

        internal async Task<RespuestaDatos> RemoverPedido(int idPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoPedidosPed.RemoverPedido(idPedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarPedido(PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoPedidosPed.ModificarPedido(pedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> GuardarProductoPedido(ProdSerXVendidosPed productoPedido, PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            if (pedido != null)
            {
                try
                {
                    respuestaDatos = await _repoProdSerXVendidosPed.GuardarProductoPedido(productoPedido);
                }
                catch (COExcepcion e)
                {
                    throw e;
                }
            }
            else { throw new COExcepcion("El pedido ingresado no existe."); }
            return respuestaDatos;
        }

        internal ProdSerXVendidosPed GetProductoPedidoPorId(int idProductoPedido)
        {
            return _repoProdSerXVendidosPed.GetProductoPedidoPorId(idProductoPedido);
        }

        internal List<ProdSerXVendidosPed> GetProductosPedidosPorIdPedido(int idPedido)
        {
            return _repoProdSerXVendidosPed.GetProductosPedidosPorIdPedido(idPedido);
        }

        internal async Task<RespuestaDatos> RemoverProductoPedido(int idProductoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProdSerXVendidosPed.RemoverProductoPedido(idProductoPedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProdSerXVendidosPed.ModificarProductoPedido(productoPedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
