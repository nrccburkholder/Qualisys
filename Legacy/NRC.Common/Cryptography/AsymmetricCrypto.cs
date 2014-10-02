using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace NRC.Common.Cryptography
{
    /// <summary>
    /// This class is a convenient implementation of public key encryption. Because RSA is slow, it internally generates an AES
    /// key, encrypts the message with that, and prepends the RSA-encrypted AES key.
    /// http://digcode.com/Default.aspx?g=posts&m=694
    /// </summary>
    public class AsymmetricCrypto
    {
        private const int KEY_LENGTH = 256;
        private const int IV_LENGTH = 16;
        private const int KEY_BITS = 2048;

        public static byte[] Encrypt(string publicKey, byte[] data)
        {
            MemoryStream output = new MemoryStream();
            Encrypt(publicKey, new MemoryStream(data), output);
            return output.ToArray();
        }

        public static void Encrypt(string publicKey, Stream input, Stream output)
        {
            byte[] key = new byte[32];
            RandomNumberGenerator.Create().GetBytes(key);

            using (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(KEY_BITS))
            {
                rsa.FromXmlString(publicKey);
                byte[] encryptedKey = rsa.Encrypt(key, true);
                if (encryptedKey.Length != KEY_LENGTH)
                {
                    throw new CryptographicException("Encrypted key wrong length (is " + encryptedKey.Length + "), aborting");
                }
                output.Write(encryptedKey, 0, encryptedKey.Length);
            }

            using (Rijndael aes = RijndaelManaged.Create())
            {
                aes.GenerateIV();
                if (aes.IV.Length != IV_LENGTH)
                {
                    throw new CryptographicException("IV too long (is " + IV_LENGTH + "), aborting");
                }
                output.Write(aes.IV, 0, aes.IV.Length);

                aes.Mode = CipherMode.CBC;
                using (CryptoStream cstream = new CryptoStream(output, aes.CreateEncryptor(key, aes.IV), CryptoStreamMode.Write))
                {
                    CopyTo(input, cstream);
                    cstream.FlushFinalBlock();
                }
            }
        }

        public static byte[] Decrypt(string privateKey, byte[] data)
        {
            MemoryStream output = new MemoryStream();
            Decrypt(privateKey, new MemoryStream(data), output);
            return output.ToArray();
        }

        public static void Decrypt(string privateKey, Stream input, Stream output)
        {
            byte[] encryptedKey = new byte[KEY_LENGTH];
            byte[] iv = new byte[IV_LENGTH];

            if ((input.Read(encryptedKey, 0, encryptedKey.Length) != encryptedKey.Length) ||
                (input.Read(iv, 0, iv.Length) != iv.Length))
            {
                throw new CryptographicException("Data too short (is " + input.Length + ")");
            }

            using (RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(KEY_BITS))
            {
                rsa.FromXmlString(privateKey);
                byte[] key = rsa.Decrypt(encryptedKey, true);

                using (Rijndael aes = RijndaelManaged.Create())
                {
                    aes.Mode = CipherMode.CBC;
                    using (Stream cstream = new CryptoStream(input, aes.CreateDecryptor(key, iv), CryptoStreamMode.Read))
                    {
                        CopyTo(cstream, output);
                        output.Flush();
                    }
                }
            }
        }

        // this method is here because this project is intended for 3.5 compatibility; if we switch to 4.0 as base, this
        // can be replaced by Stream.CopyTo
        private const int BUFFER_SIZE = 32768;
        private static void CopyTo(Stream source, Stream dest)
        {
            byte[] buffer = new byte[BUFFER_SIZE];
            int read;
            while ((read = source.Read(buffer, 0, buffer.Length)) > 0)
            {
                dest.Write(buffer, 0, read);
                dest.Flush();
            }
        }
    }
}
