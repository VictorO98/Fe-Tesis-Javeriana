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

namespace Fe.Dominio.pedidos.Datos
{
    public class RepoPedidosPed
    {
        internal async Task<RespuestaDatos> GuardarPedido(PedidosPed pedido)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(pedido);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Pedido creado exitosamente." };
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
                throw new COExcepcion("Ocurrió un problema al intentar realizar el pedido");
            }
            return respuestaDatos;
        }

        internal PedidosPed GetPedidoPorId(int idPedido)
        {
            using FeContext context = new FeContext();
            return context.PedidosPeds.SingleOrDefault(p => p.Id == idPedido);
        }

        internal List<PedidosPed> GetPedidosPorIdUsuario(int idUsuario)
        {
            using FeContext context = new FeContext();
            return context.PedidosPeds.Where(p => p.Idusuario == idUsuario).ToList();
        }

        internal async Task<RespuestaDatos> RemoverPedido(int idPedido)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            PedidosPed pedido = GetPedidoPorId(idPedido);
            if (pedido != null)
            {
                try
                {
                    context.PedidosPeds.Attach(pedido);
                    pedido.Estado = COEstadoPedido.CANCELADO;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Pedido eliminada exitosamente." };
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
                    throw new COExcepcion("Ocurrió un problema al intentar eliminar el pedido");
                }
            }
            else
            {
                throw new COExcepcion("El pedido no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarPedido(PedidosPed pedido)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            PedidosPed p = GetPedidoPorId(pedido.Id);
            if (p != null)
            {
                try
                {
                    context.Attach(p);
                    p.Idusuario = pedido.Idusuario;
                    p.Estado = pedido.Estado;
                    p.Fechapedido = pedido.Fechapedido;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Pedido modificado exitosamente." };
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
                    throw new COExcepcion("Ocurrió un problema al intentar modificar el pedido.");
                }
            }
            else
            {
                throw new COExcepcion("El pedido no existe");
            }
            return respuestaDatos;
        }
    }
}
