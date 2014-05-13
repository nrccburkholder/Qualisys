Imports Nrc.Framework.BusinessLogic

Public Interface IUploadFilePackageNote
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
Public Class UploadFilePackageNote
    Inherits BusinessBase(Of UploadFilePackageNote)
    Implements IUploadFilePackageNote

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mNoteId As Integer
    Private mUploadFilePackageId As Integer
    Private mDateCreated As Date
    Private mUsername As String = String.Empty
    Private mNote As String = String.Empty
    'UploadFilePackageId - this is for actual BO


#End Region

#Region " Public Properties "
    Public Property NoteId() As Integer Implements IUploadFilePackageNote.Noteid
        Get
            Return mNoteId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mNoteId Then
                mNoteId = value
                PropertyHasChanged("NoteId")
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


    'Public Property NoteId() As Integer
    '    Get
    '        Return mNoteId
    '    End Get
    '    Set(ByVal value As Integer)
    '        mNoteId = value
    '        PropertyHasChanged("NoteId")
    '    End Set
    'End Property
#End Region

#Region " Data Access"
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        NoteId = UploadFilePackageNoteProvider.Instance.InsertUploadFilePackageNote(Me)
    End Sub


    Public Overrides Sub Save()
        MyBase.Save()
    End Sub
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub

   

#End Region

#Region " Factory Methods "

    Public Shared Function NewUploadFilePackageNote() As UploadFilePackageNote
        Return New UploadFilePackageNote
    End Function

    Public Shared Function [Get](ByVal id As Integer) As UploadFilePackageNote
        Return UploadFilePackageNoteProvider.Instance.SelectUploadFilePackageNote(id)
    End Function

    Public Shared Function SelectUploadFilePackageNotesByUploadFilePackageIDs(ByVal ids As String) As UploadFilePackageNoteCollection
        Return UploadFilePackageNoteProvider.Instance.SelectUploadFilePackageNotesByUploadFilePackageIDs(ids)
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
