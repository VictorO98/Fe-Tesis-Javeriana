using DotLiquid;
using Fe.Servidor.Middleware.Contratos.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Servidor.Integracion.Mensajes.DotLiquid
{
    public class ClienteLiquid : Drop
    {
        private readonly DemografiaDatos _demografiaDatos;
        public int Id
        {
            get { return _demografiaDatos.Id; }
        }
        public string Nombres
        {
            get { return _demografiaDatos.Nombres; }
        }
        public string Apellidos
        {
            get { return _demografiaDatos.Apellidos; }
        }
        public string NumeroTelefono
        {
            get { return _demografiaDatos.NumeroTelefono; }
        }
        public string Email
        {
            get { return _demografiaDatos.Email; }
        }
        public string TokenConfirmacion
        {
            get { return _demografiaDatos.TokenConfirmacion; }
        }
        public ClienteLiquid(DemografiaDatos demografiaDatos)
        {
            _demografiaDatos = demografiaDatos;
        }
    }
}
