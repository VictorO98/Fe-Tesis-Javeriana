using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ProdSerXVendidosPed
    {
        public int Id { get; set; }
        public int Idproductoservico { get; set; }
        public int Idpedido { get; set; }
        public int? Preciototal { get; set; }
        public int? Cantidadespedida { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual PedidosPed IdpedidoNavigation { get; set; }
        public virtual ProductosServiciosPc IdproductoservicoNavigation { get; set; }
    }
}
