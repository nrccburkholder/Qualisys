using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceLogging;
using NRC.Exporting;

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
            NRC.Exporting.FileMakerServiceWorker.Run();
        }
    }
}
