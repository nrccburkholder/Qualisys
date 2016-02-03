Imports Nrc.Framework.BusinessLogic
Imports System.Runtime.Serialization

Public Interface ISPTI_DeDupRule
    Property DeDupRuleID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_DeDupRule
    Inherits BusinessBase(Of SPTI_DeDupRule)
    Implements ISPTI_DeDupRule

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDeDupRuleID As Integer
    Private mFileID As Integer
    Private mName As String = String.Empty
    Private mActiveSI As Boolean    
    Private mDeDupRuleClientIDs As SPTI_DeDupRuleClientIDCollection = Nothing
    Private mDeDupRuleColumnMaps As SPTI_DeDupRuleColumnMapCollection = Nothing
    Private mInitNonPropRule As Boolean    
#End Region

#Region " Public Properties "    
    Public Property DeDupRuleID() As Integer Implements ISPTI_DeDupRule.DeDupRuleID
        Get
            Return mDeDupRuleID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mDeDupRuleID Then
                mDeDupRuleID = value
                PropertyHasChanged("DeDupRuleID")
            End If
        End Set
    End Property
    Public Property FileID() As Integer
        Get
            Return mFileID
        End Get
        Set(ByVal value As Integer)
            If Not value = mFileID Then
                mFileID = value
                PropertyHasChanged("FileID")
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
    Public Property ActiveSI() As Boolean
        Get
            Return mActiveSI
        End Get
        Set(ByVal value As Boolean)
            If Not value = mActiveSI Then
                mActiveSI = value
                PropertyHasChanged("ActiveSI")
            End If
        End Set
    End Property    
    Public Property DeDupRuleClientIDs() As SPTI_DeDupRuleClientIDCollection
        Get
            If Me.mDeDupRuleClientIDs Is Nothing Then
                Me.mDeDupRuleClientIDs = SPTI_DeDupRuleClientID.GetAllByDeDupRuleID(Me.mDeDupRuleID)
                If Me.mDeDupRuleClientIDs Is Nothing OrElse Me.mDeDupRuleClientIDs.Count < 1 Then
                    Me.mDeDupRuleClientIDs = New SPTI_DeDupRuleClientIDCollection
                End If
            End If
            Return Me.mDeDupRuleClientIDs
        End Get
        Set(ByVal value As SPTI_DeDupRuleClientIDCollection)
            Me.mDeDupRuleClientIDs = value
            PropertyHasChanged("DeDupRuleClientIDs")
        End Set
    End Property
    Public Property DeDupRuleColumnMaps() As SPTI_DeDupRuleColumnMapCollection
        Get
            If Me.mDeDupRuleColumnMaps Is Nothing Then
                Me.mDeDupRuleColumnMaps = SPTI_DeDupRuleColumnMap.GetAllByDeDupRuleID(Me.mDeDupRuleID)
                If Me.mDeDupRuleColumnMaps Is Nothing Then
                    Me.mDeDupRuleColumnMaps = New SPTI_DeDupRuleColumnMapCollection
                End If
            End If
            Return Me.mDeDupRuleColumnMaps
        End Get
        Set(ByVal value As SPTI_DeDupRuleColumnMapCollection)
            Me.mDeDupRuleColumnMaps = value
            PropertyHasChanged("DeDupRuleColumnMaps")
        End Set
    End Property
    Public Property InitNonPropRule() As Boolean
        Get
            Return Me.mInitNonPropRule
        End Get
        Set(ByVal value As Boolean)
            Me.mInitNonPropRule = value
            PropertyHasChanged("InitNonPropRule")
        End Set
    End Property    
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSPTI_DeDupRule() As SPTI_DeDupRule
        Return New SPTI_DeDupRule
    End Function

    Public Shared Function [Get](ByVal deDupRuleID As Integer) As SPTI_DeDupRule
        Return DataProviders.SPTI_DeDupRuleProvider.Instance.SelectSPTI_DeDupRule(deDupRuleID)
    End Function

    Public Shared Function GetAll() As SPTI_DeDupRuleCollection
        Return DataProviders.SPTI_DeDupRuleProvider.Instance.SelectAllSPTI_DeDupRules()
    End Function
    Public Shared Function GetByFileID(ByVal FileID As Integer) As SPTI_DeDupRule
        Return DataProviders.SPTI_DeDupRuleProvider.Instance.SelectAllSPTI_DeDupRulesByFileID(FileID)
    End Function
    Public Shared Sub DeleteDeDupRuleAndChildren(ByVal fileID As Integer)
        DataProviders.SPTI_DeDupRuleProvider.Instance.DeleteDeDupRuleAndChildrenByFileID(fileID)
    End Sub
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mDeDupRuleID
        End If
    End Function
#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf NameRule, "Name")
        ValidationRules.AddRule(AddressOf CheckNonPropRules, "InitNonPropRule")
    End Sub
    Public Function CheckNonPropRules(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        'Client rules.
        If Me.mDeDupRuleClientIDs Is Nothing OrElse Me.mDeDupRuleClientIDs.Count < 1 Then
            e.Description = "No Client IDs were chosen for De-Dup Rule."
            Return False
        End If
        Dim tempClients As ExportClientAvailableCollection = ExportClientAvailable.GetAllClientList
        Dim blnFound As Boolean = False
        For Each client As SPTI_DeDupRuleClientID In Me.mDeDupRuleClientIDs
            For Each tempClient As ExportClientAvailable In tempClients
                If client.ClientID = tempClient.ClientID Then
                    blnFound = True
                    Exit For
                End If
            Next
            If Not blnFound Then
                Exit For
            End If
        Next
        If Not blnFound Then
            e.Description = "One of the selected Clients does no exist in the data source."
            Return False
        End If
        'Check Column map rules.
        If Me.mDeDupRuleColumnMaps Is Nothing OrElse Me.mDeDupRuleColumnMaps.Count < 1 Then
            e.Description = "No Selections made for Column Mapping."
            Return False
        End If
        'Check for Redundant values.
        Dim qmsVal As Integer = 0
        Dim sourceTempVal As Integer = 0
        For Each outValue As SPTI_DeDupRuleColumnMap In Me.mDeDupRuleColumnMaps
            For Each inValue As SPTI_DeDupRuleColumnMap In Me.mDeDupRuleColumnMaps
                If outValue.QMSColumnName = inValue.QMSColumnName Then
                    qmsVal += 1
                End If
                If outValue.FileTemplateColumnName = inValue.FileTemplateColumnName Then
                    sourceTempVal += 1
                End If
            Next
            If qmsVal <> 1 OrElse sourceTempVal <> 1 Then
                Exit For
            Else
                qmsVal = 0 'ReInit
                sourceTempVal = 0 'ReInit
            End If
        Next
        If qmsVal > 1 OrElse sourceTempVal > 1 Then
            e.Description = "Redundant values were found in the column mapping."
            Return False
        End If
        Return True
    End Function
    Public Function NameRule(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.mName = "" Then
            e.Description = "De-Dup Rule must have a name."
            Return False
        End If
        Return True
    End Function

    Public Function ValidateAll() As Validation.BrokenRulesCollection
        Me.InitNonPropRule = True
        If Not Me.IsValid Then
            Return Me.BrokenRulesCollection
        End If
        Return Nothing
    End Function
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        DeDupRuleID = DataProviders.SPTI_DeDupRuleProvider.Instance.InsertSPTI_DeDupRule(Me)
    End Sub

    Protected Overrides Sub Update()
        'DataProviders.SPTI_DeDupRuleProvider.Instance.UpdateSPTI_DeDupRule(Me)
        Throw New NotImplementedException("Update method has not been implemented.")
    End Sub

    Protected Overrides Sub DeleteImmediate()
        'DataProviders.SPTI_DeDupRuleProvider.Instance.DeleteSPTI_DeDupRule(mDeDupRuleID)
        Throw New NotImplementedException("Delete method has not been implemented.")
    End Sub
    Public Overrides Sub Save()
        'MyBase.Save()
        'Parent Removes all prior to save, add insert is only save functionality here.
        Insert()
        If Not Me.mDeDupRuleClientIDs Is Nothing Then
            For Each clientid As SPTI_DeDupRuleClientID In Me.mDeDupRuleClientIDs
                clientid.DeDupRuleID = Me.mDeDupRuleID
            Next
            Me.mDeDupRuleClientIDs.Save()
        End If
        If Not Me.mDeDupRuleColumnMaps Is Nothing Then
            For Each colMap As SPTI_DeDupRuleColumnMap In Me.mDeDupRuleColumnMaps
                colMap.DeDupRuleID = Me.mDeDupRuleID
            Next
            Me.mDeDupRuleColumnMaps.Save()
        End If
    End Sub
#End Region

#Region " Public Methods "    
#End Region

End Class
