using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class EstadoPoblacionCor
    {
        public EstadoPoblacionCor()
        {
            PoblacionCors = new HashSet<PoblacionCor>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }

        public virtual ICollection<PoblacionCor> PoblacionCors { get; set; }
    }
}
