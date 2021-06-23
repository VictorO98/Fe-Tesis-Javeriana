using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Pedidos
{
    public class ContratoPedidos
    {
        public int Id { get; set; }
        public virtual List<ContratoDetallesPedido> Productos { get; set; }

        public virtual DemografiaCor IdusuarioNavigation { get; set; }
        public virtual List<ProdSerXVendidosPed> ProdSerXVendidosPeds { get; set; }
    }
}
