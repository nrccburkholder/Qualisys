Imports System.ComponentModel

Public Class RadioButtonList
    Inherits System.Windows.Forms.ListBox

    Private Const mRadioButtonSize As Integer = 13
    Private mAutoResizeHeight As Boolean = False
    'Private mLastWidth As Integer

    Public Class AutoSizedEventArgs
        Inherits EventArgs

        Private mHeightChange As Integer
        Public ReadOnly Property HeightChange() As Integer
            Get
                Return mHeightChange
            End Get
        End Property
        Sub New(ByVal heightChange As Integer)
            mHeightChange = heightChange
        End Sub
    End Class
    Public Delegate Sub AutoSizedEventHandler(ByVal sender As Object, ByVal e As AutoSizedEventArgs)
    Public Event AutoSized As AutoSizedEventHandler

    <Browsable(True), Category("Behavior")> _
    Public Property AutoResizeHeight() As Boolean
        Get
            Return mAutoResizeHeight
        End Get
        Set(ByVal Value As Boolean)
            mAutoResizeHeight = Value
        End Set
    End Property

    Sub New()
        MyBase.New()

        Me.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawVariable
        Me.BorderStyle = System.Windows.Forms.BorderStyle.None
        'Me.mLastWidth = Me.Width
    End Sub

    Private Sub RadioButtonList_DrawItem(ByVal sender As Object, ByVal e As System.Windows.Forms.DrawItemEventArgs) Handles MyBase.DrawItem
        If e.Index < 0 Then
            e.DrawBackground()
            e.DrawFocusRectangle()
            Exit Sub
        End If

        Dim backBrush As New SolidBrush(Me.BackColor)
        e.Graphics.FillRectangle(backBrush, e.Bounds)
        backBrush.Dispose()
        e.DrawFocusRectangle()

        Dim itemRect As RectangleF = RectangleF.op_Implicit(e.Bounds)
        itemRect.X += mRadioButtonSize
        itemRect.Width -= mRadioButtonSize

        Dim itemColor As Color
        Dim itemFont As Font
        Dim itemText As String
        Try
            itemText = Me.GetItemText(Me.Items(e.Index))
        Catch ex As Exception
            itemText = ""
        End Try

        If (e.State And DrawItemState.Selected) = DrawItemState.Selected Then
            'itemFont = New Font(e.Font, FontStyle.Bold)
            itemFont = e.Font
            System.Windows.Forms.ControlPaint.DrawRadioButton(e.Graphics, e.Bounds.Left, e.Bounds.Top, mRadioButtonSize, mRadioButtonSize, ButtonState.Checked)
        Else
            itemFont = e.Font
            System.Windows.Forms.ControlPaint.DrawRadioButton(e.Graphics, e.Bounds.Left, e.Bounds.Top, mRadioButtonSize, mRadioButtonSize, ButtonState.Normal)
        End If

        If (e.State And DrawItemState.Disabled) = DrawItemState.Disabled OrElse (e.State And DrawItemState.Grayed) = DrawItemState.Grayed Then
            itemColor = Color.Gray
        Else
            itemColor = Me.ForeColor
        End If

        'Draw the text
        Dim itemBrush As New SolidBrush(itemColor)
        e.Graphics.DrawString(itemText, itemFont, itemBrush, itemRect)
        itemBrush.Dispose()
        'itemFont.Dispose()
    End Sub

    Private Sub RadioButtonList_MeasureItem(ByVal sender As Object, ByVal e As System.Windows.Forms.MeasureItemEventArgs) Handles MyBase.MeasureItem
        Dim itemFont As Font
        Dim itemText As String
        Try
            itemText = Me.GetItemText(Me.Items(e.Index))
        Catch ex As Exception
            itemText = ""
        End Try
        e.ItemHeight = mRadioButtonSize

        If e.Index = Me.SelectedIndex Then
            itemFont = New Font(Me.Font, FontStyle.Bold)
        Else
            itemFont = New Font(Me.Font, FontStyle.Bold)
        End If
        'dim format as New StringFormat(StringFormatFlags.NoClip
        Dim textArea As SizeF = e.Graphics.MeasureString(itemText, itemFont, Me.Width - mRadioButtonSize)

        If textArea.Height > e.ItemHeight Then
            e.ItemHeight = CType(textArea.Height, Integer)
        End If
        'me.inte
    End Sub

    Protected Overrides Sub OnDataSourceChanged(ByVal e As System.EventArgs)
        MyBase.OnDataSourceChanged(e)

        If Me.mAutoResizeHeight Then
            Dim totalHeight As Integer = 0
            Dim difference As Integer = 0

            For i As Integer = 0 To Me.Items.Count - 1
                totalHeight += Me.GetItemHeight(i)
            Next
            difference = totalHeight - Me.Height

            If Not difference = 0 Then
                Me.Height += difference
                RaiseEvent AutoSized(Me, New AutoSizedEventArgs(difference))
            End If
        End If

    End Sub
End Class
