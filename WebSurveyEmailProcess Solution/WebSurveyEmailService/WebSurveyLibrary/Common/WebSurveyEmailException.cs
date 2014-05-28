using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WebSurveyLibrary.Common;

namespace WebSurveyLibrary.Common
{
    [Serializable]
    class WebSurveyEmailException: Exception
    {

        #region private members
        private List<WebSurveyError> mErrorList;
        #endregion

        #region public properties
        public List<WebSurveyError> ErrorList
        {
            get{
                if (mErrorList == null)
                {
                    mErrorList = new List<WebSurveyError>();
                }

                return mErrorList;
            }
        }
        #endregion

        #region constructors
        public WebSurveyEmailException(string message): base(message)
        {
        }

        public WebSurveyEmailException(string message,Exception innerException): base(message, innerException)
        {
        }

        public WebSurveyEmailException(string message, List<WebSurveyError> errorList)
            : base(message)
        {
            mErrorList = errorList;
        }

        public WebSurveyEmailException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
            : base(info, context)
        {
        }

        #endregion
    }
}
