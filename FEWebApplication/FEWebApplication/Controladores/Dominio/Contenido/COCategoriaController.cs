using Fe.Dominio.contenido.Datos;
using Fe.Dominio.contenido;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Core.General.Datos;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace FEWebApplication.Controladores.Dominio.Contenido
{
    [Route("contenido/[controller]")]
    public class COCategoriaController : COCategoriaApiController
    {   
        private readonly COFachada _coFachada;

        public COCategoriaController(COFachada cOFachada)
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
    }
}
