using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;
namespace Tools
{
    /// <summary>
    /// Summary description for clsTextTools.
    /// </summary>
    public class clsTextTools
    {
        public clsTextTools()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static string StripHtmlTags(string sHtmlValue)
        {
            Regex rx = new Regex("<[^>]*>");
            return rx.Replace(sHtmlValue, "");
        }

        public static bool IsNumeric(string sValue)
        {
            try
            {
                Convert.ToDecimal(sValue);
            }
            catch
            {
                return false;
            }

            return true;
        }

        public static void SetDDLSelection(DropDownList ddl, string sSelectedValue)
        {
            ListItem li = ddl.Items.FindByValue(sSelectedValue);
            if (li != null)
                ddl.SelectedIndex = ddl.Items.IndexOf(li);

        }

        public static string Join(int[] iArray, char cDelimiter)
        {
            System.Text.StringBuilder result = new StringBuilder();
            for (int i = 0; i < iArray.Length; i++)
            {
                if (i < iArray.Length - 1)
                    result.AppendFormat("{0},", iArray[i]);
                else
                    result.Append(iArray[i]);
            }
            return result.ToString();
        }

        public static string EclipseText(string sValue, int maxLength)
        {
            if (sValue.Length > maxLength)
            {
                return String.Format("{0}...", sValue.Substring(0, maxLength - 3));
            }
            else
                return sValue;
        }
    }
}
