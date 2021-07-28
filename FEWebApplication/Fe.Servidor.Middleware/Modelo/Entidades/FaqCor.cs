using System;
using System.Collections.Generic;

#nullable disable

namespace Fe.Servidor.Middleware.Modelo.Entidades
{
    public partial class FaqCor
    {
        public int Id { get; set; }
        public string Pregunta { get; set; }
        public string Respuesta { get; set; }
        public string Categoria { get; set; }
    }
}
