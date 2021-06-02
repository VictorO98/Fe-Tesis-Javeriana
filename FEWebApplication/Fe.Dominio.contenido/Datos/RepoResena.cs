using Dapper;
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
    public class RepoResena
    {
        internal ResenasPc GetResenaPorIdResena(int idResena)
        {
            using FeContext context = new FeContext();
            return context.ResenasPcs.SingleOrDefault(r => r.Id == idResena);
        }

        internal int GetTotalResenaPorIdPublicacion(int idPublicacion)
        {
            using FeContext context = new FeContext();
            return context.ResenasPcs.Count(r => r.Idpublicacion == idPublicacion);
        }

        internal decimal GetCalificacionPromedioPorIdPublicacion(int idPublicacion)
        {
            using FeContext context = new FeContext();
            return (decimal) context.ResenasPcs.Where(r => r.Idpublicacion == idPublicacion).Average(c => c.Puntuacion);
        }

        internal async Task<RespuestaDatos> GuardarResena(ResenasPc resena)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(resena);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Reseña creada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar la reseña.");
            }
            return respuestaDatos;
        }

        internal List<ResenasPc> GetResenasPorIdPublicacion(int idPublicacion)
        {
            using FeContext context = new FeContext();
            return context.ResenasPcs.Where(r => r.Idpublicacion == idPublicacion).ToList();
        }
    }
}
