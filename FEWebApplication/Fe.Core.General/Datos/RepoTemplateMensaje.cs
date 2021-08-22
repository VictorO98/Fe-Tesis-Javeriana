using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Linq;

namespace Fe.Core.General.Datos
{
    public class RepoTemplateMensaje
    {
        public TemplateMensajeCor GetTemplatePorNombre(string codigo)
        {
            using FeContext context = new FeContext();
            return context.TemplateMensajeCors.Where(t => t.Codigo == codigo).FirstOrDefault();
        }
    }
}
