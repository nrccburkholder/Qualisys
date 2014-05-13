Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class LoadToLiveLookupCollection
    Inherits BusinessListBase(Of LoadToLiveLookupCollection, LoadToLiveLookup)

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As LoadToLiveLookup = LoadToLiveLookup.NewLoadToLiveLookup
        Add(newObj)
        Return newObj

    End Function

    Public Function GetLookupsByMasterTableName(ByVal masterTable As String) As LoadToLiveLookupCollection

        Dim lookups As New LoadToLiveLookupCollection

        For Each lookup As LoadToLiveLookup In Me
            If lookup.MasterTableName.ToUpper = masterTable.ToUpper Then
                lookups.Add(lookup)
            End If
        Next

        Return lookups

    End Function

    Public Function GetMasterTableList() As List(Of String)

        Dim tables As New List(Of String)

        For Each lookup As LoadToLiveLookup In Me
            If lookup.MasterTableName.ToUpper = "POPULATION" OrElse lookup.MasterTableName.ToUpper = "ENCOUNTER" Then
                If Not tables.Contains(lookup.MasterTableName.ToUpper) Then
                    tables.Add(lookup.MasterTableName.ToUpper)
                End If
            End If
        Next

        Return tables

    End Function

End Class

