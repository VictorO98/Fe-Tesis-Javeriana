using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Contenido
{
    public class ModificarPublicacion
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public int Cantidad { get; set; }
        public string Descripcion { get; set; }
        public int Preciounitario { get; set; }
        public decimal Descuento { get; set; }
        public int Habilitatrueque { get; set; }
    }
}
