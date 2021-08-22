using Dapper;
using Fe.Core.General.Datos;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Dapper;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Dominio.contenido.Datos
{
    public class RepoProdSerXVendidosPed
    {
        internal async Task<RespuestaDatos> GuardarProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(productoPedido);
                System.Diagnostics.Debug.WriteLine("Lo añadió :)");
                System.Diagnostics.Debug.WriteLine(productoPedido.Creacion);
                context.SaveChanges();
                System.Diagnostics.Debug.WriteLine("Khe");
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Producto pedido creado exitosamente." };
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
                throw new COExcepcion("Ocurrió un problema al intentar realizar la creación del detalle de producto de pedido");
            }
            return respuestaDatos;
        }

        internal ProdSerXVendidosPed GetProductoPedidoPorId(int idProductoPedido)
        {
            using FeContext context = new FeContext();
            return context.ProdSerXVendidosPeds.SingleOrDefault(p => p.Id == idProductoPedido);
        }

        internal List<ProdSerXVendidosPed> GetProductosPedidosPorIdPedido(int idPedido)
        {
            using FeContext context = new FeContext();
            return context.ProdSerXVendidosPeds.Where(p => p.Idpedido == idPedido).ToList();
        }

        internal async Task<RespuestaDatos> RemoverProductoPedido(int idProductoPedido)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            ProdSerXVendidosPed prodPed = GetProductoPedidoPorId(idProductoPedido);
            if (prodPed != null)
            {
                try
                {
                    context.ProdSerXVendidosPeds.Attach(prodPed);
                    context.ProdSerXVendidosPeds.Remove(prodPed);
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Producto pedido eliminado exitosamente." };
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
                    throw new COExcepcion("Ocurrió un problema al intentar eliminar el producto pedido");
                }
            }
            else
            {
                throw new COExcepcion("El producto pedido no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarProductoPedido(ProdSerXVendidosPed productoPedido)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            ProdSerXVendidosPed prodPed = GetProductoPedidoPorId(productoPedido.Id);
            if (prodPed != null)
            {
                try
                {
                    context.Attach(prodPed);
                    prodPed.Idproductoservico = productoPedido.Idproductoservico;
                    prodPed.Idpedido = productoPedido.Idpedido;
                    prodPed.Preciototal = productoPedido.Preciototal;
                    prodPed.Cantidadespedida = productoPedido.Cantidadespedida;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Producto pedido modificado exitosamente." };
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
                    throw new COExcepcion("Ocurrió un problema al intentar modificar el producto pedido.");
                }
            }
            else
            {
                throw new COExcepcion("El producto pedido no existe");
            }
            return respuestaDatos;
        }
    }
}
