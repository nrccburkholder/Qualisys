﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace FileCreationService
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            if (args != null && args.Length > 0)
            {
                new FileCreationService().DebugRun();
            }
            else
            {
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
			    { 
				    new FileCreationService() 
			    };
                ServiceBase.Run(ServicesToRun);
            }
        }
    }
}
