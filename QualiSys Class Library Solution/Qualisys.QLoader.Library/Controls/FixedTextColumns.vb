Option Explicit On 
Option Strict On

Public Class FixedTextColumns
    Inherits System.Windows.Forms.UserControl

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
    Friend WithEvents ColumnBreaker As FixedTextColumnBreaker
    Friend WithEvents ColumnScale As FixedTextColumnScale
    Friend WithEvents hsbHScrollBar As System.Windows.Forms.HScrollBar
    Friend WithEvents vsbVScrollBar As System.Windows.Forms.VScrollBar
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ColumnBreaker = New FixedTextColumnBreaker
        Me.hsbHScrollBar = New System.Windows.Forms.HScrollBar
        Me.vsbVScrollBar = New System.Windows.Forms.VScrollBar
        Me.ColumnScale = New FixedTextColumnScale
        Me.SuspendLayout()
        '
        'ColumnBreaker
        '
        Me.ColumnBreaker.BackColor = System.Drawing.Color.White
        Me.ColumnBreaker.BreakColor = System.Drawing.Color.Black
        Me.ColumnBreaker.HScrollPos = 0
        Me.ColumnBreaker.Location = New System.Drawing.Point(16, 40)
        Me.ColumnBreaker.Name = "ColumnBreaker"
        Me.ColumnBreaker.Size = New System.Drawing.Size(224, 165)
        Me.ColumnBreaker.TabIndex = 0
        Me.ColumnBreaker.VScrollPos = 0
        '
        'hsbHScrollBar
        '
        Me.hsbHScrollBar.Location = New System.Drawing.Point(16, 224)
        Me.hsbHScrollBar.Name = "hsbHScrollBar"
        Me.hsbHScrollBar.Size = New System.Drawing.Size(224, 17)
        Me.hsbHScrollBar.TabIndex = 1
        '
        'vsbVScrollBar
        '
        Me.vsbVScrollBar.Location = New System.Drawing.Point(248, 32)
        Me.vsbVScrollBar.Name = "vsbVScrollBar"
        Me.vsbVScrollBar.Size = New System.Drawing.Size(17, 184)
        Me.vsbVScrollBar.TabIndex = 2
        '
        'ColumnScale
        '
        Me.ColumnScale.HScrollPos = 0
        Me.ColumnScale.Location = New System.Drawing.Point(16, 8)
        Me.ColumnScale.Name = "ColumnScale"
        Me.ColumnScale.Size = New System.Drawing.Size(224, 24)
        Me.ColumnScale.TabIndex = 3
        '
        'FixedTextColumns
        '
        Me.Controls.Add(Me.ColumnScale)
        Me.Controls.Add(Me.vsbVScrollBar)
        Me.Controls.Add(Me.hsbHScrollBar)
        Me.Controls.Add(Me.ColumnBreaker)
        Me.Name = "FixedTextColumns"
        Me.Size = New System.Drawing.Size(288, 288)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Private Members"

    Private mMaxRowLength As Integer = 0

#End Region

#Region "Public Properties"

    <System.ComponentModel.Bindable(True), System.ComponentModel.Category("Data"), System.ComponentModel.DesignerSerializationVisibility(System.ComponentModel.DesignerSerializationVisibility.Content)> _
    Public Property Lines() As FixedTextColumnBreakerLineCollection
        Get
            Return Me.ColumnBreaker.Lines
        End Get
        Set(ByVal Value As FixedTextColumnBreakerLineCollection)
            Me.ColumnBreaker.Lines = Value
            Dim line As FixedTextColumnBreakerLine
            For Each line In Value
                If (mMaxRowLength < line.Length) Then
                    mMaxRowLength = line.Length
                End If
            Next
            ResizeScrollBar()
        End Set
    End Property

    Public WriteOnly Property StringLines() As String()
        Set(ByVal Value As String())
            Me.ColumnBreaker.Lines.Clear()
            Dim i As Integer
            For i = 0 To Value.Length - 1
                Me.ColumnBreaker.Lines.Add(New FixedTextColumnBreakerLine(Value(i)))
                If (mMaxRowLength < Lines(i).Length) Then
                    mMaxRowLength = Lines(i).Length
                End If
            Next i
            ResizeScrollBar()
        End Set
    End Property

    Public Property ColumnLengths() As Integer()
        Get
            Dim breaks As ArrayList = Me.ColumnBreaker.Breaks
            Dim lengths(breaks.Count) As Integer
            Dim i As Integer = 0
            Dim preBreak As Integer = 0

            'get length of columns except the last
            For i = 0 To breaks.Count - 1
                lengths(i) = CInt(breaks(i)) - preBreak
                preBreak = CInt(breaks(i))
            Next

            'last column
            lengths(i) = Me.mMaxRowLength - preBreak
            If (lengths(i) <= 0) Then lengths(i) = 1

            Return (lengths)
        End Get
        Set(ByVal Value As Integer())
            Dim breaks As New ArrayList
            Dim i As Integer
            Dim beginPos As Integer = 0
            Dim totalLength As Integer = 0

            For i = 0 To Value.Length - 2
                breaks.Add(beginPos + Value(i))
                beginPos += Value(i)
                totalLength += Value(i)
            Next
            totalLength += Value(i)

            Me.ColumnBreaker.Breaks = breaks
            If (totalLength > mMaxRowLength) Then
                mMaxRowLength = totalLength
                ResizeHScrollBar()
            End If
        End Set
    End Property

    Public WriteOnly Property RulerScale() As RulerScales
        Set(ByVal Value As RulerScales)
            Me.ColumnScale.RulerScale = Value
            Me.ColumnBreaker.RulerScale = Value
        End Set
    End Property

#End Region

#Region "Private Methods"

    Private Sub TextColumns_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Position the scale
        Me.ColumnScale.Left = 0
        Me.ColumnScale.Top = 0
        Me.ColumnScale.Width = Me.Width - Me.vsbVScrollBar.Width
        Me.ColumnScale.Height = 25

        'Position the ColumnBreaker
        Me.ColumnBreaker.Left = 0
        Me.ColumnBreaker.Top = 0 + Me.ColumnScale.Height
        Me.ColumnBreaker.Width = Me.Width - Me.vsbVScrollBar.Width
        Me.ColumnBreaker.Height = Me.Height - Me.ColumnScale.Height - Me.hsbHScrollBar.Height

        'Position the HScroll
        Me.hsbHScrollBar.Left = 0
        Me.hsbHScrollBar.Top = Me.Height - Me.hsbHScrollBar.Height
        Me.hsbHScrollBar.Width = Me.Width - Me.vsbVScrollBar.Width

        'Position the VScroll
        Me.vsbVScrollBar.Left = Me.Width - Me.vsbVScrollBar.Width
        Me.vsbVScrollBar.Top = 0 + Me.ColumnScale.Height
        Me.vsbVScrollBar.Height = Me.Height - Me.ColumnScale.Height - Me.hsbHScrollBar.Height

    End Sub

    Private Sub HScrollBar_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles hsbHScrollBar.ValueChanged
        'Set the scroll properties on the columnbreaker/scale and refresh them
        Me.ColumnBreaker.HScrollPos = Me.hsbHScrollBar.Value
        Me.ColumnScale.HScrollPos = Me.hsbHScrollBar.Value
        Me.ColumnBreaker.Refresh()
        Me.ColumnScale.Refresh()
    End Sub

    Private Sub VScrollBar_ValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles vsbVScrollBar.ValueChanged
        'Set the scroll properties on the columnbreaker/scale and refresh them
        Me.ColumnBreaker.VScrollPos = Me.vsbVScrollBar.Value
        Me.ColumnBreaker.Refresh()
    End Sub

    Private Sub ResizeScrollBar()
        ResizeHScrollBar()
        ResizeVScrollBar()
    End Sub

    Private Sub ResizeHScrollBar()
        With hsbHScrollBar
            .Minimum = 0
            .Maximum = mMaxRowLength + 2
            .LargeChange = CInt(Math.Floor(Me.Width / FixedTextColumnBreaker.CHAR_WIDTH))
            .Value = 0
        End With
    End Sub

    Private Sub ResizeVScrollBar()
        With vsbVScrollBar
            .Minimum = 0
            .Maximum = ColumnBreaker.Lines.Count + 1
            .LargeChange = CInt(Math.Floor(Me.Height / FixedTextColumnBreaker.CHAR_HEIGHT))
            .Value = 0
        End With
    End Sub

    'If someone clicks on the scale we need to notifiy the columnbreaker of the event
    Private Sub ColumnScale_Scale_Click(ByVal pt As System.Drawing.Point) Handles ColumnScale.Scale_Click
        Me.ColumnBreaker.SendClick(pt)
    End Sub

    Private Sub TextColumns_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        Me.Refresh()
    End Sub

#End Region

End Class
