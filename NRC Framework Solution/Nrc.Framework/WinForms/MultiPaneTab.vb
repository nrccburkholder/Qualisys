Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.ComponentModel
Imports System.Windows.Forms

Namespace WinForms
    Public Class MultiPaneTab
        Inherits Control

        Private mIsActive As Boolean
        Private mIsHovering As Boolean

        Private mImage As Image
        Private mIcon As Icon
        Private mNavControlType As Type
        Private mNavControlId As String
        Private mMainControlType As Type
        Private mMainControlId As String

        Private mFillBrush As Brush
        Private mFillBrushActive As Brush
        Private mFillBrushHovering As Brush

        Private mBorderPen As Pen

        <Category("Appearance"), Description("Indicates if the control is active")> _
        Public Property IsActive() As Boolean
            Get
                Return mIsActive
            End Get
            Set(ByVal value As Boolean)
                If Not value = mIsActive Then
                    mIsActive = value
                    Me.Invalidate()
                End If
            End Set
        End Property

        <Category("Appearance"), Description("The icon to display in the control")> _
        Public Property Icon() As Icon
            Get
                Return mIcon
            End Get
            Set(ByVal value As Icon)
                mIcon = value
                If mIcon Is Nothing Then
                    mImage = Nothing
                Else
                    mImage = value.ToBitmap
                End If
            End Set
        End Property

        <Category("Appearance"), Description("The image to display in the control")> _
        Public Property Image() As Image
            Get
                Return mImage
            End Get
            Set(ByVal value As Image)
                mImage = value
            End Set
        End Property

        <Category("Data"), Description("The type of the control to be loaded as the navigation control")> _
        Public Property NavControlType() As Type
            Get
                Return mNavControlType
            End Get
            Set(ByVal value As Type)
                mNavControlType = value
            End Set
        End Property
        <Category("Data"), Description("The id of the control to be loaded as the navigation control")> _
        Public Property NavControlId() As String
            Get
                Return mNavControlId
            End Get
            Set(ByVal value As String)
                mNavControlId = value
            End Set
        End Property

        Sub New()
            Me.SetStyle(ControlStyles.OptimizedDoubleBuffer, True)
            Me.Size = New Size(200, 32)
            Me.Cursor = Cursors.Hand
            InitBrushes()
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
            Me.Font = New Font("Tahoma", 8.25, FontStyle.Bold)
        End Sub
        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If disposing Then
                If mFillBrush IsNot Nothing Then mFillBrush.Dispose()
                If mFillBrushActive IsNot Nothing Then mFillBrush.Dispose()
                If mFillBrushHovering IsNot Nothing Then mFillBrush.Dispose()
                If mBorderPen IsNot Nothing Then mBorderPen.Dispose()
                RemoveHandler ThemeInfo.ColorSchemeChanged, AddressOf OnColorSchemeChanged
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Sub InitBrushes()
            If mFillBrush IsNot Nothing Then mFillBrush.Dispose()
            If mFillBrushActive IsNot Nothing Then mFillBrush.Dispose()
            If mFillBrushHovering IsNot Nothing Then mFillBrush.Dispose()
            If mBorderPen IsNot Nothing Then mBorderPen.Dispose()

            If Application.RenderWithVisualStyles Then
                'mFillBrush = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.OverflowButtonGradientBegin, ProfessionalColors.OverflowButtonGradientMiddle, LinearGradientMode.Vertical)
                mFillBrush = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.ToolStripGradientBegin, ProfessionalColors.ToolStripGradientEnd, LinearGradientMode.Vertical)
                mFillBrushActive = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.ButtonCheckedGradientBegin, ProfessionalColors.ButtonCheckedGradientEnd, LinearGradientMode.Vertical)
                mFillBrushHovering = New LinearGradientBrush(Me.DisplayRectangle, ProfessionalColors.ButtonCheckedGradientEnd, ProfessionalColors.ButtonCheckedGradientBegin, LinearGradientMode.Vertical)
                mBorderPen = New Pen(ProfessionalColors.ToolStripBorder)
            Else    'No visual styles
                mFillBrush = New LinearGradientBrush(Me.DisplayRectangle, Color.White, Color.FromArgb(213, 209, 201), LinearGradientMode.Vertical)
                mFillBrushActive = New SolidBrush(Color.LightGray)
                mFillBrushHovering = New SolidBrush(Color.FromArgb(182, 189, 210))
                mBorderPen = New Pen(Color.Gray)
            End If

        End Sub


        Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
            MyBase.OnPaint(e)
            If TypeOf Me.Parent Is MultiPane.TabTray Then
                Me.PaintMiniTab(e.Graphics)
            Else
                Me.PaintFullTab(e.Graphics)
            End If
        End Sub

        Private Sub PaintFullTab(ByVal g As Graphics)
            Dim rect As New Rectangle(0, 0, Me.Width, Me.Height)
            Dim textRect As Rectangle
            Dim imgHeight As Integer = Me.Height - Me.Padding.Top - Me.Padding.Bottom
            Dim imgWidth As Integer = imgHeight
            Dim imageRect As New Rectangle(Me.Padding.Left, Me.Padding.Top, imgWidth, imgHeight)
            If mImage IsNot Nothing Then
                textRect = New Rectangle(Me.Height + 3, 0, Me.Width - 1 - Me.Height, Me.Height - 1)
            Else
                textRect = New Rectangle(3, 0, Me.Width - 1 - 6, Me.Height - 1)

            End If
            Dim format As New StringFormat

            'Fill the background
            If mIsHovering Then
                g.FillRectangle(mFillBrushHovering, rect)
            ElseIf mIsActive Then
                g.FillRectangle(mFillBrushActive, rect)
            Else
                g.FillRectangle(mFillBrush, rect)
            End If

            'Paint the text
            format.LineAlignment = StringAlignment.Center
            format.Trimming = StringTrimming.EllipsisCharacter
            Using textBrush As New SolidBrush(Me.ForeColor)
                g.DrawString(Me.Text, Me.Font, textBrush, textRect, format)
            End Using

            'Paint the image
            If mImage IsNot Nothing Then
                g.DrawImage(mImage, imageRect)
            End If

            'Paint the border line on top of tab
            g.DrawLine(mBorderPen, 0, 0, Me.Width, 0)
        End Sub

        Private Sub PaintMiniTab(ByVal g As Graphics)
            Dim rect As New Rectangle(0, 0, Me.Width, Me.Height)
            Dim textRect As Rectangle
            Dim imgHeight As Integer = Me.Height - Me.Padding.Top - Me.Padding.Bottom
            Dim imgWidth As Integer = imgHeight
            Dim imageRect As New Rectangle(Me.Padding.Left, Me.Padding.Top, imgWidth, imgHeight)
            If mImage IsNot Nothing Then
                textRect = New Rectangle(Me.Height + 3, 0, Me.Width - 1 - Me.Height, Me.Height - 1)
            Else
                textRect = New Rectangle(3, 0, Me.Width - 1 - 6, Me.Height - 1)

            End If

            'Fill the background
            If mIsHovering Then
                g.FillRectangle(mFillBrushHovering, rect)
            ElseIf mIsActive Then
                g.FillRectangle(mFillBrushActive, rect)
            Else
                g.FillRectangle(mFillBrush, rect)
            End If

            'Paint the icon
            If mImage IsNot Nothing Then
                g.DrawImage(mImage, imageRect)
            End If
        End Sub

        Protected Overrides Sub OnMouseEnter(ByVal e As System.EventArgs)
            MyBase.OnMouseEnter(e)
            mIsHovering = True
            Me.Invalidate()
        End Sub

        Protected Overrides Sub OnMouseLeave(ByVal e As System.EventArgs)
            MyBase.OnMouseLeave(e)
            mIsHovering = False
            Me.Invalidate()
        End Sub

        Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
            MyBase.OnResize(e)
            If Me.DisplayRectangle.Width > 0 AndAlso Me.DisplayRectangle.Height > 0 Then
                Me.InitBrushes()
            End If
            Me.Invalidate()
        End Sub

        Protected Overrides Sub OnPaddingChanged(ByVal e As System.EventArgs)
            MyBase.OnPaddingChanged(e)
            Me.Invalidate()
        End Sub

        Private Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            Me.InitBrushes()
            Me.Invalidate()
        End Sub
    End Class
End Namespace
