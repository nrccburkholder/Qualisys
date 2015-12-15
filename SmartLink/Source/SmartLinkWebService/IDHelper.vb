Imports Microsoft.VisualBasic
Imports System

Namespace IDHelper

    Public Module IDGenerator

        Private seed As Integer

        ''' <summary>
        ''' Creates a new ID and returns it as a string.
        ''' </summary>
        ''' ***************************************************************************************
        ''' This method creates the unique ID for a record.  The key is the concatination       *
        ''' of the date, and a psuedo random number.                                            *
        ''' Output: A string repesenting the ID string formatted to be inserted into sql.       *
        ''' ***************************************************************************************

        Public Function GenerateID() As String

            Dim strID As String
            Dim strRandom As String = String.Empty
            Dim strDate As String
            Dim seededRand As Random

            'increment the seed but keep below 5000
            seed = (seed + 1) Mod 5000

            'convert current date to base 36 number and grab an 8 digit random number
            strDate = convertToBase36(Now())

            'grab 3 characters worth of a random number
            seededRand = New Random(seed)
            strRandom += convertToBase36(seededRand.Next(0, 46655))
            seededRand = Nothing

            'concat the prefix, the date as 36 base, and the random for the ID
            strID = strDate & strRandom

            Return strID

        End Function


        '***************************************************************
        ' convers a date to a base 36 number                           *
        '***************************************************************
        Function convertToBase36(ByVal dtDateField As Date) As String
            Return convertToBase36(CType(dtDateField.ToString("MMddyyHHmmssffff"), Int64))
        End Function

        Function convertToBase36(ByVal intBase10number As Int64) As String
            Dim strDigits As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            Dim cDigit() As Char = strDigits.ToCharArray()
            Dim strBase36number As String = String.Empty
            Dim intTemp As Int64

            Do
                intTemp = CType(Fix(intBase10number / 36), Int64)
                strBase36number = cDigit(CInt(intBase10number Mod 36)) & strBase36number
                intBase10number = intTemp
            Loop While intBase10number <> 0

            Return strBase36number
        End Function

    End Module
End Namespace


