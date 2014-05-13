Option Explicit On 
Option Strict On

Imports System.Drawing

'TextColumnScale Control
'This control just draws the column scale on the form

Public Class FixedTextColumnScale
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
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        '
        'FixedTextColumnScale
        '
        Me.Name = "FixedTextColumnScale"
        Me.Size = New System.Drawing.Size(272, 24)

    End Sub

#End Region

#Region " Private Members "

    Private mRulerScale As RulerScales  'Ruler scale (0-based or 1-based)
    Private mHScrollPos As Integer      'Position of the horizontal scroll bar
    'The font used in the scale
    Private mFont As New System.Drawing.Font("Courier New", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))

#End Region

#Region " User Events "

    Event Scale_Click(ByVal pt As Point)    'On click event

#End Region

#Region " Public Properties "

    Public WriteOnly Property RulerScale() As RulerScales
        Set(ByVal Value As RulerScales)
            mRulerScale = Value
            Me.Refresh()
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

#End Region

#Region " Private Methods "

    'Paint the scale onto the form
    Private Sub PaintScale(ByVal graph As Graphics)
        Dim pen As New pen(Color.Black)             'Use black pen
        Dim brush As New SolidBrush(Color.Black)    'Use solid brush

        'Draw a horizontal line along the bottom of the control, this is the base of the scale
        graph.DrawLine(pen, 0, Me.Height - 1, Me.Width, Me.Height - 1)

        Dim x As Integer        'The x position to draw the "tick" mark
        Dim xReal As Integer    'The real position (ignoring scrolling) of the "tick" mark
        'IE the mark might be displayed 10 pixels from the left but because of scrolling
        'it is much farther from the "real" left or begining of the scale

        Dim yStart As Integer   'The starting vertical position of the tick mark
        Dim scale As String     'The scale label

        'For each tick mark in the visible window
        For x = FixedTextColumnBreaker.X_OFFSET To Me.Width Step FixedTextColumnBreaker.CHAR_WIDTH
            'Calculate the "Real" position
            xReal = x + (Me.HScrollPos * FixedTextColumnBreaker.CHAR_WIDTH) - FixedTextColumnBreaker.X_OFFSET

            yStart = Me.Height - 3      'The vertical line will be three pixels tall starting from the bottom

            'If the "real" x position is a 1/5th mark then raise the line by 3 pixels
            If (xReal / FixedTextColumnBreaker.CHAR_WIDTH) Mod 5 = 0 Then yStart = yStart - 3
            'If the "real" x position is a 1/10th mark then raise the line by 3 pixels
            If (xReal / FixedTextColumnBreaker.CHAR_WIDTH) Mod 10 = 0 Then
                yStart = yStart - 3
                'also draw the scale label
                scale = (xReal / FixedTextColumnBreaker.CHAR_WIDTH + mRulerScale).ToString
                graph.DrawString(scale, Me.mFont, brush, x - 5, 0)
            End If

            'Now draw the tick mark
            graph.DrawLine(pen, x, yStart, x, Me.Height)
        Next
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)
        Me.PaintScale(e.Graphics)
    End Sub

    'When a user clicks on this control
    Private Sub TextColumnScale_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Click
        'Get the mouse point relative to this control
        Dim pt As Point = Me.PointToClient(System.Windows.Forms.Cursor.Position)

        'Raise the Click event
        RaiseEvent Scale_Click(pt)
    End Sub

#End Region

End Class
