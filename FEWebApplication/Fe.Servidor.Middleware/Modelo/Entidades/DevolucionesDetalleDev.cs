using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class DevolucionesDetalleDev
    {
        public int Id { get; set; }
        public int Iddevolucion { get; set; }
        public int? Idproducto { get; set; }
        public int? Cantidad { get; set; }
        public int Idconcepto { get; set; }
        public string Estado { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ConceptoDev IdconceptoNavigation { get; set; }
        public virtual DevolucionesDev IddevolucionNavigation { get; set; }
    }
}
