using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Dominio.trueques.Datos;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Dominio.trueques.Negocio
{
    public class TRTruequeBiz
    {
        private readonly RepoTrueque _repoTrueque;
        private readonly RepoTruequeDetalle _repoTruequeDetalle;
        
        public TRTruequeBiz(RepoTrueque repoTrueque, RepoTruequeDetalle repoTruequeDetalle)
        {
            _repoTrueque = repoTrueque;
            _repoTruequeDetalle = repoTruequeDetalle;
        }

        internal async Task<RespuestaDatos> GuardarTrueque(TruequesPedidoTrue trueque, DemografiaCor demografiaVendedor, 
            DemografiaCor demografiaComprador)
        {
            RespuestaDatos respuestaDatos;
            if (demografiaVendedor != null)
            {
                if (demografiaComprador != null)
                {
                    if(demografiaVendedor.Rolcorid == CORol.EMPRENDEDOR && demografiaComprador.Rolcorid == CORol.EMPRENDEDOR)
                    {
                        try
                        {
                            respuestaDatos = await _repoTrueque.GuardarTrueque(trueque);
                        }
                        catch (COExcepcion e)
                        {
                            throw e;
                        }
                    } else { throw new COExcepcion("El vendedor/comprador ingresado no es un emprendedor."); }
                } else { throw new COExcepcion("El comprador ingresado no existe."); }
            } else { throw new COExcepcion("El vendedor ingresado no existe."); }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarTrueque(TruequesPedidoTrue trueque)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                TruequesPedidoTrue t = _repoTrueque.GetTruequePorIdTrueque(trueque.Id);
                if (t.Estado == COEstadosTrueque.OFERTADO)
                {
                    if(trueque.Estado == COEstadosTrueque.ACEPTADO)
                    {
                        respuestaDatos = await _repoTrueque.ModificarTrueque(trueque, COEstadosTrueque.ACEPTADO);
                    }
                    else
                    {
                        if (trueque.Estado == COEstadosTrueque.RECHAZADO)
                        {
                            respuestaDatos = await _repoTrueque.ModificarTrueque(trueque, COEstadosTrueque.RECHAZADO);
                        } else { throw new COExcepcion("El estado ingresado es inválido."); }
                    }
                }
                else { throw new COExcepcion("El trueque no puede ser modificado."); }
            }
            catch (COExcepcion e) { throw e; }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> GuardarTruequeDetalle(ProdSerTruequeTrue detalle, ProductosServiciosPc publicacionVendedor,
            ProductosServiciosPc publicacionComprador)
        {
            RespuestaDatos respuestaDatos;
            if (publicacionVendedor != null)
            {
                if (publicacionComprador != null)
                {
                    if (detalle.Cantidadcomprador <= publicacionComprador.Cantidadtotal)
                    {
                        if (detalle.Cantidadvendedor <= publicacionVendedor.Cantidadtotal)
                        {
                            try
                            {
                                respuestaDatos = await _repoTruequeDetalle.GuardarTruequeDetalle(detalle);
                            }
                            catch (COExcepcion e)
                            {
                                throw e;
                            }
                        } else { throw new COExcepcion("La cantidad de la publicación del vendedor es inválida."); }
                    } else { throw new COExcepcion("La cantidad de la publicación del comprador es inválida."); }
                } else { throw new COExcepcion("La publicación ingresada del comprador no existe."); }
            } else { throw new COExcepcion("La publicación ingresada del vendedor no existe."); }
            return respuestaDatos;
        }

        internal List<TruequesPedidoTrue> GetTrueques()
        {
            return _repoTrueque.GetTrueques();
        }

        internal List<TruequesPedidoTrue> GetTruequesPorIdVendedor(int idVendedor)
        {
            var cabeceraTrueque = _repoTrueque.GetTruequesPorIdVendedor(idVendedor);
            for (int i = 0; i < cabeceraTrueque.Count; i++)
            {
                cabeceraTrueque[i].ProdSerTruequeTrues = _repoTrueque.GetDetalleTruequePorIdTrueque(cabeceraTrueque[i].Id);
            }
            return cabeceraTrueque;
        }

        internal List<TruequesPedidoTrue> GetTruequesPorIdComprador(int idComprador)
        {
            var cabeceraTrueque = _repoTrueque.GetTruequesPorIdComprador(idComprador);
            for (int i = 0; i < cabeceraTrueque.Count; i++)
            {
                cabeceraTrueque[i].ProdSerTruequeTrues = _repoTrueque.GetDetalleTruequePorIdTrueque(cabeceraTrueque[i].Id);
            }
            return cabeceraTrueque;
        }

        internal ProdSerTruequeTrue GetDetallePorIdTrueque(int idTrueque)
        {
            return _repoTruequeDetalle.GetDetallePorIdTrueque(idTrueque);
        }

        internal TruequesPedidoTrue GetTruequePorIdCompradorIdVendedor(int idComprador, int idVendedor)
        {
            return _repoTrueque.GetTruequePorIdCompradorIdVendedor(idComprador, idVendedor);
        }
    }
}
