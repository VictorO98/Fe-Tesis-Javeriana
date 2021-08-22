using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Collections.Generic;
using System.Linq;
using System;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Core.Global.Constantes;
using Fe.Core.General;
using Fe.Servidor.Middleware.Contratos.Dominio.Contenido;
using Fe.Servidor.Middleware.Contratos.Dominio.Pedidos;
using Fe.Dominio.contenido;
using Fe.Core.General.Datos;

namespace Fe.Dominio.pedidos
{
    public class PEFachada
    {
        private readonly PEPedidoBiz _pEPedidoBiz;
        private readonly COGeneralFachada _cOGeneralFachada;
        private readonly COFachada _cOContenidoFachada;

        public PEFachada(PEPedidoBiz cOContenidobiz, COGeneralFachada cOGeneralFachada, COFachada cOFachada)
        {
            _pEPedidoBiz = cOContenidobiz;
            _cOGeneralFachada = cOGeneralFachada;
            _cOContenidoFachada = cOFachada;
        }

        public async Task<RespuestaDatos> GuardarPedido(PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorId(pedido.Idusuario);
                respuestaDatos = respuestaDatos = await _pEPedidoBiz.GuardarPedido(pedido, demografiaCor);
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

        public PedidosPed GetPedidoPorId(int idPedido)
        {
            return _pEPedidoBiz.GetPedidoPorId(idPedido);
        }

        public List<PedidosPed> GetPedidosPorIdUsuario(int idUsuario)
        {
            return _pEPedidoBiz.GetPedidosPorIdUsuario(idUsuario);
        }

        public async Task<RespuestaDatos> RemoverPedido(int idPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _pEPedidoBiz.RemoverPedido(idPedido);
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

        public async Task<RespuestaDatos> ModificarPedido(PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _pEPedidoBiz.ModificarPedido(pedido);
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

        public async Task<RespuestaDatos> GuardarProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            RespuestaDatos respuestaDatos;
            ProductosServiciosPc producto = await _cOContenidoFachada.GetPublicacionPorIdPublicacion(productoPedido.Idproductoservico);
            System.Diagnostics.Debug.WriteLine("Este es el ID:");
            System.Diagnostics.Debug.WriteLine(productoPedido.Idproductoservico);
            if (producto != null)
            {
                if (await ValidarPrecioProductoPedido(productoPedido))
                {
                    TipoPublicacionPc tipoProductoPedido = _cOContenidoFachada.GetTipoPublicacionPorID(producto.Idtipopublicacion);
                    if (tipoProductoPedido != null)
                    {
                        System.Diagnostics.Debug.WriteLine("Este es el tipo:");
                        System.Diagnostics.Debug.WriteLine(tipoProductoPedido.Nombre);
                        if (tipoProductoPedido.Id == 2)
                        {
                            try
                            {
                                PedidosPed pedido = _pEPedidoBiz.GetPedidoPorId(productoPedido.Idpedido);
                                respuestaDatos = respuestaDatos = await _pEPedidoBiz.GuardarProductoPedido(productoPedido, pedido);
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
                        else
                        {
                            if (await ValidarCantidadProductoPedido(productoPedido))
                            {
                                try
                                {
                                    PedidosPed pedido = _pEPedidoBiz.GetPedidoPorId(productoPedido.Idpedido);
                                    respuestaDatos = respuestaDatos = await _pEPedidoBiz.GuardarProductoPedido(productoPedido, pedido);
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
                            else { throw new COExcepcion("No hay suficiente cantidad del producto deseado"); }
                        }
                    }
                    else { throw new COExcepcion("Hay un inconveniente con el tipo del producto"); }
                }
                else { throw new COExcepcion("Hay un inconveniente con el precio total del producto pedido"); }
            }
            else { throw new COExcepcion("El producto deseado no existe"); }
            return respuestaDatos;
        }

        public ProdSerXVendidosPed GetProductoPedidoPorId(int idProductoPedido)
        {
            return _pEPedidoBiz.GetProductoPedidoPorId(idProductoPedido);
        }

        public List<ProdSerXVendidosPed> GetProductosPedidosPorIdPedido(int idPedido)
        {
            return _pEPedidoBiz.GetProductosPedidosPorIdPedido(idPedido);
        }

        public async Task<RespuestaDatos> RemoverProductoPedido(int idProductoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _pEPedidoBiz.RemoverProductoPedido(idProductoPedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> ModificarProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _pEPedidoBiz.ModificarProductoPedido(productoPedido);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<Boolean> ValidarCantidadProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            ProductosServiciosPc producto = await _cOContenidoFachada.GetPublicacionPorIdPublicacion(productoPedido.Idproductoservico);
            bool validacion = false;
            if (producto != null)
            {
                if (producto.Cantidadtotal >= productoPedido.Cantidadespedida)
                {
                    validacion = true;
                }
            }
            else { throw new COExcepcion("El producto no existe"); }
            return validacion;
        }

        public async Task<Boolean> ValidarPrecioProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            ProductosServiciosPc producto = new ProductosServiciosPc();
            //System.Diagnostics.Debug.WriteLine(productoPedido.Idproductoservico);
            producto = await _cOContenidoFachada.GetPublicacionPorIdPublicacion(productoPedido.Idproductoservico);
            //System.Diagnostics.Debug.WriteLine(producto);
            bool validacion = false;
            if (producto != null)
            {
                bool check1 = unchecked(producto.Preciounitario == (int)producto.Preciounitario);
                bool check2 = unchecked(productoPedido.Preciototal == (int)productoPedido.Preciototal);
                if (check1 && check2)
                {
                    System.Diagnostics.Debug.WriteLine("Si entró");
                    System.Diagnostics.Debug.WriteLine(productoPedido.Preciototal);
                    System.Diagnostics.Debug.WriteLine(producto.Preciounitario);
                    System.Diagnostics.Debug.WriteLine(productoPedido.Cantidadespedida);
                    if (productoPedido.Preciototal == producto.Preciounitario * productoPedido.Cantidadespedida)
                    {
                        System.Diagnostics.Debug.WriteLine("Si entró al otro");
                        validacion = true;
                    }
                }
            }
            else { throw new COExcepcion("El producto solicitado no existe."); }

            return validacion;
        }


        public async Task<ContratoDetallesPedido> DetalleProductoPedido(int idProductoPedido)
        {
            ContratoDetallesPedido detalleProductoPedido = new ContratoDetallesPedido();
            ProdSerXVendidosPed productoPedido = _pEPedidoBiz.GetProductoPedidoPorId(idProductoPedido);
            System.Diagnostics.Debug.WriteLine(productoPedido);

            if (productoPedido != null)
            {
                ProductosServiciosPc producto = await _cOContenidoFachada.GetPublicacionPorIdPublicacion(productoPedido.Idproductoservico);
                if (producto != null)
                {
                    detalleProductoPedido.Id = producto.Id;
                    detalleProductoPedido.Precio = producto.Preciounitario;
                    detalleProductoPedido.Cantidad = productoPedido.Cantidadespedida;
                    detalleProductoPedido.Fecha = productoPedido.Creacion;
                }
                else { throw new COExcepcion("El producto no existe."); }
            }
            else { throw new COExcepcion("El producto solicitado no existe."); }
            return detalleProductoPedido;
        }


        public async Task<List<ContratoDetallesPedido>> ListarDetallesPedido(int idPedido)

        {
            List<ContratoDetallesPedido> detallesPedido = new List<ContratoDetallesPedido>();
            PedidosPed pedido = _pEPedidoBiz.GetPedidoPorId(idPedido);
            if (pedido != null)
            {
                List<ProdSerXVendidosPed> productos = _pEPedidoBiz.GetProductosPedidosPorIdPedido(pedido.Id);
                for (int i = 0; i < productos.Count; i++)
                {
                    detallesPedido.Add(await DetalleProductoPedido(productos[i].Id));

                }
            }
            else { throw new COExcepcion("El pedido ingresado no existe."); }
            return detallesPedido;
        }


        public async Task<ContratoPedidos> CabeceraPedido(int idPedido)

        {
            ContratoPedidos cabeceraPedido = new ContratoPedidos();
            PedidosPed pedido = _pEPedidoBiz.GetPedidoPorId(idPedido);
            if (pedido != null)
            {
                cabeceraPedido.Id = pedido.Idusuario;

                cabeceraPedido.Estado = pedido.Estado;
                cabeceraPedido.Fechapedido = pedido.Fechapedido;
                cabeceraPedido.Productos = await ListarDetallesPedido(pedido.Id);

            }
            else { throw new COExcepcion("El pedido ingresado no existe."); }
            return cabeceraPedido;
        }

        public async Task<List<ContratoPedidos>> ListarTodosLosPedidosPorUsuario(int idUsuario)
        {
            List<ContratoPedidos> pedidos = new List<ContratoPedidos>();
            DemografiaCor usuario = _cOGeneralFachada.GetDemografiaPorId(idUsuario);
            if(usuario != null)
            {
                List<PedidosPed> ps = _pEPedidoBiz.GetPedidosPorIdUsuario(usuario.Id);
                for (int i = 0; i < ps.Count; i++)
                {

                    pedidos.Add(await CabeceraPedido (ps[i].Id));

                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return pedidos;
        }
    }
}
