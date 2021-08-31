using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class DocumentosDemografiaCor
    {
        public int Id { get; set; }
        public string Urlimagen { get; set; }
        public int Iddemografia { get; set; }
        public DateTime Creacion { get; set; }
        public string Razonsocial { get; set; }

        public virtual DemografiaCor IddemografiaNavigation { get; set; }
    }
}
