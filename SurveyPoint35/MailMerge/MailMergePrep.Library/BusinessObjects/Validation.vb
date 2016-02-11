Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO
Imports System.Text

'#Region " Key Interface "
'Public Interface IValidation
'    Property ValidationID() As Integer
'End Interface
'#End Region
'#Region " Validation Class "
'Public Class Validation
'    Inherits BusinessBase(Of Validation)
'    Implements IValidation

'#Region " Field Definitions "
'    Private mInstanceGuid As Guid = Guid.NewGuid()
'    Private mValidationID As Integer
'    Private mMessageType As MessageTypes = MessageTypes.Unknown
'    Private mValidationType As ValidationTypes = ValidationTypes.Unknown
'    Private mMessage As String = String.Empty
'    Private mClassName As String = String.Empty
'    Private mMethodName As String = String.Empty
'    Private mDateCreated As DateTime = Now
'    Private mStackTrace As String = String.Empty
'#End Region

'#Region " Properties "
'    Public Property ValidationID() As Integer Implements IValidation.ValidationID
'        Get
'            Return Me.mValidationID
'        End Get
'        Set(ByVal value As Integer)
'            Me.mValidationID = value
'        End Set
'    End Property
'    Public Property MessageType() As MessageTypes
'        Get
'            Return Me.mMessageType
'        End Get
'        Set(ByVal value As MessageTypes)
'            Me.mMessageType = value
'        End Set
'    End Property
'    Public Property ValidationType() As ValidationTypes
'        Get
'            Return Me.mValidationType
'        End Get
'        Set(ByVal value As ValidationTypes)
'            Me.mValidationType = value
'        End Set
'    End Property
'    Public Property Message() As String
'        Get
'            Return Me.mMessage
'        End Get
'        Set(ByVal value As String)
'            If Not (Me.mMessage = value) Then
'                Me.mMessage = value
'                PropertyHasChanged("Message")
'            End If
'        End Set
'    End Property
'    Public Property ClassName() As String
'        Get
'            Return Me.mClassName
'        End Get
'        Set(ByVal value As String)
'            If Not (Me.mClassName = value) Then
'                Me.mClassName = value
'                PropertyHasChanged("ClassName")
'            End If
'        End Set
'    End Property
'    Public Property MethodName() As String
'        Get
'            Return Me.mMethodName
'        End Get
'        Set(ByVal value As String)
'            If Not (Me.mMethodName = value) Then
'                Me.mMethodName = value
'                PropertyHasChanged("MethodName")
'            End If
'        End Set
'    End Property
'    Public Property StackTrace() As String
'        Get
'            Return Me.mStackTrace
'        End Get
'        Set(ByVal value As String)
'            If Not (Me.mStackTrace = value) Then
'                Me.mStackTrace = value
'                PropertyHasChanged("StackTrace")
'            End If
'        End Set
'    End Property
'    Public ReadOnly Property DateCreated() As DateTime
'        Get
'            Return Me.mDateCreated
'        End Get
'    End Property    
'#End Region

'#Region " Constructors "
'    Public Sub New()

'    End Sub
'    Public Sub New(ByVal messType As MessageTypes, ByVal valType As ValidationTypes, _
'                   ByVal clsName As String, ByVal methName As String, ByVal stackTrace As String, ByVal msg As String)
'        Me.mValidationType = valType
'        Me.mMessageType = messType
'        Me.mMessage = msg
'        Me.mClassName = clsName
'        Me.mMethodName = methName
'        Me.mStackTrace = stackTrace
'    End Sub
'#End Region

'#Region " Factory Calls "
'    Public Shared Function NewValidation() As Validation
'        Return New Validation
'    End Function
'    Public Shared Function NewValidation(ByVal messType As MessageTypes, ByVal valType As ValidationTypes, _
'                                         ByVal clsName As String, ByVal methName As String, ByVal stackTrace As String, ByVal msg As String) As Validation
'        Return New Validation(messType, valType, clsName, methName, stackTrace, msg)
'    End Function
'#End Region

'#Region " Overrides "
'    Protected Overrides Sub Delete()
'        Throw New NotImplementedException()
'    End Sub
'    Protected Overrides Sub Insert()
'        Throw New NotImplementedException()
'    End Sub
'    Protected Overrides Sub Update()
'        Throw New NotImplementedException()
'    End Sub
'#End Region

'#Region " Validation Rules "
'    Protected Overrides Sub AddBusinessRules()
'        'This object with do object level validation rather than property based.
'    End Sub
'#End Region

'#Region " Execution Methods "

'#End Region

'#Region " Helper Methods "

'#End Region
'End Class
'#End Region


'#Region " Validation Collection Class "
'Public Class Validations
'    Inherits BusinessListBase(Of Validation)
'    Public Function ErrorsExist() As Boolean
'        For Each Item As Validation In Me
'            If Item.MessageType = MessageTypes.Error Then
'                Return True
'            End If
'        Next
'        Return False
'    End Function
'    Public Function GetErrorString() As String
'        Dim sb As New StringBuilder
'        For Each Item As Validation In Me
'            If Item.MessageType = MessageTypes.Error Then
'                sb.AppendLine(Item.Message)
'            End If
'        Next
'        Return sb.ToString
'    End Function
'    Public Function Get8KString() As String
'        Dim sb As New StringBuilder
'        For Each Item As Validation In Me
'            sb.AppendLine(String.Format("{0}-{1}-{2}-{3}", _
'                                        [Enum].GetName(GetType(MessageTypes), Item.MessageType), _
'                                        Item.ClassName, Item.MethodName, Item.Message))
'        Next
'        If sb.Length > 8000 Then
'            Return sb.ToString.Substring(0, 8000)
'        Else
'            Return sb.ToString
'        End If
'    End Function
'    Public Function WarningExist() As Boolean
'        For Each Item As Validation In Me
'            If Item.MessageType = MessageTypes.Warning Then
'                Return True
'            End If
'        Next
'        Return False
'    End Function
'    Public Function InformationExists() As Boolean
'        For Each Item As Validation In Me
'            If Item.MessageType = MessageTypes.Informational Then
'                Return True
'            End If
'        Next
'        Return False
'    End Function
'    Public Sub AddCollection(ByVal cols As Validations)
'        For Each col As Validation In cols
'            Me.Add(New Validation(col.MessageType, col.ValidationType, col.ClassName, col.MethodName, col.StackTrace, col.Message))
'        Next
'    End Sub
'End Class
'#End Region


'#Region " Data Base Class "
'Public MustInherit Class ValidationProvider
'#Region " Singleton Implementation "
'    Private Shared mInstance As ValidationProvider
'    Private Const mProviderName As String = "ValidationProvider"
'    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
'    ''' <value></value>
'    ''' <CreatedBy>Tony Piccoli</CreatedBy>
'    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
'    Public Shared ReadOnly Property Instance() As ValidationProvider
'        Get
'            If mInstance Is Nothing Then
'                mInstance = DataProviderFactory.CreateInstance(Of ValidationProvider)(mProviderName)
'            End If

'            Return mInstance
'        End Get
'    End Property
'#End Region
'#Region " Constructors "
'    Protected Sub New()
'    End Sub
'#End Region
'#Region " Abstract Methods "

'#End Region
'End Class
'#End Region
