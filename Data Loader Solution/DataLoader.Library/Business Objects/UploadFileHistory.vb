Imports Nrc.Framework.BusinessLogic
Imports NRC.Qualisys.QLoader.Library

Public Interface IUploadFileHistory
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class UploadFileHistory
    Inherits BusinessBase(Of UploadFileHistory)
    Implements IUploadFile
  

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mOrigFileName As String = String.Empty
    Private mDatOccurred As DateTime
    Private mUploadActionId As Nullable(Of Integer)
    Private mUploadAction As UploadAction
    Private mUserNotes As String = String.Empty
    Private mMemberId As Integer
    Private mGroupID As Integer
    Private mUploadFilePackages As UploadFilePackageCollection
    Private mProjectManager As ProjectManager
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

    Public Property DatOccurred() As DateTime
        Get
            Return mDatOccurred
        End Get
        Set(ByVal value As DateTime)
            mDatOccurred = value
            PropertyHasChanged("DatOccurred")
        End Set
    End Property

    Public Property ProjectManager() As ProjectManager
        Get
            Return mProjectManager
        End Get
        Set(ByVal value As ProjectManager)
            mProjectManager = value
            PropertyHasChanged("ProjectManager")
        End Set
    End Property

   
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

  
    Public Property UploadFilePackages() As UploadFilePackageCollection
        Get
            If mUploadFilePackages Is Nothing Then
                mUploadFilePackages = UploadFilePackage.GetByUploadFile(UploadFile.Get(Me.Id))
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

    Public ReadOnly Property UploadFilePagesDisplayText() As String
        Get
            Dim retval As String = String.Empty
            For Each UploadFilePackage As UploadFilePackage In UploadFilePackages
                retval += UploadFilePackage.Package.PackageFriendlyName
            Next
            Return retval
        End Get

    End Property



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

  

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewUploadFileHistory() As UploadFileHistory
        Return New UploadFileHistory
    End Function


    Public Shared Function GetByGroupId(ByVal GroupId As Integer) As UploadFileHistoryCollection
        Return UploadFileHistoryProvider.Instance.SelectUploadFilesByGroupId(GroupId)
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



#End Region

#Region " Public Methods "

    ''' <summary>
    ''' This function returns either a string containing a list of packages, or one project manager.
    ''' </summary>
    ''' <param name="seperator">String appened to end of each item returned</param>
    ''' <returns>StringBuilder</returns>
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



