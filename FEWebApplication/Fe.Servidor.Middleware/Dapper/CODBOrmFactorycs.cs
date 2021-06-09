using Microsoft.Extensions.Configuration;

namespace Fe.Servidor.Middleware.Dapper
{
    public static class CODBOrmFactorycs
    {
        public static COMicroOrm Orm { get; private set; }

        /// <summary>
        /// Inicializar la instancia del Micro ORM
        /// </summary>
        /// <param name="configuration">Intancia de configuración de la aplicación</param>
        public static void Configurar(IConfiguration configuration)
        {
            Orm = new COMicroOrm(configuration);
        }
    }
}
