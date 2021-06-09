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

namespace FEWebApplication.Controladores.Dominio.Contenido
{
    [Route("dominio/[controller]")]
    public class COContenidoController : COApiController
    {   
        private readonly COFachada _coFachada;

        public COContenidoController(COFachada cOFachada)
        {
            _coFachada = cOFachada;
        }

        [Route("GetCategorias")]
        [HttpGet]
        public List<CategoriaPc> GetCategorias()
        {
            return _coFachada.GetCategorias();
        }

        [Route("GetCategoriaPorIdCategoria")]
        [HttpGet]
        public CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            return _coFachada.GetCategoriaPorIdCategoria(idCategoria);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
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

        [Route("GetPublicacionPorIdPublicacion")]
        [HttpGet]
        public ProductosServiciosPc GetPublicacionPorIdPublicacion(int idPublicacion)
        {
            return _coFachada.GetPublicacionPorIdPublicacion(idPublicacion);
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
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

        [Route("GetResenaPorIdResena")]
        [HttpGet]
        public ResenasPc GetResenaPorIdResena(int idResena)
        {
            return _coFachada.GetResenaPorIdResena(idResena);
        }

        [Route("GetResenasPorIdPublicacion")]
        [HttpGet]
        public ICollection<ResenasPc> GetResenasPorIdPublicacion(int idPublicacion)
        {
            return _coFachada.GetResenasPorIdPublicacion(idPublicacion);
        }

        [Route("GetPreguntasyRespuestasPorIdPublicacion")]
        [HttpGet]
        public List<PreguntasRespuestasPc> GetPreguntasyRespuestasPorIdPublicacion(int idPublicacion)
        {
            return _coFachada.GetPreguntasyRespuestasPorIdPublicacion(idPublicacion);
        }

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

        [Route("DesplegarPublicacion")]
        [HttpGet]
        public ContratoPc DesplegarPublicacion(int idPublicacion)
        {
            return _coFachada.DesplegarPublicacion(idPublicacion);
        }

        [Route("FiltrarPublicacion")]
        [HttpGet]
        public List<ContratoPc> FiltrarPublicacion(int idPublicacion = -1, int idCategoria = -1, int idTipoPublicacion = -1, 
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

    }
}
