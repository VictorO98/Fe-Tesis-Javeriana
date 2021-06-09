using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ConceptoDev
    {
        public ConceptoDev()
        {
            DevolucionesDetalleDevs = new HashSet<DevolucionesDetalleDev>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public string Estado { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ICollection<DevolucionesDetalleDev> DevolucionesDetalleDevs { get; set; }
    }
}
