using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.IO;

namespace NRC.Picker.PCLGenWatchdog.RemoteMonitoringService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IPCLGenStatusService
    {
        [OperationContract]
        Status GetStatus();

        [OperationContract]
        void SetStatus(Status status);

        [WebGet]
        [OperationContract]
        Stream GetScreenShot();

        [WebGet]
        [OperationContract]
        Stream GetLastSavedScreenShot();

    }

}
