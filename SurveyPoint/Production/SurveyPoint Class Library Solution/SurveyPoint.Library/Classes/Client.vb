Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IClient
    Property ClientID() As Integer
End Interface

<Serializable()> _
Public Class Client
    Inherits BusinessBase(Of Client)
    Implements IClient

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mClientID As Integer
    Private mName As String = String.Empty
    Private mAddress1 As String = String.Empty
    Private mAddress2 As String = String.Empty
    Private mCity As String = String.Empty
    Private mState As String = String.Empty
    Private mPostalCode As String = String.Empty
    Private mTelephone As String = String.Empty
    Private mFax As String = String.Empty
    Private mActive As Byte
#End Region

#Region " Public Properties "
    Public Property ClientID() As Integer Implements IClient.ClientID
        Get
            Return mClientID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mClientID Then
                mClientID = value
                PropertyHasChanged("ClientID")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Public Property Address1() As String
        Get
            Return mAddress1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddress1 Then
                mAddress1 = value
                PropertyHasChanged("Address1")
            End If
        End Set
    End Property
    Public Property Address2() As String
        Get
            Return mAddress2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddress2 Then
                mAddress2 = value
                PropertyHasChanged("Address2")
            End If
        End Set
    End Property
    Public Property City() As String
        Get
            Return mCity
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCity Then
                mCity = value
                PropertyHasChanged("City")
            End If
        End Set
    End Property
    Public Property State() As String
        Get
            Return mState
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mState Then
                mState = value
                PropertyHasChanged("State")
            End If
        End Set
    End Property
    Public Property PostalCode() As String
        Get
            Return mPostalCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPostalCode Then
                mPostalCode = value
                PropertyHasChanged("PostalCode")
            End If
        End Set
    End Property
    Public Property Telephone() As String
        Get
            Return mTelephone
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTelephone Then
                mTelephone = value
                PropertyHasChanged("Telephone")
            End If
        End Set
    End Property
    Public Property Fax() As String
        Get
            Return mFax
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFax Then
                mFax = value
                PropertyHasChanged("Fax")
            End If
        End Set
    End Property
    Public Property Active() As Byte
        Get
            Return mActive
        End Get
        Set(ByVal value As Byte)
            If Not value = mActive Then
                mActive = value
                PropertyHasChanged("Active")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewClient() As Client
        Return New Client
    End Function

    Public Shared Function GetSelectedClients(ByVal ExportGroupID As Integer, ByVal SurveyID As Integer) As ClientCollection
        Return ClientProvider.Instance.GetSelectedClients(ExportGroupID, SurveyID)
    End Function

    Public Shared Function GetBySurveyID(ByVal SurveyID As Integer) As ClientCollection
        Return ClientProvider.Instance.GetBySurveyID(SurveyID)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mClientID
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
        Throw New NotImplementedException("Cannot Insert. Business object doesn't represent a table or view")
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException("Cannot Update. Business object doesn't represent a table or view")
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException("Cannot Delete. Business object doesn't represent a table or view")
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


