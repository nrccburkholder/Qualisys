using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceLogging;
using USPS_ACS_Library;

namespace ServiceTester_Console
{
    class Program
    {


        static void Main(string[] args)
        {
            Console.WriteLine("Press return to start");
            Console.ReadLine();

            Start();

            Console.WriteLine("Press return to exit");
            Console.ReadLine();
        }

        static void Start()
        {

            Logs.Info("USPS_ACS_Service Begin Work");
            USPS_ACS_Library.ServiceWorker.DoExtractWork();
            Logs.Info("USPS_ACS_Service End Work");

        }
    }
}
