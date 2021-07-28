using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core
{
    public class DemografiaDatos
    {
        public int Id { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string NumeroTelefono { get; set; }
        public string Email { get; set; }
        public string TokenConfirmacion { get; set; }
        public string Rol { get; set; }
    }
}
