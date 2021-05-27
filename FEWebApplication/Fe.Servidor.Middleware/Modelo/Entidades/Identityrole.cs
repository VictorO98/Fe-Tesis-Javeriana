using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class Identityrole
    {
        public Identityrole()
        {
            IdentityroleclaimStrings = new HashSet<IdentityroleclaimString>();
            IdentityuserroleStrings = new HashSet<IdentityuserroleString>();
        }

        public string Id { get; set; }
        public string Name { get; set; }
        public string NormalizedName { get; set; }
        public string ConcurrencyStamp { get; set; }

        public virtual ICollection<IdentityroleclaimString> IdentityroleclaimStrings { get; set; }
        public virtual ICollection<IdentityuserroleString> IdentityuserroleStrings { get; set; }
    }
}
