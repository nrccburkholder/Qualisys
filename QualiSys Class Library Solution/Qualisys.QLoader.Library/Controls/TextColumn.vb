Option Explicit On 
Option Strict On

''' -----------------------------------------------------------------------------
''' Project	 : DataLoadingClasses
''' Class	 : DataLoadingClasses.TextColumn
''' 
''' -----------------------------------------------------------------------------
''' <summary>
'''   User control used for text and excel import wizard
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[BMao]	07/02/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class TextColumn
    Inherits System.Windows.Forms.UserControl

#Region " Private Members "

    Private mRowNum As Integer
    Private mCharWidth As Integer
    Private mCharHeight As Integer
    Private mCanSelectColumn As Boolean

#End Region

#Region " User Events "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Occurs when a column is selected
    ''' </summary>
    ''' <remarks>
    '''   Used for column name editing
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Event ColumnSelected(ByVal columnName As String, ByVal columnLength As Integer)    'column selected event

#End Region

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

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
    Friend WithEvents ctlTextColumnHeader As TextColumnHeader
    Friend WithEvents ctlTextColumnBreaker As TextColumnBreaker
    Friend WithEvents hsbHScrollBar As System.Windows.Forms.HScrollBar
    Friend WithEvents vsbVScrollBar As System.Windows.Forms.VScrollBar
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ctlTextColumnHeader = New TextColumnHeader
        Me.ctlTextColumnBreaker = New TextColumnBreaker
        Me.hsbHScrollBar = New System.Windows.Forms.HScrollBar
        Me.vsbVScrollBar = New System.Windows.Forms.VScrollBar
        Me.SuspendLayout()
        '
        'ctlTextColumnHeader
        '
        Me.ctlTextColumnHeader.BackColor = System.Drawing.SystemColors.Control
        Me.ctlTextColumnHeader.CanSelectColumn = False
        Me.ctlTextColumnHeader.CharHeight = 0
        Me.ctlTextColumnHeader.CharWidth = 0
        Me.ctlTextColumnHeader.Columns = Nothing
        Me.ctlTextColumnHeader.DrawColumnBorder = True
        Me.ctlTextColumnHeader.HScrollPos = 0
        Me.ctlTextColumnHeader.Location = New System.Drawing.Point(8, 16)
        Me.ctlTextColumnHeader.Name = "ctlTextColumnHeader"
        Me.ctlTextColumnHeader.ShowHeader = False
        Me.ctlTextColumnHeader.Size = New System.Drawing.Size(248, 24)
        Me.ctlTextColumnHeader.TabIndex = 0
        '
        'ctlTextColumnBreaker
        '
        Me.ctlTextColumnBreaker.BackColor = System.Drawing.Color.White
        Me.ctlTextColumnBreaker.CanSelectColumn = False
        Me.ctlTextColumnBreaker.CharHeight = 0
        Me.ctlTextColumnBreaker.CharWidth = 0
        Me.ctlTextColumnBreaker.Columns = Nothing
        Me.ctlTextColumnBreaker.DrawColumnBorder = True
        Me.ctlTextColumnBreaker.Fields = Nothing
        Me.ctlTextColumnBreaker.HScrollPos = 0
        Me.ctlTextColumnBreaker.Location = New System.Drawing.Point(8, 48)
        Me.ctlTextColumnBreaker.Name = "ctlTextColumnBreaker"
        Me.ctlTextColumnBreaker.SelectedColumn = -1
        Me.ctlTextColumnBreaker.Size = New System.Drawing.Size(248, 184)
        Me.ctlTextColumnBreaker.TabIndex = 1
        Me.ctlTextColumnBreaker.VScrollPos = 0
        '
        'hsbHScrollBar
        '
        Me.hsbHScrollBar.Location = New System.Drawing.Point(8, 240)
        Me.hsbHScrollBar.Maximum = 110
        Me.hsbHScrollBar.Name = "hsbHScrollBar"
        Me.hsbHScrollBar.Size = New System.Drawing.Size(248, 16)
        Me.hsbHScrollBar.TabIndex = 2
        '
        'vsbVScrollBar
        '
        Me.vsbVScrollBar.Location = New System.Drawing.Point(264, 48)
        Me.vsbVScrollBar.Maximum = 110
        Me.vsbVScrollBar.Name = "vsbVScrollBar"
        Me.vsbVScrollBar.Size = New System.Drawing.Size(16, 184)
        Me.vsbVScrollBar.TabIndex = 3
        '
        'TextColumn
        '
        Me.Controls.Add(Me.vsbVScrollBar)
        Me.Controls.Add(Me.hsbHScrollBar)
        Me.Controls.Add(Me.ctlTextColumnBreaker)
        Me.Controls.Add(Me.ctlTextColumnHeader)
        Me.Name = "TextColumn"
        Me.Size = New System.Drawing.Size(424, 264)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Public Properties "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Show header control or not
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property ShowHeader() As Boolean
        Get
            Return (ctlTextColumnHeader.ShowHeader)
        End Get
        Set(ByVal Value As Boolean)
            ctlTextColumnHeader.ShowHeader = Value
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Column collection used for initializing the layout
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property Columns() As ColumnCollection
        Get
            Return (ctlTextColumnHeader.Columns)
        End Get
        Set(ByVal Value As ColumnCollection)
            If (Value Is Nothing) Then Return
            ctlTextColumnHeader.Columns = Value
            ctlTextColumnBreaker.Columns = Value
            VisibleHScrollBar()
        End Set
    End Property

    'Public WriteOnly Property Lines() As String()
    '    Set(ByVal Value As String())
    '        Dim fields()() As String


    '        If (Value Is Nothing) Then
    '            'if value is nothing, create a blank line
    '            ReDim fields(0)
    '            fields(0) = New String() {""}
    '            Me.Fields = fields
    '            Return
    '        Else
    '            'value is not nothing
    '            ReDim fields(Value.GetUpperBound(0))
    '            Dim i As Integer
    '            For i = 0 To Value.GetUpperBound(0)
    '                If (Value(i) Is Nothing) Then
    '                    fields(i) = New String() {""}
    '                Else
    '                    fields(i) = New String() {Value(i)}
    '                End If
    '            Next
    '        End If

    '        Me.Fields = fields
    '    End Set
    'End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Data to display in the control
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public WriteOnly Property Fields() As String()()
        Set(ByVal Value As String()())
            'if value is nothing, add a blank line
            If (Value Is Nothing) Then
                ReDim Value(0)
                Value(0) = New String() {""}
            End If

            'if any field is nothing, then assign blank string ""
            Dim i As Integer
            Dim j As Integer

            For i = 0 To Value.GetUpperBound(0)
                If (Value(i) Is Nothing) Then
                    Value(i) = New String() {""}
                End If
                For j = 0 To Value(i).GetUpperBound(0)
                    If (Value(i)(j) Is Nothing) Then
                        Value(i)(j) = ""
                    End If
                Next
            Next

            'Save value
            mRowNum = Value.GetUpperBound(0) + 1
            ctlTextColumnBreaker.Fields = Value
            VisibleVScrollBar()
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Move horizontal bar to specified position
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public WriteOnly Property HScrollPos() As Integer
        Set(ByVal Value As Integer)
            hsbHScrollBar.Value = Value
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Move vertical bar to specified position
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public WriteOnly Property VScrollPos() As Integer
        Set(ByVal Value As Integer)
            If (Value < 0) Then Value = 0
            If (Value > 100) Then Value = 100
            vsbVScrollBar.Value = Value
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Indicates if column in the control can be selected
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property CanSelectColumn() As Boolean
        Get
            Return (mCanSelectColumn)
        End Get
        Set(ByVal Value As Boolean)
            mCanSelectColumn = Value
            ctlTextColumnHeader.CanSelectColumn = Value
            ctlTextColumnBreaker.CanSelectColumn = Value
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Selected column ID
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property SelectedColumn() As Integer
        Get
            Return (ctlTextColumnBreaker.SelectedColumn)
        End Get
        Set(ByVal Value As Integer)
            If (mCanSelectColumn AndAlso Value >= 0) Then
                ctlTextColumnBreaker.SelectedColumn = Value
                Dim columnName As String = ctlTextColumnHeader.ColumnName(Value)
                Dim columnLength As Integer = ctlTextColumnHeader.ColumnLength(Value)
                RaiseEvent ColumnSelected(columnName, columnLength)
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Selected column's name
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property SelectedColumnName() As String
        Get
            Dim index As Integer = ctlTextColumnBreaker.SelectedColumn
            If ((index < 0) OrElse (index >= ctlTextColumnHeader.Columns.Count)) Then
                Return ("")
            End If
            Return (ctlTextColumnHeader.ColumnName(index))
        End Get
        Set(ByVal Value As String)
            Dim index As Integer = ctlTextColumnBreaker.SelectedColumn
            If ((index < 0) OrElse (index >= ctlTextColumnHeader.Columns.Count)) Then
                Return
            End If
            ctlTextColumnHeader.ColumnName(index) = Value
            ctlTextColumnHeader.PaintHeader(True)
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Indicates drawing column border (separate line between columns) or not
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property DrawColumnBorder() As Boolean
        Get
            Return (ctlTextColumnHeader.DrawColumnBorder)
        End Get
        Set(ByVal Value As Boolean)
            ctlTextColumnHeader.DrawColumnBorder = Value
            ctlTextColumnBreaker.DrawColumnBorder = Value
        End Set
    End Property

#End Region

#Region " Public Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Move cursor to left-top of data area.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub ResetPosition()
        HScrollPos = 0
        VScrollPos = 0
        ctlTextColumnHeader.ResetPosition()
        ctlTextColumnBreaker.ResetPosition()
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Make specified column visible.
    ''' </summary>
    ''' <param name="column"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub VisibleColumn(ByVal column As Integer)
        ctlTextColumnBreaker.VisibleColumn(column)
    End Sub

    Public Sub Moving(ByVal direction As MoveDirections)
        ctlTextColumnBreaker.Moving(direction)
    End Sub
#End Region

#Region " Event Handlers "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Initial formating
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub TextColumn_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        SetFontInfo()
        PositionControls()
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Event handler for horizontal bar scrolling
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub HScrollBar_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles hsbHScrollBar.ValueChanged
        Dim value As Integer = hsbHScrollBar.Value

        ctlTextColumnHeader.HScrollPos = value
        ctlTextColumnBreaker.HScrollPos = value
        PaintMe(False)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Event handler for vertical bar scrolling
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub VScrollBar_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles vsbVScrollBar.ValueChanged
        Dim value As Integer = vsbVScrollBar.Value
        If value > 100 Then value = 100
        If value < 0 Then value = 0

        ctlTextColumnBreaker.VScrollPos = value
        ctlTextColumnBreaker.PaintText(False)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Event handler for column breaker control's column selected event
    ''' </summary>
    ''' <param name="index"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub TextColumnBreaker_BreakerColumnSelected(ByVal index As Integer) Handles ctlTextColumnBreaker.BreakerColumnSelected
        Me.SelectedColumn = index
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Event handler for column header control's click event.
    '''   Pass the cursor click event to column breaker control
    ''' </summary>
    ''' <param name="pt"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub ctlTextColumnHeader_HeaderClick(ByVal pt As System.Drawing.Point) Handles ctlTextColumnHeader.HeaderClick
        If (Not CanSelectColumn) Then Return
        ctlTextColumnBreaker.SendClick(pt)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Event handler for column breaker's visible area moving event.
    '''   Move horizontal bar to specified position
    ''' </summary>
    ''' <param name="visibleAreaLeft"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub ctlTextColumnBreaker_VisibleAreaMoved(ByVal visibleAreaLeft As Integer) Handles ctlTextColumnBreaker.VisibleAreaMoved
        Me.hsbHScrollBar.Value = visibleAreaLeft
    End Sub

#End Region

#Region " Private Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Calculate font dimension.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub SetFontInfo()
        'Font
        ctlTextColumnHeader.Font = Me.Font
        ctlTextColumnBreaker.Font = Me.Font

        'Font dimension
        Dim testStr As String = "WWWWWWWWWW"
        Me.mCharWidth = CInt(Me.CreateGraphics.MeasureString(testStr, Me.Font).Width / testStr.Length) + TextColumnDefaultValue.CHAR_SPACING
        Me.mCharHeight = CInt(Me.Font.GetHeight()) + TextColumnDefaultValue.LINE_SPACING

        ctlTextColumnHeader.CharWidth = Me.mCharWidth
        ctlTextColumnHeader.CharHeight = Me.mCharHeight

        ctlTextColumnBreaker.CharWidth = Me.mCharWidth
        ctlTextColumnBreaker.CharHeight = Me.mCharHeight
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Adjust controls' position and size
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub PositionControls()
        'Position the ColumnHeader
        ctlTextColumnHeader.Left = 0
        ctlTextColumnHeader.Top = 0
        ctlTextColumnHeader.Width = Me.Width - vsbVScrollBar.Width
        ctlTextColumnHeader.Height = Me.mCharHeight _
                                     - TextColumnDefaultValue.LINE_SPACING _
                                     + 2 * TextColumnDefaultValue.HEADER_VERTICAL_PADDING

        'Position the ColumnBreaker
        ctlTextColumnBreaker.Left = 0
        ctlTextColumnBreaker.Top = ctlTextColumnHeader.Height
        ctlTextColumnBreaker.Width = ctlTextColumnHeader.Width
        ctlTextColumnBreaker.Height = Me.Height - ctlTextColumnHeader.Height - hsbHScrollBar.Height

        'Position the HScroll
        hsbHScrollBar.Left = 0
        hsbHScrollBar.Top = Me.Height - hsbHScrollBar.Height
        hsbHScrollBar.Width = ctlTextColumnHeader.Width

        'Position the VScroll
        vsbVScrollBar.Left = Me.Width - vsbVScrollBar.Width
        vsbVScrollBar.Top = ctlTextColumnBreaker.Top
        vsbVScrollBar.Height = ctlTextColumnBreaker.Height

    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Decide if horizontal bar need to be visible or not based on data area width
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub VisibleHScrollBar()
        Dim columns As ColumnCollection = ctlTextColumnHeader.Columns
        If (columns Is Nothing) Then Return

        Dim width As Integer = 0
        Dim i As Integer
        For i = 0 To columns.Count - 1
            width += mCharWidth * columns(i).Length _
                     + 2 * TextColumnDefaultValue.COLUMN_HORIZONTAL_PADDING _
                     + TextColumnDefaultValue.BREAK_LINE_WIDTH
        Next

        With hsbHScrollBar
            .Minimum = 0
            .Maximum = width - 1
            .SmallChange = mCharWidth
            .LargeChange = Me.ctlTextColumnBreaker.Width
        End With

        If width <= ctlTextColumnBreaker.Width Then
            hsbHScrollBar.Visible = False
        Else
            hsbHScrollBar.Visible = True
        End If
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Decide if vertical bar need to be visible or not based on data area height
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub VisibleVScrollBar()
        If (mCharHeight = 0) Then Return
        Dim maxVisibleRow As Integer = CInt(Math.Floor(Me.Height / mCharHeight))
        Dim totalRow As Integer = mRowNum

        If (totalRow <= maxVisibleRow) Then
            vsbVScrollBar.Visible = False
        Else
            vsbVScrollBar.Visible = True
        End If
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Refresh interface.
    ''' </summary>
    ''' <param name="mustDraw">
    '''   If mustDraw is True, redraw the interface;
    '''   If mustDraw is False, redraw if program decides it is necessary.
    ''' </param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	07/02/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub PaintMe(ByVal mustDraw As Boolean)
        ctlTextColumnHeader.PaintHeader(mustDraw)
        ctlTextColumnBreaker.PaintText(mustDraw)
    End Sub

#End Region

End Class
