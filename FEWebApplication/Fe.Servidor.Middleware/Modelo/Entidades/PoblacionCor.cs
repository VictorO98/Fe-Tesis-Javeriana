using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class PoblacionCor
    {
        public PoblacionCor()
        {
            DemografiaCors = new HashSet<DemografiaCor>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Estado { get; set; }
        public int Idestadopoblacion { get; set; }

        public virtual EstadoPoblacionCor IdestadopoblacionNavigation { get; set; }
        public virtual ICollection<DemografiaCor> DemografiaCors { get; set; }
    }
}
