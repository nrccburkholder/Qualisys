using System;
using System.Collections.Generic;

using NRC.Common ;
using NRC.Picker.SamplingService.Store.Models;
using NRC.Platform.Mailer.API;

namespace NRC.Picker.SamplingService.Mailer
{
    public static class ReportMailer
    {
        // TODO move this to config
        static string ADMIN_EMAIL = "agallichotte@nationalresearch.com";

        public static void SendOutputReport(Dataset dataset, string mailerUrl)
        {
            SendReport(dataset, mailerUrl, null);

            Logger.GetLogger().Info("Sent the MSM an output report.");
        }

        public static void SendAbortReport(Dataset dataset, string mailerUrl, Exception exception)
        {
            SendReport(dataset, mailerUrl, exception);

            Logger.GetLogger().Info("Sent the MSM an abort report.");
        }

        private static void SendReport(Dataset dataset, string mailerUrl, Exception exception)
        {
            APIClient mailer = new APIClient(mailerUrl);

            List<string> recipients = new List<string> { dataset.Study.AccountDirector.Email };
            if (exception != null)
            {
                recipients.Add(ADMIN_EMAIL);
            }

            mailer.Send(
                recipients.ToArray(),
                "SamplingService",
                CreateSubject(dataset, exception),
                LoadTemplate(dataset, exception),
                null,
                null,
                true);
        }

        private static string CreateSubject(Dataset dataset, Exception exception)
        {
            if (exception == null)
            {
                return String.Format(dataset.Result.Check()
                                     ? "'{0}' Dataset: SUCCESS"
                                     : "'{0}' Dataset: ERROR - please fix errors",
                                     dataset.Client.Name);
            }
            else
            {
                return String.Format("'{0}' Dataset: ERROR - Invalid dataset", dataset.Client.Name);
            }
        }

        public static string LoadTemplate(Dataset dataset, Exception exception)
        {
            Dictionary<string, object> session = new Dictionary<string, object>()
                                                     {
                                                         {"result", dataset.Result},
                                                         {"exception", exception}
                                                     };
            if (exception == null)
            {
                ReportTemplate template = new ReportTemplate();
                template.Session = session;
                template.Initialize();
                return template.TransformText();
            }
            else
            {
                AbortTemplate template = new AbortTemplate();
                template.Session = session;
                template.Initialize();
                return template.TransformText();
            }
        }
    }
}
