Imports NRC.Framework.BusinessLogic
''' <summary>This class is for data presentation only. It does not correspond to any
''' table or view.</summary>
''' <author>Arman Mnatsakanyan</author>
Public Class LithoDispositionDisplay
    Implements System.ComponentModel.IDataErrorInfo
    Private Const VendorDispositionCodePropertyName As String = "VendorDispositionCode"

#Region " Private Members "

    Private mDisposition As Disposition
    Private mLithoCode As String
    Private mErrorCodes As ErrorCodeCollection

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property LithoCode() As String
        Get
            Return mLithoCode
        End Get
    End Property

    Public ReadOnly Property DispositionDate() As Date
        Get
            Return mDisposition.DispositionDate
        End Get
    End Property

    Public ReadOnly Property VendorDispositionCode() As String
        Get
            Return mDisposition.VendorDispositionCode
        End Get

    End Property

    Public ReadOnly Property IsFinal() As Boolean
        Get
            Return mDisposition.IsFinal
        End Get
    End Property
#End Region

#Region " IDataErrorInfo Implementation "

    Public ReadOnly Property [Error]() As String Implements System.ComponentModel.IDataErrorInfo.Error
        Get
            If mDisposition.ErrorId <> TransferErrorCodes.None Then
                Return mErrorCodes.GetErrorDescriptionByErrorID(mDisposition.ErrorId)
            End If
            Return String.Empty
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal columnName As String) As String Implements System.ComponentModel.IDataErrorInfo.Item
        Get
            If columnName = VendorDispositionCodePropertyName Then
                If mDisposition.ErrorId <> TransferErrorCodes.None Then
                    Return mErrorCodes.GetErrorDescriptionByErrorID(mDisposition.ErrorId)
                End If
            End If
            Return String.Empty
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal disposition As Disposition, ByVal lithoCode As String, ByVal errorCodes As ErrorCodeCollection)

        mLithoCode = lithoCode
        mDisposition = disposition
        mErrorCodes = errorCodes

    End Sub

#End Region

End Class