using DotLiquid;
using Fe.Servidor.Middleware.Contratos.Core;

namespace Fe.Servidor.Integracion.Mensajes.DotLiquid
{
    public class AppLiquid : Drop
    {
        public string Nombre
        {
            get { return _appDatos.Nombre; }
        }
        public string Descripcion
        {
            get { return _appDatos.Descripcion; }
        }

        private readonly AppDatos _appDatos;

        public AppLiquid(AppDatos appDatos)
        {
            _appDatos = appDatos;
        }
    }
}
