Option Explicit On 
Option Strict On

Imports System.Windows.Forms

Namespace WinForms

    Public Class ListViewItemComparer
        Implements IComparer

        Private mSortCriteria As ListViewSortCriteria

        Sub New(ByVal sortCriteria As ListViewSortCriteria)
            Me.mSortCriteria = sortCriteria
        End Sub


        Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer Implements System.Collections.IComparer.Compare
            Dim item1 As ListViewItem
            Dim item2 As ListViewItem

            If (Me.mSortCriteria.SortOrder = SortOrder.Ascend) Then
                item1 = CType(x, ListViewItem)
                item2 = CType(y, ListViewItem)
            Else
                item1 = CType(y, ListViewItem)
                item2 = CType(x, ListViewItem)
            End If

            Select Case Me.mSortCriteria.DataType
                Case DataType._Unknown, DataType._String
                    Return CompareByString(item1, item2)
                Case DataType._Integer
                    Return CompareByInteger(item1, item2)
                Case DataType._Date
                    Return CompareByDate(item1, item2)
            End Select
        End Function

        Private Function CompareByString(ByVal item1 As ListViewItem, ByVal item2 As ListViewItem) As Integer
            Dim index As Integer = Me.mSortCriteria.SortColumn
            Return String.Compare(item1.SubItems(index).Text, item2.SubItems(index).Text)
        End Function

        Private Function CompareByInteger(ByVal item1 As ListViewItem, ByVal item2 As ListViewItem) As Integer
            Dim index As Integer = Me.mSortCriteria.SortColumn
            Try
                Return Math.Sign(CLng(item1.SubItems(index).Text) - CLng(item2.SubItems(index).Text))
            Catch ex As Exception
                Return String.Compare(item1.SubItems(index).Text, item2.SubItems(index).Text)
            End Try
        End Function

        Private Function CompareByDate(ByVal item1 As ListViewItem, ByVal item2 As ListViewItem) As Integer
            Dim index As Integer = Me.mSortCriteria.SortColumn
            Try
                Return Date.Compare(Date.Parse(item1.SubItems(index).Text), Date.Parse(item2.SubItems(index).Text))
            Catch ex As Exception
                Return String.Compare(item1.SubItems(index).Text, item2.SubItems(index).Text)
            End Try
        End Function

    End Class

End Namespace
