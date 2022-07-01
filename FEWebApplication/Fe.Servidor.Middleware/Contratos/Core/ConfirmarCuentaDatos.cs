using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core
{
    public class ConfirmarCuentaDatos
    {
        public string Email { get; set; }
        public string Code { get; set; }
    }
}
