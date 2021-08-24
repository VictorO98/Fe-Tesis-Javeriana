using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Factura
{
    public partial class ContratoTC
    {
        public int IdDemografiaComprador { get; set; }
        public String NumeroTC { get; set; }
        public int AnioTC { get; set; }
        public int MesTC { get; set; }
        public int CvcTC { get; set; }
        public int IdPedido { get; set; }
        public int Cuotas { get; set; }


    }
}
