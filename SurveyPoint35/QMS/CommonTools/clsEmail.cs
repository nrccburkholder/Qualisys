using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mail;

namespace Tools
{
    /// <summary>
    /// Summary description for clsEmail.
    /// </summary>
    public class clsEmail
    {
        private clsEmail()
        {
            // private constructor to prevent inheritance
        }

        public static void Send(string sFrom_Email
            , string sTo_Email
            , string sSubject
            , string sBody
            , MailFormat enMailFormat
            , string sLanguage)
        {
            MailMessage oMessage = new MailMessage();
            // UTF8 is necessary to encode Asian languages and special European characters
            oMessage.BodyEncoding = Encoding.UTF8;
            oMessage.BodyFormat = enMailFormat;

            oMessage.Subject = sSubject;
            oMessage.Body = sBody;
            oMessage.From = sFrom_Email;
            oMessage.To = sTo_Email;

            SmtpMail.SmtpServer = clsWebConfig.WebConfigAppSetting(clsWebConfig.configKey_SMTP_Server_Name);
            SmtpMail.Send(oMessage);
        }

        public static void Send(string sFrom_Email
            , string sTo_Email
            , string sSubject
            , string sBody)
        {
            System.Web.Mail.SmtpMail.SmtpServer = clsWebConfig.WebConfigAppSetting(clsWebConfig.configKey_SMTP_Server_Name);
            System.Web.Mail.SmtpMail.Send(sFrom_Email, sTo_Email, sSubject, sBody);
        }

    }
}

