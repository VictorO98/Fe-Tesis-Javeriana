using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Pedidos
{
    public class ContratoDetallesPedido
    {
        public int Id { get; set; }
        public int? Precio { get; set; }
        public int? Cantidad { get; set; }

        public virtual PedidosPed IdpedidoNavigation { get; set; }
        public virtual ProductosServiciosPc IdproductoservicoNavigation { get; set; }
    }
}

