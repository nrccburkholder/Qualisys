using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace USPS_ACS_Library.Objects
{
    class ExtractLog
    {

        #region private members
        private string mFilename = "";
        private string mFilepath = "";
        private string mVersion = "";
        private string mDetailRecordIndicator = "";
        private string mCustomerID = "";
        private string mRecordCount = "";
        private string mCreatedDate = "";
        private string mHeaderText = "";
        private string mZipFileName = "";
        private string mStatus = "";

        #endregion

        #region public properties

        public string FileName
        {
            get { return mFilename; }
            set { mFilename = value; }
        }

        public string FilePath
        {
            get { return mFilepath; }
            set { mFilepath = value; }
        }

        public string Version
        {
            get { return mVersion; }
            set { mVersion = value; }
        }
        public string DetailRecordIndicator
        {
            get { return mDetailRecordIndicator; }
            set { mDetailRecordIndicator = value; }
        }

        public string CustomerID
        {
            get { return mCustomerID; }
            set { mCustomerID = value; }
        }

        public string RecordCount
        {
            get { return mRecordCount; }
            set { mRecordCount = value; }
        }

        public string CreatedDate
        {
            get { return mCreatedDate; }
            set { mCreatedDate = value; }
        }

        public string HeaderText
        {
            get { return mHeaderText; }
            set { mHeaderText = value; }
        }

        public string ZipFileName
        {
            get { return mZipFileName; }
            set { mZipFileName = value; }
        }

        public string Status
        {
            get { return mStatus; }
            set { mStatus = value; }
        }

        #endregion


        #region constructors
        public ExtractLog()
        {

        }

        public ExtractLog(string filename, string filepath, string version, string detailrecordindicator, string customerid, string recordcount, string createddate, string headertext, string zipfilename, string status)
        {
            mFilename = filename;
            mVersion = version;
            mDetailRecordIndicator = detailrecordindicator;
            mCustomerID = customerid;
            mRecordCount = recordcount;
            mCreatedDate = createddate;
            mHeaderText = headertext;
            mZipFileName = zipfilename;
            mStatus = status;
        }
        #endregion
    }
}
