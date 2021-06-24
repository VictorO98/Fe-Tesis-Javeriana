using Fe.Core.Global.Constantes;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.General.Datos
{
    public class RepoRoles
    {
        public List<RolCor> GetRoles()
        {
            using FeContext context = new FeContext();
            return context.RolCors.Where(d => d.Id != CORol.ADMIN).ToList();
        }
    }
}
