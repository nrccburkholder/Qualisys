using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace HHCAHPSImporter.ImportProcessor
{
    public static class MyExtensions
    {
        public static void LogLine(this TextWriter tw, string message)
        {
            tw.WriteLine(string.Format("{0}\tINFO\t{1}", DateTime.Now.ToString("yyyyMMdd hh:mm:ss"), message));        
        }

        public static void LogError(this TextWriter tw, string message)
        {
            tw.WriteLine(string.Format("{0}\tERROR\t{1}", DateTime.Now.ToString("yyyyMMdd hh:mm:ss"), message));
        }


        public static void LogError(this TextWriter tw, string message, Exception ex)
        {
            if (!message.Equals(ex.Message))
            {
                tw.LogError(message);
            }
            LogError(tw, ex);
        }

        public static void LogError(this TextWriter tw, Exception ex)
        {
            tw.LogError(ex.Message);

            tw.LogError(ex.StackTrace);
            if (ex.InnerException != null)
            {
                tw.LogError(ex.InnerException);
            }
        }
    }   
}
