using Fe.Core.General.Datos;
using Fe.Core.General.Negocio;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace FEWebApplication.Controladores.Core
{
    [Route("core/[controller]")]
    public class COGeneralController : COApiController
    {
        private readonly RepoDocumento _repoDocumento = new RepoDocumento();
        private readonly RepoPoblacion _repoPoblacion = new RepoPoblacion();
        private readonly COGeneralBiz _cOGeneralBiz;

        public COGeneralController(COGeneralBiz cOGeneralBiz)
        {
            _cOGeneralBiz = cOGeneralBiz;
        }

        [Route("GetEstadoPoblacion")]
        [HttpGet]
        public List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            return _repoPoblacion.GetEstadoPoblacion();
        }

        [Route("GetPoblacionPorIdEstado")]
        [HttpGet]
        public List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            return _repoPoblacion.GetPoblacionPorIdEstado(idEstado);
        }

        [Route("GetTipoDocumento")]
        [HttpGet]
        public List<TipoDocumentoCor> GetTipoDocumento()
        {
            return _repoDocumento.GetTipoDocumento();
        }
    }
}
