Imports NRC.Framework.BusinessLogic

''' <summary>This class is for data presentation only. It does not correspond to any
''' table or view.</summary>
''' <author>Arman Mnatsakanyan</author>
Public Class LithoHandEntryDisplay
    Implements ComponentModel.IDataErrorInfo

#Region " Private Members"

    Private mLithoCodeValue As String
    Private mHandEntry As HandEntry
    Private mErrorCodes As ErrorCodeCollection

    Private Const QuestionCorePropertyName As String = "QuestionCore"

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property HandEntryId() As Integer
        Get
            Return mHandEntry.HandEntryId
        End Get
    End Property

    Public ReadOnly Property LithoCodeValue() As String
        Get
            Return mLithoCodeValue
        End Get
    End Property

    Public ReadOnly Property QuestionCore() As Integer
        Get
            Return mHandEntry.QstnCore
        End Get
    End Property

    Public ReadOnly Property ItemNumber() As Integer
        Get
            Return mHandEntry.ItemNumber
        End Get
    End Property

    Public ReadOnly Property Line() As Integer
        Get
            Return mHandEntry.LineNumber
        End Get
    End Property

    Public ReadOnly Property HandEntryText() As String
        Get
            Return mHandEntry.HandEntryText
        End Get
    End Property

#End Region

#Region " IDataErrorInfo Implementation "

    Public ReadOnly Property [Error]() As String Implements System.ComponentModel.IDataErrorInfo.Error
        Get
            If mHandEntry.ErrorId <> TransferErrorCodes.None Then
                Return mErrorCodes.GetErrorDescriptionByErrorID(mHandEntry.ErrorId)
            End If
            Return String.Empty
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal columnName As String) As String Implements System.ComponentModel.IDataErrorInfo.Item
        Get
            If columnName = QuestionCorePropertyName Then
                If mHandEntry.ErrorId <> TransferErrorCodes.None Then
                    Return mErrorCodes.GetErrorDescriptionByErrorID(mHandEntry.ErrorId)
                End If
            End If
            Return String.Empty
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal handEntry As HandEntry, ByVal lithoCode As String, ByVal errorCodes As ErrorCodeCollection)

        mHandEntry = handEntry
        mLithoCodeValue = lithoCode
        mErrorCodes = errorCodes

    End Sub

#End Region

End Class
