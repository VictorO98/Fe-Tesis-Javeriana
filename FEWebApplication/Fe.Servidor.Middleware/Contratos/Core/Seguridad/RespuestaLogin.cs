using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core.Seguridad
{
    public class RespuestaLogin : RespuestaDatos
    {
        public string Token { get; set; }
        public DateTime Expire { get; set; }
        public ApplicationUser user { get; set; }
    }
}
