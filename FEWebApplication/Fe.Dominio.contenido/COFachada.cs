using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido.Negocio
using System.Collections.Generic;
using System.Linq;
using System;

namespace Fe.Dominio.contenido
{
    public class COFachada
    {
        private readonly COBiz _cObiz;

        public COFachada(CObiz cObiz)
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
