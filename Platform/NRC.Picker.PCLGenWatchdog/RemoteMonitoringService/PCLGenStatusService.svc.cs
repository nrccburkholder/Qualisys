using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.IO;
using System.Drawing;

namespace NRC.Picker.PCLGenWatchdog.RemoteMonitoringService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    public class PCLGenStatusService : IPCLGenStatusService
    {
        private static Status CurrentStatus
        {
            get;
            set;
        }

        public void SetStatus(Status status)
        {
            CurrentStatus = status;
            CurrentStatus.ServerName = Environment.MachineName;
        }

        public Status GetStatus()
        {
            return CurrentStatus;
        }

        public Stream GetScreenShot()
        {
            throw new NotImplementedException();
        }

        public Stream GetLastSavedScreenShot()
        {
            using (FileStream fileStream = File.OpenRead(@"pclgenscreenshot.jpg"))
            {
                MemoryStream memStream = new MemoryStream();
                memStream.SetLength(fileStream.Length);
                fileStream.Read(memStream.GetBuffer(), 0, (int)fileStream.Length);

                memStream.Position = 0;
                WebOperationContext.Current.OutgoingResponse.ContentType = "image/jpeg";

                return memStream;
            }
        }
    }
}
