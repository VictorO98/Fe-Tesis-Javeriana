using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Collections.Generic;
using System.Linq;

namespace Fe.Core.General.Datos
{
    public class RepoDocumento
    {
        public List<TipoDocumentoCor> GetTipoDocumento()
        {
            using var context = new FeContext();
            return context.TipoDocumentoCors.ToList();
        }

        public TipoDocumentoCor GetTipoDocumentoPorId(int idTipoDocumento)
        {
            using FeContext context = new FeContext();
            return context.TipoDocumentoCors.Where(t => t.Id == idTipoDocumento).FirstOrDefault();
        }
    }
}
