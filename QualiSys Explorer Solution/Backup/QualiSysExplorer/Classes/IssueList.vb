'' This is the IssueVission specific control that derives from the generic 
'' Outlook-like ExandableList control. Responsible for rendering the 
'' content of each row.

'Public Class IssueList
'    Inherits ExpandableList

'    ' maps to the icons in the imagelist
'    Private Enum RowStateIcon
'        Conflict
'        Modified
'    End Enum

'    ' cell space in each row
'    Private Const Buffer As Integer = 4

'    ' where to draw the second column of information (from right side)
'    Private Const RightBuffer As Integer = 90

'    ' don't draw the second column if the control is only this wide
'    Private Const DrawRightSideWidth As Integer = 200

'    ' room for icon on the left side
'    Private Const LeftPos As Integer = 22

'    ' gdi objects
'    Private m_formatRight As StringFormat
'    Private m_formatEllipsis As StringFormat

'    ' ctor
'    Public Sub New()
'        MyBase.New()

'        ' right aligned text, setting the DirectionRightToLeft
'        ' works better then setting Alignment to StringAlignment.Far,
'        ' the later approach does not always align the strings correctly
'        m_formatRight = New StringFormat(StringFormatFlags.DirectionRightToLeft)

'        ' strings with ellispsis
'        m_formatEllipsis = New StringFormat
'        m_formatEllipsis.FormatFlags = StringFormatFlags.NoWrap
'        m_formatEllipsis.Trimming = StringTrimming.EllipsisCharacter

'        InitializeComponent()
'    End Sub

'    ' a row needs to be painted
'    Protected Overrides Sub OnDrawItem(ByVal e As DrawItemEventArgs, ByVal dr As DataRowView)
'        MyBase.OnDrawItem(e, dr)

'        ' colors that depend if the row is currently selected or not, 
'        ' assign to a system brush so should not be disposed

'        ' not selected colors
'        Dim brushBack As Brush = SystemBrushes.Window
'        Dim brushText As Brush = SystemBrushes.WindowText
'        Dim brushDim As Brush = Brushes.Gray

'        If CBool(e.State And DrawItemState.Selected) Then
'            If CBool(e.State And DrawItemState.Focus) Then
'                ' selected and has focus
'                brushBack = SystemBrushes.Highlight
'                brushText = SystemBrushes.HighlightText
'                brushDim = SystemBrushes.HighlightText
'            Else
'                ' selected and does not have focus
'                brushBack = SystemBrushes.Control
'                brushDim = SystemBrushes.WindowText
'            End If
'        End If

'        ' background
'        e.Graphics.FillRectangle(brushBack, e.Bounds)

'        ' decrease the bounds to get a visual buffer around each row
'        Dim rc As New RectangleF(e.Bounds.X, e.Bounds.Y, e.Bounds.Width, e.Bounds.Height)
'        rc.Inflate(-Me.Buffer, -Me.Buffer)

'        ' values
'        DrawValues(e.Graphics, rc, brushText, brushDim, dr)

'        ' icon
'        DrawIcon(e.Graphics, CInt(rc.Left), CInt(rc.Top), dr)
'    End Sub

'    ' draw content of a row
'    Private Sub DrawValues(ByVal g As Graphics, ByVal rc As RectangleF, _
'     ByVal brushText As Brush, ByVal brushDim As Brush, ByVal dr As DataRowView)
'        ' calculate the bounds of the title, necessary to 
'        ' draw ellipsis if string is too long
'        Dim bounds As New RectangleF(rc.Left + Me.LeftPos, rc.Top, _
'         rc.Width - Me.LeftPos, Me.Font.Height)

'        ' see if should leave room for the second column (date and username)
'        If rc.Width > Me.DrawRightSideWidth Then bounds.Width -= Me.RightBuffer

'        ' title
'        g.DrawString(CStr(dr("Title")), Me.Font, _
'         brushText, bounds, m_formatEllipsis)

'        ' comments
'        bounds.Y += Me.Font.Height + 2
'        g.DrawString(CStr(dr("Description")), Me.Font, _
'         brushDim, bounds, m_formatEllipsis)

'        ' second column, date and open status
'        If rc.Width > Me.DrawRightSideWidth Then
'            ' date
'            g.DrawString(CType(dr("DateOpened"), DateTime).ToShortDateString(), _
'             Me.Font, brushDim, rc.Right, rc.Top, m_formatRight)

'            ' open / closed
'            If CBool(dr("IsOpen")) Then
'                g.DrawString("Open", Me.Font, brushText, _
'                 rc.Right, rc.Top + Me.Font.Height + 2, m_formatRight)
'            Else
'                g.DrawString("Closed", Me.Font, brushDim, _
'                 rc.Right, rc.Top + Me.Font.Height + 2, m_formatRight)
'            End If
'        End If
'    End Sub

'    ' rows can have conflict, modified or no icon
'    Private Sub DrawIcon(ByVal g As Graphics, ByVal x As Integer, ByVal y As Integer, ByVal dr As DataRowView)
'        '' conflict
'        'If Not m_Subject.ConflictItems Is Nothing AndAlso m_Subject.ConflictItems.ContainsKey(dr("IssueID")) Then
'        '    imageList.Draw(g, x, y, RowStateIcon.Conflict)
'        '    Return
'        'End If

'        '' modified
'        'If dr.Row.RowState = DataRowState.Modified OrElse _
'        ' dr.Row.RowState = DataRowState.Added Then
'        '    imageList.Draw(g, x, y, RowStateIcon.Modified)
'        '    Return
'        'End If
'    End Sub

'#Region " Windows Form Designer generated code "

'    Private imageList As System.Windows.Forms.ImageList
'    Private components As System.ComponentModel.IContainer

'    Private Sub InitializeComponent()
'        Me.components = New System.ComponentModel.Container
'        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(IssueList))
'        Me.imageList = New System.Windows.Forms.ImageList(Me.components)
'        '
'        'imageList
'        '
'        Me.imageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth32Bit
'        Me.imageList.ImageSize = New System.Drawing.Size(16, 16)
'        Me.imageList.ImageStream = CType(resources.GetObject("imageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
'        Me.imageList.TransparentColor = System.Drawing.Color.Lime
'        '
'        'IssueList
'        '
'        Me.Name = "IssueList"

'    End Sub

'    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
'        If disposing Then
'            If Not (components Is Nothing) Then
'                components.Dispose()
'            End If
'        End If
'        MyBase.Dispose(disposing)
'    End Sub

'#End Region

'End Class
