using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Servidor.Integracion.Email
{
    public class MailOptions
    {
        public string Server { get; set; }
        public int Port { get; set; }
        public string SenderName { get; set; }
        public string Account { get; set; }
        public string SenderEmail { get; set; }
        public string Password { get; set; }
        public bool Security { get; set; }
        public string EmailSoporteTecnico { get; set; }
    }
}
