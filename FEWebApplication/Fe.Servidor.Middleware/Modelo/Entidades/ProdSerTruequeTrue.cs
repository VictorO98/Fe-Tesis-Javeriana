using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ProdSerTruequeTrue
    {
        public int Id { get; set; }
        public int Idtruequepedido { get; set; }
        public int Idproductoserviciocomprador { get; set; }
        public int Idproductoserviciovendedor { get; set; }
        public int? Cantidadcomprador { get; set; }
        public int? Cantidadvendedor { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ProductosServiciosPc IdproductoserviciocompradorNavigation { get; set; }
        public virtual ProductosServiciosPc IdproductoserviciovendedorNavigation { get; set; }
        public virtual TruequesPedidoTrue IdtruequepedidoNavigation { get; set; }
    }
}
