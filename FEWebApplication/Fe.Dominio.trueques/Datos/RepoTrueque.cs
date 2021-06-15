using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Dominio.trueques.Datos
{
    public class RepoTrueque
    {
        internal async Task<RespuestaDatos> GuardarTrueque(TruequesPedidoTrue trueque)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                trueque.Estado = COEstadosTrueque.OFERTADO;
                context.Add(trueque);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Trueque creado exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar el trueque.");
            }
            return respuestaDatos;
        }

        internal TruequesPedidoTrue GetTruequePorIdTrueque(int idTrueque)
        {
            using FeContext context = new FeContext();
            return context.TruequesPedidoTrues.SingleOrDefault(t => t.Id == idTrueque);
        }

        internal TruequesPedidoTrue GetTruequePorIdCompradorIdVendedor(int idComprador, int idVendedor)
        {
            using FeContext context = new FeContext();
            return context.TruequesPedidoTrues.FirstOrDefault(t => t.Idcomprador == idComprador && 
            t.Idvendedor == idVendedor && t.Estado == COEstadosTrueque.OFERTADO);
        }

        internal List<TruequesPedidoTrue> GetTrueques()
        {
            using FeContext context = new FeContext();
            return context.TruequesPedidoTrues.ToList();
        }

        internal List<TruequesPedidoTrue> GetTruequesPorIdVendedor(int idVendedor)
        {
            using FeContext context = new FeContext();
            return context.TruequesPedidoTrues.Where(t => t.Idvendedor == idVendedor).ToList();
        }

        internal List<TruequesPedidoTrue> GetTruequesPorIdComprador(int idComprador)
        {
            using FeContext context = new FeContext();
            return context.TruequesPedidoTrues.Where(t => t.Idcomprador == idComprador).ToList();
        }

        internal async Task<RespuestaDatos> ModificarTrueque(TruequesPedidoTrue nuevoTrueque, string estado)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            TruequesPedidoTrue trueque = GetTruequePorIdTrueque(nuevoTrueque.Id);
            if (trueque != null)
            {
                try
                {
                    context.Attach(trueque);
                    trueque.Estado = estado;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Trueque modificado exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar modificar el trueque.");
                }
            }
            else
            {
                throw new COExcepcion("El trueque no existe");
            }
            return respuestaDatos;
        }
    }
}
