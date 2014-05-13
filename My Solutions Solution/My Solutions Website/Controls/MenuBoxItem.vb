Public MustInherit Class MenuBoxItem
    Inherits WebControl

    Protected Function GetMenuBox() As MenuBox
        Dim parent As Control = Me.Parent
        Do Until parent Is Nothing
            Dim mb As MenuBox = TryCast(parent, MenuBox)
            If mb IsNot Nothing Then Return mb
            parent = parent.Parent
        Loop
        Return Nothing
    End Function

End Class