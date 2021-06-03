using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Servidor.Middleware.Contratos.Dominio.Contenido
{
    public class ContratoPc
    {
        public int Id { get; set; }
        public string Descripcion { get; set; }
        public int Cantidadtotal { get; set; }
        public DateTime Tiempoentrega { get; set; }
        public DateTime Tiempogarantia { get; set; }
        public int Preciounitario { get; set; }
        public decimal? Descuento { get; set; }
        public decimal Calificacionpromedio { get; set; }
        public int Habilitatrueque { get; set; }
        public string Nombre { get; set; }
        public string Urlimagenproductoservicio { get; set; }

        public string NombreCategoria { get; set; }
        public string TipoPublicacion { get; set; }
        public virtual DemografiaCor IdusuarioNavigation { get; set; }
        public virtual List<PreguntasRespuestasPc> PreguntasRespuestas { get; set; }
        public virtual List<ProdSerTruequeTrue> ProdSerTruequeTrueIdproductoserviciocompradorNavigations { get; set; }
        public virtual List<ProdSerTruequeTrue> ProdSerTruequeTrueIdproductoserviciovendedorNavigations { get; set; }
        public virtual List<ProdSerXVendidosPed> ProdSerXVendidosPeds { get; set; }
        public virtual List<ResenasPc> Resenas { get; set; }
    }
}
