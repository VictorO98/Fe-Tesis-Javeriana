using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Fe.Dominio.contenido.Datos
{
    public class RepoCategoria
    {
        internal async Task<RespuestaDatos> GuardarCategoria(CategoriaPc categoria)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(categoria);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Categor�a creada exitosamente." };
            }
            catch(Exception e)
            {
                throw new COExcepcion("Ocurri� un problema al intentar agregar la categor�a.");
            }
            return respuestaDatos;
        }

        internal List<CategoriaPc> GetCategorias()
        {
            using var context = new FeContext();
            return context.CategoriaPcs.ToList();
        }

        internal CategoriaPc GetCategoriaPorIdCategoria(int idCategoria)
        {
            using FeContext context = new FeContext();
            return context.CategoriaPcs.SingleOrDefault(p => p.Id == idCategoria);
        }

        internal async Task<RespuestaDatos> ModificarCategoria(CategoriaPc nuevaCategoria)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            CategoriaPc categoria = GetCategoriaPorIdCategoria(nuevaCategoria.Id);
            if (categoria != null)
            {
                try
                {
                    context.CategoriaPcs.Attach(categoria);
                    categoria.Nombre = nuevaCategoria.Nombre;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Categor�a modificada exitosamente." };
                }
                catch (COExcepcion e)
                {
                    throw new COExcepcion("Ocurri� un problema al intentar modificar la categor�a.");
                }
            }
            else
            {
                throw new COExcepcion("La categor�a no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverCategoria(int idCategoria)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                CategoriaPc categoria = new CategoriaPc { Id = idCategoria };
                context.CategoriaPcs.Attach(categoria);
                context.CategoriaPcs.Remove(categoria);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Categor�a eliminada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurri� un problema al intentar eliminar la categor�a");
            }
            return respuestaDatos;
        }
    }
}