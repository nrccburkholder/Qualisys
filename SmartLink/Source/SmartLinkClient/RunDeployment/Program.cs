using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using NRC.SmartLink.Common;

namespace NRC.SmartLink.Common.RunDeployment
{
    // We need this class here because we need this project here, and we need this project here so I can set it up to be last in the build order
    // and use a post-build event on it to build the MSI, because TeamCity uses msbuild to build and hence can't build a visual studio deployment project.
    // But since the project is here we might as well use it to generate checksums for the resulting msi.
    class Program
    {
        public static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Syntax: " + Process.GetCurrentProcess().ProcessName + " <msi directory>");
                Environment.Exit(1);
            }

            string dir = args[0].Replace("\"", ""); // strip "s, which are put in due to batch file hijinx
            foreach (string file in Directory.GetFiles(dir))
            {
                if (file.EndsWith(".msi"))
                {
                    string checksum = Utils.CheckFileHash(file);

                    FileInfo f = new FileInfo(file + ".checksum.txt");
                    StreamWriter fout = new StreamWriter(f.OpenWrite());
                    fout.WriteLine(checksum);
                    fout.Close();
                }
            }
        }
    }
}
