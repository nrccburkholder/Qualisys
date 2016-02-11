Namespace WinForms
    Public Class MultiPaneTabCollection
        Inherits System.Collections.ObjectModel.Collection(Of MultiPaneTab)

        Private mSelectedTab As MultiPaneTab

        Public Event TabAdded As EventHandler '(Of TabAddedEventArgs)
        Public Event TabRemoved As EventHandler
        Public Event SelectedTabChanging As EventHandler(Of SelectedTabChangingEventArgs)
        Public Event SelectedTabChanged As EventHandler(Of SelectedTabChangedEventArgs)

        Public Property SelectedTab() As MultiPaneTab
            Get
                Return mSelectedTab
            End Get
            Set(ByVal value As MultiPaneTab)
                Me.ChangeSelectedTab(value, False)
            End Set
        End Property

        Public Property SelectedTabIndex() As Integer
            Get
                If mSelectedTab Is Nothing Then
                    Return -1
                Else
                    Return IndexOf(mSelectedTab)
                End If
            End Get
            Set(ByVal value As Integer)
                If value < 0 OrElse value > Me.Count - 1 Then
                    Throw New ArgumentOutOfRangeException("value", "Index must be non-negative and less than the maximum index value.")
                End If
                Me.SelectedTab = Item(value)
            End Set
        End Property

        Private Function ChangeSelectedTab(ByVal newTab As MultiPaneTab, ByVal allowNull As Boolean) As Boolean
            If Not allowNull AndAlso newTab Is Nothing Then
                Throw New ArgumentNullException("newTab", "The selected tab cannot be nothing.")
            End If
            If newTab IsNot Nothing AndAlso Not Me.Contains(newTab) Then
                Throw New ArgumentException("The tab cannot be selected because it does not belong to the collection.")
            End If
            If newTab IsNot mSelectedTab Then
                Dim oldTab As MultiPaneTab = mSelectedTab
                Dim e As New SelectedTabChangingEventArgs(oldTab, newTab)
                If oldTab IsNot Nothing Then
                    Me.OnSelectedTabChanging(Me, e)
                End If
                If Not e.Cancel Then
                    If oldTab IsNot Nothing Then
                        oldTab.IsActive = False
                    End If
                    If newTab IsNot Nothing Then
                        newTab.IsActive = True
                    End If
                    mSelectedTab = newTab
                    Me.OnSelectedTabChanged(Me, New SelectedTabChangedEventArgs(oldTab, newTab))
                    Return True
                Else
                    Return False
                End If
            End If

        End Function

        Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As MultiPaneTab)
            MyBase.InsertItem(index, item)
            AddHandler item.Click, AddressOf TabClickHandler
            Me.OnTabAdded(Me, New EventArgs)

            If Me.Count = 1 Then
                Me.SelectedTab = item
            Else
                item.IsActive = False
            End If
        End Sub
        Protected Overrides Sub RemoveItem(ByVal index As Integer)
            If index < 0 OrElse index > Me.Count - 1 Then
                Throw New ArgumentOutOfRangeException("index", "Index must be non-negative and less than the total list count.")
            End If
            Dim canRemove As Boolean = True
            If index = Me.SelectedTabIndex Then
                Dim newTab As MultiPaneTab = Nothing
                If Me.Count > 1 Then
                    If index = 0 Then
                        newTab = Item(1)
                    Else
                        newTab = Item(0)
                    End If
                End If
                canRemove = Me.ChangeSelectedTab(newTab, True)
            End If
            If canRemove Then
                RemoveHandler Item(index).Click, AddressOf TabClickHandler
                MyBase.RemoveItem(index)
                Me.OnTabRemoved(Me, New EventArgs)
            End If
        End Sub

        Protected Sub OnTabAdded(ByVal sender As Object, ByVal e As EventArgs)
            RaiseEvent TabAdded(sender, e)
        End Sub
        Protected Sub OnTabRemoved(ByVal sender As Object, ByVal e As EventArgs)
            RaiseEvent TabRemoved(sender, e)
        End Sub

        Protected Sub OnSelectedTabChanging(ByVal sender As Object, ByVal e As SelectedTabChangingEventArgs)
            RaiseEvent SelectedTabChanging(sender, e)
        End Sub
        Protected Sub OnSelectedTabChanged(ByVal sender As Object, ByVal e As SelectedTabChangedEventArgs)
            RaiseEvent SelectedTabChanged(sender, e)
        End Sub

        Private Sub TabClickHandler(ByVal sender As Object, ByVal e As EventArgs)
            Dim tab As MultiPaneTab = TryCast(sender, MultiPaneTab)
            If tab IsNot Nothing Then
                If tab IsNot mSelectedTab Then
                    Me.SelectedTab = tab
                End If
            End If
        End Sub

    End Class


End Namespace
