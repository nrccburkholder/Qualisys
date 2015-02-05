using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using USPS_ACS_Library.Objects;
using USPS_ACS_Library.Enums;

namespace USPS_ACS_Library
{
    class USPS_ACS_Notification
    {

        #region private members

        private string mStatus = string.Empty;

        private PopAddress mPopAddress = new PopAddress();
        private USPSAddress mUSPSAddress = new USPSAddress();

        private string mZipFileName = string.Empty;
        private string mExtractFileName = string.Empty;

        private int mRecordCount = 0;

        #endregion

        #region public properties


        public string ZipFileFile
        {
            get { return mZipFileName; }
            set { mZipFileName = value; }
        }

        public string ExtractFileName
        {
            get {return mExtractFileName;}
            set { mExtractFileName = value; }
        }

        public int RecordCount
        {
            get {return mRecordCount;}
            set { mRecordCount = value; }
        }

        public string Status
        {
            get { return mStatus; }
            set { mStatus = value; }
        }

        public NotificationType FileType { get; set; }

        #endregion

        #region private properties
        private string ExtractTableRowHtml
        {
            get
            {
                return String.Format("<TR><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{0}</TD><TD align=\"Right\" style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{1}</TD><TD align=\"Center\"style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{2}</TD><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{3}</TD></TR>", mExtractFileName, mRecordCount.ToString(), mStatus, mZipFileName);
            }
        }

        private string ExtractTableRowText
        {
            get
            {
                return String.Format("               {0}                            {1}                            {2}", mExtractFileName.PadRight(15), mRecordCount.ToString(), mStatus);
            }
        }

        private string DownloadTableRowHtml
        {
            get
            {
                return String.Format("<TR><TD style=\"background-color: #CDE1FA; padding: 5px; White-space: nowrap\">{0}</TD></TR>", mZipFileName);
            }
        }

        private string DownloadTableRowText
        {
            get
            {
                return String.Format("               {0}", mZipFileName.PadRight(30));
            }
        }

        #endregion

        #region constructors

        public USPS_ACS_Notification()
        {

        }


        #endregion

        #region public static methods


        public static string GetNotificationTableText(List<USPS_ACS_Notification> notificationList, NotificationType ntype)
        {
            string messageString = string.Empty;


            if (notificationList.Count > 0)
            {
                if (ntype == NotificationType.Download)
                    messageString = System.Environment.NewLine + System.Environment.NewLine +
                        "               Download File                  " + System.Environment.NewLine +
                        "               -------------------------------";
                else
                    messageString = System.Environment.NewLine + System.Environment.NewLine +
                       "               Extract File                     Record Count   " + System.Environment.NewLine +
                       "               -------------------------------  ---------------";

                foreach (USPS_ACS_Notification item in notificationList)
                {
                    if (item.FileType == NotificationType.Download)
                        messageString += System.Environment.NewLine + item.DownloadTableRowHtml;
                    else
                        messageString += System.Environment.NewLine + item.ExtractTableRowHtml;
                }
            }


            return messageString;
        }

        public static string GetNotificationTableHtml(List<USPS_ACS_Notification> notificationList, NotificationType ntype)
        {
            string messageString = string.Empty;

            if (notificationList.Count > 0)
            {
                //Begin the table
                messageString = @"<BR><BR><TABLE style=""background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small"" Width=""70%"" cellpadding=""0"" cellspacing=""1"">";

                //Add the table header

                if (ntype == NotificationType.Download)
                    messageString += @"<TR><TH style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Download File</TH></TR>";
                else
                    messageString += @"<TR><TH style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Extract File</TH><TH style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Record Count</TH><TH style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">File Status</TH><TH style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Download Source</TH></TR>";

                foreach (USPS_ACS_Notification item in notificationList)
                {
                    if (item.FileType == NotificationType.Download)
                        messageString += System.Environment.NewLine + item.DownloadTableRowHtml;
                    else 
                        messageString += System.Environment.NewLine + item.ExtractTableRowHtml;
                }

                messageString += "</TABLE>";
            }
            else
            {
                if (ntype == NotificationType.Download)
                    messageString += "No files to download.";
                else
                    messageString += "No files to extract.";

            }

            return messageString;
        }

        #endregion
    }
}
