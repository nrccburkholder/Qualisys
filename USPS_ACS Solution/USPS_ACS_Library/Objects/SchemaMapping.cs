using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace USPS_ACS_Library.Objects
{

    class Schema
    {
        private int mSchema_id;
        private string mSchemaName;
        private string mVersion;
        private string mDetailRecordIndicator;
        private int mRecordlength;
        private DateTime mExpirydate;
        private List<SchemaMapping> mSchemaMappingList;

        public int USPS_ACS_Schema_ID
        {
            get { return mSchema_id; }
            set { mSchema_id = value; }
        }

        public string DetailRecordIndicator
        {
            get { return mDetailRecordIndicator; }
            set { mDetailRecordIndicator = value; }
        }

        public string SchemaName
        {
            get { return mSchemaName; }
            set { mSchemaName = value; }
        }
        public string Version
        {
            get { return mVersion; }
            set { mVersion = value; }
        }

        public int Recordlength
        {
            get {return mRecordlength;}
            set {mRecordlength = value;}
        }

        public DateTime ExpiryDate
        {
            get {return mExpirydate;}
            set {mExpirydate = value;}
        }

        public List<SchemaMapping> SchemaMappingList
        {
            get {return mSchemaMappingList;}
            set {mSchemaMappingList = value;}
        }

        public Schema()
        {
            mSchemaMappingList = new List<SchemaMapping>();
        }

        public Schema(DataSet ds)
        {

            if (ds.Tables.Count > 0)
            { 

                mSchema_id = Convert.ToInt32(ds.Tables[0].Rows[0]["USPS_ACS_Schema_ID"]);
                mSchemaName = ds.Tables[0].Rows[0]["SchemaName"].ToString();
                mVersion = ds.Tables[0].Rows[0]["FileVersion"].ToString();
                mDetailRecordIndicator = ds.Tables[0].Rows[0]["DetailRecordIndicator"].ToString();
                mRecordlength = Convert.ToInt32(ds.Tables[0].Rows[0]["RecordLength"]);
                mExpirydate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ExpiryDate"]);

                mSchemaMappingList = new List<SchemaMapping>();

                foreach (DataRow dr in ds.Tables[1].Rows)
                {
                    mSchemaMappingList.Add(new SchemaMapping(dr));
                }
            }

        }

        public Schema(int schemaid, string version, string detailrecordindicator, int recordlength, DateTime expirydate)
        {
            mSchema_id = schemaid;
            mVersion = version;
            mDetailRecordIndicator = detailrecordindicator;
            mRecordlength = recordlength;
            mExpirydate = expirydate;
            mSchemaMappingList = new List<SchemaMapping>();
        }

    }

    class SchemaMapping
    {

        #region private members

        private string mRecordType;
        private string mColumnName;
        private int mColumnStart;
        private int mColumnWidth;

        #endregion

        #region public properties

       
        public string Recordtype
        {
            get { return mRecordType; }
            set { mRecordType = value; }
        }

        public string ColumnName
        {
            get { return mColumnName; }
            set { mColumnName = value; }
        }

        public int ColumnStart
        {
            get { return mColumnStart; }
            set { mColumnStart = value; }
        }

        public int ColumnWidth
        {
            get { return mColumnWidth; }
            set { mColumnWidth = value; }
        }

        #endregion

        #region constructors


        public SchemaMapping()
        {

        }

        public SchemaMapping(int schemaid, string recordtype, string columnname, int columnstart, int columnwidth)
        {;
            mRecordType = recordtype;
            mColumnName = columnname;
            mColumnStart = columnstart;
            mColumnWidth = columnwidth;
        }

        public SchemaMapping(DataRow dr)
        {

            mRecordType = dr["RecordType"].ToString();
            mColumnName = dr["ColumnName"].ToString();
            mColumnStart = Convert.ToInt32(dr["ColumnStart"]);
            mColumnWidth = Convert.ToInt32(dr["ColumnWidth"]);          
        }

        #endregion
    }
}
