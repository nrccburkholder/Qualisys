Imports System.Windows.Forms
Imports system.Drawing
Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class frmFileHistory
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal dataFileID As Integer)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.mDataFileID = dataFileID
    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents HistoryGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents HistoryGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents ExportExcel As System.Windows.Forms.ToolStripButton
    Friend WithEvents ExportPDF As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolTipControl As System.Windows.Forms.ToolTip
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmFileHistory))
        Me.btnClose = New System.Windows.Forms.Button
        Me.ToolTipControl = New System.Windows.Forms.ToolTip(Me.components)
        Me.HistoryGridControl = New DevExpress.XtraGrid.GridControl
        Me.HistoryGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        Me.ExportExcel = New System.Windows.Forms.ToolStripButton
        Me.ExportPDF = New System.Windows.Forms.ToolStripButton
        CType(Me.HistoryGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.HistoryGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Data File History"
        Me.mPaneCaption.Size = New System.Drawing.Size(558, 26)
        Me.mPaneCaption.Text = "Data File History"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnClose.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClose.Location = New System.Drawing.Point(240, 381)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(80, 24)
        Me.btnClose.TabIndex = 1
        Me.btnClose.Text = "Close"
        '
        'ToolTipControl
        '
        Me.ToolTipControl.AutoPopDelay = 7000
        Me.ToolTipControl.InitialDelay = 500
        Me.ToolTipControl.ReshowDelay = 100
        '
        'HistoryGridControl
        '
        Me.HistoryGridControl.EmbeddedNavigator.Name = ""
        Me.HistoryGridControl.Location = New System.Drawing.Point(8, 54)
        Me.HistoryGridControl.MainView = Me.HistoryGridView
        Me.HistoryGridControl.Name = "HistoryGridControl"
        Me.HistoryGridControl.Size = New System.Drawing.Size(548, 321)
        Me.HistoryGridControl.TabIndex = 3
        Me.HistoryGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.HistoryGridView})
        '
        'HistoryGridView
        '
        Me.HistoryGridView.GridControl = Me.HistoryGridControl
        Me.HistoryGridView.Name = "HistoryGridView"
        Me.HistoryGridView.OptionsBehavior.Editable = False
        Me.HistoryGridView.OptionsView.ShowAutoFilterRow = True
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Dock = System.Windows.Forms.DockStyle.None
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportExcel, Me.ToolStripSeparator1, Me.ExportPDF})
        Me.ToolStrip1.Location = New System.Drawing.Point(1, 26)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(180, 25)
        Me.ToolStrip1.TabIndex = 4
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'ExportExcel
        '
        Me.ExportExcel.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ExportExcel.Image = CType(resources.GetObject("ExportExcel.Image"), System.Drawing.Image)
        Me.ExportExcel.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportExcel.Name = "ExportExcel"
        Me.ExportExcel.Size = New System.Drawing.Size(84, 22)
        Me.ExportExcel.Text = "Export to Excel"
        '
        'ExportPDF
        '
        Me.ExportPDF.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ExportPDF.Image = CType(resources.GetObject("ExportPDF.Image"), System.Drawing.Image)
        Me.ExportPDF.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportPDF.Name = "ExportPDF"
        Me.ExportPDF.Size = New System.Drawing.Size(78, 22)
        Me.ExportPDF.Text = "Export to PDF"
        '
        'frmFileHistory
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.AutoSize = True
        Me.Caption = "Data File History"
        Me.ClientSize = New System.Drawing.Size(560, 413)
        Me.Controls.Add(Me.HistoryGridControl)
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.btnClose)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmFileHistory"
        Me.Text = "frmFileHistory"
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.ToolStrip1, 0)
        Me.Controls.SetChildIndex(Me.HistoryGridControl, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.HistoryGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.HistoryGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

    Private mDataFileID As Integer
    Private lastIndex As Integer

    Private Sub frmFileHistory_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        LoadHistory()
    End Sub

    Private Sub LoadHistory()

        Dim tblhistory As DataTable = PackageDB.GetFileHistory(mDataFileID)
        Dim duration As Integer
        Dim hour As Integer
        Dim min As Integer
        Dim sec As Integer

        'Rename & Add DataTable Columns for Grid Display
        With tblhistory
            .Columns("StateDescription").ColumnName = "State"
            .Columns("StateParameter").ColumnName = "Info"
            .Columns("datOccurred").ColumnName = "Occurred"
            .Columns.Add("Duration")
        End With

        'Populate Duration Column
        For Each row As DataRow In tblhistory.Rows
            If Not IsDBNull(row("StateDuration")) Then
                duration = CType(row("StateDuration"), Integer)
                hour = CInt(duration / 3600)
                duration = duration Mod 3600
                min = CInt(duration / 60)
                duration = duration Mod 60
                sec = duration

                If hour > 0 Then
                    row("Duration") = String.Format("{0} hour(s) {1} min(s) {2} sec(s)", hour, min, sec)
                ElseIf min > 0 Then
                    row("Duration") = String.Format("{0} min(s) {1} sec(s)", min, sec)
                Else
                    row("Duration") = String.Format("{0} sec(s).", sec)
                End If
            Else
                row("Duration") = ""
            End If
        Next

        HistoryGridControl.DataSource = tblhistory

        'Hide Other Non-Displayed Columns
        With HistoryGridView
            .Columns("TimeID").Visible = False
            .Columns("State_id").Visible = False
            .Columns("Member_ID").Visible = False
            .Columns("StateDuration").Visible = False
            .Columns("State").Width = 75
            .Columns("Info").Width = 75
            .Columns("Occurred").Width = 50
            .Columns("Duration").Width = 100
        End With

    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub ExportExcel_Click1(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportExcel.Click

        With SaveFileDialog
            .Filter = "Excel files (*.xls)|*.xls|All files (*.*)|*.*"
            .FilterIndex = 1
            .FileName = ""

            If .ShowDialog() = Windows.Forms.DialogResult.OK Then
                HistoryGridControl.MainView.ExportToXls(.FileName)
            End If
        End With

    End Sub

    Private Sub ExportPDF_Click1(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportPDF.Click

        With SaveFileDialog
            .Filter = "PDF files (*.pdf)|*.pdf|All files (*.*)|*.*"
            .FilterIndex = 1
            .FileName = ""

            If .ShowDialog() = Windows.Forms.DialogResult.OK Then
                HistoryGridControl.MainView.ExportToPdf(.FileName)
            End If
        End With

    End Sub
End Class

'Public Class ListViewWithTooltip
'    Inherits ListView

'    '_________________________________________________________________________________________________
'    ' Written APR 18, 2002 by Urs Eichmann, PRISMA Informatik AG, Dietlikon(Switzerland)
'    ' E-Mail: Urs@prismanet.ch
'    ' This source may be freely used and changed by anyone interested.
'    '
'    ' implements a listview which shows items as tooltips if they don't fit in the column (only when in detailed view)
'    ' use this class anywhere you would use a regular ListView control.
'    '_________________________________________________________________________________________________

'#Region "Member variables"
'    Private mTooltip As fTooltip
'#End Region

'#Region "Constructors / Finalizers"
'    Public Sub New()
'        MyBase.New()

'        mTooltip = New fTooltip(Me)
'        ' default view is details
'        Me.View = View.Details
'    End Sub

'    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
'        GC.SuppressFinalize(Me)

'        If Not mTooltip Is Nothing Then mTooltip.Dispose() : mTooltip = Nothing

'        MyBase.Dispose(disposing)
'    End Sub

'    Protected Overrides Sub Finalize()
'        Me.Dispose(False)
'        MyBase.Finalize()
'    End Sub
'#End Region

'#Region "base class overrides"

'    Protected Overrides Sub OnMouseMove(ByVal e As System.Windows.Forms.MouseEventArgs)
'        If Me.View = View.Details Then
'            ' get item under mouse pointer
'            Dim itm As ListViewItem = CType(Me.GetItemAt(e.X, e.Y), ListViewItem)
'            ' if necessary and possible, show text as tooltip
'            mTooltip.ShowTooltipText(itm)
'        End If
'        MyBase.OnMouseMove(e)
'    End Sub

'#End Region

'#Region "Inner Classes"
'    Private NotInheritable Class fTooltip
'        Inherits Form
'        ' private class which implements a specific tooltip form for use in ListViewWithTooltip

'#Region "Member variables"

'        Private mParent As Control ' ref. to ListView control
'        Private mColumnWidth, mRowHeight As Integer ' size of the current cell
'        Private mCurrentListViewItem As ListViewItem ' ref. to current row
'        Private mClickedListViewItem As ListViewItem ' ref. to row last clicked on
'        Private mLastLeft, mLastRight As Integer ' edges of last evaluated cell
'        Private mText As String ' text to be displayed as tool tip
'        Private mStringFormat As StringFormat ' string format to be used for painting
'        Private mOwnerTopMost As Boolean ' TRUE if parent form has TopMost property set (special handling of showing/hiding tooltip necessary)
'#End Region

'#Region "Public Methods"
'        Public Sub ShowTooltipText(ByVal vLVI As ListViewItem)

'            ' get current mouse position
'            Dim mp As Point = Control.MousePosition

'            If vLVI Is mCurrentListViewItem AndAlso Not vLVI Is Nothing Then
'                ' find out if the mouse is still in the same subitem as last time, if that's the case we retain status quo
'                If Not IsHidden Then Exit Sub
'                If mp.X >= mLastLeft AndAlso mp.X <= mLastRight Then Exit Sub
'            End If

'            If Not vLVI Is Nothing Then
'                ' don't reshow tooltip if user has previously clicked on it
'                If vLVI Is mClickedListViewItem Then Exit Sub
'                mClickedListViewItem = Nothing
'            End If
'            mCurrentListViewItem = vLVI

'            Dim ch As ColumnHeader
'            Dim xOffs As Integer
'            Dim lviBounds As Rectangle
'            Dim chCnt As Integer
'            Dim siTopLeft, siTopRight As Point
'            Dim siTxt As String

'            If Not vLVI Is Nothing Then
'                lviBounds = vLVI.Bounds
'                ' find out over which subitem (column) is the mouse?
'                For Each ch In vLVI.ListView.Columns
'                    Dim siBounds As Rectangle = lviBounds
'                    ' have to evaluate screen coords for every column since it could has been rearranged by the user...
'                    siBounds.Offset(New Point(xOffs, 0))
'                    siTopLeft = vLVI.ListView.PointToScreen(New Point(siBounds.X, siBounds.Y))
'                    siTopRight = New Point(siTopLeft.X + ch.Width - 1, siTopLeft.Y)
'                    If mp.X >= siTopLeft.X AndAlso mp.X <= siTopRight.X Then
'                        ' yes, mouse pointer is within this column
'                        ' get text of this column
'                        siTxt = vLVI.SubItems(chCnt).Text
'                        ' store size of this cell
'                        mColumnWidth = ch.Width
'                        mRowHeight = vLVI.Bounds.Height
'                        Exit For
'                    End If
'                    ' test next column
'                    chCnt += 1
'                    xOffs += ch.Width
'                Next

'                mLastLeft = siTopLeft.X
'                mLastRight = siTopRight.X

'            End If

'            If siTxt <> "" Then
'                ' test if text fits in cell
'                Dim g As Graphics
'                Dim ts As SizeF
'                g = vLVI.ListView.CreateGraphics()
'                ts = g.MeasureString(siTxt, vLVI.Font, Screen.PrimaryScreen.WorkingArea.Width - siTopLeft.X, mStringFormat)
'                g.Dispose()
'                ' subtract cell boundaries (18 is just a guess... don't know how to get "real" grid boundaries!
'                If ts.Width > mColumnWidth - 18 Then
'                    ' text doesn't fit --> display a tooltip
'                    If ts.Height < mRowHeight + 2 Then ts.Height = mRowHeight + 2
'                    ' calculate outer bounds of the tooltip
'                    Dim bounds As Rectangle = New Rectangle(New Point(siTopLeft.X, siTopLeft.Y), New Size(CInt(ts.Width + 6), CInt(ts.Height)))
'                    If chCnt = 0 Then
'                        ' if it is the first column --> take Icon size and checkbox into account
'                        If vLVI.ListView.CheckBoxes Then
'                            bounds.Offset(16, 0)
'                        End If
'                        If Not vLVI.ImageList Is Nothing Then
'                            If vLVI.ImageIndex <> -1 Then

'                                bounds.Offset(vLVI.ImageList.Images(vLVI.ImageIndex).Width + 1, 0)
'                            End If
'                        End If
'                    End If
'                    ' set color and font of the tooltip so it matches the ListView() 's
'                    Me.Bounds = bounds
'                    Me.BackColor = vLVI.BackColor
'                    Me.ForeColor = vLVI.ForeColor
'                    Me.Font = vLVI.Font
'                    mText = siTxt
'                    ' show tooltip
'                    ShowForm()
'                    Me.Bounds = bounds
'                    Me.Update()
'                Else
'                    ' text fits --> don't display a tooltip
'                    siTxt = ""
'                End If

'            End If

'            If siTxt = "" Then
'                ' hide tooltip if there is no text to display
'                HideForm()
'                mLastLeft = -1
'                mLastRight = -1
'            End If

'        End Sub
'#End Region
'#Region "Constructors and destructors"

'        Public Sub New(ByVal vParent As ListViewWithTooltip)
'            MyBase.New()
'            mParent = vParent

'            ' create a form without border or anything
'            Me.FormBorderStyle = FormBorderStyle.None
'            Me.Font = vParent.Font
'            Me.StartPosition = FormStartPosition.Manual
'            Me.ShowInTaskbar = False

'            Dim sf As New StringFormat(StringFormat.GenericDefault)
'            sf.Alignment = Drawing.StringAlignment.Near
'            sf.LineAlignment = Drawing.StringAlignment.Near
'            sf.Trimming = Drawing.StringTrimming.Character
'            sf.FormatFlags = 0
'            mStringFormat = sf

'            HideForm()

'        End Sub

'        Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
'            GC.SuppressFinalize(Me)
'            mCurrentListViewItem = Nothing
'            mClickedListViewItem = Nothing
'            mParent = Nothing
'            If Not mStringFormat Is Nothing Then mStringFormat.Dispose()
'            mStringFormat = Nothing
'            Me.Owner = Nothing
'            MyBase.Dispose(disposing)
'        End Sub

'        Protected Overrides Sub Finalize()
'            Me.Dispose(False)
'            MyBase.Finalize()
'        End Sub
'#End Region

'#Region "Base class overrides"
'        Protected Overrides Sub OnMouseDown(ByVal e As System.Windows.Forms.MouseEventArgs)
'            ' Hide myself if clicked on it with mouse
'            mClickedListViewItem = mCurrentListViewItem
'            HideForm()
'        End Sub

'        Protected Overrides Sub OnMouseLeave(ByVal e As EventArgs)
'            ' hide myself if mouse is no longer over tooltip
'            ShowTooltipText(Nothing)
'        End Sub

'        Protected Overrides Sub OnMouseMove(ByVal e As System.Windows.Forms.MouseEventArgs)
'            If e.Button <> MouseButtons.None Then Exit Sub
'            If e.X > mColumnWidth OrElse e.Y > mRowHeight Then
'                ' mouse is more over original cell --> hide tooltip
'                ShowTooltipText(Nothing)
'            End If
'        End Sub

'        Protected Overrides Sub OnPaint(ByVal e As PaintEventArgs)
'            ' paints the tooltip
'            Dim g As Graphics = e.Graphics
'            Dim pe As New Pen(Me.ForeColor)
'            Dim br As New SolidBrush(Me.ForeColor)

'            ' Draw a border
'            g.DrawRectangle(pe, New Rectangle(Me.ClientRectangle.X, Me.ClientRectangle.Y, Me.ClientRectangle.Width - 1, Me.ClientRectangle.Height - 1))

'            ' Draw Text
'            g.DrawString(mText, Me.Font, br, New RectangleF(4, 1, Me.ClientSize.Width - 5, Me.ClientSize.Height - 3), mStringFormat)
'            pe.Dispose()
'            br.Dispose()

'        End Sub
'#End Region

'#Region "private methods"

'        Private Sub ShowForm()
'            If Me.Owner Is Nothing Then
'                ' get parent form and set it as owner
'                Me.Owner = mParent.FindForm
'                mOwnerTopMost = Me.Owner.TopMost
'            End If

'            ' must make win32 api calls since the .NET framework can't display a non-active window
'            If mOwnerTopMost Then
'                ' special treating if parent form is topmost (otherwise the tooltip would be behind the form)
'                ShowWindow(Me.Handle.ToInt32, SW_SHOWNA)
'                SetWindowPos(Me.Handle.ToInt32, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE)
'                SetWindowPos(Me.Owner.Handle.ToInt32, Me.Handle.ToInt32, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE)
'            Else
'                ShowWindow(Me.Handle.ToInt32, SW_SHOWNA)
'            End If

'        End Sub

'        Private Sub HideForm()
'            ' hide form: put it where it is invisible (don't set Me.Visible to false in order to suppress
'            ' reactivation of the owner window)
'            Me.Bounds = New Rectangle(-2, -2, 1, 1)
'            If mOwnerTopMost Then
'                ' restore former topmost window
'                SetWindowPos(Me.Owner.Handle.ToInt32, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOACTIVATE)
'            End If
'        End Sub

'        Private ReadOnly Property IsHidden() As Boolean
'            Get
'                ' returns TRUE if the tooltip was hidden using HideForm
'                If Me.Width = 1 AndAlso Me.Height = 1 Then Return True
'                Return False
'            End Get
'        End Property
'#End Region

'#Region "declarations of Win32 functions"
'        Private Declare Function ShowWindow Lib "user32" Alias "ShowWindow" (ByVal hwnd As Integer, ByVal nCmdShow As Integer) As Integer
'        Private Const SW_SHOWNA As Integer = 8
'        Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Integer, ByVal hWndInsertAfter As Integer, ByVal x As Integer, ByVal y As Integer, ByVal cx As Integer, ByVal cy As Integer, ByVal wFlags As Integer) As Integer
'        Private Const SWP_ASYNCWINDOWPOS As Integer = &H4000
'        Private Const SWP_DEFERERASE As Integer = &H2000
'        Private Const SWP_DRAWFRAME As Integer = SWP_FRAMECHANGED
'        Private Const SWP_FRAMECHANGED As Integer = &H20
'        Private Const SWP_HIDEWINDOW As Integer = &H80
'        Private Const SWP_NOACTIVATE As Integer = &H10
'        Private Const SWP_NOCOPYBITS As Integer = &H100
'        Private Const SWP_NOMOVE As Integer = &H2
'        Private Const SWP_NOOWNERZORDER As Integer = &H200
'        Private Const SWP_NOREDRAW As Integer = &H8
'        Private Const SWP_NOREPOSITION As Integer = SWP_NOOWNERZORDER
'        Private Const SWP_NOSENDCHANGING As Integer = &H400
'        Private Const SWP_NOSIZE As Integer = &H1
'        Private Const SWP_NOZORDER As Integer = &H4
'        Private Const SWP_SHOWWINDOW As Integer = &H40
'        Private Const HWND_BOTTOM As Integer = 1
'        Private Const HWND_BROADCAST As Integer = &HFFFF&
'        Private Const HWND_DESKTOP As Integer = 0
'        Private Const HWND_MESSAGE As Integer = -3
'        Private Const HWND_NOTOPMOST As Integer = -2
'        Private Const HWND_TOP As Integer = 0
'        Private Const HWND_TOPMOST As Integer = -1
'#End Region

'    End Class
'#End Region

'End Class
