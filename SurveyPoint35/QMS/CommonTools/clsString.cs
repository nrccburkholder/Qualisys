// © 2004 Sonic Solutions. All rights reserved.
// written by Carl Kelley, ckelley@winmetics.com
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Tools
{
    /// <summary>
    /// Summary description for clsString.
    /// </summary>
    public sealed class clsString
    {
        //prevent instancing by making constructor private
        private clsString()
        {
        }
        public static string Left(string strIn, int iLeftLength)
        {
            if (strIn == null)
            {
                return string.Empty;
            }
            else if (iLeftLength > strIn.Length)
            {
                return strIn;
            }
            else
            {
                return strIn.Substring(0, iLeftLength);
            }
        }
        public static string Right(string strIn, int iRightLength)
        {
            if (strIn == null)
            {
                return string.Empty;
            }
            else if (iRightLength > strIn.Length)
            {
                return strIn;
            }
            else
            {
                return strIn.Substring(strIn.Length - iRightLength, iRightLength);
            }
        }
        public static string Mid(string strIn, int iStart, int iMidLength)
        {
            if ((strIn == null)
                || (iStart > strIn.Length))
            {
                return string.Empty;
            }
            else if ((iStart + iMidLength) > strIn.Length)
            {
                return strIn.Substring(iStart, strIn.Length - iStart);
            }
            else
            {
                return strIn.Substring(iStart, iMidLength);
            }
        }


        public static string Empty_If_NULL(object objValue)
        {
            string strEmpty_If_NULL = "";
            if ((objValue == System.DBNull.Value) || objValue == null)
            {
                strEmpty_If_NULL = string.Empty;
            }
            else
            {
                strEmpty_If_NULL = objValue.ToString();
            }
            return strEmpty_If_NULL;
        }

        public static bool IsNullOrEmpty(string sValue)
        {
            if ((sValue == null) || (sValue.Trim().Length == 0))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static string Title_Case(string sIn)
        {
            sIn = sIn.Trim();
            if (IsNullOrEmpty(sIn))
            {
                return string.Empty;
            }
            else
            {
                string sDelim = "";
                const string sUnderScore = "_";
                if (sIn.IndexOf(sUnderScore) >= 0)
                {
                    sDelim = sUnderScore;
                }
                else
                {
                    sDelim = " ";
                }
                if (sIn.LastIndexOf(sDelim) < 0)
                {
                    // sIn starts with an underscore
                    return sIn.Substring(0, 1).ToUpper() + sIn.Substring(1, sIn.Length - 1).ToLower();
                }
                else
                {
                    string[] arrWord = sIn.Split(sDelim.ToCharArray());
                    StringBuilder sbTitle = new StringBuilder();
                    int iWordCount = arrWord.GetUpperBound(0);
                    for (int i = 0; i <= iWordCount; i++)
                    {
                        string sWord = arrWord[i].Trim();
                        if (sWord.Length == 1)
                        {
                            Append(sbTitle, sDelim, sWord.ToUpper());
                        }
                        else
                        {
                            Append(sbTitle, sDelim, sWord.Substring(0, 1).ToUpper()
                                + sWord.Substring(1, sWord.Length - 1).ToLower());
                        }
                    }
                    return sbTitle.ToString();
                }
            }
        }
        public static void Append(StringBuilder sbIn, string sDelim, string sSuffix)
        {
            if (sbIn.Length == 0)
            {
                sbIn.Append(sSuffix);
            }
            else
            {
                sbIn.Append(sDelim + sSuffix);
            }
        }
    }
}

