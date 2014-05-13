Imports Nrc.Framework.BusinessLogic

Public Interface IUploadFilePackageNoteDisplay
    Property NoteId() As Integer
End Interface
''' <summary>Initial Creation</summary>
''' <CreateBy>Steve Kennedy</CreateBy>
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
Public Class UploadFilePackageNoteDisplay
    Inherits BusinessBase(Of UploadFilePackageNoteDisplay)
    Implements IUploadFilePackageNoteDisplay

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mNoteId As Integer
    Private mUploadFilePackageId As Integer
    Private mDateCreated As Date
    Private mUsername As String = String.Empty
    Private mNote As String = String.Empty
    Private mUploadFileId As Integer
    Private mPackageId As Integer '(DTSPackage)

#End Region

#Region " Public Properties "


    Public Property NoteId() As Integer Implements IUploadFilePackageNoteDisplay.NoteId

        Get
            Return mNoteId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mNoteId Then
                mNoteId = value
                PropertyHasChanged("NotedId")
            End If
        End Set
    End Property
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            mDateCreated = value
            PropertyHasChanged("DateCreated")
        End Set
    End Property
    Public Property UploadFilePackageId() As Integer
        Get
            Return mUploadFilePackageId
        End Get
        Set(ByVal value As Integer)
            mUploadFilePackageId = value
            PropertyHasChanged("UploadFilePackageId")
        End Set
    End Property
    Public Property Note() As String
        Get
            Return mNote
        End Get
        Set(ByVal value As String)
            mNote = value
            PropertyHasChanged("Note")
        End Set
    End Property
    Public Property Username() As String
        Get
            Return mUsername
        End Get
        Set(ByVal value As String)
            mUsername = value
            PropertyHasChanged("Username")
        End Set
    End Property
    Public Property UploadFileId() As Integer
        Get
            Return mUploadFileId
        End Get
        Set(ByVal value As Integer)
            mUploadFileId = value
            PropertyHasChanged("UploadFileId")
        End Set
    End Property
    Public Property PackageId() As Integer
        Get
            Return mPackageId
        End Get
        Set(ByVal value As Integer)
            mPackageId = value
            PropertyHasChanged("PackageId")
        End Set
    End Property




#End Region

#Region " Data Access"
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub




#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub



#End Region

#Region " Factory Methods "

    Public Shared Function NewUploadFilePackageNoteDisplay() As UploadFilePackageNoteDisplay
        Return New UploadFilePackageNoteDisplay
    End Function



    Public Shared Function SelectUploadFilePackageNoteDisplaysByUploadFilePackageIDs(ByVal ids As String) As UploadFilePackageNoteDisplayCollection
        If String.IsNullOrEmpty(ids) Then Return Nothing
        Return UploadFilePackageNoteDisplayProvider.Instance.SelectUploadFilePackageNotesByUploadFilePackageIDs(ids)
    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mNoteId
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region


End Class
