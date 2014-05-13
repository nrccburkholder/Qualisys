Imports NRC.Framework.BusinessLogic

Public Interface IComment

    Property DataLoadCmntId() As Integer

End Interface

<Serializable()> _
Public Class Comment
	Inherits BusinessBase(Of Comment)
	Implements IComment

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDataLoadCmntId As Integer
    Private mLithoCodeId As Integer
    Private mErrorId As TransferErrorCodes = TransferErrorCodes.None
    Private mCmntNumber As Integer
    Private mCmntText As String = String.Empty
    Private mSubmitted As Boolean

#End Region

#Region " Public Properties "

    Public Property DataLoadCmntId() As Integer Implements IComment.DataLoadCmntId
        Get
            Return mDataLoadCmntId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mDataLoadCmntId Then
                mDataLoadCmntId = value
                PropertyHasChanged("DataLoadCmntId")
            End If
        End Set
    End Property

    Public Property LithoCodeId() As Integer
        Get
            Return mLithoCodeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mLithoCodeId Then
                mLithoCodeId = value
                PropertyHasChanged("LithoCodeId")
            End If
        End Set
    End Property

    Public Property ErrorId() As TransferErrorCodes
        Get
            Return mErrorId
        End Get
        Set(ByVal value As TransferErrorCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

    Public Property CmntNumber() As Integer
        Get
            Return mCmntNumber
        End Get
        Set(ByVal value As Integer)
            If Not value = mCmntNumber Then
                mCmntNumber = value
                PropertyHasChanged("CmntNumber")
            End If
        End Set
    End Property

    Public Property CmntText() As String
        Get
            Return mCmntText
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCmntText Then
                mCmntText = value
                PropertyHasChanged("CmntText")
            End If
        End Set
    End Property

    Public Property Submitted() As Boolean
        Get
            Return mSubmitted
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSubmitted Then
                mSubmitted = value
                PropertyHasChanged("Submitted")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewComment() As Comment

        Return New Comment

    End Function

    Public Shared Function [Get](ByVal dataLoadCmntId As Integer) As Comment

        Return CommentProvider.Instance.SelectComment(dataLoadCmntId)

    End Function

    Public Shared Function GetByLithoCodeId(ByVal lithoCodeId As Integer) As CommentCollection

        Return CommentProvider.Instance.SelectCommentsByLithoCodeId(lithoCodeId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mDataLoadCmntId
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

        DataLoadCmntId = CommentProvider.Instance.InsertComment(Me)

    End Sub

    Protected Overrides Sub Update()

        CommentProvider.Instance.UpdateComment(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        CommentProvider.Instance.DeleteComment(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


