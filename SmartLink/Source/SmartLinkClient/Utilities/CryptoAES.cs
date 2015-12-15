using System;
using System.Security.Cryptography;
using System.Text;

namespace Utilities
{

    public class CryptoAES : IDisposable
    {
        #region "New"
        public enum UserStatus
        {
            Valid,
            InvalidUserName,
            InvalidPassword
        }
        public enum KeySize
        {
            Bits128,
            Bits192,
            Bits256
        }
        // block size in 32-bit words.  Always 4 for AES.  (128 bits).
        private int Nb;
        // key size in 32-bit words.  4, 6, 8.  (128, 192, 256 bits).
        private int Nk;
        // number of rounds. 10, 12, 14.
        private int Nr;
        // the seed key. size will be 4 * keySize from ctor.
        private byte[] key;
        // Substitution box
        private byte[,] Sbox;
        // inverse Substitution box 
        private byte[,] iSbox;
        // key schedule array. 
        private byte[,] w;
        // Round constants.
        private byte[,] Rcon;
        // State matrix
        private byte[,] State;
        private int BlockSize = 16;
        public CryptoAES(KeySize keySize, string Password)
        {
            // convert the password to a byte array, then call the other init func
            byte[] keyBytes = System.Text.ASCIIEncoding.ASCII.GetBytes(Password);
            Init(keySize, keyBytes);
        }
        //New
        public CryptoAES(KeySize keySize, byte[] keyBytes)
        {
            Init(keySize, keyBytes);
        }
        //New
        private void Init(KeySize keySize, byte[] keyBytes)
        {
            int num1 = 0;
            int num2 = 0;
            int num3 = 0;
            byte num4 = 1;
            try
            {
                this.SetNbNkNr(keySize);
                this.key = new byte[(this.Nk * 4)];
                if ((this.key.Length == keyBytes.Length))
                {
                    keyBytes.CopyTo(this.key, 0);
                }
                else
                {
                    num2 = this.key.Length;
                    num3 = keyBytes.Length;
                    //num1()
                    for (num1 = 0; num1 <= num2 - 1; num1++)
                    {
                        if ((num1 < num3))
                        {
                            this.key[num1] = keyBytes[num1];
                        }
                        else
                        {
                            num4 = Convert.ToByte((num4 + 1));
                            this.key[num1] = num4;
                        }
                    }
                }
                this.BuildSbox();
                this.BuildInvSbox();
                this.BuildRcon();
                this.KeyExpansion();
            }
            catch
            {
                throw;
            }
        }
        //Init
        private void ClassCleanUp()
        {
            try
            {
            }
            catch
            {
            }
        }
        public void Dispose()
        {
            try
            {
                System.GC.SuppressFinalize(this);
                ClassCleanUp();
            }
            catch
            {
            }
        }

        #endregion
        #region "Encrypt"
        public string Encrypt(string input)
        {
            byte[] bInput = null;
            byte[] bText = null;
            try
            {
                // convert the string to a byte
                bInput = System.Text.ASCIIEncoding.ASCII.GetBytes(input);
                // encrypt
                bText = Encrypt(bInput);
                // convert the byte array to a string
                return Convert.ToBase64String(bText);
            }
            catch
            {
                throw;
            }
            // return the text
        }

        //Encrypt
        public byte[] Encrypt(byte[] input)
        {
            int i = 0;
            int iLen = input.Length;
            byte[] output = new byte[1];
            byte[] newInput = null;
            byte[] inBuffer = new byte[BlockSize];
            byte[] buffer = new byte[BlockSize];
            int count = 0;
            try
            {
                // we need to resize the arrays so they are 16 byte blocks
                count = GetArraySize(input.Length);
                output = new byte[count];
                newInput = new byte[count];
                // copy the data from input to newInput
                System.Array.Copy(input, 0, newInput, 0, input.Length);
                // we need to send the cipher function 16 bytes at a time to encrypt
                for (i = 0; i <= count - BlockSize; i += BlockSize)
                {
                    // copy the input into the input buffer array
                    System.Array.Copy(newInput, i, inBuffer, 0, BlockSize);
                    // copy all 16 bytes
                    // encrypt this block
                    System.Array.Copy(Cipher(inBuffer), 0, output, i, BlockSize);
                }
            }
            catch
            {
                throw;
            }
            return output;
        }
        //Encrypt
        private int GetArraySize(int ArrayLen)
        {
            // if this is divisible by blocksize, return arraylen
            if (ArrayLen % BlockSize == 0)
            {
                return ArrayLen;
            }
            // return the new array size
            return (ArrayLen / BlockSize + 1) * BlockSize;
        }

        //GetArraySize
        public string Decrypt(string input)
        {
            byte[] bInput = null;
            //Dim tByte As String()
            try
            {
                bInput = Convert.FromBase64String(input);
                return System.Text.ASCIIEncoding.ASCII.GetString(Decrypt(bInput));
            }
            catch
            {
                throw;
            }
            // return
        }

        //Decrypt
        public byte[] Decrypt(byte[] input)
        {
            int i = 0;
            int iLen = input.Length;
            byte[] inBuffer = new byte[BlockSize];
            byte[] buffer = new byte[BlockSize];
            byte[] output = new byte[input.Length];
            try
            {
                // we need to send the cipher function 16 bytes at a time to encrypt
                for (i = 0; i <= iLen - BlockSize; i += BlockSize)
                {
                    // copy the input into the input buffer array
                    System.Array.Copy(input, i, inBuffer, 0, BlockSize);
                    // copy all 16 bytes
                    // decrypt this block
                    System.Array.Copy(InvCipher(inBuffer), 0, output, i, BlockSize);
                }
            }
            catch
            {
                throw;
            }
            // return the byte array
            return output;
        }

        //Decrypt
        #endregion
        private byte[] Cipher(byte[] input)
        {
            // encipher 16-bit input
            byte[] buffer1 = new byte[16];
            try
            {
                this.State = new byte[4, this.Nb];
                int num1 = 0;
                for (num1 = 0; num1 <= (4 * this.Nb) - 1; num1++)
                {
                    this.State[(num1 % 4), (num1 / 4)] = input[num1];
                }
                this.AddRoundKey(0);
                int num2 = 1;
                while ((num2 <= (this.Nr - 1)))
                {
                    this.SubBytes();
                    this.ShiftRows();
                    this.MixColumns();
                    this.AddRoundKey(num2);
                    num2 += 1;
                }
                this.SubBytes();
                this.ShiftRows();
                this.AddRoundKey(this.Nr);
                int num3 = 0;
                for (num3 = 0; num3 <= (4 * this.Nb) - 1; num3++)
                {
                    buffer1[num3] = this.State[(num3 % 4), (num3 / 4)];
                }
            }
            catch
            {
                throw;
            }
            return buffer1;
        }

        //Cipher
        private byte[] InvCipher(byte[] input)
        {
            // decipher 16-bit input
            byte[] buffer1 = new byte[16];
            try
            {
                this.State = new byte[4, this.Nb];
                int num1 = 0;
                for (num1 = 0; num1 <= (4 * this.Nb) - 1; num1++)
                {
                    this.State[(num1 % 4), (num1 / 4)] = input[num1];
                }
                this.AddRoundKey(this.Nr);
                int num2 = (this.Nr - 1);
                while ((num2 >= 1))
                {
                    this.InvShiftRows();
                    this.InvSubBytes();
                    this.AddRoundKey(num2);
                    this.InvMixColumns();
                    num2 -= 1;
                }
                this.InvShiftRows();
                this.InvSubBytes();
                this.AddRoundKey(0);
                int num3 = 0;
                for (num3 = 0; num3 <= (4 * this.Nb) - 1; num3++)
                {
                    buffer1[num3] = this.State[(num3 % 4), (num3 / 4)];
                }
            }
            catch
            {
                throw;
            }
            return buffer1;
        }
        //InvCipher
        //
        private void SetNbNkNr(KeySize keySize)
        {
            this.Nb = 4;
            // block size always = 4 words = 16 bytes = 128 bits for AES
            if (keySize == KeySize.Bits128)
            {
                this.Nk = 4;
                // key size = 4 words = 16 bytes = 128 bits
                this.Nr = 10;
                // rounds for algorithm = 10
            }
            else
            {
                if (keySize == KeySize.Bits192)
                {
                    this.Nk = 6;
                    // 6 words = 24 bytes = 192 bits
                    this.Nr = 12;
                }
                else
                {
                    if (keySize == KeySize.Bits256)
                    {
                        this.Nk = 8;
                        // 8 words = 32 bytes = 256 bits
                        this.Nr = 14;
                    }
                }
                // SetNbNkNr()
            }
        }
        //SetNbNkNr
        private void BuildSbox()
        {
            this.Sbox = new byte[,] { { 99, 124, 119, 123, 242, 107, 111, 197, 48, 1, 103, 43, 254, 215, 171, 118 }, { 202, 130, 201, 125, 250, 89, 71, 240, 173, 212, 162, 175, 156, 164, 114, 192 }, { 183, 253, 147, 38, 54, 63, 247, 204, 52, 165, 229, 241, 113, 216, 49, 21 }, { 4, 199, 35, 195, 24, 150, 5, 154, 7, 18, 128, 226, 235, 39, 178, 117 }, { 9, 131, 44, 26, 27, 110, 90, 160, 82, 59, 214, 179, 41, 227, 47, 132 }, { 83, 209, 0, 237, 32, 252, 177, 91, 106, 203, 190, 57, 74, 76, 88, 207 }, { 208, 239, 170, 251, 67, 77, 51, 133, 69, 249, 2, 127, 80, 60, 159, 168 }, { 81, 163, 64, 143, 146, 157, 56, 245, 188, 182, 218, 33, 16, 255, 243, 210 }, { 205, 12, 19, 236, 95, 151, 68, 23, 196, 167, 126, 61, 100, 93, 25, 115 }, { 96, 129, 79, 220, 34, 42, 144, 136, 70, 238, 184, 20, 222, 94, 11, 219 }, { 224, 50, 58, 10, 73, 6, 36, 92, 194, 211, 172, 98, 145, 149, 228, 121 }, { 231, 200, 55, 109, 141, 213, 78, 169, 108, 86, 244, 234, 101, 122, 174, 8 }, { 186, 120, 37, 46, 28, 166, 180, 198, 232, 221, 116, 31, 75, 189, 139, 138 }, { 112, 62, 181, 102, 72, 3, 246, 14, 97, 53, 87, 185, 134, 193, 29, 158 }, { 225, 248, 152, 17, 105, 217, 142, 148, 155, 30, 135, 233, 206, 85, 40, 223 }, { 140, 161, 137, 13, 191, 230, 66, 104, 65, 153, 45, 15, 176, 84, 187, 22 } };
        }

        //BuildSbox
        private void BuildInvSbox()
        {
            this.iSbox = new byte[,] { { 82, 9, 106, 213, 48, 54, 165, 56, 191, 64, 163, 158, 129, 243, 215, 251 }, { 124, 227, 57, 130, 155, 47, 255, 135, 52, 142, 67, 68, 196, 222, 233, 203 }, { 84, 123, 148, 50, 166, 194, 35, 61, 238, 76, 149, 11, 66, 250, 195, 78 }, { 8, 46, 161, 102, 40, 217, 36, 178, 118, 91, 162, 73, 109, 139, 209, 37 }, { 114, 248, 246, 100, 134, 104, 152, 22, 212, 164, 92, 204, 93, 101, 182, 146 }, { 108, 112, 72, 80, 253, 237, 185, 218, 94, 21, 70, 87, 167, 141, 157, 132 }, { 144, 216, 171, 0, 140, 188, 211, 10, 247, 228, 88, 5, 184, 179, 69, 6 }, { 208, 44, 30, 143, 202, 63, 15, 2, 193, 175, 189, 3, 1, 19, 138, 107 }, { 58, 145, 17, 65, 79, 103, 220, 234, 151, 242, 207, 206, 240, 180, 230, 115 }, { 150, 172, 116, 34, 231, 173, 53, 133, 226, 249, 55, 232, 28, 117, 223, 110 }, { 71, 241, 26, 113, 29, 41, 197, 137, 111, 183, 98, 14, 170, 24, 190, 27 }, { 252, 86, 62, 75, 198, 210, 121, 32, 154, 219, 192, 254, 120, 205, 90, 244 }, { 31, 221, 168, 51, 136, 7, 199, 49, 177, 18, 16, 89, 39, 128, 236, 95 }, { 96, 81, 127, 169, 25, 181, 74, 13, 45, 229, 122, 159, 147, 201, 156, 239 }, { 160, 224, 59, 77, 174, 42, 245, 176, 200, 235, 187, 60, 131, 83, 153, 97 }, { 23, 43, 4, 126, 186, 119, 214, 38, 225, 105, 20, 99, 85, 33, 12, 125 } };
        }

        //BuildInvSbox
        private void BuildRcon()
        {
            this.Rcon = new byte[11, 4] { { 0, 0, 0, 0 }, { 1, 0, 0, 0 }, { 2, 0, 0, 0 }, { 4, 0, 0, 0 }, { 8, 0, 0, 0 }, { 16, 0, 0, 0 }, { 32, 0, 0, 0 }, { 64, 0, 0, 0 }, { 128, 0, 0, 0 }, { 27, 0, 0, 0 }, { 54, 0, 0, 0 } };
        }

        //BuildRcon
        private void AddRoundKey(int round)
        {
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    this.State[num1, num2] = Convert.ToByte((this.State[num1, num2] ^ this.w[((round * 4) + num2), num1]));
                }
            }
        }
        //AddRoundKey
        private void SubBytes()
        {
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    this.State[num1, num2] = this.Sbox[(this.State[num1, num2] >> 4), (this.State[num1, num2] & 15)];
                }
            }
        }
        //SubBytes
        private void InvSubBytes()
        {
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    this.State[num1, num2] = this.iSbox[(this.State[num1, num2] >> 4), (this.State[num1, num2] & 15)];
                }
            }
        }

        //InvSubBytes
        private void ShiftRows()
        {
            byte[,] buffer1 = new byte[4, 4];
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    buffer1[num1, num2] = this.State[num1, num2];
                }
            }
            int num3 = 0;
            for (num3 = 1; num3 <= 4 - 1; num3++)
            {
                int num4 = 0;
                for (num4 = 0; num4 <= 4 - 1; num4++)
                {
                    this.State[num3, num4] = buffer1[num3, ((num4 + num3) % this.Nb)];
                }
            }
        }

        //ShiftRows
        private void InvShiftRows()
        {
            byte[,] buffer1 = new byte[4, 4];
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    buffer1[num1, num2] = this.State[num1, num2];
                }
            }
            int num3 = 0;
            for (num3 = 1; num3 <= 4 - 1; num3++)
            {
                int num4 = 0;
                for (num4 = 0; num4 <= 4 - 1; num4++)
                {
                    this.State[num3, ((num4 + num3) % this.Nb)] = buffer1[num3, num4];
                }
            }
        }

        //InvShiftRows
        private void MixColumns()
        {
            byte[,] buffer1 = new byte[4, 4];
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    buffer1[num1, num2] = this.State[num1, num2];
                }
            }
            int num3 = 0;
            for (num3 = 0; num3 <= 4 - 1; num3++)
            {
                this.State[0, num3] = Convert.ToByte((((gfmultby02(buffer1[0, num3]) ^ gfmultby03(buffer1[1, num3])) ^ gfmultby01(buffer1[2, num3])) ^ gfmultby01(buffer1[3, num3])));
                this.State[1, num3] = Convert.ToByte((((gfmultby01(buffer1[0, num3]) ^ gfmultby02(buffer1[1, num3])) ^ gfmultby03(buffer1[2, num3])) ^ gfmultby01(buffer1[3, num3])));
                this.State[2, num3] = Convert.ToByte((((gfmultby01(buffer1[0, num3]) ^ gfmultby01(buffer1[1, num3])) ^ gfmultby02(buffer1[2, num3])) ^ gfmultby03(buffer1[3, num3])));
                this.State[3, num3] = Convert.ToByte((((gfmultby03(buffer1[0, num3]) ^ gfmultby01(buffer1[1, num3])) ^ gfmultby01(buffer1[2, num3])) ^ gfmultby02(buffer1[3, num3])));
            }
        }
        //MixColumns
        private void InvMixColumns()
        {
            byte[,] buffer1 = new byte[4, 4];
            int num1 = 0;
            for (num1 = 0; num1 <= 4 - 1; num1++)
            {
                int num2 = 0;
                for (num2 = 0; num2 <= 4 - 1; num2++)
                {
                    buffer1[num1, num2] = this.State[num1, num2];
                }
            }
            int num3 = 0;
            for (num3 = 0; num3 <= 4 - 1; num3++)
            {
                this.State[0, num3] = Convert.ToByte((((gfmultby0e(buffer1[0, num3]) ^ gfmultby0b(buffer1[1, num3])) ^ gfmultby0d(buffer1[2, num3])) ^ gfmultby09(buffer1[3, num3])));
                this.State[1, num3] = Convert.ToByte((((gfmultby09(buffer1[0, num3]) ^ gfmultby0e(buffer1[1, num3])) ^ gfmultby0b(buffer1[2, num3])) ^ gfmultby0d(buffer1[3, num3])));
                this.State[2, num3] = Convert.ToByte((((gfmultby0d(buffer1[0, num3]) ^ gfmultby09(buffer1[1, num3])) ^ gfmultby0e(buffer1[2, num3])) ^ gfmultby0b(buffer1[3, num3])));
                this.State[3, num3] = Convert.ToByte((((gfmultby0b(buffer1[0, num3]) ^ gfmultby0d(buffer1[1, num3])) ^ gfmultby09(buffer1[2, num3])) ^ gfmultby0e(buffer1[3, num3])));
            }
        }
        //InvMixColumns
        private static byte gfmultby01(byte b)
        {
            return b;
        }
        //gfmultby01
        private static byte gfmultby02(byte b)
        {
            if ((b < 128))
            {
                return Convert.ToByte(b << 1);
            }
            return Convert.ToByte(((byte)(b << 1) ^ 27));
        }
        //gfmultby02
        private static byte gfmultby03(byte b)
        {
            return Convert.ToByte((gfmultby02(b) ^ b));
        }
        //gfmultby03
        private static byte gfmultby09(byte b)
        {
            return Convert.ToByte((gfmultby02(gfmultby02(gfmultby02(b))) ^ b));
        }
        //gfmultby09
        private static byte gfmultby0b(byte b)
        {
            return Convert.ToByte(((gfmultby02(gfmultby02(gfmultby02(b))) ^ gfmultby02(b)) ^ b));
        }
        //gfmultby0b
        private static byte gfmultby0d(byte b)
        {
            return Convert.ToByte(((gfmultby02(gfmultby02(gfmultby02(b))) ^ gfmultby02(gfmultby02(b))) ^ b));
        }
        //gfmultby0d
        private static byte gfmultby0e(byte b)
        {
            return Convert.ToByte(((gfmultby02(gfmultby02(gfmultby02(b))) ^ gfmultby02(gfmultby02(b))) ^ gfmultby02(b)));
        }
        //gfmultby0e
        private void KeyExpansion()
        {
            this.w = new byte[(this.Nb * (this.Nr + 1)), 4];
            int num1 = 0;
            for (num1 = 0; num1 <= this.Nk - 1; num1++)
            {
                this.w[num1, 0] = this.key[(4 * num1)];
                this.w[num1, 1] = this.key[((4 * num1) + 1)];
                this.w[num1, 2] = this.key[((4 * num1) + 2)];
                this.w[num1, 3] = this.key[((4 * num1) + 3)];
            }
            byte[] buffer1 = new byte[4];
            int num2 = 0;
            for (num2 = this.Nk; num2 <= (this.Nb * (this.Nr + 1)) - 1; num2++)
            {
                buffer1[0] = this.w[(num2 - 1), 0];
                buffer1[1] = this.w[(num2 - 1), 1];
                buffer1[2] = this.w[(num2 - 1), 2];
                buffer1[3] = this.w[(num2 - 1), 3];
                if (((num2 % this.Nk) == 0))
                {
                    buffer1 = this.SubWord(this.RotWord(buffer1));
                    buffer1[0] = Convert.ToByte((buffer1[0] ^ this.Rcon[(num2 / this.Nk), 0]));
                    buffer1[1] = Convert.ToByte((buffer1[1] ^ this.Rcon[(num2 / this.Nk), 1]));
                    buffer1[2] = Convert.ToByte((buffer1[2] ^ this.Rcon[(num2 / this.Nk), 2]));
                    buffer1[3] = Convert.ToByte((buffer1[3] ^ this.Rcon[(num2 / this.Nk), 3]));
                }
                else
                {
                    if (((this.Nk > 6) && ((num2 % this.Nk) == 4)))
                    {
                        buffer1 = this.SubWord(buffer1);
                    }
                }
                this.w[num2, 0] = Convert.ToByte((this.w[(num2 - this.Nk), 0] ^ buffer1[0]));
                this.w[num2, 1] = Convert.ToByte((this.w[(num2 - this.Nk), 1] ^ buffer1[1]));
                this.w[num2, 2] = Convert.ToByte((this.w[(num2 - this.Nk), 2] ^ buffer1[2]));
                this.w[num2, 3] = Convert.ToByte((this.w[(num2 - this.Nk), 3] ^ buffer1[3]));
            }
        }
        //KeyExpansion
        private byte[] SubWord(byte[] word)
        {
            return new byte[] {
				this.Sbox[(word[0] >> 4), (word[0] & 15)],
				this.Sbox[(word[1] >> 4), (word[1] & 15)],
				this.Sbox[(word[2] >> 4), (word[2] & 15)],
				this.Sbox[(word[3] >> 4), (word[3] & 15)]
			};
        }
        //SubWord
        private byte[] RotWord(byte[] word)
        {
            return new byte[] {
				word[1],
				word[2],
				word[3],
				word[0]
			};
        }
        //RotWord
    }

    //This class is not using but it's a good reference
    public class Crypto
    {
        private static TripleDESCryptoServiceProvider DES = new TripleDESCryptoServiceProvider();

        private static MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();
        public static byte[] MD5Hash(string value)
        {
            return MD5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(value));
        }

        public static string Encrypt(string stringToEncrypt, string key)
        {
            DES.Key = Crypto.MD5Hash(key);
            DES.Mode = CipherMode.ECB;
            byte[] Buffer = ASCIIEncoding.ASCII.GetBytes(stringToEncrypt);
            return Convert.ToBase64String(DES.CreateEncryptor().TransformFinalBlock(Buffer, 0, Buffer.Length));
        }

        public static string Decrypt(string EncryptedString, string key)
        {
            try
            {
                DES.Key = Crypto.MD5Hash(key);
                DES.Mode = CipherMode.ECB;
                byte[] Buffer = Convert.FromBase64String(EncryptedString);
                return ASCIIEncoding.ASCII.GetString(DES.CreateDecryptor().TransformFinalBlock(Buffer, 0, Buffer.Length));
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

    }
}
