Imports Nrc.Framework.BusinessLogic
Imports System.IO

Public Interface ISPTI_ExportDefintionFile
    Property FileID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_ExportDefintionFile
    Inherits BusinessBase(Of SPTI_ExportDefintionFile)
    Implements ISPTI_ExportDefintionFile

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFileID As Integer
    Private mExportDefinitionID As Integer
    Private mName As String = String.Empty
    Private mPathandFileName As String = String.Empty
    Private mIsSourceFile As Boolean
    Private mIDGuid As Guid = Guid.NewGuid()
    Private mSplitRule As String = ""
    Private mDeDupRule As String = ""
    Private mDBDeDupRule As SPTI_DeDupRule = Nothing
#End Region

#Region " Public Properties "
    Public Property FileID() As Integer Implements ISPTI_ExportDefintionFile.FileID
        Get
            Return mFileID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFileID Then
                mFileID = value
                PropertyHasChanged("FileID")
            End If
        End Set
    End Property
    Public Property ExportDefinitionID() As Integer
        Get
            Return mExportDefinitionID
        End Get
        Set(ByVal value As Integer)
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
    Public Property PathandFileName() As String
        Get
            Return mPathandFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPathandFileName Then
                mPathandFileName = value
                PropertyHasChanged("PathandFileName")
            End If
        End Set
    End Property
    Public Property IsSourceFile() As Boolean
        Get
            Return mIsSourceFile
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsSourceFile Then
                mIsSourceFile = value
                PropertyHasChanged("IsSourceFile")
            End If
        End Set
    End Property
    Public ReadOnly Property ReferenceGuid() As Guid
        Get
            Return Me.mIDGuid
        End Get
    End Property

    Public Property SplitRule() As String
        Get
            Return Me.mSplitRule
        End Get
        Set(ByVal value As String)
            If Not Me.mSplitRule = value Then
                Me.mSplitRule = value
                PropertyHasChanged("SplitRule")
            End If
        End Set
    End Property

    Public ReadOnly Property DeDupRule() As String
        Get
            If Me.mDBDeDupRule Is Nothing AndAlso Me.mFileID > 0 Then
                Me.mDBDeDupRule = SPTI_DeDupRule.GetByFileID(Me.mFileID)
            End If
            If Not Me.mDBDeDupRule Is Nothing Then
                Me.mDeDupRule = Me.mDBDeDupRule.Name
            Else
                Me.mDeDupRule = ""
            End If
            Return Me.mDeDupRule
        End Get
    End Property
    Public Property DBDeDupRule() As SPTI_DeDupRule
        Get
            If Me.mDBDeDupRule Is Nothing AndAlso Me.mFileID > 0 Then
                Me.mDBDeDupRule = SPTI_DeDupRule.GetByFileID(Me.mFileID)
            End If
            Return Me.mDBDeDupRule
        End Get
        Set(ByVal value As SPTI_DeDupRule)
            Me.mDBDeDupRule = value
            PropertyHasChanged("DBDeDupRule")
        End Set
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
    Private Sub New(ByVal exportDefID As Integer, ByVal name As String, ByVal path As String, ByVal isSource As Boolean)
        Me.ExportDefinitionID = exportDefID
        Me.Name = name
        Me.PathandFileName = path
        Me.IsSourceFile = isSource
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "    
    Public Shared Function NewSPTI_ExportDefintionFile() As SPTI_ExportDefintionFile
        Return New SPTI_ExportDefintionFile
    End Function
    Public Shared Function NewSPTI_ExportDefintionFile(ByVal exportDefID As Integer, ByVal name As String, ByVal path As String, ByVal isSource As Boolean) As SPTI_ExportDefintionFile
        Return New SPTI_ExportDefintionFile(exportDefID, name, path, isSource)
    End Function
    Public Shared Function [Get](ByVal fileID As Integer) As SPTI_ExportDefintionFile
        Return DataProviders.SPTI_ExportDefinitionFileProvider.Instance.SelectSPTI_ExportDefintionFile(fileID)
    End Function

    Public Shared Function GetAll() As SPTI_ExportDefintionFileCollection
        Return DataProviders.SPTI_ExportDefinitionFileProvider.Instance.SelectAllSPTI_ExportDefintionFiles()
    End Function
    Public Shared Sub DeleteByExportDefinitionID(ByVal exportDefinitionID As Integer, ByVal isSourceFile As Integer)
        DataProviders.SPTI_ExportDefinitionFileProvider.Instance.DeleteSPTI_ExportDefinitionFileByDefIDAndSource(exportDefinitionID, isSourceFile)
    End Sub
    Public Shared Function GetSourceFileByExportDefinitionID(ByVal exportDefinitionID As Integer) As SPTI_ExportDefintionFile
        Return DataProviders.SPTI_ExportDefinitionFileProvider.Instance.SelectSourceFileByDefID(exportDefinitionID)
    End Function
    Public Shared Function GetExportFileByExportDefinitionID(ByVal exportDefinitionID As Integer) As SPTI_ExportDefintionFileCollection
        Return DataProviders.SPTI_ExportDefinitionFileProvider.Instance.SelectExportFilesByDefID(exportDefinitionID)
    End Function
    Public Shared Sub DeleteTempDeDupTable(ByVal logID As Integer, ByVal fileID As Integer)
        DataProviders.SPTI_ExportDefinitionFileProvider.Instance.DeleteTempDeDupTable(logID, fileID)
    End Sub
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mFileID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf CheckName, "Name")
        ValidationRules.AddRule(AddressOf CheckPath, "PathandFileName")        
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        FileID = DataProviders.SPTI_ExportDefinitionFileProvider.Instance.InsertSPTI_ExportDefintionFile(Me)        
    End Sub

    Protected Overrides Sub Update()
        DataProviders.SPTI_ExportDefinitionFileProvider.Instance.UpdateSPTI_ExportDefintionFile(Me)        
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProviders.SPTI_ExportDefinitionFileProvider.Instance.DeleteSPTI_ExportDefintionFile(mFileID)
    End Sub
    Public Overrides Sub Save()
        Dim blnIsDeleted As Boolean = Me.IsDeleted  'Need if we delete the file.
        'We need to first Remove Children, then we can re add them in.
        MyBase.Save()
        If Me.mFileID > 0 Then
            SPTI_DeDupRule.DeleteDeDupRuleAndChildren(Me.mFileID)
        End If
        If Not blnIsDeleted AndAlso Not Me.mDBDeDupRule Is Nothing AndAlso (Me.DBDeDupRule.DeDupRuleColumnMaps.Count > 0 AndAlso Me.mDBDeDupRule.DeDupRuleClientIDs.Count > 0) Then
            Me.mDBDeDupRule.FileID = Me.mFileID
            Me.mDBDeDupRule.Save()
        End If
    End Sub
#End Region

#Region " Public Methods "
    Public Function CheckName(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.Name = "" Then
            e.Description = "Export Definition File has no name."
            Return False
        End If
        Return True
    End Function
    Public Function CheckPath(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.mPathandFileName = "" Then
            e.Description = "No path given for export definition file."
            Return False
        End If
        If Me.mIsSourceFile Then
            If Not System.IO.File.Exists(Me.mPathandFileName) Then
                e.Description = "An invalid file path was given for the export definition source file."
                Return False
            End If
        Else
            If Me.mPathandFileName.IndexOf("\"c) < 0 Then
                e.Description = "An invalid file path was given for the export deinfintion file."
                Return False
            End If
            Dim path As String = Me.mPathandFileName.Substring(0, Me.mPathandFileName.LastIndexOf("\"c))
            If Not System.IO.Directory.Exists(path) Then
                e.Description = "An invalid directory was given for the export definition file."
                Return False
            End If
        End If
        Return True
    End Function
    Friend Sub DeDupQMS(ByVal logID As Integer, ByVal criteriaList As String)
        Dim clientIDs As String = Me.DBDeDupRule.DeDupRuleClientIDs.GetClientIDsString
        Dim columnMapCriteria As String = Me.DBDeDupRule.DeDupRuleColumnMaps.GetColumnMapCriteria("R", "T")
        DataProviders.SPTI_ExportDefinitionFileProvider.Instance.DeDupQMSRecordsInImportFile(logID, Me.FileID, criteriaList, clientIDs, columnMapCriteria, Me.DBDeDupRule.ActiveSI)
    End Sub
#End Region

End Class