using Fe.Core.Global.Constantes;
using Fe.Core.Global.Errores;
using Fe.Dominio.trueques;
using Fe.Servidor.Middleware.Contratos.Core;
using Fe.Servidor.Middleware.Modelo.Entidades;
using FEWebApplication.Controladores.Core;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FEWebApplication.Controladores.Dominio.Trueque
{
    /// <summary>
    /// Servicios para guardar, modificar, borrar o leer trueques
    /// y su respectivo detalle (ProdSerTruequeTrue)
    /// </summary>
    [Route("trueque/[controller]")]
    public class TRTruequeController : COApiController
    {
        private readonly TRFachada _tRFachada;
        public TRTruequeController(TRFachada tRFachada)
        {
            _tRFachada = tRFachada;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Almacena el trueque en la BD.
        /// </summary>
        /// <returns>Respuesta de datos verificando que se realizó la inserción del trueque.</returns>
        /// <param name="detalle">El detalle del trueque que se desea almacernar en la base de datos.</param>
        [Route("GuardarTrueque")]
        [HttpPost]
        public async Task<RespuestaDatos> GuardarTrueque([FromBody] ProdSerTruequeTrue detalle)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _tRFachada.GuardarTruequeDetalle(detalle);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        // TODO: Decodificacion de JWT para validar el usuario mediante el claim del ID
        /// <summary>
        /// Modifica el trueque indicado en la base de datos.
        /// </summary>
        /// <returns>Respuesta de datos con un código de respuesta y un mensaje que indica si fue o no exitoso la modificación
        /// del trueque.</returns>
        /// <param name="productosServicios">Trueque que se desea modificar en la base de datos.</param>
        [Route("ModificarTrueque")]
        [HttpPut]
        public async Task<RespuestaDatos> ModificarTrueque([FromBody] TruequesPedidoTrue trueque)
        {
            RespuestaDatos respuestaDatos;
            try
            {
                respuestaDatos = await _tRFachada.ModificarTrueque(trueque);
            }
            catch (COExcepcion e)
            {
                respuestaDatos = new RespuestaDatos { Codigo = COCodigoRespuesta.ERROR, Mensaje = e.Message };
            }
            return respuestaDatos;
        }

        /// <summary>
        /// Obtiene todos los trueques.
        /// </summary>
        /// <returns>Una lista de todos los trueques existentes.</returns>
        [Route("GetTrueques")]
        [HttpGet]
        public List<TruequesPedidoTrue> GetTrueques()
        {
            return _tRFachada.GetTrueques();
        }

        /// <summary>
        /// Obtiene todos los trueques de un comprador.
        /// </summary>
        /// <returns>Una lista de todos los trueques de un comprador.</returns>
        /// <param name="idComprador">El id del comprador para filtrar sus trueques.</param>
        [Route("GetTruequesPorIdComprador")]
        [HttpGet]
        public List<TruequesPedidoTrue> GetTruequesPorIdComprador(int idComprador)
        {
            return _tRFachada.GetTruequesPorIdComprador(idComprador);
        }

        /// <summary>
        /// Obtiene todos los trueques de un vendedor.
        /// </summary>
        /// <returns>Una lista de todos los trueques de un vendedor.</returns>
        /// <param name="idVendedor">El id del vendedor para filtrar sus trueques.</param>
        [Route("GetTruequesPorIdVendedor")]
        [HttpGet]
        public List<TruequesPedidoTrue> GetTruequesPorIdVendedor(int idVendedor)
        {
            return _tRFachada.GetTruequesPorIdVendedor(idVendedor);
        }

        /// <summary>
        /// Obtiene el detalle del trueque dado.
        /// </summary>
        /// <returns>El detalle del trueque.</returns>
        /// <param name="idTrueque">El id del trueque para obtener su detalle.</param>
        [Route("GetDetallePorIdTrueque")]
        [HttpGet]
        public ProdSerTruequeTrue GetDetallePorIdTrueque(int idTrueque)
        {
            return _tRFachada.GetDetallePorIdTrueque(idTrueque);
        }
    }
}
