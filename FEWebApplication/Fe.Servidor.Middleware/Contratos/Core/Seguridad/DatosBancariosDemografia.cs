using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core.Seguridad
{
    public class DatosBancariosDemografia
    {
        public string Email { get; set; }
        public string NumeroCuentaBancaria { get; set; }
        public string TipoDeCuenta { get; set; }
        public int EntidadBancaria { get; set; }
    }
}
