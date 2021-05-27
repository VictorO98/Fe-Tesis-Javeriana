using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class PedidosPed
    {
        public PedidosPed()
        {
            DevolucionesDevs = new HashSet<DevolucionesDev>();
            FacturasFacs = new HashSet<FacturasFac>();
            ProdSerXVendidosPeds = new HashSet<ProdSerXVendidosPed>();
        }

        public int Id { get; set; }
        public int Idusuario { get; set; }
        public string Estado { get; set; }
        public DateTime? Fechapedido { get; set; }

        public virtual DemografiaCor IdusuarioNavigation { get; set; }
        public virtual ICollection<DevolucionesDev> DevolucionesDevs { get; set; }
        public virtual ICollection<FacturasFac> FacturasFacs { get; set; }
        public virtual ICollection<ProdSerXVendidosPed> ProdSerXVendidosPeds { get; set; }
    }
}
