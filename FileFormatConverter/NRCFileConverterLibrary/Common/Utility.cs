using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRCFileConverterLibrary.common
{
    static public class Utility
    {
        /// <summary>
        /// This utility method is used to generate a time based unique string to be appended to the filename to make the file name unique. 
        /// This is used when a file name conflict exists in the destination folder.
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static string MakeFileNameUnique(string name)
        {
            var dateTime = "_" + DateTime.Now.ToString("MMddyyyy") + "_" + DateTime.Now.ToString("HHmmss");
            name = name.Insert(name.IndexOf("."), dateTime.Replace(@"/", "").Replace(@":", "").Replace(@" ", "") );
            //Let us sleep for 100ms to make sure that next time we get a unique Date-TimeStamp
            System.Threading.Thread.Sleep(100);
            return name;
        }
    }
}
