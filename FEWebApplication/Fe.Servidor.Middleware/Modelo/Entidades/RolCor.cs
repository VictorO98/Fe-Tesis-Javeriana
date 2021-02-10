using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class RolCor
    {
        public RolCor()
        {
            DemografiaCors = new HashSet<DemografiaCor>();
            UsuarioCors = new HashSet<UsuarioCor>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public DateTime? Creacion { get; set; }

        public virtual ICollection<DemografiaCor> DemografiaCors { get; set; }
        public virtual ICollection<UsuarioCor> UsuarioCors { get; set; }
    }
}
