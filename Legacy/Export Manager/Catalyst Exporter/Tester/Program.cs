using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Nrc.CatalystExporter.Logging;
using Nrc.CatalystExporter.FileCreationEngine;

namespace Tester
{
    class Program
    {
        static void Main(string[] args)
        {
            new FileCreationHelper().CreateFileForExportLog(29, new UserContext("test"));
            
            Console.ReadLine();
        }
    }
}
