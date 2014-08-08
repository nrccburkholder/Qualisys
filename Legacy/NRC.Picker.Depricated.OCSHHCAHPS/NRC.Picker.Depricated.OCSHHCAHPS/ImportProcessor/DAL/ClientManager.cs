using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.ImportProcessors.OCSHHCAHPS.DAL
{
    public static class ClientManager
    {
        //private static Dictionary<string, ClientDetails> mappingCache = null;

        public static string M0010FromFilename(string filename)
        {
            string m0010 = string.Empty;

            // M0010 from the filename:
            Regex r = new Regex(@"OCS(\d+)_");
            Match m = r.Match(filename);
            if (m.Success)
            {
                m0010 = m.Groups[1].Value.ToString();
            }

            return m0010;
        }

        //public static ClientDetails GetClientDetails(string m0010)
        //{
        //    if (mappingCache == null)
        //    {
        //        LoadMapping();
        //    }

        //    if (mappingCache.Keys.Contains(m0010))
        //    {
        //        return mappingCache[m0010];
        //    }

        //    return null;
        //}

        //private static void LoadMapping()
        //{
        //    mappingCache = new Dictionary<string, ClientDetails>();

        //    using (StreamReader sr = File.OpenText(@"ClientDetails.csv"))
        //    {
        //        sr.ReadLine();
        //        while (!sr.EndOfStream)
        //        {
        //            string line = sr.ReadLine();
        //            string [] fields = line.Split(new char[] { '\t' });
        //            ClientDetails v = new ClientDetails()
        //                {
        //                    ClientId = fields[1],
        //                    StudyId = fields[2],
        //                    SurveyId = fields[3],
        //                    BaseTransformFile = @"C:\temp\OCS.HHCAHPS\BaseTransforms.xml"
        //                };

        //            mappingCache[fields[0]] = v;
        //        }
        //    }
        //}

    }
}
