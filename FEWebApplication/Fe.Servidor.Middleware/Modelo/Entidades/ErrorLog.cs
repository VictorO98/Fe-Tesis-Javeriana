using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ErrorLog
    {
        public int Id { get; set; }
        public string Mensaje { get; set; }
        public string Traza { get; set; }
        public DateTime Creacion { get; set; }
        public string Usuario { get; set; }
        public string Tipoerror { get; set; }
    }
}
