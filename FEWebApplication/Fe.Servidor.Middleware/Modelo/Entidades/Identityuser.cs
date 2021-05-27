using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class Identityuser
    {
        public Identityuser()
        {
            IdentityuserclaimStrings = new HashSet<IdentityuserclaimString>();
            IdentityuserloginStrings = new HashSet<IdentityuserloginString>();
            IdentityuserroleStrings = new HashSet<IdentityuserroleString>();
            IdentityusertokenStrings = new HashSet<IdentityusertokenString>();
        }

        public string Id { get; set; }
        public string UserName { get; set; }
        public string NormalizedUserName { get; set; }
        public string Email { get; set; }
        public string NormalizedEmail { get; set; }
        public bool EmailConfirmed { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public string ConcurrencyStamp { get; set; }
        public string PhoneNumber { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool TwoFactorEnabled { get; set; }
        public DateTime? LockoutEnd { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }

        public virtual ICollection<IdentityuserclaimString> IdentityuserclaimStrings { get; set; }
        public virtual ICollection<IdentityuserloginString> IdentityuserloginStrings { get; set; }
        public virtual ICollection<IdentityuserroleString> IdentityuserroleStrings { get; set; }
        public virtual ICollection<IdentityusertokenString> IdentityusertokenStrings { get; set; }
    }
}
