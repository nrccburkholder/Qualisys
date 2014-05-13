Imports Nrc.Framework.BusinessLogic

Public Interface IUploadFileState
    Property Id() As Integer
End Interface

''' <summary>UploadFileState Business class. Encapsulates the current upload state
''' of every uploading or uploaded file (i.e. Uploading, Uploaded etc.).</summary>
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
Public Class UploadFileState
    Inherits BusinessBase(Of UploadFileState)
    Implements IUploadFileState

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mUploadFileId As Integer
    Private mUploadStateId As Nullable(Of Integer)
    Private mUploadState As UploadState
    Private mdatOccurred As Date
    Private mStateParameter As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IUploadFileState.Id
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
    ''' <summary>UploadFileID maps to UploadFileState.UploadFile_id. UploadFile has 1 to
    ''' 1 relationship with UploadFileState.</summary>
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
    Public Property UploadFileId() As Integer
        Get
            Return mUploadFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mUploadFileId Then
                mUploadFileId = value
                PropertyHasChanged("UploadFileId")
            End If
        End Set
    End Property
    Public Property StateOfUpload() As UploadState
        Get
            If mUploadState Is Nothing AndAlso mUploadStateId.HasValue Then
                mUploadState = UploadState.Get(mUploadStateId)
            End If
            Return mUploadState
        End Get
        Set(ByVal value As UploadState)
            If value IsNot Nothing Then
                mUploadStateId = value.UploadStateId
            End If

            If value IsNot mUploadState Then
                mUploadState = value 'reset the mUploadState
                PropertyHasChanged("UploadState")
            End If
        End Set
    End Property
    Public Property datOccurred() As Date
        Get
            Return mdatOccurred
        End Get
        Set(ByVal value As Date)
            If Not value = mdatOccurred Then
                mdatOccurred = value
                PropertyHasChanged("datOccurred")
            End If
        End Set
    End Property
    ''' <summary>StateParameter() is designed to keep additional info about the upload process. It 
    ''' can be a call stack, error message, object dump etc.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property StateParameter() As String
        Get
            Return mStateParameter
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStateParameter Then
                mStateParameter = value
                PropertyHasChanged("StateParameter")
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
    Public Shared Function NewUploadFileState() As UploadFileState
        Return New UploadFileState
    End Function


    Public Shared Function GetByUploadFileID(ByVal id As Integer) As UploadFileState
        Return UploadFileStateProvider.Instance.SelectUploadFileStateByUploadFileID(id)
    End Function
    Public Shared Function [Get](ByVal id As Integer) As UploadFileState
        Return UploadFileStateProvider.Instance.SelectUploadFileState(id)
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
        Id = UploadFileStateProvider.Instance.InsertUploadFileState(Me)
    End Sub

    Protected Overrides Sub Update()
        UploadFileStateProvider.Instance.UpdateUploadFileState(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        UploadFileStateProvider.Instance.DeleteUploadFileState(mId)
    End Sub


#End Region

#Region " Public Methods "
    Public Overrides Sub Save()
        MyBase.Save()
    End Sub
    ''' <summary>Should be used in Populate method only.</summary>
    ''' <param name="id"></param>
    Public Sub SetUploadStateID(ByVal ID As Integer)
        If Me.mUploadStateId.HasValue = False Then
            Me.mUploadStateId = ID
        Else
            Throw New Exception("UploadStateId can be assigned only once in the populate method. Change the Package object instead.")
        End If
    End Sub


#End Region

End Class



