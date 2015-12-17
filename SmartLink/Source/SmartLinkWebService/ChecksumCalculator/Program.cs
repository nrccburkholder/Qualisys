using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace NRC.SmartLink.WebService.ChecksumCalculator
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Syntax: " + Process.GetCurrentProcess().ProcessName + " <file.msi>");
                Environment.Exit(1);
            }

            string checksum = SmartLinkWS.CheckFileHash(args[0]);
            Console.WriteLine("Checksum for " + args[0] + " (auto-added to clipboard): ");
            Console.WriteLine(checksum);
            Clipboard.SetText(checksum);
        }
    }
}
