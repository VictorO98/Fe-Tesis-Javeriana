using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core.Seguridad
{
    public class RegisterDatos
    {
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string ConfirmPassword { get; set; }
        public string NumeroDocumento { get; set; }
        public string CodigoTelefonoPais { get; set; }
        public string NumeroTelefonico { get; set; }
        public string Direccion { get; set; }
        public string IdPoblacion { get; set; }
        public int IdTipoCliente { get; set; }
        public int IdTipoDocumento { get; set; }
        public bool IsAceptaTerminosYCondiciones { get; set; }
    }
}
