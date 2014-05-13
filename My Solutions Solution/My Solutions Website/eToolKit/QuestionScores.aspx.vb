Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Drawing.Drawing2D

Partial Public Class eToolKit_QuestionScores
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return True
        End Get
    End Property

    Protected Sub LinkButtonClicked(ByVal sender As Object, ByVal e As CommandEventArgs)
        'Set the current question.
        Dim questionId As Integer = CType(e.CommandArgument, Integer)
        SaveQuestion(questionId)
    End Sub

    Protected Overrides Sub OnPreInit(ByVal e As System.EventArgs)
        MyBase.OnPreInit(e)
        If SessionInfo.SelectedDimensionId = 0 Then
            If MemberGroupPreference.IsChooseQuestionSelected Then
                Response.Redirect("QuestionSelection.aspx")
            Else
                Response.Redirect("ThemeSelection.aspx")
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.PageLogo1.Title = String.Format("Question Results: {0}", SessionInfo.SelectedDimensionName)

        If Not Page.IsPostBack Then
            'Load the question/data table...
            LoadQuestionTable()
            BuildLegend()
        End If
    End Sub


#Region " Load the current question "

    Private Sub SaveQuestion(ByVal questionId As Integer)
        SessionInfo.SelectedQuestionId = questionId

        'Redirect the user to the question content page...
        Response.Redirect("QuestionContent.aspx?aux=qi")
    End Sub

#End Region

#Region " Load the Question HTML Table "
    Private Sub LoadQuestionTable()
        'Get the data for the Question HTML Table...
        GetDataSet()
    End Sub

#End Region

#Region " Get Icon "
    Public Function GetIcon(ByVal Code As Integer) As String

        Dim ShowIconColumn As Boolean = True
        Dim strIcon As String = ""

        If ShowIconColumn Then
            Select Case Code
                Case 1
                    strIcon = "<img src=""../img/ModelSigBetter.gif"" width=""24"" height=""24"" hSpace=""5"" ALT=""" & "Your score is statistically better than your comparison group (at the " & MemberGroupPreference.QualityProgramName & ")" & """>"
                Case 2
                    strIcon = "<img src=""../img/ModelSigWorse.gif"" width=""24"" height=""24"" hSpace=""5"" ALT=""" & "Your score is statistically worse than your comparison group (at the " & MemberGroupPreference.QualityProgramName & ")" & """>"
                Case Else
                    strIcon = "<img src=""../img/ghost.gif"" width=""24"" height=""24"" hSpace=""5"" ALT="""">"
            End Select
        Else
            strIcon = "<img src=""../img/ghost.gif"" width=""1"" height=""24"">"
        End If

        Return strIcon

    End Function

#End Region

#Region " Initialize HBar Chart "

    Dim intWidth As Integer = 300
    Dim intHeight As Integer = 62
    Dim bol3D As Boolean = True
    Dim bolGradient As Boolean = False
    Dim intAdjust As Integer = 2.5
    Dim dblAdjust As Double = 2.5

    Public Function BuildChart(Optional ByVal Score As Double = -1, Optional ByVal Comparison As Double = -1, Optional ByVal Benchmark As Double = -1) As String
        'Draw the bars...
        Dim objBitmap As Bitmap = New Bitmap(intWidth, intHeight)
        Dim objGraphics As Graphics = Graphics.FromImage(objBitmap)

        'Draw the background of the image...
        DrawBackground(objGraphics, Color.White)
        'Draw the Benchmark Score bar...
        DrawHBar(objGraphics, Benchmark, 0, 44, Color.CadetBlue)
        'Draw the Comparison Score bar...
        DrawHBar(objGraphics, Comparison, 0, 25, Color.Lavender)
        'Draw the Current Score bar...
        DrawHBar(objGraphics, Score, 0, 6, Color.Purple)

        'Save the new image...
        Dim strFileName As String = Guid.NewGuid.ToString.Replace("-", "")
        Dim strFilePath As String = Request.PhysicalApplicationPath.ToString & "/eToolKit/temp_img/" & strFileName & ".png"
        'Dim strFilePath As String = Server.MapPath("/IDEAS/Toolkit/temp_img/" & strFileName & ".png")
        objBitmap.Save(strFilePath, ImageFormat.Png)

        Dim strBarImage As String = "<IMG alt="""" src=""temp_img/" & strFileName & ".png"" height=""" & intHeight & """ width=""" & intWidth & """ align=""absmiddle"">"

        Return strBarImage

        objGraphics.Dispose()
        objBitmap.Dispose()

    End Function

#End Region

#Region " Draw the Background "

    Private Sub DrawBackground(ByRef g As Graphics, ByVal c As Color)
        Dim objBrush As SolidBrush = New SolidBrush(c)
        Dim objRect As Rectangle = New Rectangle(0, 0, intWidth, intHeight)

        g.FillRectangle(objBrush, objRect)

    End Sub

#End Region

#Region " Draw a Horizontal Bar "

    Private Sub DrawHBar(ByRef g As Graphics, ByVal value As Double, ByVal x As Integer, ByVal y As Integer, ByVal c As Color)
        Dim objBrush As SolidBrush
        Dim objRect As Rectangle
        Dim intValue As Integer = CInt(CInt(value) * 2.4)

        'Set the SmoothingMode to the default...
        g.SmoothingMode = SmoothingMode.Default

        'Start drawing the Horizontal Bar...
        objBrush = New SolidBrush(c)
        objRect = New Rectangle(x, y, intValue, 18)
        g.FillRectangle(objBrush, objRect)

        'Draw the points for the top of the bar...
        Dim aobjPoint() As PointF
        objBrush = New SolidBrush(getDarkColor(c, 18))

        aobjPoint = New PointF() {New PointF(-1, y), _
            New PointF(intValue - 1, y), _
            New PointF(intValue - 1 + 6, y - 6), _
            New PointF(6, y - 6), _
            New PointF(0, y)}
        g.FillPolygon(objBrush, aobjPoint)

        'Draw the points for the end of the bar...
        objBrush = New SolidBrush(getDarkColor(c, 55))
        aobjPoint = New PointF() {New PointF(intValue, y + 18), _
            New PointF(intValue + 6, (y + 18) - 6), _
            New PointF(intValue + 6, y - 7), _
            New PointF(intValue, y - 1), _
            New PointF(intValue, y + 18)}
        g.FillPolygon(objBrush, aobjPoint)

        'Now Draw the actual value at the end of the bar...
        'First we are going set the SmoothingMode to AnitAlias.
        'This is to improve the quality of the text of the value...
        g.SmoothingMode = SmoothingMode.AntiAlias
        Dim imageText As String = "N/A"
        If value >= 0 Then
            imageText = FormatNumber(value, 1) & "%"
        End If
        Using imageFont As New Font("Verdana", 8, FontStyle.Regular)
            Using imageBrush As New SolidBrush(Color.Black)
                g.DrawString(imageText, imageFont, imageBrush, intValue + 12, y - 1)
            End Using
        End Using

    End Sub

#End Region

#Region " Adjust Bar Colors "

    Private Function getDarkColor(ByVal c As Color, ByVal d As Byte) As Color
        Dim r As Byte = 0
        Dim g As Byte = 0
        Dim b As Byte = 0

        If (c.R > d) Then r = (c.R - d)
        If (c.G > d) Then g = (c.G - d)
        If (c.B > d) Then b = (c.B - d)

        Dim c1 As Color = Color.FromArgb(r, g, b)
        Return c1
    End Function

    Private Function getLightColor(ByVal c As Color, ByVal d As Byte) As Color
        Dim r As Byte = 255
        Dim g As Byte = 255
        Dim b As Byte = 255

        If (CInt(c.R) + CInt(d) <= 255) Then r = (c.R + d)
        If (CInt(c.G) + CInt(d) <= 255) Then g = (c.G + d)
        If (CInt(c.B) + CInt(d) <= 255) Then b = (c.B + d)

        Dim c2 As Color = Color.FromArgb(r, g, b)
        Return c2
    End Function

#End Region

#Region " Get the DataSet "

    'Private Function GetDataSet() As DataSet
    Private Sub GetDataSet()
        dgResults.DataSource = Me.ToolKitServer.GetQuestionScores(MemberGroupPreference.SelectedViewId, SessionInfo.SelectedDimensionId)
        dgResults.DataBind()
    End Sub

#End Region

#Region " Build the Legend "

    Private Sub BuildLegend()
        Dim sbHTML As New StringBuilder

        With sbHTML
            .Append("<TABLE border=""0"" cellPadding=""0"" cellSpacing=""0"" width=""100%"">" & vbCrLf)
            .Append("<TR><TD align=""right"">" & vbCrLf)
            .Append("<TABLE border=""0"" cellPadding=""2"" cellSpacing=""0"">" & vbCrLf)
            .Append("<TR>" & vbCrLf)

            'Current Score...
            .Append("<TD><IMG src=""../img/LegendCurrentScore.gif"" width=""24"" height=""24""></TD>" & vbCrLf)
            .Append("<TD noWrap><FONT face=""Verdana, Arial, Helvetica"" size=""1"" color=""#000000"">")
            If MemberGroupPreference.AnalysisId = ToolKitServer.AnalysisVariable.PositiveScore Then
                .Append("Current Positive Score")
            Else
                .Append("Current Problem Score")
            End If
            .Append("</FONT>&nbsp;&nbsp;</TD>" & vbCrLf)

            'Comparative Score...
            .Append("<TD><IMG src=""../img/LegendComparisonScore.gif"" width=""24"" height=""24""></TD>" & vbCrLf)
            .Append("<TD noWrap><FONT face=""Verdana, Arial, Helvetica"" size=""1"" color=""#000000"">")
            .Append(MemberGroupPreference.CompDatasetName)
            .Append("</FONT>&nbsp;&nbsp;</TD>" & vbCrLf)

            'Benchmark Score...
            .Append("<TD><IMG src=""../img/LegendBenchmarkScore.gif"" width=""24"" height=""24""></TD>" & vbCrLf)
            .Append("<TD noWrap><FONT face=""Verdana, Arial, Helvetica"" size=""1"" color=""#000000"">")
            .Append("NRC Best")
            .Append("</FONT>&nbsp;&nbsp;</TD>" & vbCrLf)

            .Append("</TR>" & vbCrLf)
            .Append("</TABLE>" & vbCrLf)
            .Append("</TD></TR></TABLE>" & vbCrLf)

            .Append("<TABLE id=""tblLegend"" cellSpacing=""2"" cellPadding=""3"" width=""100%"" border=""0"">" & vbCrLf)
            .Append("<TR>" & vbCrLf)
            .Append("<TD vAlign=""top""><IMG alt="""" src=""../img/ModelSigBetter.gif""></TD>" & vbCrLf)
            .Append("<TD vAlign=""top"" width=""100%""><FONT face=""Verdana, Arial, Helvetica"" color=""#7c7c7c"" size=""2"">Your score is statistically better than your comparison group (at the " & MemberGroupPreference.QualityProgramName & ")</FONT></TD>" & vbCrLf)
            .Append("</TR>" & vbCrLf)
            .Append("<TR>" & vbCrLf)
            .Append("<TD vAlign=""top""><IMG alt="""" src=""../img/ModelSigWorse.gif""></TD>" & vbCrLf)
            .Append("<TD vAlign=""top""><FONT face=""Verdana, Arial, Helvetica"" color=""#7c7c7c"" size=""2"">Your score is statistically worse than your comparison group (at the " & MemberGroupPreference.QualityProgramName & ")</FONT></TD>" & vbCrLf)
            .Append("</TR>" & vbCrLf)
            .Append("</TABLE><BR>" & vbCrLf)
        End With

        ltlLegend.Text = sbHTML.ToString
    End Sub

#End Region

    Protected Sub buttonSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ButtonSearch.Click
        ' Choose a question
        MemberGroupPreference.SelectedViewId = -1
        SessionInfo.SelectedViewName = "Choose a question"

        Response.Redirect("QuestionSelection.aspx?SearchText=" & Me.TextSearch.Text)
    End Sub

End Class