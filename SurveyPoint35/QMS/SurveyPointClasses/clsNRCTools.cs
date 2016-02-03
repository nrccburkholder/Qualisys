using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace SurveyPointClasses
{
    /// <summary>
    /// Summary description for clsNCRTools.
    /// </summary>
    public class clsNCRTools
    {
        public static int getTemplateIDFromLine(string strLine)
        {
            int iTemplateID = -1;
            Regex rx = new Regex("^.{18}([\\d\\s]{5})");
            if (rx.IsMatch(strLine))
            {
                Match m = rx.Match(strLine);
                iTemplateID = Convert.ToInt32(m.Groups[1].Value);
            }

            return iTemplateID;
        }

        public static int extractTemplateIDFromFile(string sImportFile)
        {
            int iTemplateID = -1;
            FileInfo fi = new FileInfo(sImportFile);
            if (fi.Exists)
            {
                StreamReader sr = null;
                try
                {
                    sr = fi.OpenText();
                    string strLine = sr.ReadLine();
                    iTemplateID = getTemplateIDFromLine(strLine);
                }
                finally
                {
                    if (sr != null) sr.Close();
                }
            }
            return iTemplateID;
        }

        public static void setTemplateInfoForSurveyInstance(int iSurveyInstanceID, string sProjectID, string sFAQSSTemplateID, string sTemplateID)
        {
            SurveyPointDAL.clsNRC.setTemplateInfoForSurveyInstance(iSurveyInstanceID, sProjectID, sFAQSSTemplateID, sTemplateID);
        }
    }
}
