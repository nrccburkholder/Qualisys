Option Explicit On 
Option Strict On

Imports System.Drawing

Public Class FixedTextColumnBreaker
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
    Friend WithEvents tipBreaker As System.Windows.Forms.ToolTip
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.tipBreaker = New System.Windows.Forms.ToolTip(Me.components)
        '
        'tipBreaker
        '
        Me.tipBreaker.AutoPopDelay = 5000
        Me.tipBreaker.InitialDelay = 1500
        Me.tipBreaker.ReshowDelay = 100
        '
        'FixedTextColumnBreaker
        '
        Me.BackColor = System.Drawing.Color.White
        Me.Name = "FixedTextColumnBreaker"

    End Sub

#End Region

#Region " Private Members "

    Private mBreaks As New FixedTextColumnBreakCollection        'The collection of breaks
    Private mLines As New FixedTextColumnBreakerLineCollection   'The collection of lines
    Private mFont As New System.Drawing.Font("Courier New", 10.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte)) 'Font to use
    Private mBreakColor As Color = Color.BlueViolet     'The color of the ColumnBreak

    Private mRulerScale As RulerScales  'Ruler scale (0-based or 1-based)
    Private mMaxChars As Integer        'The maximum number of chars that can currently be displayed
    Private mMaxLines As Integer        'The max number of lines that can currently be shown
    Private mHScrollPos As Integer      'The horizontal scroll position
    Private mVScrollPos As Integer      'the vertical scroll position

    Friend Const CHAR_WIDTH As Integer = 8  'The width of each character
    Friend Const X_OFFSET As Integer = 2    'I don't know why but for some reason if you say draw a character at (0,0) you get a char at (2,0)
    Friend Const CHAR_HEIGHT As Integer = 15    'The height of each character

#End Region

#Region " Public Properties "

    '    <System.ComponentModel.Bindable(True), System.ComponentModel.Category("Data"), System.ComponentModel.DesignerSerializationVisibility(System.ComponentModel.DesignerSerializationVisibility.Content)> _
    Public Property Lines() As FixedTextColumnBreakerLineCollection
        Get
            Return Me.mLines
        End Get
        Set(ByVal Value As FixedTextColumnBreakerLineCollection)
            Me.mLines = Value
        End Set
    End Property

    Public Property Breaks() As ArrayList
        Get
            Dim arrPoints As New ArrayList(Me.mBreaks.Count)
            Dim break As FixedTextColumnBreak
            Dim entry As DictionaryEntry
            Dim i As Integer = 0

            For Each entry In Me.mBreaks
                break = CType(entry.Value, FixedTextColumnBreak)
                'Offset the X by the scroll position
                arrPoints.Add((break.X - X_OFFSET) / CHAR_WIDTH)
                i += 1
            Next

            arrPoints.Sort()
            Return arrPoints

        End Get
        Set(ByVal Value As ArrayList)
            Me.mBreaks.Clear()
            Dim break As Integer
            Dim x As Integer
            For Each break In Value
                x = break * CHAR_WIDTH + X_OFFSET
                Me.mBreaks.Add(New FixedTextColumnBreak(x, 0, Me.Height))
            Next
            Me.Refresh()
        End Set
    End Property

    Public Overrides Property Font() As System.Drawing.Font
        Get
            Return Me.mFont
        End Get
        Set(ByVal Value As System.Drawing.Font)
            Me.mFont = Value
        End Set
    End Property

    <System.ComponentModel.Browsable(True), System.ComponentModel.Category("Appearance")> _
    Public Property BreakColor() As System.Drawing.Color
        Get
            Return Me.mBreakColor
        End Get
        Set(ByVal Value As System.Drawing.Color)
            Me.mBreakColor = Value
        End Set
    End Property

    Public WriteOnly Property RulerScale() As RulerScales
        Set(ByVal Value As RulerScales)
            mRulerScale = Value
        End Set
    End Property

    Public Property HScrollPos() As Integer
        Get
            Return Me.mHScrollPos
        End Get
        Set(ByVal Value As Integer)
            Me.mHScrollPos = Value
        End Set
    End Property

    Public Property VScrollPos() As Integer
        Get
            Return Me.mVScrollPos
        End Get
        Set(ByVal Value As Integer)
            Me.mVScrollPos = Value
        End Set
    End Property

#End Region

#Region " Private Methods "

    Private Sub TextColumnBreaker_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.Width = Me.Width - (Me.Width Mod CHAR_WIDTH)             '??probably don't need
        Me.mMaxChars = CInt(Math.Floor(Me.Width / CHAR_WIDTH))      'calculate the max chars
        Me.Height = Me.Height - (Me.Height Mod CHAR_HEIGHT)         '??probably don't need
        Me.mMaxLines = CInt(Math.Floor(Me.Height / CHAR_HEIGHT))    'Calculate the max lines

        'No scrolling
        Me.HScroll = False
        Me.VScroll = False
        Me.AutoScroll = False
    End Sub

    'When a user clicks on the control
    Private Sub TextColumnBreaker_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Click
        'Get the mouse point
        Dim pt As Point = Me.PointToClient(System.Windows.Forms.Cursor.Position)

        'Add/Remove a break at this point
        AddBreak(pt)

        'Refresh the control
        Me.Refresh()
    End Sub

    Private Sub AddBreak(ByVal pt As Point)
        'Get the x,y
        Dim x As Integer = pt.X
        Dim y As Integer = pt.Y

        'Round x to the nearest CHAR_WIDTH position
        x = x - (x Mod CHAR_WIDTH)
        'Offset in the x direction by 2 (I think this is because of an initial space?)
        x = x + X_OFFSET
        'Offset x based on the HScroll position
        x = x + (Me.mHScrollPos * CHAR_WIDTH)

        'If this is greater than the first position
        If x > X_OFFSET Then
            'If there is already a break there then remove it
            If Me.mBreaks.Contains(x) Then
                Me.mBreaks.Remove(x)
            Else    'Add the new break
                Me.mBreaks.Add(New FixedTextColumnBreak(x, 0, Me.Height))
            End If
        End If

    End Sub


    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)
        Me.PaintBorder(e.Graphics)      'Paint the border
        Me.PaintLines(e.Graphics)       'Paint in the text lines
        Me.PaintColumnBreaks(e.Graphics)      'Pain in the Column Breaks
    End Sub

    'Draw all the current break points
    Private Sub PaintColumnBreaks(ByVal graph As System.Drawing.Graphics)
        Dim pen As New System.Drawing.Pen(Me.mBreakColor)
        Dim break As FixedTextColumnBreak
        Dim Entry As DictionaryEntry
        Dim X As Single
        Dim Y As Single
        Dim height As Integer

        'For each break in the BreakCollection
        For Each Entry In Me.mBreaks
            break = CType(Entry.Value, FixedTextColumnBreak)
            'Offset the X by the scroll position
            X = break.X - (Me.mHScrollPos * CHAR_WIDTH)
            Y = break.Y
            height = break.Height

            If (X >= 0 AndAlso X <= Me.Width) Then
                'Draw the line
                graph.DrawLine(pen, X, Y, X, height)
            End If
        Next
    End Sub

    'Draws all the text lines on the control
    Private Sub PaintLines(ByVal graph As System.Drawing.Graphics)
        Dim brush As New System.Drawing.SolidBrush(System.Drawing.Color.Black)
        Dim line As FixedTextColumnBreakerLine
        Dim y As Integer = 0
        Dim i As Integer

        'For each visible line
        For i = Me.mVScrollPos To Me.mLines.Count - 1
            line = Me.mLines(i)     'Get the text

            'If part of this line is in the visible area
            If line.Text.Length > Me.mHScrollPos Then
                'Paint the line at the current y coordinate
                Me.PaintLine(graph, y, line.Text.Substring(Me.mHScrollPos))
                'graph.DrawString(line.Text.Substring(Me.mHScrollPos), Me.Font, brush, 0, y)
            End If
            y += CHAR_HEIGHT    'Increment the y coordinate

            'if we have exceeded the visible bounds then exit
            If (y > Me.Height) Then Exit For
        Next
    End Sub

    'This is used because the character width/spacing is NOT PREDICTABLE!!!
    'Therefore we place each character in the exact location we want it.
    'Not too efficient I suppose but hey, this is a prototype!
    Private Sub PaintLine(ByVal graph As System.Drawing.Graphics, ByVal y As Integer, ByVal str As String)
        Dim brush As New System.Drawing.SolidBrush(System.Drawing.Color.Black)
        'Get a char array
        Dim chars As Char() = str.ToCharArray
        Dim i As Integer
        Dim x As Integer = 0

        'For each char
        For i = 0 To chars.Length - 1
            'Draw the char
            graph.DrawString(chars(i), Me.Font, brush, x, y)
            'Increment x by exactly the width we want
            x += CHAR_WIDTH

            'if we have exceeded the visible bounds then exit
            If i > Me.mMaxChars Then Exit For
        Next
    End Sub

    Private Sub PaintBorder(ByVal graph As System.Drawing.Graphics)
        Dim pen As New pen(Color.Black)

        graph.DrawRectangle(pen, 0, 0, Me.Width - 1, Me.Height - 1)
    End Sub

    Private Sub TextColumnBreaker_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        Me.mMaxChars = CInt(Me.Width / CHAR_WIDTH)
        Me.mMaxLines = CInt(Me.Height / CHAR_HEIGHT)

    End Sub

    'Used to receive a click event from external to this control (ie, the scale)
    Public Sub SendClick(ByVal pt As Point)
        Me.AddBreak(pt)
        Me.Refresh()
    End Sub

#End Region

    Private Sub FixedTextColumnBreaker_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MyBase.MouseMove
        Dim x As Integer = e.X
        Dim break As FixedTextColumnBreak
        Dim maxBreakX As Single = 0
        Dim tip As String

        'Offset in the x direction by 2 (I think this is because of an initial space?)
        x += X_OFFSET

        'Offset x based on the HScroll position
        x += Me.mHScrollPos * CHAR_WIDTH

        For Each break In Me.mBreaks.Values
            'find a column that cursor is in
            If (break.X - break.Length < x AndAlso x <= break.X) Then
                Dim length As Integer = CInt(break.Length / CHAR_WIDTH)
                tip = "Field Begin Position: " & CInt((break.X - break.Length - X_OFFSET) / CHAR_WIDTH + mRulerScale)
                tip += vbCrLf + "Field Length: " & length
                tipBreaker.SetToolTip(Me, tip)
                Return
            End If
            If (break.X > maxBreakX) Then maxBreakX = break.X
        Next

        'in last column
        If (x >= maxBreakX) Then
            tip = "Field Begin Position: " & CInt((maxBreakX - X_OFFSET) / CHAR_WIDTH + mRulerScale)
            tipBreaker.SetToolTip(Me, tip)
            Return
        End If

        'not in any column
        tipBreaker.SetToolTip(Me, Nothing)
    End Sub
End Class
