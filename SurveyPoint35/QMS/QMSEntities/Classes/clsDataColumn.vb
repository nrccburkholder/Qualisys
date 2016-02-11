Option Strict On
Option Explicit On
Imports System.Text

Public Class clsDataColumn

    Private m_sSourceTableName As String
    Private m_sSourceColName As String
    Private m_sDestColName As String
    Private m_sFileDefColName As String
    Private m_sPropertyName As String
    Private m_iSurveyQuestionID As Integer
    Private m_iQuestionPartID As Integer

    Private SKIP_FIELD_COL_NAME As String = "SKIP_FIELD"

    Public Sub Clear()

        m_sSourceTableName = ""
        m_sSourceColName = ""
        m_sDestColName = ""
        m_sFileDefColName = ""
        m_sPropertyName = ""
        m_iSurveyQuestionID = 0
        m_iQuestionPartID = 0

    End Sub

    Public Sub SetSourceTableColName(ByVal sTableName As String, ByVal sColName As String, Optional ByVal sPropertyName As String = "", Optional ByVal iSurveyQuestionID As Integer = 0, Optional ByVal iQuestionPartID As Integer = 0)

        'reset local variables
        Clear()

        'set optional variables
        m_sPropertyName = sPropertyName
        m_iSurveyQuestionID = iSurveyQuestionID
        m_iQuestionPartID = iQuestionPartID

        'set source table variables
        m_sSourceTableName = sTableName.ToUpper
        m_sSourceColName = sColName.ToUpper

        'set file def variable
        Select Case m_sSourceTableName.ToUpper
            Case "RESPONDENTS"
                m_sFileDefColName = String.Format("RESPONDENT: {0}", sColName)

            Case "RESPONSES"
                If sColName.ToUpper = "RESPONSEDESC" Then
                    m_sFileDefColName = String.Format("Q{0}.{1} DESC: ", m_iSurveyQuestionID, m_iQuestionPartID)

                ElseIf sColName.ToUpper = "ANSWERVALUE" Then
                    m_sFileDefColName = String.Format("Q{0}.{1}: ", m_iSurveyQuestionID, m_iQuestionPartID)

                Else
                    m_sFileDefColName = String.Format("Q{0}.{1} UNKNOWN: ", m_iSurveyQuestionID, m_iQuestionPartID)

                End If


            Case "RESPONDENTPROPERTIES"
                m_sFileDefColName = String.Format("PROPERTY: {0}", m_sPropertyName.ToUpper)

        End Select

        'set destination variable
        m_sDestColName = Me.FDToDestColName(m_sFileDefColName)

    End Sub

    Public Sub SetSourceTableColName(ByVal sTableName As String, ByVal sColName As String, ByVal iSurveyQuestionID As Integer, ByVal iQuestionPartID As Integer)

        SetSourceTableColName(sTableName, sColName, "", iSurveyQuestionID, iQuestionPartID)

    End Sub

    Private Sub SetDestTableColName(ByVal sColName As String)

        'reset local variables
        Clear()

        'set destination variable
        m_sDestColName = sColName

        'set file definition variable
        m_sFileDefColName = Me.DestToFDColName(m_sDestColName)

        'set source and option variables
        Me.ParseFileDefColName(m_sFileDefColName)

    End Sub

    Private Sub SetFileDefColName(ByVal sColName As String)
        Dim oMatch As RegularExpressions.Match

        'reset local variables
        Clear()

        'set file def variables
        m_sFileDefColName = sColName

        'set destination variable
        m_sDestColName = Me.FDToDestColName(sColName)

        'set source and option variables
        Me.ParseFileDefColName(sColName)

    End Sub

    Private Sub ParseFileDefColName(ByVal sFDColName As String)
        Dim oMatch As RegularExpressions.Match
        Dim rxRespondentCol As New RegularExpressions.Regex("^(?:RESPONDENTS?[:_]\s*)?(.+)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim rxPropertyCol As New RegularExpressions.Regex("^PROPERTY[:_]\s*(.+)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim rxQuestionValueCol As New RegularExpressions.Regex("^Q(\d+)\.(\d+):.*$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim rxQuestionDescCol As New RegularExpressions.Regex("^Q(\d+)\.(\d+) DESC:.*$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim rxSkipFieldCol As New RegularExpressions.Regex("^SKIP_FIELD.*(\d*)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)

        If rxSkipFieldCol.IsMatch(sFDColName) Then
            m_sSourceTableName = ""
            oMatch = rxSkipFieldCol.Match(sFDColName)
            m_sSourceColName = String.Format("{0}_{1}", sFDColName, oMatch.Groups(1).Value).Trim()

        ElseIf rxPropertyCol.IsMatch(sFDColName) Then
            m_sSourceTableName = "RESPONDENTPROPERTIES"
            oMatch = rxPropertyCol.Match(sFDColName)
            m_sPropertyName = oMatch.Groups(1).Value
            m_sSourceColName = "PROPERTYVALUE"

        ElseIf rxQuestionValueCol.IsMatch(sFDColName) Then
            m_sSourceTableName = "RESPONSES"
            oMatch = rxQuestionValueCol.Match(sFDColName)
            m_iSurveyQuestionID = CInt(oMatch.Groups(1).Value)
            m_iQuestionPartID = CInt(oMatch.Groups(2).Value)
            m_sSourceColName = "ANSWERVALUE"

        ElseIf rxQuestionDescCol.IsMatch(sFDColName) Then
            m_sSourceTableName = "RESPONSES"
            oMatch = rxQuestionDescCol.Match(sFDColName)
            m_iSurveyQuestionID = CInt(oMatch.Groups(1).Value)
            m_iQuestionPartID = CInt(oMatch.Groups(2).Value)
            m_sSourceColName = "RESPONSEDESC"

        ElseIf rxRespondentCol.IsMatch(sFDColName) Then
            m_sSourceTableName = "RESPONDENTS"
            oMatch = rxRespondentCol.Match(sFDColName)
            m_sSourceColName = oMatch.Groups(1).Value

        Else
            m_sSourceTableName = ""
            m_sSourceColName = sFDColName

        End If

        oMatch = Nothing

    End Sub

    Private Function DestToFDColName(ByVal sDestColName As String) As String
        Dim oMatch As RegularExpressions.Match
        Dim rx As New RegularExpressions.Regex("^Q(\d+)_(\d+)(_DESC)*$")
        Dim rxSkipFieldCol As New RegularExpressions.Regex("^SKIP_FIELD_*(\d*)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)

        Const TABLE_COL As String = "^([^_]+)_\s*(.+)$"

        'test for question column
        If rxSkipFieldCol.IsMatch(sDestColName) Then
            oMatch = rx.Match(sDestColName)
            If (oMatch.Groups(1).Value = "") Then
                Return SKIP_FIELD_COL_NAME
            Else
                Return String.Format("{0} {1}", SKIP_FIELD_COL_NAME, oMatch.Groups(1).Value)
            End If


        ElseIf rx.IsMatch(sDestColName) Then
            oMatch = rx.Match(sDestColName)
            Return String.Format("Q{0}.{1}{2}: ", oMatch.Groups(1).ToString, oMatch.Groups(2).ToString, oMatch.Groups(3).ToString.Replace("_", " "))

        ElseIf rx.IsMatch(sDestColName, TABLE_COL) Then
            oMatch = rx.Match(sDestColName, TABLE_COL)
            Return String.Format("{0}: {1}", oMatch.Groups(1), oMatch.Groups(2))

        Else
            Return String.Format("Respondent: {0}", sDestColName)

        End If

    End Function

    Private Function FDToDestColName(ByVal sFDColName As String) As String
        Dim oMatch As RegularExpressions.Match
        Dim rx As New RegularExpressions.Regex("^Q(\d+)\.(\d+)\s*(DESC)*:.*$", RegularExpressions.RegexOptions.IgnoreCase)
        Dim rxSkipFieldCol As New RegularExpressions.Regex("^SKIP FIELD\D*(\d*)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim Pattern As String

        'test for question column
        If rx.IsMatch(sFDColName) Then
            oMatch = rx.Match(sFDColName)
            Return String.Format("Q{0}_{1}{2}", oMatch.Groups(1).ToString, _
                                                oMatch.Groups(2).ToString, _
                                                IIf(oMatch.Groups(3).Length > 0, "_DESC", ""))

        End If

        'test for respondent column
        Pattern = "Respondent:\s*(\w*)"
        If rx.IsMatch(sFDColName, Pattern) Then
            oMatch = rx.Match(sFDColName, Pattern)
            Return oMatch.Groups(1).ToString.ToUpper

        End If

        'test for skip field
        If rxSkipFieldCol.IsMatch(sFDColName) Then
            oMatch = rxSkipFieldCol.Match(sFDColName)
            If (oMatch.Groups(1).Value = "") Then
                Return SKIP_FIELD_COL_NAME
            Else
                Return String.Format("{0}_{1}", SKIP_FIELD_COL_NAME, oMatch.Groups(1).Value)
            End If
        End If

        Return rx.Replace(sFDColName, ":\s*", "_")

    End Function

    Public Function GetFileDataType() As Integer

        If Me.m_sSourceTableName = "RESPONDENTS" Then
            Select Case Me.m_sSourceColName
                Case "RESPONDENTID", "BATCHID", "SURVEYINSTANCEID", "MAILINGSEEDFLAG", "CLIENTID", "SURVEYID"
                    Return CInt(DMI.TextFileDataTypes.INTEGER_TYPE)

                Case "DOB"
                    Return CInt(DMI.TextFileDataTypes.DATE_TYPE)

            End Select

        ElseIf Me.m_sSourceTableName = "RESPONSES" Then
            If Me.m_sSourceColName = "ANSWERVALUE" Then
                Return CInt(DMI.TextFileDataTypes.INTEGER_TYPE)

            Else
                Return CInt(DMI.TextFileDataTypes.CHAR_TYPE)

            End If

        End If

        'by default all columns are character types
        Return CInt(DMI.TextFileDataTypes.CHAR_TYPE)

    End Function

    Public Function GetColWidth() As Integer

        If Me.m_sSourceTableName = "RESPONDENTS" Then
            Select Case Me.m_sSourceColName
                Case "GENDER"
                    Return 1
                Case "STATE"
                    Return 2
                Case "RESPONDENTID", "BATCHID", "SURVEYINSTANCEID", "MAILINGSEEDFLAG", "CLIENTID", "SURVEYID"
                    Return 8
                Case "DOB", "MIDDLEINITIAL"
                    Return 10
                Case "POSTALCODE", "TELEPHONEDAY", "TELEPHONEEVENING", "EMAIL", "ClientRespondentID", "SSN"
                    Return 50
                Case "FIRSTNAME", "LASTNAME", "CITY", "CLIENTNAME", "SURVEYNAME"
                    Return 100
                Case "ADDRESS1", "ADDRESS2"
                    Return 250
            End Select

        ElseIf Me.m_sSourceTableName = "RESPONSES" Then
            Select Case Me.m_sSourceColName
                Case "ANSWERVALUE"
                    Return 8
                Case "RESPONSEDESC"
                    Return 100
            End Select

        ElseIf Me.m_sSourceTableName = "RESPONDENTPROPERTIES" Then
            Return 100

        End If

        Return 0

    End Function

    Public ReadOnly Property SourceTableName() As String
        Get
            Return m_sSourceTableName

        End Get
    End Property

    Public ReadOnly Property SourceColName() As String
        Get
            Return m_sSourceColName

        End Get
    End Property

    Public Property DestColName() As String
        Get
            Return m_sDestColName

        End Get
        Set(ByVal Value As String)
            Me.SetDestTableColName(Value)

        End Set
    End Property

    Public Property FileDefColName() As String
        Get
            Return m_sFileDefColName

        End Get
        Set(ByVal Value As String)
            Me.SetFileDefColName(Value)

        End Set
    End Property

    Public ReadOnly Property PropertyName() As String
        Get
            Return m_sPropertyName

        End Get
    End Property

    Public ReadOnly Property SurveyQuestionID() As Integer
        Get
            Return m_iSurveyQuestionID

        End Get
    End Property

    Public ReadOnly Property QuestionPartID() As Integer
        Get
            Return m_iQuestionPartID

        End Get
    End Property

    Public ReadOnly Property FileDataType() As Integer
        Get
            Return GetFileDataType()

        End Get
    End Property

    Public Function IsTableRespondents() As Boolean
        If m_sSourceTableName = "RESPONDENTS" Then Return True

        Return False

    End Function


    Public Function IsTableRespondentProperties() As Boolean
        If m_sSourceTableName = "RESPONDENTPROPERTIES" Then Return True

        Return False

    End Function


    Public Function IsTableQuestions() As Boolean
        If m_sSourceTableName = "RESPONSES" Then Return True

        Return False

    End Function

End Class
