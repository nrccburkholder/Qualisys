Imports NRC.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration
Imports System.IO
Imports System.Data.Common

Public Interface ILithoCode

    Property LithoCodeId() As Integer
    Property SentMailId() As Integer
    Property QuestionFormId() As Integer
    Property StudyId() As Integer
    Property SurveyId() As Integer
    Property SamplePopId() As Integer
    Property SampleSetId() As Integer
    Property PopId() As Integer
    Property LangID() As Integer
    Property ResultsImported() As Date
    Property Returned() As Date
    Property UnusedReturnId() As UnusedReturnCodes
    Property OtherStepImported() As Boolean
    Property DateExpired() As Date
    Property ReceiptType() As QualiSys.Library.ReceiptType
    Property SurveyName() As String
    Property ClientName() As String

End Interface

<Serializable()> _
Public Class LithoCode
	Inherits BusinessBase(Of LithoCode)
	Implements ILithoCode

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mLithoCodeId As Integer
    Private mSurveyDataLoadId As Integer
    Private mErrorId As TransferErrorCodes = TransferErrorCodes.None
    Private mResponseType As String = String.Empty
    Private mLithoCode As String = String.Empty
    Private mSurveyLang As Nullable(Of Integer)
    Private mIgnore As Boolean
    Private mSubmitted As Boolean
    Private mExtracted As Boolean
    Private mSkipDuplicate As Boolean
    Private mDispositionUpdate As Boolean
    Private mDateCreated As Date

    Private mSentMailId As Integer
    Private mQuestionFormId As Integer
    Private mStudyId As Integer
    Private mSurveyId As Integer
    Private mSamplePopId As Integer
    Private mSampleSetId As Integer
    Private mPopId As Integer
    Private mLangID As Integer
    Private mResultsImported As Date
    Private mReturned As Date
    Private mUnusedReturnId As UnusedReturnCodes = UnusedReturnCodes.None
    Private mOtherStepImported As Boolean
    Private mDateExpired As Date
    Private mReceiptType As QualiSys.Library.ReceiptType
    Private mSurveyName As String = String.Empty
    Private mClientName As String = String.Empty
    Private mCommentQstnCores As New Dictionary(Of Integer, String)

    Private mQuestionResults As QuestionResultCollection
    Private mComments As CommentCollection
    Private mHandEntries As HandEntryCollection
    Private mPopMappings As PopMappingCollection
    Private mDispositions As DispositionCollection

    Private Const mkCommentQstnCoreOffset As Integer = 500000

#End Region

#Region " Public Properties "

    Public Property LithoCodeId() As Integer Implements ILithoCode.LithoCodeId
        Get
            Return mLithoCodeId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mLithoCodeId Then
                mLithoCodeId = value
                PropertyHasChanged("LithoCodeId")
            End If
        End Set
    End Property

    Public Property SurveyDataLoadId() As Integer
        Get
            Return mSurveyDataLoadId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyDataLoadId Then
                mSurveyDataLoadId = value
                PropertyHasChanged("SurveyDataLoadId")
            End If
        End Set
    End Property

    Public Property ErrorId() As TransferErrorCodes
        Get
            Return mErrorId
        End Get
        Set(ByVal value As TransferErrorCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

    Public Property ResponseType() As String
        Get
            Return mResponseType
        End Get
        Set(ByVal value As String)
            If Not value = mResponseType Then
                mResponseType = value
                PropertyHasChanged("ResponseType")
            End If
        End Set
    End Property

    Public Property SurveyLang() As Nullable(Of Integer)
        Get
            Return mSurveyLang
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mSurveyLang = value
            PropertyHasChanged("SurveyLang")
        End Set
    End Property

    Public Property LithoCode() As String
        Get
            Return mLithoCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLithoCode Then
                mLithoCode = value
                PropertyHasChanged("LithoCode")
            End If
        End Set
    End Property

    Public Property Ignore() As Boolean
        Get
            Return mIgnore
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIgnore Then
                mIgnore = value
                PropertyHasChanged("Ignore")
            End If
        End Set
    End Property

    Public Property Submitted() As Boolean
        Get
            Return mSubmitted
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSubmitted Then
                mSubmitted = value
                PropertyHasChanged("Submitted")
            End If
        End Set
    End Property

    Public Property Extracted() As Boolean
        Get
            Return mExtracted
        End Get
        Set(ByVal value As Boolean)
            If Not value = mExtracted Then
                mExtracted = value
                PropertyHasChanged("Extracted")
            End If
        End Set
    End Property

    Public Property SkipDuplicate() As Boolean
        Get
            Return mSkipDuplicate
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSkipDuplicate Then
                mSkipDuplicate = value
                PropertyHasChanged("SkipDuplicate")
            End If
        End Set
    End Property

    Public Property DispositionUpdate() As Boolean
        Get
            Return mDispositionUpdate
        End Get
        Set(ByVal value As Boolean)
            If Not value = mDispositionUpdate Then
                mDispositionUpdate = value
                PropertyHasChanged("DispositionUpdate")
            End If
        End Set
    End Property

    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property

#End Region

#Region " Public Collection Properties "

    Public ReadOnly Property QuestionResults() As QuestionResultCollection
        Get
            If mQuestionResults Is Nothing Then
                mQuestionResults = QuestionResult.GetByLithoCodeId(mLithoCodeId)
            End If

            Return mQuestionResults
        End Get
    End Property

    Public ReadOnly Property Comments() As CommentCollection
        Get
            If mComments Is Nothing Then
                mComments = Comment.GetByLithoCodeId(mLithoCodeId)
            End If

            Return mComments
        End Get
    End Property

    Public ReadOnly Property HandEntries() As HandEntryCollection
        Get
            If mHandEntries Is Nothing Then
                mHandEntries = HandEntry.GetByLithoCodeId(mLithoCodeId)
            End If

            Return mHandEntries
        End Get
    End Property

    Public ReadOnly Property PopMappings() As PopMappingCollection
        Get
            If mPopMappings Is Nothing Then
                mPopMappings = PopMapping.GetByLithoCodeId(mLithoCodeId)
            End If

            Return mPopMappings
        End Get
    End Property

    Public ReadOnly Property Dispositions() As DispositionCollection
        Get
            If mDispositions Is Nothing Then
                mDispositions = Disposition.GetByLithoCodeId(mLithoCodeId)
            End If

            Return mDispositions
        End Get
    End Property

#End Region

#Region " ILithocode Lookup Properties "

    Public Property SentMailId() As Integer Implements ILithoCode.SentMailId
        Get
            Return mSentMailId
        End Get
        Private Set(ByVal value As Integer)
            mSentMailId = value
        End Set
    End Property

    Public Property QuestionFormId() As Integer Implements ILithoCode.QuestionFormId
        Get
            Return mQuestionFormId
        End Get
        Private Set(ByVal value As Integer)
            mQuestionFormId = value
        End Set
    End Property

    Public Property StudyId() As Integer Implements ILithoCode.StudyId
        Get
            Return mStudyId
        End Get
        Private Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    Public Property SurveyId() As Integer Implements ILithoCode.SurveyId
        Get
            Return mSurveyId
        End Get
        Private Set(ByVal value As Integer)
            mSurveyId = value
        End Set
    End Property

    Public Property SamplePopId() As Integer Implements ILithoCode.SamplePopId
        Get
            Return mSamplePopId
        End Get
        Private Set(ByVal value As Integer)
            mSamplePopId = value
        End Set
    End Property

    Public Property SampleSetId() As Integer Implements ILithoCode.SampleSetId
        Get
            Return mSampleSetId
        End Get
        Private Set(ByVal value As Integer)
            mSampleSetId = value
        End Set
    End Property

    Public Property PopId() As Integer Implements ILithoCode.PopId
        Get
            Return mPopId
        End Get
        Private Set(ByVal value As Integer)
            mPopId = value
        End Set
    End Property

    Public Property LangId() As Integer Implements ILithoCode.LangID
        Get
            Return mLangID
        End Get
        Private Set(ByVal value As Integer)
            mLangID = value
        End Set
    End Property

    Public Property ResultsImported() As Date Implements ILithoCode.ResultsImported
        Get
            Return mResultsImported
        End Get
        Private Set(ByVal value As Date)
            mResultsImported = value
        End Set
    End Property

    Public Property Returned() As Date Implements ILithoCode.Returned
        Get
            Return mReturned
        End Get
        Private Set(ByVal value As Date)
            mReturned = value
        End Set
    End Property

    Public Property UnusedReturnId() As UnusedReturnCodes Implements ILithoCode.UnusedReturnId
        Get
            Return mUnusedReturnId
        End Get
        Private Set(ByVal value As UnusedReturnCodes)
            mUnusedReturnId = value
        End Set
    End Property

    Public Property OtherStepImported() As Boolean Implements ILithoCode.OtherStepImported
        Get
            Return mOtherStepImported
        End Get
        Private Set(ByVal value As Boolean)
            mOtherStepImported = value
        End Set
    End Property

    Public Property DateExpired() As Date Implements ILithoCode.DateExpired
        Get
            Return mDateExpired
        End Get
        Private Set(ByVal value As Date)
            mDateExpired = value
        End Set
    End Property

    Public Property ReceiptType() As QualiSys.Library.ReceiptType Implements ILithoCode.ReceiptType
        Get
            Return mReceiptType
        End Get
        Private Set(ByVal value As QualiSys.Library.ReceiptType)
            mReceiptType = value
        End Set
    End Property

    Public Property SurveyName() As String Implements ILithoCode.SurveyName
        Get
            Return mSurveyName
        End Get
        Private Set(ByVal value As String)
            mSurveyName = value
        End Set
    End Property

    Public Property ClientName() As String Implements ILithoCode.ClientName
        Get
            Return mClientName
        End Get
        Private Set(ByVal value As String)
            mClientName = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewLithoCode() As LithoCode

        Return New LithoCode

    End Function

    Public Shared Function [Get](ByVal lithoCodeId As Integer) As LithoCode

        Return LithoCodeProvider.Instance.SelectLithoCode(lithoCodeId)

    End Function

    Public Shared Function GetBySurveyDataLoadId(ByVal surveyDataLoadId As Integer) As LithoCodeCollection

        Return LithoCodeProvider.Instance.SelectLithoCodesBySurveyDataLoadId(surveyDataLoadId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mLithoCodeId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        LithoCodeId = LithoCodeProvider.Instance.InsertLithoCode(Me)

    End Sub

    Protected Overrides Sub Update()

        LithoCodeProvider.Instance.UpdateLithoCode(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        LithoCodeProvider.Instance.DeleteLithoCode(Me)

    End Sub

#End Region

#Region " Friend Methods "

    Friend Sub GetAdditionalInfo()

        LithoCodeProvider.Instance.GetAdditionalInfo(Me)

    End Sub

    Friend Sub SaveToQualiSys(ByVal userName As String, ByVal commentFileName As String, ByRef qtyCommentRowsInFile As Integer, ByVal noResponseChar As String, ByVal skipResponseChar As String, ByVal dontKnowResponseChar As String, ByVal refusedResponseChar As String)

        Dim tryInt As Integer

        'If we cannot save to QualiSys then we are out of here
        If Not CanSaveToQualiSys() Then Exit Sub

        Using conn As DbConnection = LithoCodeProvider.Instance.CreateConnection
            'Start a transaction
            Using trans As DbTransaction = conn.BeginTransaction

                'Get the barcode for this LithoCode
                Dim barcode As String = Litho.LithoToBarcode(CInt(mLithoCode), False, 1)
                Dim fullBarcode As String = Litho.LithoToBarcode(CInt(mLithoCode), True, 1)

                'Get a FileInfo for the definition file name
                Dim definitionFile As New FileInfo(Path.Combine(AppConfig.Params("QSIFAQSSCommentDataFileFolder").StringValue, barcode & ".txt"))

                'Get a FileInfo for the comment data file
                Dim dataFile As New FileInfo(commentFileName)

                Try
                    'If we have a final disposition then save everything
                    If Dispositions.DoesFinalExist AndAlso Not IsUndeliverable() Then
                        If DoResultsExist(noResponseChar, dontKnowResponseChar, refusedResponseChar) Then
                            'Save the litho code data
                            LithoCodeProvider.Instance.SaveLithoCodeToQualiSys(Me, trans)

                            'Save the question results
                            For Each result As QuestionResult In QuestionResults
                                If result.ErrorId <> TransferErrorCodes.IgnoreQstnCore AndAlso Not String.IsNullOrEmpty(result.ResponseVal) Then
                                    If Integer.TryParse(result.GetQualiSysResponseValue(noResponseChar, skipResponseChar, dontKnowResponseChar, refusedResponseChar), tryInt) Then
                                        'Only save the result if it is an integer.  We do not save the MultiRespItemNotPickedChar, or Blanks (NULL or Empty String)
                                        LithoCodeProvider.Instance.SaveQuestionResultToQualiSys(QuestionFormId, result.SampleUnitID, result.QstnCore, tryInt, trans)
                                    End If
                                End If
                            Next

                            'Save the hand entries
                            For Each hand As HandEntry In HandEntries
                                LithoCodeProvider.Instance.SaveHandEntryToQualiSys(Me, hand, trans)
                            Next

                            'Save the pop mappings
                            For Each pop As PopMapping In PopMappings
                                LithoCodeProvider.Instance.SavePopMappingToQualiSys(Me, pop, trans)
                            Next

                            'Save the langId data
                            LithoCodeProvider.Instance.SaveLangIdToQualiSys(Me, trans)

                        ElseIf Dispositions.DoesMustHaveResultsExist Then
                            'No results exist and we have a disposition that says we have to have results
                            Throw New MustHaveResultsException()
                        End If
                    End If

                    'Save all of the dispositions
                    For Each dispo As Disposition In Dispositions
                        'Save this disposition
                        LithoCodeProvider.Instance.SaveDispositionToQualiSys(Me, dispo, userName, trans)
                    Next

                    'Save the comments
                    If Comments.Count > 0 Then
                        'Write the comment definition file for this LithoCode
                        Dim definitionStream As StreamWriter = definitionFile.CreateText
                        definitionStream.Write(GetCommentDefinitionFile())
                        definitionStream.Flush()
                        definitionStream.Close()

                        'Build the comment data file row for this LithoCode
                        Dim dataFileRow As String = fullBarcode
                        For Each cmnt As Comment In Comments
                            If AppConfig.Params("QSIIncludeQuestionTextInCMT").IntegerValue = 0 Then
                                'Do not include the question text in the CMT file
                                dataFileRow &= String.Format(",{0},{1}{2}{1}", cmnt.CmntNumber + mkCommentQstnCoreOffset, Chr(34), cmnt.CmntText)
                            Else
                                'Include the question text in the CMT file
                                dataFileRow &= String.Format(",{0},{1}{2}{1},{1}{3}{1}", cmnt.CmntNumber + mkCommentQstnCoreOffset, Chr(34), mCommentQstnCores.Item(cmnt.CmntNumber), cmnt.CmntText)
                            End If
                        Next

                        'Write the row to the comment data file
                        Dim dataStream As StreamWriter = dataFile.AppendText
                        dataStream.WriteLine(dataFileRow)
                        dataStream.Flush()
                        dataStream.Close()
                        qtyCommentRowsInFile += 1
                    End If

                    'If we have made it to hear then commit the transaction
                    trans.Commit()

                    'Set the bitSubmitted for the comments
                    If Comments.Count > 0 Then
                        For Each cmnt As Comment In Comments
                            cmnt.Submitted = True
                            cmnt.Save()
                        Next
                    End If

                    'Set the bitSummited
                    Submitted = True
                    Save()

                Catch ex As Exception
                    'Roll the transaction back
                    If trans IsNot Nothing AndAlso trans.Connection IsNot Nothing Then
                        Try
                            trans.Rollback()
                        Catch ex2 As Exception
                            EventLog.WriteEntry(QSIServiceNames.QSITransferResultsService, Translator.SendNotification(QSIServiceNames.QSITransferResultsService, String.Format("Error encountered, Rollback failure, unable to save LithoCode {0} to QualiSys.", mLithoCode), ex2, False), EventLogEntryType.Error)
                        End Try
                    End If

                    'If this litho had comments clean them up
                    If Comments.Count > 0 Then
                        'Delete the definition file
                        If definitionFile.Exists Then definitionFile.Delete()
                    End If

                    'Mark the litho with an error
                    If TypeOf ex Is MustHaveResultsException Then
                        ErrorId = TransferErrorCodes.DispositionMustHaveResults
                    Else
                        ErrorId = TransferErrorCodes.ErrorSavingToQualiSys
                        EventLog.WriteEntry(QSIServiceNames.QSITransferResultsService, Translator.SendNotification(QSIServiceNames.QSITransferResultsService, String.Format("Error encountered, unable to save LithoCode {0} to QualiSys.", mLithoCode), ex, False), EventLogEntryType.Error)
                    End If
                    Submitted = False
                    Save()

                End Try
            End Using
        End Using
    End Sub

    Friend Function IsValidLithoCode() As Boolean

        Return (mSentMailId > 0 AndAlso mQuestionFormId > 0 AndAlso mStudyId > 0 AndAlso mSurveyId > 0 AndAlso mSamplePopId > 0 AndAlso mSampleSetId > 0 AndAlso mPopId > 0)

    End Function

    Friend Function IsDispositionOnly(ByVal noResponseChar As String, ByVal dontKnowResponseChar As String, ByVal refusedResponseChar As String) As Boolean

        Return (Dispositions.Count > 0 AndAlso QuestionResults.ValidResultCount(noResponseChar, dontKnowResponseChar, refusedResponseChar) = 0 AndAlso Comments.Count = 0 AndAlso HandEntries.Count = 0 AndAlso PopMappings.Count = 0)

    End Function

    Friend Sub AddCommentQstnCore(ByVal qstnCore As Integer, ByVal label As String)

        If Not mCommentQstnCores.ContainsKey(qstnCore) Then
            mCommentQstnCores.Add(qstnCore, label)
        End If

    End Sub

#End Region

#Region "Private Methods"

    Private Function CanSaveToQualiSys() As Boolean

        ' added this code only for debugging purposes to be able to easily see the values.
        Dim isSubmitted As Boolean = Submitted
        Dim isSkipDuplicate As Boolean = SkipDuplicate
        Dim isIgnore As Boolean = Ignore
        Dim isError As Boolean = ErrorId = TransferErrorCodes.None
        Dim isDispostionError As Boolean = Dispositions.HasErrors
        Dim isQuestionResultsError As Boolean = QuestionResults.HasErrors
        Dim isCommentsError As Boolean = Comments.HasErrors
        Dim isHandEntryError As Boolean = HandEntries.HasErrors
        Dim isPopMappingError As Boolean = PopMappings.HasErrors
        Dim isAlreadyFinalDispostion As Boolean = IsAlreadyFinalDisposition()

        Dim result As Boolean
        result = (Not Submitted AndAlso Not SkipDuplicate AndAlso Not Ignore AndAlso ErrorId = TransferErrorCodes.None AndAlso _
                Not Dispositions.HasErrors AndAlso Not QuestionResults.HasErrors AndAlso Not Comments.HasErrors AndAlso _
                Not HandEntries.HasErrors AndAlso Not PopMappings.HasErrors AndAlso Not IsAlreadyFinalDisposition())

        Return (Not Submitted AndAlso Not SkipDuplicate AndAlso Not Ignore AndAlso ErrorId = TransferErrorCodes.None AndAlso _
                Not Dispositions.HasErrors AndAlso Not QuestionResults.HasErrors AndAlso Not Comments.HasErrors AndAlso _
                Not HandEntries.HasErrors AndAlso Not PopMappings.HasErrors AndAlso Not IsAlreadyFinalDisposition())

    End Function

    Private Function IsAlreadyFinalDisposition() As Boolean

        Return (LithoCodeProvider.Instance.SelectLithoCodePrevFinalDispoCount(Me) > 0)

    End Function

    Private Function IsUndeliverable() As Boolean

        For Each dispo As Disposition In Dispositions
            If dispo.VendorDispo.QCLDisposition.Action = QualiSys.Library.DispositionAction.CancelMailings Then
                Return True
            End If
        Next

        Return False

    End Function

    Private Function GetCommentDefinitionFile() As String

        'Get the template code
        Dim templateCode As String = String.Format("{0}X{1}", SurveyId.ToString, LangId.ToString("00"))

        'Get the template name
        Dim templateName As String = String.Format("{0} {1} {2}", templateCode, SurveyName.Trim, ClientName.Trim)
        If templateName.Length > 30 Then templateName = templateName.Substring(0, 30)

        'Add the template line
        Dim defFile As String = String.Format("{0}{1},{2}", "TMP=", templateCode, templateName)
        defFile &= vbCrLf

        'Add all possible comments
        For Each qstnCore As Integer In mCommentQstnCores.Keys
            'Add the comment box definition line
            defFile &= String.Format("BX{0}", qstnCore + mkCommentQstnCoreOffset) & ",1,1,{0,0},{0,0},{0,0},{0,0},NONE" & vbCrLf

            'Add the comment box line definition line
            defFile &= "LN1,{0,0},{0,0},{0,0},{0,0}" & vbCrLf
        Next

        Return defFile

    End Function

    Private Function DoResultsExist(ByVal noResponseChar As String, ByVal dontKnowResponseChar As String, ByVal refusedResponseChar As String) As Boolean

        Return (QuestionResults.HasValidResults(noResponseChar, dontKnowResponseChar, refusedResponseChar) OrElse Comments.Count > 0 OrElse HandEntries.Count > 0 OrElse PopMappings.Count > 0)

    End Function

#End Region

End Class


