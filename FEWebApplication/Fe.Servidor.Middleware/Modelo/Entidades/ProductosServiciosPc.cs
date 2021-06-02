using Fe.Core.Global.Constantes;
using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class ProductosServiciosPc
    {
        public ProductosServiciosPc()
        {
            FavoritosUsuarioProductosPcs = new HashSet<FavoritosUsuarioProductosPc>();
            PreguntasRespuestasPcs = new HashSet<PreguntasRespuestasPc>();
            ProdSerTruequeTrueIdproductoserviciocompradorNavigations = new HashSet<ProdSerTruequeTrue>();
            ProdSerTruequeTrueIdproductoserviciovendedorNavigations = new HashSet<ProdSerTruequeTrue>();
            ProdSerXVendidosPeds = new HashSet<ProdSerXVendidosPed>();
            ResenasPcs = new HashSet<ResenasPc>();
        }

        public int Id { get; set; }
        public int Idcategoria { get; set; }
        public int Idtipopublicacion { get; set; }
        public int Idusuario { get; set; }
        public string Descripcion { get; set; }
        public int Cantidadtotal { get; set; }
        public DateTime Tiempoentrega { get; set; }
        public DateTime Tiempogarantia { get; set; }
        public int Preciounitario { get; set; }
        public decimal? Descuento { get; set; }
        public string Estado { get; set; } = COEstados.VIGENTE;
        public decimal Calificacionpromedio { get; set; } = 0;
        public int Habilitatrueque { get; set; }
        public DateTime Creacion { get; set; } = DateTime.Now;
        public string Nombre { get; set; }
        public DateTime Modificacion { get; set; } = DateTime.Now;
        public string Urlimagenproductoservicio { get; set; }

        public virtual CategoriaPc IdcategoriaNavigation { get; set; }
        public virtual TipoPublicacionPc IdtipopublicacionNavigation { get; set; }
        public virtual DemografiaCor IdusuarioNavigation { get; set; }
        public virtual ICollection<FavoritosUsuarioProductosPc> FavoritosUsuarioProductosPcs { get; set; }
        public virtual ICollection<PreguntasRespuestasPc> PreguntasRespuestasPcs { get; set; }
        public virtual ICollection<ProdSerTruequeTrue> ProdSerTruequeTrueIdproductoserviciocompradorNavigations { get; set; }
        public virtual ICollection<ProdSerTruequeTrue> ProdSerTruequeTrueIdproductoserviciovendedorNavigations { get; set; }
        public virtual ICollection<ProdSerXVendidosPed> ProdSerXVendidosPeds { get; set; }
        public virtual ICollection<ResenasPc> ResenasPcs { get; set; }
    }
}
