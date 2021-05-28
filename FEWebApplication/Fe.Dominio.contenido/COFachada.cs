using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Collections.Generic;
using System.Linq;
using System;

namespace Fe.Dominio.contenido
{
    public class COFachada
    {
        private readonly COContenidoBiz _cObiz;

        public COFachada(COContenidoBiz cObiz)
        {
            _cObiz = cObiz;
        }

        public List<CategoriaPc> GetCategorias()
        {
            return _cObiz.GetCategorias();
        }

        public CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            return _cObiz.GetCategoriaPorIdCategoria(idCategoria);
        }
    }
}
