using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.IO;

using NRC.Platform.Mailer.API;

namespace NRC.Platform.Mailer.Test
{
    [TestClass()]
    public class APIClientTest
    {
        private static readonly string SERVER_URL = "http://localhost:37556/Service";
        private static readonly string RECIPIENT = "aaliabadi@nationalresearch.com";
        private static readonly string CLIENT_TAG = "APIClientTest";
        private static readonly string ATTACHMENT_PATH = "../../../NRC.Platform.Mailer.Test/sampleAttachment.txt";

        private TestContext testContextInstance;

        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        [TestMethod()]
        public void APIClientConstructorTest()
        {
            APIClient target = new APIClient(SERVER_URL);
            Assert.IsTrue(true, "Instantiated APIClient");
        }

        [TestMethod()]
        public void APIClientSendTest()
        {
            APIClient target = new APIClient(SERVER_URL);

            // first pass - null for data and fileinfo
            string[] recipients = new string[] {RECIPIENT};
            string subject = "first test email";
            string body = "No data or attachment";
            Dictionary<string, string> data = null;
            FileInfo fileInfo = null;
            Assert.IsTrue(target.Send(recipients, CLIENT_TAG, subject, body, data, fileInfo, false));

            // second pass - some keys for data, null for fileinfo
            subject = "second test email";
            body = "Some data, no attachment";
            data = new Dictionary<string, string>();
            data.Add("key1", "value1");
            data.Add("key2", "value2");
            data.Add("key3", "value3");
            Assert.IsTrue(target.Send(recipients, CLIENT_TAG, subject, body, data, fileInfo, false));

            // third pass - some keys for data, sampleAttachment.txt fileinfo
            subject = "third test email";
            body = "Some data, an attachment";
            fileInfo = new FileInfo(ATTACHMENT_PATH);
            Assert.IsTrue(target.Send(recipients, CLIENT_TAG, subject, body, data, fileInfo, false));
        }
    }
}
