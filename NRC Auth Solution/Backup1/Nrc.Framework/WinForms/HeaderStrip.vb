Imports System.Windows.Forms
Imports System.ComponentModel
Imports System.Drawing
Imports System.Drawing.Drawing2D

Namespace WinForms
    Public Class HeaderStrip
        Inherits ToolStrip

#Region " Private Instance Fields "
        Private mHeaderStyle As HeaderStripStyle = HeaderStripStyle.Large
        Private mRenderer As ToolStripProfessionalRenderer
#End Region

#Region " Constructors "
        Public Sub New()
            MyBase.New()

            'Set the dock
            Me.Dock = DockStyle.Top
            Me.GripStyle = ToolStripGripStyle.Hidden
            Me.AutoSize = False

            'Set the renderer - override background painting
            Me.SetRenderer()

            'Track Preference Changes
            AddHandler Microsoft.Win32.SystemEvents.UserPreferenceChanged, AddressOf HeaderStrip_UserPreferenceChanged

            'Setup Headers
            Me.SetHeaderStyle()

        End Sub
#End Region

#Region " Public Properties "
        <DefaultValue(HeaderStripStyle.Large), Category("Appearance")> _
             Public Property HeaderStyle() As HeaderStripStyle
            Get
                Return mHeaderStyle
            End Get
            Set(ByVal value As HeaderStripStyle)
                If mHeaderStyle <> value Then
                    mHeaderStyle = value

                    'Set Header Style
                    Me.SetHeaderStyle()
                End If
            End Set
        End Property
#End Region

#Region " Base Class Overrides "
        Protected Overrides Sub OnRendererChanged(ByVal e As System.EventArgs)
            MyBase.OnRendererChanged(e)

            'Work around bug with setting renderer in the constructor
            Me.SetRenderer()
        End Sub
#End Region

#Region " Private Methods "
        Private Sub SetHeaderStyle()
            'Get system font
            Dim sysFont As Font = SystemFonts.MenuFont

            If mHeaderStyle = HeaderStripStyle.Large Then
                Me.Font = New Font("Tahoma", sysFont.SizeInPoints + 3.75F, FontStyle.Bold)
                Me.ForeColor = Color.White
            Else
                Me.Font = sysFont
                Me.ForeColor = Color.Black
            End If

            'Only way to calculate size
            Dim tsl As New ToolStripLabel
            tsl.Font = Me.Font
            tsl.Text = "I"

            'Set Size
            Me.Height = tsl.GetPreferredSize(System.Drawing.Size.Empty).Height + 6

        End Sub

        Private Sub SetRenderer()
            'Set renderer - override background painting
            If TypeOf Me.Renderer Is ToolStripProfessionalRenderer AndAlso Me.Renderer IsNot mRenderer Then
                If mRenderer Is Nothing Then
                    mRenderer = New ToolStripProfessionalRenderer

                    'Square edges
                    mRenderer.RoundedEdges = False

                    'Improve painting (use our colors)
                    AddHandler mRenderer.RenderToolStripBackground, AddressOf Renderer_RenderToolStripBackground
                End If

                'Use our renderer
                Me.Renderer = mRenderer
            End If
        End Sub

        Private Sub Renderer_RenderToolStripBackground(ByVal sender As Object, ByVal e As ToolStripRenderEventArgs)
            Dim startColor As Color
            Dim endColor As Color

            If TypeOf Me.Renderer Is ToolStripProfessionalRenderer Then
                Dim pr As ToolStripProfessionalRenderer = TryCast(Me.Renderer, ToolStripProfessionalRenderer)

                'Setup colors from the provided renderer
                If mHeaderStyle = HeaderStripStyle.Large Then
                    startColor = pr.ColorTable.OverflowButtonGradientMiddle
                    endColor = pr.ColorTable.OverflowButtonGradientEnd
                Else
                    startColor = pr.ColorTable.MenuStripGradientEnd
                    endColor = pr.ColorTable.MenuStripGradientBegin
                End If

                'Size to paint
                Dim rect As New Rectangle(Point.Empty, e.ToolStrip.Size)

                'Make sure we need to paint
                If rect.Width > 0 AndAlso rect.Height > 0 Then
                    Using b As Brush = New LinearGradientBrush(rect, startColor, endColor, LinearGradientMode.Vertical)
                        e.Graphics.FillRectangle(b, rect)
                    End Using
                End If
            End If
        End Sub

        Private Sub HeaderStrip_UserPreferenceChanged(ByVal sender As Object, ByVal e As Microsoft.Win32.UserPreferenceChangedEventArgs)
            Me.SetHeaderStyle()
        End Sub
#End Region

    End Class

End Namespace
