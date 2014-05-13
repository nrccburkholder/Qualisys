Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class LoadToLiveLookup
    Inherits BusinessBase(Of LoadToLiveLookup)

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMasterTableName As String = String.Empty
    Private mMasterFieldName As String = String.Empty
    Private mLookupTableName As String = String.Empty
    Private mLookupFieldName As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property MasterTableName() As String
        Get
            Return mMasterTableName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMasterTableName Then
                mMasterTableName = value
                PropertyHasChanged("MasterTableName")
            End If
        End Set
    End Property

    Public Property MasterFieldName() As String
        Get
            Return mMasterFieldName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMasterFieldName Then
                mMasterFieldName = value
                PropertyHasChanged("MasterFieldName")
            End If
        End Set
    End Property

    Public Property LookupTableName() As String
        Get
            Return mLookupTableName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLookupTableName Then
                mLookupTableName = value
                PropertyHasChanged("LookupTableName")
            End If
        End Set
    End Property

    Public Property LookupFieldName() As String
        Get
            Return mLookupFieldName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLookupFieldName Then
                mLookupFieldName = value
                PropertyHasChanged("LookupFieldName")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewLoadToLiveLookup() As LoadToLiveLookup

        Return New LoadToLiveLookup

    End Function

    Public Shared Function GetByStudyIDTableName(ByVal studyID As Integer, ByVal lookupTableName As String) As LoadToLiveLookupCollection

        Return LoadToLiveLookupProvider.Instance.SelectLoadToLiveLookupsByStudyIDTableName(studyID, lookupTableName)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        Return mInstanceGuid

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


