using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class UsuarioCor
    {
        public UsuarioCor()
        {
            FavoritosUsuarioProductosPcs = new HashSet<FavoritosUsuarioProductosPc>();
            NotificacionesCors = new HashSet<NotificacionesCor>();
            PedidosPeds = new HashSet<PedidosPed>();
            ProductosServiciosPcs = new HashSet<ProductosServiciosPc>();
            TruequesPedidoTrueIdcompradorNavigations = new HashSet<TruequesPedidoTrue>();
            TruequesPedidoTrueIdvendedorNavigations = new HashSet<TruequesPedidoTrue>();
        }

        public int Id { get; set; }
        public string Email { get; set; }
        public string Passwordhash { get; set; }
        public DateTime? Creacion { get; set; }
        public DateTime? Modificacion { get; set; }
        public string Estado { get; set; }
        public int Rolcorid { get; set; }
        public bool Emailconfirmed { get; set; }

        public virtual RolCor Rolcor { get; set; }
        public virtual ICollection<FavoritosUsuarioProductosPc> FavoritosUsuarioProductosPcs { get; set; }
        public virtual ICollection<NotificacionesCor> NotificacionesCors { get; set; }
        public virtual ICollection<PedidosPed> PedidosPeds { get; set; }
        public virtual ICollection<ProductosServiciosPc> ProductosServiciosPcs { get; set; }
        public virtual ICollection<TruequesPedidoTrue> TruequesPedidoTrueIdcompradorNavigations { get; set; }
        public virtual ICollection<TruequesPedidoTrue> TruequesPedidoTrueIdvendedorNavigations { get; set; }
    }
}
