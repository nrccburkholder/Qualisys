Imports NRC.Framework.BusinessLogic

''' <summary>This class is for data presentation only. It does not correspond to any
''' table or view.</summary>
''' <author>Arman Mnatsakanyan</author>
Public Class LithoPopMappingDisplay
    Implements ComponentModel.IDataErrorInfo

#Region " Private Members"

    Private mLithoCodeValue As String
    Private mPopMapping As PopMapping
    Private mErrorCodes As ErrorCodeCollection

    Private Const QuestionCorePropertyName As String = "QuestionCore"

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property PopMappingId() As Integer
        Get
            Return mPopMapping.PopMappingId
        End Get
    End Property

    Public ReadOnly Property LithoCodeValue() As String
        Get
            Return mLithoCodeValue
        End Get
    End Property

    Public ReadOnly Property QuestionCore() As Integer
        Get
            Return mPopMapping.QstnCore
        End Get
    End Property

    Public ReadOnly Property PopMappingText() As String
        Get
            Return mPopMapping.PopMappingText
        End Get
    End Property

#End Region

#Region " IDataErrorInfo Implementation "

    Public ReadOnly Property [Error]() As String Implements System.ComponentModel.IDataErrorInfo.Error
        Get
            If mPopMapping.ErrorId <> TransferErrorCodes.None Then
                Return mErrorCodes.GetErrorDescriptionByErrorID(mPopMapping.ErrorId)
            End If
            Return String.Empty
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal columnName As String) As String Implements System.ComponentModel.IDataErrorInfo.Item
        Get
            If columnName = QuestionCorePropertyName Then
                If mPopMapping.ErrorId <> TransferErrorCodes.None Then
                    Return mErrorCodes.GetErrorDescriptionByErrorID(mPopMapping.ErrorId)
                End If
            End If
            Return String.Empty
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal popMap As PopMapping, ByVal lithoCode As String, ByVal errorCodes As ErrorCodeCollection)

        mPopMapping = popMap
        mLithoCodeValue = lithoCode
        mErrorCodes = errorCodes

    End Sub

#End Region

End Class
