using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CommonTools
{
    /// <summary>
    /// Summary description for clsDate.
    /// </summary>
    public class clsDate
    {
        /// <summary>
        /// same common params as the VBScript DateDiff: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/script56/html/vsfctdatediff.asp
        /// Sample Code:
        /// * System.DateTime dt1 = new System.DateTime(1974,12,16);
        /// * System.DateTime dt2 = new System.DateTime(1973,12,16);
        /// * Page.Response.Write(Convert.ToString(DateDiff("t", dt1, dt2)));
        /// 
        /// </summary>
        /// <param name="howtocompare"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static double DateDiff(string howtocompare, System.DateTime startDate, System.DateTime endDate)
        {
            double diff = 0;
            try
            {
                System.TimeSpan TS = new System.TimeSpan(startDate.Ticks - endDate.Ticks);
                #region converstion options
                switch (howtocompare.ToLower())
                {
                    case "m":
                        diff = Convert.ToDouble(TS.TotalMinutes);
                        break;
                    case "s":
                        diff = Convert.ToDouble(TS.TotalSeconds);
                        break;
                    case "t":
                        diff = Convert.ToDouble(TS.Ticks);
                        break;
                    case "mm":
                        diff = Convert.ToDouble(TS.TotalMilliseconds);
                        break;
                    case "yyyy":
                        diff = Convert.ToDouble(TS.TotalDays / 365);
                        break;
                    case "q":
                        diff = Convert.ToDouble((TS.TotalDays / 365) / 4);
                        break;
                    default:
                        //d
                        diff = Convert.ToDouble(TS.TotalDays);
                        break;
                }
                #endregion
            }
            catch (Exception)
            {
                diff = -1;
            }
            return diff;
        }

    }
}
