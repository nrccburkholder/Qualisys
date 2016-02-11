// © 2004 Sonic Solutions. All rights reserved.
// written by Carl Kelley, ckelley@winmetics.com

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace Tools
{
    /// <summary>
    /// Summary description for clsWebConfig.
    /// </summary>
    public class clsWebConfig
    {
        public const string configKey_APPLICATION_SHORT_NAME = "ApplicationShortName";
        public const string configKey_APPLICATION_DOMAIN = "ApplicationDomain";
        //	use clsURL.Application_URL(Request) instead
        //public const string configKey_APPLICATION_URL = "ApplicationURL";
        public const string configKey_SUPPORT_EMAIL = "SupportEmail";
        public const string configKey_APPLICATION_FROM_EMAIL = "ApplicationFromEmail";
        public const string configKey_SMTP_Server_Name = "SMTPServerName";

        public static string WebConfigAppSetting(string sKey)
        {
            if ((sKey == null) || (sKey.Trim().Length == 0))
            {
                throw new Exception("AppSetting key was null or empty.");
            }
            else
            {
                string sValue = ConfigurationSettings.AppSettings[sKey];
                if (sValue == null)
                {
                    throw new Exception(String.Format("AppSetting key '{0}' was not found in the Web.config file.", sKey));
                }
                else
                {
                    return sValue;
                }
            }
        }

        public static string Primary_Support_Email()
        {
            return WebConfigAppSetting(configKey_SUPPORT_EMAIL).Trim().Split(",; ".ToCharArray(), 1)[0];
        }
    }
}

