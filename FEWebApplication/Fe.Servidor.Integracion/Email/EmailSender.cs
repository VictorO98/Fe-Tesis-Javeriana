using MailKit.Security;
using MimeKit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Fe.Servidor.Integracion.Email
{
    public class EmailSender
    {
        /// <summary>
        /// Sends an email
        /// </summary>
        /// <param name="emailAccount">Email account to use</param>
        /// <param name="subject">Subject</param>
        /// <param name="body">Body</param>
        /// <param name="fromAddress">From address</param>
        /// <param name="fromName">From display name</param>
        /// <param name="toAddress">To address</param>
        /// <param name="toName">To display name</param>
        public virtual async Task SendEmail(MailOptions emailAccount, string subject, string body,
           string fromAddress, string fromName, string toAddress, string toName)

        {
            var message = new MimeMessage();
            //from, to, reply to
            message.From.Add(new MailboxAddress(fromName, fromAddress));
            message.To.Add(new MailboxAddress(toName, toAddress));

            //subject
            message.Subject = subject;

            //content
            var builder = new BodyBuilder
            {
                HtmlBody = body
            };


            message.Body = builder.ToMessageBody();

            //send email
            using var smtpClient = new MailKit.Net.Smtp.SmtpClient();
            //smtpClient.ServerCertificateValidationCallback = (s, c, h, e) => emailAccount.UseServerCertificateValidation;
            await smtpClient.ConnectAsync(emailAccount.Server, emailAccount.Port, SecureSocketOptions.Auto);
            await smtpClient.AuthenticateAsync(emailAccount.Account, emailAccount.Password);
            await smtpClient.SendAsync(message);
            await smtpClient.DisconnectAsync(true);

        }
    }
}
