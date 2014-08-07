using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CultureInfo = System.Globalization.CultureInfo;

namespace NRC.Common.Web
{
    public abstract class Encoder
    {
        // Local version of HtmlEncode to avoid having to use System.Web as part of this project
        // Taken from http://www.west-wind.com/Weblog/posts/617930.aspx
        public static string HtmlEncode(string text)
        {
            if (text == null)
            {
                return null;
            }

            StringBuilder sb = new StringBuilder(text.Length);

            int len = text.Length;
            for (int i = 0; i < len; i++)
            {
                switch (text[i])
                {
                    case '<':
                        sb.Append("&lt;");
                        break;
                    case '>':
                        sb.Append("&gt;");
                        break;
                    case '"':
                        sb.Append("&quot;");
                        break;
                    case '&':
                        sb.Append("&amp;");
                        break;
                    default:
                        if (text[i] > 159)
                        {
                            // decimal numeric entity
                            sb.Append("&#");
                            sb.Append(((int)text[i]).ToString(CultureInfo.InvariantCulture));
                            sb.Append(";");
                        }
                        else
                            sb.Append(text[i]);
                        break;
                }
            }
            return sb.ToString();
        }
    }
}
