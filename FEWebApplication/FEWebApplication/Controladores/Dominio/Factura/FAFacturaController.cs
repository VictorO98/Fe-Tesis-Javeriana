using EpaycoSdk;
using EpaycoSdk.Models;
using EpaycoSdk.Models.Bank;
using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Dominio.facturas;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Dominio.Factura;
using Fe.Servidor.Middleware.Modelo.Entidades;
using FEWebApplication.Controladores.Core;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Dominio.Factura
{
    /// <summary>
    /// Servicios para realizar transacciones y CRUD de Factura
    /// y su respectivo detalle
    /// </summary>
    [Route("factura/[controller]")]
    public class FAFacturaController : COApiController
    {
        private readonly FAFachada _fAFachada;

        public FAFacturaController(FAFachada fAFachada)
        {
            _fAFachada = fAFachada;
        }

        /// <summary>
        /// Se realiza un pago con tarjeta de crédito y se almacena la factura una vez que ha sido aprobada.
        /// </summary>
        /// <returns>Respuesta de datos indicando la factura.</returns>
        /// <param name="contratoTC">Información necesaria para realizar la transacción con tarjeta de crédito.</param>
        [Route("PagoConTC")]
        [HttpPost]
        public async Task<string> PagoConTC([FromBody] ContratoTC contratoTC)
        {
            string respuesta = null;
            try
            {
                respuesta = await _fAFachada.PagoConTC(contratoTC);
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine(e.InnerException);
                Console.WriteLine(e.StackTrace);
            }
            return respuesta;
        }

        /// <summary>
        /// Se realiza un pago mediante PSE y se almacena la factura una vez que ha sido aprobada.
        /// </summary>
        /// <returns>Respuesta de datos indicando la factura.</returns>
        /// <param name="contratoPSE">Información necesaria para realizar la transacción mediante PSE.</param>
        [Route("PagoPSE")]
        [HttpPost]
        public async Task<string> PagoPSE([FromBody] ContratoPSE contratoPSE)
        {
            string respuesta = "";
            try
            {
                respuesta = await _fAFachada.PagoPSE(contratoPSE);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine(e.InnerException);
                Console.WriteLine(e.StackTrace);
            }
            return respuesta;
        }
        /// <summary>
        /// Retorna las facturas de un pedido (una factura por cada vendedor) (No las almacena en BD)
        /// </summary>
        /// <returns>Lista de facturas del pedido</returns>
        /// <param name="pedido">Pedido del cual se desean obtener sus facturas</param>
        [Route("PedidoAFactura")]
        [HttpGet]
        public async Task<List<FacturasFac>> PedidoAFacturas(List<ProdSerXVendidosPed> pedido)
        {
            return await _fAFachada.PedidoAFacturas(pedido);
        }

        /// <summary>
        /// Convuerte los productos de un pedido, a los productos de una factura (no los almacena en BD)
        /// </summary>
        /// <returns>Lista de productos facturados</returns>
        /// <param name="pedido">Id de la factura deseada</param>
        [Route("ProductoPedidoAProductoFactura")]
        [HttpGet]
        public async Task<List<ProdSerXFacturaFac>> ProductoPedidoAProductoFactura(List<ProdSerXVendidosPed> pedido)
        {
            List<FacturasFac> facturas = await _fAFachada.PedidoAFacturas(pedido);
            return await _fAFachada.ProductosPedidoAProductosFacturados(pedido, facturas);
        }

        /// <summary>
        /// Función para probar el proceso de facturación definido en las funciones de pago
        /// </summary>
        /// <returns>Listado de confirmaciones de insersión en la BD</returns>
        /// <param name="pedido">Pedido que se desea facturar</param>
        [Route("Prueba")]
        [HttpPost]
        public async Task<List<RespuestaDatos>> Prueba(List<ProdSerXVendidosPed> pedido)
        {
            return await _fAFachada.Prueba(pedido);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena la factura en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción de la factura</returns>
        /// <param name="factura">Factura que se desea almacenar en la base de datos</param>
        [Route("GuardarFactura")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarFactura([FromBody] FacturasFac factura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFachada.GuardarFactura(factura);
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
        /// Obtiene la factura ascociada al ID
        /// </summary>
        /// <returns>Factura asociada al ID</returns>
        /// <param name="idFactura">Id de la factura deseada</param>
        [Route("GetFacturaPorId")]
        [HttpGet]
        public FacturasFac GetFacturaPorId(int idFactura)
        {
            return _fAFachada.GetFacturaPorId(idFactura);
        }

        /// <summary>
        /// Obtiene las facturas ascociadas al ID de un pedido
        /// </summary>
        /// <returns>Facturas asociadas al ID del pedido</returns>
        /// <param name="idPedido">Id del pedido del cual se desean conocer sus facturas</param>
        [Route("GetFacturasPorIdPedido")]
        [HttpGet]
        public List<FacturasFac> GetFacturasPorIdPedido(int idPedido)
        {
            return _fAFachada.GetFacturasPorIdPedido(idPedido);
        }

        /// <summary>
        /// Obtiene las facturas ascociadas al ID de un vendedor
        /// </summary>
        /// <returns>Facturas asociadas al ID del vendedor</returns>
        /// <param name="idVendedor">Id del vendedor del cual se desean conocer sus facturas</param>
        [Route("GetFacturasPorIdVendedor")]
        [HttpGet]
        public List<FacturasFac> GetFacturasPorIdVendedor(int idVendedor)
        {
            return _fAFachada.GetFacturasPorIdVendedor(idVendedor);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Elimina la factura de la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la eliminación de la factura</returns>
        /// <param name="idFactura">Id de la factura que se desea eliminar de la base de datos</param>
        [Route("RemoverFactura")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverFactura(int idFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFachada.RemoverFactura(idFactura);
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
        /// Modifica la factura en la base de datos
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la modificación de la factura</returns>
        /// <param name="factura">Factura que se desea modificar en la base de datos</param>
        [Route("ModificarFactura")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarFactura([FromBody] FacturasFac factura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFachada.ModificarFactura(factura);
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
        /// Almacena el producto de una factura en la base de datos (ProdSerXFacturaFac)
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción del producto de una factura</returns>
        /// <param name="productoFactura">Producto de una factura que se desea almacenar en la base de datos</param>
        [Route("GuardarProductoFactura")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarProductoFactura([FromBody] ProdSerXFacturaFac productoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFachada.GuardarProductoFactura(productoFactura);
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
        /// Obtiene el producto de una factura asociado al ID (ProdSerXFacturaFac)
        /// </summary>
        /// <returns>Producto de una factura asociado al ID</returns>
        /// <param name="idProductoFactura">Id del producto de una factura deseado</param>
        [Route("GetProductoFacturaPorId")]
        [HttpGet]
        public ProdSerXFacturaFac GetPrductoFacturaPorId(int idProductoFactura)
        {
            return _fAFachada.GetProductoFacturaPorId(idProductoFactura);
        }

        /// <summary>
        /// Obtiene una lista con todos los productos de una factura asociado al ID de la factura (ProdSerXFacturaFac)
        /// </summary>
        /// <returns>Lista con todos los producto de una factura asociados al ID de la factura</returns>
        /// <param name="idFactura">Id factura de la cual se desean obtener todos sus productos</param>
        [Route("GetProductosFacturaPorIdFactura")]
        [HttpGet]
        public List<ProdSerXFacturaFac> GetProductosFacturaPorIdFactura(int idFactura)
        {
            return _fAFachada.GetProductosFacturaPorIdFactura(idFactura);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Eliminar el producto de una factura en la base de datos (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la eliminación del producto de una factura</returns>
        /// <param name="idProductoFactura">Id producto de una factura que se desea eliminar de la base de datos</param>
        [Route("RemoverProductoFactura")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverProductoFactura(int idProductoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFachada.RemoverProductoFactura(idProductoFactura);
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
        /// Modifica el producto de una factura en la base de datos (ProdSerXVendidosPed)
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la modificación del producto de una factura</returns>
        /// <param name="productoFactura">Producto de una factura que se desea modificar en la base de datos</param>
        [Route("ModificarProductoFactura")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarProductoFactura([FromBody] ProdSerXFacturaFac productoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFachada.ModificarProductoFactura(productoFactura);
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
        /// Obtiene el detalle del producto de una factura (ProdSerXFacturasFac)
        /// </summary>
        /// <returns>Contrato de detalles del producto de una factura</returns>
        /// <param name="idProductoFactura">Producto de una factura que se desea obtener su detalle</param>
        [Route("DetalleProductoFactura")]
        [HttpGet]
        public async Task<ContratoDetallesFactura> DetalleProductoFactura(int idProductoFactura)
        {
            return await _fAFachada.DetalleProductoFactura(idProductoFactura);
        }

        /// <summary>
        /// Obtiene la lista de detalles de los productos de una factura (ProdSerXFacturasFac)
        /// </summary>
        /// <returns>Lista de contratos de detalles de los productos de una factura</returns>
        /// <param name="idFactura">IDFactura del cual se desea obtener el detalle de todos sus productos</param>
        [Route("ListarDetallesFactura")]
        [HttpGet]
        public async Task<List<ContratoDetallesFactura>> ListarDetallesFactura(int idFactura)
        {
            try
            {
                return await _fAFachada.ListarDetallesFactura(idFactura);
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
        /// Obtiene el contrato de una factura (ProdSerXFacturasFac)
        /// </summary>
        /// <returns>Contrato de una factura con sus productos</returns>
        /// <param name="idFactura">Factura del que se desea obtener su contrato</param>
        [Route("CabeceraFactura")]
        [HttpGet]
        public async Task<ContratoFacturas> CabeceraFactura(int idFactura)
        {
            try
            {
                return await _fAFachada.CabeceraFactura(idFactura);
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
        /// Obtiene todas las facturas de un usuario
        /// </summary>
        /// <returns>Lista con todas las facturas de un usuario</returns>
        /// <param name="idUsuario">ID usuario del que se desean obtner todas sus facturas</param>
        [Route("ListarTodasLasFacturasPorUsuario")]
        [HttpGet]
        public async Task<List<ContratoFacturas>> ListarTodasLasFacturasPorUsuario(int idUsuario)
        {
            try
            {
                return await _fAFachada.ListarTodasLasFacturasPorUsuario(idUsuario);
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
