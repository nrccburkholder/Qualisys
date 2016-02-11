// © 2004 Sonic Solutions. All rights reserved.
// written by Carl Kelley, ckelley@winmetics.com
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Collections.Specialized;
using System.Web;


//Sonic namespaces


namespace Tools
{
    /// <summary>
    /// Summary description for clsURL.
    /// </summary>
    public class clsURL
    {
        public const string urlParm_REDIRECT = "redir";
        protected string _sUrl = string.Empty;

        #region Properties

        public string URL
        {
            get { return _sUrl; }
        }

        public string Domain
        {
            get { return Domain_In_URL(_sUrl); }
        }

        public NameValueCollection Parameters
        {
            get { return ParameterCollection(_sUrl); }
        }
        #endregion Properties

        #region Constructors
        public clsURL(string sUrl)
        {
            if ((sUrl != null) && (sUrl.Trim().Length > 0))
            {
                _sUrl = sUrl;
            }
            else
            {
                throw new Exception("URL is null or empty in constructor.");
            }
        }
        #endregion Constructors

        #region Methods

        public override string ToString()
        {
            return _sUrl;
        }

        public string Append_Parameter(string sParamName
            , string sValue)
        {
            string sNewUrl;
            if ((sValue != null) && (sValue.Trim().Length > 0))
            {
                if (_sUrl.IndexOf("?") < 0)
                {
                    sNewUrl = string.Format("{0}?{1}={2}", _sUrl, sParamName, HttpUtility.UrlEncode(sValue));
                }
                else if (_sUrl.EndsWith("?"))
                {
                    sNewUrl = string.Format("{0}{1}={2}", _sUrl, sParamName, HttpUtility.UrlEncode(sValue));
                }
                else
                {
                    sNewUrl = string.Format("{0}&{1}={2}", _sUrl, sParamName, HttpUtility.UrlEncode(sValue));
                }
                _sUrl = sNewUrl;
            }
            return _sUrl;
        }

        public string Add_or_Replace_Parameter(string psParamName
                                              , string psValue)
        {
            NameValueCollection colParams = this.Parameters;
            if (colParams[psParamName] == null)
            {
                colParams.Add(psParamName, psValue);
            }
            else
            {
                colParams[psParamName] = psValue;
            }
            _sUrl = Replace_Parameters(_sUrl, colParams);
            return _sUrl;
        }

        public string Parameter_Value(string psParamName)
        {
            if ((psParamName == null) || (psParamName.Trim().Length == 0))
            {
                throw new Exception("Query string parameter name was null or empty.");
            }
            else
            {
                // split the Query string into arguments
                NameValueCollection colParams = this.Parameters;
                return colParams[psParamName];
            }
        }

        public static NameValueCollection ParameterCollection(string sUrl)
        {
            NameValueCollection colParam = new NameValueCollection();
            string[] arrUrlPart = sUrl.Split("?".ToCharArray(), 2);
            string sQuery = (arrUrlPart.GetUpperBound(0) > 0) ? arrUrlPart[1] : string.Empty;
            if (sQuery.Length > 0)
            {
                // split the Query string into arguments
                string[] arrParam = sQuery.ToLower().Split("&".ToCharArray());
                foreach (string sNameValuePair in arrParam)
                {
                    string[] arrNameValue = sNameValuePair.Split('=');
                    string sParamName = arrNameValue[0];
                    string sValue = HttpUtility.UrlDecode((arrNameValue.GetUpperBound(0) > 0) ? arrNameValue[1] : string.Empty);
                    colParam.Add(sParamName, sValue);
                }
            }
            return colParam;
        }

        public static string Replace_Parameters(string sUrl, NameValueCollection colParams)
        {
            string[] arrUrlPart = sUrl.Split("?".ToCharArray(), 2);
            string sLeftPart = arrUrlPart[0];
            return sLeftPart + "?" + QueryString(colParams);
        }

        public static string QueryString(NameValueCollection colParams)
        {
            string sQuery = string.Empty;
            if (colParams.HasKeys())
            {
                StringBuilder sb = new StringBuilder(256);
                foreach (string sKey in colParams.Keys)
                {
                    if (sb.Length > 0)
                    {
                        sb.Append("&");
                    }
                    sb.Append(sKey + "=" + HttpUtility.UrlEncode(colParams[sKey]));
                }
                sQuery = sb.ToString();
            }
            return sQuery;
        }

        public string Absolute(HttpRequest Request)
        {
            return Absolute_URL(_sUrl, Request);
        }

        public static string Absolute_URL(HttpRequest Request)
        {
            return Absolute_URL(Request.Url);
        }

        public static string Absolute_URL(Uri oUri)
        {
            return oUri.GetLeftPart(UriPartial.Path);
        }

        public static string Absolute_URL(string sRelativeURL, HttpRequest Request)
        {
            string sAbsoluteURL = "unassigned!";
            string sAppRoot = Request.ApplicationPath.ToLower();
            if (sAppRoot == "/") sAppRoot = "";

            if (sRelativeURL.ToLower().IndexOf(sAppRoot) >= 0)
            {
                sAbsoluteURL = sRelativeURL;
            }
            else if (sRelativeURL.StartsWith("/"))
            {
                sAbsoluteURL = sAppRoot + sRelativeURL;
            }
            else
            {
                sAbsoluteURL = sAppRoot + "/" + sRelativeURL;
            }
            return sAbsoluteURL;
        }

        public static string Absolute_Directory(HttpRequest Request)
        {
            return Absolute_Directory(Request.Url);
        }

        public static string Absolute_Directory(Uri oUri)
        {
            return oUri.ToString().Substring(0, oUri.ToString().LastIndexOf("/") + 1);
        }

        public static string Relative_Directory(Uri oUri)
        {
            if (oUri.LocalPath.LastIndexOf("/") > 0)
            {
                return oUri.LocalPath.Substring(0, oUri.LocalPath.LastIndexOf("/"));
            }
            else
            {
                return "/";
            }
        }

        public static string File_Name(string sUrl)
        {
            if ((sUrl == null) || (sUrl.Trim().Length == 0))
            {
                return string.Empty;
            }
            else
            {
                sUrl = sUrl.Trim();
                string sLeft = sUrl;
                int ixQuestionMark = sUrl.IndexOf("?");
                if (ixQuestionMark >= 0)
                {
                    sLeft = sUrl.Substring(0, ixQuestionMark);
                }
                int ixSlash = sLeft.LastIndexOf("/");
                if (ixSlash < 0)
                {
                    return sLeft;
                }
                else if (sLeft.EndsWith("/"))
                {
                    return string.Empty;
                }
                else
                {
                    return sLeft.Substring(ixSlash + 1);
                }
            }
        }

        public static string Application_URL(HttpRequest Request)
        {
            string sApplication_URL = null;
            string sPageUrl = Request.Url.ToString().ToLower();
            int iSlashSlash = sPageUrl.IndexOf("//");
            string sApplicationPath = Request.ApplicationPath.ToLower();
            int iAppPath = sPageUrl.IndexOf(sApplicationPath, (iSlashSlash + 2));
            if (sApplicationPath.Length == 1)
            {
                // to remove the trailing slash
                sApplication_URL = sPageUrl.Substring(0, iAppPath);
            }
            else
            {
                sApplication_URL = sPageUrl.Substring(0, iAppPath + sApplicationPath.Length);
            }
            return sApplication_URL;
        }

        public bool Is_In_This_Domain(HttpRequest Request)
        {
            return Is_In_This_Domain(_sUrl, Request);
        }

        public static bool Is_In_This_Domain(string sUrl, HttpRequest Request)
        {
            string sDomain = clsWebConfig.WebConfigAppSetting(clsWebConfig.configKey_APPLICATION_DOMAIN).ToLower();
            return (sUrl.ToLower().IndexOf(sDomain) >= 0) || (sUrl.ToLower().IndexOf(Request.ApplicationPath.ToLower()) >= 0);
        }

        public static string Domain_In_URL(string sUrl)
        {
            string sDomain = string.Empty;
            Uri oUri = new Uri(sUrl);
            string sHost = oUri.Host;
            string[] arrHostParts = sHost.Split('.');
            int ixLastPart = arrHostParts.GetUpperBound(0);
            if (ixLastPart > 1)
            {
                sDomain = arrHostParts[ixLastPart - 1] + "." + arrHostParts[ixLastPart];
            }
            else
            {
                sDomain = sHost;
            }
            return sDomain;
        }
        #endregion Methods
    }
}
