Imports NRC.Framework.BusinessLogic

''' <summary>This class is for data presentation only. It does not correspond to any
''' table or view.</summary>
''' <author>Arman Mnatsakanyan</author>
Public Class LithoCodeDisplay
    Implements ComponentModel.IDataErrorInfo

#Region " Private Members "

    Private mLithoCode As LithoCode
    Private mErrorCodes As ErrorCodeCollection

    Private Const mkLithoCodeValuePropertyName As String = "LithoCodeValue"

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property LithoCodeValue() As String
        Get
            Return mLithoCode.LithoCode
        End Get
    End Property

    Public ReadOnly Property SurveyID() As Integer
        Get
            Return mLithoCode.SurveyId
        End Get
    End Property

    Public ReadOnly Property ResponseType() As String
        Get
            Return mLithoCode.ResponseType
        End Get
    End Property

    Public ReadOnly Property Ignore() As Boolean
        Get
            Return mLithoCode.Ignore
        End Get
    End Property

    Public ReadOnly Property SkipDuplicate() As Boolean
        Get
            Return mLithoCode.SkipDuplicate
        End Get
    End Property

    Public ReadOnly Property Submitted() As Boolean
        Get
            Return mLithoCode.Submitted
        End Get
    End Property

    Public ReadOnly Property DispositionUpdate() As Boolean
        Get
            Return mLithoCode.DispositionUpdate
        End Get
    End Property

#End Region

#Region " IDataErrorInfo Implementation "

    Public ReadOnly Property [Error]() As String Implements System.ComponentModel.IDataErrorInfo.Error
        Get
            If mLithoCode.ErrorId <> TransferErrorCodes.None Then
                Return mErrorCodes.GetErrorDescriptionByErrorID(mLithoCode.ErrorId)
            End If
            Return String.Empty
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal columnName As String) As String Implements System.ComponentModel.IDataErrorInfo.Item
        Get
            If columnName = mkLithoCodeValuePropertyName Then
                If mLithoCode.ErrorId <> TransferErrorCodes.None Then
                    Return mErrorCodes.GetErrorDescriptionByErrorID(mLithoCode.ErrorId)
                End If
            End If
            Return String.Empty
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal lithoCode As LithoCode, ByVal errorCodes As ErrorCodeCollection)

        mLithoCode = lithoCode
        mErrorCodes = errorCodes

    End Sub

#End Region

End Class