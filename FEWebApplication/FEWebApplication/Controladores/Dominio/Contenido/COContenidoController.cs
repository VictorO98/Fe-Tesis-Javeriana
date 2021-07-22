using Fe.Dominio.contenido;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using FEWebApplication.Controladores.Core;
using Fe.Servidor.Middleware.Contratos.Core;
using System.Threading.Tasks;
using Fe.Servidor.Middleware.Contratos.Dominio.Contenido;
using System.IO;
using Microsoft.AspNetCore.Http;
using System;

namespace FEWebApplication.Controladores.Dominio.Contenido
{
    /// <summary>
    /// Servicios para guardar, modificar, borrar o leer publicaciones
    /// y su respectivo detalle (categor�as, favoritos, preguntas y respuestas, rese�as, tipo de publicaci�n)
    /// </summary>
    [Route("dominio/[controller]")]
    public class COContenidoController : COApiController
    {   
        private readonly COFachada _coFachada;

        public COContenidoController(COFachada cOFachada)
        {
            _coFachada = cOFachada;
        }

        /// <summary>
        /// Retorna todas las categor�as de publicaciones almacenadas en la base de datos.
        /// </summary>
        /// <returns>Una lista en formato JSON con todas las categor�as y sus respectivos atributos.</returns>
        [Route("GetCategorias")]
        [HttpGet]
        public List<CategoriaPc> GetCategorias()
        {
            return _coFachada.GetCategorias();
        }

        /// <summary>
        /// Busca una categor�a por su ID y retorna los atributos de esta.
        /// </summary>
        /// <returns>Una categor�a en formato JSON con sus respectivos atributos.</returns>
        /// <param name="idCategoria">El id de la categor�a a buscar.</param>
        [Route("GetCategoriaPorIdCategoria")]
        [HttpGet]
        public CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            return _coFachada.GetCategoriaPorIdCategoria(idCategoria);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena la categor�a en la BD.
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realiz� la inserci�n de la categor�a.</returns>
        /// <param name="categoria">Categor�a que se desea almacernar en la base de datos.</param>
        [Route("GuardarCategoria")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarCategoria([FromBody] CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.GuardarCategoria(categoria);
            }
            catch (COExcepcion e) 
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena la publicaci�n en la BD.
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realiz� la inserci�n de la publicaci�n.</returns>
        /// <param name="productosServicios">Publicaci�n que se desea almacenar en la base de datos.</param>
        [Route("GuardarPublicacion")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarPublicacion([FromBody] ProductosServiciosPc productosServicios)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.GuardarPublicacion(productosServicios);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        [Route("SubirFotosPublicacion")]
        public RespuestaDatos SubirFotosPublicacion(IFormCollection collection)
        {
            try
            {
                var formData = Request.Form;
                var files = Request.Form.Files;
                formData = Request.Form;
                if (formData == null)
                    throw new COExcepcion("El formulario de la petici�n enviada se encuentra vac�o. ");

                return _coFachada.SubirFotosPublicacion(files);
            }
            catch (Exception e)
            {
                throw new COExcepcion("Error al subir el documento. " + e.Message);
            }
        }

        /// <summary>
        /// Busca las imagens de los productos por su ID.
        /// </summary>
        /// <returns>Retonr la imagen del producto en un formato JPG o PNG.</returns>
        /// <param name="idPublicacion">El id de la publicaci�n para buscar.</param>
        [Route("GetImagenProdcuto")]
        [HttpGet]
        public IActionResult GetImagenProdcuto(int idPublicacion, int idUsuario)
        {
            string pathImage = _coFachada.GetImagenProdcuto(idPublicacion, idUsuario);

            var ext = Path.GetExtension(pathImage).ToLowerInvariant();
            string mimeTypeExt = "";
            switch (ext)
            {
                case ".jpg":
                case ".jpeg":
                    mimeTypeExt = "jpg";
                    break;
                case ".png":
                    mimeTypeExt = "png";
                    break;
                default:
                    mimeTypeExt = "jpg";
                    break;
            }

            return PhysicalFile(pathImage, $@"image/{mimeTypeExt}");
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Busca una publicaci�n por su ID y la desactiva de la aplicaci�n.
        /// </summary>
        /// <returns>Respuesta de datos con un c�digo de respuesta y un mensaje que indica si fue o no exitoso la desactivaci�n
        /// de la publicaci�n.</returns>
        /// <param name="idPublicacion">El id de la publicaci�n a desactivar.</param>
        [Route("RemoverPublicacion")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverPublicacion(int idPublicacion)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.RemoverPublicacion(idPublicacion);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Modifica la publicaci�n indicada en la base de datos.
        /// </summary>
        /// <returns>Respuesta de datos con un c�digo de respuesta y un mensaje que indica si fue o no exitoso la modificaci�n
        /// de la publicaci�n.</returns>
        /// <param name="productosServicios">Publicaci�n que se desea modificar en la base de datos.</param>
        [Route("ModificarPublicacion")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarPublicacion([FromBody] ProductosServiciosPc productosServicios)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.ModificarPublicacion(productosServicios);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Busca una categor�a por su ID y la borra de la base de datos.
        /// </summary>
        /// <returns>Respuesta de datos con un c�digo de respuesta y un mensaje que indica si fue o no la eliminaci�n
        /// de la categor�a.</returns>
        /// <param name="idCategoria">El id de la categor�a a eliminar.</param>
        [Route("RemoverCategoria")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverCategoria(int idCategoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.RemoverCategoria(idCategoria);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Modifica la categor�a indicada en la base de datos.
        /// </summary>
        /// <returns>Respuesta de datos con un c�digo de respuesta y un mensaje que indica si fue o no exitoso la modificaci�n
        /// de la categor�a.</returns>
        /// <param name="categoria">Publicaci�n que se desea modificar en la base de datos.</param>
        [Route("ModificarCategoria")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarCategoria([FromBody] CategoriaPc categoria)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.ModificarCategoria(categoria);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena la rese�a en la BD.
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realiz� la inserci�n de la rese�a.</returns>
        /// <param name="resena">Rese�a que se desea almacenar en la base de datos.</param>
        [Route("GuardarResena")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarResena([FromBody] ResenasPc resena)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.GuardarResena(resena);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Busca una rese�a por su ID y retorna los atributos de esta.
        /// </summary>
        /// <returns>Una rese�a en formato JSON con sus respectivos atributos.</returns>
        /// <param name="idResena">El id de la rese�a a buscar.</param>
        [Route("GetResenaPorIdResena")]
        [HttpGet]
        public ResenasPc GetResenaPorIdResena(int idResena)
        {
            return _coFachada.GetResenaPorIdResena(idResena);
        }

        /// <summary>
        /// Busca todas las rese�as de una publicaci�n y retorna una lista de ellas.
        /// </summary>
        /// <returns>Una lista de rese�as en formato JSON con sus respectivos atributos.</returns>
        /// <param name="idPublicacion">El id de la publicaci�n de las rese�as a buscar.</param>
        [Route("GetResenasPorIdPublicacion")]
        [HttpGet]
        public ICollection<ResenasPc> GetResenasPorIdPublicacion(int idPublicacion)
        {
            return _coFachada.GetResenasPorIdPublicacion(idPublicacion);
        }

        /// <summary>
        /// Busca todas las preguntas y respuestas de una publicaci�n y retorna una lista de ellas.
        /// </summary>
        /// <returns>Una lista de preguntas y respuestas en formato JSON con sus respectivos atributos.</returns>
        /// <param name="idPublicacion">El id de la publicaci�n de las preguntas y respuestas a buscar.</param>
        [Route("GetPreguntasyRespuestasPorIdPublicacion")]
        [HttpGet]
        public List<PreguntasRespuestasPc> GetPreguntasyRespuestasPorIdPublicacion(int idPublicacion)
        {
            return _coFachada.GetPreguntasyRespuestasPorIdPublicacion(idPublicacion);
        }

        /// <summary>
        /// Almacena la pregunta en la BD.
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realiz� la inserci�n de la pregunta.</returns>
        /// <param name="pyr">Pregunta que se desea almacenar en la base de datos.</param>
        [Route("GuardarPreguntasyRespuestas")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarPreguntasyRespuestas([FromBody] PreguntasRespuestasPc pyr)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.GuardarPreguntasyRespuestas(pyr);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Modifica la respuesta de la pregunta indicada en la base de datos.
        /// </summary>
        /// <returns>Respuesta de datos con un c�digo de respuesta y un mensaje que indica si fue o no exitoso la modificaci�n
        /// de la respuesta.</returns>
        /// <param name="categoria">Pregunta que se desea responder o respuesta a modificar en la base de datos.</param>
        [Route("ModificarPreguntasyRespuestas")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarPreguntasyRespuestas([FromBody] PreguntasRespuestasPc pyr)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.ModificarPreguntasyRespuestas(pyr);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Despliega una publicaci�n con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.
        /// </summary>
        /// <returns>La publicaci�n con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.</returns>
        /// <param name="idPublicacion">El id de la publicaci�n a desplegar.</param>
        [Route("DesplegarPublicacion")]
        [HttpGet]
        public ContratoPc DesplegarPublicacion(int idPublicacion)
        {
            return _coFachada.DesplegarPublicacion(idPublicacion);
        }

        /// <summary>
        /// Filtra todas las publicaciones que correspondan a los par�metros dados y los entrega.
        /// </summary>
        /// <returns>Una lista de publicaciones filtradas con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.</returns>
        /// <param name="idCategoria">El id de la categor�a de las publicaciones a filtrar.</param>
        /// <param name="idTipoPublicacion">El tipo de las publicaciones a filtrar.</param>
        /// <param name="precioMenor">El l�mite inferior del precio de las publicaciones a filtrar.</param>
        /// <param name="precioMayor">El l�mite superior del precio de las publicaciones a filtrar.</param>
        /// <param name="calificacionMenor">El l�mite inferior de la calificaci�n de las publicaciones a filtrar.</param>
        /// <param name="calificacionMayor">El l�mite superior de la calificaci�n de las publicaciones a filtrar.</param>
        /// 
        [Route("FiltrarPublicacion")]
        [HttpGet]
        public List<ContratoPc> FiltrarPublicacion(int idCategoria = -1, int idTipoPublicacion = -1, 
            decimal precioMenor = -1, decimal precioMayor = -1, decimal calificacionMenor = -1, decimal calificacionMayor = -1)
        {
            try
            {
                return _coFachada.FiltrarPublicacion(idCategoria, idTipoPublicacion, precioMenor, precioMayor,
                    calificacionMenor, calificacionMayor);
            }
            catch(COExcepcion e)
            {
                throw e;
            }
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena la publicaci�n favorita en la BD.
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realiz� la inserci�n de la publicaci�n a favoritos.</returns>
        /// <param name="favorito">Publicaci�n que se desea agregar a favoritos.</param>
        [Route("GuardarFavorito")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarFavorito([FromBody] ProductosFavoritosDemografiaPc favorito)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.GuardarFavorito(favorito);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Busca una publicaci�n por su ID y la borra de favoritos.
        /// </summary>
        /// <returns>Respuesta de datos con un c�digo de respuesta y un mensaje que indica si fue o no la eliminaci�n
        /// de la publicaci�n de favoritos.</returns>
        /// <param name="idFavorito">El id de la publicaci�n a eliminar de favoritos.</param>
        [Route("RemoverFavorito")]
        [HttpDelete]
        public async Task<RespuestaDatos> RemoverFavorito(int idFavorito)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _coFachada.RemoverFavorito(idFavorito);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Busca todas las publicaciones favoritas de un usuario.
        /// </summary>
        /// <returns>Una lista de publicaciones favoritas con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.</returns>
        /// <param name="idDemografia">El id del usuario para buscar sus publicaciones favoritas.</param>
        [Route("GetFavoritosPorIdDemografia")]
        [HttpGet]
        public List<ContratoPc> GetFavoritosPorIdDemografia(int idDemografia)
        {
            try
            {
                return _coFachada.GetFavoritosPorIdDemografia(idDemografia);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Valida cu�ntas publicaciones tiene un usuario.
        /// </summary>
        /// <returns>Un entero que indica cu�ntas publicaciones tiene un usuario.</returns>
        /// <param name="idDemografia">El id del usuario para validar sus publicaciones.</param>
        [Route("ValidarPublicacionesPorIdUsuario")]
        [HttpGet]
        public int ValidarPublicacionesPorIdUsuario(int idDemografia)
        {
            try
            {
                return _coFachada.ValidarPublicacionesPorIdUsuario(idDemografia);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Obtiene todas las publicaciones de un usuario.
        /// </summary>
        /// <returns>Una lista de publicaciones con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.</returns>
        /// <param name="idDemografia">El id del usuario para obtener sus publicaciones.</param>
        [Route("GetPublicacionesPorIdUsuario")]
        [HttpGet]
        public List<ContratoPc> GetPublicacionesPorIdUsuario(int idDemografia)
        {
            try
            {
                return _coFachada.GetPublicacionesPorIdUsuario(idDemografia);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
        }

        /// <summary>
        /// Obtiene todas las publicaciones que contengan descuentos.
        /// </summary>
        /// <returns>Una lista de publicaciones con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.</returns>
        [Route("GetPublicacionesPorDescuento")]
        [HttpGet]
        public List<ContratoPc> GetPublicacionesPorDescuento()
        {
            return _coFachada.GetPublicacionesPorDescuento();
        }

        /// <summary>
        /// Obtiene todas las publicaciones que contengan el par�metro dado en su nombre.
        /// </summary>
        /// <returns>Una lista de publicaciones con sus rese�as, preguntas y respuestas, categor�a y tipo de publicaci�n.</returns>
        /// <param name="nombre">El nombre de las publicaciones a filtrar.</param>
        [Route("BuscarPublicacion")]
        [HttpGet]
        public List<ContratoPc> BuscarPublicacion(string nombre)
        {
            return _coFachada.BuscarPublicacion(nombre);
        }
    }
}
