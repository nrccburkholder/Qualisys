Imports System.ComponentModel

Public Class SectionControl
    Inherits System.Windows.Forms.UserControl

    ' events
    Public Event DrawItem(ByVal sender As Object, ByVal e As DrawItemEventArgs, ByVal dr As DataRowView)
    Public Event SelectionChanged(ByVal sender As SectionControl, ByVal dr As DataRowView)
    Public Event SelectionDoubleClicked(ByVal sender As SectionControl, ByVal dr As DataRowView)

    ' const values
    Public Const DefaultItemHeight As Integer = 36
    Private Const HeaderHeight As Integer = 40

    ' internal members
    Private m_expansionState As Integer = 1
    Private m_itemHeight As Integer = SectionControl.DefaultItemHeight
    Private m_rows As DataRowView()
    Private m_groupTitle As String = ""

    ' index to the currently selected row
    Private m_currrentSelectionIndex As Integer = -1

    ' gdi objects
    Private m_penSeparate As Pen
    Private m_fontGroupTitle As Font
    Private m_format As StringFormat

    <Category("Data"), DefaultValue(GetType(DataRowView()), Nothing), _
    Description("Gets and sets a data source for this group.")> _
    Public Property DataSource() As DataRowView()
        Get
            Return m_rows
        End Get
        Set(ByVal Value As DataRowView())
            m_rows = Value
            UpdateLayout()
        End Set
    End Property

    <Category("Layout"), DefaultValue(SectionControl.DefaultItemHeight), _
    Description("Height of each row in the group.")> _
    Public Property ItemHeight() As Integer
        Get
            Return m_itemHeight
        End Get
        Set(ByVal Value As Integer)
            m_itemHeight = Value
        End Set
    End Property

    Public Overrides Property Text() As String
        Get
            Return m_groupTitle
        End Get
        Set(ByVal Value As String)
            m_groupTitle = Value
        End Set
    End Property

    ' The selected row in the group.
    <Browsable(False)> _
    Public Property SelectedIndex() As Integer
        Get
            Return m_currrentSelectionIndex
        End Get
        Set(ByVal Value As Integer)
            If m_currrentSelectionIndex <> Value Then
                m_currrentSelectionIndex = Value
                Invalidate()
            End If
        End Set
    End Property

    ' Number of rows in the group.
    <Browsable(False)> _
    Public ReadOnly Property Count() As Integer
        Get
            If m_rows Is Nothing Then Return 0
            Return m_rows.Length
        End Get
    End Property

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        ' init gdi objects
        m_penSeparate = New Pen(SystemColors.InactiveCaption, 2)

        ' font for the group section header
        m_fontGroupTitle = New Font("tahoma", Me.Font.Size, FontStyle.Bold)

        ' draw strings w/ ellipsis
        m_format = New StringFormat
        m_format.FormatFlags = StringFormatFlags.NoWrap
        m_format.LineAlignment = StringAlignment.Center
        m_format.Trimming = StringTrimming.EllipsisCharacter

        ' turn on double buffering
        Me.SetStyle(ControlStyles.DoubleBuffer Or _
         ControlStyles.UserPaint Or ControlStyles.ResizeRedraw Or _
         ControlStyles.AllPaintingInWmPaint, True)
    End Sub

    ' Return the row index that contains the specified data row.
    Public Function GetRow(ByVal dr As DataRowView) As Integer
        ' return right away if don't have any rows
        If dr Is Nothing OrElse m_rows Is Nothing OrElse m_rows.Length = 0 Then Return -1

        ' look for the matching row
        For i As Integer = 0 To m_rows.Length - 1
            If m_rows(i).Row Is dr.Row Then Return i
        Next

        ' did not find a match
        Return -1
    End Function

    ' Set the expand / collapse image.
    Private Sub SetImage(ByVal index As Integer)
        pictExpand.Image = imageList.Images(index)
    End Sub

    ' Calculate the total height of the control.
    Private Sub UpdateLayout()
        If m_expansionState = 1 Then
            Height = HeaderHeight + m_rows.Length * (m_itemHeight + 1)
        Else
            Height = HeaderHeight
        End If
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        ' Draw the group title
        Dim groupTitleBounds As New RectangleF( _
         pictExpand.Right + 5, pictExpand.Top, _
         Me.Width - pictExpand.Right - 10, m_fontGroupTitle.Height)

        e.Graphics.DrawString(Me.Text, m_fontGroupTitle, _
         SystemBrushes.Highlight, groupTitleBounds, m_format)

        ' Draw a line to separate the header from its associated items.
        e.Graphics.DrawLine(m_penSeparate, 0, HeaderHeight - 1, Width, HeaderHeight - 1)

        ' Loop through and draw each row.
        Dim topItem As Integer = HeaderHeight
        Dim index As Integer
        For Each dr As DataRowView In m_rows
            ' Determine what state the row is in.
            Dim state As DrawItemState = DrawItemState.None
            If m_currrentSelectionIndex = index Then state = state Or DrawItemState.Selected
            If Me.Focused Then state = state Or DrawItemState.Focus

            ' Create object that holds the drawing data.
            Dim drawArg As New DrawItemEventArgs(e.Graphics, Me.Font, _
             New Rectangle(0, topItem, Width, m_itemHeight), index, state)

            ' Have some other code render the item.
            OnDrawItem(drawArg, dr)

            ' Draw a line to separate each item.
            e.Graphics.DrawLine(SystemPens.Control, 0, _
             topItem + m_itemHeight, Width, topItem + m_itemHeight)

            ' Update the top of the next item.
            topItem += m_itemHeight + 1

            index += 1
        Next
    End Sub

    Protected Overridable Sub OnDrawItem(ByVal e As DrawItemEventArgs, ByVal dr As DataRowView)
        ' Have some other code render the item.
        RaiseEvent DrawItem(Me, e, dr)
    End Sub

    Private Sub SectionControl_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        SetImage(m_expansionState)
        UpdateLayout()
    End Sub

    Private Sub PictExpand_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles pictExpand.Click
        m_expansionState = 1 - m_expansionState
        SetImage(m_expansionState)
        UpdateLayout()
    End Sub

#Region " Windows Form Designer generated code "

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents pictExpand As System.Windows.Forms.PictureBox
    Friend WithEvents imageList As System.Windows.Forms.ImageList
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(SectionControl))
        Me.pictExpand = New System.Windows.Forms.PictureBox
        Me.imageList = New System.Windows.Forms.ImageList(Me.components)
        Me.SuspendLayout()
        '
        'pictExpand
        '
        Me.pictExpand.Location = New System.Drawing.Point(8, 16)
        Me.pictExpand.Name = "pictExpand"
        Me.pictExpand.Size = New System.Drawing.Size(11, 11)
        Me.pictExpand.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize
        Me.pictExpand.TabIndex = 0
        Me.pictExpand.TabStop = False
        '
        'imageList
        '
        Me.imageList.ImageSize = New System.Drawing.Size(11, 11)
        Me.imageList.ImageStream = CType(resources.GetObject("imageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imageList.TransparentColor = System.Drawing.Color.Lime
        '
        'SectionControl
        '
        Me.BackColor = System.Drawing.SystemColors.Window
        Me.Controls.Add(Me.pictExpand)
        Me.Name = "SectionControl"
        Me.Size = New System.Drawing.Size(208, 48)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub SectionControl_DoubleClick(ByVal sender As Object, ByVal e As EventArgs) Handles MyBase.DoubleClick
        RaiseEvent SelectionDoubleClicked(Me, Nothing)
    End Sub

    ' see if a new row was selected and raise event
    Private Sub SectionControl_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MyBase.MouseDown
        ' holds the new selection
        Dim sel As Integer

        If e.Y < HeaderHeight Then
            ' the header was selected, usually would set this to -1
            ' but set to the first item in the list (selecting the
            ' header selects the first row)
            If m_rows Is Nothing OrElse m_rows.Length = 0 Then
                ' the group does not contain any rows
                sel = -1
            Else
                ' the first row in the group
                sel = 0
            End If
        Else
            ' the selected row
            sel = (e.Y - HeaderHeight) \ (m_itemHeight + 1)
        End If

        ' update if a new row was selected
        If sel <> m_currrentSelectionIndex Then
            m_currrentSelectionIndex = sel
            Invalidate()
            OnSelectionChanged(m_currrentSelectionIndex)
        End If
    End Sub

    Protected Overridable Sub OnSelectionChanged(ByVal index As Integer)
        ' pass the selected row data if available
        If index = -1 Then
            RaiseEvent SelectionChanged(Me, Nothing)
        Else
            RaiseEvent SelectionChanged(Me, m_rows(index))
        End If
    End Sub

    Private Sub SectionControl_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.GotFocus
        ' Invalidate so the selected row can be repainted
        If m_currrentSelectionIndex <> -1 Then Invalidate()
    End Sub

    Private Sub SectionControl_LostFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.LostFocus
        ' Invalidate so the selected row can be repainted
        If m_currrentSelectionIndex <> -1 Then Invalidate()
    End Sub
End Class
