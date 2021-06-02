using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System.Collections.Generic;
using System.Linq;
using System;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Core.Global.Constantes;
using Fe.Core.General;

namespace Fe.Dominio.contenido
{
    public class COFachada
    {
        private readonly COContenidoBiz _cOContenidoBiz;
        private readonly COGeneralFachada _cOGeneralFachada;

        public COFachada(COContenidoBiz cOContenidobiz, COGeneralFachada cOGeneralFachada)
        {
            _cOContenidoBiz = cOContenidobiz;
            _cOGeneralFachada = cOGeneralFachada;
        }

        public List<CategoriaPc> GetCategorias()
        {
            return _cOContenidoBiz.GetCategorias();
        }

        public CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            return _cOContenidoBiz.GetCategoriaPorIdCategoria(idCategoria);
        }

        public async Task<RespuestaDatos> GuardarCategoria(CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOContenidoBiz.GuardarCategoria(categoria);
            }
            catch(COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public TipoPublicacionPc GetTipoPublicacionPorID(int idPublicacion)
        {
            return _cOContenidoBiz.GetTipoPublicacionPorID(idPublicacion);
        }

        public async Task<RespuestaDatos> GuardarPublicacion(ProductosServiciosPc productosServicios)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorId(productosServicios.Idusuario);
                respuestaDatos = respuestaDatos = await _cOContenidoBiz.GuardarPublicacion(productosServicios, demografiaCor);
            }
            catch(COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public ProductosServiciosPc GetPublicacionPorIdPublicacion(int idPublicacion)
        {
            return _cOContenidoBiz.GetPublicacionPorIdPublicacion(idPublicacion);
        }
        
        public async Task<RespuestaDatos> RemoverPublicacion(int idPublicacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOContenidoBiz.RemoverPublicacion(idPublicacion);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> ModificarPublicacion(ProductosServiciosPc productosServicios)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOContenidoBiz.ModificarPublicacion(productosServicios);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> RemoverCategoria(int idCategoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOContenidoBiz.RemoverCategoria(idCategoria);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> ModificarCategoria(CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOContenidoBiz.ModificarCategoria(categoria);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> GuardarResena(ResenasPc resena)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = respuestaDatos = await _cOContenidoBiz.GuardarResena(resena);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public ResenasPc GetResenaPorIdResena(int idResena)
        {
            return _cOContenidoBiz.GetResenaPorIdResena(idResena);
        }

        public ICollection<ResenasPc> GetResenasPorIdPublicacion(int idPublicacion)
        {
            return _cOContenidoBiz.GetResenasPorIdPublicacion(idPublicacion);
        }
    }
}
