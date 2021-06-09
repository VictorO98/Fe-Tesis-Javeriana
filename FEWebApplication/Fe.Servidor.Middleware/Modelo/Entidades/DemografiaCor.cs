using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class DemografiaCor
    {
        public DemografiaCor()
        {
            DemografiaReportadaCors = new HashSet<DemografiaReportadaCor>();
            NotificacionesCors = new HashSet<NotificacionesCor>();
            PedidosPeds = new HashSet<PedidosPed>();
            ProductosFavoritosDemografiaPcs = new HashSet<ProductosFavoritosDemografiaPc>();
            ProductosServiciosPcs = new HashSet<ProductosServiciosPc>();
            TruequesPedidoTrueIdcompradorNavigations = new HashSet<TruequesPedidoTrue>();
            TruequesPedidoTrueIdvendedorNavigations = new HashSet<TruequesPedidoTrue>();
        }

        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public int Numerodocumento { get; set; }
        public int Telefono { get; set; }
        public int Aceptoterminoscondiciones { get; set; }
        public DateTime Creacion { get; set; }
        public DateTime Modificacion { get; set; }
        public string Direccion { get; set; }
        public string Estado { get; set; }
        public int Rolcorid { get; set; }
        public int Tipodocumentocorid { get; set; }
        public int Idpoblacion { get; set; }
        public string Email { get; set; }
        public string Codigotelefonopais { get; set; }

        public virtual PoblacionCor IdpoblacionNavigation { get; set; }
        public virtual RolCor Rolcor { get; set; }
        public virtual TipoDocumentoCor Tipodocumentocor { get; set; }
        public virtual ICollection<DemografiaReportadaCor> DemografiaReportadaCors { get; set; }
        public virtual ICollection<NotificacionesCor> NotificacionesCors { get; set; }
        public virtual ICollection<PedidosPed> PedidosPeds { get; set; }
        public virtual ICollection<ProductosFavoritosDemografiaPc> ProductosFavoritosDemografiaPcs { get; set; }
        public virtual ICollection<ProductosServiciosPc> ProductosServiciosPcs { get; set; }
        public virtual ICollection<TruequesPedidoTrue> TruequesPedidoTrueIdcompradorNavigations { get; set; }
        public virtual ICollection<TruequesPedidoTrue> TruequesPedidoTrueIdvendedorNavigations { get; set; }
    }
}
