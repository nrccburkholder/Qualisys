Imports NRC.Framework.BusinessLogic

Public Class LithoCommentDisplay
    Implements System.ComponentModel.IDataErrorInfo

#Region " Private Members "

    Private mComment As Comment
    Private mLithoCodeValue As String
    Private mErrorCodes As ErrorCodeCollection

    Private Const CommentNumberPropertyName As String = "CommentNumber"

#End Region

#Region " Public Properties "

    Public ReadOnly Property DataLoadCmntId() As Integer
        Get
            Return mComment.DataLoadCmntId
        End Get
    End Property

    Public ReadOnly Property CmntText() As String
        Get
            Return mComment.CmntText
        End Get
    End Property

    Public ReadOnly Property LithoCodeValue() As String
        Get
            Return mLithoCodeValue
        End Get
    End Property

    Public ReadOnly Property CommentNumber() As Integer
        Get
            Return mComment.CmntNumber
        End Get
    End Property

#End Region

#Region " IDataErrorInfo implementation "

    Public ReadOnly Property [Error]() As String Implements System.ComponentModel.IDataErrorInfo.Error
        Get
            If mComment.ErrorId <> TransferErrorCodes.None Then
                Return mErrorCodes.GetErrorDescriptionByErrorID(mComment.ErrorId)
            End If
            Return String.Empty
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal columnName As String) As String Implements System.ComponentModel.IDataErrorInfo.Item
        Get
            If columnName = CommentNumberPropertyName Then
                If mComment.ErrorId <> TransferErrorCodes.None Then
                    Return mErrorCodes.GetErrorDescriptionByErrorID(mComment.ErrorId)
                End If
            End If
            Return String.Empty
        End Get
    End Property

#End Region

#Region " Constructors"

    Public Sub New(ByVal comment As Comment, ByVal lithoCode As String, ByVal errorCodes As ErrorCodeCollection)

        mComment = comment
        mLithoCodeValue = lithoCode
        mErrorCodes = errorCodes

    End Sub

#End Region

End Class