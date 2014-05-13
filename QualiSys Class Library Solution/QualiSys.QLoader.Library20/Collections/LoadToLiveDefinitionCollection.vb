Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class LoadToLiveDefinitionCollection
	Inherits BusinessListBase(Of LoadToLiveDefinitionCollection , LoadToLiveDefinition)
	
    Protected Overrides Function AddNewCore() As Object

        Dim newObj As  LoadToLiveDefinition = LoadToLiveDefinition.NewLoadToLiveDefinition
        Add(newObj)
        Return newObj

    End Function

    Public Function GetMatchFieldsByTableName(ByVal tableName As String) As List(Of String)

        Dim matchFields As New List(Of String)

        For Each def As LoadToLiveDefinition In Me
            If def.TableName.ToUpper = tableName.ToUpper Then
                If def.IsMatchField Then
                    matchFields.Add(def.FieldName.ToUpper)
                End If
            End If
        Next

        Return matchFields

    End Function

    Public Function GetUpdateFieldsByTableName(ByVal tableName As String) As List(Of String)

        Dim updateFields As New List(Of String)

        For Each def As LoadToLiveDefinition In Me
            If def.TableName.ToUpper = tableName.ToUpper Then
                If Not def.IsMatchField Then
                    updateFields.Add(def.FieldName.ToUpper)
                End If
            End If
        Next

        Return updateFields

    End Function

    Public Function GetTableList() As List(Of String)

        Dim tables As New List(Of String)

        For Each def As LoadToLiveDefinition In Me
            If Not tables.Contains(def.TableName.ToUpper) Then
                tables.Add(def.TableName.ToUpper)
            End If
        Next

        Return tables

    End Function

End Class

