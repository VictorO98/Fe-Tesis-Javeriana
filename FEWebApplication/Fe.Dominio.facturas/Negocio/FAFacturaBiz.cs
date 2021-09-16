using EpaycoSdk;
using EpaycoSdk.Models;
using EpaycoSdk.Models.Bank;
using EpaycoSdk.Models.Charge;
using Fe.Core.Global.Constantes;
using Fe.Servidor.Middleware.Contratos.Dominio.Factura;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.facturas.Datos;
using Fe.Dominio.facturas;
using Fe.Core.General.Datos;
using System;
using System.Collections.Generic;
using Fe.Dominio.contenido.Datos;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Dominio.Contenido;
using Fe.Dominio.pedidos.Datos;
using System.Linq;

namespace Fe.Dominio.facturas
{
    public class FAFacturaBiz
    {
        private readonly RepoFacturasFac _repoFacturasFac;
        private readonly RepoProdSerXFacturaFac _repoProdSerXFacturaFac;

        public FAFacturaBiz(RepoFacturasFac repoFacturasFac, RepoProdSerXFacturaFac repoProdSerXFacturaFac)
        {
            _repoFacturasFac = repoFacturasFac;
            _repoProdSerXFacturaFac = repoProdSerXFacturaFac;
        }

        // TODO: Cambiar llave publica y privada a los de la fundacion
        readonly Epayco epayco = new Epayco(
          "c7e7b10c02ddb910e5a58db9f46f7217", //public_key
          "158873dad66300d10b9a2f5240866b8a", //private_key
          "ES", //language
          true //test 
        );

        public async Task<string> PagoConTC(ContratoTC contratoTC, 
            List<ProdSerXVendidosPed> listaPedido, 
            DemografiaCor demografiaComprador,
            TipoDocumentoCor documentoComprador,
            List<ProductosServiciosPc> productos)
        {
            int? total = 0;
            foreach(ProdSerXVendidosPed p in listaPedido) {
                total += p.Preciototal;
            }
            TokenModel token = epayco.CreateToken(
              contratoTC.NumeroTC, //cardNumber
              contratoTC.AnioTC.ToString(), //expYear
              contratoTC.MesTC.ToString(), //expMonth
              contratoTC.CvcTC.ToString() //cvc
            );

            CustomerCreateModel customer = epayco.CustomerCreate(
              token.id, //string
              demografiaComprador.Nombre, //string
              demografiaComprador.Apellido, //string
              demografiaComprador.Email, //string 
              true //boolean
            );

            ChargeModel response = epayco.ChargeCreate(
                token.id,
                customer.data.customerId,
                documentoComprador.Codigo,
                demografiaComprador.Numerodocumento.ToString(),
                demografiaComprador.Nombre,
                demografiaComprador.Apellido,
                demografiaComprador.Email,
                contratoTC.IdPedido.ToString(),
                "Pedido numero " + contratoTC.IdPedido.ToString(),
                total.ToString(),
                "0", // tax
                "0", // tax base
                "COP",
                contratoTC.Cuotas.ToString(),
                demografiaComprador.Direccion,
                demografiaComprador.Telefono.ToString(),
                demografiaComprador.Telefono.ToString(),
                "url_response",
                "url_confirmation",
                // TODO: Obtener IP
                "ip"
            );

            List<FacturasFac> facturasGuargadas = new List<FacturasFac>();
            // TODO: Si el response.estado == Aceptado, realizar la facturación, si es false, realizar su debido proceso.
            if (response.data.estado == "Aceptado")
            {
                List<FacturasFac> facturas = PedidoAFacturas(listaPedido, productos);
                foreach (FacturasFac f in facturas)
                {
                    _ = await _repoFacturasFac.GuardarFactura(f);
                    facturasGuargadas.Add(f);
                }
                List<ProdSerXFacturaFac> productosFacturas = ProductosPedidoAProductosFacturados(listaPedido, productos, facturasGuargadas);
                foreach (ProdSerXFacturaFac pf in productosFacturas)
                {
                    _ = await _repoProdSerXFacturaFac.GuardarProductoFactura(pf);
                }
            }
            return response.data.estado;
        }

        public async Task<string> PagoPSE(ContratoPSE contratoPSE,
            List<ProdSerXVendidosPed> listaPedido,
            DemografiaCor demografiaComprador,
            TipoDocumentoCor documentoComprador,
            List<ProductosServiciosPc> productos)
        {

            int? total = 0;
            foreach (ProdSerXVendidosPed p in listaPedido)
            {
                total += p.Preciototal;
            }

            PseModel response = epayco.BankCreate(
              COEpayco.CODIGO_BANCARIO[contratoPSE.Banco],
              contratoPSE.Bill.ToString(), // ID de factura
              "Pedido numero" + contratoPSE.IdPedido.ToString(),
              total.ToString(),
              "0",
              "0",
              "COP",
              "0", // 0 para persona, 1 para comercio
              documentoComprador.Codigo,
              demografiaComprador.Numerodocumento.ToString(),
              demografiaComprador.Nombre,
              demografiaComprador.Apellido,
              demografiaComprador.Email,
              "CO",
              demografiaComprador.Telefono.ToString(),
              "url_response",
              "url_confirmation",
              "method_confirmation"
            );

            // TODO: Si el response.success == True, realizar la facturación, si es false, realizar su debido proceso.
            // TODO: response.data.urlbanco contiene un link que tiene que recibir el front end y entregar al cliente para
            // TODO: finalizar la transacción en la página de PSE.
            List<FacturasFac> facturasGuargadas = new List<FacturasFac>();
             
            if(response.success)
            {
                List<FacturasFac> facturas = PedidoAFacturas(listaPedido, productos);
                foreach(FacturasFac f in facturas)
                {
                    _ = await _repoFacturasFac.GuardarFactura(f);
                    facturasGuargadas.Add(f);
                }
                List<ProdSerXFacturaFac> productosFacturas = ProductosPedidoAProductosFacturados(listaPedido, productos, facturasGuargadas);
                foreach (ProdSerXFacturaFac pf in productosFacturas)
                {
                    _ = await _repoProdSerXFacturaFac.GuardarProductoFactura(pf);
                }
                return response.data.urlbanco;
            }
            return "";
        }

        internal async Task<List<RespuestaDatos>> Prueba(List<ProdSerXVendidosPed> pedido, List<ProductosServiciosPc> productos)
        {
            List<RespuestaDatos> r = new List<RespuestaDatos>();
            List<FacturasFac> facturasGuargadas = new List<FacturasFac>();
            List<FacturasFac> facturas = PedidoAFacturas(pedido, productos);
            foreach (FacturasFac f in facturas)
            {
                r.Add(await _repoFacturasFac.GuardarFactura(f));
                facturasGuargadas.Add(f);
            }
            List<ProdSerXFacturaFac> productosFacturas = ProductosPedidoAProductosFacturados(pedido, productos, facturasGuargadas);
            foreach (ProdSerXFacturaFac pf in productosFacturas)
            {
                r.Add(await _repoProdSerXFacturaFac.GuardarProductoFactura(pf));
            }
            return r;
        }

        internal FacturasFac PedidoAFactura(List<ProdSerXVendidosPed> pedido, int idVendedor, DateTime entrega)
        {
            FacturasFac factura = new FacturasFac();

            if(pedido != null && idVendedor != -1 && entrega != null)
            {
                int? total = 0;
                foreach (ProdSerXVendidosPed p in pedido)
                {
                    total += p.Preciototal;
                }

                factura.Id = 0;
                factura.Idpedido = pedido[0].Idpedido;
                factura.Fechafactura = DateTime.Now;
                factura.Fechaentrega = entrega;
                factura.Valortotalfactura = total;
                factura.Valortotalfacturaiva = (int?)(total + (total * 0.19));
                factura.Estado = "FAC";
                factura.Idvendedor = idVendedor;
            }

            return factura;
        }

        internal List<FacturasFac> PedidoAFacturas(List<ProdSerXVendidosPed> listaPedido, List<ProductosServiciosPc> productos)
        {

            List<FacturasFac> facturas = new List<FacturasFac>();

            if (listaPedido != null && productos != null)
            {
                List<int> vendedores = new List<int>();

                for (int i = 0; i < listaPedido.Count; i++)
                {
                    vendedores.Add(productos[i].Idusuario);
                }
                List<int> uniqueValues = new List<int>();
                List<PedidosPed> pedidos = new List<PedidosPed>();
                for (int i = 0; i < vendedores.Count; i++)
                {
                    if (!uniqueValues.Contains(vendedores[i]))
                        uniqueValues.Add(vendedores[i]);
                }
                for (int i = 0; i < uniqueValues.Count; i++)
                {
                    List<ProdSerXVendidosPed> p = new List<ProdSerXVendidosPed>();
                    List<ProductosServiciosPc> ps = new List<ProductosServiciosPc>();
                    for (int j = 0; j < productos.Count; j++)
                    {
                        if (uniqueValues[i] == productos[j].Idusuario && productos[j].Id == listaPedido[j].Idproductoservico)
                        {
                            p.Add(listaPedido[j]);
                            ps.Add(productos[j]);
                        }
                    }
                    DateTime entrega = ps.Max(record => record.Tiempoentrega);
                    facturas.Add(PedidoAFactura(p, uniqueValues[i], entrega));
                }
            }
            return facturas;
        }

        internal ProdSerXFacturaFac ProductoPedidoAProductoFactura(ProdSerXVendidosPed productoPedido, int idFactura)
        {
            ProdSerXFacturaFac productoFactura = new ProdSerXFacturaFac();

            if (productoPedido != null && idFactura != -1)
            {
                productoFactura.Id = 0;
                productoFactura.Preciofacturado = productoPedido.Preciototal;
                productoFactura.Cantidadfacturado = productoPedido.Cantidadespedida;
                productoFactura.Idproductoservicio = productoPedido.Idproductoservico;
                productoFactura.Idfactura = idFactura;
            }

            return productoFactura;
        }

        internal List<ProdSerXFacturaFac> ProductosPedidoAProductosFacturados(List<ProdSerXVendidosPed> listaPedido, List<ProductosServiciosPc> productos, 
                                                                              List<FacturasFac> facturas)
        {
            List<ProdSerXFacturaFac> productosFacturas = new List<ProdSerXFacturaFac>();

            if (listaPedido != null && facturas != null && productos != null)
            {
                for (int i = 0; i < facturas.Count; i++)
                {
                    for (int j = 0; j < productos.Count; j++)
                    {
                        if (facturas[i].Idvendedor == productos[j].Idusuario && productos[j].Id == listaPedido[j].Idproductoservico)
                        {
                            ProdSerXFacturaFac pf = ProductoPedidoAProductoFactura(listaPedido[j], facturas[i].Id);
                            productosFacturas.Add(pf);
                        }
                    }
                }
            }
            return productosFacturas;
        }

        internal async Task<RespuestaDatos> GuardarFactura(FacturasFac factura ,PedidosPed pedido)
        {
            RespuestaDatos respuestaDatos;
            if (pedido != null)
            {
                try
                {
                    respuestaDatos = await _repoFacturasFac.GuardarFactura(factura);
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
            else { throw new COExcepcion("El pedido ingresado no existe."); }
            return respuestaDatos;
        }

        internal FacturasFac GetFacturaPorId(int idFactura)
        {
            return _repoFacturasFac.GetFacturaPorId(idFactura);
        }

        internal List<FacturasFac> GetFacturasPorIdPedido(int idPedido)
        {
            return _repoFacturasFac.GetFacturasPorIdPedido(idPedido);
        }

        internal List<FacturasFac> GetFacturasPorIdVendedor(int idVendedor)
        {
            return _repoFacturasFac.GetFacturasPorIdVendedor(idVendedor);
        }

        internal async Task<RespuestaDatos> RemoverFactura(int idFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoFacturasFac.RemoverFactura(idFactura);
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

        internal async Task<RespuestaDatos> ModificarFactura(FacturasFac factura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoFacturasFac.ModificarFactura(factura);
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

        internal async Task<RespuestaDatos> GuardarProductoFactura(ProdSerXFacturaFac productoFactura, FacturasFac factura)
        {
            RespuestaDatos respuestaDatos;
            if (factura != null)
            {
                try
                {
                    respuestaDatos = await _repoProdSerXFacturaFac.GuardarProductoFactura(productoFactura);
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
            else { throw new COExcepcion("La factura ingresada no existe."); }
            return respuestaDatos;
        }

        internal ProdSerXFacturaFac GetProductoFacturaPorId(int idProductoFactura)
        {
            return _repoProdSerXFacturaFac.GetProductoFacturaPorId(idProductoFactura);
        }

        internal List<ProdSerXFacturaFac> GetProductosFacturaPorIdFactura(int idFactura)
        {
            return _repoProdSerXFacturaFac.GetProductosFacturaPorIdFactura(idFactura);
        }

        internal async Task<RespuestaDatos> RemoverProductoFactura(int idProductoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProdSerXFacturaFac.RemoverProductoFactura(idProductoFactura);
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

        internal async Task<RespuestaDatos> ModificarProductoFactura(ProdSerXFacturaFac productoFactura)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProdSerXFacturaFac.ModificarProductoFactura(productoFactura);
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
    }
}
