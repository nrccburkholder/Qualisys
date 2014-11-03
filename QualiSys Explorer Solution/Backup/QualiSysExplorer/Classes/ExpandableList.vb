Imports System.ComponentModel

' ExpandableList is the generic implementation of the "Outlook" style list in the
' middle pane of IssueVision
Public Class ExpandableList
    Inherits System.Windows.Forms.UserControl

    ' events
    Public Event DrawItem(ByVal sender As Object, ByVal e As DrawItemEventArgs, ByVal dr As DataRowView)
    Public Event SelectionChanged(ByVal dr As DataRowView)
    Public Event SelectionDoubleClicked(ByVal dr As DataRowView)

    ' internal members
    Private m_dataSource As DataView
    Private m_groupList As New GroupItemCollection
    Private m_itemHeight As Integer = SectionControl.DefaultItemHeight

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

        ' turn on double buffering
        Me.SetStyle(ControlStyles.DoubleBuffer Or _
         ControlStyles.UserPaint Or ControlStyles.ResizeRedraw Or _
         ControlStyles.AllPaintingInWmPaint, True)
    End Sub

    <Category("Data"), DefaultValue(GetType(DataView), Nothing)> _
    Public Property DataSource() As DataView
        Get
            Return m_dataSource
        End Get
        Set(ByVal Value As DataView)
            m_dataSource = Value
        End Set
    End Property

    <Category("Data"), _
    DesignerSerializationVisibility(DesignerSerializationVisibility.Content)> _
    Public ReadOnly Property GroupList() As GroupItemCollection
        Get
            Return m_groupList
        End Get
    End Property

    <Category("Layout"), DefaultValue(SectionControl.DefaultItemHeight)> _
    Public Property ItemHeight() As Integer
        Get
            Return m_itemHeight
        End Get
        Set(ByVal Value As Integer)
            m_itemHeight = Value
        End Set
    End Property

    ' Call this method after modifying any of the above three properties to
    ' rerender this ExpandableList.
    Public Sub LayoutSections()
        SuspendLayout()

        Do While Controls.Count > 0
            RemoveDrawItemHandler(Controls.Item(0))
            Controls.RemoveAt(0)
        Loop

        Dim sc As SectionControl
        Dim al As New ArrayList

        If Not m_groupList Is Nothing Then
            For Each gi As GroupItem In m_groupList
                Dim sp As New Splitter
                sp.BackColor = SystemColors.Window
                sp.Dock = DockStyle.Top
                sp.Enabled = False
                sp.Height = 2
                al.Add(sp)
                sc = New SectionControl
                sc.DataSource = m_dataSource.FindRows(gi.RowFilter)
                sc.Dock = DockStyle.Top
                sc.Text = gi.GroupTitle
                AddHandler sc.DrawItem, AddressOf SectionControl_DrawItem
                AddHandler sc.SelectionChanged, AddressOf SectionControl_SelectionChanged
                AddHandler sc.SelectionDoubleClicked, AddressOf SectionControl_SelectionDoubleClicked
                al.Add(sc)
            Next

            ' Add the controls in reverse order for proper layout.
            For i As Integer = al.Count - 1 To 0 Step -1
                Controls.Add(DirectCast(al(i), Control))
            Next
        End If

        ResumeLayout()

        ' The vertical scrollbar is not always shown after
        ' the list is repopulated with controls. Setting the
        ' AutoScroll property forces the control to display the 
        ' scrollbar if necessary, but is a work around.
        ' The problem occurs when list is populated with controls
        ' that don't require a scrollbar, and then populated 
        ' with controls that do require a scrollbar, but the 
        ' scrollbar is not visible until you collapse and
        ' expand an item.
        Me.AutoScroll = True
    End Sub

    Private Sub RemoveDrawItemHandler(ByVal c As Control)
        If TypeOf c Is SectionControl Then
            Dim sc As SectionControl = DirectCast(c, SectionControl)
            RemoveHandler sc.DrawItem, AddressOf SectionControl_DrawItem
            RemoveHandler sc.SelectionChanged, AddressOf SectionControl_SelectionChanged
        End If
    End Sub

    Protected Overridable Sub OnDrawItem(ByVal e As DrawItemEventArgs, ByVal dr As DataRowView)
        ' Have some other code render the item.
        RaiseEvent DrawItem(Me, e, dr)
    End Sub

    Protected Overridable Sub OnSelectionChanged(ByVal dr As DataRowView)
        RaiseEvent SelectionChanged(dr)
    End Sub

    Private Sub ExpandableList_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        LayoutSections()
    End Sub

    Private Sub SectionControl_DrawItem(ByVal sender As Object, ByVal e As DrawItemEventArgs, ByVal dr As DataRowView)
        OnDrawItem(e, dr)
    End Sub

    Private Sub SectionControl_SelectionDoubleClicked(ByVal sender As SectionControl, ByVal dr As DataRowView)
        RaiseEvent SelectionDoubleClicked(Nothing)
    End Sub

    Private Sub SectionControl_SelectionChanged(ByVal sender As SectionControl, ByVal dr As DataRowView)
        ' The selection changed in one of the section controls. 
        ' Make sure any previous selection in another section
        ' control is cleared.
        For Each c As Control In Controls
            If TypeOf c Is SectionControl Then
                Dim sc As SectionControl = DirectCast(c, SectionControl)
                If Not sc Is sender Then
                    ' clear selected row
                    sc.SelectedIndex = -1
                End If
            End If
        Next

        ' raise selection event
        OnSelectionChanged(dr)
    End Sub

    ' select the row that contains the specified data row,
    ' raiseChangedEvent specifies if the selection changed event should
    ' be raised if a row is selected
    Public Function SelectRow(ByVal dr As DataRowView, ByVal raiseChangedEvent As Boolean) As Boolean
        ' loop through the controls and find the row that
        ' contains the data row
        Dim index As Integer
        For Each c As Control In Controls
            If TypeOf c Is SectionControl Then
                Dim sc As SectionControl = DirectCast(c, SectionControl)
                index = sc.GetRow(dr)
                If index <> -1 Then
                    ' found the row, tell that section group to
                    ' select the row and raise the event if specified
                    sc.SelectedIndex = index
                    If raiseChangedEvent Then OnSelectionChanged(sc.DataSource(index))
                    Return True
                End If
            End If
        Next

        ' did not find a row that contains the data
        Return False
    End Function

    ' select the first row in the first section group,
    ' raiseChangedEvent specifies if the selection changed event should be raised
    Public Function SelectFirstRow(ByVal raiseChangedEvent As Boolean) As Boolean
        ' controls are in reverse order
        For i As Integer = Controls.Count - 1 To 0 Step -1
            If TypeOf Controls(i) Is SectionControl Then
                ' select the first row in this section group, if it contains any rows
                Dim sc As SectionControl = DirectCast(Controls(i), SectionControl)
                If sc.Count > 0 Then
                    sc.SelectedIndex = 0
                    If raiseChangedEvent Then OnSelectionChanged(sc.DataSource(0))
                    Return True
                End If
            End If
        Next

        ' there are not any rows to select
        Return False
    End Function

    ' indicate that an empty row is selected
    ' raiseChangedEvent specifies if the selection changed event should be raised
    Public Function SelectEmptyRow(ByVal raiseChangedEvent As Boolean) As Boolean
        OnSelectionChanged(Nothing)
    End Function

#Region " Windows Form Designer generated code "

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If Disposing Then
            Dim c As Control
            For Each c In Controls
                RemoveDrawItemHandler(c)
            Next

            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(Disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        '
        'ExpandableList
        '
        Me.AutoScroll = True
        Me.Name = "ExpandableList"
    End Sub
#End Region
End Class
