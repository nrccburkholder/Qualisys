using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebSurveyLibrary.Extensions
{
    public static class StringExtensions
    {
        /// <summary>
        /// Replace function that allows for case insensitive string replacement
        /// </summary>
        /// <param name="originalString"></param>
        /// <param name="oldValue"></param>
        /// <param name="newValue"></param>
        /// <param name="comparisonType"></param>
        /// <returns></returns>
        public static string Replace(this string originalString, string oldValue, string newValue, StringComparison comparisonType)
        {
            int startIndex = 0;
            while (true)
            {
                startIndex = originalString.IndexOf(oldValue, startIndex, comparisonType);
                if (startIndex == -1)
                    break;

                originalString = originalString.Substring(0, startIndex) + newValue + originalString.Substring(startIndex + oldValue.Length);

                startIndex += newValue.Length;
            }

            return originalString;
        }

    }
}
