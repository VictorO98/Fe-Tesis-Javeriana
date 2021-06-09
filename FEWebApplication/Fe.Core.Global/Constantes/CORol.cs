using System;
using System.Collections.Generic;
using System.Text;

namespace Fe.Core.Global.Constantes
{
    public class CORol
    {
        public const int ADMIN = 1;
        public const int EMPRENDEDOR = 2;
        public const int USUARIO = 3;

        public const string ADMIN_IDENTITY = "ADMINISTRADOR";
        public const string EMPRENDEDOR_IDENTITY = "EMPRENDEDOR";
        public const string USUARIO_IDENTITY = "USUARIO";

        public static string GetIdentityRolPorId(int idRol)
        {
            return idRol switch
            {
                ADMIN => ADMIN_IDENTITY,
                EMPRENDEDOR => EMPRENDEDOR_IDENTITY,
                USUARIO => USUARIO_IDENTITY,
                _ => null,
            };
        }
    }
}
