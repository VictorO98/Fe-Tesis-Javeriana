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

namespace Fe.Dominio.contenido.Datos
{
    public class RepoPyR
    {
        internal async Task<RespuestaDatos> GuardarPreguntasyRespuestas(PreguntasRespuestasPc pyr)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                pyr.Creacion = DateTime.Now;
                pyr.Modificacion = DateTime.Now;
                context.Add(pyr);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Pregunta realizada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar realizar la pregunta");
            }
            return respuestaDatos;
        }

        internal PreguntasRespuestasPc GetPreguntasyRespuestasPorIdPyR(int idPyR)
        {
            using FeContext context = new FeContext();
            return context.PreguntasRespuestasPcs.SingleOrDefault(p => p.Id == idPyR);
        }

        internal async Task<RespuestaDatos> ModificarPreguntasyRespuestas(PreguntasRespuestasPc pyr)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            PreguntasRespuestasPc nuevoPyR = GetPreguntasyRespuestasPorIdPyR(pyr.Id);
            if (nuevoPyR != null)
            {
                try
                {
                    context.Attach(nuevoPyR);
                    nuevoPyR.Respuesta = pyr.Respuesta;
                    nuevoPyR.Modificacion = DateTime.Now;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Respuesta modificada exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la respuesta.");
                }
            }
            else
            {
                throw new COExcepcion("La pregunta no existe");
            }
            return respuestaDatos;
        }

        internal List<PreguntasRespuestasPc> GetPreguntasyRespuestasPorIdPublicacion(int idPublicacion)
        {
            using FeContext context = new FeContext();
            return context.PreguntasRespuestasPcs.Where(p => p.Idproductoservicio == idPublicacion).ToList();
        }
    }
}
