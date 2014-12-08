using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceLogging;
using NRC.Exporting;
using CEM.FileMaker;

namespace FileMakerServiceTester
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
            try
            {
                // Do the scheduled work here.
                Logs.Info("FileMakerService Tester Begin Work");
                //NRC.Exporting.FileMakerServiceWorker.Run();
                ServiceWorker.MakeFiles();
                Logs.Info("FileMakerService Tester End Work");
            }
            catch (Exception ex)
            {
                Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
            }
        }
    }
}
