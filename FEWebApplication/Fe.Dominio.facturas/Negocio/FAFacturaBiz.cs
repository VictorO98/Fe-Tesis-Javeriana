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
        Epayco epayco = new EpaycoSdk.Epayco(
          "8f095995bc9eebac37cdbfbbb1ec7b63", //public_key
          "1ca543d6550342296aac93a73deb4e97", //private_key
          "ES", //language
          false //test 
        );

        public String PagoConTC(ContratoTC contratoTC, 
            List<ProdSerXVendidosPed> listaPedido, 
            List<DemografiaCor> listaDemografiaPedido,
            DemografiaCor demografiaComprador,
            TipoDocumentoCor documentoComprador)
        {
            int? total = 0;
            foreach(ProdSerXVendidosPed p in listaPedido) {
                total = total + p.Preciototal;
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

            SplitModel splitData = new SplitModel();
            splitData.splitpayment = "true";
            splitData.split_app_id = COEpayco.EPAYCO_IDBUYA;
            splitData.split_merchant_id = COEpayco.EPAYCO_IDBUYA;
            splitData.split_type = "02";
            splitData.split_primary_receiver = COEpayco.EPAYCO_IDBUYA;
            splitData.split_primary_receiver_fee = "0";
            splitData.split_rule = "multiple";
            List<SplitReceivers> splitReceivers = new List<SplitReceivers>();
            for(int i = 0; i < listaDemografiaPedido.Count; i++)
            {
                splitReceivers.Add(new SplitReceivers() { id = listaDemografiaPedido[i].Idepayco.ToString(), 
                    fee = "2", total = listaPedido[i].Preciototal.ToString(), fee_type = "02" });
                Console.WriteLine(listaDemografiaPedido[i].Idepayco);
            }
            splitData.split_receivers = splitReceivers;

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
                "ip",
                "extra1",
                "extra2",
                "extra3",
                "extra4",
                "extra5",
                "extra6",
                "extra7",
                "extra8",
                "extra9",
                "extra10",
                splitData
            );

            // TODO: Si el response.status == Aceptado, realizar la facturación, si es false, realizar su debido proceso.
            return response.data.status;
        }

        public bool PagoPSE(ContratoPSE contratoPSE,
            List<ProdSerXVendidosPed> listaPedido,
            List<DemografiaCor> listaDemografiaPedido,
            DemografiaCor demografiaComprador,
            TipoDocumentoCor documentoComprador)
        {

            int? total = 0;
            foreach (ProdSerXVendidosPed p in listaPedido)
            {
                total = total + p.Preciototal;
            }

            List<SplitReceivers> splitReceivers = new List<SplitReceivers>();
            for (int i = 0; i < listaDemografiaPedido.Count; i++)
            {
                splitReceivers.Add(new SplitReceivers()
                {
                    id = listaDemografiaPedido[i].Idepayco.ToString(),
                    fee = "2",
                    total = listaPedido[i].Preciototal.ToString(),
                    fee_type = "02"
                });
            }

            PseModel response = epayco.BankCreateSplit(
              COEpayco.CODIGO_BANCARIO[contratoPSE.Banco],
              contratoPSE.IdPedido.ToString(), // ID de factura
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
              "method_confirmation",

              "true", // true or false
              COEpayco.EPAYCO_IDBUYA,
              COEpayco.EPAYCO_IDBUYA,
              "01", // 01 para dispersión fija, 02 para dispersión porcentual
              COEpayco.EPAYCO_IDBUYA,
              "0",

              //TODO: Este valor puede que no funcione. Probar con un objeto de tipo SplitModel como en Tarjeta de Crédito
              //TODO: Si no funciona, convertir ese SplitModel a un objeto JSON mediante alguna función
              splitReceivers // Este sería un array de tipo SplitReceivers el cual se inicializa al principio del método es un campo opcional y es obligatorio sí se envía split_rule
            );

            // TODO: Si el response.success == True, realizar la facturación, si es false, realizar su debido proceso.
            return response.success;
        }
    }
}
