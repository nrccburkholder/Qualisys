''' <summary>
''' A collection of privilege objects
''' </summary>
<Serializable()> _
Public Class PrivilegeCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Privilege
        Get
            Return DirectCast(MyBase.List(index), Privilege)
        End Get
    End Property

    Default Public ReadOnly Property Item(ByVal privilegeName As String) As Privilege
        Get
            For Each priv As Privilege In MyBase.List
                If privilegeName.ToLower = priv.Name.ToLower Then
                    Return priv
                End If
            Next

            Return Nothing
        End Get
    End Property

    Public Function Add(ByVal priv As Privilege) As Integer
        Return MyBase.List.Add(priv)
    End Function

End Class


'<Serializable()> _
'Public Class PrivilegeCollection
'    Inherits DictionaryBase

'    Default Public ReadOnly Property Item(ByVal privilegeName As String) As Privilege
'        Get
'            Return DirectCast(MyBase.Dictionary(privilegeName), Privilege)
'        End Get
'    End Property

'    Public Sub Add(ByVal priv As Privilege)
'        MyBase.Dictionary.Add(priv.Name, priv)
'    End Sub

'    Public ReadOnly Property Keys() As ICollection
'        Get
'            Return MyBase.Dictionary.Keys
'        End Get
'    End Property

'End Class