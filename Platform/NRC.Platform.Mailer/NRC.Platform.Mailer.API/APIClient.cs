using System;
using System.Collections.Generic;
using System.Reflection;
using System.IO;

using Newtonsoft.Json;

using RESTClient = NRC.Common.Web.RESTClient;

namespace NRC.Platform.Mailer.API
{
    public class APIClient : RESTClient
    {
        public APIClient(string baseUrl)
            : base(baseUrl)
        {
        }

        public bool Send(string[] recipients, string clientTag, string subject,
            string body, Dictionary<string, string> data,
            FileInfo fileInfo, bool isHTML)
        {
            Dictionary<string, string> args = new Dictionary<string, string>();
            args.Add("recipients", String.Join(", ", recipients));
            args.Add("clientTag", clientTag);
            args.Add("subject", subject);
            args.Add("body", body);
            args.Add("isHTML", isHTML.ToString());

            if (data != null)
            {
                string serializedData = JsonConvert.SerializeObject(data);
                args.Add("data", serializedData);
            }

            if (fileInfo != null)
            {
                args.Add("attachmentName", fileInfo.Name);
                return CallServiceWithFile<bool>(MethodBase.GetCurrentMethod().Name, "POST", args, fileInfo.Name, fileInfo);
            }
            else
            {
                return CallService<bool>(MethodBase.GetCurrentMethod().Name, "POST", args);
            }
        }
    }
}
