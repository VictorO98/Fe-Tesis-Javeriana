using Fe.Core.General.Datos;
using Fe.Core.General.Negocio;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Fe.Core.General
{
    public class COGeneralFachada   
    {
        private readonly COGeneralBiz _cOGeneralBiz;

        public COGeneralFachada(COGeneralBiz coGeneralBiz)
        {
            _cOGeneralBiz = coGeneralBiz;
        }

        public DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            return _cOGeneralBiz.GetDemografiaPorId(idDemografia);
        }

        public DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            return _cOGeneralBiz.GetDemografiaPorEmail(emailDemografia);
        }

        public List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            return _cOGeneralBiz.GetEstadoPoblacion();
        }

        public List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            return _cOGeneralBiz.GetPoblacionPorIdEstado(idEstado);
        }

        public TipoDocumentoCor GetTipoDocumentoPorId(int idTipoDocumento)
        {
            return _cOGeneralBiz.GetTipoDocumentoPorId(idTipoDocumento);
        }

        public List<TipoDocumentoCor> GetTipoDocumento()
        {
            return _cOGeneralBiz.GetTipoDocumento();
        }

        public async Task<RespuestaDatos> GuardarDemografia(DemografiaCor demografia)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _cOGeneralBiz.GuardarDemografia(demografia);
            }
            catch(COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
