Imports System.Drawing

Partial Public Class eToolKit_ModelSelection
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return True
        End Get
    End Property

    Protected Overrides ReadOnly Property RequiresDataSelection() As Boolean
        Get
            Return True
        End Get
    End Property

    Private Enum ModelViewMode
        View = 1
        Theme = 2
    End Enum

    Private ReadOnly Property ViewMode() As ModelViewMode
        Get
            If Request.QueryString("Type") Is Nothing Then
                Return ModelViewMode.View
            ElseIf Request.QueryString("Type").Equals("View", StringComparison.CurrentCultureIgnoreCase) Then
                Return ModelViewMode.View
            Else
                Return ModelViewMode.Theme
            End If
        End Get
    End Property

    Protected Overrides Sub OnPreInit(ByVal e As System.EventArgs)
        MyBase.OnPreInit(e)
        If SessionInfo.SelectedDimensionId = 0 Then
            If MemberGroupPreference.IsChooseQuestionSelected Then
                Response.Redirect("QuestionSelection.aspx")
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Generate the Organizational Tree
        LoadOrgTree()
        LoadTip()
    End Sub

#Region " Load Tips "

    Private Sub LoadTip()
        Dim sbHTML As New StringBuilder

        With sbHTML
            If CInt(Request.QueryString("x")) = 1 Then
                .Append("<STRONG>Tip:</STRONG> To navigate backwards in the tree select the top, parent node of the " & vbCrLf)
                .Append("Improvement Model Tree.<BR>" & vbCrLf)
                .Append("<BR>" & vbCrLf)
                .Append("<STRONG>Legend:</STRONG>" & vbCrLf)
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
            Else
                .Append("<STRONG>Tip:</STRONG> To navigate through the Improvement Model Tree click on a View " & vbCrLf)
                .Append("to see the Departments or Dimensions of that view.<BR>" & vbCrLf)
            End If
        End With

        lblTip.Text = sbHTML.ToString

    End Sub

#End Region

#Region " Generate the Org Tree "

    'Define the OrgTree Nodes...
    Dim intWidth As Integer = 165
    Dim intHeight As Integer = 35
    Dim intPadding As Integer = 16
    Dim strIconPath As String = "../img/"

    Private Sub LoadOrgTree()
        'Get the data for the Question HTML Table.
        Dim objDataSet As New DataSet

        If Me.ViewMode = ModelViewMode.Theme AndAlso MemberGroupPreference.SelectedViewId > 0 Then
            objDataSet = GetDataSet(MemberGroupPreference.SelectedViewId)
            Me.SideNav1.ShowViewSelection = True
        Else
            objDataSet = GetDataSet(MemberGroupPreference.ServiceTypeId)
            Me.SideNav1.ShowViewSelection = False
        End If

        'Loop through the DataSet to write out the questions and horizontal bar charts...
        'Get the count of records in the DataSet.
        Dim intRowCnt As Integer = objDataSet.Tables(0).Rows.Count
        Dim intChildCnt As Integer = intRowCnt
        Dim bolColumnar As Boolean = False

        'Set whether the children are displayed in a columnar fashion.
        If intChildCnt > 3 Then
            bolColumnar = True
        End If

        'Declare a new StringBuilder object.
        Dim sbHTML As New StringBuilder
        Dim intColumnCnt As Integer = intChildCnt

        If bolColumnar Then
            intColumnCnt = 3
        End If

        With sbHTML
            'Start the HTML table and draw the parent node in the tree.
            .Append("<TABLE border=""0"" cellPadding=""0"" cellSpacing=""0"">" & vbCrLf)

            'Start the first row and build the parent node.
            If Me.ViewMode = ModelViewMode.Theme Then 'This will be either the Dimension or Department Node when a parent.
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD colSpan=""" & intColumnCnt & """ align=""center"" vAlign=""top"">")
                .Append(BuildChartNode(MemberGroupPreference.SelectedViewId, SessionInfo.SelectedViewName, -1, True, False, True))
                .Append("</TD>" & vbCrLf)
                .Append(vbTab & "</TR>" & vbCrLf)
            Else 'This is the initial node...
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD colSpan=""" & intColumnCnt & """ align=""center"" vAlign=""top"">")
                .Append(BuildChartNode(MemberGroupPreference.ServiceTypeId, Me.ToolKitServer.ServiceTypeName, 0, True, False, True))
                .Append("</TD>" & vbCrLf)
                .Append(vbTab & "</TR>" & vbCrLf)
            End If

            'Now write out the connector row.
            .Append(vbTab & "<TR>" & vbCrLf)
            Dim intMiddleChild As Integer = (CInt((intColumnCnt / 2) - 0.5)) + 1
            Dim bolEven As Boolean = False

            If intChildCnt Mod 2 = 0 Then
                bolEven = True
            End If

            Dim i As Integer
            For i = 0 To intColumnCnt - 1

                If bolColumnar Then
                    If i = intMiddleChild - 1 Then
                        'Open the table cell...
                        .Append(vbTab & vbTab & "<TD align=""center"" colSpan=""" & intColumnCnt & """>")
                        .Append(DrawNodeConnector(NodeConnector.LargeLine))
                    End If
                Else
                    If i = 0 And intChildCnt > 2 Then
                        .Append(vbTab & vbTab & "<TD align=""center"">")
                        .Append(DrawNodeConnector(NodeConnector.LargeLeftElbow))
                    ElseIf i = 0 And intChildCnt = 1 Then
                        'Open the table cell...
                        .Append(vbTab & vbTab & "<TD align=""center"" colSpan=""" & intColumnCnt & """>")
                        .Append(DrawNodeConnector(NodeConnector.LargeLine))
                    ElseIf i = 0 And intChildCnt = 2 Then
                        .Append(vbTab & vbTab & "<TD align=""center"">")
                        .Append(DrawNodeConnector(NodeConnector.LargeLeftElbowAux))
                    ElseIf i = intMiddleChild - 1 Then
                        If bolEven Then
                            .Append(vbTab & vbTab & "<TD align=""center"">")
                            .Append(DrawNodeConnector(NodeConnector.SmallTee))
                        Else
                            .Append(vbTab & vbTab & "<TD align=""center"">")
                            .Append(DrawNodeConnector(NodeConnector.LargePlus))
                        End If
                    ElseIf i = intColumnCnt - 1 Then
                        .Append(vbTab & vbTab & "<TD align=""center"">")
                        .Append(DrawNodeConnector(NodeConnector.LargeRightElbow))
                    End If
                End If

                'Close the table cell...
                .Append("</TD>" & vbCrLf)
            Next i

            'End the row...
            .Append(vbTab & "</TR>" & vbCrLf)

            'Now write out the children...
            If Not bolColumnar Then
                .Append(vbTab & "<TR>" & vbCrLf)
                For i = 0 To intChildCnt - 1
                    .Append(vbTab & vbTab & "<TD align=""center"" vAlign=""middle"">")
                    .Append(BuildChartNode(CInt(objDataSet.Tables(0).Rows(i).Item("Dimension_id")), _
                        objDataSet.Tables(0).Rows(i).Item("strDimension_nm").ToString, _
                        CInt(objDataSet.Tables(0).Rows(i).Item("Problem")), _
                        CType(objDataSet.Tables(0).Rows(i).Item("bitHasChild"), Boolean), _
                        CType(objDataSet.Tables(0).Rows(i).Item("HasResults"), Boolean), _
                        False))
                    .Append("</TD>" & vbCrLf)
                Next i
                .Append(vbTab & "</TR>" & vbCrLf)

            Else
                For i = 0 To intChildCnt - 1
                    If i Mod 2 = 0 Then
                        .Append(vbTab & "<TR>" & vbCrLf)
                    End If
                    .Append(vbTab & vbTab & "<TD align=""center"" vAlign=""middle"">")
                    .Append(BuildChartNode(CInt(objDataSet.Tables(0).Rows(i).Item("Dimension_id")), _
                        objDataSet.Tables(0).Rows(i).Item("strDimension_nm").ToString, _
                        CInt(objDataSet.Tables(0).Rows(i).Item("Problem")), _
                        CType(objDataSet.Tables(0).Rows(i).Item("bitHasChild"), Boolean), _
                        CType(objDataSet.Tables(0).Rows(i).Item("HasResults"), Boolean), False))
                    .Append("</TD>" & vbCrLf)

                    If i Mod 2 = 0 Then
                        If i = intChildCnt - 1 Then
                            .Append(vbTab & vbTab & "<TD align=""center"">" & DrawNodeConnector(NodeConnector.SmallUpsideDownLeftElbow) & "</TD>" & vbCrLf)
                        ElseIf i = intChildCnt - 2 Then
                            .Append(vbTab & vbTab & "<TD align=""center"">" & DrawNodeConnector(NodeConnector.SmallTee) & "</TD>" & vbCrLf)
                        Else
                            .Append(vbTab & vbTab & "<TD align=""center"">" & DrawNodeConnector(NodeConnector.SmallPlus) & "</TD>" & vbCrLf)
                        End If
                    Else
                        .Append(vbTab & "</TR>" & vbCrLf)
                    End If

                Next i
            End If

            'End the HTML table...
            .Append("</TABLE>")
        End With

        'Write out the HTML...
        ltlOrgChart.Text = sbHTML.ToString

    End Sub

#End Region

#Region " Build Chart Node "

    Private Function BuildChartNode(ByVal ID As Integer, ByVal Label As String, ByVal Icon As Integer, ByVal HasChild As Boolean, ByVal HasResults As Boolean, ByVal IsParent As Boolean) As String
        Dim sbHTML As New StringBuilder

        With sbHTML
            .Append("<TABLE cellSpacing=""0"" cellPadding=""0"" width=""" & intWidth & """ height=""" & intHeight & """ border=""0"">" & vbCrLf)
            .Append("<TR>" & vbCrLf)
            .Append("<TD width=""100%"">" & vbCrLf)
            .Append("<TABLE cellSpacing=""1"" cellPadding=""0"" width=""" & intWidth & """ height=""" & intHeight & """ bgColor=""#7c7c7c"" border=""0"">" & vbCrLf)
            .Append("<TR>" & vbCrLf)
            .Append("<TD bgColor=""#f1f2f3"">" & vbCrLf)
            .Append("<TABLE cellSpacing=""2"" cellPadding=""3"" width=""" & intWidth & """ height=""" & intHeight & """ border=""0"">" & vbCrLf)
            .Append("<TR>" & vbCrLf)
            .Append("<TD>")

            'Write out the Icon if necessary.
            Select Case Icon
                Case -1
                    .Append("<IMG src=""" & strIconPath & "ModelUpTree.gif"" width=""24"" height=""24"" ALT=""Move up one level"">")
                Case 1
                    .Append("<IMG src=""" & strIconPath & "ModelSigBetter.gif"" width=""24"" height=""24"" ALT=""" & "Your score is statistically better than your comparison group (at the " & MemberGroupPreference.QualityProgramName & ")" & """>")
                Case 2
                    .Append("<IMG src=""" & strIconPath & "ModelSigWorse.gif"" width=""24"" height=""24"" ALT=""" & "Your score is statistically worse than your comparison group (at the " & MemberGroupPreference.QualityProgramName & ")" & """>")
                Case Else
                    .Append("<IMG src=""" & strIconPath & "ghost.gif"" width=""1"" height=""24"" ALT="""">")
            End Select
            .Append("</TD>" & vbCrLf)

            Dim strFontColor As String = "#7c7c7c"

            If HasChild Or HasResults Then
                If IsParent Then
                    Dim url As String = CreatePostBack(ID.ToString, Label, NodeType.Parent)
                    .AppendFormat("<TD align=""center"" width=""100%"" OnClick=""{0};"" style=""cursor: pointer;"">", url)
                Else
                    Dim url As String = CreatePostBack(ID.ToString, Label, NodeType.Child)
                    .AppendFormat("<TD align=""center"" width=""100%"" OnClick=""{0};"" style=""cursor: pointer;"">", url)
                End If
                strFontColor = "#003399"
            Else
                .Append("<TD align=""center"" width=""100%"">")
            End If

            .Append("<FONT face=""Verdana, Arial, Helvetica"" size=""1"" color=""" & strFontColor & """><STRONG>" & Label & "</STRONG></FONT>")

            .Append("</TD>" & vbCrLf)
            .Append("</TR>" & vbCrLf)
            .Append("</TABLE>" & vbCrLf)
            .Append("</TD>" & vbCrLf)
            .Append("</TR>" & vbCrLf)
            .Append("</TABLE>" & vbCrLf)
            .Append("</TD>" & vbCrLf)
            .Append("<TD background=""" & strIconPath & "ModelShadowVert.gif"" vAlign=""top""><IMG alt="""" src=""" & strIconPath & "ModelShadowRight.gif""></TD>" & vbCrLf)
            .Append("</TR>" & vbCrLf)
            .Append("<TR>" & vbCrLf)
            .Append("<TD background=""" & strIconPath & "ModelShadowHoriz.gif"" align=""left""><IMG alt="""" src=""" & strIconPath & "ModelShadowBottom.gif""></TD>" & vbCrLf)
            .Append("<TD><IMG alt="""" src=""" & strIconPath & "ModelShadowCorner.gif""></TD>" & vbCrLf)
            .Append("</TR>" & vbCrLf)
            .Append("</TABLE>" & vbCrLf)
        End With

        'Return the HTML...
        Return sbHTML.ToString
    End Function


#End Region

#Region " Draw Node Connector "

    Private Enum NodeConnector
        LargeLine = 0
        LargePlus = 1
        LargeLeftElbow = 2
        LargeLeftElbowAux = 3
        LargeRightElbow = 4
        SmallPlus = 5
        SmallTee = 6
        SmallUpsideDownLeftElbow = 7
    End Enum

    Private Function DrawNodeConnector(ByVal Connector As NodeConnector) As String
        'Dimension the connector objects...
        Dim b As Bitmap
        Dim g As Graphics
        Dim c As Color
        Dim objBrush As SolidBrush
        Dim objRect As Rectangle
        Dim width As Integer
        Dim height As Integer

        Select Case Connector
            Case NodeConnector.LargePlus, NodeConnector.LargeLeftElbow, NodeConnector.LargeLeftElbowAux, NodeConnector.LargeRightElbow, NodeConnector.LargeLine
                width = intWidth + intPadding
                height = CInt((intPadding / 2) + intPadding)
            Case Else
                width = 89
                height = intHeight + intPadding
        End Select

        'Create a new Bitmap
        b = New Bitmap(width, height)
        g = Graphics.FromImage(b)

        'Draw the background of the image...
        c = Color.White
        objBrush = New SolidBrush(c)
        objRect = New Rectangle(0, 0, width, height)

        g.FillRectangle(objBrush, objRect)

        'Draw the connector line...
        Dim p As Pen
        Dim pStart As Point
        Dim pEnd As Point

        c = Color.FromArgb(124, 124, 124)
        p = New Pen(c, 1)
        Select Case Connector
            Case NodeConnector.LargeLine
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), 0)
                pEnd = New Point(CInt(width / 2), height)
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.LargePlus
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), 0)
                pEnd = New Point(CInt(width / 2), height)
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(0, CInt(height / 2))
                pEnd = New Point(width, CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.LargeLeftElbow
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), CInt(height / 2))
                pEnd = New Point(CInt(width / 2), height)
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(CInt(width / 2), CInt(height / 2))
                pEnd = New Point(width, CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.LargeLeftElbowAux
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), CInt(height / 2))
                pEnd = New Point(CInt(width / 2), height)
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(CInt(width / 2), CInt(height / 2))
                pEnd = New Point(width, CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)

                'Draw the Auxillary line...
                pStart = New Point(width - 1, 0)
                pEnd = New Point(width - 1, CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.LargeRightElbow
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), CInt(height / 2))
                pEnd = New Point(CInt(width / 2), height)
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(0, CInt(height / 2))
                pEnd = New Point(CInt(width / 2), CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.SmallPlus
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), 0)
                pEnd = New Point(CInt(width / 2), height)
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(0, CInt(height / 2))
                pEnd = New Point(width, CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.SmallTee
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), 0)
                pEnd = New Point(CInt(width / 2), CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(0, CInt(height / 2))
                pEnd = New Point(width, CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeConnector.SmallUpsideDownLeftElbow
                'Draw the vertical line...
                pStart = New Point(CInt(width / 2), 0)
                pEnd = New Point(CInt(width / 2), CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)

                'Draw the horizontal line...
                pStart = New Point(0, CInt(height / 2))
                pEnd = New Point(CInt(width / 2), CInt(height / 2))
                g.DrawLine(p, pStart, pEnd)
        End Select

        'Save the new image...
        'Dim strFileName As String = GenRandomString(15)
        Dim strFileName As String = Guid.NewGuid.ToString.Replace("-", "")
        Dim strFilePath As String = Request.PhysicalApplicationPath.ToString & "eToolKit\temp_img\" & strFileName & ".png"
        'Dim strFilePath As String = Server.MapPath("/IDEAS/Toolkit/temp_img/" & strFileName & ".png")
        b.Save(strFilePath, Imaging.ImageFormat.Png)

        'Clean up...
        g.Dispose()
        b.Dispose()

        Dim strImage As String = "<IMG alt="""" border=""0"" src=""temp_img/" & strFileName & ".png"" height=""" & height & """ width=""" & width & """>"

        'Return the HTML to display the image...
        Return strImage

    End Function

#End Region

#Region " Get the DataSet "

    Private Function GetDataSet(ByVal intID As Integer) As DataSet
        Dim objDataSet As New DataSet
        objDataSet = Me.ToolKitServer.GetTreeData(intID)

        'Used for testing...
        'Dim strAppPath As String = Request.PhysicalApplicationPath.ToString
        'objDataSet.ReadXml(strAppPath & "Toolkit/OrgChartData.xml")

        Return objDataSet

    End Function

#End Region

    Private Enum NodeType
        Parent = 0
        Child = 1
    End Enum

    Private Function CreatePostBack(ByVal ID As String, ByVal label As String, ByVal ntype As NodeType) As String
        Dim btn As New LinkButton
        btn.ID = "Node" & ID
        btn.Text = label
        btn.Visible = False
        btn.CommandName = "Clicked"
        btn.CommandArgument = ID
        Select Case ntype
            Case NodeType.Parent
                AddHandler btn.Command, AddressOf ParentNodeCommand
            Case NodeType.Child
                AddHandler btn.Command, AddressOf ChildNodeCommand
        End Select

        Me.Controls.Add(btn)
        Return Me.ClientScript.GetPostBackEventReference(btn, ID)
    End Function

    Private Sub ParentNodeCommand(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs)
        'Response.Write("Parent Clicked: " & e.CommandArgument & "<BR>")
        'Response.Redirect("ViewSelection.aspx")
        Response.Redirect("DataSelection.aspx")
    End Sub

    Private Sub ChildNodeCommand(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs)
        'Response.Write("Child Clicked: " & e.CommandArgument & "<BR>")
        Dim btn As LinkButton = DirectCast(sender, LinkButton)
        If Me.ViewMode = ModelViewMode.View Then 'This is a view being clicked
            MemberGroupPreference.SelectedViewId = CInt(e.CommandArgument)
            SessionInfo.SelectedViewName = btn.Text
            Response.Redirect("ThemeSelection.aspx")
        Else    'This is a dimension being clicked
            SessionInfo.SelectedDimensionId = CInt(e.CommandArgument)
            SessionInfo.SelectedDimensionName = btn.Text
            Response.Redirect("QuestionScores.aspx")
        End If
    End Sub

End Class