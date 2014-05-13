'Imports System.Drawing
'Imports Siberix

'Namespace Web
'    Public Class ReportTable

'#Region " Private Members "
'        Private mGroups As ReportColumnGroupCollection
'        Private mColumns As ReportColumnCollection
'        Private mSubColumns As ReportColumnCollection
'        Private WithEvents mRows As ReportRowCollection
'        Private mAllColumns As ReportColumnCollection

'        Private mTitle As String
'        Private mSubTitle As String
'        Private mHeaderImage As Image
'        Private mHeaderImageWidth As Integer
'        Private mHeaderImageHeight As Integer
'        Private mRowTitle As String
'        Private mRowLabelColumnWidth As Single

'        'Margin in Inches
'        Private mMarginLeft As Single
'        Private mMarginRight As Single
'        Private mMarginTop As Single
'        Private mMarginBottom As Single

'        Private mFont As Font
'        Private mTitleFont As Font
'        Private mBorderColor As Color
'        Private mBorderWidth As Integer
'        Private mCellPadding As Integer
'        Private mCellSpacing As Integer

'        Private mRenderGroupHeaders As Boolean
'        Private mShowHeader As Boolean
'        Private mShowTitle As Boolean
'#End Region

'#Region " Public Properties "
'        Public ReadOnly Property ColumnGroups() As ReportColumnGroupCollection
'            Get
'                Return mGroups
'            End Get
'        End Property
'        Public ReadOnly Property ColumnCount() As Integer
'            Get
'                Dim count As Integer = 0
'                Dim grp As ReportColumnGroup
'                For Each grp In mGroups
'                    count += grp.Columns.Count
'                Next

'                Return count
'            End Get
'        End Property
'        Public ReadOnly Property Column(ByVal index As Integer) As ReportColumn
'            Get
'                Dim i As Integer
'                Dim colCount As Integer = -1
'                Dim group As ReportColumnGroup
'                Dim col As ReportColumn

'                For Each group In mGroups
'                    For Each col In group.Columns
'                        colCount += 1
'                        If colCount = index Then
'                            Return col
'                        End If
'                    Next
'                Next

'                Throw New ArgumentOutOfRangeException("index", "Column " & index & " does not exist.")
'            End Get
'        End Property
'        Public ReadOnly Property Rows() As ReportRowCollection
'            Get
'                Return mRows
'            End Get
'        End Property

'        Public Property Title() As String
'            Get
'                Return mTitle
'            End Get
'            Set(ByVal Value As String)
'                mTitle = Value
'            End Set
'        End Property

'        Public Property SubTitle() As String
'            Get
'                Return mSubTitle
'            End Get
'            Set(ByVal Value As String)
'                mSubTitle = Value
'            End Set
'        End Property

'        Public Property HeaderImage() As Image
'            Get
'                Return mHeaderImage
'            End Get
'            Set(ByVal Value As Image)
'                mHeaderImage = Value
'                mHeaderImageWidth = Value.Width
'                mHeaderImageHeight = Value.Height
'            End Set
'        End Property

'        Public Property RowTitle() As String
'            Get
'                Return mRowTitle
'            End Get
'            Set(ByVal Value As String)
'                mRowTitle = Value
'            End Set
'        End Property

'        Public Property MarginLeft() As Single
'            Get
'                Return mMarginLeft
'            End Get
'            Set(ByVal Value As Single)
'                mMarginLeft = Value
'            End Set
'        End Property
'        Public Property MarginRight() As Single
'            Get
'                Return mMarginRight
'            End Get
'            Set(ByVal Value As Single)
'                mMarginRight = Value
'            End Set
'        End Property
'        Public Property MarginTop() As Single
'            Get
'                Return mMarginTop
'            End Get
'            Set(ByVal Value As Single)
'                mMarginTop = Value
'            End Set
'        End Property
'        Public Property MarginBottom() As Single
'            Get
'                Return mMarginBottom
'            End Get
'            Set(ByVal Value As Single)
'                mMarginBottom = Value
'            End Set
'        End Property

'        Public Property Font() As Font
'            Get
'                Return mFont
'            End Get
'            Set(ByVal Value As Font)
'                mFont = Value
'            End Set
'        End Property
'        Public Property CellPadding() As Integer
'            Get
'                Return mCellPadding
'            End Get
'            Set(ByVal Value As Integer)
'                mCellPadding = Value
'            End Set
'        End Property
'        Public Property CellSpacing() As Integer
'            Get
'                Return mCellSpacing
'            End Get
'            Set(ByVal Value As Integer)
'                mCellSpacing = Value
'            End Set
'        End Property

'        Public Property RenderGroupHeaders() As Boolean
'            Get
'                Return mRenderGroupHeaders
'            End Get
'            Set(ByVal Value As Boolean)
'                mRenderGroupHeaders = Value
'            End Set
'        End Property

'        Public Property ShowHeader() As Boolean
'            Get
'                Return mShowHeader
'            End Get
'            Set(ByVal Value As Boolean)
'                mShowHeader = Value
'            End Set
'        End Property

'        Public Property ShowTitle() As Boolean
'            Get
'                Return mShowTitle
'            End Get
'            Set(ByVal Value As Boolean)
'                mShowTitle = Value
'            End Set
'        End Property

'#End Region

'#Region " Private Properties "
'        Friend ReadOnly Property RowHeight() As Integer
'            Get
'                Return mFont.Height + (2 * mCellPadding)
'            End Get
'        End Property

'        Private ReadOnly Property TotalColumnCount() As Integer
'            Get
'                'Get the TOTAL column count, if there are sub columns then multiply column count by sub count

'                If mSubColumns.Count > 0 Then
'                    Return (mColumns.Count * mSubColumns.Count)
'                Else
'                    Return mColumns.Count
'                End If
'            End Get
'        End Property

'        Private ReadOnly Property HasSubColumns() As Boolean
'            Get
'                Return mSubColumns.Count > 0
'            End Get
'        End Property
'#End Region

'        Sub New()
'            mColumns = New ReportColumnCollection(Me)
'            mGroups = New ReportColumnGroupCollection(Me)
'            mRows = New ReportRowCollection(Me)
'            mRowTitle = ""

'            'Set default margins to 1 inch
'            mMarginLeft = 0.5
'            mMarginRight = 0.5
'            mMarginTop = 0.5
'            mMarginBottom = 0.5

'            mTitle = ""
'            mSubTitle = ""
'            mFont = New Font("Verdana", 8, FontStyle.Regular)
'            mTitleFont = New Font("Verdana", 12, FontStyle.Bold)
'            mBorderColor = Color.Black
'            mBorderWidth = 1
'            mCellPadding = 3
'            mCellSpacing = 0
'            mRenderGroupHeaders = True

'            mShowHeader = True
'            mShowTitle = True
'        End Sub

'        Private Class PDFReportPage
'            Private mPageSize As PDFPageSize
'            Private mRowStart As Integer
'            Private mRowEnd As Integer
'            Private mGroupStart As Integer
'            Private mGroupEnd As Integer
'            Private mX As Single
'            Private mY As Single
'            Private mRenderHeader As Boolean
'            Private mRenderTitle As Boolean

'#Region " Public Properties "
'            Public Property PageSize() As PDFPageSize
'                Get
'                    Return mPageSize
'                End Get
'                Set(ByVal Value As PDFPageSize)
'                    mPageSize = Value
'                End Set
'            End Property
'            Public Property RowStart() As Integer
'                Get
'                    Return mRowStart
'                End Get
'                Set(ByVal value As Integer)
'                    mRowStart = value
'                End Set
'            End Property
'            Public Property RowEnd() As Integer
'                Get
'                    Return mRowEnd
'                End Get
'                Set(ByVal value As Integer)
'                    mRowEnd = value
'                End Set
'            End Property
'            Public Property GroupStart() As Integer
'                Get
'                    Return mGroupStart
'                End Get
'                Set(ByVal value As Integer)
'                    mGroupStart = value
'                End Set
'            End Property
'            Public Property GroupEnd() As Integer
'                Get
'                    Return mGroupEnd
'                End Get
'                Set(ByVal value As Integer)
'                    mGroupEnd = value
'                End Set
'            End Property
'            Public Property XStart() As Single
'                Get
'                    Return mX
'                End Get
'                Set(ByVal value As Single)
'                    mX = value
'                End Set
'            End Property
'            Public Property YStart() As Single
'                Get
'                    Return mY
'                End Get
'                Set(ByVal value As Single)
'                    mY = value
'                End Set
'            End Property
'            Public Property RenderHeader() As Boolean
'                Get
'                    Return mRenderHeader
'                End Get
'                Set(ByVal value As Boolean)
'                    mRenderHeader = value
'                End Set
'            End Property
'            Public Property RenderTitle() As Boolean
'                Get
'                    Return mRenderTitle
'                End Get
'                Set(ByVal Value As Boolean)
'                    mRenderTitle = Value
'                End Set
'            End Property
'#End Region

'            Sub New(ByVal pageSize As PDFPageSize)
'                mPageSize = pageSize
'                mRenderHeader = False
'                mRenderTitle = False
'            End Sub

'        End Class

'        Private Function GetPages(ByVal pageSize As PDFPageSize) As ArrayList
'            Dim pageWidth As Single = calcPageWidth(pageSize)
'            Dim pageHeight As Single = calcPageHeight(pageSize)
'            Dim pages As New ArrayList
'            Dim page As PDFReportPage
'            Dim pageNum As Integer = 1
'            Dim x, y As Single

'            Dim vPageTotal As Integer
'            Dim usableWidth As Single
'            Dim usableHeight As Single
'            Dim usedWidth As Single

'            Dim done As Boolean

'            Dim rowsPerPage, rowStart, rowEnd, rowsLeft As Integer
'            Dim groupStart, groupEnd, groupsLeft As Integer
'            Dim groupIndex As Integer
'            Dim firstPage As Boolean

'            'Set the widths for the columns
'            SetAllWidths()

'            groupIndex = 0
'            While groupIndex < mGroups.Count
'                usableWidth = pageWidth - (mMarginLeft * 72) - (mMarginRight * 72)

'                done = False
'                groupStart = groupIndex
'                groupEnd = groupIndex
'                usableWidth -= mRowLabelColumnWidth
'                'Automatically place 1 group onto a page
'                usableWidth -= mGroups(groupIndex).GroupWidth
'                groupIndex += 1
'                While Not done
'                    If groupIndex < mGroups.Count AndAlso mGroups(groupIndex).GroupWidth < usableWidth Then
'                        groupEnd = groupIndex
'                        usableWidth -= mGroups(groupIndex).GroupWidth
'                        groupIndex += 1
'                    Else
'                        done = True
'                    End If
'                End While

'                firstPage = True
'                rowsLeft = mRows.Count
'                rowStart = 0
'                While rowsLeft > 0
'                    usableHeight = pageHeight - (mMarginTop * 72) - (mMarginBottom * 72)
'                    If firstPage AndAlso mShowHeader Then
'                        usableHeight -= mHeaderImage.Height
'                    End If
'                    If firstPage AndAlso mShowTitle Then
'                        usableHeight -= mTitleFont.Height()

'                        If mSubTitle.Length > 0 Then
'                            usableHeight -= mFont.Height
'                        End If
'                    End If

'                    rowsPerPage = CType(Math.Floor((usableHeight - (2 * RowHeight)) / RowHeight), Integer)
'                    'vPageTotal = CType(Math.Ceiling(mRows.Count / rowsPerPage), Integer)

'                    rowEnd = rowStart + rowsPerPage - 1
'                    If rowEnd > mRows.Count - 1 Then
'                        rowEnd = mRows.Count - 1
'                    End If

'                    page = New PDFReportPage(pageSize)
'                    page.RenderHeader = (firstPage AndAlso mShowHeader)
'                    page.RenderTitle = (firstPage AndAlso mShowTitle)
'                    page.GroupStart = groupStart
'                    page.GroupEnd = groupEnd
'                    page.RowStart = rowStart
'                    page.RowEnd = rowEnd
'                    page.XStart = mMarginLeft * 72
'                    page.YStart = mMarginTop * 72

'                    pages.Add(page)

'                    rowStart = rowEnd + 1
'                    rowsLeft = mRows.Count - rowEnd - 1
'                    pageNum += 1
'                    firstPage = False
'                End While

'            End While


'            'rowStart = 0
'            'rowEnd = rowsPerPage - 1
'            'rowsLeft = mRows.Count

'            Return pages
'        End Function

'        Private Sub SetAllWidths()
'            Dim sampleDoc As PDF.Document
'            Dim samplePage As PDF.Page
'            Dim grp As ReportColumnGroup

'            'Create a sample document with the correct font settings so that
'            'we can measure all of the columns etc.
'            sampleDoc = New PDF.Document
'            samplePage = New PDF.Page(612, 792)
'            sampleDoc.Pages.Content.Add(samplePage)
'            samplePage.Graphics.Font = mFont
'            'Set column widths
'            For Each grp In mGroups
'                grp.SetGroupWidth(samplePage.Graphics)
'            Next
'            'Set the row label column width
'            mRowLabelColumnWidth = GetRowLabelWidth(samplePage.Graphics) + (2 * mCellPadding)
'        End Sub

'        Public Sub RenderToPDF(ByVal pageSize As PDFPageSize, ByVal filePath As String)
'            Dim stream As New System.IO.FileStream(filePath, IO.FileMode.Create)
'            RenderToPDF(pageSize, stream)
'            stream.Close()
'        End Sub

'        Public Sub RenderToPDF(ByVal pageSize As PDFPageSize, ByVal stream As System.IO.Stream)
'            Dim doc As New PDF.Document
'            doc.ViewerPreferences.FitWindow = True

'            Dim page As PDFReportPage
'            Dim pages As ArrayList
'            pages = Me.GetPages(pageSize)

'            CreatePDFMetaData(doc)

'            For Each page In pages
'                RenderPage(doc, page)
'            Next

'            doc.Generate(stream)
'        End Sub

'        Public Enum PDFPageSize
'            Letter = 0
'            Legal = 1
'        End Enum

'        Private Function calcPageWidth(ByVal pageSize As PDFPageSize) As Single
'            Select Case pageSize
'                Case PDFPageSize.Letter
'                    Return 612
'                Case PDFPageSize.Letter
'                    Return 612
'            End Select
'        End Function
'        Private Function calcPageHeight(ByVal pageSize As PDFPageSize) As Single
'            Select Case pageSize
'                Case PDFPageSize.Letter
'                    Return 792
'                Case PDFPageSize.Legal
'                    Return 1008
'            End Select
'        End Function

'        Private Sub RenderPage(ByVal doc As PDF.Document, ByVal props As PDFReportPage)
'            Dim pageWidth As Single = calcPageWidth(props.PageSize)
'            Dim pageHeight As Single = calcPageHeight(props.PageSize)
'            Dim page As New PDF.Page(pageWidth, pageHeight)
'            Dim g As PDF.Graphics = page.Graphics
'            Dim i As Integer
'            Dim imgWidth, imgHeight As Integer

'            'Add the page to the document
'            doc.Pages.Content.Add(page)

'            'Setup the graphics object
'            g.Font = mFont
'            g.Brush = Brushes.Black
'            g.Pen = Pens.Black

'            If props.RenderHeader Then
'                imgWidth = mHeaderImageWidth
'                imgHeight = mHeaderImageHeight
'                g.DrawImage(mHeaderImage, props.XStart, props.YStart, imgWidth, imgHeight)
'                props.YStart += imgHeight
'            End If
'            If props.RenderTitle Then
'                g.SaveState()
'                g.Font = mTitleFont
'                g.DrawString(props.XStart, props.YStart, mTitle)
'                props.YStart += mTitleFont.Height
'                If mSubTitle.Length > 0 Then
'                    g.Font = mFont
'                    g.DrawString(props.XStart, props.YStart, mSubTitle)
'                    props.YStart += mFont.Height
'                End If
'                g.RestoreState()
'            End If

'            'Render the row labels
'            RenderRowLabels(g, props.XStart, props.YStart, props.RowStart, props.RowEnd)
'            props.XStart += mRowLabelColumnWidth

'            'Now render all the groups we need
'            For i = props.GroupStart To props.GroupEnd
'                mGroups(i).RenderPDF(g, props.XStart, props.YStart, props.RowStart, props.RowEnd)
'                props.XStart += mGroups(i).GroupWidth
'            Next

'            g.Flush()
'        End Sub

'        Private Sub RenderRowLabels(ByVal g As PDF.Graphics, ByVal x As Single, ByVal y As Single, ByVal startRow As Integer, ByVal endRow As Integer)
'            Dim rowCount As Integer = (endRow - startRow) + 1
'            Dim colHeight As Single
'            Dim penX, penY As Single
'            Dim i As Integer
'            Dim backColor As Color

'            'Get height
'            colHeight = (rowCount * RowHeight) + RowHeight
'            If mRenderGroupHeaders Then
'                colHeight += RowHeight
'            End If

'            'Draw Border
'            g.DrawRectangle(x, y, mRowLabelColumnWidth, colHeight)

'            'Draw Labels
'            penX = x
'            penY = y
'            If mRenderGroupHeaders Then
'                penY += RowHeight
'            End If
'            g.DrawString(penX + mCellPadding, penY + mCellPadding, mRowTitle)
'            penY += RowHeight
'            For i = startRow To endRow
'                backColor = mRows(i).BackColor
'                g.Brush = New System.Drawing.SolidBrush(backColor)
'                g.FillRectangle(penX, penY, mRowLabelColumnWidth, RowHeight)
'                g.Brush = Brushes.Black

'                g.DrawLine(penX, penY, penX + mRowLabelColumnWidth, penY)
'                g.DrawString(penX + mCellPadding, penY + mCellPadding, Rows(i).RowLabel)
'                penY += RowHeight
'            Next

'        End Sub
'        Private Function GetRowLabelWidth(ByVal g As PDF.Graphics) As Single
'            Dim max As Single = g.StringWidth(mRowTitle)
'            Dim row As ReportRow
'            Dim width As Single

'            For Each row In mRows
'                width = g.StringWidth(row.RowLabel)
'                If width > max Then max = width
'            Next

'            If max < 0 Then max = 0

'            Return max
'        End Function

'        Private Sub CreatePDFMetaData(ByVal doc As PDF.Document)
'            doc.Info.Title = "Report Table PDF"
'            doc.Info.Subject = "Report Data"
'            doc.Info.Author = "National Research Corporation"
'            doc.Info.Creator = "NRC Reporting Application"
'            doc.Info.Keywords = "Reporting, Data, Results"
'        End Sub

'        Private Sub AddRowToColumns()
'            Dim grp As ReportColumnGroup
'            Dim col As ReportColumn

'            For Each grp In mGroups
'                For Each col In grp.Columns

'                Next
'            Next
'        End Sub

'    End Class

'End Namespace