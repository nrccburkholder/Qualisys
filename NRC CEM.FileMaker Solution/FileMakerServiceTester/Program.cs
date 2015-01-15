using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Configuration;
using NRC.Exporting;
using NRC.Exporting.Configuration;
using NRC.Logging;

namespace FileMakerServiceTester
{
    public class Program
    {

       private static EventLog eventLog;



        static void Main(string[] args)
        {

            eventLog = new EventLog();
            eventLog.Source = "CEM.FileMaker_Service";
            eventLog.Log = "Application";


            Console.WriteLine();
            Console.WriteLine(string.Format("Environment: {0}", GetEnvironment()));
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine("Press return to start");
            Console.ReadLine();

            Start();

        }

        static void Start()
        {      
            try
            {
                // Do the scheduled work here.
                
                Logs.Info(string.Format("FileMakerService Tester Begin Work"));
                string schedulerCron = SystemParams.Params.GetParam("ServiceInterval").StringValue;

                Exporter.MakeFiles();

                Logs.Info(string.Format("FileMakerService Tester End Work"));

                Console.WriteLine();
                Console.WriteLine();
                Console.WriteLine("Do you want to run it again? (Y or just hit return>");
                string answer = Console.ReadLine().ToLower();
                if (answer.IndexOf("y") == 0)
                {
                    Start();
                }
                Console.WriteLine();
                Console.WriteLine("Goodbye!");

            }
            catch (Exception ex)
            {
                Logs.Error("Error executing job.",ex);
            }
        }


        static string GetEnvironment()
        {
            string connStr = ConfigurationManager.ConnectionStrings["CEMConnection"].ConnectionString.ToUpper();

            if (connStr.Contains("LNK0TCATSQL01"))return "TEST";
            else if (connStr.Contains("STGCATCLUSTDB2")) return "STAGE";
            else return "PROD";

        }
    }
}
