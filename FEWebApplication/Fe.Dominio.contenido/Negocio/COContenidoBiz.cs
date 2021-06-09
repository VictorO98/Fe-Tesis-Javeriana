using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido.Datos;
using System.Collections.Generic;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using System;

namespace Fe.Dominio.contenido
{
    public class COContenidoBiz
    {
        private readonly RepoCategoria _repoCategoria;
        private readonly RepoProducto _repoProducto;
        private readonly RepoTipoPublicacion _repoTipoPublicacion;
        private readonly RepoResena _repoResena;

        public COContenidoBiz(RepoCategoria repoCategoria, RepoProducto repoProducto, RepoTipoPublicacion repoTipoPublicacion, 
            RepoResena repoResena)
        {
            _repoCategoria = repoCategoria;
            _repoProducto = repoProducto;
            _repoTipoPublicacion = repoTipoPublicacion;
            _repoResena = repoResena;
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

        internal ProductosServiciosPc GetPublicacionPorIdPublicacion(int idPublicacion)
        {
            return _repoProducto.GetPublicacionPorIdPublicacion(idPublicacion);
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

        internal ResenasPc GetResenaPorIdResena(int idResena)
        {
            return _repoResena.GetResenaPorIdResena(idResena);
        }

        internal List<ResenasPc> GetResenasPorIdPublicacion(int idPublicacion)
        {
            return _repoResena.GetResenasPorIdPublicacion(idPublicacion);
        }

        internal async Task<RespuestaDatos> GuardarResena(ResenasPc resena)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                ProductosServiciosPc publicacion = _repoProducto.GetPublicacionPorIdPublicacion(resena.Idpublicacion);
                if (publicacion != null)
                {
                    respuestaDatos = await _repoResena.GuardarResena(resena);
                    try
                    {
                        decimal calificacion = _repoResena.GetCalificacionPromedioPorIdPublicacion(resena.Idpublicacion);
                        await _repoProducto.ModificarCalificacion(publicacion.Id, calificacion);
                    }
                    catch (COExcepcion e)
                    {
                        throw e;
                    }
                }
                else
                {
                    throw new COExcepcion("La publicación ingresada no existe");
                }
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
