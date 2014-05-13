Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Windows.Forms
Imports System.ComponentModel

Namespace WinForms
    Public Class SelectedItemChangedEventArgs
        Inherits EventArgs

        Private mOldItem As ToolStripItem
        Private mNewItem As ToolStripItem

        Public ReadOnly Property OldItem() As ToolStripItem
            Get
                Return mOldItem
            End Get
        End Property
        Public ReadOnly Property NewItem() As ToolStripItem
            Get
                Return mNewItem
            End Get
        End Property

        Public Sub New(ByVal oldItem As ToolStripItem, ByVal newItem As ToolStripItem)
            mOldItem = oldItem
            mNewItem = newItem
        End Sub

    End Class
    Public Class StackStrip
        Inherits BaseStackStrip

        Public Event ItemHeightChanged As EventHandler
        Public Event SelectedItemChanged As EventHandler(Of SelectedItemChangedEventArgs)

        Private mSelectedButton As ToolStripButton
        Private mFont As Font

        Public Sub New()
            MyBase.New()

            Me.LayoutStyle = ToolStripLayoutStyle.VerticalStackWithOverflow
        End Sub

        Public Property SelectedButton() As ToolStripButton
            Get
                Return Me.mSelectedButton
            End Get
            Set(ByVal value As ToolStripButton)
                If value IsNot Nothing AndAlso value IsNot mSelectedButton Then
                    value.Checked = True
                End If
            End Set
        End Property
        Public ReadOnly Property ItemCount() As Integer
            Get
                Return Me.Items.Count
            End Get
        End Property


        Public ReadOnly Property ItemHeight() As Integer
            Get
                If ItemCount > 0 Then
                    Return Me.Items(0).Height
                Else
                    Return 32
                End If
            End Get
        End Property

        Protected Overrides Sub OnItemRemoved(ByVal e As System.Windows.Forms.ToolStripItemEventArgs)
            MyBase.OnItemRemoved(e)
            If Me.mSelectedButton Is e.Item Then
                Me.mSelectedButton = Nothing
            End If
        End Sub

        Protected Overrides Sub OnSetRenderer(ByVal pr As System.Windows.Forms.ToolStripProfessionalRenderer)
            MyBase.OnSetRenderer(pr)

            'Button Painting
            AddHandler pr.RenderButtonBackground, AddressOf StackStrip_RenderButtonBackground
        End Sub

        Protected Overrides Sub OnRenderToolStripBackground(ByVal e As System.Windows.Forms.ToolStripRenderEventArgs)

        End Sub

        Protected Overrides Sub OnSetFonts()
            Me.mFont = New Font(SystemFonts.IconTitleFont, FontStyle.Bold)

            'Update if different
            If Me.Font IsNot Me.mFont Then
                Me.Font = Me.mFont

                'Notify container
                OnItemHeightChanged(EventArgs.Empty)
            End If
        End Sub

        Protected Overridable Sub OnItemHeightChanged(ByVal e As EventArgs)
            RaiseEvent ItemHeightChanged(Me, e)
        End Sub

        Protected Overrides Sub OnItemAdded(ByVal e As ToolStripItemEventArgs)
            Dim btn As ToolStripButton = TryCast(e.Item, ToolStripButton)

            If btn IsNot Nothing Then
                'Attach to click event
                Me.RegisterButtonForCheckChanged(btn)
            End If
        End Sub

        Private Sub StackStrip_RenderButtonBackground(ByVal sender As Object, ByVal e As ToolStripItemRenderEventArgs)
            Dim g As Graphics = e.Graphics
            Dim rect As New Rectangle(Point.Empty, e.Item.Size)

            Dim startColor As Color = StackStripRenderer.ColorTable.ImageMarginGradientMiddle
            Dim endColor As Color = StackStripRenderer.ColorTable.ImageMarginGradientEnd

            Dim button As ToolStripButton = TryCast(e.Item, ToolStripButton)
            If button.Pressed OrElse button.Checked Then
                startColor = StackStripRenderer.ColorTable.ButtonPressedGradientBegin
                endColor = StackStripRenderer.ColorTable.ButtonPressedGradientEnd
            ElseIf button.Selected Then
                startColor = StackStripRenderer.ColorTable.ButtonSelectedGradientBegin
                endColor = StackStripRenderer.ColorTable.ButtonSelectedGradientEnd
            End If

            'Draw button background
            Using b As New LinearGradientBrush(rect, startColor, endColor, LinearGradientMode.Vertical)
                g.FillRectangle(b, rect)
            End Using

            'Draw outline
            e.Graphics.DrawRectangle(SystemPens.ControlDarkDark, rect)
        End Sub

        Private Sub RegisterButtonForCheckChanged(ByVal btn As ToolStripButton)
            If btn IsNot Nothing Then
                AddHandler btn.CheckedChanged, AddressOf StackStripButton_CheckedChanged
            End If
        End Sub
        Private Sub UnregisterButtonForCheckChanged(ByVal btn As ToolStripButton)
            If btn IsNot Nothing Then
                RemoveHandler btn.CheckedChanged, AddressOf StackStripButton_CheckedChanged
            End If
        End Sub

        Protected Overridable Sub OnSelectedItemChanged(ByVal e As SelectedItemChangedEventArgs)
            RaiseEvent SelectedItemChanged(Me, e)
        End Sub

        Private Sub StackStripButton_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
            Dim btn As ToolStripButton = TryCast(sender, ToolStripButton)

            'Should never but null - but in case someone adds a label
            If btn IsNot Nothing Then
                If btn.Checked Then
                    If (mSelectedButton IsNot btn) AndAlso (mSelectedButton IsNot Nothing) Then
                        'Unset
                        Me.UnregisterButtonForCheckChanged(mSelectedButton)
                        mSelectedButton.Checked = False
                        Me.RegisterButtonForCheckChanged(mSelectedButton)
                        Me.OnSelectedItemChanged(New SelectedItemChangedEventArgs(mSelectedButton, btn))
                    End If

                    mSelectedButton = btn
                Else
                    'Make sure something is checked
                    Dim foundItem As Boolean = False

                    For Each item As ToolStripItem In Me.Items
                        Dim stripButton As ToolStripButton = TryCast(item, ToolStripButton)

                        If stripButton IsNot Nothing Then
                            If stripButton.Checked Then
                                foundItem = True
                                Exit For
                            End If
                        End If
                    Next

                    'Verify
                    If Not foundItem Then
                        'Select the last item
                        mSelectedButton = btn
                        Me.UnregisterButtonForCheckChanged(btn)
                        btn.Checked = True
                        Me.RegisterButtonForCheckChanged(btn)
                    End If
                End If
            End If

        End Sub

    End Class

End Namespace
