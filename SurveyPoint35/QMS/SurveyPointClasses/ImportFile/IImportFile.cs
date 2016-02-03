using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SurveyPointDAL;
using System.Data.SqlClient;

namespace SurveyPointClasses
{
    public interface IImportFile
    {
        int RespondentID
        {
            get;
        }

        int FileDefID
        {
            get;
            set;
        }

        int SurveyID
        {
            get;
            set;
        }

        int ClientID
        {
            get;
            set;
        }

        int SurveyInstanceID
        {
            get;
            set;
        }

        bool AllowRedoOfResponses
        {
            get;
            set;
        }

        int ErrorCount
        {
            get;
            set;
        }

        int WarnCount
        {
            get;
            set;
        }

        string ErrorMessage
        {
            get;
        }

        string WarningMessage
        {
            get;
        }

        int TemplateID
        {
            get;
            set;
        }

        string SetupParameters
        {
            get;
        }

        SqlTransaction DBTransaction
        {
            get;
            set;
        }

        void ImportRow(string sRow);

    }

}
