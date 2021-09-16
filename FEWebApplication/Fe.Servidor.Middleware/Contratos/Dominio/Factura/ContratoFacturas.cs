using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Factura
{
    public class ContratoFacturas
    {
        public int Id { get; set; }
        public string Estado { get; set; }
        public DateTime? Fechafactura { get; set; }
        public DateTime? Fechaentrega { get; set; }
        public int? Valortotalfactura { get; set; }
        public int? Valortotalfacturaiva { get; set; }
        public int? Idvendedor { get; set; }
        public virtual List<ContratoDetallesFactura> Productos { get; set; }

        public virtual DemografiaCor IdusuarioNavigation { get; set; }
        public virtual List<ProdSerXVendidosPed> ProdSerXVendidosPeds { get; set; }
    }
}