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


        internal static DataSet SelectSubmissionData(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

    
            DataSet ds = new DataSet();
            //SqlProvider.Fill(ref ds, "CIHI.Select_Final_Metadata", CommandType.StoredProcedure, param);

            SqlProvider.Fill(ref ds, "temp_CIHI_Select_All_By_SubmissionID", CommandType.StoredProcedure, param);


            return ds;
        }

        internal static DataSet SelectSubmissionMetadata()
        {
            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_Metadata", CommandType.StoredProcedure);

            return ds;
        }

        internal static DataSet SelectSubmissionMetadata(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            string commandText = $@"SELECT [Final_MetadataID]
		                      ,[submissionID]
		                      ,[creationTime_value]
		                      ,[sender.device.manufacturer.id.value]
		                      ,[sender.organization.id.value]
		                      ,[versionCode_code]
		                      ,[versionCode_codeSystem]
		                      ,[purpose_code]
		                      ,[purpose_codeSystem]
	                      FROM [CIHI].[Final_Metadata]
	                      WHERE submissionID = {id}";

            DataSet ds = new DataSet();
            //SqlProvider.Fill(ref ds, "CIHI.Select_Final_Metadata", CommandType.StoredProcedure, param);
            SqlProvider.Fill(ref ds, commandText, CommandType.Text);

            return ds;
        }

        internal static DataSet SelectSubmission_OrgProfile(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_OrgProfile", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_Role(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_Role", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_OrgProfile_Contacts(int id )
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_Contact", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_QuestionnaireCycle(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            string commandText = $@"SELECT fqs.[Final_QuestionnaireCycleID]
                                  ,[submissionID]
                                  ,[questionnaireCycle.id.value]
                                  ,[questionnaireCycle.healthCareFacility.id.value]
                                  ,[questionnaireCycle.submissionType_code]
                                  ,[questionnaireCycle.submissionType_codeSystem]
                                  ,[questionnaireCycle.proceduresManualVersion_code]
                                  ,[questionnaireCycle.proceduresManualVersion_codeSystem]
                                  ,[questionnaireCycle.effectiveTime.low_value]
                                  ,[questionnaireCycle.effectiveTime.high_value]
                                  ,[questionnaireCycle.sampleInformation.samplingMethod_code]
                                  ,[questionnaireCycle.sampleInformation.samplingMethod_codeSystem]
                                  ,[questionnaireCycle.sampleInformation.populationInformation.dischargeCount]
                                  ,[questionnaireCycle.sampleInformation.populationInformation.sampleSize]
                                  ,[questionnaireCycle.sampleInformation.populationInformation.nonResponseCount]
                                  ,fs.[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumCode]
		                          ,fs.[questionnaireCycle.sampleInformation.populationInformation.stratum.stratumDescription]
		                          ,fs.[questionnaireCycle.sampleInformation.populationInformation.stratum.dischargeCount]
		                          ,fs.[questionnaireCycle.sampleInformation.populationInformation.stratum.sampleSize]
		                          ,fs.[questionnaireCycle.sampleInformation.populationInformation.stratum.nonResponseCount]
                              FROM [CIHI].[Final_QuestionnaireCycle] fqs
                             INNER JOIN[CIHI].[Final_Stratum] fs on fs.Final_QuestionnairCycleID = fqs.Final_QuestionnaireCycleID
                        WHERE submissionID = {id}";

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_QuestionnaireCycle", CommandType.StoredProcedure, param);
            //SqlProvider.Fill(ref ds, commandText, CommandType.Text);

            return ds;
        }

        internal static DataSet SelectSubmission_Questionnaire(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_Questionnaire", CommandType.StoredProcedure, param);

            return ds;
        }


        internal static DataSet SelectSubmission_Questions(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_Question", CommandType.StoredProcedure, param);

            return ds;
        }

        internal static DataSet SelectSubmission_Stratum(int id)
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ID", id) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CIHI.Select_Final_Stratum", CommandType.StoredProcedure, param);

            return ds;
        }

        #endregion
    }
}
