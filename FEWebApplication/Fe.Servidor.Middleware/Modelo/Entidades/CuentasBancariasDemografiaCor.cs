using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class CuentasBancariasDemografiaCor
    {
        public int Id { get; set; }
        public int IdDemografia { get; set; }
        public long Numero { get; set; }
        public string Tipocuenta { get; set; }
        public int Identidadbancaria { get; set; }
        public DateTime Creacion { get; set; }
        public DateTime Modificacion { get; set; }
    }
}
