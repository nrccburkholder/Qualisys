using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Configuration;

namespace CEM.FileMaker
{
    public class DebugHelper
    {
        public static void RunInteractive(ServiceBase[] servicesToRun)
        {
            //Source: http://coding.abel.nu/2012/05/debugging-a-windows-service-project/
            Console.WriteLine("Services running in interactive mode.");
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine(string.Format("Environment: {0}", GetEnvironment()));
            Console.WriteLine();

            MethodInfo onStartMethod = typeof(ServiceBase).GetMethod("OnStart",
                BindingFlags.Instance | BindingFlags.NonPublic);

            foreach (ServiceBase service in servicesToRun)
            {
                Console.Write("Starting {0}...", service.ServiceName);
                onStartMethod.Invoke(service, new object[] { new string[] { } });
                Console.Write("Started");
            }

            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine(
                "Press any key to stop the services and end the process...");
            Console.ReadKey();
            Console.WriteLine();

            MethodInfo onStopMethod = typeof(ServiceBase).GetMethod("OnStop",
                BindingFlags.Instance | BindingFlags.NonPublic);
            foreach (ServiceBase service in servicesToRun)
            {
                Console.Write("Stopping {0}...", service.ServiceName);
                onStopMethod.Invoke(service, null);
                Console.WriteLine("Stopped");
            }

            Console.WriteLine("All services stopped.");
            // Keep the console alive for a second to allow the user to see the message.
            Thread.Sleep(1000);
        }

        static string GetEnvironment()
        {
            string connStr = ConfigurationManager.ConnectionStrings["CEMConnection"].ConnectionString.ToUpper();

            if (connStr.Contains("LNK0TCATSQL01")) return "TEST";
            else if (connStr.Contains("STGCATCLUSTDB2")) return "STAGE";
            else return "PROD";

        }
    }
}
