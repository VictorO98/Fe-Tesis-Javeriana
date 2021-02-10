using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class TruequesPedidoTrue
    {
        public TruequesPedidoTrue()
        {
            ProdSerTruequeTrues = new HashSet<ProdSerTruequeTrue>();
        }

        public int Id { get; set; }
        public int Idcomprador { get; set; }
        public int Idvendedor { get; set; }
        public string Estado { get; set; }
        public DateTime? Fechatrueque { get; set; }

        public virtual UsuarioCor IdcompradorNavigation { get; set; }
        public virtual UsuarioCor IdvendedorNavigation { get; set; }
        public virtual ICollection<ProdSerTruequeTrue> ProdSerTruequeTrues { get; set; }
    }
}
