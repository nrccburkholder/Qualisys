using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Mail;

using NRC.Common;
using NRC.Common.Configuration;
using NRC.Common.Mvc;
using System.Text;

namespace NRC.Platform.Mailer
{
    public class Mailer : APIService
    {
        private static readonly Logger _logger;
        private static readonly Configuration _config;

        static Mailer()
        {
            _logger = NRC.Common.Logger.GetLogger();
            _config = ConfigManager.Load<Configuration>();
        }

        [APIMethod]
        public bool Send(String remoteIP, String recipients, string clientTag, string subject,
            string body, Dictionary<string, string> data, string attachmentName,
            Stream attachmentStream, bool isHTML)
        {
            if (String.IsNullOrEmpty(recipients) || String.IsNullOrEmpty(clientTag) || String.IsNullOrEmpty(subject))
            {
                throw new UserException("recipients, clientTag, and subject cannot be null or empty strings");
            }

            MailMessage mail = new MailMessage(_config.MailerAddress, recipients);
            mail.Subject = String.Format("{0}: {1}", clientTag, subject);

            StringBuilder bodyText = new StringBuilder(body);
            bodyText.Append("\n\n");

            // TODO dictionary won't work here - order is not preserved.  List<KVP>?
            if (data != null)
            {
                foreach (KeyValuePair<string, string> kvp in data)
                {
                    bodyText.AppendFormat("{0}: {1}\n", kvp.Key, kvp.Value);
                }
            }

            mail.Body = bodyText.ToString();
            mail.IsBodyHtml = isHTML;

            if (attachmentStream != null)
            {
                Attachment attachment = new Attachment(attachmentStream, attachmentName);
                mail.Attachments.Add(attachment);
            }

            int contentSize = 0;
            contentSize += mail.Body.Length * 2;    // .NET strings are UTF-16, thus 2 bytes per character
            if (mail.Attachments.Count > 0)
                contentSize += (int)mail.Attachments[0].ContentStream.Length;

            try
            {

                SmtpClient smtpClient = new SmtpClient(_config.SMTPServer);
                smtpClient.Send(mail);
                _logger.Info(String.Format(
                    "Sent mail. ClientIP: {0} ClientTag: '{1}' Recipients: '{2}' Subject: '{3}' Bytes sent: '{4}'",
                    remoteIP,
                    clientTag,
                    recipients,
                    subject,
                    contentSize
                ));

                return true;
            }
            catch (Exception e)
            {
                _logger.Info(String.Format(
                    "Failed to send mail. ClientIP: {0} ClientTag: '{1}' Recipients: '{2}' Subject: '{3}' Bytes sent: '{4}' Exception: '{5}'",
                    remoteIP,
                    clientTag,
                    recipients,
                    subject,
                    contentSize,
                    e.Message
                ));
                throw e;
            }
        }
    }
}
