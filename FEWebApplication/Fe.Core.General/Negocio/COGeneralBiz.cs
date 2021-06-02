using Fe.Core.General.Datos;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.General.Negocio
{
    public class COGeneralBiz
    {
        RepoDemografia _repoDemografia;
        RepoDocumento _repoDocumento;
        RepoPoblacion _repoPoblacion;

        public COGeneralBiz(RepoDemografia repoDemografia, RepoDocumento repoDocumento, RepoPoblacion repoPoblacion)
        {
            _repoDemografia = repoDemografia;
            _repoDocumento = repoDocumento;
            _repoPoblacion = repoPoblacion;
        }
        internal DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            return _repoDemografia.GetDemografiaPorId(idDemografia);
        }

        internal DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            return _repoDemografia.GetDemografiaPorEmail(emailDemografia);
        }

        internal TipoDocumentoCor GetTipoDocumentoPorId(int idTipoDocumento)
        {
            return _repoDocumento.GetTipoDocumentoPorId(idTipoDocumento);
        }

        internal List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            return _repoPoblacion.GetPoblacionPorIdEstado(idEstado);
        }

        internal List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            return _repoPoblacion.GetEstadoPoblacion();
        }

        internal List<TipoDocumentoCor> GetTipoDocumento()
        {
            return _repoDocumento.GetTipoDocumento();
        }

        internal async Task<RespuestaDatos> GuardarDemografia(DemografiaCor demografia)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _repoDemografia.GuardarDemografia(demografia);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
    }
}
