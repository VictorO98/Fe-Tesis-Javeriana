using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class FavoritosUsuarioProductosPc
    {
        public int Id { get; set; }
        public int? IdProductoServicio { get; set; }
        public DateTime Creacion { get; set; }
        public string[] Estado { get; set; }
        public int? IdUsuario { get; set; }

        public virtual ProductosServiciosPc IdProductoServicioNavigation { get; set; }
    }
}
