Imports Nrc.Framework.BusinessLogic
Imports NRC.Qualisys.QLoader.Library
Public Interface IUploadFile
    Property Id() As Integer
End Interface

''' <summary>UploadFile Business Class. Encapsulates Uploaded Files.</summary>
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
Public Class UploadFile
    Inherits BusinessBase(Of UploadFile)
    Implements IUploadFile
    Public Enum RestoreRequestReturned
        CanRestore = 1
        FileIsNotAbandoned = 2
        FileIsNotUploaded = 3
        NotInitialized = 4
    End Enum
#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mOrigFileName As String = String.Empty
    Private mFileName As String = String.Empty
    Private mFileSize As Integer
    Private mUploadActionId As Nullable(Of Integer)
    Private mUploadAction As UploadAction
    Private mUserNotes As String = String.Empty
    Private mMemberId As Integer
    Private mGroupID As Integer
    Private mUploadFilePackages As UploadFilePackageCollection
    Private mUploadFileState As UploadFileState
    Private mClientFileId As Integer
    Private mProjectManager As ProjectManager
    'Private mUploadFileTypeAction As UploadFileTypeAction

    Private mFileStatusSaved As Boolean = False
    Private mFileNotificationHandled As Boolean = False
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IUploadFile.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property FileStatusSaved() As Boolean
        Get
            Return mFileStatusSaved
        End Get
        Set(ByVal value As Boolean)
            mfilestatussaved = value
        End Set
    End Property
    Public Property FileNotificationHandled() As Boolean
        Get
            Return mFileNotificationHandled
        End Get
        Set(ByVal value As Boolean)
            mFileNotificationHandled = value
        End Set
    End Property
    Public ReadOnly Property CanRestore() As RestoreRequestReturned
        Get
            Return UploadFile.CanRestoreAbandonedUpload(Me.Id)
        End Get
    End Property


    ''' <summary>This field does NOT map to any field in the UploadFiles table. It's
    ''' designed for internal use.</summary>
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
    Public Property ClientFileId() As Integer
        Get
            Return mClientFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientFileId Then
                mClientFileId = value
                PropertyHasChanged("ClientFileId")
            End If
        End Set
    End Property

    ''' <summary>The project manager that is selected by users to be notified about the
    ''' upload.</summary>
    ''' <remarks>ProjectManager class exposes a fiew properties from Member class
    ''' (NRCAuth).</remarks>
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
    Public Property ProjectManager() As ProjectManager
        Get
            Return mProjectManager
        End Get
        Set(ByVal value As ProjectManager)
            mProjectManager = value
            PropertyHasChanged("ProjectManager")
        End Set
    End Property
    ''' <summary>The original uploaded file name.</summary>
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
    Public Property OrigFileName() As String
        Get
            Return mOrigFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOrigFileName Then
                mOrigFileName = value
                PropertyHasChanged("OrigFileName")
            End If
        End Set
    End Property
    ''' <summary>The file name that the uploaded file is saved as.</summary>
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
    Public Property FileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileName Then
                mFileName = value
                PropertyHasChanged("FileName")
            End If
        End Set
    End Property
    ''' <summary>The Uploaded File Size in bytes</summary>
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
    Public Property FileSize() As Integer
        Get
            Return mFileSize
        End Get
        Set(ByVal value As Integer)
            If Not value = mFileSize Then
                mFileSize = value
                PropertyHasChanged("FileSize")
            End If
        End Set
    End Property
    ''' <summary>Upload action is the &quot;type&quot; of the uploaded data file. It
    ''' will define the action applied to the file on the server. Currently it can have
    ''' two values: &quot;Production File&quot; and &quot;DRG Update
    ''' File&quot;.</summary>
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
    Public Property UploadAction() As UploadAction
        Get
            If mUploadAction Is Nothing Then
                mUploadAction = UploadAction.Get(mUploadActionId)
            End If
            Return mUploadAction
        End Get
        Set(ByVal value As UploadAction)
            If value IsNot Nothing Then
                mUploadActionId = value.UploadActionId
            End If
            If value IsNot mUploadAction Then
                mUploadAction = value
                PropertyHasChanged("UploadAction")
            End If
        End Set
    End Property
    ''' <summary>The note that a user enters on the upload file page.</summary>
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
    Public Property UserNotes() As String
        Get
            Return mUserNotes
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mUserNotes Then
                mUserNotes = value
                PropertyHasChanged("UserNotes")
            End If
        End Set
    End Property
    ''' <summary>The member ID of the user doing the upload.</summary>
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
    Public Property MemberId() As Integer
        Get
            Return mMemberId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMemberId Then
                mMemberId = value
                PropertyHasChanged("MemberId")
            End If
        End Set
    End Property
    ''' <summary>The DTS Packages associated with the uploaded file. They will be saved
    ''' in UploadFilePackage table as separate records with same
    ''' UploadFile_id.</summary>
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
    Public Property UploadFilePackages() As UploadFilePackageCollection
        Get
            If mUploadFilePackages Is Nothing Then
                mUploadFilePackages = UploadFilePackage.GetByUploadFile(Me)
            End If
            Return mUploadFilePackages
        End Get
        Set(ByVal value As UploadFilePackageCollection)
            If Not value Is mUploadFilePackages Then
                mUploadFilePackages = value
                PropertyHasChanged("UploadFilePackages")
            End If
        End Set
    End Property
    ''' <summary>The current state of the upload file. It is retrieved from
    ''' UploadFileState table. UploadFile has 1 to 1 relationship with
    ''' UploadFileState.</summary>
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
    Public Property UploadFileState() As UploadFileState
        Get
            If mUploadFileState Is Nothing Then
                mUploadFileState = UploadFileState.GetByUploadFileID(Me.Id)
                If mUploadFileState Is Nothing Then
                    mUploadFileState = UploadFileState.NewUploadFileState()
                End If
            End If
            Return mUploadFileState
        End Get
        Set(ByVal value As UploadFileState)
            'If value IsNot Nothing Then
            '    mUploadFileStateId = value.Id
            'End If
            If Not value Is mUploadFileState Then
                mUploadFileState = value
                PropertyHasChanged("UploadFileState")
            End If
        End Set
    End Property
    ''' <summary>The Group ID that was selected by the user to log in.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property GroupID() As Integer
        Get
            Return mGroupID
        End Get
        Set(ByVal value As Integer)
            If Not value = mGroupID Then
                mGroupID = value
                PropertyHasChanged("GroupID")
            End If
        End Set
    End Property

    ''' <summary>Should be used in Populate method only.</summary>
    ''' <param name="id"></param>
    Public Sub SetUploadActionID(ByVal ID As Integer)
        If Me.mUploadActionId.HasValue = False Then
            Me.mUploadActionId = ID
        Else
            Throw New Exception("PackageID can be assigned only once in the populate method. Change the Package object instead.")
        End If
    End Sub

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewUploadFile() As UploadFile
        Return New UploadFile
    End Function

    Public Shared Function [Get](ByVal id As Integer) As UploadFile
        Return UploadFileProvider.Instance.SelectUploadFile(id)
    End Function

    Public Shared Function GetAll() As UploadFileCollection
        Return UploadFileProvider.Instance.SelectAllUploadFiles()
    End Function
    Public Shared Function CanRestoreAbandonedUpload(ByVal id As Integer) As RestoreRequestReturned
        Return UploadFileProvider.Instance.CanRestoreUbandonedFile(id)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
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
        Id = UploadFileProvider.Instance.InsertUploadFile(Me)
    End Sub

    Protected Overrides Sub Update()
        UploadFileProvider.Instance.UpdateUploadFile(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        UploadFileProvider.Instance.DeleteUploadFile(mId)
    End Sub
    ''' <summary>Save should also save the Packages to the UploadFilePackage table and
    ''' also the current state to UploadFileState table.</summary>
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
    Public Overrides Sub Save()
        MyBase.Save()
        For Each pkg As UploadFilePackage In UploadFilePackages
            pkg.UploadFileId = Me.Id
        Next
        Me.UploadFilePackages.Save()
        Me.UploadFileState.UploadFileId = Me.Id
        Me.UploadFileState.datOccurred = Now()
        Me.UploadFileState.Save()
    End Sub
#End Region

#Region " Public Methods "
    Public Function ValidatePackages(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

    End Function
    ''' <summary>
    ''' This function returns either a string containing a list of packages, or one project manager.
    ''' </summary>
    ''' <param name="seperator">String appened to end of each item returned</param>
    ''' <returns>String</returns>
    ''' <remarks></remarks>
    Public Function GetFileTypeActionDisplayString(ByVal seperator As String) As String

        Dim sb As System.Text.StringBuilder = New System.Text.StringBuilder
        If UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.Packages Then
            For Each package As UploadFilePackage In UploadFilePackages
                sb.AppendLine(package.Package.PackageFriendlyName & seperator)
            Next
        ElseIf UploadAction.UploadFileTypeAction.Name = UploadFileTypeAction.AvailableActions.ProjectManagers Then
            sb.AppendLine(ProjectManager.FullName & seperator)
        End If
        Return sb.ToString
    End Function


#End Region

End Class



