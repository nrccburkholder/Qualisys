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

        private int mID;
        private int mSurveyID;
        private string mLitho = string.Empty;
        private string mErrorMessage = string.Empty;

        


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
                    return String.Format("<TR><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{0}</TD><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{1}</TD><TD style=\"background-color: #CDE1FA;padding: 5px; White-space: wrap\">{2}</TD><TD style=\"background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: wrap\">{3}</TD></TR>", mID.ToString(), mSurveyID.ToString(), mLitho, mErrorMessage); 
                }
                else {
                    return String.Format("<TR><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{0}</TD><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{1}</TD><TD style=\"background-color: #CDE1FA;padding: 5px; White-space: wrap\">{2}</TD><TD style=\"background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: wrap\">{3}</TD></TR>", mID.ToString(), mSurveyID.ToString(), mLitho, mErrorMessage); 
                }
                
            }
        }

        private string TableRowText
        {
            get
            {
                return String.Format("               {0}  {1}  {2}  {3}", mID.ToString().PadLeft(5), mSurveyID.ToString().PadLeft(5), mLitho.PadRight(10), mErrorMessage);
            }
        }

        #endregion

        #region constructors

        public USPS_ACS_Error(int id, int surveyid, string litho, string errormessage)
        {
            mID = id;
            mSurveyID = surveyid;
            mLitho = litho;
            mErrorMessage = errormessage;
        }

        public USPS_ACS_Error(ErrorType errorType, string errormessage)
        {
            mErrorType = errorType;
            mErrorMessage = errormessage;
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
                        "               Row #  Survey  Litho/WAC   Error Message" + System.Environment.NewLine +
                        "               -----  ------  ----------  -------------------------";


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
                errString += @"<TR><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Row #</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Survey</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Litho/WAC</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Error Message</TD></TR>";


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
