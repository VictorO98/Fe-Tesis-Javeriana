using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Factura
{
    public partial class ContratoFacturaPSE
    {
        public int IdPedido { get; set; }
        public String TicketId { get; set; }
    }
}
