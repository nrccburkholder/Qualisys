Public Class BusinessCollection(Of T)
    Inherits ObjectModel.Collection(Of T)

    Private mIsLoading As Boolean
    Private mAddedItems As New ObjectModel.Collection(Of T)
    Private mDeletedItems As New ObjectModel.Collection(Of T)


#Region " ItemAdded Event "
    Public Event ItemAdded As EventHandler(Of ItemAddedEventArgs(Of T))
    Protected Overridable Sub OnItemAdded(ByVal e As ItemAddedEventArgs(Of T))
        RaiseEvent ItemAdded(Me, e)
    End Sub
#End Region

#Region " ItemRemoved Event "
    Public Event ItemRemoved As EventHandler(Of ItemRemovedEventArgs(Of T))
    Protected Overridable Sub OnItemRemoved(ByVal e As ItemRemovedEventArgs(Of T))
        RaiseEvent ItemRemoved(Me, e)
    End Sub
#End Region

#Region " ItemsCleared Event "
    Public Event ItemsCleared As EventHandler
    Protected Overridable Sub OnItemsCleared(ByVal e As EventArgs)
        RaiseEvent ItemsCleared(Me, e)
    End Sub
#End Region

#Region " Public Properties "
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return (Not mIsLoading AndAlso (mAddedItems.Count > 0 OrElse mDeletedItems.Count > 0))
        End Get
    End Property

    Public ReadOnly Property AddedItems() As ObjectModel.Collection(Of T)
        Get
            Return mAddedItems
        End Get
    End Property

    Public ReadOnly Property DeletedItems() As ObjectModel.Collection(Of T)
        Get
            Return mDeletedItems
        End Get
    End Property

#End Region

#Region " Base Class Overrides "
    Protected Overrides Sub ClearItems()
        'Verify that there are any items to clear
        If Me.Count > 0 Then

            If Not mIsLoading Then
                'Record each item as removed
                For Each item As T In Me.Items
                    Me.RecordItemRemoval(item)
                Next
            End If

            'Call the clear method
            MyBase.ClearItems()

            'Raise event if not in load mode
            If Not mIsLoading Then Me.OnItemsCleared(EventArgs.Empty)
        End If
    End Sub

    Protected Overrides Sub RemoveItem(ByVal index As Integer)
        'Store the item
        Dim removedItem As T = Me.Item(index)

        'Call the remove
        MyBase.RemoveItem(index)

        If Not mIsLoading Then
            'Record removal
            Me.RecordItemRemoval(removedItem)

            'Raise the event
            Me.OnItemRemoved(New ItemRemovedEventArgs(Of T)(removedItem))
        End If
    End Sub


    Protected Overrides Sub SetItem(ByVal index As Integer, ByVal item As T)
        If Not mIsLoading Then
            Dim oldItem As T = Me.Item(index)
            Dim newItem As T = item

            'Record removal and addition
            Me.RecordItemRemoval(oldItem)
            Me.RecordItemAddition(newItem)

            'Raise both events
            Me.OnItemRemoved(New ItemRemovedEventArgs(Of T)(oldItem))
            Me.OnItemAdded(New ItemAddedEventArgs(Of T)(newItem))
        End If

        'Perform set
        MyBase.SetItem(index, item)
    End Sub

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As T)
        'Perform insert
        MyBase.InsertItem(index, item)

        If Not mIsLoading Then
            'Record addition
            Me.RecordItemAddition(item)

            'Raise event
            Me.OnItemAdded(New ItemAddedEventArgs(Of T)(item))
        End If

    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>
    ''' Begins the initial loading of the collection without tracking changes
    ''' </summary>
    Public Overridable Sub BeginLoad()
        mIsLoading = True
        Me.mAddedItems.Clear()
        Me.mDeletedItems.Clear()
    End Sub

    ''' <summary>
    ''' Completes the initial loading of the collection and after EndLoad() is called changes will be tracked
    ''' </summary>
    ''' <remarks></remarks>
    Public Overridable Sub EndLoad()
        mIsLoading = False
        Me.mAddedItems.Clear()
        Me.mDeletedItems.Clear()
    End Sub

    ''' <summary>
    ''' Resets the dirty flag on the collection and removes the history of added and removed items
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub CommitChanges()
        Me.mAddedItems.Clear()
        Me.mDeletedItems.Clear()
    End Sub
#End Region


#Region " Private Methods "
    Private Sub RecordItemRemoval(ByVal item As T)
        If mAddedItems.Contains(item) Then
            mAddedItems.Remove(item)
        ElseIf Not mDeletedItems.Contains(item) Then
            mDeletedItems.Add(item)
        End If
    End Sub

    Private Sub RecordItemAddition(ByVal item As T)
        If mDeletedItems.Contains(item) Then
            mDeletedItems.Remove(item)
        ElseIf Not mAddedItems.Contains(item) Then
            mAddedItems.Add(item)
        End If
    End Sub
#End Region


End Class

Public Class ItemAddedEventArgs(Of T)
    Inherits EventArgs
    Private mNewItem As T

    Public ReadOnly Property NewItem() As T
        Get
            Return mNewItem
        End Get
    End Property

    Public Sub New(ByVal newItem As T)
        mNewItem = newItem
    End Sub
End Class

Public Class ItemRemovedEventArgs(Of T)
    Inherits EventArgs
    Private mOldItem As T

    Public ReadOnly Property OldItem() As T
        Get
            Return mOldItem
        End Get
    End Property

    Public Sub New(ByVal oldItem As T)
        mOldItem = OldItem
    End Sub
End Class
