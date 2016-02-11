Imports System.ComponentModel

Public Class BusinessListBase(Of T As BusinessBase(Of T))
    Inherits System.ComponentModel.BindingList(Of T)

    Private mdeletedItems As New List(Of T)

    Protected Overrides Sub RemoveItem(ByVal index As Integer)
        Me(index).MarkDeleted()
        mdeletedItems.Add(Me(index))
        MyBase.RemoveItem(index)
    End Sub
    Public Overridable Sub Save()
        For Each Item As T In Me
            If Item.IsValid Then
                Item.Save()
            End If
        Next
        If Me.mdeletedItems.Count > 0 Then
            For i As Integer = (Me.mdeletedItems.Count - 1) To 0
                Me.mdeletedItems(i).Save()
                Me.RemoveAt(i)
            Next
        End If
    End Sub
End Class
