Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_DeDupRuleColumnMap
    Property ID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_DeDupRuleColumnMap
    Inherits BusinessBase(Of SPTI_DeDupRuleColumnMap)
    Implements ISPTI_DeDupRuleColumnMap

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mID As Integer
    Private mDeDupRuleID As Integer
    Private mQMSColumnName As String = String.Empty
    Private mFileTemplateColumnName As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property ID() As Integer Implements ISPTI_DeDupRuleColumnMap.ID
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
    Public Property QMSColumnName() As String
        Get
            Return mQMSColumnName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mQMSColumnName Then
                mQMSColumnName = value
                PropertyHasChanged("QMSColumnName")
            End If
        End Set
    End Property
    Public Property FileTemplateColumnName() As String
        Get
            Return mFileTemplateColumnName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileTemplateColumnName Then
                mFileTemplateColumnName = value
                PropertyHasChanged("FileTemplateColumnName")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
    Private Sub New(ByVal templateColName As String, ByVal qmsColName As String)
        Me.mFileTemplateColumnName = templateColName
        Me.mQMSColumnName = qmsColName
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSPTI_DeDupRuleColumnMap() As SPTI_DeDupRuleColumnMap
        Return New SPTI_DeDupRuleColumnMap
    End Function
    Public Shared Function NewSPTI_DeDupRuleColumnMap(ByVal templateColName As String, ByVal qmsColName As String) As SPTI_DeDupRuleColumnMap
        Return New SPTI_DeDupRuleColumnMap(templateColName, qmsColName)
    End Function

    Public Shared Function [Get](ByVal iD As Integer) As SPTI_DeDupRuleColumnMap
        Return DataProviders.SPTI_DeDupRuleColumnMapProvider.Instance.SelectSPTI_DeDupRuleColumnMap(iD)
    End Function

    Public Shared Function GetAll() As SPTI_DeDupRuleColumnMapCollection
        Return DataProviders.SPTI_DeDupRuleColumnMapProvider.Instance.SelectAllSPTI_DeDupRuleColumnMaps()
    End Function
    Public Shared Function GetAllByDeDupRuleID(ByVal deDupRuleID As Integer) As SPTI_DeDupRuleColumnMapCollection
        Return DataProviders.SPTI_DeDupRuleColumnMapProvider.Instance.SelectAllSPTI_DeDupRuleColumnMapsByDeDupRuleID(deDupRuleID)
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
        ID = DataProviders.SPTI_DeDupRuleColumnMapProvider.Instance.InsertSPTI_DeDupRuleColumnMap(Me)
    End Sub

    Protected Overrides Sub Update()
        'DataProviders.SPTI_DeDupRuleColumnMapProvider.Instance.UpdateSPTI_DeDupRuleColumnMap(Me)
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub

    Protected Overrides Sub DeleteImmediate()
        'DataProviders.SPTI_DeDupRuleColumnMapProvider.Instance.DeleteSPTI_DeDupRuleColumnMap(mID)
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub
    Public Overrides Sub Save()
        Insert()
    End Sub
#End Region

#Region " Public Methods "

#End Region

End Class