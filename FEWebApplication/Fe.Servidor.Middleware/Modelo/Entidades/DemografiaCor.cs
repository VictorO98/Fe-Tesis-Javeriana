using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class DemografiaCor
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public int? Numerodocumento { get; set; }
        public int? Telefono { get; set; }
        public int? Aceptoterminoscondiciones { get; set; }
        public DateTime? Creacion { get; set; }
        public DateTime? Modificacion { get; set; }
        public string Direccion { get; set; }
        public string Estado { get; set; }
        public int Rolcorid { get; set; }
        public int Tipodocumentocorid { get; set; }
        public int Idrazonsocial { get; set; }
        public int Idpoblacion { get; set; }

        public virtual PoblacionCor IdpoblacionNavigation { get; set; }
        public virtual RazonSocialCor IdrazonsocialNavigation { get; set; }
        public virtual RolCor Rolcor { get; set; }
        public virtual TipoDocumentoCor Tipodocumentocor { get; set; }
    }
}
