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

        internal List<PoblacionCor> GetPoblacionPorIdEstado(int idEstado)
        {
            using FeContext context = new FeContext();
            return context.PoblacionCors.Where(p => p.Estado == COEstados.VIGENTE && p.Idestadopoblacion == idEstado).ToList();
        }

        public EstadoPoblacionCor GetEstadoPorIdPoblacion(int idPoblacion) 
        {
            using FeContext context = new FeContext();
            var poblacion = GetPoblacionPorIdPoblacion(idPoblacion);
            return context.EstadoPoblacionCors.Where(p => p.Id == poblacion.Idestadopoblacion).FirstOrDefault();
        }

        public PoblacionCor GetPoblacionPorIdPoblacion(int idPoblacion)
        {
            using FeContext context = new FeContext();
            return context.PoblacionCors.Where(p => p.Estado == COEstados.VIGENTE && p.Id == idPoblacion).FirstOrDefault();
        }
    }
}
