Imports System.Web.UI.WebControls
Imports System.Web
Imports System.Drawing
Namespace Web
    Public Class SessionStateViewer
        Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

        'Stores the HTTP Context object
        Private mContext As System.Web.HttpContext

        'Some colors used in HTML
        Private mTableBorderColor As Color = ColorTranslator.FromHtml("#C6C3C6")
        Private mAlternateRowColor As Color = ColorTranslator.FromHtml("#EFEBEF")
        Private mHeaderBackColor As Color = ColorTranslator.FromHtml("#086DCE")

        Private Function GetTitleHTML() As String
            Dim title As String
            title = "<FONT face=""Verdana, Arial"" size=""4"" color=""#086DCE""><STRONG>Session State Viewer for {0} on {1}</STRONG></FONT><HR><BR>"
            Dim appName As String = HttpRuntime.AppDomainAppVirtualPath
            appName = appName.Substring(appName.LastIndexOf("/") + 1)

            Return String.Format(title, appName, mContext.Server.MachineName)
        End Function

        Private Function CreateTable() As Table
            Dim tbl As New Table
            'tbl.BorderStyle = BorderStyle.Solid
            'tbl.BorderWidth = Unit.Pixel(1)
            'tbl.BorderColor = mTableBorderColor
            tbl.BackColor = mTableBorderColor
            tbl.CellSpacing = 1
            tbl.CellPadding = 3
            tbl.Width = Unit.Percentage(100)
            tbl.Font.Names = New String() {"Verdana", "Arial"}
            tbl.Font.Size = FontUnit.XSmall
            Return tbl
        End Function

        Private Function CreateHeaderRow() As TableRow
            Dim row As New TableRow

            row.Cells.Add(CreateHeaderCell("Key"))
            row.Cells.Add(CreateHeaderCell("Type"))
            row.Cells.Add(CreateHeaderCell("Value"))
            row.Cells.Add(CreateHeaderCell("Data"))

            Return row
        End Function

        Private Function CreateHeaderCell(ByVal text As String) As TableCell
            Dim cell As New TableCell
            cell.BackColor = mHeaderBackColor
            cell.ForeColor = Color.White
            cell.Text = text
            cell.Font.Bold = True
            cell.HorizontalAlign = HorizontalAlign.Center
            cell.Wrap = False

            Return cell
        End Function

        Private Function CreateDataRow(ByVal key As String, ByVal value As Object, ByVal isAlternateRow As Boolean) As TableRow
            Dim row As New TableRow
            Dim backColor As Color
            Dim href As String
            If isAlternateRow Then
                backColor = mAlternateRowColor
            Else
                backColor = Color.White
            End If

            row.Cells.Add(CreateDataCell(key, backColor))
            row.Cells.Add(CreateDataCell(value.GetType.ToString, backColor))
            row.Cells.Add(CreateDataCell(value.ToString, backColor))
            If value.GetType.IsSerializable Then
                href = "<a target=""_blank"" href=""{0}?Key={1}"">View</a>"
                row.Cells.Add(CreateDataCell(String.Format(href, mContext.Request.Path, key), backColor, True))
            Else
                row.Cells.Add(CreateDataCell("Not Serializable", backColor, True))
            End If

            Return row
        End Function

        Private Function CreateDataCell(ByVal text As String, ByVal backColor As Color) As TableCell
            Return CreateDataCell(text, backColor, False)
        End Function
        Private Function CreateDataCell(ByVal text As String, ByVal backColor As Color, ByVal isLastCell As Boolean) As TableCell
            Dim cell As New TableCell
            cell.BackColor = backColor
            cell.ForeColor = Color.Black
            cell.Text = text

            If isLastCell Then
                cell.Width = Unit.Percentage(100)
            Else

            End If


            Return cell
        End Function

        Private Function GetHtml() As String
            Dim tbl As Table = CreateTable()
            tbl.Rows.Add(CreateHeaderRow)


            Dim sb As New System.Text.StringBuilder
            Dim stringWriter As New IO.StringWriter(sb)
            Dim htmlWriter As New System.Web.UI.HtmlTextWriter(stringWriter)
            Dim isAlt As Boolean = False

            Try
                htmlWriter.WriteLine(GetTitleHTML)
                If mContext Is Nothing Then
                    Throw New ArgumentNullException("Context is NULL")
                End If

                If mContext.Session Is Nothing Then
                    Throw New ArgumentNullException("Session is NULL")
                End If
                If mContext.Session.Mode = SessionState.SessionStateMode.Off Then
                    Throw New ArgumentException("Session Mode is OFF")
                End If

                For Each key As String In mContext.Session.Keys
                    tbl.Rows.Add(CreateDataRow(key, mContext.Session(key), isAlt))

                    isAlt = Not isAlt
                Next

                tbl.RenderControl(htmlWriter)
            Catch ex As Exception
                htmlWriter.WriteLine(ex.ToString)
            End Try

            Return sb.ToString()
        End Function

        Public ReadOnly Property IsReusable() As Boolean Implements System.Web.IHttpHandler.IsReusable
            Get
                Return False
            End Get
        End Property

        Public Sub ProcessRequest(ByVal context As System.Web.HttpContext) Implements System.Web.IHttpHandler.ProcessRequest
            mContext = context
            If IsLocalRequest(context.Request) Then
                If mContext.Request.QueryString("Key") Is Nothing Then
                    Dim html As String = GetHtml()
                    mContext.Response.Write(html)
                Else
                    ShowXMLData(mContext.Request.QueryString("Key"))
                End If
            Else
                Throw New HttpException(404, "Path not found.", 404)
            End If
        End Sub

        Private Sub ShowXMLData(ByVal key As String)
            Dim obj As Object = mContext.Session(key)
            mContext.Response.Write(Serialize(obj))
        End Sub

        Private Shared Function Serialize(ByVal obj As Object) As String
            Dim sb As System.Text.StringBuilder
            Dim tWriter As System.IO.StringWriter
            Dim xWriter As System.Xml.XmlTextWriter
            Dim serializer As System.Xml.Serialization.XmlSerializer

            Try
                If Not obj.GetType.IsSerializable Then
                    Return "Not Serializable"
                End If
                sb = New System.Text.StringBuilder
                tWriter = New IO.StringWriter(sb)
                xWriter = New System.Xml.XmlTextWriter(tWriter)
                serializer = New System.Xml.Serialization.XmlSerializer(obj.GetType)
                serializer.Serialize(xWriter, obj)

                Return sb.ToString
            Catch ex As Exception
                Return "Could not serialize: " & ex.ToString
            Finally
                If Not xWriter Is Nothing Then
                    xWriter.Close()
                End If
                If Not tWriter Is Nothing Then
                    tWriter.Close()
                End If
            End Try
        End Function

        Public Function IsLocalRequest(ByVal request As HttpRequest) As Boolean
            If request.UserHostAddress = "127.0.0.1" OrElse request.UserHostAddress = request.ServerVariables("LOCAL_ADDR") Then
                Return True
            Else
                Return False
            End If

        End Function

    End Class
End Namespace
