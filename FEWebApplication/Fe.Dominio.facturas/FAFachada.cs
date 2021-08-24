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
        private readonly COFachada _cOFachada;

        public FAFachada(FAFacturaBiz fAFacturaBiz, PEFachada pEFachada, COGeneralFachada cOGeneralFachada, COFachada cOFachada)
        {
            _fAFacturaBiz = fAFacturaBiz;
            _pEFachada = pEFachada;
            _cOGeneralFachada = cOGeneralFachada;
            _cOFachada = cOFachada;
        }

        public async Task<String> PagoConTC(ContratoTC contratoTC)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoTC.IdPedido);
            List<DemografiaCor> listaDemografiaPedido = new List<DemografiaCor>();
            DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(contratoTC.IdDemografiaComprador);
            foreach(ProdSerXVendidosPed p in listaPedido)
            {
                ProductosServiciosPc publicacion = await _cOFachada.GetPublicacionPorIdPublicacion(p.Idproductoservico);
                DemografiaCor demografia = _cOGeneralFachada.GetDemografiaPorId(publicacion.Idusuario);
                listaDemografiaPedido.Add(demografia);
            };
            TipoDocumentoCor documentoComprador = _cOGeneralFachada.GetTipoDocumentoPorId(demografiaComprador.Tipodocumentocorid);
            return _fAFacturaBiz.PagoConTC(contratoTC, listaPedido, listaDemografiaPedido, demografiaComprador, documentoComprador);
        }

        public async Task<bool> PagoPSE(ContratoPSE contratoPSE)
        {
            List<ProdSerXVendidosPed> listaPedido = _pEFachada.GetProductosPedidosPorIdPedido(contratoPSE.IdPedido);
            List<DemografiaCor> listaDemografiaPedido = new List<DemografiaCor>();
            DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(contratoPSE.IdDemografiaComprador);
            foreach (ProdSerXVendidosPed p in listaPedido)
            {
                ProductosServiciosPc publicacion = await _cOFachada.GetPublicacionPorIdPublicacion(p.Idproductoservico);
                DemografiaCor demografia = _cOGeneralFachada.GetDemografiaPorId(publicacion.Idusuario);
                listaDemografiaPedido.Add(demografia);
            };
            TipoDocumentoCor documentoComprador = _cOGeneralFachada.GetTipoDocumentoPorId(demografiaComprador.Tipodocumentocorid);
            return _fAFacturaBiz.PagoPSE(contratoPSE, listaPedido, listaDemografiaPedido, demografiaComprador, documentoComprador);
        }
    }
}
