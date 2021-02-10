using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class RazonSocialCor
    {
        public RazonSocialCor()
        {
            DemografiaCors = new HashSet<DemografiaCor>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Direccion { get; set; }
        public int? Telefono { get; set; }
        public string Estado { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ICollection<DemografiaCor> DemografiaCors { get; set; }
    }
}
