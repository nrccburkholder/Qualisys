Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_DeDupRuleClientID
    Property ID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_DeDupRuleClientID
    Inherits BusinessBase(Of SPTI_DeDupRuleClientID)
    Implements ISPTI_DeDupRuleClientID

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mID As Integer
    Private mDeDupRuleID As Integer
    Private mClientID As Integer
    Private mClientName As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property ID() As Integer Implements ISPTI_DeDupRuleClientID.ID
        Get
            Return mID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mID Then
                mID = value
                PropertyHasChanged("ID")
            End If
        End Set
    End Property
    Public Property DeDupRuleID() As Integer
        Get
            Return mDeDupRuleID
        End Get
        Set(ByVal value As Integer)
            If Not value = mDeDupRuleID Then
                mDeDupRuleID = value
                PropertyHasChanged("DeDupRuleID")
            End If
        End Set
    End Property
    Public Property ClientID() As Integer
        Get
            Return mClientID
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientID Then
                mClientID = value
                PropertyHasChanged("ClientID")
            End If
        End Set
    End Property
    Public ReadOnly Property ClientName() As String
        Get
            If Me.mClientName.Length = 0 Then
                Me.mClientName = Me.GetClientName()
            End If
            Return Me.mClientName
        End Get        
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
    Private Sub New(ByVal clientID As Integer)
        Me.CreateNew()
        Me.mClientID = clientID
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSPTI_DeDupRuleClientID() As SPTI_DeDupRuleClientID
        Return New SPTI_DeDupRuleClientID
    End Function
    Public Shared Function NewSPTI_DeDupRuleClientID(ByVal clientID As Integer) As SPTI_DeDupRuleClientID
        Return New SPTI_DeDupRuleClientID(clientID)
    End Function
    
    Public Shared Function [Get](ByVal iD As Integer) As SPTI_DeDupRuleClientID
        Return DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.SelectSPTI_DeDupRuleClientID(iD)
    End Function

    Public Shared Function GetAll() As SPTI_DeDupRuleClientIDCollection
        Return DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.SelectAllSPTI_DeDupRuleClientIDs()
    End Function
    Public Shared Function GetAllByDeDupRuleID(ByVal deDupRuleID As Integer) As SPTI_DeDupRuleClientIDCollection
        Return DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.SelectAllSPTI_DeDupRuleClientIDsByDeDupRuleID(deDupRuleID)
    End Function

#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mID
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
        ID = DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.InsertSPTI_DeDupRuleClientID(Me)
    End Sub

    Protected Overrides Sub Update()
        'DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.UpdateSPTI_DeDupRuleClientID(Me)
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub

    Protected Overrides Sub DeleteImmediate()
        'DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.DeleteSPTI_DeDupRuleClientID(mID)
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub
    Public Overrides Sub Save()
        Insert()
    End Sub
    Private Function GetClientName() As String
        Return DataProviders.SPTI_DeDupRuleClientIDProvider.Instance.GetClientName(Me.ClientID)
    End Function
#End Region

#Region " Public Methods "

#End Region

End Class