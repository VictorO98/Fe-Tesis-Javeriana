using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ImagenesPublicacionesPc
    {
        public int Id { get; set; }
        public int Idpublicacion { get; set; }
        public string UrlImagen { get; set; }
        public TimeSpan Creacion { get; set; }
        public DateTime Modificacion { get; set; }

        public virtual ProductosServiciosPc IdpublicacionNavigation { get; set; }
    }
}
