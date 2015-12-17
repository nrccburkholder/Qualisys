using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
namespace NRC.Miscellaneous
{

	public class UJK_Generator
	{

		//Private Shared rand As New Random()

		//bilwel 1/12/2009 - no longer using a seeded random number, now we use an
		//                   incrementing value as the suffix instead
		//Private Shared seed As Integer
		private static int _suffix;

		private static string _DefaultPrefix;
		/// <summary>
		/// Use this property to assign a default value to be used as a table/database prefix when none is passed to the method.
		/// </summary>
		public static string DefaultPrefix {
			get { return _DefaultPrefix; }
			set { _DefaultPrefix = value; }
		}


		/// <summary>
		/// Creates a new UJK and returns it as a string.
		/// </summary>
		/// ***************************************************************************************
		/// This method creates the unique join key for a record.  The key is the concatination *
		/// of the input table prefix, the date, and an incrementing number.                    *
		/// Output: A string repesenting the UJK string formatted to be inserted into sql.      *
		/// ***************************************************************************************
		/// <param name="strPrefix">A two character prefix that represents a table name or database.</param>
		public static string GenerateUJK(string strPrefix)
		{

			string strUJK = null;
			//Dim strRandom As String = String.Empty
			string strSuffix = string.Empty;
			string strDate = null;
			//Dim seededRand As Random

			//bilwel 1/12/2009 - no longer using a seeded random number, now we use an
			//                   incrementing value as the suffix instead
			//increment the seed but keep below 500
			_suffix = (_suffix + 1) % 46655;
			//Mod 500

			//prefix must be two characters exactly
			//If strPrefix.Length <> 2 Then
			//    'Throw New SLWriterException("Invalid prefix passed to GenerateUJK.  It just be two characters in length.")
			//End If

			//convert current date to base 36 number and grab an 8 digit random number
			strDate = convertToBase36(DateAndTime.Now);

			//For intI As Integer = 0 To 2
			//    strRandom += convertToBase36(rand.Next(0, 35))
			//Next

			//bilwel 1/12/2009 - no longer using a seeded random number, now we use an
			//                   incrementing value as the suffix instead
			//grab 3 characters worth of a random number
			//seededRand = New Random(seed)
			//strRandom += convertToBase36(seededRand.Next(0, 46655))
			//seededRand = Nothing
			strSuffix = convertToBase36(_suffix);


			//concat the prefix, the date as 36 base, and the random for the ujk
			strUJK = strPrefix + strDate + strSuffix;

			return strUJK;

		}

		/// <summary>
		/// Creates a new UJK and returns it as a string.
		/// </summary>
		/// ***************************************************************************************
		/// This method creates the unique join key for a record.  The key is the concatination *
		/// of the prefix, the date, and a psuedo random number.                                *
		/// Output: A string repesenting the UJK string formatted to be inserted into sql.      *
		/// ***************************************************************************************
		/// <param name="strPrefix">A two character prefix that represents a table name or database.</param>
		/// <param name="intSeed">An integer used to seed the random number generator used to create the last 3 characters</param>
		public static string GenerateUJK(string strPrefix, int intSeed)
		{

			string strUJK = null;
			string strRandom = string.Empty;
			string strDate = null;
			Random seededRand = null;

			//prefix must be two characters exactly
			//If strPrefix.Length <> 2 Then
			//    'Throw New SLWriterException("Invalid prefix passed to GenerateUJK.  It just be two characters in length.")
			//End If

			//convert current date to base 36 number 
			strDate = convertToBase36(DateAndTime.Now);


			//For intI As Integer = 0 To 2
			//    strRandom += convertToBase36(seededRand.Next(0, 35))
			//Next

			//grab 3 characters worth of a random number
			seededRand = new Random(intSeed);
			strRandom += convertToBase36(seededRand.Next(0, 46655));
			seededRand = null;

			//concat the prefix, the date as 36 base, and the random for the ujk
			strUJK = strPrefix + strDate + strRandom;

			return strUJK;

		}

		/// <summary>
		/// Creates a new UJK and returns it as a string.
		/// </summary>
		/// ***************************************************************************************
		/// This method creates the unique join key for a record.  The key is the concatination *
		/// of the default prefix, the date, and an incrementing number.                        *
		/// Output: A string repesenting the UJK string formatted to be inserted into sql.      *
		/// ***************************************************************************************
		public static string GenerateUJK()
		{
			return GenerateUJK(_DefaultPrefix);
		}

		//***************************************************************
		// convers a date to a base 36 number                           *
		//***************************************************************
		public static string convertToBase36(System.DateTime dtDateField)
		{
			return convertToBase36(Int64.Parse(dtDateField.ToString("MMddyyHHmmssffff")));
		}

		public static string convertToBase36(Int64 intBase10number)
		{
			string strDigits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			char[] cDigit = strDigits.ToCharArray();
			string strBase36number = string.Empty;
			Int64 intTemp = default(Int64);

			do {
				intTemp = (Int64)Conversion.Fix(intBase10number / 36);
				strBase36number = cDigit[Convert.ToInt32(intBase10number % 36)] + strBase36number;
				intBase10number = intTemp;
			} while (intBase10number != 0);

			return strBase36number;
		}

		//***************************************************************
		// convers a base 36 number to a date                           *
		//***************************************************************
		public static string convertFromBase36(string strNumber)
		{

			string strDigits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			int intI = 0;
			long lngDate = 0;
			char[] cNumber = null;

			cNumber = strNumber.Trim().ToCharArray();
			while (intI < strNumber.Length) {
				lngDate += strDigits.IndexOf(cNumber[intI]) * (Int64)Math.Pow(36, (strNumber.Length - 1) - intI);
				intI += 1;
			}

			return "" + lngDate;
		}

	}

}

