using Dapper;
using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Dapper;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Dominio.facturas.Datos
{
    public class RepoProdSerXFacturaFac
    {
        private readonly COFachada _cOFachada;

        public RepoProdSerXFacturaFac(COFachada cOFachada)
        {
            _cOFachada = cOFachada;
        }
        internal async Task<RespuestaDatos> GuardarProductoFactura(ProdSerXFacturaFac productoFactura)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(productoFactura);
                context.SaveChanges();
                ProductosServiciosPc p = await _cOFachada.GetPublicacionPorIdPublicacion((int)productoFactura.Idproductoservicio);
                p.Cantidadtotal = (int)(p.Cantidadtotal - productoFactura.Cantidadfacturado);
                await _cOFachada.ModificarPublicacion(p);
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Producto facturado creado exitosamente." };
            }
            catch (Exception e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "no_aplica",
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.ENVIO_CORREO
                });
                throw new COExcepcion("Ocurrió un problema al intentar realizar la creación del detalle de producto de la factura");
            }
            return respuestaDatos;
        }

        internal ProdSerXFacturaFac GetProductoFacturaPorId(int idProductoFactura)
        {
            using FeContext context = new FeContext();
            return context.ProdSerXFacturaFacs.SingleOrDefault(pf => pf.Id == idProductoFactura);
        }

        internal List<ProdSerXFacturaFac> GetProductosFacturaPorIdFactura(int idFactura)
        {
            using FeContext context = new FeContext();
            return context.ProdSerXFacturaFacs.Where(pf => pf.Idfactura == idFactura).ToList();
        }

        internal async Task<RespuestaDatos> RemoverProductoFactura(int idProductoFactura)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            ProdSerXFacturaFac prodFac = GetProductoFacturaPorId(idProductoFactura);
            if (prodFac != null)
            {
                try
                {
                    context.ProdSerXFacturaFacs.Attach(prodFac);
                    context.ProdSerXFacturaFacs.Remove(prodFac);
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Producto facturado eliminado exitosamente." };
                }
                catch (Exception e)
                {
                    RepoErrorLog.AddErrorLog(new ErrorLog
                    {
                        Mensaje = e.Message,
                        Traza = e.StackTrace,
                        Usuario = "no_aplica",
                        Creacion = DateTime.Now,
                        Tipoerror = COErrorLog.ENVIO_CORREO
                    });
                    throw new COExcepcion("Ocurrió un problema al intentar eliminar el producto facturado");
                }
            }
            else
            {
                throw new COExcepcion("El producto facturado no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarProductoFactura(ProdSerXFacturaFac productoFactura)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            ProdSerXFacturaFac prodFac = GetProductoFacturaPorId(productoFactura.Id);
            if (prodFac != null)
            {
                try
                {
                    context.Attach(prodFac);
                    prodFac.Preciofacturado = productoFactura.Preciofacturado;
                    prodFac.Cantidadfacturado = productoFactura.Cantidadfacturado;
                    prodFac.Idproductoservicio = productoFactura.Idproductoservicio;
                    prodFac.Idfactura = productoFactura.Idfactura;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Producto facturado modificado exitosamente." };
                }
                catch (Exception e)
                {
                    RepoErrorLog.AddErrorLog(new ErrorLog
                    {
                        Mensaje = e.Message,
                        Traza = e.StackTrace,
                        Usuario = "no_aplica",
                        Creacion = DateTime.Now,
                        Tipoerror = COErrorLog.ENVIO_CORREO
                    });
                    throw new COExcepcion("Ocurrió un problema al intentar modificar el producto facturado.");
                }
            }
            else
            {
                throw new COExcepcion("El producto facturado no existe");
            }
            return respuestaDatos;
        }
    }
}
