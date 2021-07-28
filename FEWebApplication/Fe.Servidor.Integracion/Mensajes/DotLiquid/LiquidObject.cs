using DotLiquid;
using System.Collections.Generic;

namespace Fe.Servidor.Integracion.Mensajes.DotLiquid
{
    public partial class LiquidObject
    {
        public IDictionary<string, string> AdditionalTokens { get; set; }

        public LiquidObject()
        {
            AdditionalTokens = new Dictionary<string, string>();
        }

        public Drop ClienteLiquid { get; set; }
        public Drop AppLiquid { get; set; }
    }
}
