using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Web;
using System.Net;
using System.IO;
using System.Xml;
using System.Data;
using System.Data.SqlClient;



namespace PersonatorAddressCleaner_POC
{
    class Program
    {
        static void Main(string[] args)
        {
            string environment = "STAGE";
            int dataFile_id = 475774;
            int study_id = 5575;
            int batchSize = 100;
            int totalBatches = 59;

            Console.WriteLine("MelissaData Personator Address Cleaner");
            Console.WriteLine(string.Format("Running for:\n\tQualisys Environment {0}\n\tDataFile_Id {1}\n\tStudy_Id {2}\n\tMaxRecords {3}\n\tTotalBatches {4}",
                environment, dataFile_id, study_id, batchSize, totalBatches));
            Console.WriteLine();

            int totalMatch = 0, totalMismatch = 0;

            for(int batchIdx = 0; batchIdx < totalBatches; ++batchIdx)
            {
                int countMatch, countMismatch;
                ProcessBatch(environment, dataFile_id, study_id, batchIdx, batchSize, out countMatch, out countMismatch);
                totalMatch += countMatch;
                totalMismatch += countMismatch;
            }

            Console.WriteLine("FINAL Compare Counts");
            Console.WriteLine("      MATCHES " + totalMatch);
            Console.WriteLine("   MISMATCHES " + totalMismatch);

            
            Console.WriteLine("Press ENTER to exit.");
            Console.ReadLine();
        }


        static void ProcessBatch(string environment, int DataFile_id, int Study_id, int batchIdx, int batchSize, out int countMatch, out int countMismatch)
        {
            countMatch = countMismatch = 0;

            string responseText = MelissaDataApiJsonCall(environment, DataFile_id, Study_id, batchIdx, batchSize);

            JObject jObj = null;
            try
            {
                jObj = JObject.Parse(responseText);
                //Console.WriteLine("API RESPONSE");
                //Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(jObj, Newtonsoft.Json.Formatting.Indented));
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unable to parse json: " + ex.Message);
                Console.WriteLine("API RESPONSE");
                Console.WriteLine(responseText);
                Console.WriteLine();
            }


            try
            {
                if (jObj != null)
                {
                    Console.WriteLine();
                    Console.WriteLine("Comparing Against QP_Load..EncounterTable");
                    CompareResultAgainStudyPopulationTable(jObj, environment, DataFile_id, Study_id, batchIdx, batchSize, out countMatch, out countMismatch);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unable to compare against encounters: " + ex.Message);
                Console.WriteLine();
            }
        }

        public static string MelissaDataApiJsonCall(string environment, int DataFile_id, int Study_id, int batchIdx, int batchSize)
        {
            string TransmissionReference = ""; //The Transmission Reference is a unique string value that identifies this particular request
            string CustomerID = "99869570"; // I think this was provided by BJ
            string Actions = "Check"; //The Check action will validate the individual input data pieces for validity and correct them if possible. 
            string Options = "AdvancedAddressCorrection:on";//UsePreferredCity:on
            string Columns = "GrpCensus,GrpGeocode"; //To use Geocode, you must have the geocode columns on: GrpCensus or GrpGeocode.

            var httpWebRequest = (HttpWebRequest)WebRequest.Create("https://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify");
            httpWebRequest.ContentType = "text/json";
            httpWebRequest.Method = "POST";

            var serializer = new Newtonsoft.Json.JsonSerializer();
            using (var sw = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                using (var tw = new Newtonsoft.Json.JsonTextWriter(sw))
                {
                    var requestData = new
                        {
                            TransmissionReference = TransmissionReference,
                            CustomerID = CustomerID,
                            Actions = Actions,
                            Options = Options,
                            Columns = Columns,
                            Records = BuildAddressRecords(environment, DataFile_id, Study_id, batchIdx, batchSize)
                        };

                    serializer.Serialize(tw, requestData);
                }
            }
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var responseText = streamReader.ReadToEnd();
                return responseText;
            }
        }

        private static object[] BuildAddressRecords(string environment, int DataFile_Id, int Study_Id, int batchIdx, int batchSize)
        {
            bool CLEAN_PHONE = false;
            bool CLEAN_NAME = false;

            List<object> addressCleanRecords = new List<object>();

            //Pull records from DataFile
            DataTable encounters = GetDataFileRecords(environment, DataFile_Id, batchIdx, batchSize);

            foreach (DataRow e in encounters.Rows)
            {
                string RecordID = e["DF_id"].ToString(); //e["DataFile_id"].ToString() + "_" + 
                string CompanyName = "";
                string FullName;
                string Middle = e["Middle"].ToString().Trim();

                if (CLEAN_NAME)
                {
                    if (string.IsNullOrWhiteSpace(Middle))
                    { FullName = string.Concat(e["FName"], " ", e["LName"]); }
                    else
                    { FullName = string.Concat(e["FName"], " ", Middle, " ", e["LName"]); }
                }
                else
                {
                    FullName = "";
                }


                /* NOTE:  The "raw" column names for a datafile will not always match these.  The current AddressCleaner makes a call to AC_GetMetaGroups and then reassigns to use "common" names*/
                string AddressLine1 = e["Addr"].ToString(); //e["Addr"].ToString();
                string AddressLine2 = e["Addr2"].ToString();
                string Suite = "";
                string City = e["City"].ToString();
                string State = e["ST"].ToString();
                string PostalCode = e["Zip5"].ToString();
                string Country = "";
                string PhoneNumber = CLEAN_PHONE ? string.Concat(e["AreaCode"], e["Phone"]) : "";
                string EmailAddress = "";
                string FreeForm = "";

                var o = new
                {
                    RecordID = RecordID,
                    CompanyName = CompanyName,
                    FullName = FullName,
                    AddressLine1 = AddressLine1,
                    AddressLine2 = "", //AddressLine2,
                    Suite = Suite,
                    City = City,
                    State = State,
                    PostalCode = PostalCode,
                    Country = Country,
                    PhoneNumber = PhoneNumber,
                    EmailAddress = EmailAddress,
                    FreeForm = FreeForm,
                };

                addressCleanRecords.Add(o);
            }


            return addressCleanRecords.ToArray();
        }

        private static DataTable GetDataFileRecords(string environment, int datafile_id, int batchIdx, int batchSize)
        {
            //string limitExpression = maxRecords > 0 ? string.Format(" WHERE DF_ID <= {0} ", maxRecords) : "";
            //string sql = string.Format("SELECT * FROM DataFile_{0}{1}", datafile_id, limitExpression);
            int offset = (batchIdx * batchSize) + 1;
            string sql = string.Format("SELECT * FROM DataFile_{0} WHERE DF_ID >= {1} AND DF_ID<{2} ORDER BY DF_ID", datafile_id, offset, offset + batchSize);
            return SelectTableFromDB(environment, sql);
        }

        private static DataTable SelectTableFromDB(string environment, string sql)
        {
            Console.WriteLine("Executing SQL: " + sql);

            string serverName = GetEnvironmentQPLoadServerName(environment);

            string connStr = string.Format("Server={0};Database=QP_Load;Trusted_Connection=True;", serverName);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter sda = new SqlDataAdapter(sql, conn);
                DataTable table = new DataTable();
                try
                {
                    conn.Open();
                    sda.Fill(table);
                }
                finally
                {
                    conn.Close();
                }
                return table;
            }
        }

        private static string GetEnvironmentQPLoadServerName(string environment)
        {
            string serverName;
            if (environment.ToUpper() == "STAGE")
            {
                serverName = "Cyclone";
                return serverName;
            }
            {
                throw new Exception(string.Format("Don't know how to reach environment: [{0}]", environment));
            }
        }

        private static void CompareResultAgainStudyPopulationTable(dynamic personatorResponse, string environment, int datafile_id, int study_id, int batchIdx, int batchSize, out int countMatch, out int countMismatch)
        {
            Console.WriteLine("Starting Data Compare");
            int offset = (batchIdx * batchSize) + 1;
            string sql = string.Format("SELECT * FROM S{0}.POPULATION_Load WHERE DataFile_id = {1} AND DF_ID >= {2} AND DF_ID<{3} ORDER BY DF_ID", study_id, datafile_id , offset, offset + batchSize);
            DataTable pops = SelectTableFromDB(environment, sql);

            countMatch = 0; countMismatch = 0;

            for (int i = 0; i < pops.Rows.Count; ++i )
            {
                var cleanRecord = personatorResponse.Records[i];
                DataRow pop = pops.Rows[i];

                string cleanAddr1 = cleanRecord["AddressLine1"].ToString().Trim().ToUpper();
                string cleanAddr2 = cleanRecord["AddressLine2"].ToString().Trim().ToUpper();
                string cleanAddr = cleanAddr1 + (string.IsNullOrWhiteSpace(cleanAddr2) ? "" : (" " + cleanAddr2));
                string cleanResultCode = cleanRecord["Results"];

                string popAddr1 = pop["Addr"].ToString();
                string popAddr2 = pop["Addr2"].ToString();
                string popAddr = popAddr1 + (string.IsNullOrWhiteSpace(popAddr2) ? "" : (" " + popAddr2));
                string popResultCode = pop["AddrStat"].ToString();

                if(cleanAddr == popAddr && cleanResultCode == popResultCode)
                {
                    countMatch++;
                    //Console.WriteLine("PSEUDO-MATCH (upper casing, unsplit)");
                    //Console.WriteLine("Personator: [" + cleanAddr + "]\t[" + cleanResultCode + "]");
                    //Console.WriteLine("Legacy:     [" + popAddr + "]\t[" + popResultCode + "]");
                }
                else
                {
                    countMismatch++;
                    Console.WriteLine("MISMATCH");
                    Console.WriteLine("Personator: [" + cleanAddr + "]\t[" + cleanResultCode + "]");
                    Console.WriteLine("Legacy:     [" + popAddr + "]\t[" + popResultCode + "]");
                    Console.WriteLine();
                }
            }
            Console.WriteLine("Batch Compare Counts");
            Console.WriteLine("      MATCHES " + countMatch);
            Console.WriteLine("   MISMATCHES " + countMismatch);
        }

    }
}
