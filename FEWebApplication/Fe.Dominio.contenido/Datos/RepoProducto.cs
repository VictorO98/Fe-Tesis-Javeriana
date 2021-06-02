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
    public class RepoProducto
    {
        internal async Task<RespuestaDatos> GuardarPublicacion(ProductosServiciosPc productoSservicio)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(productoSservicio);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Publicación creada exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar realizar la publicación");
            }
            return respuestaDatos;
        }

        internal ProductosServiciosPc GetPublicacionPorIdPublicacion(int idPublicacion)
        {
            using FeContext context = new FeContext();
            return context.ProductosServiciosPcs.SingleOrDefault(p => p.Id == idPublicacion);
        }

        internal async Task<RespuestaDatos> RemoverPublicacion(int idPublicacion)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                ProductosServiciosPc publicacion = new ProductosServiciosPc { Id = idPublicacion };
                context.ProductosServiciosPcs.Attach(publicacion);
                context.ProductosServiciosPcs.Remove(publicacion);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Publicación eliminada exitosamente." };
            }
            catch(Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar eliminar la publicación");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarPublicacion(ProductosServiciosPc productoSservicio)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            ProductosServiciosPc publicacion = GetPublicacionPorIdPublicacion(productoSservicio.Id);
            if(publicacion != null)
            {
                try
                {
                    context.Attach(publicacion);
                    publicacion.Descripcion = productoSservicio.Descripcion;
                    publicacion.Descuento = productoSservicio.Descuento;
                    publicacion.Cantidadtotal = productoSservicio.Cantidadtotal;
                    publicacion.Nombre = productoSservicio.Nombre;
                    publicacion.Preciounitario = productoSservicio.Preciounitario;
                    publicacion.Tiempoentrega = productoSservicio.Tiempoentrega;
                    publicacion.Tiempogarantia = productoSservicio.Tiempogarantia;
                    publicacion.Habilitatrueque = productoSservicio.Habilitatrueque;
                    publicacion.Urlimagenproductoservicio = productoSservicio.Urlimagenproductoservicio;
                    publicacion.Modificacion = DateTime.Now;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Publicación modificada exitosamente." };
                }
                catch(Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la publicación.");
                }
            }
            else
            {
                throw new COExcepcion("La publicación no existe");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> ModificarCalificacion(int idPublicacion, decimal calificacion)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            ProductosServiciosPc publicacion = GetPublicacionPorIdPublicacion(idPublicacion);
            if (publicacion != null)
            {
                try
                {
                    context.Attach(publicacion);
                    publicacion.Calificacionpromedio = calificacion;
                    publicacion.Modificacion = DateTime.Now;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Calificación modificada exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar modificar la calificación.");
                }
            }
            else
            {
                throw new COExcepcion("La publicación no existe");
            }
            return respuestaDatos;
        }
    }
}
