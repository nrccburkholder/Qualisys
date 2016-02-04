using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Globalization;

namespace NetClasses.Tools
{
    /// <summary>
    /// Summary description for clsLanguageDef.
    /// </summary>
    public class clsLanguageDef
    {
        protected HttpContext theContext;
        protected string m_language = "ENU";

        protected clsLanguageDef()
        {
            theContext = null;
            throw new Exception("invalid constructor called");
        }
        public clsLanguageDef(HttpContext context)
        {
            //
            // TODO: Add constructor logic here
            theContext = context;
            if (theContext.Request.QueryString["LANG"] == null)
            {
                HttpCookie cookieColl = theContext.Request.Cookies["snc"];
                if (cookieColl != null && cookieColl.Values["countryid"] != null)
                {
                    m_language = cookieColl.Values["countryid"];
                }
                else
                {
                    m_language = identify_browser();
                }
            }
            else
            {
                m_language = theContext.Request.QueryString["LANG"];
                m_language.ToUpper();

                if (m_language == "JP" || m_language == "JPN")
                    m_language = "JA";
            }
            //
        }
        private string identify_browser()
        {

            int nPos = -1;
            string szLanguage = theContext.Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"];
            if ((nPos = szLanguage.IndexOf(",")) != -1)
            {
                szLanguage = szLanguage.Substring(0, nPos);
            }
            return szLanguage;
        }

        private string get_language(string szLanguage)
        {
            if (szLanguage.Length != 3)	 // three letter code that can be passed from the apps should be passed directly to the redirect server
            {
                CultureInfo myCulture = new CultureInfo(szLanguage, false);
                szLanguage = myCulture.ThreeLetterWindowsLanguageName;
            }
            return szLanguage;

        }
        public string language
        {
            get
            {
                string szLanguage = "";
                try
                {
                    // look at the query->cookie->browser settings
                    szLanguage = get_language(m_language);
                }
                catch (Exception e)
                {
                    szLanguage = e.Message;
                    try
                    {

                        m_language = identify_browser();
                        szLanguage = get_language(m_language);
                    }
                    catch (Exception inner)
                    {
                        szLanguage = inner.Message;
                        szLanguage = "ENU";
                    }
                }
                return szLanguage.ToLower();
            }
        }
        public string currency
        {
            get
            {
                string szCurrency = "USD";
                try
                {
                    // look at the query->cookie->browser settings
                    if (m_language.Length != 3)	 // three letter code that can be passed from the apps should be passed directly to the redirect server
                    {
                        CultureInfo myCulture = new CultureInfo(m_language, false);
                        szCurrency = myCulture.NumberFormat.CurrencySymbol;
                    }
                }
                catch (Exception e)
                {
                    szCurrency = e.Message;
                    szCurrency = "USD";
                }
                return szCurrency.ToLower();
            }

        }
        public string countryName
        {
            get
            {
                string defaultCountryName = "US";
                try
                {
                    // look at the query->cookie->browser settings
                    if (m_language.Length != 3)	 // three letter code that can be passed from the apps should be passed directly to the redirect server
                    {
                        CultureInfo myInfo = new CultureInfo(m_language, false);
                        if (myInfo.IsNeutralCulture)
                        {
                            string countryCode = myInfo.TwoLetterISOLanguageName + "-" + myInfo.TwoLetterISOLanguageName;
                            CultureInfo tempInfo = new CultureInfo(countryCode, false);
                            RegionInfo myRegion = new RegionInfo(tempInfo.LCID);
                            defaultCountryName = myRegion.Name;
                        }
                        else
                        {
                            RegionInfo myRegion = new RegionInfo(myInfo.LCID);
                            defaultCountryName = myRegion.Name;
                        }
                    }
                }
                catch (Exception e)
                {
                    defaultCountryName = e.Message;
                    defaultCountryName = "US"; ;
                }
                return defaultCountryName.ToUpper();

            }
        }

    }
}
