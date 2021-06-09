using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ProductosFavoritosDemografiaPc
    {
        public int Id { get; set; }
        public int Iddemografia { get; set; }
        public int Idproductoservicio { get; set; }

        public virtual DemografiaCor IddemografiaNavigation { get; set; }
        public virtual ProductosServiciosPc IdproductoservicioNavigation { get; set; }
    }
}
