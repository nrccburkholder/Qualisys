using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.Misc
{
    public class Methods
    {
        public Dictionary<string, string> _row { get; set; }
        public Dictionary<string, string> _macroValue { get; set;  }
        public List<string> ContractedLanguages { get; set; }

        public void SetData( Dictionary<string, string> row, Dictionary<string, string> macroValues )
        {
            this._row = row;
            this._macroValue = macroValues;
            this.ContractedLanguages = macroValues["ContractedLanguages"].Replace(" ", "").Split(new char[] { ',' }).ToList<string>();
        }

        #region Pervasive Methods
        public int serial(int seed)
        {
            // _rowid starts at 1, so serial will also start at one
            // may need to revert _rowid to start at zero, of this is the case then do a +1 here.
            return Convert.ToInt32(_row["_rowid"]) ; 
        }
        public bool IsNull(string value)
        {
            return string.IsNullOrEmpty(value);
        }
        public string Null()
        {
            return string.Empty;
        }
        public string StrReplace(char c, string newVal, string data)
        {
            return data.Replace(c.ToString(), newVal) ;
        }
        private static string DateValMask(string inputvalue, string format)
        {
            try
            {
                // if we get 1112011 we want it to be 01112011
                // this makes the assumption that a short date is caused by a missing leading zero
                if (inputvalue.Length.Equals(7))
                {
                    inputvalue = "0" + inputvalue;
                }

                format = format.Replace("mm", "MM");
                DateTime dt = DateTime.ParseExact(inputvalue, format, CultureInfo.InvariantCulture);

                if (!dt.Equals(DateTime.MinValue))
                {
                    return dt.ToString("MM/dd/yyyy");
                }

                // if we get a min date (01/01/0001) assuming this implies NULL date.
                return null;
            }
            catch
            {
                return null;
            }
        }
        #endregion

        #region c_AgeAtMonthEnd.rifl
        public static int AgeAtMonthEnd(string strDOB, string Month, string Year)
        {
            try
            {
                DateTime startDate = DateTime.Parse(strDOB);
                DateTime endDate = new DateTime(    Convert.ToInt32(Year), 
                                                    Convert.ToInt32(Month), 
                                                    GetEOM(Month, Year).Day ); 

                return Methods.YearsBetween(startDate.ToString(), endDate.ToString());
            }
            catch
            {
                return 999;
            }
        }

        /// <summary>
        /// Returns last day of month for the month indicated
        /// </summary>
        /// <param name="strMonth"></param>
        /// <param name="strYear"></param>
        /// <returns></returns>
        public static DateTime GetEOM(string strMonth, string strYear)
        {
            return new DateTime(Convert.ToInt32(strYear), Convert.ToInt32(strMonth), DateTime.DaysInMonth(Convert.ToInt32(strYear), Convert.ToInt32(strMonth)));
        }
        public static bool IsLeapyear(string iYear)
        {
            try
            {
                int year = Convert.ToInt32(iYear);
                if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) return true;
                return false;
            }
            catch
            {
                return false;
            }
        }
        #endregion

        #region c_DateFunctions.rifl
        public static int _AgeFromAdminDate(string dob, string admitDate)
        {
            return YearsBetween(dob, admitDate);
        }
        public static int _AgeFromDOB(string dob)
        {
            return YearsBetween(dob, DateTime.Now.ToString());
        }
        public static int _GetLengthOfStay(string admitDate, string dischargeDate)
        {
            try
            {
                DateTime dtAdmitDate = DateTime.Parse(admitDate);
                DateTime dtDischargeDate = DateTime.Parse(dischargeDate);
                return dtDischargeDate.Subtract(dtAdmitDate).Days;
            }
            catch
            {
                return 9999;
            }
        }
        public static string _DateFormat(string dateString, string formatString)
        {
            return DateValMask(dateString, formatString);
        }
        public static int _GetFourDigitYear(string clientMonth, string clientDay, string clientYear)
        {
            DateTime dt = new DateTime(
                Convert.ToInt32(clientYear), 
                Convert.ToInt32(clientMonth), 
                Convert.ToInt32(clientDay) );

            return dt.Year;
        }
        public static string _CheckLeadingZero(string datePart)
        {
            if( !string.IsNullOrEmpty(datePart) )
            {
                if( datePart.Length == 1 ) return string.Format("0{0}",datePart);
                if( datePart.Length == 2 ) return datePart;
            }
            return string.Empty;
        }
        public static string _GetMonthNumFromAbbr(string strMonthAbbr)
        {
            switch (strMonthAbbr.ToUpper())
            {
                case "JAN": return "01";
                case "FEB": return "02";
                case "MAR": return "03";
                case "APR": return "04";
                case "MAY": return "05";
                case "JUN": return "06";
                case "JUL": return "07";
                case "AUG": return "08";
                case "SEP": return "09";
                case "OCT": return "10";
                case "NOV": return "11";
                case "DEC": return "12";
                default: return string.Empty;
            }
        }
        #endregion

        #region Private functions
        private static int YearsBetween(string startDate, string endDate)
        {
            try
            {
                DateTime dtStartDate = DateTime.Parse(startDate);
                DateTime dtEndDate = DateTime.Parse(endDate);

                if (dtEndDate.Month < dtStartDate.Month ||
                    (dtEndDate.Month.Equals(dtStartDate.Month) && dtEndDate.Day < dtStartDate.Day))
                {
                    return dtEndDate.Year - dtStartDate.Year - 1;
                }
                return dtEndDate.Year - dtStartDate.Year;
            }
            catch
            {
                return 9999;
            }
        }
        #endregion
    }
}
