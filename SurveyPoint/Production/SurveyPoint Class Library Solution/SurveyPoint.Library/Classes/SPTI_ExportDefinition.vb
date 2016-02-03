Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_ExportDefinition
    Property ExportDefinitionID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_ExportDefinition
    Inherits BusinessBase(Of SPTI_ExportDefinition)
    Implements ISPTI_ExportDefinition

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mExportDefinitionID As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty    
    Private mSourceFileTemplateID As Integer
    Private mExportFileTemplateID As Integer
    Private mSourceFileTemplate As SPTI_FileTemplate = Nothing
    Private mExportFileTemplate As SPTI_FileTemplate = Nothing
    Private mSourceFile As SPTI_ExportDefintionFile = Nothing
    Private mExportFiles As SPTI_ExportDefintionFileCollection = Nothing
    Private mInitNonPropRule As Boolean
    Private mHasHeader As Boolean = False
    Private mFileDeDupRule As String = ""
    Private mSIDeDupStartDate As Integer = 6
    Public Event NewMessage As EventHandler(Of ExportMessageArgs)
    Public Event ExportProgress As EventHandler(Of ExportFileProgress)
#End Region

#Region " Public Properties "
    Public Property ExportDefinitionID() As Integer Implements ISPTI_ExportDefinition.ExportDefinitionID
        Get
            Return mExportDefinitionID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mExportDefinitionID Then
                mExportDefinitionID = value
                PropertyHasChanged("ExportDefinitionID")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property    
    Public Property SourceFileTemplateID() As Integer
        Get
            Return mSourceFileTemplateID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSourceFileTemplateID Then
                mSourceFileTemplateID = value
                Me.mSourceFileTemplate = Nothing
                PropertyHasChanged("SourceFileTemplate")
            End If
        End Set
    End Property
    Public Property ExportFileTemplateID() As Integer
        Get
            Return mExportFileTemplateID
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportFileTemplateID Then
                mExportFileTemplateID = value
                Me.mExportFileTemplate = Nothing
                PropertyHasChanged("ExportFileTemplate")
            End If
        End Set
    End Property
    Public ReadOnly Property SourceFileTemplate() As SPTI_FileTemplate
        Get
            If Me.mSourceFileTemplate Is Nothing Then
                Me.mSourceFileTemplate = SPTI_FileTemplate.Get(Me.SourceFileTemplateID)
            Else
                If Me.mSourceFileTemplate.FileTemplateID <> Me.SourceFileTemplateID Then
                    Me.mSourceFileTemplate = SPTI_FileTemplate.Get(Me.SourceFileTemplateID)
                End If
            End If
            Return Me.mSourceFileTemplate
        End Get
    End Property
    Public ReadOnly Property ExportFileTemplate() As SPTI_FileTemplate
        Get
            If Me.mExportFileTemplate Is Nothing Then
                Me.mExportFileTemplate = SPTI_FileTemplate.Get(Me.mExportFileTemplateID)
            Else
                If Me.mExportFileTemplate.FileTemplateID <> Me.mExportFileTemplateID Then
                    Me.mExportFileTemplate = SPTI_FileTemplate.Get(Me.mExportFileTemplateID)
                End If
            End If
            Return Me.mExportFileTemplate
        End Get
    End Property
    Public Property SourceFile() As SPTI_ExportDefintionFile
        Get            
            If Me.mSourceFile Is Nothing AndAlso Me.mExportDefinitionID > 0 Then
                Me.mSourceFile = SPTI_ExportDefintionFile.GetSourceFileByExportDefinitionID(Me.mExportDefinitionID)
                If Me.mSourceFile Is Nothing Then
                    'Me.mSourceFile = SPTI_ExportDefintionFile.NewSPTI_ExportDefintionFile
                End If
            End If
            Return Me.mSourceFile           
        End Get
        Set(ByVal value As SPTI_ExportDefintionFile)
            Me.mSourceFile = value
            PropertyHasChanged("SourceFile")
        End Set
    End Property
    Public Property ExportFiles() As SPTI_ExportDefintionFileCollection
        Get
            If Me.mExportFiles Is Nothing Then
                Me.mExportFiles = SPTI_ExportDefintionFile.GetExportFileByExportDefinitionID(Me.mExportDefinitionID)
                If Me.mExportFiles Is Nothing Then
                    Me.mExportFiles = New SPTI_ExportDefintionFileCollection
                End If
            End If
            Return Me.mExportFiles
        End Get
        Set(ByVal value As SPTI_ExportDefintionFileCollection)
            Me.mExportFiles = value
            PropertyHasChanged("ExportFiles")
        End Set
    End Property
    Public Property InitNonPropRule() As Boolean
        Get
            Return Me.mInitNonPropRule
        End Get
        Set(ByVal value As Boolean)
            Me.mInitNonPropRule = value
            PropertyHasChanged("InitNonPropRule")
        End Set
    End Property
    Public Property HasHeader() As Boolean
        Get
            Return Me.mHasHeader
        End Get
        Set(ByVal value As Boolean)
            If Not Me.mHasHeader = value Then
                Me.mHasHeader = value
                PropertyHasChanged("HasHeader")
            End If
        End Set
    End Property
    Public Property FileDeDupRule() As String
        Get
            Return Me.mFileDeDupRule
        End Get
        Set(ByVal value As String)
            If Not Me.mFileDeDupRule = value Then
                Me.mFileDeDupRule = value
                PropertyHasChanged("FileDeDupRule")
            End If
        End Set
    End Property
    Public Property SIDeDupStartDate() As Integer
        Get
            Return Me.mSIDeDupStartDate
        End Get
        Set(ByVal value As Integer)
            If Not Me.mSIDeDupStartDate = value Then
                Me.mSIDeDupStartDate = value
                PropertyHasChanged("SIDeDupStartDate")
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
        Me.mDescription = ""        
        Me.mExportDefinitionID = 0
        Me.mSourceFileTemplateID = 0
    End Sub
    Private Sub New(ByVal name As String)
        Me.mName = name
        Me.mDescription = name
        Dim fileTemplates As SPTI_FileTemplateCollection = SPTI_FileTemplate.GetAll()
        Dim fileTemplateID As Integer = fileTemplates(0).FileTemplateID
        Me.SourceFileTemplateID = fileTemplateID
        Me.ExportFileTemplateID = fileTemplateID
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSPTI_ExportDefinition(ByVal name As String) As SPTI_ExportDefinition
        'Creates a valid (default) export file definition.
        Return New SPTI_ExportDefinition(name)
    End Function
    Public Shared Function NewSPTI_ExportDefinition() As SPTI_ExportDefinition
        Return New SPTI_ExportDefinition
    End Function

    Public Shared Function [Get](ByVal exportDefinitionID As Integer) As SPTI_ExportDefinition
        Return DataProviders.SPTI_ExportDefinitionProvider.Instance.SelectSPTI_ExportDefinition(exportDefinitionID)
    End Function

    Public Shared Function GetAll() As SPTI_ExportDefinitionCollection
        Return DataProviders.SPTI_ExportDefinitionProvider.Instance.SelectAllSPTI_ExportDefinitions()
    End Function
    Public Shared Sub DeleteExportDefIncludingChildren(ByVal exportDefinitionID As Integer)
        DataProviders.SPTI_ExportDefinitionProvider.Instance.DeleteExportDefIncludingChildren(exportDefinitionID)
    End Sub
    Public Shared Function CheckExportDefExistsByName(ByVal oldExportDefID As Integer, ByVal newExportDefName As String) As Boolean
        Return DataProviders.SPTI_ExportDefinitionProvider.Instance.CheckExportDefExistsByName(oldExportDefID, newExportDefName)
    End Function
    Public Shared Function CopyExportDefinition(ByVal oldExportDefID As Integer, ByVal newExportDefName As String) As Integer
        Return DataProviders.SPTI_ExportDefinitionProvider.Instance.CopyExportDefinition(oldExportDefID, newExportDefName)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mExportDefinitionID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf CheckNonPropRules, "InitNonPropRule")

    End Sub
    Public Function ValidateAll() As Validation.BrokenRulesCollection
        Me.InitNonPropRule = True
        If Not Me.IsValid Then
            Return Me.BrokenRulesCollection
        End If
        'Validate Source Template
        Dim rules As Validation.BrokenRulesCollection = Nothing
        rules = Me.SourceFileTemplate.ValidateAll
        If Not rules Is Nothing Then
            Return rules
        End If
        'Validate Export Template
        rules = Me.ExportFileTemplate.ValidateAll
        If Not rules Is Nothing Then
            Return rules
        End If
        'Validate Source File
        If Not Me.SourceFile.IsValid Then
            Return Me.SourceFile.BrokenRulesCollection
        End If
        'Validate Export Files
        For Each item As SPTI_ExportDefintionFile In Me.ExportFiles
            If Not item.IsValid Then
                Return item.BrokenRulesCollection
            End If
        Next        
        Return Nothing
    End Function
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        ExportDefinitionID = DataProviders.SPTI_ExportDefinitionProvider.Instance.InsertSPTI_ExportDefinition(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProviders.SPTI_ExportDefinitionProvider.Instance.UpdateSPTI_ExportDefinition(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProviders.SPTI_ExportDefinitionProvider.Instance.DeleteSPTI_ExportDefinition(mExportDefinitionID)
    End Sub

    Public Overrides Sub Save()
        MyBase.Save()
        If Not Me.SourceFile Is Nothing Then
            Me.SourceFile.Save()
        End If
        If Not Me.ExportFiles Is Nothing AndAlso Me.ExportFiles.Count > 0 Then
            Me.ExportFiles.Save()
        End If

    End Sub
#End Region

#Region " Public Methods "    
    Public Function CheckNonPropRules(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.Name = "" Then
            e.Description = "Export Defintion must have a name."
            Return False
        End If
        If Me.Description = "" Then
            e.Description = "Export Definition must have a description."
            Return False
        End If
        'Must be able to save prior to having exportDefFiles.
        'If Me.SourceFile Is Nothing Then
        '    e.Description = "No source file has been selected."
        '    Return False
        'End If
        'If Me.ExportFiles Is Nothing OrElse Me.ExportFiles.Count < 1 Then
        '    e.Description = "No export files have been selected."
        '    Return False
        'End If
        If Me.SourceFileTemplate Is Nothing Then
            e.Description = "No source file template has been selected."
            Return False
        End If
        If Me.ExportFileTemplate Is Nothing Then
            e.Description = "No export file template has been selected."
            Return False
        End If
        Dim retVal As Boolean = True
        Dim msg As String = ""
        retVal = CheckTemplateColumns(msg)
        If Not retVal Then
            e.Description = msg
            Return False
        End If
        Return True
    End Function  
    Private Function CheckTemplateColumns(ByRef msg As String) As Boolean
        Dim retVal As Boolean = True
        For Each exportItem As SPTI_ColumnDefinition In Me.ExportFileTemplate.ColumnDefinitions
            Dim blnFound As Boolean = False
            For Each sourceItem As SPTI_ColumnDefinition In Me.SourceFileTemplate.ColumnDefinitions
                If sourceItem.Name = exportItem.Name Then
                    blnFound = True
                    Exit For
                End If
            Next
            If blnFound Then
                blnFound = False
            Else
                retVal = False
                msg = "Column " & exportItem.Name & " does not exist in the source template."
                Exit For
            End If
        Next
        Return retVal
    End Function
    ''' <summary>Bubbles events from child objects back to the UI</summary>
    ''' <param name="exportMessage"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub RaiseMessageEvent(ByVal exportMessage As ExportObjectMessage)
        RaiseEvent NewMessage(Me, New ExportMessageArgs(exportMessage))
    End Sub
    ''' <summary>Bubbles progress event from child objects back to the UI.</summary>
    ''' <param name="percentComplete"></param>
    ''' <param name="progressMessage"></param>
    ''' <param name="abort"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub RaiseProgressMessage(ByVal percentComplete As Integer, ByVal progressMessage As String, ByVal abort As Boolean)
        RaiseEvent ExportProgress(Me, New ExportFileProgress(percentComplete, progressMessage, abort))
    End Sub
    Private Function InsertLog() As Integer
        Return DataProviders.SPTI_ExportDefinitionProvider.Instance.InsertLog(Me.ExportDefinitionID)
    End Function    
    Public Sub RunExport()        
        Try
            RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Inserting Log File", 0, "", "Definition Run In Progress"))
            RaiseProgressMessage(1, "Processing", False)
            Dim logID As Integer = InsertLog()
            RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Log Created", 0, "", "Definition Run In Progress"))
            RaiseProgressMessage(5, "Processing", False)
            Try
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Creating Import Table", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(6, "Processing", False)
                Me.SourceFileTemplate.CreateImportTable(logID)
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Import Table Created", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(10, "Processing", False)

                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Importing Source File", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(11, "Processing", False)
                Me.SourceFileTemplate.ImportSourceTable(Me, Me.SourceFile.PathandFileName, logID, Me.HasHeader)
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Source File Imported", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(50, "Processing", False)

                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "De-Duping Export Files", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(51, "Processing", False)
                Me.DeDupFile(logID)
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "File(s) De-Dup Complete", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(70, "Processing", False)

                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Writing Export Files", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(71, "Processing", False)
                Me.WriteSplitFiles(logID)
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Export Files Written", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(95, "Processing", False)

                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Finalizing Export Log", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(96, "Processing", False)
                'Clean up dynamic tables
                For Each exportFile As SPTI_ExportDefintionFile In Me.ExportFiles
                    SPTI_ExportDefintionFile.DeleteTempDeDupTable(logID, exportFile.FileID)
                Next
                DataProviders.SPTI_ExportDefinitionProvider.Instance.FinalizeExportDefinitionLog(logID, "", "")
                RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportInformation, "Export Log Complete", 0, "", "Definition Run In Progress"))
                RaiseProgressMessage(100, "Processing", True)
            Catch ex As System.Exception
                'Clean up dynamic tables
                For Each exportFile As SPTI_ExportDefintionFile In Me.ExportFiles
                    SPTI_ExportDefintionFile.DeleteTempDeDupTable(logID, exportFile.FileID)
                Next
                DataProviders.SPTI_ExportDefinitionProvider.Instance.FinalizeExportDefinitionLog(logID, ex.Message, ex.StackTrace)
                Throw ex
            End Try
        Catch myEx As System.Exception
            RaiseMessageEvent(ExportObjectMessage.NewExportObjectMessage(ExportObjectMessageType.ExportError, myEx.Message, 0, myEx.StackTrace, "Export Definition Error"))
            RaiseProgressMessage(100, "Process errored", True)
        End Try
    End Sub
    Private Sub DeDupFile(ByVal logID As Integer)
        If Me.FileDeDupRule.Length > 0 Then
            Dim colList() As String = Me.FileDeDupRule.Split(","c)
            Dim qualifiedFieldList As String = ""
            Dim tempFieldList1 As String = ""
            Dim tempFieldList2 As String = ""
            Dim tempCriteria As String = ""
            For Each item As String In colList
                qualifiedFieldList += "Q." & item & ","
                tempFieldList1 += "QD1." & item & ","
                tempFieldList2 += "QD2." & item & ","
                tempCriteria += "Q." & item & " = QD1." & item & " AND "
            Next
            If qualifiedFieldList.Length > 0 Then
                qualifiedFieldList = qualifiedFieldList.Substring(0, qualifiedFieldList.Length - 1)
                tempFieldList1 = tempFieldList1.Substring(0, tempFieldList1.Length - 1)
                tempFieldList2 = tempFieldList2.Substring(0, tempFieldList2.Length - 1)
                tempCriteria = tempCriteria.Substring(0, tempCriteria.Length - 5)
            End If
            DataProviders.SPTI_ExportDefinitionProvider.Instance.DeDupImportFile(logID, qualifiedFieldList, tempFieldList1, tempFieldList2, tempCriteria)
        End If
    End Sub
    Private Sub WriteSplitFiles(ByVal logID As Integer)
        For Each file As SPTI_ExportDefintionFile In Me.ExportFiles
            Me.ExportFileTemplate.WriteExportFile(logID, file)
        Next
    End Sub
#End Region

End Class