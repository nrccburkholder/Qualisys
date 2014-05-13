Partial Public Class eToolKit_QuestionContent
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

    Private ReadOnly Property AllowTrending() As Boolean
        Get
            Return CurrentUser.SelectedGroup.HasPrivilege("eReports", "Access Interactive eReports")
        End Get
    End Property

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
        Me.TrendLinkDiv.Visible = AllowTrending
        Me.ControlLinkDiv.Visible = AllowTrending

        If Not Page.IsPostBack Then
            If MemberGroupPreference.IsChooseQuestionSelected Then
                Me.SideNav1.ShowDimensionSelection = False
                Me.BackLink.NavigateUrl = String.Format("~/eToolKit/QuestionSelection.aspx")
            Else
                Me.BackLink.NavigateUrl = String.Format("~/eToolKit/QuestionScores.aspx?x=1&node={0}&lbl={1}", SessionInfo.SelectedDimensionId, SessionInfo.SelectedDimensionName)
            End If

            LoadPageContent()
            LoadGraph()

        End If
    End Sub

#Region " Load the Content "

    Private Sub LoadPageContent()
        Dim contentType As String = Request.QueryString("aux")

        'Set the current question text.
        Me.QuestionTextLabel.Text = Me.ToolKitServer.GetQuestionText(MemberGroupPreference.SelectedViewId, SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId)
        Dim contentHtml As String = ""
        Dim isNewContent As Boolean
        Select Case contentType
            Case "qi"
                Me.PageLogo1.Title = "Question Importance"
                Me.ContentTitle.Text = "Why is this question important?"
                contentHtml = Me.ToolKitServer.GetContentData(SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, ToolKitServer.enuContentDataTypes.enuCDTQuestionImportance, isNewContent)

                If contentHtml.Length <= 1 Then
                    contentHtml = "<FONT face=""Verdana, Arial, Helvetica"" size=""2"" color=""#7c7c7c"">There is no <I>Question Importance</I> for this question.</FONT>"
                End If
            Case "qc"
                Me.PageLogo1.Title = "Quick Check"
                Me.ContentTitle.Visible = False
                contentHtml = Me.ToolKitServer.GetContentData(SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, ToolKitServer.enuContentDataTypes.enuCDTQuickCheck, isNewContent)

                If contentHtml.Length <= 1 Then
                    contentHtml = "<FONT face=""Verdana, Arial, Helvetica"" size=""2"" color=""#7c7c7c"">There is no <I>Quick Check</I> for this question.</FONT>"
                End If
            Case "wr"
                Me.PageLogo1.Title = "What is Recommended?"
                Me.ContentTitle.Visible = False
                contentHtml = Me.ToolKitServer.GetContentData(SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, ToolKitServer.enuContentDataTypes.enuCDTRecommendations, isNewContent)

                If contentHtml.Length <= 1 Then
                    contentHtml = "<FONT face=""Verdana, Arial, Helvetica"" size=""2"" color=""#7c7c7c"">There is no <I>What is Recommended?</I> for this question.</FONT>"
                End If
            Case "r"
                Me.PageLogo1.Title = "Resources"
                Me.ContentTitle.Visible = False
                contentHtml = Me.ToolKitServer.GetContentData(SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, ToolKitServer.enuContentDataTypes.enuCDTResources, isNewContent)

                If contentHtml.Length <= 1 Then
                    contentHtml = "<FONT face=""Verdana, Arial, Helvetica"" size=""2"" color=""#7c7c7c"">There are no <I>Resources</I> for this question.</FONT>"
                End If
            Case Else
                Me.PageLogo1.Title = "Question Importance"
                Me.ContentTitle.Text = "Why is this question important?"
                contentHtml = Me.ToolKitServer.GetContentData(SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, ToolKitServer.enuContentDataTypes.enuCDTQuestionImportance, isNewContent)

                If contentHtml.Length <= 1 Then
                    contentHtml = "<FONT face=""Verdana, Arial, Helvetica"" size=""2"" color=""#7c7c7c"">There is no <I>Question Importance</I> for this question.</FONT>"
                End If
        End Select

        Me.ContentLiteral.Text = contentHtml
        Me.NewContentImage.Visible = isNewContent
    End Sub

#End Region

#Region " Load the Question Results Graph "

    Private Sub LoadGraph()
        With Me.ScoreChart
            'Set the type of chart.
            .Gallery = SoftwareFX.ChartFX.Gallery.Bar
            .Chart3D = False
            .HtmlTag = "PNG"
            .ImgHeight = 350
            .ImgWidth = 230

            'Set the background properties of the chart.
            .TopGap = 0
            .RightGap = 0
            .LeftGap = 0
            .BottomGap = 0
            .BackColor = Drawing.Color.White
            .BorderObject.Color = System.Drawing.Color.White
            .InsideColor = System.Drawing.Color.WhiteSmoke

            'Populating the Chart with fixed data.
            'Session("uiSelectedCurrent") = objIDEASServer.DecryptString(astrAux(2))
            'Session("uiSelectedComparison") = objIDEASServer.DecryptString(astrAux(3))
            'Session("uiSelectedBenchMark") = objIDEASServer.DecryptString(astrAux(4))
            .OpenData(SoftwareFX.ChartFX.COD.Values, 3, 1)
            '.Value(0, 0) = (SessionInfo.SelectedQuestionScore) / 100
            .Value(0, 0) = (Me.ToolKitServer.GetQuestionScore(MemberGroupPreference.SelectedViewId, SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId)) / 100
            '.Value(1, 0) = (SessionInfo.SelectedQuestionNorm) / 100
            .Value(1, 0) = (Me.ToolKitServer.GetQuestionNorm(MemberGroupPreference.SelectedViewId, SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId)) / 100
            '.Value(2, 0) = (SessionInfo.SelectedQuestionBest) / 100
            .Value(2, 0) = (Me.ToolKitServer.GetQuestionBest(MemberGroupPreference.SelectedViewId, SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId)) / 100
            .CloseData(SoftwareFX.ChartFX.COD.Values)

            'Define each series.
            Dim i As Integer
            Dim intNumSeries As Integer = 3

            For i = 0 To intNumSeries - 1
                Select Case i
                    Case 0
                        .Series(i).Color = Drawing.Color.Purple
                    Case 1
                        .Series(i).Color = Drawing.Color.Lavender
                    Case 2
                        .Series(i).Color = Drawing.Color.CadetBlue
                End Select
                .Series(i).PointLabels = True
                .Series(i).PointLabelAngle = 0
                '.Series(i).PointLabelAlign = SoftwareFX.ChartFX.LabelAlign.Center
                .Series(i).PointLabelColor = Drawing.Color.Black
            Next i

            'Format the axis labels.
            .AxisY.LabelsFormat.Format = SoftwareFX.ChartFX.AxisFormat.Percentage
            .AxisY.LabelsFormat.Decimals = 1
            .AxisY.Min = 0
            .AxisY.Max = 1
            .AxisX.Visible = False

            'Define the legend.
            .SerLegBox = True
            .SerLegBoxObj.Alignment = SoftwareFX.ChartFX.ToolAlignment.Near
            .SerLegBoxObj.Docked = SoftwareFX.ChartFX.Docked.Bottom

            If MemberGroupPreference.AnalysisId = ToolKitServer.AnalysisVariable.PositiveScore Then
                .Series(0).Legend = "Current Positive Score"
            Else
                .Series(0).Legend = "Current Problem Score"
            End If
            .Series(1).Legend = MemberGroupPreference.CompDatasetName
            .Series(2).Legend = "NRC Best"

        End With

    End Sub

#End Region

End Class