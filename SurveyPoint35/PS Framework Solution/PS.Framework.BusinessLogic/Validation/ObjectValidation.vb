Imports System.Data
Imports System.IO
Imports System.Text
Namespace Validation
    Public Enum MessageTypes
        Unknown = 0
        Informational = 1
        Warning = 2
        [Error] = 3
        Print = 4
    End Enum
    Public Class ObjectValidation
#Region " Field Definitions "
        Private mInstanceGuid As Guid = Guid.NewGuid()
        Private mValidationID As Integer
        Private mMessageType As MessageTypes = MessageTypes.Unknown
        Private mValidationType As String = String.Empty
        Private mMessage As String = String.Empty
        Private mClassName As String = String.Empty
        Private mMethodName As String = String.Empty
        Private mDateCreated As DateTime = Now
        Private mStackTrace As String = String.Empty
#End Region
#Region " Properties "
        Public Property ValidationID() As Integer
            Get
                Return Me.mValidationID
            End Get
            Set(ByVal value As Integer)
                Me.mValidationID = value
            End Set
        End Property
        Public Property MessageType() As MessageTypes
            Get
                Return Me.mMessageType
            End Get
            Set(ByVal value As MessageTypes)
                Me.mMessageType = value
            End Set
        End Property
        Public Property ValidationType() As String
            Get
                Return Me.mValidationType
            End Get
            Set(ByVal value As String)
                Me.mValidationType = value
            End Set
        End Property
        Public Property Message() As String
            Get
                Return Me.mMessage
            End Get
            Set(ByVal value As String)
                If Not (Me.mMessage = value) Then
                    Me.mMessage = value
                End If
            End Set
        End Property
        Public Property ClassName() As String
            Get
                Return Me.mClassName
            End Get
            Set(ByVal value As String)
                If Not (Me.mClassName = value) Then
                    Me.mClassName = value
                End If
            End Set
        End Property
        Public Property MethodName() As String
            Get
                Return Me.mMethodName
            End Get
            Set(ByVal value As String)
                If Not (Me.mMethodName = value) Then
                    Me.mMethodName = value
                End If
            End Set
        End Property
        Public Property StackTrace() As String
            Get
                Return Me.mStackTrace
            End Get
            Set(ByVal value As String)
                If Not (Me.mStackTrace = value) Then
                    Me.mStackTrace = value
                End If
            End Set
        End Property
        Public ReadOnly Property DateCreated() As DateTime
            Get
                Return Me.mDateCreated
            End Get
        End Property
#End Region

#Region " Constructors "
        Public Sub New()

        End Sub
        Public Sub New(ByVal messType As MessageTypes, ByVal valType As String, _
                       ByVal clsName As String, ByVal methName As String, ByVal stackTrace As String, ByVal msg As String)
            Me.mValidationType = valType
            Me.mMessageType = messType
            Me.mMessage = msg
            Me.mClassName = clsName
            Me.mMethodName = methName
            Me.mStackTrace = stackTrace
        End Sub
#End Region

    End Class

    Public Class ObjectValidations
        Dim oVals As List(Of ObjectValidation)

        Public Sub New()
            oVals = New List(Of ObjectValidation)
        End Sub

        Public ReadOnly Property MyValidations() As List(Of ObjectValidation)
            Get
                Return oVals
            End Get
        End Property

        Public Sub Add(ByVal item As ObjectValidation)
            Me.oVals.Add(item)
        End Sub
        Public Sub Clear()
            Me.oVals.Clear()
        End Sub
        Public Function ErrorsExist() As Boolean
            For Each Item As ObjectValidation In Me.oVals
                If Item.MessageType = MessageTypes.Error Then
                    Return True
                End If
            Next
            Return False
        End Function
        Public Function GetErrorString() As String
            Dim sb As New StringBuilder
            For Each Item As ObjectValidation In Me.oVals
                If Item.MessageType = MessageTypes.Error Then
                    sb.AppendLine(Item.Message)
                End If
            Next
            Return sb.ToString
        End Function
        Public Function Get8KString() As String
            Dim sb As New StringBuilder
            For Each Item As ObjectValidation In Me.oVals
                sb.AppendLine(String.Format("{0}-{1}-{2}-{3}", _
                                            [Enum].GetName(GetType(MessageTypes), Item.MessageType), _
                                            Item.ClassName, Item.MethodName, Item.Message))
            Next
            If sb.Length > 8000 Then
                Return sb.ToString.Substring(0, 8000)
            Else
                Return sb.ToString
            End If
        End Function
        Public Function WarningExist() As Boolean
            For Each Item As ObjectValidation In Me.oVals
                If Item.MessageType = MessageTypes.Warning Then
                    Return True
                End If
            Next
            Return False
        End Function
        Public Function InformationExists() As Boolean
            For Each Item As ObjectValidation In Me.oVals
                If Item.MessageType = MessageTypes.Informational Then
                    Return True
                End If
            Next
            Return False
        End Function
        Public Sub AddCollection(ByVal cols As ObjectValidations)
            For Each col As ObjectValidation In cols.oVals
                Me.Add(New ObjectValidation(col.MessageType, col.ValidationType, col.ClassName, col.MethodName, col.StackTrace, col.Message))
            Next
        End Sub
    End Class
End Namespace