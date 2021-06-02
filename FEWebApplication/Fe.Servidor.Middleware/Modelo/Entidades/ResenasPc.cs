using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ResenasPc
    {
        public int Id { get; set; }
        public int Idpublicacion { get; set; }
        public string Comentarios { get; set; }
        public decimal? Puntuacion { get; set; }
        public DateTime? Creacion { get; set; } = DateTime.Now;
        public virtual ProductosServiciosPc IdpublicacionNavigation { get; set; }
    }
}
