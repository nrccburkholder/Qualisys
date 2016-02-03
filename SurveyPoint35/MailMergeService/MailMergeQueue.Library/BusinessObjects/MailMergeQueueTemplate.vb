Imports PS.Framework.BusinessLogic
Imports System.IO
Imports System.Xml
Imports Aspose.Words
Imports Microsoft.Office.Interop

#Region " Key Interface "
Public Interface IMailMergeQueueTemplate
    Property MailMergeQueueTemplateID() As Integer
End Interface
#End Region
#Region " Customer Class "
Public Class MailMergeQueueTemplate
    Inherits BusinessBase(Of MailMergeQueueTemplate)
    Implements IMailMergeQueueTemplate
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeQueueTemplateID As Integer
    Private mMailMergeQueueID As Integer
    Private mFileName As String = String.Empty
    Private mFileExtension As String = String.Empty
    Private mFilePath As String = String.Empty
    Private mNetworkpath As String = String.Empty
    Private mRecordedTemplateID As Integer
    Private mFileTemplateID As Integer
    Private mCoverStepOrSurvey As String = String.Empty
    Private mSimplexOrDuplex As String = String.Empty
    Private mPaperSizeType As String = String.Empty
    Private mRecordedPaperConfigID As Integer
    Private mFilePaperConfigID As Integer
    Private mDocOrder As Integer
    Private mFullPath As String = String.Empty
    Private mInstanceCreateDate As DateTime = Now
    Private mValidationMessages As New Validation.ObjectValidations()
    Private Const CLASSNAME As String = "MailMergeQueueTemplate"
#End Region
#Region " Properties "
    Public Property MailMergeQueueTemplateID() As Integer Implements IMailMergeQueueTemplate.MailMergeQueueTemplateID
        Get
            Return Me.mMailMergeQueueTemplateID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeQueueTemplateID = value
        End Set
    End Property
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
    Public Sub New(ByVal queueID As Integer, ByVal fullPath As String, ByVal networkPath As String, ByVal templateID As Integer, ByVal paperConfigID As Integer, ByVal instanceCreateDate As DateTime)
        Me.mMailMergeQueueID = queueID
        Me.mFullPath = fullPath
        Me.mRecordedTemplateID = templateID
        Me.mRecordedPaperConfigID = paperConfigID
        Me.mNetworkpath = networkPath
        Me.mInstanceCreateDate = instanceCreateDate
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewMailMergeQueueTemplate(ByVal queueID As Integer, ByVal fullPath As String, ByVal networkPath As String, _
                        ByVal templateID As Integer, ByVal paperConfigID As Integer, ByVal instanceCreateDate As DateTime) As MailMergeQueueTemplate
        Return New MailMergeQueueTemplate(queueID, fullPath, networkPath, templateID, paperConfigID, instanceCreateDate)
    End Function
#End Region
#Region " Overrides "
    Protected Overrides Sub Delete()
        Throw (New NotImplementedException("Delete method has not be implemented."))
        'MailMergeQueueTemplateProvider.Instance.DeleteMailMergeQueueTemplate(Me.mMailMergeQueueTemplateID)
    End Sub
    Protected Overrides Sub Insert()
        Throw (New NotImplementedException("Insert method has not be implemented."))
        'Me.mMailMergeQueueTemplateID = MailMergeQueueTemplateProvider.Instance.InsertMailMergeQueueTemplate(Me)
    End Sub
    Protected Overrides Sub Update()
        Throw (New NotImplementedException("Update method has not be implemented."))
        'MailMergeQueueTemplateProvider.Instance.UpdateMailMergeQueueTemplate(Me)
    End Sub
#End Region
#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()
        'This object with do object level validation rather than property based.
    End Sub
    Public Function Validate() As Validation.ObjectValidations
        ValidateTemplate()
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                "Validate", "", "Template " & Me.mFileName & " has been validated."))
        End If
        Return Me.mValidationMessages
    End Function
    Private Sub ValidateTemplate()
        If Me.mNetworkpath.Length <= 0 Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "ValidateTemplate", "", "Network Template Path does not exist."))
        End If
        If Me.mFullPath.Length <= 0 OrElse Not File.Exists(Me.mFullPath) Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "ValidateTemplate", "", "Template Path does not exist."))
        Else
            Dim fi As New FileInfo(Me.mFullPath)
            Me.mFileExtension = fi.Extension.ToLower()
            Me.mFilePath = fi.DirectoryName
            Me.mFileName = fi.Name
            ParseTemplateName()
            If Not Me.mValidationMessages.ErrorsExist Then
                CompareTemplateToRecorded()
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "ValidateTemplate", "", Me.mFileName & " has been validated."))
            End If
        End If
    End Sub
    Private Sub CompareTemplateToRecorded()
        If Me.mFilePaperConfigID = 0 OrElse Me.mFilePaperConfigID <> Me.mRecordedPaperConfigID Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "CompareTemplateToRecorded", "", "Recorded paper config id does not match file paper config id."))
        End If
        If Me.mFileTemplateID = 0 OrElse Me.mFileTemplateID <> Me.mRecordedTemplateID Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "CompareTemplateToRecorded", "", "Recorded templateID does not match file template id."))
        End If
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                            "CompareTemplateToRecorded", "", "Template data compared to Survey Data"))
        End If
    End Sub
    Private Sub ParseTemplateName()
        Try
            Me.mFileTemplateID = CInt(Me.mFileName.Substring(3, 5))
            Me.mFilePaperConfigID = CInt(Me.mFileName.Substring(17, 2))
            mCoverStepOrSurvey = Me.mFileName.Substring(9, 2)
            mSimplexOrDuplex = Me.mFileName.Substring(14, 2)
            mPaperSizeType = Me.mFileName.Substring(20, 3)
            Me.mDocOrder = CInt(Me.mFileName.Substring(24, 2))
            If Me.mSimplexOrDuplex <> "SN" AndAlso Me.mSimplexOrDuplex <> "DL" AndAlso Me.mSimplexOrDuplex <> "DS" Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "ParseTemplateName", "", "Invalid Simplex or duplex type."))
            End If
            If Me.mCoverStepOrSurvey <> "01" AndAlso Me.mCoverStepOrSurvey <> "02" AndAlso Me.mCoverStepOrSurvey <> "03" AndAlso Me.mCoverStepOrSurvey <> "SV" Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "ParseTemplateName", "", "Invalid cover or survey step."))
            End If
            If Me.mPaperSizeType <> "LTR" AndAlso Me.mPaperSizeType <> "TBL" Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "ParseTemplateName", "", "Invalid Paper Size type."))
            End If
            If Not Me.mValidationMessages.ErrorsExist Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "ParseTemplateName", "", "Template Name as been parsed."))
            End If
        Catch ex As System.Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "ParseTemplateName", ex.StackTrace, ex.Message))
        End Try
    End Sub
#End Region
#Region " Execution Methods "
    Friend Function PrintDoc(ByVal dt As DataTable, ByVal subJobNumber As Integer) As Validation.ObjectValidations
        Dim currentSubJobIndex As Integer = subJobNumber + 1
        SetPrinterSettings()
        Dim docPath As String = Me.mFullPath
        Dim printPath As String = CommonMethods.AppendLastSlash(Config.TempPrintPath) & GetPrintFileName(currentSubJobIndex)
        Dim savePrintPath As String = CommonMethods.AppendLastSlash(Config.PrintPath) & GetPrintFileName(currentSubJobIndex)
        Dim saveDocPath As String = CommonMethods.AppendLastSlash(Me.mFilePath) & GetDocFileName(currentSubJobIndex)
        'InsertSavedDocMMFile(saveDocPath)
        InsertSavedPrintMMFile(savePrintPath)
        SaveSubJob(dt, currentSubJobIndex)
        If Me.mRecordedPaperConfigID = 23 Then
            dt = PivotDataTable(dt)
        End If
        Dim doc As Document
        doc = New Document(docPath)
        doc.MailMerge.Execute(dt)
        doc.Save(saveDocPath)
        doc = Nothing
        CreatePrintFile(printPath, saveDocPath)
        If Not Me.mValidationMessages.ErrorsExist Then
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "PrintDoc", "", "Print doc method was successful."))
        End If
        Return Me.mValidationMessages
    End Function
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
            If pivotIndex Mod 4 = 0 OrElse counter = dt.Rows.Count - 1 Then
                retVal.Rows.Add(dr)
                retVal.AcceptChanges()
                pivotIndex = 0
                If counter <> dt.Rows.Count - 1 Then
                    dr = retVal.NewRow()
                End If
            End If
            pivotIndex += 1
        Next
        Return retVal        
    End Function
    Private Sub CreatePrintFile(ByVal printPath As String, ByVal saveDocPath As String)
        Dim mWordApp As Word.Application = Nothing
        Dim wrdDoc As Word.Document = Nothing
        Try
            mWordApp = CType(CreateObject("Word.Application"), Word.Application)
            mWordApp.DisplayAlerts = Word.WdAlertLevel.wdAlertsNone
            mWordApp.Visible = False
            mWordApp.Options.SaveInterval = 0
            'Check if it is merge main document
            wrdDoc = mWordApp.Documents.Open(saveDocPath, ReadOnly:=True)
            'Allow time to open document.
            Threading.Thread.Sleep(2500)
            wrdDoc.PrintOut(PrintToFile:=True, _
                            OutputFileName:=printPath, _
                            Background:=False, _
                            Range:=Word.WdPrintOutRange.wdPrintAllDocument, _
                            Item:=Word.WdPrintOutItem.wdPrintDocumentContent, _
                            Copies:=1, _
                            Pages:="", _
                            PageType:=Word.WdPrintOutPages.wdPrintAllPages, _
                            ManualDuplexPrint:=False, _
                            Collate:=True, _
                            PrintZoomColumn:=0, _
                            PrintZoomRow:=0, _
                            PrintZoomPaperWidth:=0, _
                            PrintZoomPaperHeight:=0, _
                            Append:=False)
            If Not File.Exists(printPath) Then
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "CreatePrintFile", "", printPath & " did not successfully print."))
            Else
                If CommonMethods.FileSize(printPath) = 0 Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                                            "CreatePrintFile", "", printPath & " did not successfully print."))
                Else
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Informational, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                        "CreatePrintFile", "", printPath & " successfully printed."))
                End If
            End If
            
        Catch ex As Exception
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, CommonMethods.VTToString(ValidationTypes.Template), CLASSNAME, _
                                    "CreatePrintFile", ex.StackTrace, ex.Message))
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
    Private Sub SetPrinterSettings()
        Dim myPrinter As Printer = Printer.GetPrinter
        If myPrinter.IsInstalled AndAlso myPrinter.IsDefaultPrinter Then
            Dim duplex As Printer.PrintDuplex
            Select Case Me.mSimplexOrDuplex
                Case "SN"
                    duplex = Printer.PrintDuplex.Simplex
                Case "DL"
                    duplex = Printer.PrintDuplex.Vertical
                Case "DS"
                    duplex = Printer.PrintDuplex.Horizontal
                Case Else
                    duplex = Printer.PrintDuplex.Simplex
            End Select
            Try
                If Not WinApiPrinterSettings.SetPrinterDuplex(myPrinter.PrinterName, duplex) Then
                    Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, "Template", CLASSNAME, _
                                            "SetPrinterSettings", "", myPrinter.PrinterName & " Unable to set duplex setting for this printer."))
                End If
            Catch ex As Exception
                Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, "Template", CLASSNAME, _
                                            "SetPrinterSettings", ex.StackTrace, myPrinter.PrinterName & " " & ex.Message))
            End Try
        Else
            Me.mValidationMessages.Add(New Validation.ObjectValidation(MessageTypes.Error, "Template", CLASSNAME, _
                                        "SetPrinterSettings", "", myPrinter.PrinterName & " Printer is not installed or is not the default printer."))
        End If
    End Sub
    Private Sub SaveSubJob(ByVal dt As DataTable, ByVal subJobIndex As Integer)
        Dim totalRecords As Integer = dt.Rows.Count
        Dim startRespID As Integer = CInt(dt.Rows(0)("RESPONDENT_ID"))
        Dim endRespID As Integer = CInt(dt.Rows(dt.Rows.Count - 1)("RESPONDENT_ID"))
        Dim startSeq As Integer = CInt(dt.Rows(0)("ORDINAL"))
        Dim endSeq As Integer = CInt(dt.Rows(dt.Rows.Count - 1)("ORDINAL"))
        MailMergeQueueTemplateProvider.Instance.InsertMMSubJob(Me.mMailMergeQueueID, subJobIndex, totalRecords, startSeq, endSeq, startRespID, endRespID)
    End Sub
    Friend Function InsertTemplateMMFile() As Integer
        'Insert tne Network path.        
        Return MailMergeQueueTemplateProvider.Instance.InsertMMFile(Me.mMailMergeQueueID, FileTypes.TemplateFile, CommonMethods.AppendLastSlash(Me.mNetworkpath) & Me.mFileName)
    End Function
    Private Function InsertSavedDocMMFile(ByVal filePath As String) As Integer
        'This is taking up too much disk space, remove for now.
        Return 0
        'Return MailMergeQueueTemplateProvider.Instance.InsertMMFile(Me.mMailMergeQueueID, FileTypes.DocFile, filePath)
    End Function
    Private Function InsertSavedPrintMMFile(ByVal filePath As String) As Integer
        Return MailMergeQueueTemplateProvider.Instance.InsertMMFile(Me.mMailMergeQueueID, FileTypes.PrintFile, filePath)
    End Function
#End Region
#Region " Helper Methods "
    Private Function GetPrintFileName(ByVal index As Integer) As String
        Dim retVal As String
        Dim ordinal As Integer
        If IsNumeric(Me.mCoverStepOrSurvey) Then 'This is a cover letter.
            ordinal = 1
        Else
            'This is a survey Page.
            ordinal = Me.mDocOrder + 1
        End If
        retVal = String.Format("GHS_{0:D5}_{1}_PVEND_{2:yyyyMMdd}_{3:HHmm}_{4}_{5}_{6:D3}_{7:D2}.prn", _
                               Me.mFileTemplateID, Me.mMailMergeQueueID, Me.mInstanceCreateDate, Me.mInstanceCreateDate, Me.mFilePaperConfigID, Me.mPaperSizeType, index, ordinal)

        Return retVal
    End Function
    Private Function GetDocFileName(ByVal index As Integer) As String
        Dim retVal As String
        Dim ordinal As Integer
        If IsNumeric(Me.mCoverStepOrSurvey) Then 'This is a cover letter.
            ordinal = 1
        Else
            'This is a survey Page.
            ordinal = Me.mDocOrder + 1
        End If
        retVal = String.Format("GHS_{0:D5}_{1}_PVEND_{2:yyyyMMdd}_{3:HHmm}_{4}_{5}_{6:D3}_{7:D2}.doc", _
                               Me.mFileTemplateID, Me.mMailMergeQueueID, Me.mInstanceCreateDate, Me.mInstanceCreateDate, Me.mFilePaperConfigID, Me.mPaperSizeType, index, ordinal)

        Return retVal
    End Function    
#End Region
End Class
#End Region

#Region " Customers Collection Class "
Public Class MailMergeQueueTemplates
    Inherits BusinessListBase(Of MailMergeQueueTemplate)

End Class
#End Region

#Region " Data Base Class "
Public MustInherit Class MailMergeQueueTemplateProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeQueueTemplateProvider
    Private Const mProviderName As String = "MailMergeQueueTemplateProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeQueueTemplateProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeQueueTemplateProvider)(mProviderName)
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
    Public MustOverride Function InsertMMFile(ByVal queueID As Integer, ByVal fileType As FileTypes, ByVal fileName As String) As Integer
    Public MustOverride Function InsertMMSubJob(ByVal queueID As Integer, ByVal subJobIndex As Integer, ByVal totalRecs As Integer, ByVal startSeqNumber As Integer, ByVal endSeqNumber As Integer, _
                                                ByVal startRespID As Integer, ByVal endRespID As Integer) As Integer
#End Region
End Class
#End Region
