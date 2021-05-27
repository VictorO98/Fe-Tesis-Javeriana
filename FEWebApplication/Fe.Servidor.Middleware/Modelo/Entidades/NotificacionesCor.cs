using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class NotificacionesCor
    {
        public int Id { get; set; }
        public string Detalle { get; set; }
        public int Idusuario { get; set; }
        public DateTime? Creacion { get; set; }
        public string Estado { get; set; }

        public virtual DemografiaCor IdusuarioNavigation { get; set; }
    }
}
