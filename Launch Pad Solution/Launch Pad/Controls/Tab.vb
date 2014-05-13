Public Class Tab
    Inherits Control

#Region " Private Instance Fields "
    Private mTabLocation As TabLocation = TabLocation.Top
    Private mIsHot As Boolean
    Private mIsSelected As Boolean

    Private mBorderColor As Color = Color.Blue
    Private mBackColorNormal As Color
    Private mBackColorHot As Color
    Private mBackColorSelected As Color

#End Region

#Region " Public Properties "
    Public Property Selected() As Boolean
        Get
            Return mIsSelected
        End Get
        Set(ByVal value As Boolean)
            mIsSelected = value
            Me.Invalidate()
        End Set
    End Property

    Public Property TabLocation() As TabLocation
        Get
            Return mTabLocation
        End Get
        Set(ByVal value As TabLocation)
            mTabLocation = value
        End Set
    End Property

    Public Property BorderColor() As Color
        Get
            Return mBorderColor
        End Get
        Set(ByVal value As Color)
            mBorderColor = value
            Me.Invalidate()
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private ReadOnly Property CurrentBackColor() As Color
        Get
            If mIsSelected Then
                Return mBackColorSelected
            ElseIf mIsHot Then
                Return mBackColorHot
            Else
                Return mBackColorNormal
            End If
        End Get
    End Property
#End Region

#Region " Constructors "
    Sub New()
        Me.Cursor = Cursors.Hand

        If Windows.Forms.Application.RenderWithVisualStyles Then
            mBackColorNormal = Color.LightGray
            mBackColorHot = ProfessionalColors.MenuItemSelectedGradientBegin
            mBackColorSelected = ProfessionalColors.MenuStripGradientBegin
        Else
            mBackColorNormal = Color.LightGray
            mBackColorHot = Color.FromArgb(255, 255, 222)
            mBackColorSelected = Color.FromArgb(158, 190, 245)
        End If

    End Sub
#End Region

#Region " Base Class Overrides "
    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)

        Dim rect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)

        'Fill Background
        Using brush As New SolidBrush(CurrentBackColor)
            e.Graphics.FillRectangle(brush, rect)
        End Using

        Using borderPen As New Pen(mBorderColor)
            If Not Me.mTabLocation = TabLocation.Top OrElse Not Me.mIsSelected Then
                'Draw bottom
                e.Graphics.DrawLine(borderPen, rect.Left, rect.Bottom, rect.Right, rect.Bottom)
            End If
            If Not Me.mTabLocation = TabLocation.Bottom OrElse Not Me.mIsSelected Then
                'Draw top
                e.Graphics.DrawLine(borderPen, rect.Left, rect.Top, rect.Right, rect.Top)
            End If
            If Not Me.mTabLocation = TabLocation.Left OrElse Not Me.mIsSelected Then
                'Draw right
                e.Graphics.DrawLine(borderPen, rect.Right, rect.Top, rect.Right, rect.Bottom)
            End If
            If Not Me.mTabLocation = TabLocation.Right OrElse Not Me.mIsSelected Then
                'Draw left
                e.Graphics.DrawLine(borderPen, rect.Left, rect.Top, rect.Left, rect.Bottom)
            End If
        End Using

        Dim format As New StringFormat
        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Center
        format.Trimming = StringTrimming.EllipsisCharacter

        e.Graphics.DrawString(Me.Text, Me.Font, Brushes.Black, rect, format)
    End Sub

    Protected Overrides Sub OnMouseEnter(ByVal e As System.EventArgs)
        MyBase.OnMouseEnter(e)
        Me.mIsHot = True
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnMouseLeave(ByVal e As System.EventArgs)
        MyBase.OnMouseLeave(e)
        Me.mIsHot = False
        Me.Invalidate()
    End Sub

    Protected Overrides Sub OnMouseClick(ByVal e As System.Windows.Forms.MouseEventArgs)
        MyBase.OnMouseClick(e)
        Me.mIsSelected = True
        Me.Invalidate()
    End Sub
#End Region

    Public Function AutoSizeTab() As Size
        Dim textSize As SizeF = Me.MeasureWidth
        If textSize.Width < Me.Width Then
            Me.Width = CInt(textSize.Width) + 5
        End If

        Return Me.Size
    End Function

    Private Function MeasureWidth() As SizeF
        Dim rect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        Dim format As New StringFormat
        format.Alignment = StringAlignment.Center
        format.LineAlignment = StringAlignment.Center
        format.Trimming = StringTrimming.EllipsisCharacter

        Using g As Graphics = Me.CreateGraphics
            Return g.MeasureString(Me.Text, Me.Font, Me.Size, format)
        End Using
    End Function


End Class
