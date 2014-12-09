using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting;


namespace FileMakerServiceTester
{
    class Program
    {

        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

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
                logger.Info("FileMakerService Tester Begin Work");
                Exporter.MakeFiles();
                logger.Info("FileMakerService Tester End Work");
            }
            catch (Exception ex)
            {
                logger.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
            }
        }
    }
}
