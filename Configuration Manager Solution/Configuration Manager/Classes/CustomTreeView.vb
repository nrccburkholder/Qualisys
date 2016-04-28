Imports System.ComponentModel

Public Class CustomTreeView
    Inherits System.Windows.Forms.TreeView




    Protected Overrides Sub OnDrawNode(e As DrawTreeNodeEventArgs)

        Dim state As TreeNodeStates = e.State
        Dim font As Font = e.Node.NodeFont
        Dim foreColor As Color = e.Node.ForeColor

        If foreColor = Color.Empty Then foreColor = e.Node.TreeView.ForeColor

        If e.Node Is e.Node.TreeView.SelectedNode Then
            foreColor = SystemColors.HighlightText
            e.Graphics.FillRectangle(New SolidBrush(SystemColors.Highlight), e.Bounds)
            ControlPaint.DrawFocusRectangle(e.Graphics, e.Bounds, foreColor, SystemColors.Highlight)
            TextRenderer.DrawText(e.Graphics, e.Node.Text, font, e.Bounds, foreColor, SystemColors.Highlight, TextFormatFlags.GlyphOverhangPadding)
        Else
            e.Graphics.FillRectangle(SystemBrushes.Window, e.Bounds)
            TextRenderer.DrawText(e.Graphics, e.Node.Text, font, e.Bounds, foreColor, TextFormatFlags.GlyphOverhangPadding)
        End If

    End Sub

End Class
