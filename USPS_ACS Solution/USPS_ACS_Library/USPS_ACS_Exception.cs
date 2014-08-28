using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServiceLogging;

namespace USPS_ACS_Library
{
    [Serializable]
    class USPS_ACS_Exception: Exception
    {

        #region private members
        private List<USPS_ACS_Error> mErrorList;
        #endregion

        #region public properties
        public List<USPS_ACS_Error> ErrorList
        {
            get{
                if (mErrorList == null)
                {
                    mErrorList = new List<USPS_ACS_Error>();
                }

                return mErrorList;
            }
        }
        #endregion

        #region constructors
        public USPS_ACS_Exception(string message): base(message)
        {
        }

        public USPS_ACS_Exception(string message,Exception innerException): base(message, innerException)
        {
        }

        public USPS_ACS_Exception(string message, List<USPS_ACS_Error> errorList)
            : base(message)
        {
            mErrorList = errorList;
        }

        public USPS_ACS_Exception(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
            : base(info, context)
        {
        }

        #endregion
    }
}
