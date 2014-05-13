Imports Microsoft.Win32
Imports System
Imports System.Drawing

Namespace WinForms

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : WinForms.ProColors
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Defines some theme specific colors used in professional looking applications like MS Office.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public NotInheritable Class ProColors
        <ThreadStatic()> Private Shared proColorTable As proColorTable

        Shared Sub New()
            InitColorTable()
            AddHandler ThemeInfo.ColorSchemeChanged, AddressOf ProColors.OnColorSchemeChanged
        End Sub

        'This is a static class
        Private Sub New()
        End Sub

        Private Shared Sub InitColorTable()
            'Just set the table to nothing and then the next access will reinitialize
            ProColors.proColorTable = Nothing
        End Sub

        Private Shared Sub OnColorSchemeChanged(ByVal sender As Object, ByVal e As EventArgs)
            'When the color scheme changes then we need to rebuild the color table
            InitColorTable()
        End Sub

        Friend Shared ReadOnly Property ColorTable() As proColorTable
            Get
                If (ProColors.proColorTable Is Nothing) Then
                    ProColors.proColorTable = New ProColorTable
                End If
                Return ProColors.proColorTable
            End Get
        End Property

#Region " Color Properties "
        Public Shared ReadOnly Property ButtonCheckedGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ButtonCheckedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ButtonCheckedGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ButtonCheckedGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ButtonCheckedGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.ButtonCheckedGradientMiddle
            End Get
        End Property


        'Public Shared ReadOnly Property ButtonCheckedHighlight() As Color
        '    Get
        '        Return ProColors.ColorTable.ButtonCheckedHighlight
        '    End Get
        'End Property


        Public Shared ReadOnly Property ButtonCheckedHighlightBorder() As Color
            Get
                Return ProColors.ColorTable.ButtonCheckedHighlightBorder
            End Get
        End Property


        Public Shared ReadOnly Property ButtonPressedBorder() As Color
            Get
                Return ProColors.ColorTable.ButtonPressedBorder
            End Get
        End Property


        Public Shared ReadOnly Property ButtonPressedGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ButtonPressedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ButtonPressedGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ButtonPressedGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ButtonPressedGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.ButtonPressedGradientMiddle
            End Get
        End Property


        'Public Shared ReadOnly Property ButtonPressedHighlight() As Color
        '    Get
        '        Return ProColors.ColorTable.ButtonPressedHighlight
        '    End Get
        'End Property


        Public Shared ReadOnly Property ButtonPressedHighlightBorder() As Color
            Get
                Return ProColors.ColorTable.ButtonPressedHighlightBorder
            End Get
        End Property


        Public Shared ReadOnly Property ButtonSelectedBorder() As Color
            Get
                Return ProColors.ColorTable.ButtonCheckedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ButtonSelectedGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ButtonSelectedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ButtonSelectedGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ButtonSelectedGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ButtonSelectedGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.ButtonSelectedGradientMiddle
            End Get
        End Property


        'Public Shared ReadOnly Property ButtonSelectedHighlight() As Color
        '    Get
        '        Return ProColors.ColorTable.ButtonSelectedHighlight
        '    End Get
        'End Property


        Public Shared ReadOnly Property ButtonSelectedHighlightBorder() As Color
            Get
                Return ProColors.ColorTable.ButtonSelectedHighlightBorder
            End Get
        End Property


        Public Shared ReadOnly Property CheckBackground() As Color
            Get
                Return ProColors.ColorTable.CheckBackground
            End Get
        End Property


        Public Shared ReadOnly Property CheckPressedBackground() As Color
            Get
                Return ProColors.ColorTable.CheckPressedBackground
            End Get
        End Property


        Public Shared ReadOnly Property CheckSelectedBackground() As Color
            Get
                Return ProColors.ColorTable.CheckSelectedBackground
            End Get
        End Property

        Public Shared ReadOnly Property GripDark() As Color
            Get
                Return ProColors.ColorTable.GripDark
            End Get
        End Property


        Public Shared ReadOnly Property GripLight() As Color
            Get
                Return ProColors.ColorTable.GripLight
            End Get
        End Property


        Public Shared ReadOnly Property ImageMarginGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ImageMarginGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ImageMarginGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ImageMarginGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ImageMarginGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.ImageMarginGradientMiddle
            End Get
        End Property


        Public Shared ReadOnly Property ImageMarginRevealedGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ImageMarginRevealedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ImageMarginRevealedGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ImageMarginRevealedGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ImageMarginRevealedGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.ImageMarginRevealedGradientMiddle
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemBorder() As Color
            Get
                Return ProColors.ColorTable.MenuItemBorder
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemPressedGradientBegin() As Color
            Get
                Return ProColors.ColorTable.MenuItemPressedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemPressedGradientEnd() As Color
            Get
                Return ProColors.ColorTable.MenuItemPressedGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemPressedGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.MenuItemPressedGradientMiddle
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemSelected() As Color
            Get
                Return ProColors.ColorTable.MenuItemBorder
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemSelectedGradientBegin() As Color
            Get
                Return ProColors.ColorTable.MenuItemSelectedGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property MenuItemSelectedGradientEnd() As Color
            Get
                Return ProColors.ColorTable.MenuItemSelectedGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property MenuStripGradientBegin() As Color
            Get
                Return ProColors.ColorTable.MenuStripGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property MenuStripGradientEnd() As Color
            Get
                Return ProColors.ColorTable.MenuStripGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property OverflowButtonGradientBegin() As Color
            Get
                Return ProColors.ColorTable.OverflowButtonGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property OverflowButtonGradientEnd() As Color
            Get
                Return ProColors.ColorTable.OverflowButtonGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property OverflowButtonGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.OverflowButtonGradientMiddle
            End Get
        End Property


        Public Shared ReadOnly Property RaftingContainerGradientBegin() As Color
            Get
                Return ProColors.ColorTable.RaftingContainerGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property RaftingContainerGradientEnd() As Color
            Get
                Return ProColors.ColorTable.RaftingContainerGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property SeparatorDark() As Color
            Get
                Return ProColors.ColorTable.SeparatorDark
            End Get
        End Property


        Public Shared ReadOnly Property SeparatorLight() As Color
            Get
                Return ProColors.ColorTable.SeparatorLight
            End Get
        End Property


        Public Shared ReadOnly Property StatusStripGradientBegin() As Color
            Get
                Return ProColors.ColorTable.StatusStripGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property StatusStripGradientEnd() As Color
            Get
                Return ProColors.ColorTable.StatusStripGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripBorder() As Color
            Get
                Return ProColors.ColorTable.ToolStripBorder
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripContentPanelGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ToolStripContentPanelGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripContentPanelGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ToolStripContentPanelGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripDropDownBackground() As Color
            Get
                Return ProColors.ColorTable.ToolStripDropDownBackground
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ToolStripGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ToolStripGradientEnd
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripGradientMiddle() As Color
            Get
                Return ProColors.ColorTable.ToolStripGradientMiddle
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripPanelGradientBegin() As Color
            Get
                Return ProColors.ColorTable.ToolStripPanelGradientBegin
            End Get
        End Property


        Public Shared ReadOnly Property ToolStripPanelGradientEnd() As Color
            Get
                Return ProColors.ColorTable.ToolStripPanelGradientEnd
            End Get
        End Property
#End Region

    End Class

End Namespace
