using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Factura
{
    public partial class ContratoPSE
    {
        public int IdDemografiaComprador { get; set; }
        public int IdPedido { get; set; }
        public String Banco { get; set; }
    }
}
