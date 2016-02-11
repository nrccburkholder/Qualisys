using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Specialized;

namespace Tools
{
    /// <summary>
    /// Summary description for clsQueryStringBuilder.
    /// </summary>
    public class clsQueryStringBuilder
    {

        private StringDictionary _QueryStringVars = new StringDictionary();

        public clsQueryStringBuilder()
        {
            // constructor
        }

        public clsQueryStringBuilder(string sURL)
        {
            string qs = GetQueryString(sURL);
            this.QueryString = qs;
        }

        public string QueryString
        {
            get { return BuildQueryString(); }
            set { ParseQueryString(value); }
        }

        private string GetQueryString(string sURL)
        {
            string result = "";
            int i = sURL.IndexOf("?");
            if (i > -1) result = sURL.Substring(i + 1);
            return result;
        }

        private void ParseQueryString(string sQueryString)
        {
            Regex rx = new Regex("([^=]+)=([^&]+)&{0,1}");
            MatchCollection qsVars = rx.Matches(sQueryString);
            foreach (Match qs in qsVars)
            {
                _QueryStringVars.Add(qs.Groups[1].Value, qs.Groups[2].Value);
            }
        }

        private string BuildQueryString()
        {
            StringBuilder qs = new StringBuilder();
            foreach (string key in _QueryStringVars.Keys)
            {
                if (qs.Length == 0)
                    qs.AppendFormat("{0}={1}", key, _QueryStringVars[key].ToString());
                else
                    qs.AppendFormat("&{0}={1}", key, _QueryStringVars[key].ToString());
            }
            return qs.ToString();
        }

        public void SetVariable(string key, string varValue)
        {
            if (_QueryStringVars.ContainsKey(key))
                _QueryStringVars[key] = varValue;
            else
                _QueryStringVars.Add(key, varValue);
        }

        public StringDictionary Variables
        {
            get { return _QueryStringVars; }
        }

        public void RemoveVariable(string key)
        {
            _QueryStringVars.Remove(key);
        }

        public bool HasVariable(string key)
        {
            return _QueryStringVars.ContainsKey(key);
        }
    }
}
