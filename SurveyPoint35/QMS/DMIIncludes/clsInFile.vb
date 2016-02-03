Option Strict On
Option Explicit On

Public Class clsIniFile

    Private _sFilename As String = ""
    Private _sFileContents As String = ""
    Private _alSections As New ArrayList()
    Private _sSectionName As String = ""
    Private _htKeys As New Hashtable()

    Private Const SECTION_REGEX As String = "\[([^\]]+)\]"
    Private Const KEY_REGEX As String = "([^=]+)=(.+)"
    Private Const SECTION_KEYS_REGEX As String = "\[{0}\]([^\[]*)"

    Public Sub New(Optional ByVal sFilename As String = "")

        If sFilename.Length > 0 Then LoadFile(sFilename)
        _sFilename = sFilename

    End Sub

    'Read file content into variable
    Public Sub LoadFile(ByVal sFilename As String)
        Dim f As IO.File
        Dim s As IO.Stream
        Dim sr As IO.StreamReader

        'valid file?
        If f.Exists(sFilename) Then
            _sFilename = sFilename
            'open file
            s = f.OpenRead(_sFilename)
            sr = New System.IO.StreamReader(s)
            'pull file contents into variable
            _sFileContents = sr.ReadToEnd()
            'close file and file reader
            sr.Close()
            s.Close()

            'get section names from file
            GetSections()
            'clear section keys
            _htKeys.Clear()

        End If

    End Sub

    'Setup section array
    Private Sub GetSections()
        Dim re As New Text.RegularExpressions.Regex(SECTION_REGEX, Text.RegularExpressions.RegexOptions.Multiline)
        Dim oMatch As Text.RegularExpressions.Match
        Dim oMatches As Text.RegularExpressions.MatchCollection

        'clear section array
        _alSections.Clear()

        'Find all section titles
        oMatches = re.Matches(_sFileContents)

        'loop thru each line of file contents
        For Each oMatch In oMatches
            _alSections.Add(oMatch.Groups(1).ToString.ToUpper)

        Next

    End Sub

    'Reference to section array
    ReadOnly Property Sections() As ArrayList
        Get
            Return _alSections

        End Get

    End Property

    'Reference to key hashtable
    ReadOnly Property Keys() As Hashtable
        Get
            Return _htKeys

        End Get
    End Property

    'Read section and keys
    Public Sub SetSection(ByVal sName As String)
        'Set current section
        _sSectionName = sName

        If _alSections.Contains(sName.ToUpper) Then
            'section exist, load keys
            GetKeys(_sSectionName)

        Else
            'new section, add section and clear keys
            _alSections.Add(_sSectionName)
            _htKeys.Clear()

        End If

    End Sub

    'setup keys
    Private Sub GetKeys(ByVal sSectionName As String)
        Dim sr As IO.StringReader
        Dim sLine As String
        Dim reSection As Text.RegularExpressions.Regex
        Dim reKey As New Text.RegularExpressions.Regex(KEY_REGEX)
        Dim oMatch As Text.RegularExpressions.Match
        Dim sPattern As String

        _htKeys.Clear()

        sPattern = String.Format(SECTION_KEYS_REGEX, Text.RegularExpressions.Regex.Escape(sSectionName))
        reSection = New Text.RegularExpressions.Regex(sPattern, Text.RegularExpressions.RegexOptions.Multiline Or Text.RegularExpressions.RegexOptions.IgnoreCase)

        If reSection.IsMatch(_sFileContents) Then
            oMatch = reSection.Match(_sFileContents)
            sr = New IO.StringReader(oMatch.Groups(1).ToString)
            sLine = sr.ReadLine

            'loop thru each line of file contents
            Do Until IsNothing(sLine)
                'is line a section name
                If reKey.IsMatch(sLine) Then
                    'add section name to array
                    oMatch = reKey.Match(sLine)
                    _htKeys.Add(oMatch.Groups(1).ToString, oMatch.Groups(2).ToString)

                End If

                'get next line
                sLine = sr.ReadLine()
            Loop

            'close string reader
            sr.Close()

        End If

    End Sub

    Public Sub DeleteSection(ByVal sName As String)
        ReplaceSection(sName, "")

    End Sub

    Public Sub SaveSection()
        Dim sbKeys As New Text.StringBuilder()
        Dim strw As New IO.StringWriter(sbKeys)
        Dim a As Object

        'write keys to string builder
        strw.WriteLine("[{0}]", _sSectionName.ToUpper)
        For Each a In _htKeys.Keys
            strw.WriteLine("{0}={1}", a.ToString, _htKeys(a).ToString)

        Next
        strw.WriteLine("")
        strw.Close()

        ReplaceSection(_sSectionName, sbKeys.ToString)

    End Sub

    Private Sub ReplaceSection(ByVal sName As String, ByVal sReplacement As String)
        Dim reSection As Text.RegularExpressions.Regex
        Dim oMatch As Text.RegularExpressions.Match
        Dim sPattern As String
        Dim sw As IO.StreamWriter
        Dim f As IO.File
        Dim s As IO.Stream
        Dim sr As IO.StreamReader

        If f.Exists(_sFilename) Then
            'Get recent copy of file contents
            s = f.Open(_sFilename, IO.FileMode.Open)
            sr = New IO.StreamReader(s)
            _sFileContents = sr.ReadToEnd
            sr.Close()
            s.Close()
            sr = Nothing

            'find section
            sPattern = String.Format(SECTION_KEYS_REGEX, Text.RegularExpressions.Regex.Escape(sName))
            reSection = New Text.RegularExpressions.Regex(sPattern, Text.RegularExpressions.RegexOptions.Multiline Or Text.RegularExpressions.RegexOptions.IgnoreCase)
            If reSection.IsMatch(_sFileContents) Then
                'Replace section
                _sFileContents = reSection.Replace(_sFileContents, sReplacement)

            Else
                'append to end of file
                _sFileContents &= sReplacement

            End If

            'delete existing file
            f.Delete(_sFilename)

        Else
            _sFileContents = sReplacement

        End If

        'create replacement file
        s = f.Open(_sFilename, IO.FileMode.CreateNew)
        sw = New IO.StreamWriter(s)
        sw.Write(_sFileContents)
        sw.Flush()
        sw.Close()
        s.Close()

        'Re-read sections
        GetSections()


    End Sub

End Class
