using EpaycoSdk;
using EpaycoSdk.Models;
using EpaycoSdk.Models.Bank;
using EpaycoSdk.Models.Charge;
using Fe.Core.Global.Constantes;
using Fe.Servidor.Middleware.Contratos.Dominio.Factura;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;

namespace Fe.Dominio.facturas.Negocio
{
    public class FAFacturaBiz
    {

        // TODO: Cambiar llave publica y privada a los de la fundacion
        readonly Epayco epayco = new Epayco(
          "c7e7b10c02ddb910e5a58db9f46f7217", //public_key
          "158873dad66300d10b9a2f5240866b8a", //private_key
          "ES", //language
          true //test 
        );

        public string PagoConTC(ContratoTC contratoTC, 
            List<ProdSerXVendidosPed> listaPedido, 
            DemografiaCor demografiaComprador,
            TipoDocumentoCor documentoComprador)
        {
            int? total = 0;
            foreach(ProdSerXVendidosPed p in listaPedido) {
                total += p.Preciototal;
            }
            TokenModel token = epayco.CreateToken(
              contratoTC.NumeroTC, //cardNumber
              contratoTC.AnioTC.ToString(), //expYear
              contratoTC.MesTC.ToString(), //expMonth
              contratoTC.CvcTC.ToString() //cvc
            );

            CustomerCreateModel customer = epayco.CustomerCreate(
              token.id, //string
              demografiaComprador.Nombre, //string
              demografiaComprador.Apellido, //string
              demografiaComprador.Email, //string 
              true //boolean
            );

            ChargeModel response = epayco.ChargeCreate(
                token.id,
                customer.data.customerId,
                documentoComprador.Codigo,
                demografiaComprador.Numerodocumento.ToString(),
                demografiaComprador.Nombre,
                demografiaComprador.Apellido,
                demografiaComprador.Email,
                contratoTC.IdPedido.ToString(),
                "Pedido numero " + contratoTC.IdPedido.ToString(),
                total.ToString(),
                "0", // tax
                "0", // tax base
                "COP",
                contratoTC.Cuotas.ToString(),
                demografiaComprador.Direccion,
                demografiaComprador.Telefono.ToString(),
                demografiaComprador.Telefono.ToString(),
                "url_response",
                "url_confirmation",
                // TODO: Obtener IP
                "ip"
            );


            // TODO: Si el response.estado == Aceptado, realizar la facturación, si es false, realizar su debido proceso.
            return response.data.estado;
        }

        public string PagoPSE(ContratoPSE contratoPSE,
            List<ProdSerXVendidosPed> listaPedido,
            DemografiaCor demografiaComprador,
            TipoDocumentoCor documentoComprador)
        {

            int? total = 0;
            foreach (ProdSerXVendidosPed p in listaPedido)
            {
                total += p.Preciototal;
            }

            PseModel response = epayco.BankCreate(
              COEpayco.CODIGO_BANCARIO[contratoPSE.Banco],
              contratoPSE.Bill.ToString(), // ID de factura
              "Pedido numero" + contratoPSE.IdPedido.ToString(),
              total.ToString(),
              "0",
              "0",
              "COP",
              "0", // 0 para persona, 1 para comercio
              documentoComprador.Codigo,
              demografiaComprador.Numerodocumento.ToString(),
              demografiaComprador.Nombre,
              demografiaComprador.Apellido,
              demografiaComprador.Email,
              "CO",
              demografiaComprador.Telefono.ToString(),
              "url_response",
              "url_confirmation",
              "method_confirmation"
            );

            // TODO: Si el response.success == True, realizar la facturación, si es false, realizar su debido proceso.
            // TODO: response.data.urlbanco contiene un link que tiene que recibir el front end y entregar al cliente para
            // TODO: finalizar la transacción en la página de PSE.
            if(response.success)
            {
                return response.data.urlbanco;
            }
            return "";
        }
    }
}
