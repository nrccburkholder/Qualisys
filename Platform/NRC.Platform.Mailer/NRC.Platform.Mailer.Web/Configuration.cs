using NRC.Common.Configuration;

namespace NRC.Platform.Mailer
{
    class Configuration : ConfigSection
    {
        [ConfigUse("smtp-server")]
        public string SMTPServer { get; set; }

        [ConfigUse("mailer-address")]
        public string MailerAddress { get; set; }
    }
}
