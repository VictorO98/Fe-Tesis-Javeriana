using Dapper;
using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Dapper;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
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
                productoSservicio.Creacion = DateTime.Now;
                productoSservicio.Calificacionpromedio = 0;
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
            ProductosServiciosPc publicacion = GetPublicacionPorIdPublicacion(idPublicacion);
            if (publicacion != null)
            {
                try
                {
                    context.ProductosServiciosPcs.Attach(publicacion);
                    publicacion.Estado = COEstados.INACTIVO;
                    publicacion.Modificacion = DateTime.Now;
                    context.SaveChanges();
                    respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Publicación eliminada exitosamente." };
                }
                catch (Exception e)
                {
                    throw new COExcepcion("Ocurrió un problema al intentar eliminar la publicación");
                }
            }
            else
            {
                throw new COExcepcion("La publicación no existe");
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

        internal List<ProductosServiciosPc> FiltrarPublicaciones(int idCategoria, int idTipoPublicacion,
            decimal precioMenor, decimal precioMayor, decimal calificacionMenor, decimal calificacionMayor)
        {
            var dynamicParameters = new DynamicParameters();
            StringBuilder condiciones = new StringBuilder();

            dynamicParameters.Add("Idcategoria", idCategoria);
            dynamicParameters.Add("Idtipopublicacion", idTipoPublicacion);
            dynamicParameters.Add("Preciomenor", precioMenor);
            dynamicParameters.Add("Preciomayor", precioMayor);
            dynamicParameters.Add("Calificacionmenor", calificacionMenor);
            dynamicParameters.Add("Calificacionmayor", calificacionMayor);

            if (idCategoria != -1)
            {
                condiciones.Append(" p.idcategoria = @Idcategoria ");
                if (idTipoPublicacion != -1)
                {
                    condiciones.Append(" AND p.idtipopublicacion = @Idtipopublicacion ");
                }
                if (precioMenor != -1 && precioMayor != -1)
                {
                    condiciones.Append(" AND p.preciounitario between @Preciomenor and @Preciomayor ");
                }
                if (calificacionMenor != -1 && calificacionMayor != -1)
                {
                    condiciones.Append(" AND p.calificacionpromedio between @Calificacionmenor and @Calificacionmayor ");
                }
            }

            else
            {
                if (idTipoPublicacion != -1)
                {
                    condiciones.Append(" p.idtipopublicacion = @Idtipopublicacion ");
                    if (precioMenor != -1 && precioMayor != -1)
                    {
                        condiciones.Append(" AND p.preciounitario between @Preciomenor and @Preciomayor ");
                    }
                    if (calificacionMenor != -1 && calificacionMayor != -1)
                    {
                        condiciones.Append(" AND p.calificacionpromedio between @Calificacionmenor and @Calificacionmayor ");
                    }
                }
                else
                {
                    if (precioMenor != -1 && precioMayor != -1)
                    {
                        condiciones.Append(" p.preciounitario between @Preciomenor and @Preciomayor ");
                        if (calificacionMenor != -1 && calificacionMayor != -1)
                        {
                            condiciones.Append(" AND p.calificacionpromedio between @Calificacionmenor and @Calificacionmayor ");
                        }
                    }
                    else
                    {
                        if (calificacionMenor != -1 && calificacionMayor != -1)
                        {
                            condiciones.Append(" p.calificacionpromedio between @Calificacionmenor and @Calificacionmayor ");
                        }
                    }
                }
            }


            var listado = CODBOrmFactorycs.Orm.SqlQuery<ProductosServiciosPc>($@"
                SELECT
                    p.id as Id
                FROM
                    public.productos_servicios_pc p
                WHERE {condiciones}", dynamicParameters);
            return listado.ToList();
        }

        internal List<ProductosServiciosPc> GetPublicacionesPorIdUsuario(int idDemografia)
        {
            using FeContext context = new FeContext();
            return context.ProductosServiciosPcs.Where(p => p.Idusuario == idDemografia).ToList();
        }

        internal List<ProductosServiciosPc> GetPublicacionesPorDescuento()
        {
            using FeContext context = new FeContext();
            return context.ProductosServiciosPcs.Where(p => p.Descuento > 0).ToList();
        }

        internal string RemoverAcentos(string s)
        {
            string decomposed = s.Normalize(NormalizationForm.FormD);
            char[] filtered = decomposed
                .Where(c => char.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                .ToArray();
            string newString = new String(filtered);
            return newString;
        }

        internal List<ProductosServiciosPc> BuscarPublicacion(string nombre)
        {
            nombre = RemoverAcentos(nombre);
            using FeContext context = new FeContext();
            return context.ProductosServiciosPcs.Where(p => p.Nombre.ToLower().Contains(nombre.ToLower())).ToList();
        }
    }
}
