Public Class NrcNavBar
    Inherits DevExpress.XtraNavBar.NavBarControl
    Public Sub New()
        MyBase.New()

    End Sub

#Region " SelectedTabChanging Event "
    Public Class SelectedTabChangingEventArgs
        Inherits System.ComponentModel.CancelEventArgs

        Private mOldGroup As DevExpress.XtraNavBar.NavBarGroup
        Private mNewGroup As DevExpress.XtraNavBar.NavBarGroup

        Public ReadOnly Property OldGroup() As DevExpress.XtraNavBar.NavBarGroup
            Get
                Return mOldGroup
            End Get
        End Property
        Public ReadOnly Property NewGroup() As DevExpress.XtraNavBar.NavBarGroup
            Get
                Return mNewGroup
            End Get
        End Property

        Public Sub New(ByVal oldGroup As DevExpress.XtraNavBar.NavBarGroup, ByVal newGroup As DevExpress.XtraNavBar.NavBarGroup)
            mOldGroup = oldGroup
            mNewGroup = newGroup
        End Sub
    End Class
    Public Event SelectedTabChanging As EventHandler(Of SelectedTabChangingEventArgs)
    Protected Overridable Sub OnSelectedTabChanging(ByVal e As SelectedTabChangingEventArgs)
        RaiseEvent SelectedTabChanging(Me, e)
    End Sub
#End Region

#Region " SelectedTabChanged Event "
    Public Class SelectedTabChangedEventArgs
        Inherits System.EventArgs

        Private mOldGroup As DevExpress.XtraNavBar.NavBarGroup
        Private mNewGroup As DevExpress.XtraNavBar.NavBarGroup

        Public ReadOnly Property OldGroup() As DevExpress.XtraNavBar.NavBarGroup
            Get
                Return mOldGroup
            End Get
        End Property
        Public ReadOnly Property NewGroup() As DevExpress.XtraNavBar.NavBarGroup
            Get
                Return mNewGroup
            End Get
        End Property

        Public Sub New(ByVal oldGroup As DevExpress.XtraNavBar.NavBarGroup, ByVal newGroup As DevExpress.XtraNavBar.NavBarGroup)
            mOldGroup = oldGroup
            mNewGroup = newGroup
        End Sub
    End Class
    Public Event SelectedTabChanged As EventHandler(Of SelectedTabChangedEventArgs)
    Protected Overridable Sub OnSelectedTabChanged(ByVal e As SelectedTabChangedEventArgs)
        RaiseEvent SelectedTabChanged(Me, e)
    End Sub
#End Region


    Private mGroupChanging As Boolean
    Private mCurrentGroup As DevExpress.XtraNavBar.NavBarGroup

    Private Sub NrcNavBar_ActiveGroupChanged(ByVal sender As Object, ByVal e As DevExpress.XtraNavBar.NavBarGroupEventArgs) Handles Me.ActiveGroupChanged
        If mGroupChanging Then
            Exit Sub
        End If

        If mCurrentGroup IsNot Nothing Then
            mGroupChanging = True
            Dim oldGroup As DevExpress.XtraNavBar.NavBarGroup = mCurrentGroup
            Dim newGroup As DevExpress.XtraNavBar.NavBarGroup = e.Group

            'Go back to old group
            Me.ActiveGroup = oldGroup

            Dim cancelArgs As New SelectedTabChangingEventArgs(oldGroup, newGroup)
            Me.OnSelectedTabChanging(cancelArgs)

            If Not cancelArgs.Cancel Then
                Me.ActiveGroup = newGroup
                Dim changedArgs As New SelectedTabChangedEventArgs(oldGroup, newGroup)
                Me.OnSelectedTabChanged(changedArgs)
            End If

            mGroupChanging = False
        End If

        mCurrentGroup = Me.ActiveGroup
    End Sub
End Class