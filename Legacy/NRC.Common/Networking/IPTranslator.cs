using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;

namespace NRC.Common.Networking
{
    // Some of our servers are set up to do IPV6 on loopback, which means that if you look up "localhost" or their machine name, you get
    // an IPV6 address, which is lame since all the other names they resolve get IPV4. This class is a helper for converting those 
    // to 127.0.0.1, plus doing any other translation/IP cleanup necessary in the future.
    public abstract class IPTranslator
    {
        private static Logger _logger = Logger.GetLogger();
        private static HashSet<string> _localIPs = new HashSet<string>();

        static IPTranslator()
        {
            _logger.Trace("Checking local IPs ...");
            IPHostEntry localEntry = Dns.GetHostEntry(Dns.GetHostName());
            foreach (var address in localEntry.AddressList)
            {
                _logger.Trace(String.Format("Found local IP {0}", address.ToString()));
                _localIPs.Add(address.ToString());
            }
            _localIPs.Add("::1"); // not listed, but is the IPV6 equivalent of 127.0.0.1
        }

        public static string Translate(string ip)
        {
            if (_localIPs.Contains(ip))
            {
                return "127.0.0.1";
            }
            return ip;
        }
    }
}
