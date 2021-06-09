using System;
using System.Runtime.Serialization;

namespace Fe.Core.Global.Errores
{
    public class COExcepcion : Exception
    {
        public COExcepcion(string message) : base(message)
        {

        }

        public COExcepcion(string message, Exception innerException) : base(message, innerException)
        {

        }

        protected COExcepcion(SerializationInfo info, StreamingContext context) : base(info, context)
        {

        }
    }
}
