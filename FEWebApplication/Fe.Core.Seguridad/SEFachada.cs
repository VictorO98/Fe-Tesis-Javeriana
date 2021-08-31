
using Fe.Core.General;
using Fe.Core.Seguridad.Negocio;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.Seguridad
{
    public class SEFachada
    {
        private readonly COGeneralFachada _cOGeneralFachada;
        private readonly COSeguridadBiz _cOSeguridadBiz;

        public SEFachada(COGeneralFachada cOGeneralFachada, COSeguridadBiz cOSeguridadBiz)
        {
            _cOGeneralFachada = cOGeneralFachada;
            _cOSeguridadBiz = cOSeguridadBiz;
        }

        public async Task<RespuestaDatos> SubirDocumentosEmprendedor(string correoUsuario, IFormFileCollection files)
        {
            DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorEmail(correoUsuario);
            return await _cOSeguridadBiz.SubirDocumentosEmprendedor(demografiaCor, files);

        }
    }
}
