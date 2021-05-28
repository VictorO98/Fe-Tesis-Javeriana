using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;

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
    }
}
