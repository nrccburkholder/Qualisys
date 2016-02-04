using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace CommonTools
{
    /// <summary>
    /// Summary description for clsFileIO.
    /// </summary>
    public class clsFileIO
    {
        public clsFileIO()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static StreamReader getFileReader(string sFilepath)
        {
            FileInfo fi = new FileInfo(sFilepath);

            if (fi.Exists)
            {
                return fi.OpenText();
            }
            else
            {
                throw new FileNotFoundException("File Not Found", sFilepath);
            }
        }
    }
}
