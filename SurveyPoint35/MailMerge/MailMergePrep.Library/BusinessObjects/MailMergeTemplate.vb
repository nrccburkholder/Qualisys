Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO
Imports Microsoft.Office.Interop
Imports System.Text
Imports Aspose.Words

#Region " Key Interface "
Public Interface IMailMergeTemplate
    Property MailMergeTemplateID() As Integer
End Interface
#End Region
#Region " MailMergeTemplate Class "
Public Class MailMergeTemplate
    Inherits BusinessBase(Of MailMergeTemplate)
    Implements IMailMergeTemplate

#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeTemplateID As Integer
    Private mTemplatePathAndName As String = String.Empty
    Private mFileExtension As String = String.Empty
    Private mFileName As String = String.Empty
    Private mFilePath As String = String.Empty
    Private mMailStep As String = String.Empty
    Private mPrintCommonSurvey As Boolean = False
    Private mFileTemplateID As Integer
    Private mDuplexPrint As String = String.Empty
    'TODO:  Make an Enum
    Private mPaperConfigID As Integer
    Private mPaperSizeCode As String = String.Empty
    Private mPaperSizeID As Integer
    Private mSheetNumber As Integer
    Private mDataSchema As DataTable
    'TODO:  Add TEMPLATEID.
    Private Const CLASSNAME As String = "MailMergeTemplate"
    Private mLoaded As Boolean = False
    Private mValidated As Boolean = False
    Private mValidationMessages As Validation.ObjectValidations = New Validation.ObjectValidations

#End Region

#Region " Properties "
    Public Property MailMergeTemplateID() As Integer Implements IMailMergeTemplate.MailMergeTemplateID
        Get
            Return Me.mMailMergeTemplateID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeTemplateID = value
        End Set
    End Property
    Public ReadOnly Property FileTemplateID() As Integer
        Get
            Return Me.mFileTemplateID
        End Get
    End Property
    Public Property TemplatePathAndName() As String
        Get
            Return Me.mTemplatePathAndName
        End Get
        Set(ByVal value As String)
            If Not (Me.mTemplatePathAndName = value) Then
                Me.mTemplatePathAndName = value
                ReSet()
                PropertyHasChanged("TemplatePathAndName")
            End If
        End Set
    End Property
    Public ReadOnly Property Loaded() As Boolean
        Get
            Return Me.mLoaded
        End Get
    End Property
    Public ReadOnly Property Validated() As Boolean
        Get
            Return Me.mValidated
        End Get
    End Property
    Public ReadOnly Property ValidationMessages() As Validation.ObjectValidations
        Get
            Return Me.mValidationMessages
        End Get
    End Property
    Public ReadOnly Property FileName() As String
        Get
            Return Me.mFileName
        End Get
    End Property
    Public ReadOnly Property FilePath() As String
        Get
            Return Me.mFilePath
        End Get
    End Property
    Public ReadOnly Property FileExt() As String
        Get
            Return Me.mFileExtension
        End Get
    End Property
    Public ReadOnly Property PaperConfigID() As Integer
        Get
            Return Me.mPaperConfigID
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
    Public Sub New(ByVal templatePathAndName As String)
        Me.mTemplatePathAndName = templatePathAndName
    End Sub
#End Region

#Region " Factory Calls "
    Public Shared Function NewMailMergeTemplate() As MailMergeTemplate
        Return New MailMergeTemplate
    End Function
    Public Shared Function NewMailMergeTemplate(ByVal templatePathAndName As String) As MailMergeTemplate
        Return New MailMergeTemplate(templatePathAndName)
    End Function
#End Region

#Region " Overrides "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException()
    End Sub
    Protected Overrides Sub Insert()
        Throw New NotImplementedException()
    End Sub
    Protected Overrides Sub Update()
        Throw New NotImplementedException()
    End Sub
#End Region

#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()
        'This object with do object level validation rather than property based.
    End Sub

    Public Function Validate(ByVal dataSchema As DataTable) As Validation.ObjectValidations
        If Me.mLoaded Then
            Me.mDataSchema = dataSchema
            CheckMergeFields()
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, "Validate", _
                            "", "Mail Merge Template Object must be loaded prior to validation."))
        End If
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidated = True
        End If
        Return Me.mValidationMessages
    End Function
    Private Function GetMergeFieldName(ByVal field As String) As String
        Dim beginPos As Integer
        Dim endPos As Integer

        'e.g.
        '   { MERGEFIELD "PageBarcode1" }
        '   { MERGEFIELD PageBarcode1 }
        '   { MERGEFIELD   "PageBarcode1" }

        field = field.ToUpper
        ' --------------------------------------------
        ' Find begin position
        ' --------------------------------------------
        'Skip "MERGEFIELD"
        beginPos = field.IndexOf("MERGEFIELD") + "MERGEFIELD".Length

        'Skip spaces
        Do While field.Substring(beginPos, 1) = " "
            beginPos += 1
        Loop

        'Skip quote
        If (field.Substring(beginPos, 1) = """") Then beginPos += 1

        ' --------------------------------------------
        ' Find end position
        ' --------------------------------------------
        endPos = field.Length - 1

        'Skip spaces
        Do While field.Substring(endPos, 1) = " "
            endPos -= 1
        Loop

        'Skip quote
        If (field.Substring(endPos, 1) = """") Then endPos -= 1

        Return field.Substring(beginPos, endPos - beginPos + 1)
    End Function
    Private Sub CheckMergeFields()
        Dim mWordApp As Word.Application = Nothing
        Dim wrdDoc As Word.Document = Nothing
        Dim missingMergeField As Boolean = False
        Dim mergeFieldsExist As Boolean = False
        Dim missingMergeText As New StringBuilder()
        Try
            mWordApp = CType(CreateObject("Word.Application"), Word.Application)
            mWordApp.DisplayAlerts = Word.WdAlertLevel.wdAlertsNone
            mWordApp.Visible = False
            mWordApp.Options.SaveInterval = 0
            'Check if it is merge main document
            wrdDoc = mWordApp.Documents.Open(Me.mTemplatePathAndName, ReadOnly:=True)
            'Allow time to open document.
            Threading.Thread.Sleep(2500)
            'Search all the fields in body, header and footer to find all the merge fields
            Dim wdField As Word.Field
            'Check in Word body
            For Each wdField In wrdDoc.Fields
                If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                    mergeFieldsExist = True
                    Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                    If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                        missingMergeField = True
                        missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                    End If
                End If
                wdField = Nothing
            Next
            'Check in text boxes
            For Each shape As Word.Shape In wrdDoc.Shapes
                If (shape.Type = Microsoft.Office.Core.MsoShapeType.msoTextBox) Then
                    For Each wdField In shape.TextFrame.TextRange.Fields
                        If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                            mergeFieldsExist = True
                            Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                            If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                missingMergeField = True
                                missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                            End If
                        End If
                        wdField = Nothing
                    Next
                End If
                shape = Nothing
            Next
            'Check header and footer in all the sections
            For i As Integer = 1 To wrdDoc.Sections.Count
                With wrdDoc.Sections.Item(i)
                    'Check in Word header
                    For Each wdField In .Headers.Item(Word.WdHeaderFooterIndex.wdHeaderFooterPrimary).Range.Fields
                        If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                            mergeFieldsExist = True
                            Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                            If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                missingMergeField = True
                                missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                            End If
                        End If
                        wdField = Nothing
                    Next
                    'Check in Word footer
                    For Each wdField In .Footers.Item(Word.WdHeaderFooterIndex.wdHeaderFooterPrimary).Range.Fields
                        If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                            mergeFieldsExist = True
                            Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                            If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                missingMergeField = True
                                missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                            End If
                        End If
                        wdField = Nothing
                    Next
                    'If headers and footers are different on odd and even page, check header and footer on even page
                    If (.PageSetup.OddAndEvenPagesHeaderFooter <> 0) Then
                        'Check in Word header
                        For Each wdField In .Headers.Item(Word.WdHeaderFooterIndex.wdHeaderFooterEvenPages).Range.Fields
                            If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                                mergeFieldsExist = True
                                Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                                If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                    missingMergeField = True
                                    missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                                End If
                            End If
                            wdField = Nothing
                        Next
                        'Check in Word footer
                        For Each wdField In .Footers.Item(Word.WdHeaderFooterIndex.wdHeaderFooterEvenPages).Range.Fields
                            If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                                mergeFieldsExist = True
                                Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                                If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                    missingMergeField = True
                                    missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                                End If
                            End If
                            wdField = Nothing
                        Next
                    End If
                    'If headers and footers are different on first page, check header and footer on first page
                    If (.PageSetup.DifferentFirstPageHeaderFooter <> 0) Then
                        'Check in Word header
                        For Each wdField In .Headers.Item(Word.WdHeaderFooterIndex.wdHeaderFooterFirstPage).Range.Fields
                            If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                                mergeFieldsExist = True
                                Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                                If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                    missingMergeField = True
                                    missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                                End If
                            End If
                            wdField = Nothing
                        Next
                        'Check in Word footer
                        For Each wdField In .Footers.Item(Word.WdHeaderFooterIndex.wdHeaderFooterEvenPages).Range.Fields
                            If (wdField.Type = Word.WdFieldType.wdFieldMergeField) Then
                                mergeFieldsExist = True
                                Dim fieldName As String = CleanWordFieldName(GetMergeFieldName(wdField.Code.Text))
                                If Not Me.mDataSchema.Columns.Contains(fieldName) Then
                                    missingMergeField = True
                                    missingMergeText.Append(fieldName & " does not exist in the data file.  ")
                                End If
                            End If
                            wdField = Nothing
                        Next
                    End If
                End With
            Next
            If Not mergeFieldsExist Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                            "CheckMergeFields", "", "No merge fields were found for " & Me.mFileName))
            End If
            If missingMergeField Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                            "CheckMergeFields", "", "Missing Merge Fields: " & missingMergeText.ToString()))
            End If
            If mergeFieldsExist AndAlso Not missingMergeField Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "CheckMergeFields", "", "All merge fields exist in data file for: " & Me.mFileName))
            End If

        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "CheckMergeFields", ex.StackTrace, ex.Message))
        Finally
            If (Not wrdDoc Is Nothing) Then
                wrdDoc.Close(SaveChanges:=False)
                Threading.Thread.Sleep(2500)
                wrdDoc = Nothing
            End If
            If mWordApp IsNot Nothing Then
                mWordApp.Quit()
                mWordApp = Nothing
            End If
        End Try

    End Sub
#End Region

#Region " Execution Methods "
    Public Function Load() As Validation.ObjectValidations
        If Me.Loaded Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Warning, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, "Load", "", "Template Object has already been loaded."))
        Else
            ValidateTemplateFilePath()
            If Not Me.mValidationMessages.ErrorsExist Then
                ParseTemplateFileString()
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mLoaded = True
            End If
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, "Load", "", "Template was successfully loaded."))
        End If
        Return Me.mValidationMessages
    End Function
    Friend Function GeneratePreview(ByVal dt As DataTable, ByVal path As String) As Validation.ObjectValidation
        Try
            If Me.Validated Then
                Dim dtSmall As DataTable = dt.Clone
                Dim tempCounter As Integer = 4
                If dt.Rows.Count <= tempCounter Then
                    tempCounter = dt.Rows.Count - 1
                End If
                For i As Integer = 0 To tempCounter
                    dtSmall.LoadDataRow(dt(i).ItemArray(), True)
                Next
                If Me.mPaperConfigID = 23 Then
                    dtSmall = PivotDataTable(dtSmall)
                End If
                Dim doc As Document
                doc = New Document(Me.mTemplatePathAndName)
                doc.MailMerge.Execute(dtSmall)
                doc.Save(CommonMethods.AppendLastSlash(path) & "Preview_" & Me.mFileName)
                doc = Nothing
                Return New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                      "GeneratePreview", "", CommonMethods.AppendLastSlash(path) & "Preview_" & Me.mFileName)
            Else
                Return New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                      "GeneratePreview", "", "The Template object must first be validated.")
            End If
        Catch ex As Exception
            Return New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                  "GeneratePreview", ex.StackTrace, ex.Message)
        End Try
    End Function
#End Region

#Region " Helper Methods "
    Private Function PivotDataTable(ByVal dt As DataTable) As DataTable
        Dim retVal As New DataTable
        retVal = dt.Clone
        Dim colList As New List(Of String)
        For i As Integer = 0 To retVal.Columns.Count - 1
            colList.Add(retVal.Columns(i).ColumnName)
            retVal.Columns(i).ColumnName = retVal.Columns(i).ColumnName & "_1"
        Next
        For j As Integer = 2 To 4
            For k As Integer = 0 To colList.Count - 1
                retVal.Columns.Add(New DataColumn(colList(k) & "_" & j))
            Next
        Next
        Dim dr As DataRow = retVal.NewRow()
        Dim pivotIndex As Integer = 1
        For counter As Integer = 0 To dt.Rows.Count - 1
            For colIndex = 0 To dt.Columns.Count - 1
                dr(dt.Columns(colIndex).ColumnName & "_" & pivotIndex) = dt.Rows(counter)(colIndex)
            Next
            pivotIndex += 1
            If counter <> 0 AndAlso counter Mod 3 = 0 Then
                retVal.Rows.Add(dr)
                retVal.AcceptChanges()
                pivotIndex = 1
                If counter <> dt.Rows.Count - 1 Then
                    dr = retVal.NewRow
                Else
                    retVal.Rows.Add(dr)
                    retVal.AcceptChanges()
                End If
            End If
        Next        
        Return retVal
    End Function
    Friend Sub ReSet()
        Me.mLoaded = False
        Me.mValidated = False
    End Sub
    Public Sub ParseTemplateFileString()
        Dim fi As New FileInfo(Me.mTemplatePathAndName)
        Me.mFileName = fi.Name
        Me.mFilePath = fi.DirectoryName
        Me.mFileExtension = fi.Extension.ToLower()
        If Not (fi.Exists) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", Me.mFileName & " does not exist."))
            Exit Sub
        End If
        If Me.mFileName.Length <> 30 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", Me.mFileName & " does not equal 30 characters."))
            Exit Sub
        End If
        If Me.mFileExtension <> ".doc" Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", Me.mFileName & " contains an invalid file extension."))
            Exit Sub
        End If
        Me.mMailStep = Me.mFileName.Substring(9, 2).ToUpper
        If Me.mMailStep <> "01" AndAlso Me.mMailStep <> "02" AndAlso Me.mMailStep <> "03" AndAlso Me.mMailStep <> "SV" Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", Me.mFileName & " has an unrecognized mail step of " & Me.mMailStep))
            Exit Sub
        End If
        Me.mFileTemplateID = CInt(Me.mFileName.Substring(3, 5))
        Me.mPrintCommonSurvey = (Me.mFileName.Substring(12, 1).ToUpper = "Y")
        Me.mDuplexPrint = Me.mFileName.Substring(14, 2).ToUpper
        'TODO:  DataProvider.Instance.IsPrinterTermExist(mDuplexPrint) MainDocument.vb
        If Not IsNumeric(Me.mFileName.Substring(17, 2)) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", "Paper Config ID is not numeric for " & Me.mFileName))
            Exit Sub
        End If
        Me.mPaperConfigID = CInt(Me.mFileName.Substring(17, 2))
        'TODO:  DataProvider.Instance.IsPaperConfigExist(mPaperConfigID) MailDocument.vb
        Me.mPaperSizeCode = Me.mFileName.Substring(20, 3).ToUpper
        'TODO:  mPaperSizeID = DataProvider.Instance.SelectPaperSizeID(mPaperSizeCode) MainDocument.vb
        If Not IsNumeric(Me.mFileName.Substring(24, 2)) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", "Sheet Number is not numeric for " & Me.mFileName))
            Exit Sub
        End If
        Me.mSheetNumber = CInt(Me.mFileName.Substring(24, 2))
        Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                        "ParseTemplateFileString", "", "Template File Name was successfully parsed."))
    End Sub
    ''' <summary>
    ''' Postcards (config 23) has their data pivoted.  Therefore merge fields are postfixed with an _#
    ''' which denotes the actual record to use.  This removes that when checking the fields agains the
    ''' data file prior to it being pivoted.
    ''' </summary>
    ''' <param name="item"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function CleanWordFieldName(ByVal item As String) As String
        Dim retVal As String = item
        If Me.mPaperConfigID = 23 Then
            If retVal.Length > 2 Then
                retVal = retVal.Substring(0, (retVal.Length - 2))
            End If
        End If
        Return retVal
    End Function
    Public Sub ValidateTemplateFilePath()
        If Me.mTemplatePathAndName.Length = 0 OrElse Not File.Exists(Me.mTemplatePathAndName) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), _
                                                      CLASSNAME, "ValidateTemplateFilePath", _
                                                      "", "A Template file needs to be set prior to loading a MailMergeTemplate."))
        End If
    End Sub
#End Region
End Class
#End Region


#Region " MailMergeTemplate Collection Class "
Public Class MailMergeTemplates
    Inherits BusinessListBase(Of MailMergeTemplate)

End Class
#End Region


#Region " Data Base Class "
Public MustInherit Class MailMergeTemplateProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeTemplateProvider
    Private Const mProviderName As String = "MailMergeTemplateProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeTemplateProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeTemplateProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region " Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "

#End Region
End Class
#End Region
