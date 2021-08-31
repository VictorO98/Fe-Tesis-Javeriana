using EpaycoSdk;
using EpaycoSdk.Models;
using EpaycoSdk.Models.Bank;
using Fe.Core.Global.Constantes;
using Fe.Dominio.facturas;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Dominio.Factura;
using Fe.Servidor.Middleware.Modelo.Entidades;
using FEWebApplication.Controladores.Core;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Dominio.Factura
{
    /// <summary>
    /// Servicios para realizar transacciones y CRUD de Factura
    /// y su respectivo detalle
    /// </summary>
    [Route("factura/[controller]")]
    public class FAFacturaController : COApiController
    {
        private readonly FAFachada _fAFachada;

        public FAFacturaController(FAFachada fAFachada)
        {
            _fAFachada = fAFachada;
        }

        /// <summary>
        /// Se realiza un pago con tarjeta de crédito y se almacena la factura una vez que ha sido aprobada.
        /// </summary>
        /// <returns>Respuesta de datos indicando la factura.</returns>
        /// <param name="contratoTC">Información necesaria para realizar la transacción con tarjeta de crédito.</param>
        [Route("PagoConTC")]
        [HttpPost]
        public string PagoConTC([FromBody] ContratoTC contratoTC)
        {
            string respuesta = null;
            try
            {
                respuesta = _fAFachada.PagoConTC(contratoTC);
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine(e.InnerException);
                Console.WriteLine(e.StackTrace);
            }
            return respuesta;
        }

        /// <summary>
        /// Se realiza un pago mediante PSE y se almacena la factura una vez que ha sido aprobada.
        /// </summary>
        /// <returns>Respuesta de datos indicando la factura.</returns>
        /// <param name="contratoPSE">Información necesaria para realizar la transacción mediante PSE.</param>
        [Route("PagoPSE")]
        [HttpPost]
        public string PagoPSE([FromBody] ContratoPSE contratoPSE)
        {
            string respuesta = "";
            try
            {
                respuesta = _fAFachada.PagoPSE(contratoPSE);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                Console.WriteLine(e.InnerException);
                Console.WriteLine(e.StackTrace);
            }
            return respuesta;
        }
    }
}
