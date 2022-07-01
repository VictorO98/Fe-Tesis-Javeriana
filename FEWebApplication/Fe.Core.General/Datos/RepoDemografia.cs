using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Fe.Core.General.Datos
{
    public class RepoDemografia
    {
        public async Task<int> GuardarDemografia(DemografiaCor demografia)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(demografia);
                context.SaveChanges();
                return demografia.Id;
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar agregar la categoría.");
            }   
        }

        internal DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            using FeContext context = new FeContext();
            return context.DemografiaCors.Where(d => d.Id == idDemografia).FirstOrDefault();
        }

        public DemografiaCor GetDemografiaPorEmail(string emailDemografia)
        {
            using FeContext context = new FeContext();
            return context.DemografiaCors.Where(d => d.Email == emailDemografia).FirstOrDefault();
        }

        public async Task<RespuestaDatos> ModificarDemografia(DemografiaCor demografiaCor, Servidor.Middleware.Contratos.Core.Seguridad.ModificarDemografia model)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.DemografiaCors.Attach(demografiaCor);
                demografiaCor.Nombre = model.Nombre;
                demografiaCor.Apellido = model.Apellido;
                demografiaCor.Telefono = model.Telefono;
                demografiaCor.Direccion = model.Direccion;              
                demografiaCor.Modificacion = DateTime.Now;
                context.SaveChanges();
                respuestaDatos =  new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Usuario modificado exitosamente!" };
            }
            catch (COExcepcion e)
            {
                RepoErrorLog.AddErrorLog(new ErrorLog
                {
                    Mensaje = e.Message,
                    Traza = e.StackTrace,
                    Usuario = demografiaCor.Email,
                    Creacion = DateTime.Now,
                    Tipoerror = COErrorLog.MODIFICAR_USUARIO
                });
                throw new COExcepcion("Ocurrió un problema al modificar el usuario.");
            }
            return respuestaDatos;
        }

        public void SubirImagenSocial(DemografiaCor demografiaCor)
        {
            using FeContext context = new FeContext();
            context.DemografiaCors.Update(demografiaCor);
            context.SaveChanges();
        }
    }
}
