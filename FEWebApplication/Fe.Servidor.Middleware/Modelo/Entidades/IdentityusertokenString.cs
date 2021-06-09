using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class IdentityusertokenString
    {
        public string UserId { get; set; }
        public string LoginProvider { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }

        public virtual Identityuser User { get; set; }
    }
}
