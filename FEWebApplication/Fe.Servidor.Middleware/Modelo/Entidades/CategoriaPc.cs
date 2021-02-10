using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class CategoriaPc
    {
        public CategoriaPc()
        {
            ProductosServiciosPcs = new HashSet<ProductosServiciosPc>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ICollection<ProductosServiciosPc> ProductosServiciosPcs { get; set; }
    }
}
