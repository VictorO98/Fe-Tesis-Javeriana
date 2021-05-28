using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Collections.Generic;
using System.Linq;

namespace Fe.Dominio.contenido.Datos
{
    public class RepoCategoria
    {
        public CategoriaPc GuardarCategoria(CategoriaPc categoria)
        {
            using FeContext context = new FeContext();
            context.Add(categoria);
            context.SaveChanges();
            return categoria;
        }

        public List<CategoriaPc> GetCategorias()
        {
            using var context = new FeContext();
            return context.CategoriaPcs.ToList();
        }

        public CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            using FeContext context = new FeContext();
            return context.CategoriaPcs.Where(p => p.Id == idCategoria);
        }
    }
}