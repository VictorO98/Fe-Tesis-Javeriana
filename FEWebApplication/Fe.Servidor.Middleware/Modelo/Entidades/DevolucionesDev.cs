using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class DevolucionesDev
    {
        public DevolucionesDev()
        {
            DevolucionesDetalleDevs = new HashSet<DevolucionesDetalleDev>();
        }

        public int Id { get; set; }
        public int Idpedido { get; set; }
        public int Idfactura { get; set; }
        public DateTime? Fecha { get; set; }
        public string Estado { get; set; }

        public virtual FacturasFac IdfacturaNavigation { get; set; }
        public virtual PedidosPed IdpedidoNavigation { get; set; }
        public virtual ICollection<DevolucionesDetalleDev> DevolucionesDetalleDevs { get; set; }
    }
}
