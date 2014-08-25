using System;
using System.IO;
using System.Linq;
using NRC.Common;
using NRC.Picker.SamplingService.Mailer;
using NRC.Picker.SamplingService.Store.Models;
using NRC.Picker.SamplingService.Test;

namespace NRC.Picker.SamplingService.Test.ReportViewer
{
    public class ReportViewer
    {
        public static void Main()
        {
            Logger logger = Logger.GetLogger();

            Dataset dataset = new Dataset(DatasetTest.DatasetID, DatasetTest.SampleCountThreshold);

            dataset.ClearSamples(true);
            dataset.Dequeue();
            dataset.Enqueue();
            dataset.Sample(false);

            using (var fp = new StreamWriter("report.html"))
            {
                fp.Write(ReportMailer.LoadTemplate(dataset, null));
            }

            using (var fp = new StreamWriter("abort.html"))
            {
                fp.Write(ReportMailer.LoadTemplate(dataset, new Exception("uhoh!")));
            }

            ReportMailer.SendOutputReport(dataset, DatasetTest.MailerUrl);
        }
    }
}
