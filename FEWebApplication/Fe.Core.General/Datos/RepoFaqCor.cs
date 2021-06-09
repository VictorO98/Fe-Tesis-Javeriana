using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Fe.Core.General.Datos
{
    public class RepoFaqCor
    {
        public async Task<RespuestaDatos> GuardarFaqCor(FaqCor faq)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(faq);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "FAQ creada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar la FAQ.");
            }
            return respuestaDatos;
        }

        internal FaqCor GetFaqCorPorId(int idFaqCor)
        {
            using FeContext context = new FeContext();
            return context.FaqCors.Where(f => f.Id == idFaqCor).FirstOrDefault();
        }

        public List<FaqCor> GetTodasFaqCor()
        {
            using FeContext context = new FeContext();
            return context.FaqCors.ToList();
        }

        internal async Task<RespuestaDatos> ModificarFaqCor(FaqCor faq)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            FaqCor f = GetFaqCorPorId(faq.Id);
            if (f != null)
            {
                try
                {
                    context.Attach(f);
                    f.Pregunta = faq.Pregunta;
                    f.Respuesta = faq.Respuesta;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "FAQ modificada exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la FAQ.");
                }
            }
            else
            {
                throw new COExcepcion("La FAQ no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverFaqCor(int idFaqCor)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                FaqCor f = new FaqCor { Id = idFaqCor };
                context.FaqCors.Attach(f);
                context.FaqCors.Remove(f);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "FAQ eliminada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar eliminar la FAQ");
            }
            return respuestaDatos;
        }
    }
}
