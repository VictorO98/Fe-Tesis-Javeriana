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

        internal async Task<RespuestaDatos> GuardarPreguntasyRespuestas(PreguntasRespuestasPc pyr)
        {
            RespuestaDatos respuestaDatos;
            ProductosServiciosPc publicacion = _repoProducto.GetPublicacionPorIdPublicacion(pyr.Idproductoservicio);
            if (publicacion != null)
            {
                try
                {
                    respuestaDatos = await _repoPyR.GuardarPreguntasyRespuestas(pyr);
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
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarPreguntasyRespuestas(PreguntasRespuestasPc pyr)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoPyR.ModificarPreguntasyRespuestas(pyr);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal List<PreguntasRespuestasPc> GetPreguntasyRespuestasPorIdPublicacion(int idPublicacion)
        {
            return _repoPyR.GetPreguntasyRespuestasPorIdPublicacion(idPublicacion);
        }

        internal ContratoPc DesplegarPublicacion(int idPublicacion)
        {
            ProductosServiciosPc publicacion = _repoProducto.GetPublicacionPorIdPublicacion(idPublicacion);
            ContratoPc contrato = new ContratoPc();
            if (publicacion != null)
            {
                contrato.Id = publicacion.Id;
                contrato.Nombre = publicacion.Nombre;
                contrato.Habilitatrueque = publicacion.Habilitatrueque;
                contrato.Cantidadtotal = publicacion.Cantidadtotal;
                contrato.Descripcion = publicacion.Descripcion;
                contrato.Descuento = publicacion.Descuento;
                contrato.Preciounitario = publicacion.Preciounitario;
                contrato.Urlimagenproductoservicio = publicacion.Urlimagenproductoservicio;
                contrato.Tiempoentrega = publicacion.Tiempoentrega;
                contrato.Tiempogarantia = publicacion.Tiempogarantia;
                contrato.Calificacionpromedio = publicacion.Calificacionpromedio;
                contrato.NombreCategoria = _repoCategoria.GetCategoriaPorIdCategoria(publicacion.Idcategoria).Nombre;
                contrato.TipoPublicacion = _repoTipoPublicacion.GetTipoPublicacionPorID(publicacion.Idtipopublicacion).Nombre;
                contrato.Resenas = _repoResena.GetResenasPorIdPublicacion(idPublicacion);
                contrato.PreguntasRespuestas = _repoPyR.GetPreguntasyRespuestasPorIdPublicacion(idPublicacion);
            }
            else
            {
                throw new COExcepcion("La publicación ingresada no existe.");
            }
            return contrato;
        }

        internal List<ContratoPc> FiltrarPublicacion(int idCategoria, int idTipoPublicacion,
            decimal precioMenor, decimal precioMayor, decimal calificacionMenor, decimal calificacionMayor)
        {
            List<ContratoPc> contratos = new List<ContratoPc>();
            if (idCategoria != -1 && GetCategoriaPorIdCategoria(idCategoria) == null)
            {
                throw new COExcepcion("La categoría ingresada no existe.");
            }
            if (idTipoPublicacion != -1 && GetTipoPublicacionPorID(idTipoPublicacion) == null)
            {
                throw new COExcepcion("El tipo de publicación ingresado no existe.");
            }
            if (precioMenor <= precioMayor)
            {
                if(calificacionMenor <= calificacionMayor)
                {
                    try
                    {

                        List<ProductosServiciosPc> listaPublicaciones = _repoProducto.FiltrarPublicaciones(idCategoria, 
                            idTipoPublicacion, precioMenor, precioMayor, calificacionMenor, calificacionMayor);
                        for(int i = 0; i < listaPublicaciones.Count; i++)
                        {
                            contratos.Add(DesplegarPublicacion(listaPublicaciones[i].Id));
                        }
                    }
                    catch(Exception e)
                    {
                        throw new COExcepcion("Ocurrió un problema al intentar filtrar la publicación.");
                    }

                }
                else { throw new COExcepcion("Las calificaciones ingresadas son inválidas."); }
            }
            else { throw new COExcepcion("Los precios ingresados son inválidos."); }
            return contratos;
        }

    }
}
