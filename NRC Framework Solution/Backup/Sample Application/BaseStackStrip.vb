Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Windows.Forms
Imports System.ComponentModel

Namespace WinForms
    Public Class BaseStackStrip
        Inherits ToolStrip

        Private mRenderer As ToolStripProfessionalRenderer


        Public Sub New()
            MyBase.New()

            'Set Dock
            'Me.Dock = DockStyle.Fill
            Me.GripStyle = ToolStripGripStyle.Hidden
            Me.Margin = New Padding(0)
            Me.CanOverflow = False
            Me.AutoSize = False

            'Set renderer - override background painting
            Me.SetRenderer()

            'Setup Fonts
            Me.OnSetFonts()

            'Track Preference Changes
            AddHandler Microsoft.Win32.SystemEvents.UserPreferenceChanged, AddressOf StackStrip_UserPreferenceChanged

        End Sub

        Protected Overridable Sub OnSetRenderer(ByVal pr As ToolStripProfessionalRenderer)
            'Handled by sub-classes
        End Sub

        Protected ReadOnly Property StackStripRenderer() As ToolStripProfessionalRenderer
            Get
                Return mRenderer
            End Get
        End Property

        Protected Overridable Sub OnRenderToolStripBackground(ByVal e As ToolStripRenderEventArgs)
            If Me.StackStripRenderer IsNot Nothing Then
                'Setup colors from the provided renderer
                Dim startColor As Color = StackStripRenderer.ColorTable.ToolStripGradientMiddle
                Dim endColor As Color = StackStripRenderer.ColorTable.ToolStripGradientEnd

                'Size to paint
                Dim rect As New Rectangle(Point.Empty, e.ToolStrip.Size)

                'Make sure we need to paint
                If rect.Width > 0 AndAlso rect.Height > 0 Then
                    Using b As New LinearGradientBrush(rect, startColor, endColor, LinearGradientMode.Vertical)
                        e.Graphics.FillRectangle(b, rect)
                    End Using
                End If

                'Draw border
                'e.Graphics.DrawRectangle(Pens.Red, rect)
                e.Graphics.DrawLine(SystemPens.ControlDarkDark, rect.X, rect.Y, rect.Width - 1, rect.Y)
                e.Graphics.DrawLine(SystemPens.ControlDarkDark, rect.X, rect.Y, rect.X, rect.Height - 1)
                e.Graphics.DrawLine(SystemPens.ControlDarkDark, rect.X + rect.Width - 1, rect.Y, rect.X + rect.Width - 1, rect.Height - 1)
            End If
        End Sub

        Protected Overridable Sub OnSetFonts()
            'Base off system fonts
        End Sub

        Protected Overrides Sub OnRendererChanged(ByVal e As System.EventArgs)
            MyBase.OnRendererChanged(e)

            'Work around but with setting renderer in the constructor
            Me.SetRenderer()
        End Sub

        Private Sub SetRenderer()
            'Set renderer - override background painting
            If TypeOf Me.Renderer Is ToolStripProfessionalRenderer AndAlso Me.Renderer IsNot mRenderer Then
                If mRenderer Is Nothing Then
                    mRenderer = New ToolStripProfessionalRenderer

                    'Square edges
                    mRenderer.RoundedEdges = False

                    'Improve painting (use our colors)
                    AddHandler mRenderer.RenderToolStripBackground, AddressOf BaseStackStrip_RenderToolStripBackground

                    'Call overriable method
                    OnSetRenderer(mRenderer)
                End If

                'Use our renderer
                Me.Renderer = mRenderer
            End If
        End Sub

        Private Sub BaseStackStrip_RenderToolStripBackground(ByVal sender As Object, ByVal e As ToolStripRenderEventArgs)
            'Call overrideable method
            OnRenderToolStripBackground(e)
        End Sub

        Private Sub StackStrip_UserPreferenceChanged(ByVal sender As Object, ByVal e As Microsoft.Win32.UserPreferenceChangedEventArgs)
            'Reset font
            OnSetFonts()
        End Sub
    End Class
End Namespace
