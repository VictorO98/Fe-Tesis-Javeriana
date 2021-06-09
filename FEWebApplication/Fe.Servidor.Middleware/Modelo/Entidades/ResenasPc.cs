using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    // TODO: Agregar el ID del usuario
    public partial class ResenasPc
    {
        public int Id { get; set; }
        public int Idpublicacion { get; set; }
        public string Comentarios { get; set; }

        // TODO: Modificar el tipo de puntuacion para permitir valores de 0 a 5
        public decimal? Puntuacion { get; set; }
        public DateTime? Creacion { get; set; } = DateTime.Now;
        public virtual ProductosServiciosPc IdpublicacionNavigation { get; set; }
    }
}
