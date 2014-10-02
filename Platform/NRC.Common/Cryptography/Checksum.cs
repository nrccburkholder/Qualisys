using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace NRC.Common.Cryptography
{
    public abstract class Checksum
    {
        // computes a 24-character base-64-encoded version of a 16-byte checksum of the input
        public static string Base64(string file)
        {
            using (MD5 md5 = new MD5CryptoServiceProvider())
            {
                using (FileStream fin = File.OpenRead(file))
                {
                    byte[] hashbytes = md5.ComputeHash(fin);
                    return Convert.ToBase64String(hashbytes);
                }
            }
        }

        // computes a 24-character base-64-encoded version of a 16-byte checksum of the input
        public static string Base64(byte[] bytes)
        {
            using (MD5 md5 = new MD5CryptoServiceProvider())
            {
                byte[] hashbytes = md5.ComputeHash(bytes);
                return Convert.ToBase64String(hashbytes);
            }
        }
    }
}
