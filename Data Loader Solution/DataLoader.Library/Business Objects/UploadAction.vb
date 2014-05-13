Imports Nrc.Framework.BusinessLogic

Public Interface IUploadAction
    Property Id() As Integer
End Interface

''' <summary>UploadAction business class is designed to hold possible 
''' upload file types distinguished by the action to be taken to the 
''' uploaded file (like DRG Update File, Production etc.). It is also used to
''' display as a selection choice to the end user.
'''</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class UploadAction
    Inherits BusinessBase(Of UploadAction)
    Implements IUploadAction

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mUploadActionId As Integer
    Private mUploadActionName As String = String.Empty
    Private mUploadFileTypeAction As UploadFileTypeAction
    Private mFolderName as String 
#End Region

#Region " Public Properties "
    ''' <summary>Maps to Folder_nm field in UploadActions table. This is the subfolder name where the 
    ''' uploaded files are going to be saved for a given file type(upload action).</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FolderName() As String
        Get
            Return mFolderName
        End Get
        Set(ByVal value As String)
            mFolderName = value
            PropertyHasChanged("FolderName")
        End Set
    End Property
    ''' <summary>Maps to UploadAction_id identity field in UploadActions table.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property UploadActionId() As Integer Implements IUploadAction.Id
        Get
            Return mUploadActionId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mUploadActionId Then
                mUploadActionId = value
                PropertyHasChanged("UploadActionId")
            End If
        End Set
    End Property
    ''' <summary>Maps to UploadAction_nm field in UploadActions table. This is the uploaded file type 
    ''' that determines the action to be taken with the uploaded file.  </summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property UploadActionName() As String
        Get
            Return mUploadActionName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mUploadActionName Then
                mUploadActionName = value
                PropertyHasChanged("UploadActionName")
            End If
        End Set
    End Property
    ''' <summary>Maps to UploadFileTypeAction_id field in UploadActions table. We use this property to change the web page appearance depending on its value.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property UploadFileTypeAction() As UploadFileTypeAction
        Get
            Return mUploadFileTypeAction
        End Get
        Set(ByVal value As UploadFileTypeAction)
            mUploadFileTypeAction = value
            PropertyHasChanged("UploadFileTypeAction")
        End Set
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewUploadAction() As UploadAction
        Return New UploadAction
    End Function

    Public Shared Function [Get](ByVal uploadActionId As Integer) As UploadAction
        Return UploadActionsProvider.Instance.SelectUploadAction(uploadActionId)
    End Function

    Public Shared Function GetAll() As UploadActionCollection
        Return UploadActionsProvider.Instance.SelectAllUploadActions()
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mUploadActionId
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
        Throw New NotImplementedException()
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException()
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException()
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class



