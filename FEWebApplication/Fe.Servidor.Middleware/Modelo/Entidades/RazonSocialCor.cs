using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class RazonSocialCor
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string DocumentoCedula { get; set; }
        public int? Telefono { get; set; }
        public string Estado { get; set; }
        public DateTime Creacion { get; set; }
        public int Nit { get; set; }
        public string DocumentoCamaraComercio { get; set; }
    }
}
