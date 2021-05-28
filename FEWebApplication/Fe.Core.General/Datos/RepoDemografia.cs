using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Linq;

namespace Fe.Core.General.Datos
{
    public class RepoDemografia
    {
        public DemografiaCor GuardarDemografia(DemografiaCor demografia)
        {
            using FeContext context = new FeContext();
            context.Add(demografia);
            context.SaveChanges();
            return demografia;
        }

        internal DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            using FeContext context = new FeContext();
            return context.DemografiaCors.Where(d => d.Id == idDemografia).FirstOrDefault();
        }
    }
}
