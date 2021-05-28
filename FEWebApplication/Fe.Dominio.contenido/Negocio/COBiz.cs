using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido.Datos;
using System.Collections.Generic;
using System.Linq;
using System;
using System.Text;

namespace Fe.Dominio.contenido
{
    public class COBiz
    {
        private readonly RepoCategoria _repoCategoria;

        public COBiz(RepoCategoria repoCategoria)
        {
            _repoCategoria = repoCategoria;
        }

        public List<CategoriaPc> GetCategorias()
        {
            return _repoCategoria.GetCategorias();
        }

        public CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            return _repoCategoria.GetCategoriaPorIdCategoria(idCategoria);
        }
    }
}
