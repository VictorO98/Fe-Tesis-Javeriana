using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Contratos.Core.Seguridad;
using Fe.Servidor.Middleware.Dapper;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Fe.Core.General.Datos
{
    public class RepoDatosBancarios
    {
        public async Task<RespuestaDatos> GuardarDatosBancariosDemografia(CuentasBancariasDemografiaCor datosBancarios)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.CuentasBancariasDemografiaCors.Add(datosBancarios);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Cuenta Creada Exitosamente" };
            }
            catch (Exception e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = "Usuario con id " + datosBancarios.Id,
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.MODIFICAR_USUARIO
                });
                throw new COExcepcion("No se pudieron guardar sus datos bancarios...puede iniciar sesión pero contacte al soporte.");
            }
            return respuestaDatos;
        }

        public CuentaBancariaEmprendedor ObtenerDatosbancarios(int idDemografia)
        {
            using FeContext context = new FeContext();
            var query = from c in context.CuentasBancariasDemografiaCors
                        join b in context.BancosPermitidosCors on c.Identidadbancaria equals b.Id
                        where c.IdDemografia == idDemografia
                        select new CuentaBancariaEmprendedor
                        {
                            Numero = c.Numero,
                            Tipocuenta = c.Tipocuenta,
                            Identidadbancaria = b.Nombre
                        };
          
            return query.FirstOrDefault();
        }
    }
}
