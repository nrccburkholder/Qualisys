Imports System.Reflection
Public Class AuditLogChange

#Region " Private Members "
    Private mPropertyName As String
    Private mChangeType As AuditLogChangeType
    Private mInitialValue As String
    Private mFinalValue As String
    Private mObjectType As AuditLogObject
    Private mLoggableObject As Object
    Private mIdPropertyName As String
#End Region

#Region " Public Properties "
    Public ReadOnly Property PropertyName() As String
        Get
            Return mPropertyName
        End Get
    End Property

    Public ReadOnly Property ChangeType() As AuditLogChangeType
        Get
            Return mChangeType
        End Get
    End Property

    Public ReadOnly Property InitialValue() As String
        Get
            Return mInitialValue
        End Get
    End Property

    Public ReadOnly Property FinalValue() As String
        Get
            Return mFinalValue
        End Get
    End Property

    Public ReadOnly Property ObjectId() As Integer
        Get
            Return CInt(mLoggableObject.GetType().GetProperty(Me.mIdPropertyName).GetValue(mLoggableObject, Nothing))
        End Get
    End Property

    Public ReadOnly Property ObjectType() As AuditLogObject
        Get
            Return mObjectType
        End Get
    End Property

    Public ReadOnly Property LoggableObject() As Object
        Get
            Return mLoggableObject
        End Get
    End Property
#End Region


    Public Sub New(ByVal loggableObject As Object, ByVal idPropertyName As String, ByVal propertyName As String, ByVal changeType As AuditLogChangeType, ByVal initialValue As String, ByVal finalValue As String, ByVal objectType As AuditLogObject)
        Me.mLoggableObject = loggableObject
        Me.mIdPropertyName = idPropertyName
        Me.mPropertyName = propertyName
        Me.mChangeType = changeType
        Me.mInitialValue = initialValue
        Me.mFinalValue = finalValue
        Me.mObjectType = objectType
    End Sub

End Class