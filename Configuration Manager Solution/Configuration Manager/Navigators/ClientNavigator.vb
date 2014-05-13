Imports Nrc.Qualisys.Library

Public Class ClientNavigator

#Region " Public Events "

    Public Event FacilityViewModeChanged As EventHandler(Of FacilityViewModeChangedEventArgs)

#End Region

#Region " Private Members "

    Private mNavigationTree As Navigation.NavigationTree
    Private mSection As Section
    Private mSelectedIndex As Integer
    Private mTrackChanges As Boolean = True
    Private mIsLoading As Boolean = False

#End Region

#Region " Public Properties "

    Public ReadOnly Property SelectedClient() As Client
        Get
            If FacilityClientTSButton.Checked Then
                'Get a reference to the currently selected client navigation object
                Dim navClient As Navigation.ClientNavNode = TryCast(ClientList.Items(mSelectedIndex), Navigation.ClientNavNode)
                If navClient IsNot Nothing Then
                    'Return the client object that this client navigation object refers to
                    Return navClient.GetClient
                Else
                    'Must be something wrong with the selected item list
                    Return Nothing
                End If
            Else
                'We are in show all mode so return nothing
                Return Nothing
            End If
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal navTree As Navigation.NavigationTree)

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call.
        mNavigationTree = navTree

    End Sub

#End Region

#Region " Overrides "

    Public Overrides Sub RegisterSectionControl(ByVal sect As Section)

        mSection = sect

    End Sub

#End Region

#Region " Event Handlers "

    Private Sub ClientNavigator_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Initialize the client list
        mIsLoading = True
        ClientList.DataSource = mNavigationTree.Clients
        ClientList.DisplayMember = "DisplayLabel"
        ClientList.ValueMember = "Id"
        mIsLoading = False
        SetViewMode(FacilitySection.DataViewMode.AllFacilities)

    End Sub


    Private Sub ClientList_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClientList.SelectedValueChanged

        If Not mIsLoading Then SelectedClientChanged()

    End Sub


    Private Sub FacilityClientTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FacilityClientTSButton.Click

        'Check to see if we can change views
        If Not mSection.AllowInactivate Then Exit Sub

        'Set the display mode
        SetViewMode(FacilitySection.DataViewMode.ClientFacilities)

    End Sub


    Private Sub FacilityAllTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FacilityAllTSButton.Click

        'Check to see if we can change views
        If Not mSection.AllowInactivate Then Exit Sub

        'Set the display mode
        SetViewMode(FacilitySection.DataViewMode.AllFacilities)

    End Sub

#End Region

#Region " Protected Methods "

    Protected Sub OnFacilityViewModeChanged(ByVal e As FacilityViewModeChangedEventArgs)

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        'Raise the event to whomever is listening
        RaiseEvent FacilityViewModeChanged(Me, e)

        'Reset the wait cursor
        Me.Cursor = Cursors.Default

    End Sub

#End Region

#Region " Private Methods "

    Private Sub SetViewMode(ByVal viewMode As FacilitySection.DataViewMode)

        'Update the button selection
        FacilityClientTSButton.Checked = (viewMode = FacilitySection.DataViewMode.ClientFacilities)
        FacilityAllTSButton.Checked = (viewMode = FacilitySection.DataViewMode.AllFacilities)

        'Determine if we need the client list box
        ClientList.Enabled = (viewMode = FacilitySection.DataViewMode.ClientFacilities)

        'Fire the event so the FacilitySection can deal with the change
        Dim eArgs As FacilityViewModeChangedEventArgs = New FacilityViewModeChangedEventArgs(viewMode)
        OnFacilityViewModeChanged(eArgs)

    End Sub


    Private Sub UndoClientSelection()

        'Reset the selected index to it's previous value
        mTrackChanges = False
        ClientList.SelectedIndex = mSelectedIndex
        mTrackChanges = True

    End Sub


    Private Sub SelectedClientChanged()

        'The user has selected a different client
        If mTrackChanges AndAlso ClientList.SelectedIndex > -1 Then
            If mSection.AllowInactivate Then
                'Save the currently selected index
                mSelectedIndex = ClientList.SelectedIndex

                'Raise the event
                Dim eArgs As FacilityViewModeChangedEventArgs = New FacilityViewModeChangedEventArgs(FacilitySection.DataViewMode.ClientFacilities)
                OnFacilityViewModeChanged(eArgs)
            Else
                UndoClientSelection()
            End If
        End If

    End Sub

#End Region

    
End Class
