using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using USPS_ACS_Library.Enums;

namespace USPS_ACS_Library.Objects
{
    public class UpdateResult
    {
        private ExtractFileRecordStatus mStatus;
        private string mMessage;

        public ExtractFileRecordStatus Status
        {
            get { return mStatus; }
            set { mStatus = value; }
        }

        public string Message
        {
            get { return mMessage; }
            set { mMessage = value; }
        }

        public UpdateResult()
        {

        }

        public UpdateResult(int status, string message)
        {
            mStatus = (ExtractFileRecordStatus)status;
            mMessage = message;
        }
    }
}
