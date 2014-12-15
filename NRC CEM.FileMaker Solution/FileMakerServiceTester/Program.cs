﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting;
using NRC.Exporting.Configuration;

namespace FileMakerServiceTester
{
    public class Program
    {

       private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        static void Main(string[] args)
        {
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
                logger.Info(string.Format("FileMakerService Tester Begin Work"));
                string schedulerCron = SystemParams.Params.GetParam("ServiceInterval").StringValue;

                Exporter.MakeFiles();

                logger.Info(string.Format("FileMakerService Tester End Work"));

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
                logger.Error("Error executing job.",ex);
            }
        }
    }
}
