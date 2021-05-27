using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class IdentityuserroleString
    {
        public string UserId { get; set; }
        public string RoleId { get; set; }

        public virtual Identityrole Role { get; set; }
        public virtual Identityuser User { get; set; }
    }
}
