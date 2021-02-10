using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class FacturasFac
    {
        public FacturasFac()
        {
            DevolucionesDevs = new HashSet<DevolucionesDev>();
            ProdSerXFacturaFacs = new HashSet<ProdSerXFacturaFac>();
        }

        public int Id { get; set; }
        public int Idpedido { get; set; }
        public DateTime? Fechafactura { get; set; }
        public DateTime? Fechaentrega { get; set; }
        public int? Valortotalfactura { get; set; }
        public int? Valortotalfacturaiva { get; set; }

        public virtual PedidosPed IdpedidoNavigation { get; set; }
        public virtual ICollection<DevolucionesDev> DevolucionesDevs { get; set; }
        public virtual ICollection<ProdSerXFacturaFac> ProdSerXFacturaFacs { get; set; }
    }
}
