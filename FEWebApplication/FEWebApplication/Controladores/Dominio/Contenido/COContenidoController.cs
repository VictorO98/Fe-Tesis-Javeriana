using Fe.Dominio.contenido.Datos;
using Fe.Dominio.contenido;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Core.General.Datos;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using FEWebApplication.Controladores.Core;
using Fe.Servidor.Middleware.Contratos.Core;
using System.Threading.Tasks;

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

        [Route("GetPublicacionPorId")]
        [HttpGet]
        public ProductosServiciosPc GetPublicacionPorId(int idPublicacion)
        {
            return _coFachada.GetPublicacionPorId(idPublicacion);
        }

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

        [Route("ModificarPublicacion")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarPublicacion(ProductosServiciosPc productosServicios)
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
        public async Task<RespuestaDatos> ModificarCategoria(CategoriaPc categoria)
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
    }
}
