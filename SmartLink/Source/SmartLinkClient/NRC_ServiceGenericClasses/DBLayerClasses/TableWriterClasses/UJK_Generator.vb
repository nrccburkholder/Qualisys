Namespace Miscellaneous

    Public Class UJK_Generator

        'Private Shared rand As New Random()

        'bilwel 1/12/2009 - no longer using a seeded random number, now we use an
        '                   incrementing value as the suffix instead
        'Private Shared seed As Integer
        Private Shared _suffix As Integer
        Private Shared _DefaultPrefix As String

        ''' <summary>
        ''' Use this property to assign a default value to be used as a table/database prefix when none is passed to the method.
        ''' </summary>
        Public Shared Property DefaultPrefix() As String
            Get
                Return _DefaultPrefix
            End Get
            Set(ByVal value As String)
                _DefaultPrefix = value
            End Set
        End Property


        ''' <summary>
        ''' Creates a new UJK and returns it as a string.
        ''' </summary>
        ''' ***************************************************************************************
        ''' This method creates the unique join key for a record.  The key is the concatination *
        ''' of the input table prefix, the date, and an incrementing number.                    *
        ''' Output: A string repesenting the UJK string formatted to be inserted into sql.      *
        ''' ***************************************************************************************
        ''' <param name="strPrefix">A two character prefix that represents a table name or database.</param>
        Public Shared Function GenerateUJK(ByVal strPrefix As String) As String

            Dim strUJK As String
            'Dim strRandom As String = String.Empty
            Dim strSuffix As String = String.Empty
            Dim strDate As String
            'Dim seededRand As Random

            'bilwel 1/12/2009 - no longer using a seeded random number, now we use an
            '                   incrementing value as the suffix instead
            'increment the seed but keep below 500
            _suffix = (_suffix + 1) Mod 46655 'Mod 500

            'prefix must be two characters exactly
            'If strPrefix.Length <> 2 Then
            '    'Throw New SLWriterException("Invalid prefix passed to GenerateUJK.  It just be two characters in length.")
            'End If

            'convert current date to base 36 number and grab an 8 digit random number
            strDate = convertToBase36(Now())

            'For intI As Integer = 0 To 2
            '    strRandom += convertToBase36(rand.Next(0, 35))
            'Next

            'bilwel 1/12/2009 - no longer using a seeded random number, now we use an
            '                   incrementing value as the suffix instead
            'grab 3 characters worth of a random number
            'seededRand = New Random(seed)
            'strRandom += convertToBase36(seededRand.Next(0, 46655))
            'seededRand = Nothing
            strSuffix = convertToBase36(_suffix)


            'concat the prefix, the date as 36 base, and the random for the ujk
            strUJK = strPrefix & strDate & strSuffix

            Return strUJK

        End Function

        ''' <summary>
        ''' Creates a new UJK and returns it as a string.
        ''' </summary>
        ''' ***************************************************************************************
        ''' This method creates the unique join key for a record.  The key is the concatination *
        ''' of the prefix, the date, and a psuedo random number.                                *
        ''' Output: A string repesenting the UJK string formatted to be inserted into sql.      *
        ''' ***************************************************************************************
        ''' <param name="strPrefix">A two character prefix that represents a table name or database.</param>
        ''' <param name="intSeed">An integer used to seed the random number generator used to create the last 3 characters</param>
        Public Shared Function GenerateUJK(ByVal strPrefix As String, ByVal intSeed As Integer) As String

            Dim strUJK As String
            Dim strRandom As String = String.Empty
            Dim strDate As String
            Dim seededRand As Random

            'prefix must be two characters exactly
            'If strPrefix.Length <> 2 Then
            '    'Throw New SLWriterException("Invalid prefix passed to GenerateUJK.  It just be two characters in length.")
            'End If

            'convert current date to base 36 number 
            strDate = convertToBase36(Now())


            'For intI As Integer = 0 To 2
            '    strRandom += convertToBase36(seededRand.Next(0, 35))
            'Next

            'grab 3 characters worth of a random number
            seededRand = New Random(intSeed)
            strRandom += convertToBase36(seededRand.Next(0, 46655))
            seededRand = Nothing

            'concat the prefix, the date as 36 base, and the random for the ujk
            strUJK = strPrefix & strDate & strRandom

            Return strUJK

        End Function

        ''' <summary>
        ''' Creates a new UJK and returns it as a string.
        ''' </summary>
        ''' ***************************************************************************************
        ''' This method creates the unique join key for a record.  The key is the concatination *
        ''' of the default prefix, the date, and an incrementing number.                        *
        ''' Output: A string repesenting the UJK string formatted to be inserted into sql.      *
        ''' ***************************************************************************************
        Public Shared Function GenerateUJK() As String
            Return GenerateUJK(_DefaultPrefix)
        End Function

        '***************************************************************
        ' convers a date to a base 36 number                           *
        '***************************************************************
        Shared Function convertToBase36(ByVal dtDateField As Date) As String
            Return convertToBase36(CType(dtDateField.ToString("MMddyyHHmmssffff"), Int64))
        End Function

        Shared Function convertToBase36(ByVal intBase10number As Int64) As String
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

        '***************************************************************
        ' convers a base 36 number to a date                           *
        '***************************************************************
        Shared Function convertFromBase36(ByVal strNumber As String) As String

            Dim strDigits As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            Dim intI As Integer = 0
            Dim lngDate As Long
            Dim cNumber() As Char

            cNumber = strNumber.Trim().ToCharArray()
            While intI < strNumber.Length()
                lngDate += strDigits.IndexOf(cNumber(intI)) * CType(Math.Pow(36, (strNumber.Length - 1) - intI), Int64)
                intI += 1
            End While

            Return "" & lngDate
        End Function

    End Class

End Namespace

