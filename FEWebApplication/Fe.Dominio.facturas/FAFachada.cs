using Fe.Core.General;
using Fe.Dominio.contenido;
using Fe.Dominio.facturas.Negocio;
using Fe.Dominio.pedidos;
using Fe.Servidor.Middleware.Contratos.Dominio.Factura;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Fe.Dominio.facturas
{
    public class FAFachada
    {
        private readonly FAFacturaBiz _fAFacturaBiz;
        private readonly PEFachada _pEFachada;
        private readonly COGeneralFachada _cOGeneralFachada;

        public FAFachada(FAFacturaBiz fAFacturaBiz, PEFachada pEFachada, COGeneralFachada cOGeneralFachada)
        {
            _fAFacturaBiz = fAFacturaBiz;
            _pEFachada = pEFachada;
            _cOGeneralFachada = cOGeneralFachada;
        }

        public string PagoConTC(ContratoTC contratoTC)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoTC.IdPedido);
            DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(contratoTC.IdDemografiaComprador);
            TipoDocumentoCor documentoComprador = _cOGeneralFachada.GetTipoDocumentoPorId(demografiaComprador.Tipodocumentocorid);
            return _fAFacturaBiz.PagoConTC(contratoTC, listaPedido, demografiaComprador, documentoComprador);
        }

        public string PagoPSE(ContratoPSE contratoPSE)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoPSE.IdPedido);
            DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(contratoPSE.IdDemografiaComprador);
            TipoDocumentoCor documentoComprador = _cOGeneralFachada.GetTipoDocumentoPorId(demografiaComprador.Tipodocumentocorid);
            return _fAFacturaBiz.PagoPSE(contratoPSE, listaPedido, demografiaComprador, documentoComprador);
        }
    }
}
