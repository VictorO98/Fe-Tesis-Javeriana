using Fe.Servidor.Middleware.Modelo.Entidades;
using Fe.Dominio.contenido.Datos;
using System.Collections.Generic;
using Fe.Core.Global.Errores;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Core;
using System;
using Fe.Servidor.Middleware.Contratos.Dominio.Contenido;
using Fe.Core.Global.Constantes;
using Microsoft.Extensions.Configuration;
using System.IO;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using Fe.Core.General.Datos;
using System.Linq;

namespace Fe.Dominio.contenido
{
    public class COContenidoBiz
    {
        private readonly IConfiguration _configuration;
        private readonly RepoCategoria _repoCategoria;
        private readonly RepoProducto _repoProducto;
        private readonly RepoTipoPublicacion _repoTipoPublicacion;
        private readonly RepoResena _repoResena;
        private readonly RepoPyR _repoPyR;
        private readonly RepoFavorito _repoFavorito;

        public COContenidoBiz(RepoCategoria repoCategoria, RepoProducto repoProducto, RepoTipoPublicacion repoTipoPublicacion, 
            RepoResena repoResena, RepoPyR repoPyR, RepoFavorito repoFavorito, IConfiguration configuration)
        {
            _configuration = configuration;
            _repoCategoria = repoCategoria;
            _repoProducto = repoProducto;
            _repoTipoPublicacion = repoTipoPublicacion;
            _repoResena = repoResena;
            _repoPyR = repoPyR;
            _repoFavorito = repoFavorito;
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

        internal async Task<RespuestaDatos> GuardarPublicacion(ProductosServiciosPc productosServicios, DemografiaCor demografiaCor, IFormFileCollection files)
        {
            if (demografiaCor != null)
            {
                if (GetCategoriaPorIdCategoria(productosServicios.Idcategoria) != null)
                {
                    if (GetTipoPublicacionPorID(productosServicios.Idtipopublicacion) != null)
                    {
                        if (Convert.ToInt32(productosServicios.Descuento) <= productosServicios.Preciounitario)
                        {
                            try
                            {
                                

                                productosServicios.Estado = COEstados.VIGENTE;
                                // TODO : queda pendiente definir bien estas fechas
                                productosServicios.Tiempoentrega = DateTime.Today.AddDays(10); // Tiempo de entrega aproximado a 10 días
                                productosServicios.Tiempogarantia = productosServicios.Tiempoentrega.AddDays(15); // TIempo de garantía aproximado de 15 días
                                productosServicios.Modificacion = DateTime.Now;
                                productosServicios.Id = await _repoProducto.GuardarPublicacion(productosServicios);

                                string directorio = _configuration["ImageProductos:DirectorioImagenes"];
                                directorio = directorio + "/" + "Productos";

                                if (string.IsNullOrEmpty(directorio))
                                {
                                    RepoErrorLog.AddErrorLog(new ErrorLog
                                    {
                                        Mensaje = "No se encuentra definida la ruta para las imagenes de evidencia. ",
                                        Traza = null,
                                        Usuario = demografiaCor.Email,
                                        Creacion = DateTime.Now,
                                        Tipoerror = COErrorLog.RUTA_NO_ENCONTRADA
                                    });
                                    throw new COExcepcion("Problema con las rutas. Por favor contacte a servicio al cliente. ");
                                }

                                var folderName = Path.Combine(directorio);
                                if (files.Count == 0)
                                    throw new COExcepcion("No hay documento a subir. ");

                                if (files.Count > 1)
                                    throw new COExcepcion("Solo se puede subir un máximo de 1 documento. ");

                                string[] permittedExtensions = { ".jpg", ".jpeg", ".png" };
                                List<string> listadoDeRutaFotos = new List<string>();
                                var folderDocument = directorio;
                                
                                foreach (var file in files)
                                {
                                    var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
                                    if (string.IsNullOrEmpty(ext) || !permittedExtensions.Contains(ext))
                                        throw new COExcepcion("Solo se aceptan imágenes JPG y PNG. ");

                                    var fileName = $@"imagen-producto-{productosServicios.Id}{ext}";
                                    productosServicios.Urlimagenproductoservicio = fileName;
                                    var fullPath = Path.Combine(folderName, fileName);
                                    using var stream = new FileStream(fullPath, FileMode.Create);
                                    file.CopyTo(stream);
                                    listadoDeRutaFotos.Add(fullPath);
                                }
                                if (listadoDeRutaFotos.Count == 0)
                                    throw new COExcepcion("No se almacenó ninguna imagen.");

                                await _repoProducto.GuardarLinkImagen(productosServicios);

                                return new RespuestaDatos
                                {
                                    Codigo = COCodigoRespuesta.OK,
                                    Mensaje = "Se guardo correctamente la publicación."
                                };
                            }
                            catch (COExcepcion e)
                            {
                                throw e;
                            }
                        }
                        else { throw new COExcepcion("El descuento es mayor al valor de tu producto"); }
                    }
                    else { throw new COExcepcion("El tipo de publicación ingresado no existe."); }
                }
                else { throw new COExcepcion("La categoría ingresada no existe."); }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
        }

        internal async Task<ProductosServiciosPc> GetPublicacionPorIdPublicacion(int idPublicacion)
        {
            return await _repoProducto.GetPublicacionPorIdPublicacion(idPublicacion);
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

        internal async Task<RespuestaDatos> ModificarPublicacionApp(ModificarPublicacion productosServicios)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoProducto.ModificarPublicacionApp(productosServicios);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal string GetImagenProdcuto(ProductosServiciosPc publicacion)
        {
            try
            {
                if (publicacion == null)
                    throw new COExcepcion("La publicación no existe. ");

                string fileName = publicacion.Urlimagenproductoservicio;

                if (!fileName.Contains($@"imagen-producto-{publicacion.Id}"))
                    throw new COExcepcion("No tiene acceso a esta imagen. ");

                string directorio = _configuration["ImageProductos:DirectorioImagenes"] + "/Productos";

                return Path.Combine(directorio, Path.GetFileName(fileName));

            }
            catch (COExcepcion e)
            {
                throw e;
            }
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
                ProductosServiciosPc publicacion = await _repoProducto.GetPublicacionPorIdPublicacion(resena.Idpublicacion);
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
            ProductosServiciosPc publicacion = await _repoProducto.GetPublicacionPorIdPublicacion(pyr.Idproductoservicio);
            if (publicacion != null)
            {
                try
                {
                    pyr.Creacion = DateTime.Now;
                    pyr.Modificacion = DateTime.Now;
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

        internal async Task<ContratoPublicacionPc> GetProductoPorIdProducto(int idPublicacion)
        {
            return await DesplegarPublicacion(idPublicacion);
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

        internal async Task<bool> FavoritoMio(DemografiaCor demografiaCor, ProductosServiciosPc publicacion)
        {
            try
            {
                bool respuesta = false;
                if (demografiaCor == null)
                    throw new COExcepcion("El usuario no existe. ");

                if (publicacion == null)
                    throw new COExcepcion("La publicación no existe. ");

                var ans = _repoFavorito.FavoritoMio(demografiaCor,publicacion);

                if (ans != null)
                    respuesta = true;

                return respuesta;
            }
             catch(COExcepcion e)
            {
                throw e;
            }
        }

        internal List<PreguntasRespuestasPc> GetPreguntasyRespuestasPorIdPublicacion(int idPublicacion)
        {
            return _repoPyR.GetPreguntasyRespuestasPorIdPublicacion(idPublicacion);
        }

        internal async Task<ContratoPublicacionPc> DesplegarPublicacion(int idPublicacion)
        {
            ProductosServiciosPc publicacion = await _repoProducto.GetPublicacionPorIdPublicacion(idPublicacion);
            ContratoPublicacionPc contrato = new ContratoPublicacionPc();
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

        internal async Task<List<ContratoPublicacionPc>> FiltrarPublicacion(int idCategoria, int idTipoPublicacion, DemografiaCor usuario, 
            decimal precioMenor, decimal precioMayor, decimal calificacionMenor, decimal calificacionMayor)
        {
            List<ContratoPublicacionPc> publicaciones = new List<ContratoPublicacionPc>();
            if (idCategoria != -1 && GetCategoriaPorIdCategoria(idCategoria) == null)
            {
                throw new COExcepcion("La categoría ingresada no existe.");
            }
            if (idTipoPublicacion != -1 && GetTipoPublicacionPorID(idTipoPublicacion) == null)
            {
                throw new COExcepcion("El tipo de publicación ingresado no existe.");
            }
            if (usuario == null)
            {
                throw new COExcepcion("El usuario no existe.");
            }
            if (precioMenor <= precioMayor)
            {
                if(calificacionMenor <= calificacionMayor)
                {
                    try
                    {

                        List<ProductosServiciosPc> listaPublicaciones = _repoProducto.FiltrarPublicaciones(idCategoria, 
                            idTipoPublicacion, precioMenor, precioMayor, calificacionMenor, calificacionMayor, usuario);
                        for(int i = 0; i < listaPublicaciones.Count; i++)
                        {
                            publicaciones.Add(await DesplegarPublicacion(listaPublicaciones[i].Id));
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
            return publicaciones;
        }

        internal async Task<RespuestaDatos> GuardarFavorito(ProductosFavoritosDemografiaPc favorito, DemografiaCor demografiaCor,
            ProductosServiciosPc publicacion)
        {
            RespuestaDatos respuestaDatos;
            if(demografiaCor != null)
            {
                if (publicacion != null)
                {
                    try
                    {
                        respuestaDatos = await _repoFavorito.GuardarFavorito(favorito);
                    }
                    catch (COExcepcion e)
                    {
                        throw e;
                    }
                }
                else { throw new COExcepcion("La publicación ingresada no existe."); }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverFavorito(int idFavorito)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoFavorito.RemoverFavorito(idFavorito);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        internal async Task<List<ContratoPublicacionPc>> GetFavoritosPorIdDemografia(DemografiaCor demografia)
        {
            List<ContratoPublicacionPc> publicaciones = new List<ContratoPublicacionPc>();
            if(demografia != null)
            {
                List<ProductosFavoritosDemografiaPc> favoritos = _repoFavorito.GetFavoritosPorIdDemografia(demografia.Id);
                for(int i = 0; i < favoritos.Count; i++)
                {
                    publicaciones.Add(await DesplegarPublicacion(favoritos[i].Idproductoservicio));
                }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return publicaciones;
        }
        internal int ValidarPublicacionesPorIdUsuario(DemografiaCor demografia)
        {
            int validarPublicacion;
            if (demografia != null)
            {
                if (demografia.Rolcorid == 2)
                {
                    validarPublicacion = _repoProducto.GetPublicacionesPorIdUsuario(demografia.Id).Count;
                }
                else { throw new COExcepcion("El usuario ingresado no es un emprendedor."); }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return validarPublicacion;
        }

        internal async Task<List<ContratoPublicacionPc>> GetPublicacionesPorIdUsuario(DemografiaCor demografia)
        {
            List<ContratoPublicacionPc> publicaciones = new List<ContratoPublicacionPc>();
            if (demografia != null)
            {
                if(demografia.Rolcorid == 2)
                {
                    List<ProductosServiciosPc> publicacion = _repoProducto.GetPublicacionesPorIdUsuario(demografia.Id);
                    for (int i = 0; i < publicacion.Count; i++)
                    {
                        publicaciones.Add(await DesplegarPublicacion(publicacion[i].Id));
                    }
                } else { throw new COExcepcion("El usuario ingresado no es un emprendedor."); }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return publicaciones;
        }

        internal async Task<List<ContratoPublicacionPc>> GetPublicacionesPorDescuento(int idUsuario, DemografiaCor demografiaCor)
        {
            if (demografiaCor == null)
                throw new COExcepcion("El usuario no existe.");

            List<ContratoPublicacionPc> publicaciones = new List<ContratoPublicacionPc>();
            List<ProductosServiciosPc> publicacion = _repoProducto.GetPublicacionesPorDescuento(idUsuario);
            for (int i = 0; i < publicacion.Count; i++)
            {
                publicaciones.Add(await DesplegarPublicacion(publicacion[i].Id));
            }
            return publicaciones;
        }

        internal async Task<List<ContratoPublicacionPc>> BuscarPublicacion(string nombre, int idUsuario)
        {
            List<ContratoPublicacionPc> publicaciones = new List<ContratoPublicacionPc>();
            List<ProductosServiciosPc> publicacion = _repoProducto.BuscarPublicacion(nombre, idUsuario);
            for (int i = 0; i < publicacion.Count; i++)
            {
                publicaciones.Add(await DesplegarPublicacion(publicacion[i].Id));
            }
            return publicaciones;
        }

        internal async Task<List<ContratoPublicacionPc>> GetPublicacionesHabilitadasTrueque(DemografiaCor demografia)
        {
            List<ContratoPublicacionPc> publicaciones = new List<ContratoPublicacionPc>();
            if (demografia != null)
            {
                if (demografia.Rolcorid == 2)
                {
                    List<ProductosServiciosPc> publicacion = _repoProducto.GetPublicacionesHabilitadasTrueque(demografia.Id);
                    for (int i = 0; i < publicacion.Count; i++)
                    {
                        publicaciones.Add(await DesplegarPublicacion(publicacion[i].Id));
                    }
                }
                else { throw new COExcepcion("El usuario ingresado no es un emprendedor."); }
            }
            else { throw new COExcepcion("El usuario ingresado no existe."); }
            return publicaciones;
        }
    }
}
