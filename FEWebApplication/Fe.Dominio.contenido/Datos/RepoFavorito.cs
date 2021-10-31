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
    public class RepoFavorito
    {
        internal async Task<RespuestaDatos> GuardarFavorito(ProductosFavoritosDemografiaPc favorito)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(favorito);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Publicación agregada a favoritos exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar guardar la publicación en favoritos.");
            }
            return respuestaDatos;
        }

        internal async Task<RespuestaDatos> RemoverFavorito(int idFavorito)
        {
            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                ProductosFavoritosDemografiaPc favorito = new ProductosFavoritosDemografiaPc { Id = idFavorito };
                context.ProductosFavoritosDemografiaPcs.Attach(favorito);
                context.ProductosFavoritosDemografiaPcs.Remove(favorito);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Publicación eliminada de favoritos exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar eliminar la publicación de favoritos.");
            }
            return respuestaDatos;
        }

        internal List<ProductosFavoritosDemografiaPc> GetFavoritosPorIdDemografia(int idDemografia)
        {
            using FeContext context = new FeContext();
            return context.ProductosFavoritosDemografiaPcs.Where(f => f.Iddemografia == idDemografia).ToList();
        }

        internal object FavoritoMio(DemografiaCor demografiaCor, ProductosServiciosPc publicacion)
        {
            using FeContext context = new FeContext();
            return context.ProductosFavoritosDemografiaPcs.Where(f => f.Iddemografia == demografiaCor.Id && f.Idproductoservicio == publicacion.Id).FirstOrDefault();
        }
    }
}
