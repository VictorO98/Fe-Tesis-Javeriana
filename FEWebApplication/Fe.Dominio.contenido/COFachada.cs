using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Collections.Generic;
using System.Linq;
using System;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Core.Global.Constantes;

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

        public async Task<RespuestaDatos> GuardarCategoria(CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cObiz.GuardarCategoria(categoria);
            }
            catch(COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
                throw new COExcepcion("Ocurrió un problema al intentar agregar la categoría.");
            }
            return respuestaDatos;
        }
    }
}
