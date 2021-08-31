using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ProdSerXFacturaFac
    {
        public int Id { get; set; }
        public int? Preciofacturado { get; set; }
        public int? Cantidadfacturado { get; set; }
        public int? Idproductoservicio { get; set; }
        public int Idfactura { get; set; }
        public int Idvendedor { get; set; }

        public virtual FacturasFac IdfacturaNavigation { get; set; }
    }
}
