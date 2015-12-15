using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Utilities
{
    public class Formatting
    {
        /// <summary>
        /// Format this TimeSpan
        /// </summary>
        public static string FormatTimeSpan(TimeSpan span)
        {
            string days = null;
            string hours = null;
            string minutes = null;
            string seconds = null;
            if (span.Days == 1)
                days = "1 day";
            else if (span.Days > 1)
                days = span.Days + " days";
            if (span.Hours == 1)
                hours = "1 hour";
            else if (span.Hours > 1)
                hours = span.Hours + " hours";
            if (span.Minutes == 1)
                minutes = "1 minute";
            else if (span.Minutes > 1)
                minutes = span.Minutes + " minutes";
            if (span.Minutes == 0)
            {
                if (span.Seconds == 1 && span.Milliseconds == 0)
                    seconds = "1 second";
                else
                    seconds = string.Format("{0}.{1:000} seconds", span.Seconds, span.Milliseconds);
            }
            else
            {
                if (span.Seconds == 1)
                    seconds = "1 second";
                else if (span.Seconds > 1)
                    seconds = span.Seconds + " seconds";
            }
            return string.Format("{0} {1} {2} {3}", days, hours, minutes, seconds).Trim();
        }

        /// <summary>
        /// Returns the count of an object and will convert to plural if necessary
        /// </summary>
        /// <param name="count">Count</param>
        /// <param name="name">The item to add an 's' to if count != 1</param>
        /// <param name="pluralName">If just adding an 's' is not valid then you can specify the name in it's plural format here.</param>
        public static string Pluralize(int count, string name = "row", string pluralName = null)
        {
            if (string.IsNullOrWhiteSpace(pluralName))
                return string.Format("{0:N0} {1}{2}", count, name, (count == 1) ? string.Empty : "s");
            else if (count == 1)
                return string.Format("{0:N0} {1}", count, name);
            else
                return string.Format("{0:N0} {1}", count, pluralName);
        }

        /// <summary>
        /// Replace multiple values in a string with a new value.  This is case insensitive.
        /// </summary>
        public static string Replace(string text, string replaceWith, params string[] replace)
        {
            foreach (string pattern in replace)
            {
                text = ReplaceEx(text, pattern, replaceWith);
            }
            return text;
        }

        /// <summary>
        /// Fast case insensitive string replace
        /// <remarks>http://www.codeproject.com/Articles/10890/Fastest-C-Case-Insenstive-String-Replace</remarks>
        /// </summary>
        private static string ReplaceEx(string original, string pattern, string replacement)
        {
            int count, position0, position1;
            count = position0 = position1 = 0;
            string upperString = original.ToUpper();
            string upperPattern = pattern.ToUpper();
            int inc = (original.Length / pattern.Length) *
                      (replacement.Length - pattern.Length);
            char[] chars = new char[original.Length + Math.Max(0, inc)];
            while ((position1 = upperString.IndexOf(upperPattern,
                                              position0)) != -1)
            {
                for (int i = position0; i < position1; ++i)
                    chars[count++] = original[i];
                for (int i = 0; i < replacement.Length; ++i)
                    chars[count++] = replacement[i];
                position0 = position1 + pattern.Length;
            }
            if (position0 == 0) return original;
            for (int i = position0; i < original.Length; ++i)
                chars[count++] = original[i];
            return new string(chars, 0, count);
        }
    }
}
