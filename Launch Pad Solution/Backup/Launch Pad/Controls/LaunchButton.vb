Imports System.Drawing.Drawing2D
Imports Nrc.LaunchPad.Library

Public MustInherit Class LaunchButton
    Inherits ButtonBase

#Region " Private Instance Fields "
    Private mIsPushed As Boolean
    Private mIsHot As Boolean
    Private mApplication As Application
#End Region

#Region " Public Properties "
    Public Property Application() As Application
        Get
            Return mApplication
        End Get
        Set(ByVal value As Application)
            mApplication = value
        End Set
    End Property
#End Region

#Region " Protected Properties "
    Protected ReadOnly Property IsPushed() As Boolean
        Get
            Return mIsPushed
        End Get
    End Property

    Protected ReadOnly Property IsHot() As Boolean
        Get
            Return mIsHot
        End Get
    End Property

    Protected Overrides ReadOnly Property DefaultCursor() As System.Windows.Forms.Cursor
        Get
            Return Cursors.Hand
        End Get
    End Property
#End Region

#Region " Constructors "
    Sub New()
        Me.Cursor = Me.DefaultCursor
    End Sub
#End Region

#Region " Abstract Methods "
    Protected MustOverride Sub InitBrushes()
    Protected MustOverride Sub DisposeBrushes()
    Protected MustOverride Sub PaintBackground(ByVal g As Graphics)
    Protected MustOverride Sub PaintControl(ByVal g As Graphics)
#End Region

#Region " Base Class Overrides "
    Protected Overrides Sub OnPaint(ByVal pevent As System.Windows.Forms.PaintEventArgs)
        'Call the abstract paint methods 

        'Paint the control background
        Me.PaintBackground(pevent.Graphics)

        'Paint the control
        Me.PaintControl(pevent.Graphics)
    End Sub

    Protected Overrides Sub OnMouseDown(ByVal mevent As System.Windows.Forms.MouseEventArgs)
        'On mouse down toggle the IsPushed property

        MyBase.OnMouseDown(mevent)
        If mevent.Button = Windows.Forms.MouseButtons.Left Then
            Me.mIsPushed = True
            Me.Invalidate()
        End If
    End Sub

    Protected Overrides Sub OnMouseUp(ByVal mevent As System.Windows.Forms.MouseEventArgs)
        'On mouse up toggle the IsPushed property

        MyBase.OnMouseUp(mevent)
        If mevent.Button = Windows.Forms.MouseButtons.Left Then
            Me.mIsPushed = False
            Me.Invalidate()
        End If
    End Sub

    Protected Overrides Sub OnMouseEnter(ByVal eventargs As System.EventArgs)
        'On mouse enter toggle the IsHot property

        MyBase.OnMouseEnter(eventargs)
        mIsHot = True

        'If there is no application or no path then show the "No" cursor
        If Me.mApplication Is Nothing OrElse String.IsNullOrEmpty(Me.mApplication.Path) Then
            Me.Cursor = Cursors.No
        End If
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnMouseLeave(ByVal eventargs As System.EventArgs)
        'On mouse leave toggle the IsHot property

        MyBase.OnMouseLeave(eventargs)
        mIsHot = False

        'Set the cursor back to the default
        Me.Cursor = Me.DefaultCursor
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnBackColorChanged(ByVal e As System.EventArgs)
        'Need to re-initialize the brushes if back color changes

        MyBase.OnBackColorChanged(e)

        Me.InitBrushes()
        Me.Invalidate()
    End Sub

    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        MyBase.Dispose(disposing)
        If disposing Then
            Me.DisposeBrushes()
        End If
    End Sub

#End Region

#Region " Protected Helper Functions "
    Protected Shared Function GetRoundedRectPath(ByVal rect As Rectangle, ByVal radius As Integer) As GraphicsPath
        Dim diameter As Integer = 2 * radius
        Dim arcRect As New Rectangle(rect.Location, New Size(diameter, diameter))
        Dim path As New GraphicsPath

        'top left
        path.AddArc(arcRect, 180, 90)

        'top right
        arcRect.X = rect.Right - diameter
        path.AddArc(arcRect, 270, 90)

        'bottom right
        arcRect.Y = rect.Bottom - diameter
        path.AddArc(arcRect, 0, 90)

        'bottom left
        arcRect.X = rect.Left
        path.AddArc(arcRect, 90, 90)

        path.CloseFigure()
        Return path
    End Function
#End Region

    ''' <summary>Factory method to return an instance of the right sub class</summary>
    ''' <param name="style">The view style for the button that should be returned</param>
    Public Shared Function GetNewLaunchButton(ByVal style As ViewStyle) As LaunchButton
        Select Case style
            Case ViewStyle.List
                Return New ListLaunchButton
            Case ViewStyle.Tiles
                Return New TileLaunchButton
            Case Else
                Return New ListLaunchButton
        End Select
    End Function

End Class
