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
    internal  class ClientProvider
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

        private static Client PopulateClient(DataRow dr)
        {

            Client client = new Client();
            client.ClientName = dr["strclient_nm"].ToString();
            client.SurveyName = dr["strSurvey_nm"].ToString();
            client.SurveyID = (int)dr["Survey_id"];
            client.SurveyDescription = dr["SurveyType_dsc"].ToString();
            client.SurveyType_ID = (int)dr["SurveyType_id"];
            client.NumberOfPieces = (int)dr["numPieces"];
            client.NumberPrinted = (int)dr["numPrinted"];
            client.NumberMailed = (int)dr["numMailed"];
            client.NumberInGroupPrint = (int)dr["numInGroupedPrint"];

            client.Configurations = Configuration.SelectConfigurationList(mPCLOutput,mIsReprint, client.SurveyID);

            return client;
            
        }

        private static List<Client> PopulateClientList(DataSet ds)
        {

            List<Client> clients = new List<Client>();
             if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    clients.Add(PopulateClient(dr));
                }
             }
            
            return clients;
        }


        #endregion

        #region public methods

        internal static List<Client> SelectClientList(string pclOutput, bool isReprint)
        {
            mIsReprint = isReprint;
            mPCLOutput = pclOutput;

            string queueType = isReprint == true ? "M" : "P";

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@PCLOutput",pclOutput),
                                                       new SqlParameter("@QueueType",queueType)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "QQM_ClientList", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateClientList(ds);
            }

        }

        #endregion

    }
}
