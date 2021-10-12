using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Core.Seguridad
{
    public class ModificarDemografia
    {
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public long NroDocumento { get; set; }
        public long Telefono { get; set; }
        public string Direccion { get; set; }
        public int IdPoblacion { get; set; }
        public string Correo { get; set; }
    }
}
