Imports System.Data
Imports System.Data.SqlClient

Public Class clsQuestionnaire

    Private mstrLithoCode As String = ""
    Private mintSentMailID As Integer
    Private mintQuestionFormID As Integer
    Private mintStudyID As Integer
    Private mintSurveyID As Integer
    Private mintSamplePopID As Integer
    Private mintSampleSetID As Integer
    Private mintPopID As Integer
    Private mdatResultsImported As Date
    Private mbolAlreadyExists As Boolean
    Private mdatDateReturned As Date
    Private mobjQuestions As New ArrayList
    Private mobjPopValues As New ArrayList

    Private mstrErrorString As String = ""

    Public Sub New(ByVal strLithoCode As String, ByVal datDateReturned As Date)

        MyBase.New()

        'Save the data passed in
        mstrLithoCode = strLithoCode
        mdatDateReturned = datDateReturned

        'Populate the data for this litho
        PopAdditionalInfo()

    End Sub

    Private Sub PopAdditionalInfo()

        'Dim strConn As String = GetSQLConnectString(strApplication:="OfflineTransferResults")
        Dim strConn As String = Config.QP_ProdConnection

        'Open the connection
        Dim objConnection1 As SqlConnection = New SqlConnection(strConn)
        Dim objConnection2 As SqlConnection = New SqlConnection(strConn)    '** Added 10/16/03 JJF
        Dim objDataAdapter As SqlDataAdapter = New SqlDataAdapter

        'Build the additional info command
        Dim objAddInfoCommand As SqlCommand = New SqlCommand("sp_OffTR_GetAdditionalInfo", objConnection1)
        With objAddInfoCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@strLithoCode", SqlDbType.VarChar, 10).Value = mstrLithoCode
        End With

        'Build the questionform insert command
        objConnection2.Open()
        Dim objQFInsertCommand As SqlCommand = New SqlCommand("sp_OffTR_QuestionFormInsert")
        With objQFInsertCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Connection = objConnection2
            .Parameters.Add("@strLithoCode", SqlDbType.VarChar, 10).Value = mstrLithoCode
        End With

        'Populate the additional info dataset
        objDataAdapter.SelectCommand = objAddInfoCommand
        Dim objDataSet As DataSet = New DataSet
        objDataAdapter.Fill(objDataSet)
        objDataSet.Tables(0).PrimaryKey = New DataColumn() {objDataSet.Tables(0).Columns("SentMail_id")}    '** Added 10/21/03 JJF

        'Populate the properties
        With objDataSet.Tables(0)
            If .Rows.Count > 0 Then
                'Determine if we have a questionform record
                If IsDBNull(.Rows(0).Item("QuestionForm_id")) Then
                    'Insert the QuestionForm record
                    objQFInsertCommand.ExecuteNonQuery()

                    'Repopulate the additional info dataset
                    'objDataSet = New DataSet   '** Removed 10/21/03
                    objDataAdapter.Fill(objDataSet)
                End If

                'We found the record so store the values
                mintSentMailID = IIf(IsDBNull(.Rows(0).Item("SentMail_id")), -1, .Rows(0).Item("SentMail_id"))
                mintQuestionFormID = IIf(IsDBNull(.Rows(0).Item("QuestionForm_id")), -1, .Rows(0).Item("QuestionForm_id"))
                mintStudyID = IIf(IsDBNull(.Rows(0).Item("Study_id")), -1, .Rows(0).Item("Study_id"))
                mintSurveyID = IIf(IsDBNull(.Rows(0).Item("Survey_id")), -1, .Rows(0).Item("Survey_id"))
                mintSamplePopID = IIf(IsDBNull(.Rows(0).Item("SamplePop_id")), -1, .Rows(0).Item("SamplePop_id"))
                mintSampleSetID = IIf(IsDBNull(.Rows(0).Item("SampleSet_id")), -1, .Rows(0).Item("SampleSet_id"))
                mintPopID = IIf(IsDBNull(.Rows(0).Item("Pop_id")), -1, .Rows(0).Item("Pop_id"))
                mdatResultsImported = IIf(IsDBNull(.Rows(0).Item("datResultsImported")), Date.MinValue, .Rows(0).Item("datResultsImported"))
                mbolAlreadyExists = (Not IsDBNull(.Rows(0).Item("datResultsImported")))
            Else
                'No record was found so store the error defaults
                mintSentMailID = -1
                mintQuestionFormID = -1
                mintStudyID = -1
                mintSurveyID = -1
                mintSamplePopID = -1
                mintSampleSetID = -1
                mintPopID = -1
                mdatResultsImported = Date.MinValue
                mbolAlreadyExists = False
            End If
        End With

        'Cleanup
        objConnection1.Close()
        objConnection2.Close()

    End Sub

    Public Sub AddQuestion(ByVal strColumnName As String, ByVal objValue As Object)

        Dim intCnt As Integer
        Dim intQstnCore As Integer
        Dim bolMultiResponse As Boolean
        Dim bolFound As Boolean
        Dim strPopField As String = ""

        'Determine if this is a question
        If IsQuestion(strColumnName:=strColumnName, intQstnCore:=intQstnCore, bolMultiResponse:=bolMultiResponse) Then
            'Determine if we already have this question
            If bolMultiResponse Then
                bolFound = False
                For intCnt = 0 To mobjQuestions.Count - 1
                    If mobjQuestions.Item(intCnt).QstnCore = intQstnCore Then
                        mobjQuestions.Item(intCnt).AddValue(objValue)
                        bolFound = True
                        Exit For
                    End If
                Next
            Else
                bolFound = False
            End If

            'If we have not found the question then add it
            If Not bolFound Then
                Dim objQuestion As clsQuestion = New clsQuestion(intQstnCore:=intQstnCore, _
                                                                 intQuestionFormID:=mintQuestionFormID, _
                                                                 bolMultiResponse:=bolMultiResponse)
                objQuestion.AddValue(objValue)
                mobjQuestions.Add(objQuestion)
            End If
        End If

        'Determine if this is being mapped to a population field
        If IsMapped(strColumnName:=strColumnName, strPopField:=strPopField) Then
            Dim strValue As String
            Try
                strValue = CStr(objValue)
            Catch
                strValue = ""
            End Try
            Dim objPopValue As clsPopValue = New clsPopValue(strSourceField:=strColumnName, _
                                                             strPopField:=strPopField, _
                                                             strValue:=strValue)
            mobjPopValues.Add(objPopValue)
        End If

    End Sub

    Private Function IsQuestion(ByVal strColumnName As String, ByRef intQstnCore As Integer, _
                                ByRef bolMultiResponse As Boolean) As Boolean

        If strColumnName.ToUpper.StartsWith("Q") Then
            'This might be a question
            If IsNumeric(strColumnName.Substring(1)) Then
                'This is a question
                intQstnCore = Val(strColumnName.Substring(1))
                bolMultiResponse = False
                Return True
            ElseIf IsNumeric(strColumnName.Substring(1, strColumnName.Length - 2)) Then
                'This is a multiple response question
                intQstnCore = Val(strColumnName.Substring(1, strColumnName.Length - 2))
                bolMultiResponse = True
                Return True
            Else
                Return False
            End If
        Else
            Return False
        End If

    End Function

    Private Function IsMapped(ByVal strColumnName As String, ByRef strPopField As String) As Boolean

        Dim objPopMap As clsPopMap

        'Check to see if this source field is mapped
        For Each objPopMap In Globals.gobjPopMaps
            If objPopMap.SourceField = strColumnName Then
                strPopField = objPopMap.PopField
                Return True
            End If
        Next

        'If we made it here then we did not find it
        strPopField = ""
        Return False

    End Function

    '** Modified 01-05-05 JJF
    'Public Function InvalidSampleUnitsExist() As Boolean   '** Modified 01-06-05 JJF
    Public Function InvalidSampleUnitsExist(ByRef strErrMsg As String) As Boolean

        Dim bolFoundInvalid As Boolean
        Dim objQuestion As clsQuestion
        'Dim intCnt As Integer
        Dim strMissing As String = ""       '** Added 01-06-05 JJF
        Dim strMultiple As String = ""      '** Added 01-06-05 JJF

        'Optimistic initialization
        bolFoundInvalid = False
        strErrMsg = ""                      '** Added 01-06-05 JJF

        'Check all of the questions
        For Each objQuestion In mobjQuestions
            With objQuestion
                '** Modified 01-06-05 JJF
                'If .SampleUnitID = gkintSampleUnitMissing Or _
                '   .SampleUnitID = Globals.gkintSampleUnitMultiple Then
                '    'This one is bad so we are out of here
                '    bolFoundInvalid = True
                '    Exit For
                'End If
                If .SampleUnitID = Globals.gkintSampleUnitMissing Then
                    'This one is missing so add it to the list
                    bolFoundInvalid = True
                    strMissing &= IIf(strMissing.Length = 0, "", ",") & .QstnCore.ToString
                ElseIf .SampleUnitID = Globals.gkintSampleUnitMultiple Then
                    'This one has multiple sampleunits so add it to the list
                    bolFoundInvalid = True
                    strMultiple &= IIf(strMultiple.Length = 0, "", ",") & .QstnCore.ToString
                End If
                '** End of modification 01-06-05 JJF
            End With
        Next objQuestion

        'Build the error string if required
        If strMissing.Length > 0 Then
            strErrMsg = "The following QstnCores do not exist for this LithoCode in QualiSys: " & strMissing
        End If
        If strMultiple.Length > 0 Then
            If strErrMsg.Length > 0 Then strErrMsg &= " and "
            strErrMsg &= "The following QstnCores appear to be assigned to more than one SampleUnit for this LithoCode in QualiSys: " & strMultiple
        End If

        'Cleanup
        Return bolFoundInvalid

    End Function

    Public Function OtherStepImported() As Boolean

        Dim bolReturn As Boolean

        'Get the connection string
        'Dim strConn As String = GetSQLConnectString(strApplication:="OfflineTransferResults")
        Dim strConn As String = Config.QP_ProdConnection

        'Open the connection
        Dim objConnection As SqlConnection = New SqlConnection(strConn)
        objConnection.Open()

        'Build the command
        Dim objCommand As SqlCommand = New SqlCommand("sp_OffTR_OtherStepImported", objConnection)
        With objCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int).Value = mintQuestionFormID
        End With

        'Populate the data reader
        Dim objReader As SqlDataReader = objCommand.ExecuteReader

        'Populate the recently used array
        objReader.Read()
        If objReader("QtyRec") > 0 Then
            bolReturn = True
        Else
            bolReturn = False
        End If

        'Cleanup
        objReader.Close()
        objConnection.Close()

        'Return the value
        Return bolReturn

    End Function

    Public Sub ResetForImport(ByRef objConnection As SqlConnection, ByRef objTransaction As SqlTransaction)

        'Build the reset command
        Dim objCommand As SqlCommand = New SqlCommand("sp_OffTR_ResetForImport", objConnection)
        With objCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Transaction = objTransaction
            .Parameters.Add("@intSentMailID", SqlDbType.Int).Value = mintSentMailID
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int).Value = mintQuestionFormID
        End With

        'Execute the query
        objCommand.ExecuteNonQuery()

    End Sub

    Public Function ImportedSameDay() As Boolean

        If mdatResultsImported.Month = Date.Now.Month And _
           mdatResultsImported.Day = Date.Now.Day And _
           mdatResultsImported.Year = Date.Now.Year Then
            Return True
        Else
            Return False
        End If

    End Function

    Public Sub AddToTOCL(ByRef objConnection As SqlConnection, ByRef objTransaction As SqlTransaction)

        'Build the TOCL command
        Dim objCommand As SqlCommand = New SqlCommand("sp_OffTR_AddToTOCL", objConnection)
        With objCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Transaction = objTransaction
            .Parameters.Add("@intStudyID", SqlDbType.Int).Value = mintStudyID
            .Parameters.Add("@intPopID", SqlDbType.Int).Value = mintPopID
        End With

        'Execute the query
        objCommand.ExecuteNonQuery()

    End Sub

    Public ReadOnly Property LithoCode() As String
        Get
            Return mstrLithoCode
        End Get
    End Property

    Public ReadOnly Property SentMailID() As Integer
        Get
            Return mintSentMailID
        End Get
    End Property

    Public ReadOnly Property QuestionFormID() As Integer
        Get
            Return mintQuestionFormID
        End Get
    End Property

    Public ReadOnly Property StudyID() As Integer
        Get
            Return mintStudyID
        End Get
    End Property

    Public ReadOnly Property SurveyID() As Integer
        Get
            Return mintSurveyID
        End Get
    End Property

    Public ReadOnly Property SamplePopID() As Integer
        Get
            Return mintSamplePopID
        End Get
    End Property

    Public ReadOnly Property SampleSetID() As Integer
        Get
            Return mintSampleSetID
        End Get
    End Property

    Public ReadOnly Property PopID() As Integer
        Get
            Return mintPopID
        End Get
    End Property

    Public ReadOnly Property AlreadyExists() As Boolean
        Get
            Return mbolAlreadyExists
        End Get
    End Property

    Public ReadOnly Property Questions() As ArrayList
        Get
            Return mobjQuestions
        End Get
    End Property

    Public ReadOnly Property PopValues() As ArrayList
        Get
            Return mobjPopValues
        End Get
    End Property

    Public ReadOnly Property DateReturned() As Date
        Get
            Return mdatDateReturned
        End Get
    End Property

    Public Property ErrorString() As String
        Get
            Return mstrErrorString
        End Get
        Set(ByVal Value As String)
            mstrErrorString = Value
        End Set
    End Property
End Class
