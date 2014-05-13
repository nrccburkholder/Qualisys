Imports NRC.Data

<Serializable()> _
Public Class OrgUnitCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As OrgUnit
        Get
            Return DirectCast(MyBase.List(index), OrgUnit)
        End Get
    End Property

    Public Function Add(ByVal ou As OrgUnit) As Integer
        Return MyBase.List.Add(ou)
    End Function

    ''' <summary>
    ''' Gets the collection of OrgUnits that are children of the specified OrgUnit
    ''' </summary>
    Public Shared Function GetOrgUnitChildren(ByVal orgUnitId As Integer) As OrgUnitCollection
        Dim rdr As IDataReader = DAL.SelectOrgUnitChildren(orgUnitId)
        Dim units As IList
        units = New OrgUnitCollection
        Return DirectCast(Populator.FillCollection(rdr, GetType(OrgUnit), units), OrgUnitCollection)
    End Function

End Class
'<Serializable()> _
'Public Class OrgUnitCollection
'    Inherits DictionaryBase

'    Default Public ReadOnly Property Item(ByVal orgUnitName As String) As OrgUnit
'        Get
'            Return DirectCast(MyBase.Dictionary(orgUnitName), OrgUnit)
'        End Get
'    End Property

'    Public Sub Add(ByVal ou As OrgUnit)
'        MyBase.Dictionary.Add(ou.Name, ou)
'    End Sub

'    Public ReadOnly Property Keys() As ICollection
'        Get
'            Return MyBase.Dictionary.Keys
'        End Get
'    End Property


'End Class
