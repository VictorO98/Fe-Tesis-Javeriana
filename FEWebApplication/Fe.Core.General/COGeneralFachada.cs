using Fe.Core.General.Datos;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;

namespace Fe.Core.General
{
    public class COGeneralFachada   
    {
        private readonly RepoDemografia repoDemografia = new RepoDemografia();

        public DemografiaCor GetDemografiaPorId(int idDemografia)
        {
            return repoDemografia.GetDemografiaPorId(idDemografia);
        }
    }
}
