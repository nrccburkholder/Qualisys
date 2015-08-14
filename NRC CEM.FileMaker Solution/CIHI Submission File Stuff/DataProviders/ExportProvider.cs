using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;

namespace ConsoleApplication1.DataProviders
{
    internal static class ExportProvider
    {

        private static SqlDataProvider mSDP;

        private static SqlDataProvider SqlProvider
        {
            get
            {
                if (mSDP == null)
                {
                    // TODO:  read connection string from a param store.
                    mSDP = new SqlDataProvider();
                }
                return mSDP;
            }
        }

        #region public methods

        //internal static DataSet Select()
        //{
        //    DataSet ds = new DataSet();
        //    SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission", CommandType.StoredProcedure);

        //    return ds;
        //}

        internal static DataSet SelectSubmissionMetadata()
        {
            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_SubmissionMetadata", CommandType.StoredProcedure);

            return ds;
        }

        internal static DataSet SelectSubmissionMetadata(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SubmissionFileID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_SubmissionMetadata", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_OrgProfile(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SubmissionFileID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission_OrgProfile", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_Role(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@orgProfileID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission_Role", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_OrgProfile_Contacts(int id )
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@orgProfileID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission_OrgProfile_Contacts", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_QuestionnaireCycle(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@SubmissionFileID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission_QuestionnaireCycle", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_Questionnaire(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@questionnaireCycleID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission_Questionnaire", CommandType.StoredProcedure, param);

            return ds;
        }


        internal static DataSet SelectSubmission_Questions(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@questionnaireID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "temp_CIHI_Select_Submission_Questions", CommandType.StoredProcedure, param);

            return ds;
        }

        #endregion
    }
}
