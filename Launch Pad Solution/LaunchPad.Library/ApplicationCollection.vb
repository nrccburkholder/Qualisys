<Serializable()> _
Public Class ApplicationCollection
    Inherits List(Of Application)

    Dim list As List(Of Application)

    Public Shadows Sub Sort()
        Dim comparison As New Comparison(Of Application)(AddressOf CompareApps)
        MyBase.Sort(comparison)
    End Sub


    Private Function CompareApps(ByVal x As Application, ByVal y As Application) As Integer
        If x.CategoryName.CompareTo(y.CategoryName) = 0 Then
            Return x.Name.CompareTo(y.Name)
        Else
            Return x.CategoryName.CompareTo(y.CategoryName)
        End If
    End Function

    Public Function GetCategories() As String()
        Dim list As New List(Of String)

        For Each app As Application In Me
            If Not list.Contains(app.CategoryName) Then
                list.Add(app.CategoryName)
            End If
        Next

        list.Sort()

        Return list.ToArray
    End Function
End Class
