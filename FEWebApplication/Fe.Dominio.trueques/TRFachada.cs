using Fe.Core.General;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Dominio.contenido;
using Fe.Dominio.trueques.Negocio;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Fe.Dominio.trueques
{
    public class TRFachada
    {
        private readonly TRTruequeBiz _tRTruequeBiz;
        private readonly COGeneralFachada _cOGeneralFachada;
        private readonly COFachada _cOFachada;
        public TRFachada(TRTruequeBiz tRTruequeBiz, COGeneralFachada cOGeneralFachada, COFachada cOFachada)
        {
            _tRTruequeBiz = tRTruequeBiz;
            _cOGeneralFachada = cOGeneralFachada;
            _cOFachada = cOFachada;
        }

        public async Task<RespuestaDatos> GuardarTrueque(TruequesPedidoTrue trueque)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                DemografiaCor demografiaVendedor = _cOGeneralFachada.GetDemografiaPorId(trueque.Idvendedor);
                DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(trueque.Idcomprador);
                respuestaDatos = respuestaDatos = await _tRTruequeBiz.GuardarTrueque(trueque, demografiaVendedor, demografiaComprador);
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public async Task<RespuestaDatos> ModificarTrueque(TruequesPedidoTrue trueque)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = respuestaDatos = await _tRTruequeBiz.ModificarTrueque(trueque);
                if(trueque.Estado == COEstadosTrueque.ACEPTADO)
                {
                    ProdSerTruequeTrue detalle = _tRTruequeBiz.GetDetallePorIdTrueque(trueque.Id);
                    ProductosServiciosPc publicacionVendedor = _cOFachada.GetPublicacionPorIdPublicacion(detalle.Idproductoserviciovendedor);
                    ProductosServiciosPc publicacionComprador = _cOFachada.GetPublicacionPorIdPublicacion(detalle.Idproductoserviciocomprador);
                    publicacionComprador.Cantidadtotal = (int)(publicacionComprador.Cantidadtotal - detalle.Cantidadcomprador);
                    publicacionVendedor.Cantidadtotal = (int)(publicacionVendedor.Cantidadtotal - detalle.Cantidadvendedor);
                    RespuestaDatos modificarVendedor = await _cOFachada.ModificarPublicacion(publicacionVendedor);
                    RespuestaDatos modificarComprador = await _cOFachada.ModificarPublicacion(publicacionComprador);
                    respuestaDatos.Mensaje = respuestaDatos.Mensaje + " " + modificarVendedor.Mensaje + " " + modificarComprador.Mensaje;
                }
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }
        public async Task<RespuestaDatos> GuardarTruequeDetalle(ProdSerTruequeTrue detalle)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                ProductosServiciosPc publicacionComprador = _cOFachada.GetPublicacionPorIdPublicacion(detalle.Idproductoserviciocomprador);
                ProductosServiciosPc publicacionVendedor = _cOFachada.GetPublicacionPorIdPublicacion(detalle.Idproductoserviciovendedor);
                DemografiaCor demografiaComprador = _cOGeneralFachada.GetDemografiaPorId(publicacionComprador.Idusuario);
                DemografiaCor demografiaVendedor = _cOGeneralFachada.GetDemografiaPorId(publicacionVendedor.Idusuario);
                TruequesPedidoTrue trueque = new TruequesPedidoTrue
                {
                    Idcomprador = demografiaComprador.Id,
                    Idvendedor = demografiaVendedor.Id
                };
                respuestaDatos = await _tRTruequeBiz.GuardarTrueque(trueque, demografiaComprador, demografiaVendedor);
                trueque = GetTruequePorIdCompradorIdVendedor(demografiaComprador.Id, demografiaVendedor.Id);
                detalle.Idtruequepedido = trueque.Id;
                RespuestaDatos respuestaDetalle = await _tRTruequeBiz.GuardarTruequeDetalle(detalle, publicacionVendedor, publicacionComprador);
                respuestaDatos.Mensaje = respuestaDatos.Mensaje + " " + respuestaDetalle.Mensaje;
            }
            catch (COExcepcion e)
            {
                throw e;
            }
            return respuestaDatos;
        }

        public List<TruequesPedidoTrue> GetTrueques()
        {
            return _tRTruequeBiz.GetTrueques();
        }

        public List<TruequesPedidoTrue> GetTruequesPorIdVendedor(int idVendedor)
        {
            return _tRTruequeBiz.GetTruequesPorIdVendedor(idVendedor);
        }

        public List<TruequesPedidoTrue> GetTruequesPorIdComprador(int idComprador)
        {
            return _tRTruequeBiz.GetTruequesPorIdComprador(idComprador);
        }

        public ProdSerTruequeTrue GetDetallePorIdTrueque(int idTrueque)
        {
            return _tRTruequeBiz.GetDetallePorIdTrueque(idTrueque);
        }

        internal TruequesPedidoTrue GetTruequePorIdCompradorIdVendedor(int idComprador, int idVendedor)
        {
            return _tRTruequeBiz.GetTruequePorIdCompradorIdVendedor(idComprador, idVendedor);
        }
    }
}
