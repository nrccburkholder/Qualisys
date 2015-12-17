using System;
using System.Text;
using System.Security.Cryptography;

namespace Utilities
{
    class Encryption
    {
        public static string EncryptString(string Message, string Passphrase)
        {
            // Encrypt the Password
            CryptoAES.KeySize objKeySize = CryptoAES.KeySize.Bits256;
            CryptoAES cryptoAES = new CryptoAES(objKeySize, Passphrase);
            string encryption = cryptoAES.Encrypt(Message);
            return encryption;
        }

        public static string DecryptString(string Message, string Passphrase)
        {
            // Encrypt the Password
            CryptoAES.KeySize objKeySize = CryptoAES.KeySize.Bits256;
            CryptoAES cryptoAES = new CryptoAES(objKeySize, Passphrase);
            string decryption = cryptoAES.Decrypt(Message).Replace("\0", string.Empty);

            // Step 6. Return the decrypted string
            return decryption;
        }
    }
}
