using Fe.Core.Global.Constantes;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Fe.Core.General.Datos
{
    public class RepoPoblacion
    {
        public List<EstadoPoblacionCor> GetEstadoPoblacion()
        {
            using FeContext feContext = new FeContext();
            return feContext.EstadoPoblacionCors.ToList();
        }

        public List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            using FeContext context = new FeContext();
            return context.PoblacionCors.Where(p => p.Estado == COEstados.VIGENTE && p.Idestadopoblacion == idEstado).ToList();
        }
    }
}
