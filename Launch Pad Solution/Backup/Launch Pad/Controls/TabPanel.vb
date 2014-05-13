Imports System.ComponentModel

Public Enum TabLocation
    Top
    Left
    Right
    Bottom
End Enum


Public Class TabPanel
    Inherits Control

    Private mBorderColor As Color = Color.LightSlateGray
    Private mTabLocation As TabLocation = TabLocation.Left
    Private WithEvents mTabs As TabCollection
    Private mPanel As FlowLayoutPanel
    Private mSelectedTab As Tab

    Private Const mTabSpacing As Integer = 5
    Private mTabSize As Size = New Size(95, 25)

    Public Class TabChangedEventArgs
        Inherits EventArgs

        Private mNewTab As Tab
        Public ReadOnly Property NewTab() As Tab
            Get
                Return mNewTab
            End Get
        End Property

        Sub New(ByVal newTab As Tab)
            mNewTab = newTab
        End Sub

    End Class
    Public Event TabChanged As EventHandler(Of TabChangedEventArgs)

    <DesignerSerializationVisibility(DesignerSerializationVisibility.Content)> _
    Public ReadOnly Property Tabs() As TabCollection
        Get
            Return mTabs
        End Get
    End Property

    Public Property TabLocation() As TabLocation
        Get
            Return mTabLocation
        End Get
        Set(ByVal value As TabLocation)
            mTabLocation = value
            Me.AddTabControls()
        End Set
    End Property

    Public ReadOnly Property Panel() As FlowLayoutPanel
        Get
            Return mPanel
        End Get
    End Property

    Sub New()
        Me.Padding = New Padding(0, 25, 0, 0)
        Me.mTabs = New TabCollection
        Me.mPanel = New FlowLayoutPanel
    End Sub

    Public Sub SelectTab(ByVal newTab As Tab)
        If Me.mTabs.Contains(newTab) Then
            If mSelectedTab IsNot newTab Then
                If mSelectedTab IsNot Nothing Then Me.mSelectedTab.Selected = False
                mSelectedTab = newTab
                mSelectedTab.Selected = True
                Me.OnTabChanged(New TabChangedEventArgs(mSelectedTab))
            End If
        End If
    End Sub

    Private Sub AddTabControls()
        Me.Controls.Clear()

        Dim x As Integer
        Dim y As Integer
        Dim tabSize As Size = Me.mTabSize

        Select Case Me.mTabLocation
            Case LaunchPad.TabLocation.Top, LaunchPad.TabLocation.Left
                x = 0
                y = 0
            Case LaunchPad.TabLocation.Bottom
                x = 0
                y = Me.Height - tabSize.Height
            Case LaunchPad.TabLocation.Right
                x = Me.Width - tabSize.Width
                y = 0
        End Select

        For Each t As Tab In Me.mTabs
            AddHandler t.Click, AddressOf TabClickEventHandler
            t.Size = tabSize
            'tabSize = t.AutoSizeTab()
            t.BorderColor = Me.mBorderColor
            t.TabLocation = Me.mTabLocation
            t.Location = New Point(x, y)
            Me.Controls.Add(t)

            Select Case Me.mTabLocation
                Case LaunchPad.TabLocation.Top, LaunchPad.TabLocation.Bottom
                    x += tabSize.Width + mTabSpacing
                Case LaunchPad.TabLocation.Left, LaunchPad.TabLocation.Right
                    y += tabSize.Height + mTabSpacing
            End Select
        Next

        'Now add the last 

        Dim panelX As Integer
        Dim panelY As Integer
        Dim panelWidth As Integer
        Dim panelHeight As Integer
        Select Case Me.mTabLocation
            Case LaunchPad.TabLocation.Top
                panelX = 1
                panelY = Me.mTabSize.Height + 1
                panelWidth = Me.Width - 2
                panelHeight = Me.Height - Me.mTabSize.Height - 2
            Case LaunchPad.TabLocation.Bottom
                panelX = 1
                panelY = 1
                panelWidth = Me.Width - 2
                panelHeight = Me.Height - Me.mTabSize.Height - 2
            Case LaunchPad.TabLocation.Left
                panelX = Me.mTabSize.Width + 1
                panelY = 1
                panelWidth = Me.Width - Me.mTabSize.Width - 2
                panelHeight = Me.Height - 2
            Case LaunchPad.TabLocation.Right
                panelX = 1
                panelY = 1
                panelWidth = Me.Width - Me.mTabSize.Width - 2
                panelHeight = Me.Height - 2
        End Select

        mPanel.Anchor = (AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right)
        mPanel.Location = New Point(panelX, panelY)
        mPanel.Size = New Size(panelWidth, panelHeight)
        Me.Controls.Add(mPanel)
    End Sub

    Private Sub TabAdded(ByVal sender As Object, ByVal e As EventArgs) Handles mTabs.TabAdded
        Me.AddTabControls()
        If Me.mTabs.Count = 1 Then
            mTabs(0).Selected = True
            Me.mSelectedTab = mTabs(0)
            Me.OnTabChanged(New TabChangedEventArgs(mTabs(0)))
        End If
    End Sub

    Protected Overrides Sub OnPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(e)

        Me.PaintBorder(e.Graphics)
        Me.PaintTabSpacings(e.Graphics)
    End Sub

    Private Sub PaintBorder(ByVal g As Graphics)
        Dim rect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        Dim lineHeight As Integer
        Dim lineWidth As Integer
        Dim xStart As Integer
        Dim yStart As Integer
        Select Case Me.mTabLocation
            Case LaunchPad.TabLocation.Top
                lineHeight = rect.Height - Me.mTabSize.Height
                lineWidth = rect.Width
                xStart = 0
                yStart = Me.mTabSize.Height
            Case LaunchPad.TabLocation.Bottom
                lineHeight = rect.Height - Me.mTabSize.Height
                lineWidth = rect.Width
                xStart = 0
                yStart = 0
            Case LaunchPad.TabLocation.Left
                lineHeight = rect.Height
                lineWidth = rect.Width - Me.mTabSize.Width
                xStart = Me.mTabSize.Width
                yStart = 0
            Case LaunchPad.TabLocation.Right
                lineHeight = rect.Height
                lineWidth = rect.Width - Me.mTabSize.Width
                xStart = 0
                yStart = 0
        End Select

        Using borderPen As New Pen(mBorderColor)
            If Not Me.mTabLocation = LaunchPad.TabLocation.Top Then
                'Draw top
                g.DrawLine(borderPen, xStart, rect.Top, xStart + lineWidth, rect.Top)
            End If
            If Not Me.mTabLocation = LaunchPad.TabLocation.Bottom Then
                'Draw bottom
                g.DrawLine(borderPen, xStart, rect.Bottom, xStart + lineWidth, rect.Bottom)
            End If
            If Not Me.mTabLocation = LaunchPad.TabLocation.Left Then
                'Draw left
                g.DrawLine(borderPen, rect.Left, yStart, rect.Left, yStart + lineHeight)
            End If
            If Not Me.mTabLocation = LaunchPad.TabLocation.Right Then
                'Draw right
                g.DrawLine(borderPen, rect.Right, yStart, rect.Right, yStart + lineHeight)
            End If
        End Using

    End Sub

    Private Sub PaintTabSpacings(ByVal g As Graphics)
        Dim x As Integer
        Dim y As Integer
        Dim spacerWidth As Integer
        Dim spacerHeight As Integer
        Select Case Me.mTabLocation
            Case LaunchPad.TabLocation.Top
                x = Me.mTabSize.Width
                y = Me.mTabSize.Height - 1
                spacerWidth = mTabSpacing
                spacerHeight = 0
            Case LaunchPad.TabLocation.Bottom
                x = Me.mTabSize.Width
                y = Me.Height - Me.mTabSize.Height
                spacerWidth = mTabSpacing
                spacerHeight = 0
            Case LaunchPad.TabLocation.Left
                x = Me.mTabSize.Width - 1
                y = Me.mTabSize.Height
                spacerWidth = 0
                spacerHeight = mTabSpacing
            Case LaunchPad.TabLocation.Right
                x = Me.Width - Me.mTabSize.Width
                y = Me.mTabSize.Height
                spacerWidth = 0
                spacerHeight = mTabSpacing
        End Select

        Using borderPen As New Pen(mBorderColor)
            For i As Integer = 0 To Me.mTabs.Count - 2
                g.DrawLine(borderPen, x, y, x + spacerWidth, y + spacerHeight)
                Select Case Me.mTabLocation
                    Case LaunchPad.TabLocation.Top, LaunchPad.TabLocation.Bottom
                        x += Me.mTabSize.Width + mTabSpacing
                    Case LaunchPad.TabLocation.Left, LaunchPad.TabLocation.Right
                        y += Me.mTabSize.Height + mTabSpacing
                End Select
            Next
            Select Case Me.mTabLocation
                Case LaunchPad.TabLocation.Top, LaunchPad.TabLocation.Bottom
                    spacerWidth = Me.Width - x
                Case LaunchPad.TabLocation.Left, LaunchPad.TabLocation.Right
                    spacerHeight = Me.Height - y
            End Select
            g.DrawLine(borderPen, x, y, x + spacerWidth, y + spacerHeight)
        End Using

    End Sub

    Private Sub TabClickEventHandler(ByVal sender As Object, ByVal e As EventArgs)
        Dim t As Tab = TryCast(sender, Tab)
        If Me.mSelectedTab IsNot Nothing Then Me.mSelectedTab.Selected = False

        If Me.mSelectedTab IsNot t Then
            Me.mSelectedTab = t
            OnTabChanged(New TabChangedEventArgs(t))
        End If

    End Sub

    Protected Sub OnTabChanged(ByVal e As TabChangedEventArgs)
        RaiseEvent TabChanged(Me, e)
    End Sub

End Class
