using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using SurveyPointDAL;

namespace SurveyPointClasses.ImportFile
{
    /// <summary>
    /// Summary description for clsFixedWidth.
    /// </summary>
    public class clsFixedWidth : IImportFile
    {
        public clsFixedWidth()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #region IImportFile Members
        private int _RespondentID;
        private int _FileDefID;
        private int _SurveyID;
        private int _SurveyInstanceID;
        private int _ClientID;
        private bool _allowRedoOfResponses = false;
        private int _ErrorCount;
        private int _WarnCount;
        private int _TemplateID;
        private string _ErrorMsg;
        private string _WarnMsg;
        private SqlTransaction _transaction = null;

        public int RespondentID
        {
            get
            {
                return _RespondentID;
            }
        }

        public int FileDefID
        {
            get
            {
                return _FileDefID;
            }
            set
            {
                _FileDefID = value;
            }
        }

        public int SurveyID
        {
            get
            {
                return _SurveyID;
            }
            set
            {
                _SurveyID = value;
            }
        }

        public int SurveyInstanceID
        {
            get
            {
                return _SurveyInstanceID;
            }
            set
            {
                _SurveyInstanceID = value;
            }
        }

        public bool AllowRedoOfResponses
        {
            get
            {
                return _allowRedoOfResponses;
            }
            set
            {
                _allowRedoOfResponses = value;
            }
        }

        public int ClientID
        {
            get
            {
                return _ClientID;
            }
            set
            {
                _ClientID = value;
            }
        }

        public int ErrorCount
        {
            get
            {
                return _ErrorCount;
            }
            set
            {
                _ErrorCount = value;
            }
        }

        public int WarnCount
        {
            get
            {
                return _WarnCount;
            }
            set
            {
                _WarnCount = value;
            }
        }

        public int TemplateID
        {
            get
            {
                return _TemplateID;
            }
            set
            {
                _TemplateID = value;
            }
        }

        public string ErrorMessage
        {
            get
            {
                return _ErrorMsg;
            }
        }

        public string WarningMessage
        {
            get
            {
                return _WarnMsg;
            }
        }

        public string SetupParameters
        {
            get
            {
                // TODO:  Add clsFixedWidth.SetupParameters getter implementation
                return null;
            }
        }

        public SqlTransaction DBTransaction
        {
            get { return _transaction; }
            set { _transaction = value; }
        }

        public void ImportRow(string sRow)
        {
            IDataReader dr = null;
            try
            {
                // run stored procedure to import line
                if (DBTransaction == null)
                    dr = clsTemplate.importResponses(this.FileDefID, sRow, this.SurveyInstanceID, AllowRedoOfResponses);
                else
                    dr = clsTemplate.importResponses(DBTransaction, this.FileDefID, sRow, this.SurveyInstanceID, AllowRedoOfResponses);

                // read results of the import
                if (dr.Read())
                {
                    Object colValue = dr[0]; // get respondent id
                    if (colValue != DBNull.Value) _RespondentID = Convert.ToInt32(colValue);
                    colValue = dr[1];		// get file def id
                    if (colValue != DBNull.Value) _FileDefID = Convert.ToInt32(colValue);
                    colValue = dr[2];		// get survey id
                    if (colValue != DBNull.Value) _SurveyID = Convert.ToInt32(colValue);
                    //colValue = dr[3];		// get survey instance id
                    //if (colValue != DBNull.Value) _SurveyInstanceID = Convert.ToInt32(colValue);
                    colValue = dr[4];		// get client id
                    if (colValue != DBNull.Value) _ClientID = Convert.ToInt32(colValue);
                    colValue = dr[5];		// get error count
                    if (colValue != DBNull.Value) _ErrorCount = Convert.ToInt32(colValue);
                    colValue = dr[6];		// get warning count
                    if (colValue != DBNull.Value) _WarnCount = Convert.ToInt32(colValue);

                    // get error and warning messages
                    if (dr.NextResult())
                    {
                        StringBuilder sbError = new StringBuilder();
                        StringBuilder sbWarn = new StringBuilder();
                        while (dr.Read())
                        {
                            if (dr["severity"] == DBNull.Value)
                                sbError.AppendFormat("{0}\r\n", dr[2]);
                            else
                                sbWarn.AppendFormat("{0}\r\n", dr[2]);
                        }

                        if (sbError.Length > 0)
                            _ErrorMsg = sbError.ToString();
                        else
                            _ErrorMsg = null;

                        if (sbWarn.Length > 0)
                            _WarnMsg = sbWarn.ToString();
                        else
                            _WarnMsg = null;

                    }
                }

            }
            finally
            {
                if (dr != null && !dr.IsClosed) dr.Close();
            }
        }

        #endregion
    }
}
