using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;

namespace Fe.Core.General.Datos
{
    public class RepoErrorLog
    {
        public static void AddErrorLog(ErrorLog errorLog)
        {
            using FeContext context = new FeContext();
            context.Add(errorLog);
            context.SaveChanges();
        }
    }
}
