using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido.Datos;
using System.Collections.Generic;
using System.Linq;
using System;
using System.Text;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Core.Global.Constantes;

namespace Fe.Dominio.contenido
{
    public class COContenidoBiz
    {
        private readonly RepoCategoria _repoCategoria;
        private readonly RepoProducto _repoProducto;
        private readonly RepoTipoPublicacion _repoTipoPublicacion;

        public COContenidoBiz(RepoCategoria repoCategoria, RepoProducto repoProducto, RepoTipoPublicacion repoTipoPublicacion)
        {
            _repoCategoria = repoCategoria;
            _repoProducto = repoProducto;
            _repoTipoPublicacion = repoTipoPublicacion;
        }

        internal List<CategoriaPc> GetCategorias()
        {
            return _repoCategoria.GetCategorias();
        }

        internal CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            return _repoCategoria.GetCategoriaPorIdCategoria(idCategoria);
        }

        internal TipoPublicacionPc GetTipoPublicacionPorID(int idPublicacion)
        {
            return _repoTipoPublicacion.GetTipoPublicacionPorID(idPublicacion);
        }

        internal async Task<RespuestaDatos> GuardarCategoria(CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoCategoria.GuardarCategoria(categoria);
            }
            catch(COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> GuardarPublicacion(ProductosServiciosPc productosServicios, DemografiaCor demografiaCor)
        {
            RespuestaDatos respuestaDatos;
            if (demografiaCor != null)
            {
                if (GetCategoriaPorIdCategoria(productosServicios.Idcategoria) != null)
                {
                    if (GetTipoPublicacionPorID(productosServicios.Idtipopublicacion) != null)
                    {
                        try
                        {
                            respuestaDatos = await _repoProducto.GuardarPublicacion(productosServicios);
                        }
                        catch (COExcepcion e)
                        {
                            throw e;
                        }
                    }
                    else { throw new COExcepcion("El tipo de publicación ingresado no existe."); }
                }
                else { throw new COExcepcion("La categoría ingresada no existe."); }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return respuestaDatos;
        }

        internal ProductosServiciosPc GetPublicacionPorId(int idPublicacion)
        {
            return _repoProducto.GetPublicacionPorId(idPublicacion);
        }

        internal async Task<RespuestaDatos> RemoverPublicacion(int idPublicacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProducto.RemoverPublicacion(idPublicacion);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarPublicacion(ProductosServiciosPc productosServicios)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProducto.ModificarPublicacion(productosServicios);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverCategoria(int idCategoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoCategoria.RemoverCategoria(idCategoria);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarCategoria(CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoCategoria.ModificarCategoria(categoria);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
