using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using QueueManagerLibrary.Objects;

namespace QueueManagerLibrary.DataProviders
{
    internal class ConfigurationProvider
    {
        private static bool mIsReprint;
        private static string mPCLOutput;

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }

        #region private methods

        private static Configuration PopulateConfiguration(DataRow dr)
        {
            Configuration config = new Configuration();

            config.PaperConfig_Name = dr["strPaperConfig_nm"].ToString();
            config.PaperConfig_ID = (int)dr["PaperConfig_id"];
            config.Pages = (int)dr["intPages"];
            config.Study_ID = (int)dr["Study_id"];
            config.Survey_ID = (int)dr["Survey_id"];
            config.NumPieces = (int)dr[5];
            config.NumberMailed = (int)dr["numMailed"];
            config.DateMailed = (DateTime)dr["datMailed"];

            string strDateBundled = config.PaperConfig_Name.Substring(0, config.PaperConfig_Name.IndexOf("  "));

            DateTime datBundled = DateTime.Parse(strDateBundled);

            config.PaperConfigList = PaperConfigProvider.SelectPaperConfigList(mPCLOutput, mIsReprint, config.Survey_ID, datBundled, config.PaperConfig_ID);

            return config;
        }


        private static List<Configuration> PopulateConfigurationList(DataSet ds)
        {
            List<Configuration> configList = new List<Configuration>();

            if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    configList.Add(PopulateConfiguration(dr));
                }
            }

            return configList;
        }


        internal static List<Configuration> SelectConfigurationList(string pclOutput, bool isReprint, int SurveyID)
        {
            mPCLOutput = pclOutput;
            mIsReprint = isReprint;
            string queueType = isReprint == true ? "M" : "P";

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@PCLOutput",pclOutput),
                                                       new SqlParameter("Survey_id", SurveyID),
                                                       new SqlParameter("@QueueType",queueType)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "SP_Queue_BundleList", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateConfigurationList(ds);
            }

        }

        #endregion

    }
}
