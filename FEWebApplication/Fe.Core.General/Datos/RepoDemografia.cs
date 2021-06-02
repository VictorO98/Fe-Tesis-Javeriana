using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Fe.Core.General.Datos
{
    public class RepoDemografia
    {
        public async Task<RespuestaDatos> GuardarDemografia(DemografiaCor demografia)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(demografia);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Categoría creada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar la categoría.");
            }
            return respuestaDatos;
        }

        internal DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            using FeContext context = new FeContext();
            return context.DemografiaCors.Where(d => d.Id == idDemografia).FirstOrDefault();
        }

        public DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            using FeContext context = new FeContext();
            return context.DemografiaCors.Where(d => d.Email == emailDemografia).FirstOrDefault();
        }
    }
}
