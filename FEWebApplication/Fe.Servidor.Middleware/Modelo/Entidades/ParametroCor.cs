using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ParametroCor
    {
        public int Id { get; set; }
        public string Codigo { get; set; }
        public string Valor { get; set; }
        public DateTime Creacion { get; set; }
        public string Descripcion { get; set; }
    }
}
