
using Fe.Core.General;
using Fe.Core.Seguridad.Negocio;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
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

        public async Task<RespuestaDatos> SubirDocumentosEmprendedor(string correoUsuario, string razonSoccial, IFormFileCollection files)
        {
            DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorEmail(correoUsuario);
            return await _cOSeguridadBiz.SubirDocumentosEmprendedor(demografiaCor, razonSoccial, files);

        }

        public async Task<RespuestaDatos> ModificarDemografia(ModificarDemografia model)
        {
            DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorEmail(model.Correo);
            return await _cOSeguridadBiz.ModificarDemografia(model, demografiaCor);

        }

        public async Task<RespuestaDatos> SubirImagenSocial(string correoUsuario, IFormFileCollection files)
        {
            DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorEmail(correoUsuario);
            return await _cOSeguridadBiz.SubirImagenSocial(files, demografiaCor);
        }

        public async Task<string> GetImagenSocial(string correoUsuario)
        {
            DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorEmail(correoUsuario);
            return await _cOSeguridadBiz.GetImagenSocial(demografiaCor);
        }

        public async Task<bool> IsImagen(string correoUsuario)
        {
            DemografiaCor demografiaCor = _cOGeneralFachada.GetDemografiaPorEmail(correoUsuario);
            return await _cOSeguridadBiz.IsImagen(demografiaCor);
        }
    }
}
