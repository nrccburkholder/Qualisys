Imports Nrc.Framework.BusinessLogic

Public Interface IMetaField

    Property FieldID() As Integer

End Interface

''' <summary>
''' This file contains the definition of the CMetaField object used to 
''' hold all the required information about a single field of name or 
''' address data needed to identify it.
''' </summary>
''' <remarks></remarks>
<Serializable()> _
Friend Class MetaField
    Inherits BusinessBase(Of MetaField)
    Implements IMetaField

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFieldType As String = String.Empty
    Private mFieldID As Integer
    Private mFieldName As String = String.Empty
    Private mFieldDataType As String = String.Empty
    Private mFieldLength As Integer
    Private mAddrCleanCode As Integer
    Private mAddrCleanGroup As Integer
    Private mParamName As String = String.Empty


#End Region

#Region " Public Properties "

    Public Property FieldType() As String
        Get
            Return mFieldType
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFieldType Then
                mFieldType = value
                PropertyHasChanged("FieldType")
            End If
        End Set
    End Property

    Public Property FieldID() As Integer Implements IMetaField.FieldID
        Get
            Return mFieldID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFieldID Then
                mFieldID = value
                PropertyHasChanged("FieldID")
            End If
        End Set
    End Property

    Public Property FieldName() As String
        Get
            Return mFieldName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFieldName Then
                mFieldName = value
                PropertyHasChanged("FieldName")
            End If
        End Set
    End Property

    Public Property FieldDataType() As String
        Get
            Return mFieldDataType
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFieldDataType Then
                mFieldDataType = value.ToUpper()
                PropertyHasChanged("FieldDataType")
            End If
        End Set
    End Property

    Public Property FieldLength() As Integer
        Get
            Return mFieldLength
        End Get
        Set(ByVal value As Integer)
            If Not value = mFieldLength Then
                mFieldLength = value
                PropertyHasChanged("FieldLength")
            End If
        End Set
    End Property

    Public Property AddrCleanCode() As Integer
        Get
            Return mAddrCleanCode
        End Get
        Set(ByVal value As Integer)
            If Not value = mAddrCleanCode Then
                mAddrCleanCode = value
                PropertyHasChanged("AddrCleanCode")
            End If
        End Set
    End Property

    Public Property AddrCleanGroup() As Integer
        Get
            Return mAddrCleanGroup
        End Get
        Set(ByVal value As Integer)
            If Not value = mAddrCleanGroup Then
                mAddrCleanGroup = value
                PropertyHasChanged("AddrCleanGroup")
            End If
        End Set
    End Property

    Public Property ParamName() As String
        Get
            Return mParamName
        End Get
        Set(ByVal Value As String)
            If Value Is Nothing Then Value = String.Empty
            If Not Value = mParamName Then
                mParamName = Value
                PropertyHasChanged("ParamName")
            End If
        End Set
    End Property

    Public ReadOnly Property IsAddress() As Boolean
        Get
            Return mFieldType = "A"
        End Get

    End Property

    Public ReadOnly Property IsName() As Boolean
        Get
            Return mFieldType = "N"
        End Get

    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Friend Shared Function NewMetaField() As MetaField

        Return New MetaField

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mFieldID
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

#End Region

#Region " Public Methods "

#End Region

#Region " Private Methods "

#End Region

End Class