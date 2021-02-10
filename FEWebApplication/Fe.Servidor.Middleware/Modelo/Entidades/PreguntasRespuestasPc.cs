using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class PreguntasRespuestasPc
    {
        public int Id { get; set; }
        public int Idproductoservicio { get; set; }
        public string Pregunta { get; set; }
        public string Respuesta { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ProductosServiciosPc IdproductoservicioNavigation { get; set; }
    }
}
