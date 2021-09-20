using EpaycoSdk.Models.Bank;
using Fe.Core.General;
using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Dominio.contenido;
using Fe.Dominio.pedidos;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Dominio.Factura;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Fe.Dominio.facturas
{
    public class FAFachada
    {
        private readonly FAFacturaBiz _fAFacturaBiz;
        private readonly PEFachada _pEFachada;
        private readonly COGeneralFachada _cOGeneralFachada;
        private readonly COFachada _cOFachada;

        public FAFachada(FAFacturaBiz fAFacturaBiz, PEFachada pEFachada, COGeneralFachada cOGeneralFachada, COFachada cOFachada)
        {
            _fAFacturaBiz = fAFacturaBiz;
            _pEFachada = pEFachada;
            _cOGeneralFachada = cOGeneralFachada;
            _cOFachada = cOFachada;
        }

        public async Task<string> PagoConTC(ContratoTC contratoTC)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoTC.IdPedido);
            DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(contratoTC.IdDemografiaComprador);
            TipoDocumentoCor documentoComprador = _cOGeneralFachada.GetTipoDocumentoPorId(demografiaComprador.Tipodocumentocorid);
            List<ProductosServiciosPc> productos = new List<ProductosServiciosPc>();
            for (int i = 0; i < listaPedido.Count; i++)
            {
                ProductosServiciosPc producto = await _cOFachada.GetPublicacionPorIdPublicacion(listaPedido[i].Idproductoservico);
                productos.Add(producto);
            }
            return await _fAFacturaBiz.PagoConTC(contratoTC, listaPedido, demografiaComprador, documentoComprador, productos);
        }

        public async Task<DataPse> PagoPSE(ContratoPSE contratoPSE)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoPSE.IdPedido);
            DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(contratoPSE.IdDemografiaComprador);
            TipoDocumentoCor documentoComprador = _cOGeneralFachada.GetTipoDocumentoPorId(demografiaComprador.Tipodocumentocorid);
            List<ProductosServiciosPc> productos = new List<ProductosServiciosPc>();
            for(int i = 0; i < listaPedido.Count; i++)
            {
                ProductosServiciosPc producto = await _cOFachada.GetPublicacionPorIdPublicacion(listaPedido[i].Idproductoservico);
                productos.Add(producto);
            }
            return await _fAFacturaBiz.PagoPSE(contratoPSE, listaPedido, demografiaComprador, documentoComprador, productos);
        }

        public async Task<string> FacturacionPSE(ContratoFacturaPSE contratoFacturaPSE)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoFacturaPSE.IdPedido);
            List<ProductosServiciosPc> productos = new List<ProductosServiciosPc>();
            for (int i = 0; i < listaPedido.Count; i++)
            {
                ProductosServiciosPc producto = await _cOFachada.GetPublicacionPorIdPublicacion(listaPedido[i].Idproductoservico);
                productos.Add(producto);
            }
            return await _fAFacturaBiz.FacturacionPSE(contratoFacturaPSE.TicketId, listaPedido, productos);
        }

        public async Task<List<FacturasFac>> PedidoAFacturas(List<ProdSerXVendidosPed> listaPedido)
        {
            List<ProductosServiciosPc> productos = new List<ProductosServiciosPc>(); 

            for (int i = 0; i < listaPedido.Count; i++)
            {
                ProductosServiciosPc p = await _cOFachada.GetPublicacionPorIdPublicacion(listaPedido[i].Idproductoservico);
                productos.Add(p);
            }
            return _fAFacturaBiz.PedidoAFacturas(listaPedido, productos);
        }

        public async Task<List<ProdSerXFacturaFac>> ProductosPedidoAProductosFacturados(List<ProdSerXVendidosPed> listaPedido, List<FacturasFac> facturas)
        {
            List<ProductosServiciosPc> productos = new List<ProductosServiciosPc>();
            for (int i = 0; i < listaPedido.Count; i++)
            {
                ProductosServiciosPc producto = await _cOFachada.GetPublicacionPorIdPublicacion(listaPedido[i].Idproductoservico);
                productos.Add(producto);
            }
            return _fAFacturaBiz.ProductosPedidoAProductosFacturados(listaPedido, productos, facturas);
        }
        public async Task<List<RespuestaDatos>> Prueba(List<ProdSerXVendidosPed> listaPedido)
        {
            List<ProductosServiciosPc> productos = new List<ProductosServiciosPc>();
            for (int i = 0; i < listaPedido.Count; i++)
            {
                ProductosServiciosPc producto = await _cOFachada.GetPublicacionPorIdPublicacion(listaPedido[i].Idproductoservico);
                productos.Add(producto);
            }
            return await _fAFacturaBiz.Prueba(listaPedido, productos);
        }

        public async Task<RespuestaDatos> GuardarFactura(FacturasFac factura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                PedidosPed pedido = _pEFachada.GetPedidoPorId(factura.Idpedido);
                respuestaDatos = respuestaDatos = await _fAFacturaBiz.GuardarFactura(factura, pedido);
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

        public FacturasFac GetFacturaPorId(int idFactura)
        {
            return _fAFacturaBiz.GetFacturaPorId(idFactura);
        }

        public List<FacturasFac> GetFacturasPorIdPedido(int idPedido)
        {
            return _fAFacturaBiz.GetFacturasPorIdPedido(idPedido);
        }

        public List<FacturasFac> GetFacturasPorIdVendedor(int idVendedor)
        {
            return _fAFacturaBiz.GetFacturasPorIdVendedor(idVendedor);
        }

        public async Task<RespuestaDatos> RemoverFactura(int idFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFacturaBiz.RemoverFactura(idFactura);
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

        public async Task<RespuestaDatos> ModificarFactura(FacturasFac factura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFacturaBiz.ModificarFactura(factura);
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

        public async Task<RespuestaDatos> GuardarProductoFactura(ProdSerXFacturaFac productoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                FacturasFac factura = _fAFacturaBiz.GetFacturaPorId(productoFactura.Idfactura);
                respuestaDatos = respuestaDatos = await _fAFacturaBiz.GuardarProductoFactura(productoFactura, factura);
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

        public ProdSerXFacturaFac GetProductoFacturaPorId(int idProductoFactura)
        {
            return _fAFacturaBiz.GetProductoFacturaPorId(idProductoFactura);
        }

        public List<ProdSerXFacturaFac> GetProductosFacturaPorIdFactura(int idFactura)
        {
            return _fAFacturaBiz.GetProductosFacturaPorIdFactura(idFactura);
        }

        public async Task<RespuestaDatos> RemoverProductoFactura(int idProductoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFacturaBiz.RemoverProductoFactura(idProductoFactura);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> ModificarProductoFactura(ProdSerXFacturaFac productoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _fAFacturaBiz.ModificarProductoFactura(productoFactura);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<ContratoDetallesFactura> DetalleProductoFactura(int idProductoFactura)
        {
            ContratoDetallesFactura detalleProductoFactura = new ContratoDetallesFactura();
            ProdSerXFacturaFac productoFactura = _fAFacturaBiz.GetProductoFacturaPorId(idProductoFactura);
            System.Diagnostics.Debug.WriteLine(productoFactura);

            if (productoFactura != null)
            {
                ProductosServiciosPc producto = await _cOFachada.GetPublicacionPorIdPublicacion((int)productoFactura.Idproductoservicio);
                if (producto != null)
                {
                    detalleProductoFactura.Id = producto.Id;
                    detalleProductoFactura.Preciofacturado = productoFactura.Preciofacturado;
                    detalleProductoFactura.Cantidadfacturado = productoFactura.Cantidadfacturado;
                    detalleProductoFactura.Idproductoservicio = productoFactura.Idproductoservicio;
                }
                else { throw new COExcepcion("El producto o la factura no existen."); }
            }
            else { throw new COExcepcion("El producto solicitado no existe."); }
            return detalleProductoFactura;
        }


        public async Task<List<ContratoDetallesFactura>> ListarDetallesFactura(int idFactura)

        {
            List<ContratoDetallesFactura> detallesPedido = new List<ContratoDetallesFactura>();
            FacturasFac factura = _fAFacturaBiz.GetFacturaPorId(idFactura);
            if (factura != null)
            {
                List<ProdSerXFacturaFac> productos = _fAFacturaBiz.GetProductosFacturaPorIdFactura(factura.Id);
                for (int i = 0; i < productos.Count; i++)
                {
                    detallesPedido.Add(await DetalleProductoFactura(productos[i].Id));

                }
            }
            else { throw new COExcepcion("La factura ingresada no existe."); }
            return detallesPedido;
        }


        public async Task<ContratoFacturas> CabeceraFactura(int idFactura)

        {
            ContratoFacturas cabeceraFactura = new ContratoFacturas();
            FacturasFac factura = _fAFacturaBiz.GetFacturaPorId(idFactura);
            if (factura != null)
            {
                cabeceraFactura.Id = factura.Id;

                cabeceraFactura.Estado = factura.Estado;
                cabeceraFactura.Fechafactura = factura.Fechafactura;
                cabeceraFactura.Fechaentrega = factura.Fechaentrega;
                cabeceraFactura.Valortotalfactura = factura.Valortotalfactura;
                cabeceraFactura.Valortotalfacturaiva = factura.Valortotalfacturaiva;
                cabeceraFactura.Idvendedor = (int)factura.Idvendedor;
                cabeceraFactura.Productos = await ListarDetallesFactura(factura.Id);

            }
            else { throw new COExcepcion("La factura ingresada no existe."); }
            return cabeceraFactura;
        }

        public async Task<List<ContratoFacturas>> ListarTodasLasFacturasPorUsuario(int idUsuario)
        {
            List<ContratoFacturas> facturas = new List<ContratoFacturas>();
            DemografiaCor usuario = _cOGeneralFachada.GetDemografiaPorId(idUsuario);
            if (usuario != null)
            {
                List<FacturasFac> ps = _fAFacturaBiz.GetFacturasPorIdVendedor(usuario.Id);
                for (int i = 0; i < ps.Count; i++)
                {

                    facturas.Add(await CabeceraFactura(ps[i].Id));

                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return facturas;
        }
    }
}
