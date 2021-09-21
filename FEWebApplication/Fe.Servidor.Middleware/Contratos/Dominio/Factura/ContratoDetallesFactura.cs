using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Factura
{
    public class ContratoDetallesFactura
    {
        public int Id { get; set; }
        public int? Preciofacturado { get; set; }
        public int? Cantidadfacturado { get; set; }
        public int? Idproductoservicio { get; set; }

        public virtual PedidosPed IdpedidoNavigation { get; set; }
        public virtual ProductosServiciosPc IdproductoservicoNavigation { get; set; }
    }
}