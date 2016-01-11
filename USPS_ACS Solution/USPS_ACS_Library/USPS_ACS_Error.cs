using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using USPS_ACS_Library.Enums;

namespace USPS_ACS_Library
{
    

    class USPS_ACS_Error
    {
        #region private members

        private ErrorType mErrorType;

        private string mZipFileName = string.Empty;
        private string mExtractFileName = string.Empty;
        private string mErrorMessage = string.Empty;
        private string mStackTrace = string.Empty;


        #endregion

        #region public properties
        #endregion

        #region private properties

        private string TableRowHtml
        {
            get 
            {
                if (mErrorType == ErrorType.Download)
                {
                    return String.Format("<TR><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{0}</TD><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{1}</TD><TD style=\"background-color: #CDE1FA;padding: 5px; White-space: wrap\">{2}</TD></TR>", mZipFileName, mExtractFileName, mErrorMessage); 
                }
                else {
                    return String.Format("<TR><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{0}</TD><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{1}</TD><TD style=\"background-color: #CDE1FA;padding: 5px; White-space: wrap\">{2}</TD></TR>", mZipFileName, mExtractFileName, mErrorMessage); 
                }
                
            }
        }

        private string TableRowText
        {
            get
            {
                return String.Format("               {0}                            {1}               {2}", mZipFileName.PadRight(30), mExtractFileName.PadRight(15), mErrorMessage);
            }
        }

        #endregion

        #region constructors

        public USPS_ACS_Error(string zipfilename, string extractfilename, string errormessage)
        {

            mZipFileName = zipfilename;
            mExtractFileName = extractfilename;
            mErrorMessage = errormessage;
        }

        public USPS_ACS_Error(ErrorType errorType, string errormessage)
        {
            mErrorType = errorType;
            mErrorMessage = errormessage;
        }

        public USPS_ACS_Error(ErrorType errorType, string zipfilename, string extractfilename, string errormessage)
        {
            mErrorType = errorType;
            mZipFileName = zipfilename;
            mExtractFileName = extractfilename;
            mErrorMessage = errormessage;
        }

        public USPS_ACS_Error(ErrorType errorType, string zipfilename, string extractfilename, string errormessage, string stacktrace)
        {
            mErrorType = errorType;
            mZipFileName = zipfilename;
            mExtractFileName = extractfilename;
            mErrorMessage = errormessage;
            mStackTrace = stacktrace;
        }

        #endregion

        #region public methods
        #endregion

        #region public static methods

        public static string GetErrorTableText(List<USPS_ACS_Error> errorList)
        {
            string errString = string.Empty;


            if (errorList.Count > 0)
            {
                errString = System.Environment.NewLine + System.Environment.NewLine +
                        "               Download File                    Extracted File  Error Message" + System.Environment.NewLine +
                        "               -------------------------------  --------------- -------------------------";


                foreach (USPS_ACS_Error item in errorList)
                {
                    errString += System.Environment.NewLine + item.TableRowText;
                }
            }


            return errString;
        }

        public static string GetErrorTableHtml(List<USPS_ACS_Error> errorList)
        {
            string errString = string.Empty;

            if (errorList.Count > 0)
            {
                //Begin the table
                errString = @"<BR><BR><TABLE style=""background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">";

                //Add the table header
                errString += @"<TR><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">DownloadFile</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Extracted File</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Error Message</TD></TR>";


                foreach (USPS_ACS_Error item in errorList)
                {
                    errString += System.Environment.NewLine + item.TableRowHtml;
                }

                errString += "</TABLE>";
            }

            return errString;
        }

        #endregion

    }
}
