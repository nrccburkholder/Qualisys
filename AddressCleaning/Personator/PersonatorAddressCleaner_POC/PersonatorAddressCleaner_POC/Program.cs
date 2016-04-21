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


            Console.WriteLine("Personator Address Cleaner:  POC ");
            Console.WriteLine();
            Console.WriteLine("Press ENTER to begin.");
            Console.ReadLine();
            Start();
            Console.WriteLine("End of Processing");
            Console.WriteLine("Press ENTER to exit.");
            Console.ReadLine();
            Console.WriteLine("Exiting application...");

        }


        static void Start()
        {
            string responseText = MelissaDataApiJsonCall();
            Console.WriteLine();
            Console.WriteLine(responseText);
            Console.WriteLine(); 
        }

        public static string MelissaDataApiJsonCall()
        {
            string TransmissionReference = "";
            string CustomerID = "99869570";
            string Actions = "Check";
            string Options = "";
            string Columns = "";
            
            //string RecordID = "1";
            //string CompanyName = "NRC";
            //string FullName = "Timothy S Butler";
            //string AddressLine1 = "610 S Evergreen Drive";
            //string AddressLine2 = "";
            //string Suite = "";
            //string City = "Seward";
            //string State = "Nebraska";
            //string PostalCode = "68444";
            //string Country = "USA";
            //string PhoneNumber = "4026416896";
            //string EmailAddress = "tbutler1@neb.rr.com";
            //string FreeForm = "";


            /*
            string RecordID = "1";
            string CompanyName = "";
            string FullName = "Christian Amelinckx";
            string AddressLine1 = "2450 Sewell St";
            string AddressLine2 = "";
            string Suite = "";
            string City = "Lincoln";
            string State = "Nebraska";
            string PostalCode = "68502";
            string Country = "USA";
            string PhoneNumber = "";
            string EmailAddress = "";
            string FreeForm = "";

            {"Records":[{"AddressExtras":" ","AddressKey":"68502403050","AddressLine1":"2450 Sewell St","AddressLine2":" ","City":"Lincoln","CompanyName":" ","EmailAddress":" ","MelissaAddressKey":" ","NameFull":"Christian Amelinckx","PhoneNumber":" ","PostalCode":"68502-4030","RecordExtras":" ","RecordID":"1","Reserved":" ","Results":"AS01,NS01,NS05","State":"NE"}],"TotalRecords":"1","TransmissionReference":" ","TransmissionResults":" ","Version":"4.0.10"}
             */

            string environment = "STAGE";
            int DataFile_id = 427336;
            int Study_id = 4329;

            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://personator.melissadata.net/v3/WEB/ContactVerify/doContactVerify");
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
                            Records = BuildAddressRecords(environment, DataFile_id, Study_id)
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

        private static object[] BuildAddressRecords(string environment, int DataFile_Id, int Study_Id)
        {
            List<object> addressCleanRecords = new List<object>();

            //Pull records from DataFile
            DataTable encounters = GetDataFileRecords(environment, DataFile_Id, 5);

            foreach (DataRow e in encounters.Rows)
            {
                string RecordID = e["DataFile_id"].ToString() + "_" + e["DF_id"].ToString();
                string CompanyName = "";
                string FullName;
                string Middle = e["Middle"].ToString().Trim();
                if (string.IsNullOrWhiteSpace(Middle))
                { FullName = string.Concat(e["FName"], " ", e["LName"]); }
                else
                { FullName = string.Concat(e["FName"], " ", Middle, " ", e["LName"]); }
                string AddressLine1 = e["Addr"].ToString();
                string AddressLine2 = e["Addr2"].ToString();
                string Suite = "";
                string City = e["City"].ToString();
                string State = e["ST"].ToString();
                string PostalCode = e["Zip5"].ToString();
                string Country = "";
                string PhoneNumber = string.Concat(e["AreaCode"], e["Phone"]);
                string EmailAddress = "";
                string FreeForm = "";

                var o = new
                {
                    RecordID = RecordID,
                    CompanyName = CompanyName,
                    FullName = FullName,
                    AddressLine1 = AddressLine1,
                    AddressLine2 = AddressLine2,
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

        private static DataTable GetDataFileRecords(string environment, int datafile_id, int maxRecords)
        {
            string serverName = GetEnvironmentQPLoadServerName(environment);

            string connStr = string.Format("Server={0};Database=QP_Load;Trusted_Connection=True;", serverName);

            using(SqlConnection conn = new SqlConnection(connStr))
            {
                string limitExpression = maxRecords > 0 ? string.Format(" TOP {0} ", maxRecords) : "";
                string sql = string.Format("SELECT {0} * FROM DataFile_{1}", limitExpression, datafile_id);

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
    }
}
