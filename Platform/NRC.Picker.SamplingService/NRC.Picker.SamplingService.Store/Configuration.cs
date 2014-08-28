using NRC.Common.Configuration;

namespace NRC.Picker.SamplingService.Store
{
    public class Configuration : ConfigSection
    {
        [ConfigUse("autosampler-threads")]
        public int AutosamplerThreads { get; set; }

        [ConfigUse("sample-count-threshold")]
        public float SampleCountThreshold { get; set; }

        [ConfigUse("mailer-url")]
        public string MailerUrl { get; set; }

        [ConfigUse("enable-scheduling")]
        public bool EnableScheduling { get; set; }
    }
}