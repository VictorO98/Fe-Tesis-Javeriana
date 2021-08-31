using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Contexto;
using Fe.Servidor.Middleware.Modelo.Entidades;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Core.Seguridad.Datos
{
    public class RepoDocumentosEmprendedor
    {
        internal async Task<RespuestaDatos> SubirDocumentosEmprendedor(DocumentosDemografiaCor documentosDemografiaCor)
        {

            using FeContext context = new FeContext();
            RespuestaDatos respuestaDatos;
            try
            {
                context.Add(documentosDemografiaCor);
                context.SaveChanges();
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.OK, Mensaje = "Documentos guardados exitosamente." };
            }
            catch (Exception e)
            {
                throw new COExcepcion("Ocurrió un problema al intentar guardar los documentos del emprendedor.");
            }
            return respuestaDatos;
        }
    }
}
