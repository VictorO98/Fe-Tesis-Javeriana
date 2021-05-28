using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Fe.Dominio.contenido.Datos
{
    public class RepoTipoPublicacion
    {
        internal TipoPublicacionPc GetTipoPublicacionPorID(int idPublicacion)
        {
            using FeContext context = new FeContext();
            return (TipoPublicacionPc)context.TipoPublicacionPcs.Where(p => p.Id == idPublicacion);
        }
    }
}
