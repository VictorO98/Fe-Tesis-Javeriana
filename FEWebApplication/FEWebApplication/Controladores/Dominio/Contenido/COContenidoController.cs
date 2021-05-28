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
    }
}
