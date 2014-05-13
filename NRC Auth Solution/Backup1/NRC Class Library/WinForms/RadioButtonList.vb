'Copyright (C) 2004 Microsoft Corporation
'All rights reserved.
'
'THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
'EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
'MERCHANTIBILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
'
'Date: May 2004
'Author: Duncan Mackenzie
'
'Requires the 1.1 version of the .NET Framework

Option Strict On
Option Explicit On 

Imports System
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Windows.Forms
Imports System.ComponentModel

Namespace WinForms
    <DefaultEvent("SelectedValueChanged")> _
    Public Class RadioButtonList
        Inherits ListControl

        Private m_buttonSize As Integer = 13
        Private m_currentTopPosition As Integer
        Private m_AutoSize As Boolean = True
        Private m_VerticalSpacing As Integer = 10
        Private m_HorizontalSpacing As Integer = 7
        Private m_borderStyle As Border3DStyle = Border3DStyle.RaisedOuter
        Private m_focusedItem As Integer = 0
        Private m_focusRectInflation As Integer = 2
        Private m_rowStarts() As Integer = {0}
        Private m_textHeight As Integer
        Private WithEvents vSB As VScrollBar

        Public Property focusedItem() As Integer
            Get
                Return m_focusedItem
            End Get
            Set(ByVal Value As Integer)
                m_focusedItem = Value
                If Me.m_currentTopPosition > m_rowStarts(Me.focusedItem) Then
                    Me.m_currentTopPosition = m_rowStarts(Me.focusedItem) _
                    - Me.m_VerticalSpacing
                Else
                    If (Me.m_currentTopPosition < m_rowStarts(Me.focusedItem)) _
                    AndAlso ((Me.m_currentTopPosition + Me.Height) < _
                            m_rowStarts(Me.focusedItem)) Then
                        Me.m_currentTopPosition = m_rowStarts(Me.focusedItem) _
                        - Me.m_VerticalSpacing
                    End If
                End If
                Me.Invalidate()
            End Set
        End Property

        Public Sub New()
            'Setting this style causes the control to 
            'receive a paint message after a resize
            'This is critical to this control because a '
            'resize could change the number of items that fit
            Me.SetStyle(ControlStyles.ResizeRedraw, True)

            'The next 3 styles are all to avoid flicker in my
            'graphics routines
            Me.SetStyle(ControlStyles.DoubleBuffer, True)
            Me.SetStyle(ControlStyles.AllPaintingInWmPaint, True)
            Me.SetStyle(ControlStyles.UserPaint, True)

        End Sub

        Public Property buttonSize() As Integer
            Get
                Return m_buttonSize
            End Get
            Set(ByVal Value As Integer)
                m_buttonSize = Value
            End Set
        End Property

        Protected Overrides Sub SetItemsCore( _
                ByVal items As System.Collections.IList)
            If items Is Nothing OrElse items.Count = 0 Then
                m_focusedItem = 0
                m_textHeight = 0
            End If

            RecalcSizing()
        End Sub

        Private Sub RecalcSizing()
            If Me.DataManager Is Nothing Then
                ReDim m_rowStarts(0)
                m_rowStarts(0) = 0
                m_focusedItem = 0
                m_textHeight = 0
            Else
                ReDim m_rowStarts(Me.DataManager.List.Count - 1)
                m_rowStarts(0) = m_VerticalSpacing
                focusedItem = 0
                Dim rowHeight, rowWidth As Integer
                Dim rowSize As SizeF
                Dim sf As StringFormat
                sf = sf.GenericTypographic
                sf.FormatFlags = sf.FormatFlags Or StringFormatFlags.NoWrap
                Dim g As Graphics = Me.CreateGraphics()

                For i As Integer = 1 To DataManager.Count - 1
                    rowSize = g.MeasureString(Me.GetItemText( _
                        DataManager.List(i - 1)), Me.Font, _
                        New PointF(0, 0), sf)
                    m_rowStarts(i) = m_rowStarts(i - 1) + _
                        CInt(rowSize.Height) + m_VerticalSpacing
                Next

                m_textHeight = _
                    m_rowStarts(datamanager.Count - 1) + _
                        CInt(g.MeasureString( _
                            Me.GetItemText(datamanager.List(datamanager.Count - 1)), _
                            Me.Font, New PointF(0, 0), sf).Height) _
                    + m_VerticalSpacing
            End If

            Debug.WriteLine(m_rowStarts(0))

            If Me.AutoSize Then
                Me.Height = m_textHeight
            Else
                If Me.Height < m_textHeight Then
                    If vSB Is Nothing Then
                        vSB = New VScrollBar
                        Me.Controls.Add(vSB)
                    End If
                    With vSB
                        .Top = 0
                        .Left = Me.Width - .Width
                        .Height = Me.Height
                        .Visible = True
                        .Maximum = m_textHeight - Me.Height
                        .Minimum = 0
                        .Value = 0
                        .LargeChange = .Maximum \ 10
                        .SmallChange = 1
                    End With
                Else
                    If Not vSB Is Nothing Then
                        Me.Controls.Remove(vSB)
                        vSB = Nothing
                    End If
                End If
            End If
            Me.Invalidate()
        End Sub

        Private Sub vScrollChanged(ByVal sender As Object, _
            ByVal e As EventArgs) Handles vSB.ValueChanged
            Dim sb As VScrollBar
            sb = DirectCast(sender, VScrollBar)
            Me.m_currentTopPosition = sb.Value
            Me.Invalidate()
        End Sub

#Region "Graphic Work"

        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
            If Me.DesignMode Then
                PaintDesignMode(e)
                Exit Sub
            End If
            Dim myList As IList
            Dim gr As Graphics = e.Graphics
            gr.PageUnit = GraphicsUnit.Pixel

            gr.Clear(Me.BackColor)
            ControlPaint.DrawBorder3D(gr, Me.DisplayRectangle, m_borderStyle)
            gr.TranslateTransform(0, -1 * Me.m_currentTopPosition)

            If Me.DataManager Is Nothing Then
                myList = Nothing
            Else
                myList = Me.DataManager.List
                Dim itemCount As Integer
                itemCount = myList.Count

                Dim i As Integer 'loop indexes

                For i = 0 To itemCount - 1
                    DrawOneItem(i, gr)
                Next
            End If
        End Sub

        Private Sub PaintDesignMode(ByVal e As PaintEventArgs)
            Dim y As Integer = 0
            Dim count As Integer = CInt(Me.Height / 24)
            Dim i As Integer
            Dim rect As Rectangle
            'MessageBox.Show("here we are in design mode")
            For i = 1 To count

                rect = New Rectangle(0, y, 12, 12)
                If i = 2 Then
                    ControlPaint.DrawRadioButton(e.Graphics, rect, ButtonState.Checked)
                Else
                    ControlPaint.DrawRadioButton(e.Graphics, rect, ButtonState.Normal)
                End If

                e.Graphics.DrawString("Radio Button " & i, Me.Font, Brushes.Black, 15, y)
                y += 24
            Next
        End Sub


        Private Sub DrawOneItem(ByVal index As Integer, ByVal gr As Graphics)
            Dim textFont As Font = Me.Font
            Dim textBrush As _
                New SolidBrush(Me.ForeColor)

            Dim myStringFormat As New StringFormat
            myStringFormat.Alignment = StringAlignment.Near
            myStringFormat.FormatFlags = StringFormatFlags.LineLimit

            Dim leftPos As Integer = m_HorizontalSpacing
            Dim topPos As Integer = m_rowStarts(index)

            'grab the display member text from the data source
            Dim itemText As String = _
                Me.GetItemText(Me.DataManager.List.Item(index))

            'the ButtonState indicates 
            'how the Radio Button should be drawn
            Dim bs As ButtonState

            'should it be grayed out?
            If Not Me.Enabled Then
                bs = bs Or ButtonState.Inactive
            End If

            'should it be selected?
            If Me.SelectedIndex = index Then
                bs = bs Or ButtonState.Checked
            End If

            'draw focus rectangle (dotted line)
            If Me.focusedItem = index Then
                Dim rowSize As SizeF
                rowSize = gr.MeasureString(itemText, textFont, _
                    New PointF(leftPos, topPos), myStringFormat)
                Dim focusRect As New Rectangle(leftPos, topPos, _
                    CInt(rowSize.Width) + m_buttonSize, CInt(rowSize.Height))
                focusRect.Inflate(m_focusRectInflation, _
                    m_focusRectInflation)
                ControlPaint.DrawFocusRectangle(gr, focusRect)
            End If

            ControlPaint.DrawRadioButton(gr, _
                    New Rectangle(leftPos, topPos, _
                    m_buttonSize, m_buttonSize), bs)

            gr.DrawString(itemText, _
                    textFont, textBrush, leftPos + m_buttonSize, _
                    topPos, myStringFormat)
        End Sub

        Private Function GetItemRect(ByVal index As Integer) As Rectangle
            Dim itemRect As Rectangle
            If index < (m_rowStarts.GetLength(0) - 1) Then
                itemRect = New Rectangle(0, m_rowStarts(index), Me.Width, _
                    m_rowStarts(index + 1) - m_rowStarts(index))
            Else
                itemRect = New Rectangle(0, m_rowStarts(index), Me.Width, _
                    m_textHeight - m_rowStarts(index))
            End If
            Return itemRect
        End Function

        Protected Overrides Sub RefreshItem(ByVal index As Integer)
            Debug.WriteLine(String.Format("Refreshing {0}", index))
            Dim itemRect As Rectangle = GetItemRect(index)
            itemRect.Inflate(5, 5)
            Me.Invalidate(itemRect)
        End Sub

#End Region

#Region "Properties"
        <Category("Appearance")> _
        Public Property AutoSize() As Boolean
            Get
                Return m_AutoSize
            End Get
            Set(ByVal Value As Boolean)
                If Not (m_AutoSize = Value) Then
                    m_AutoSize = Value
                    Me.Invalidate()
                End If
            End Set
        End Property

        <Category("Appearance")> _
        Public Property Border3DStyle() As Border3DStyle
            Get
                Return m_borderStyle
            End Get
            Set(ByVal Value As Border3DStyle)
                If Not (m_borderStyle = Value) Then
                    m_borderStyle = Value
                    Me.Invalidate()
                End If
            End Set
        End Property

        <Browsable(False)> _
        Public Overrides Property SelectedIndex() As Integer
            Get
                If Not Me.DataManager Is Nothing Then
                    Return Me.DataManager.Position
                Else
                    Return -1
                End If
            End Get
            Set(ByVal Value As Integer)
                If Not Me.DataManager Is Nothing Then
                    Me.DataManager.Position = Value
                    Me.focusedItem = Value
                    Me.OnSelectedIndexChanged(New System.EventArgs)
                    Me.Invalidate() 'redraw the whole thing
                End If
            End Set
        End Property

        <Category("Layout")> _
        Public Property VerticalSpacing() As Integer
            Get
                Return m_VerticalSpacing
            End Get
            Set(ByVal Value As Integer)
                m_VerticalSpacing = Value
                RecalcSizing()
            End Set
        End Property
#End Region

#Region "Key Presses and Mouse Clicks"
        Protected Overrides Function IsInputKey( _
                ByVal keyData As System.Windows.Forms.Keys) As Boolean
            Select Case keyData
                Case Keys.Down, Keys.Left, Keys.Up, Keys.Right, Keys.Enter, Keys.Return
                    Return True
                Case Else
                    Return MyBase.IsInputKey(keyData)
            End Select
        End Function

        Protected Overrides Sub OnKeyDown( _
            ByVal e As System.Windows.Forms.KeyEventArgs)
            KeyPressed(e.KeyCode)
        End Sub

        Private Sub KeyPressed(ByVal Key As System.Windows.Forms.Keys)
            Try
                Dim currentSelectedItem As Integer = Me.focusedItem
                Dim newPosition As Integer = currentSelectedItem
                Dim selectedRow As Integer
                Dim selectedColumn As Integer

                If Not Me.DataManager.List Is Nothing _
                    AndAlso Not Me.Parent Is Nothing Then

                    Select Case Key
                        Case Keys.Up
                            If currentSelectedItem = 0 Then
                                'go to the previous control
                                Me.Parent.SelectNextControl(Me, _
                                    False, True, True, True)
                            Else
                                'go up by one
                                newPosition -= 1
                            End If

                        Case Keys.Down
                            Dim selected As Boolean
                            If currentSelectedItem >= _
                                Me.DataManager.Count - 1 Then
                                'go to the next control
                                selected = Me.Parent.SelectNextControl(Me, _
                                    True, True, True, True)
                            Else
                                'go down by one
                                newPosition += 1
                            End If
                        Case Keys.Left
                            'go to the previous control
                            Me.Parent.SelectNextControl(Me, False, True, True, True)

                        Case Keys.Right
                            'go to the next control
                            Me.Parent.SelectNextControl(Me, True, True, True, True)

                        Case Keys.Enter, Keys.Return, Keys.Space
                            Me.SelectedIndex = newPosition

                    End Select

                    If newPosition < 0 Then
                        newPosition = 0
                    ElseIf newPosition >= Me.DataManager.Count Then
                        newPosition = Me.DataManager.Count - 1
                    End If

                    If Me.focusedItem <> newPosition Then
                        Me.focusedItem = newPosition
                    End If
                End If
            Catch except As Exception
                Debug.WriteLine(except)
            End Try
        End Sub

        Protected Overrides Sub OnClick(ByVal e As System.EventArgs)
            Dim mouseLoc As Point = Me.PointToClient(Me.MousePosition())
            mouseLoc.Y += Me.m_currentTopPosition
            Dim itemHit As Integer = HitTest(mouseLoc)
            If itemHit <> -1 Then
                Me.SelectedIndex = itemHit
                Me.Focus()
            End If
        End Sub

        Private Function HitTest(ByVal loc As Point) As Integer
            Dim i As Integer
            Dim found As Boolean = False
            i = 0
            Do While i < Me.DataManager.Count And Not found
                If GetItemRect(i).Contains(loc) Then
                    found = True
                Else
                    i += 1
                End If
            Loop
            If found Then
                Return i
            Else
                Return -1
            End If
        End Function
#End Region


        Protected Overrides Sub OnSelectedIndexChanged(ByVal e As System.EventArgs)
            MyBase.OnSelectedIndexChanged(e)
            Me.focusedItem = Me.SelectedIndex
        End Sub

        Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
            RecalcSizing()
        End Sub
    End Class

End Namespace
