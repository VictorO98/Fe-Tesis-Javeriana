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
    public class RepoTruequeDetalle
    {
        internal async Task<RespuestaDatos> GuardarTruequeDetalle(ProdSerTruequeTrue detalle)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                detalle.Creacion = DateTime.Now;
                context.Add(detalle);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Detalle del trueque creado exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar el detalle del trueque.");
            }
            return respuestaDatos;
        }

        internal ProdSerTruequeTrue GetDetallePorIdTrueque(int idTrueque)
        {
            using FeContext context = new FeContext();
            return context.ProdSerTruequeTrues.SingleOrDefault(t => t.Idtruequepedido == idTrueque);
        }
    }
}
