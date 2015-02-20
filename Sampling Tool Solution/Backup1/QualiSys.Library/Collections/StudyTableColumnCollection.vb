Public Class StudyTableColumnCollection
    Inherits Collection(Of StudyTableColumn)

    Private mIsDirty As Boolean
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As StudyTableColumn)
        MyBase.InsertItem(index, item)
        Me.mIsDirty = True
    End Sub

    Protected Overrides Sub ClearItems()
        MyBase.ClearItems()
        Me.mIsDirty = True
    End Sub

    Protected Overrides Sub RemoveItem(ByVal index As Integer)
        MyBase.RemoveItem(index)
        Me.mIsDirty = True
    End Sub

    Protected Overrides Sub SetItem(ByVal index As Integer, ByVal item As StudyTableColumn)
        MyBase.SetItem(index, item)
        Me.mIsDirty = True
    End Sub

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
End Class
