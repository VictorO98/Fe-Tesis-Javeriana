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
using Fe.Core.General.Datos;
using System;

namespace FEWebApplication.Controladores.Dominio.Pedido
{
    /// <summary>
    /// Servicios para guardar, modificar o borrar pedidos (PedidosPed)
    /// y su respectivo detalle (ProdSerXVendidosPed)
    /// </summary>
    [Route("dominio/[controller]")]
    public class PEPedidoController : COApiController
    {
        private readonly PEFachada _peFachada;

        /// <summary>
        /// Controlador de pedidos
        /// </summary>
        public PEPedidoController(PEFachada pEFachada)
        {
            _peFachada = pEFachada;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena el pedido en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción del pedido</returns>
        /// <param name="pedido">Pedido que se desea almacenar en la base de datos</param>
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
        /// Obtiene el pedido ascociado al ID
        /// </summary>
        /// <returns>Pedido asociado al ID</returns>
        /// <param name="idPedido">Id del pedido deseado</param>
        [Route("GetPedidoPorId")]
        [HttpGet]
        public PedidosPed GetPedidoPorId(int idPedido)
        {
            return _peFachada.GetPedidoPorId(idPedido);
        }

        /// <summary>
        /// Obtiene los pedidos ascociado al ID de un usuario
        /// </summary>
        /// <returns>Pedidos asociado al ID del usuario</returns>
        /// <param name="idUsuario">Id del usario del cual se desean conocer sus pedidos</param>
        [Route("GetPedidosPorIdUsuario")]
        [HttpGet]
        public List<PedidosPed> GetPedidosPorIdUsuario(int idUsuario)
        {
            return _peFachada.GetPedidosPorIdUsuario(idUsuario);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Elimina el pedido de la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la eliminación del pedido</returns>
        /// <param name="pedido">Id del pedido que se desea eliminar de la base de datos</param>
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

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Modifica el pedido en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la modificación del pedido</returns>
        /// <param name="pedido">Pedido que se desea modificar en la base de datos</param>
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
        /// Almacena el producto de un pedido en la base de datos (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción del producto de un pedido</returns>
        /// <param name="productoPedido">Producto de un pedido que se desea almacenar en la base de datos</param>
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
        /// Obtiene el producto de un pedido asociado al ID (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Producto de un pedido asociado al ID</returns>
        /// <param name="idProductoPedido">Id del producto de un pedido deseado</param>
        [Route("GetProductoPedidoPorId")]
        [HttpGet]
        public ProdSerXVendidosPed GetPrductoPedidoPorId(int idProductoPedido)
        {
            return _peFachada.GetProductoPedidoPorId(idProductoPedido);
        }

        /// <summary>
        /// Obtiene una lista con todos los productos de un pedido asociado al ID del pedido (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Lista con todos los producto de un pedido asociados al ID del pedido</returns>
        /// <param name="idPedido">Id pedido del cual se desean obtener todos sus productos</param>
        [Route("GetProductosPedidosPorIdPedido")]
        [HttpGet]
        public List<ProdSerXVendidosPed> GetProductosPedidosPorIdPedido(int idPedido)
        {
            return _peFachada.GetProductosPedidosPorIdPedido(idPedido);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Eliminar el producto de un pedido en la base de datos (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la eliminación del producto de un pedido</returns>
        /// <param name="idProductoPedido">Id producto de un pedido que se desea eliminar de la base de datos</param>
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

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Modifica el producto de un pedido en la base de datos (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la modificación del producto de un pedido</returns>
        /// <param name="productoPedido">Producto de un pedido que se desea modificar en la base de datos</param>
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
        /// Obtiene el detalle del producto de un pedido (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Contrato de detalles del producto de un pedido</returns>
        /// <param name="idProductoPedido">Producto de un pedido que se desea obtener su detalle</param>
        [Route("DetalleProductoPedido")]
        [HttpGet]
        public ContratoDetallesPedido DetalleProductoPedido(int idProductoPedido)
        {
            return _peFachada.DetalleProductoPedido(idProductoPedido);
        }

        /// <summary>
        /// Obtiene la lista de detalles de los productos de un pedido (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Lista de contratos de detalles de los productos de un pedido</returns>
        /// <param name="idPedido">IDPedido del cual se desea obtener el detalle de todos sus productos</param>
        [Route("ListarDetallesPedido")]
        [HttpGet]
        public List<ContratoDetallesPedido> ListarDetallesPedido(int idPedido)
        {
            try
            {
                return _peFachada.ListarDetallesPedido(idPedido);
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

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Obtiene el contrato de un pedido (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Contrato de un pedido con sus productos</returns>
        /// <param name="idPedido">Pedido del que se desea obtener su contrato</param>
        [Route("CabeceraPedido")]
        [HttpGet]
        public ContratoPedidos CabeceraPedido(int idPedido)
        {
            try
            {
                return _peFachada.CabeceraPedido(idPedido);
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

        /// <summary>
        /// Obtiene todos los pedidos de un usuario
        /// </summary>
        /// <returns>Lista con todos los pedidos de un usuario</returns>
        /// <param name="idUsuario">ID usuario del que se desean obtner todos sus pedidos</param>
        [Route("ListarTodosLosPedidosPorUsuario")]
        [HttpGet]
        public List<ContratoPedidos> ListarTodosLosPedidosPorUsuario(int idUsuario)
        {
            try
            {
                return _peFachada.ListarTodosLosPedidosPorUsuario(idUsuario);
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
    }
}
