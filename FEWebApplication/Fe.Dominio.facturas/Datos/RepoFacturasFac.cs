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


namespace Fe.Dominio.facturas.Datos
{
    public class RepoFacturasFac
    {
        internal async Task<RespuestaDatos> GuardarFactura(FacturasFac factura)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(factura);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Factura creada exitosamente." };
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
                throw new COExcepcion("Ocurrió un problema al intentar realizar la factura");
            }
            return respuestaDatos;
        }

        internal FacturasFac GetFacturaPorId(int idFactura)
        {
            using FeContext context = new FeContext();
            return context.FacturasFacs.SingleOrDefault(f => f.Id == idFactura);
        }

        internal List<FacturasFac> GetFacturasPorIdPedido(int idPedido)
        {
            using FeContext context = new FeContext();
            return context.FacturasFacs.Where(f => f.Idpedido == idPedido).ToList();
        }

        internal List<FacturasFac> GetFacturasPorIdVendedor(int idVendedor)
        {
            using FeContext context = new FeContext();
            return context.FacturasFacs.Where(f => f.Idvendedor == idVendedor).ToList();
        }

        internal async Task<RespuestaDatos> RemoverFactura(int idFactura)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            FacturasFac factura = GetFacturaPorId(idFactura);
            if (factura != null)
            {
                try
                {
                    context.FacturasFacs.Attach(factura);
                    context.FacturasFacs.Remove(factura);
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Factura eliminada exitosamente." };
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
                    throw new COExcepcion("Ocurrió un problema al intentar eliminar la factura");
                }
            }
            else
            {
                throw new COExcepcion("La factura no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarFactura(FacturasFac factura)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            FacturasFac f = GetFacturaPorId(factura.Id);
            if (f != null)
            {
                try
                {
                    context.Attach(f);
                    f.Idpedido = factura.Idpedido;
                    f.Idvendedor = f.Idvendedor;
                    f.Valortotalfactura = factura.Valortotalfactura;
                    f.Valortotalfacturaiva = factura.Valortotalfacturaiva;
                    f.Fechaentrega = factura.Fechaentrega;
                    f.Fechafactura = factura.Fechafactura;
                    f.Estado = factura.Estado;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Factura modificada exitosamente." };
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
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la factura.");
                }
            }
            else
            {
                throw new COExcepcion("La factura no existe");
            }
            return respuestaDatos;
        }
    }
}
