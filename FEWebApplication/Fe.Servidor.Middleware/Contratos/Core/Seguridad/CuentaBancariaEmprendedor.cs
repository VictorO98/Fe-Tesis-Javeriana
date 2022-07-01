using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core.Seguridad
{
    public class CuentaBancariaEmprendedor
    {
        public long Numero { get; set; }
        public string Tipocuenta { get; set; }
        public string Identidadbancaria { get; set; }
    }
}
