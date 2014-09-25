Imports Nrc.QualiSys.Library
Imports NRC.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration
Imports System.IO
Imports System.Data

Public Interface ISurveyDataLoad

    Property SurveyDataLoadId() As Integer

End Interface

<Serializable()> _
Public Class SurveyDataLoad
	Inherits BusinessBase(Of SurveyDataLoad)
	Implements ISurveyDataLoad

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mSurveyDataLoadId As Integer
    Private mDataLoadId As Integer
    Private mSurveyId As Integer
    Private mDateCreated As Date
    Private mNotes As String = String.Empty
    Private mHasErrors As Boolean

    Private mLithoCodes As LithoCodeCollection

    Private mSurvey As Survey
    Private mParentDataLoad As DataLoad

#End Region

#Region " Public Properties "

    Public Property SurveyDataLoadId() As Integer Implements ISurveyDataLoad.SurveyDataLoadId
        Get
            Return mSurveyDataLoadId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mSurveyDataLoadId Then
                mSurveyDataLoadId = value
                PropertyHasChanged("SurveyDataLoadId")
            End If
        End Set
    End Property

    Public Property DataLoadId() As Integer
        Get
            Return mDataLoadId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDataLoadId Then
                mDataLoadId = value
                PropertyHasChanged("DataLoadId")
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
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

    Public Property Notes() As String
        Get
            Return mNotes
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mNotes Then
                mNotes = value
                PropertyHasChanged("Notes")
            End If
        End Set
    End Property

    Public Property HasErrors() As Boolean
        Get
            Return mHasErrors
        End Get
        Set(ByVal value As Boolean)
            If Not value = mHasErrors Then
                mHasErrors = value
                PropertyHasChanged("HasErrors")
            End If
        End Set
    End Property

    Public ReadOnly Property LithoCodes() As LithoCodeCollection
        Get
            If mLithoCodes Is Nothing Then
                mLithoCodes = LithoCode.GetBySurveyDataLoadId(mSurveyDataLoadId)
            End If

            Return mLithoCodes
        End Get
    End Property

    Public ReadOnly Property Survey() As Survey
        Get
            If mSurvey Is Nothing Then
                mSurvey = Survey.Get(mSurveyId)
            End If

            Return mSurvey
        End Get
    End Property

#End Region

#Region " Friend Properties "

    Friend ReadOnly Property ParentDataLoad() As DataLoad
        Get
            If mParentDataLoad Is Nothing Then
                mParentDataLoad = DataLoad.Get(mDataLoadId)
            End If

            Return mParentDataLoad
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewSurveyDataLoad() As SurveyDataLoad

        Return New SurveyDataLoad

    End Function

    Public Shared Function [Get](ByVal surveyDataLoadId As Integer) As SurveyDataLoad

        Return SurveyDataLoadProvider.Instance.SelectSurveyDataLoad(surveyDataLoadId)

    End Function

    Public Shared Function GetByDataLoadId(ByVal dataLoadId As Integer) As SurveyDataLoadCollection

        Return SurveyDataLoadProvider.Instance.SelectSurveyDataLoadsByDataLoadId(dataLoadId)

    End Function

    Public Shared Function GetValidationDataBySampleSet(ByVal sampleSetId As Integer) As DataSet

        Return SurveyDataLoadProvider.Instance.SelectValidationDataBySampleSet(sampleSetId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mSurveyDataLoadId
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

        SurveyDataLoadId = SurveyDataLoadProvider.Instance.InsertSurveyDataLoad(Me)

    End Sub

    Protected Overrides Sub Update()

        SurveyDataLoadProvider.Instance.UpdateSurveyDataLoad(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        SurveyDataLoadProvider.Instance.DeleteSurveyDataLoad(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub ValidateAndSave(ByVal userName As String)

        Dim questionTable As DataTable = Nothing
        Dim commentTable As DataTable = Nothing
        Dim handTable As DataTable = Nothing
        Dim popMappingTable As DataTable = Nothing
        Dim scaleTable As DataTable = Nothing
        Dim validateSampleSets As New Dictionary(Of Integer, DataSet)

        'Set the file name for the file that will hold all of the comments that go to FAQSS
        Dim commentFileName As String = Path.Combine(AppConfig.Params("QSIFAQSSCommentDataFileFolder").StringValue, String.Format("{0}_{1}_{2}.cmt", Format(Now(), "yyMMdd"), mDataLoadId, SurveyId))
        Dim qtyCommentRowsInFile As Integer = 0

        'Get the receipt types for validating the response type (TranslationCode)
        Dim receiptTypes As QualiSys.Library.ReceiptTypeCollection = QualiSys.Library.ReceiptType.GetAll

        'Get the Vendor Dispositions for validating the disposition codes
        Dim vendorDispos As VendorDispositionCollection = VendorDisposition.GetByVendorId(ParentDataLoad.VendorId)

        'Get the Vendor's No Response character
        Dim noResponseChar As String = ParentDataLoad.ParentVendor.NoResponseChar.ToUpper
        Dim dontKnowResponseChar As String = ParentDataLoad.ParentVendor.DontKnowResponseChar.ToUpper
        Dim refusedResponseChar As String = ParentDataLoad.ParentVendor.RefusedResponseChar.ToUpper
        Dim skipResponseChar As String = ParentDataLoad.ParentVendor.SkipResponseChar.ToUpper
        Dim multiRespItemNotPickedChar As String = ParentDataLoad.ParentVendor.MultiRespItemNotPickedChar.ToUpper

        'Check for SurveyID mismatch condition
        Dim surveyMismatch As Boolean = False
        For Each litho As LithoCode In LithoCodes
            If litho.SurveyId <> SurveyId Then
                'We found one mismatch so every litho gets marked
                surveyMismatch = True
                Exit For
            End If
        Next

        'Validate all of the LithoCode objects
        For Each litho As LithoCode In LithoCodes
            'Get the validation data
            If Not validateSampleSets.ContainsKey(litho.SampleSetId) Then
                validateSampleSets.Add(litho.SampleSetId, GetValidationDataBySampleSet(litho.SampleSetId))
            End If
            questionTable = validateSampleSets.Item(litho.SampleSetId).Tables(0)
            commentTable = validateSampleSets.Item(litho.SampleSetId).Tables(1)
            handTable = validateSampleSets.Item(litho.SampleSetId).Tables(2)
            scaleTable = validateSampleSets.Item(litho.SampleSetId).Tables(3)
            popMappingTable = validateSampleSets.Item(litho.SampleSetId).Tables(4)

            'Save the ReceiptType of this litho
            Dim lithoInterface As ILithoCode = litho
            lithoInterface.ReceiptType = receiptTypes.GetByTranslationCode(litho.ResponseType)

            'Save the LangId of this litho
            If litho.SurveyLang.HasValue Then
                lithoInterface.LangID = CInt(litho.SurveyLang)
            End If

            'Validate this LithoCode object
            If surveyMismatch Then
                'This is a SurveyID mismatch
                litho.ErrorId = TransferErrorCodes.SurveyIdMismatch
            ElseIf litho.ReceiptType Is Nothing Then
                'Invalid response type specified
                litho.ErrorId = TransferErrorCodes.ResponseTypeInvalid
            ElseIf litho.Dispositions.Count = 0 Then
                'No dispositions were provided for this litho code
                litho.ErrorId = TransferErrorCodes.NoDispositionsProvided
            ElseIf litho.Dispositions.FinalDispositionCount > 1 Then
                'More than one final disposition was provided
                litho.ErrorId = TransferErrorCodes.MoreThanOneFinalDispostion
            Else
                'No errors were encountered
                litho.ErrorId = TransferErrorCodes.None
            End If

            'Check to see if we already have results for this litho
            litho.SkipDuplicate = (litho.ResultsImported > Date.MinValue OrElse litho.UnusedReturnId > UnusedReturnCodes.None)

            'Check to see if we should ignore this litho
            litho.Ignore = (litho.OtherStepImported OrElse litho.DateExpired < Date.Now)

            'Save the LithoCode object
            If litho.IsNew Then litho.SurveyDataLoadId = SurveyDataLoadId
            If litho.IsNew OrElse litho.IsDirty Then litho.Save()

            'Validate all of the Disposition objects for this LithoCode
            For Each dispo As Disposition In litho.Dispositions
                'Save the VendorDispo of the disposition
                Dim dispoInterface As IDisposition = dispo
                dispoInterface.VendorDispo = vendorDispos.GetByVendorDispositionCode(dispo.VendorDispositionCode, dispo.IsFinal)

                'Validate this disposition
                If dispo.VendorDispo Is Nothing Then
                    'This is an invalid disposition code
                    dispo.ErrorId = TransferErrorCodes.Disposition
                ElseIf dispo.DispositionDate = Date.MinValue Then
                    'This is an invalid date
                    dispo.ErrorId = TransferErrorCodes.DateValidation
                Else
                    'No errors were encountered
                    dispo.ErrorId = TransferErrorCodes.None
                End If

                'Save this Disposition object
                If dispo.IsNew Then dispo.LithoCodeId = litho.LithoCodeId
                If dispo.IsNew OrElse dispo.IsDirty Then dispo.Save()
            Next

            'Validate all of the QuestionResult objects for this LithoCode
            Dim qstns As DataRow()
            Dim scale As DataRow()
            For Each result As QuestionResult In litho.QuestionResults
                'Select the question from the validation table
                qstns = questionTable.Select(String.Format("QuestionForm_id = {0} AND QstnCore = {1}", litho.QuestionFormId, result.QstnCore))
                If qstns.GetLength(0) = 0 Then
                    'This question was not found for this litho
                    If String.IsNullOrEmpty(result.ResponseVal) Then
                        'The question was not found and does not have a value so we do not want to save this one
                        result.ResponseVal = String.Empty
                        result.ErrorId = TransferErrorCodes.IgnoreQstnCore
                    Else
                        'The question was not found and we have a response so this is an error
                        result.ErrorId = TransferErrorCodes.ExtraQstnCore
                    End If
                Else
                    'Save the SampleUnitID for the result
                    Dim resultInterface As IQuestionResult = result
                    resultInterface.SampleUnitID = CInt(qstns(0).Item("SampleUnit_id"))

                    'Validate this response
                    If Not String.IsNullOrEmpty(result.ResponseVal) Then
                        'Select the scale from the validation table
                        scale = scaleTable.Select(String.Format("ScaleID = {0} AND Val = '{1}'", qstns(0).Item("ScaleID"), result.ResponseVal))
                        If result.ResponseVal.ToUpper = noResponseChar.PadLeft(result.ResponseVal.Length, CChar(noResponseChar)) OrElse _
                           result.ResponseVal.ToUpper = skipResponseChar.PadLeft(result.ResponseVal.Length, CChar(skipResponseChar)) OrElse _
                           result.ResponseVal.ToUpper = dontKnowResponseChar.PadLeft(result.ResponseVal.Length, CChar(dontKnowResponseChar)) OrElse _
                           result.ResponseVal.ToUpper = refusedResponseChar.PadLeft(result.ResponseVal.Length, CChar(refusedResponseChar)) OrElse _
                           result.ResponseVal.ToUpper = multiRespItemNotPickedChar.PadLeft(result.ResponseVal.Length, CChar(multiRespItemNotPickedChar)) Then
                            'The response is considered a valid response
                            result.ErrorId = TransferErrorCodes.None

                            'Set to just the first character if there are more than one
                            If result.ResponseVal.Length > 1 Then
                                result.ResponseVal = result.ResponseVal.Substring(0, 1).ToUpper
                            End If
                        ElseIf scale.GetLength(0) = 0 Then
                            'The scale value was not found for this question
                            result.ErrorId = TransferErrorCodes.Scale
                        Else
                            'No errors were encountered
                            result.ErrorId = TransferErrorCodes.None
                        End If
                    Else
                        'We have a null or empty response so decide what to do with it
                        If result.MultipleResponse Then
                            'This is a multiple response question so we need to set this to the multiRespItemNotPickedChar
                            result.ResponseVal = multiRespItemNotPickedChar
                            result.ErrorId = TransferErrorCodes.None
                        Else
                            'This is a single response question so replace the null/empty with -9
                            result.ResponseVal = "-9"
                            result.ErrorId = TransferErrorCodes.None
                        End If
                    End If
                End If

                'Save the QuestionResult object
                If result.IsNew Then result.LithoCodeId = litho.LithoCodeId
                If result.ErrorId <> TransferErrorCodes.IgnoreQstnCore Then
                    If result.IsNew OrElse result.IsDirty Then result.Save()
                End If
            Next

            'Save all of the valid comment QstnCores for this LithoCode
            Dim cmntQstnCores As DataRow() = commentTable.Select(String.Format("QuestionForm_id = {0}", litho.QuestionFormId))
            For cnt As Integer = 0 To cmntQstnCores.GetUpperBound(0)
                litho.AddCommentQstnCore(CInt(cmntQstnCores(cnt).Item("QstnCore")), cmntQstnCores(cnt).Item("Label").ToString.Trim)
            Next

            'Validate all of the Comment objects for this LithoCode
            Dim cmnts As DataRow()
            For Each cmnt As Comment In litho.Comments
                'Select the comment from the validation table
                cmnts = commentTable.Select(String.Format("QuestionForm_id = {0} AND QstnCore = {1}", litho.QuestionFormId, cmnt.CmntNumber))
                If cmnts.GetLength(0) = 0 Then
                    'This comment was not found for this litho
                    cmnt.ErrorId = TransferErrorCodes.ExtraQstnCore
                ElseIf cmnt.CmntText.Length > 12000 Then
                    'This comment exceeds the maximum allowable length
                    cmnt.ErrorId = TransferErrorCodes.CommentLengthExceeded
                Else
                    'No errors were encountered
                    cmnt.ErrorId = TransferErrorCodes.None
                End If

                'Save the Comment object
                If cmnt.IsNew Then cmnt.LithoCodeId = litho.LithoCodeId
                If cmnt.IsNew OrElse cmnt.IsDirty Then cmnt.Save()
            Next

            'Validate all of the HandEntry objects for this LithoCode
            Dim handsQstnCore As DataRow()
            Dim handsItem As DataRow()
            Dim handsLine As DataRow()
            For Each hand As HandEntry In litho.HandEntries
                'Select the hand entry from the validation table by QuestionFormID, QstnCore
                handsQstnCore = handTable.Select(String.Format("QuestionForm_id = {0} AND QstnCore = {1}", litho.QuestionFormId, hand.QstnCore))

                'Select the hand entry from the validation table adding Item
                handsItem = handTable.Select(String.Format("QuestionForm_id = {0} AND QstnCore = {1} AND Item = {2}", litho.QuestionFormId, hand.QstnCore, hand.ItemNumber))

                'Select the hand entry from the validation table adding Line
                handsLine = handTable.Select(String.Format("QuestionForm_id = {0} AND QstnCore = {1} AND Item = {2} AND Line_id = {3}", litho.QuestionFormId, hand.QstnCore, hand.ItemNumber, hand.LineNumber))

                'Validate
                If handsQstnCore.GetLength(0) = 0 Then
                    'This hand entry question was not found for this litho
                    hand.ErrorId = TransferErrorCodes.ExtraQstnCore
                ElseIf handsItem.GetLength(0) = 0 Then
                    'This hand entry question's Item number was not found
                    hand.ErrorId = TransferErrorCodes.HandEntryInvalidItem
                ElseIf handsLine.GetLength(0) = 0 Then
                    'This hand entry question/Item combination has an invalid line number
                    hand.ErrorId = TransferErrorCodes.HandEntryInvalidLine
                Else
                    'Save the population table field name
                    Dim handInterface As IHandEntry = hand
                    handInterface.FieldName = handsLine(0).Item("strField_Nm").ToString

                    'Validate the hand entry value
                    Dim testInt As Integer
                    If handsLine(0).Item("strFieldDataType").ToString = "I" Then
                        If Integer.TryParse(hand.HandEntryText, testInt) Then
                            hand.ErrorId = TransferErrorCodes.None
                        Else
                            hand.ErrorId = TransferErrorCodes.HandEntryInvalidInteger
                        End If
                    ElseIf handsLine(0).Item("strFieldDataType").ToString = "D" Then
                        If IsDate(hand.HandEntryText) Then
                            hand.ErrorId = TransferErrorCodes.None
                        Else
                            hand.ErrorId = TransferErrorCodes.HandEntryInvalidDate
                        End If
                    Else
                        If hand.HandEntryText.Length > CInt(handsQstnCore(0).Item("intFieldLength")) Then
                            hand.ErrorId = TransferErrorCodes.HandEntryLengthExceeded
                        Else
                            hand.ErrorId = TransferErrorCodes.None
                        End If
                    End If
                End If

                'Save the HandEntry object
                If hand.IsNew Then hand.LithoCodeId = litho.LithoCodeId
                If hand.IsNew OrElse hand.IsDirty Then hand.Save()
            Next

            'Validate all of the PopMapping objects for this LithoCode
            Dim pops As DataRow()
            For Each pop As PopMapping In litho.PopMappings
                'Select the pop mapping from the validation table
                pops = popMappingTable.Select(String.Format("Survey_id = {0} AND QstnCore = {1}", litho.SurveyId, pop.QstnCore))
                If pops.GetLength(0) = 0 Then
                    'This pop mapping was not found for this litho
                    pop.ErrorId = TransferErrorCodes.ExtraQstnCore
                Else
                    'Save the population table field name
                    Dim popInterface As IPopMapping = pop
                    popInterface.FieldName = pops(0).Item("strField_Nm").ToString

                    'Validate the pop mapping value
                    Dim testInt As Integer
                    If pops(0).Item("strFieldDataType").ToString = "I" Then
                        If Integer.TryParse(pop.PopMappingText, testInt) Then
                            pop.ErrorId = TransferErrorCodes.None
                        Else
                            pop.ErrorId = TransferErrorCodes.PopMappingInvalidInteger
                        End If
                    ElseIf pops(0).Item("strFieldDataType").ToString = "D" Then
                        If IsDate(pop.PopMappingText) Then
                            pop.ErrorId = TransferErrorCodes.None
                        Else
                            pop.ErrorId = TransferErrorCodes.PopMappingInvalidDate
                        End If
                    Else
                        If pop.PopMappingText.Length > CInt(pops(0).Item("intFieldLength")) Then
                            pop.ErrorId = TransferErrorCodes.PopMappingLengthExceeded
                        Else
                            pop.ErrorId = TransferErrorCodes.None
                        End If
                    End If
                End If

                'Save the Comment object
                If pop.IsNew Then pop.LithoCodeId = litho.LithoCodeId
                If pop.IsNew OrElse pop.IsDirty Then pop.Save()
            Next

            'Save everything for this litho to QualiSys.  The comments must be written as a single batch.
            litho.SaveToQualiSys(userName, commentFileName, qtyCommentRowsInFile, noResponseChar, skipResponseChar, dontKnowResponseChar, refusedResponseChar)
        Next

        'Determine if any comments were written to the file
        If qtyCommentRowsInFile = 0 Then
            Dim dataFile As New FileInfo(commentFileName)
            If dataFile.Exists Then dataFile.Delete()
        End If

        'Update the HasErrors property
        HasErrors = (DistinctLithoCountWithErrors() > 0)
        Save()

    End Sub

    Public Function LithoErrorCount() As Integer

        Return LithoCodes.ErrorCount

    End Function

    Public Function DispositionErrorCount() As Integer

        Dim count As Integer

        For Each litho As LithoCode In LithoCodes
            count += litho.Dispositions.ErrorCount
        Next

        Return count

    End Function

    Public Function QuestionResultErrorCount() As Integer

        Dim count As Integer

        For Each litho As LithoCode In LithoCodes
            count += litho.QuestionResults.ErrorCount
        Next

        Return count

    End Function

    Public Function CommentErrorCount() As Integer

        Dim count As Integer

        For Each litho As LithoCode In LithoCodes
            count += litho.Comments.ErrorCount
        Next

        Return count

    End Function

    Public Function HandEntryErrorCount() As Integer

        Dim count As Integer

        For Each litho As LithoCode In LithoCodes
            count += litho.HandEntries.ErrorCount
        Next

        Return count

    End Function

    Public Function PopMappingErrorCount() As Integer

        Dim count As Integer

        For Each litho As LithoCode In LithoCodes
            count += litho.PopMappings.ErrorCount
        Next

        Return count

    End Function

    Public Function DistinctLithoCountWithErrors() As Integer

        Dim count As Integer = 0

        For Each litho As LithoCode In LithoCodes
            If litho.ErrorId <> TransferErrorCodes.None OrElse litho.Dispositions.HasErrors OrElse litho.QuestionResults.HasErrors OrElse litho.Comments.HasErrors OrElse _
               litho.HandEntries.HasErrors OrElse litho.PopMappings.HasErrors Then
                count += 1
            End If
        Next

        Return count

    End Function

    Public Function TotalErrorCount() As Integer

        Return LithoErrorCount() + DispositionErrorCount() + QuestionResultErrorCount() + CommentErrorCount() + HandEntryErrorCount() + PopMappingErrorCount()

    End Function

#End Region

End Class


