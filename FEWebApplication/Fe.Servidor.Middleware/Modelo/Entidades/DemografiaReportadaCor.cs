using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class DemografiaReportadaCor
    {
        public int Id { get; set; }
        public int Iddemografia { get; set; }
        public string Motivo { get; set; }
        public DateTime Creacion { get; set; }

        public virtual DemografiaCor IddemografiaNavigation { get; set; }
    }
}
