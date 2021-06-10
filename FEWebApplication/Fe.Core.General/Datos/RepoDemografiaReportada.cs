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
    public class RepoDemografiaReportada
    {
        public async Task<RespuestaDatos> GuardarDemografiaReportada(DemografiaReportadaCor demografiaReportada)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
           
            try
            {
                context.Add(demografiaReportada);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Demografía reportada creada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar la Demografía reportada.");
            }
         
            return respuestaDatos;
        }

        internal DemografiaReportadaCor GetDemografiaReportadaPorId(int idDemografiaReportada)
        {
            using FeContext context = new FeContext();
            return context.DemografiaReportadaCors.SingleOrDefault(dr => dr.Id == idDemografiaReportada);
        }

        public List<DemografiaReportadaCor> GetTodasDemografiaReportada()
        {
            using FeContext context = new FeContext();
            return context.DemografiaReportadaCors.ToList();
        }

        internal async Task<RespuestaDatos> ModificarDemografiaReportada(DemografiaReportadaCor demografiaReportada)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            DemografiaReportadaCor dr = GetDemografiaReportadaPorId(demografiaReportada.Id);
            if (dr != null)
            {
                try
                {
                    context.Attach(dr);
                    dr.Motivo = demografiaReportada.Motivo;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Demografía Reportada modificada exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la demografía reportada.");
                }
            }
            else
            {
                throw new COExcepcion("La demografía reportada no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverDemografiaReportada(int idDemografiaReportada)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                DemografiaReportadaCor dr = new DemografiaReportadaCor { Id = idDemografiaReportada };
                context.DemografiaReportadaCors.Attach(dr);
                context.DemografiaReportadaCors.Remove(dr);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Demografía reportada eliminada exitosamente." };
            }
            catch (Exception e)
            {
                Console.WriteLine(e.StackTrace);
                Console.WriteLine(e.InnerException);
                throw new COExcepcion("Ocurrió un problema al intentar eliminar la demografía reportada");
            }
            return respuestaDatos;
        }
    }
}
