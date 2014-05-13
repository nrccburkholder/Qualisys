Imports System.ComponentModel
Imports Nrc.DataMart.MySolutions.Library.Legacy
Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.NRCAuthLib
Imports Nrc.NRCWebDocumentManagerLibrary
Imports System.Drawing
Imports System.Drawing.Imaging

Partial Public Class eToolKit_UserControls_SideNav
    Inherits System.Web.UI.UserControl

#Region " Public Properties "
    <Category("Menus"), DefaultValue(True)> _
    Public Property ShowSelectionTree() As Boolean
        Get
            Return Me.SelectionTreeMenu.Visible
        End Get
        Set(ByVal value As Boolean)
            Me.SelectionTreeMenu.Visible = value
        End Set
    End Property

    <Category("Menus"), DefaultValue(True)> _
    Public Property ShowToolbox() As Boolean
        Get
            Return Me.ToolBoxMenu.Visible
        End Get
        Set(ByVal value As Boolean)
            Me.ToolBoxMenu.Visible = value
        End Set
    End Property

    <Category("Menus"), DefaultValue(True)> _
    Public Property ShowSupportMenu() As Boolean
        Get
            Return Me.SupportMenu.Visible
        End Get
        Set(ByVal value As Boolean)
            Me.SupportMenu.Visible = value
        End Set
    End Property

    <Category("Menus"), DefaultValue(True)> _
    Public Property ShowMemberResources() As Boolean
        Get
            Return Me.MemberResourcesMenu.Visible
        End Get
        Set(ByVal value As Boolean)
            Me.MemberResourcesMenu.Visible = value
        End Set
    End Property

    <Category("Menus"), DefaultValue(True)> _
    Public Property ShowActionPlans() As Boolean
        Get
            Return Me.ActionPlansMenu.Visible
        End Get
        Set(ByVal value As Boolean)
            Me.ActionPlansMenu.Visible = value
        End Set
    End Property

    <Category("MenuItems"), DefaultValue(False)> _
    Public Property ShowControlChartGuide() As Boolean
        Get
            Return Me.ControlChartLink.Visible
        End Get
        Set(ByVal value As Boolean)
            Me.ControlChartLink.Visible = value
        End Set
    End Property

    <Category("MenuItems"), DefaultValue(False)> _
    Public Property ShowViewSelection() As Boolean
        Get
            If ViewState("ShowViewSelection") IsNot Nothing Then
                Return CBool(ViewState("ShowViewSelection"))
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            ViewState("ShowViewSelection") = value
        End Set
    End Property

    <Category("MenuItems"), DefaultValue(False)> _
    Public Property ShowDimensionSelection() As Boolean
        Get
            If ViewState("ShowDimensionSelection") IsNot Nothing Then
                Return CBool(ViewState("ShowDimensionSelection"))
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            ViewState("ShowDimensionSelection") = value
        End Set
    End Property

    <Category("MenuItems"), DefaultValue(False)> _
    Public Property ShowImprovementContentTypes() As Boolean
        Get
            If ViewState("ShowImprovementContentTypes") IsNot Nothing Then
                Return CBool(ViewState("ShowImprovementContentTypes"))
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            ViewState("ShowImprovementContentTypes") = value
        End Set
    End Property

    <Category("MenuItems"), DefaultValue(False)> _
    Public Property ShowQuestionResultsLink() As Boolean
        Get
            If ViewState("ShowQuestionResultsLink") IsNot Nothing Then
                Return CBool(ViewState("ShowQuestionResultsLink"))
            Else
                Return False
            End If
        End Get
        Set(ByVal value As Boolean)
            ViewState("ShowQuestionResultsLink") = value
        End Set
    End Property


#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.SelectionTreeMenu.Style.Add("margin-bottom", "10px")
        Me.ToolBoxMenu.Style.Add("margin-bottom", "10px")
        Me.MemberResourcesMenu.Style.Add("margin-bottom", "10px")
        Me.ActionPlansMenu.Style.Add("margin-bottom", "10px")
        Me.SupportMenu.Style.Add("margin-bottom", "10px")
        If Page.IsCallback Then
            ' Ignore callbacks
        ElseIf Page.IsPostBack Then
            ' TODO: Use CollapsiblePanelExtender.Collapsed when its fixed
            ' Fix borrowed from "ToolkitTests/Manual/ClientStateLifecycle.aspx" in the AJAX Control Toolkit 
            If Me.ShowSelectionTree Then SessionInfo.CollapseSelectionTreeMenu = CBool(Me.SelectionTreeMenuExtender.ClientState)
            If Me.ShowSupportMenu Then SessionInfo.CollapseSupportMenu = CBool(Me.SupportMenuExtender.ClientState)
            If Me.ShowToolbox Then SessionInfo.CollapseToolBoxMenu = CBool(Me.ToolBoxMenuExtender.ClientState)
            If Me.ShowMemberResources Then SessionInfo.CollapseMemberResources = CBool(Me.MemberResourcesExtender.ClientState)
            If Me.ShowActionPlans Then SessionInfo.CollapseActionPlansMenu = CBool(Me.ActionPlansMenuExtender.ClientState)
        Else
            If Me.ShowSelectionTree Then
                ltlSelectionTreeMenu.Text = Me.LoadModelNav
                Me.SelectionTreeMenuExtender.Collapsed = SessionInfo.CollapseSelectionTreeMenu
            End If

            If Me.ShowSupportMenu Then
                Me.PreferencesLink.NavigateUrl = "~/eToolKit/Preferences.aspx?ReturnPath=" & Server.UrlEncode(Request.Url.PathAndQuery)
                Me.SupportMenuExtender.Collapsed = SessionInfo.CollapseSupportMenu
            End If

            If Me.ShowToolbox Then
                Me.QuestionResultsLink.Visible = Me.ShowQuestionResultsLink
                If Me.ShowQuestionResultsLink Then
                    Me.QuestionResultsLink.NavigateUrl = "~/eToolKit/QuestionScores.aspx?x=1&amp;node=" & SessionInfo.SelectedDimensionId
                End If
                Me.QuestionImportanceLink.Visible = Me.ShowImprovementContentTypes
                Me.QuickCheckLink.Visible = Me.ShowImprovementContentTypes
                Me.RecommendationsLink.Visible = Me.ShowImprovementContentTypes
                Me.ResourcesLink.Visible = Me.ShowImprovementContentTypes
                Me.CommentsLink.Visible = CurrentUser.SelectedGroup.HasPrivilege("eComments")

                Me.ResearchInquiry.NavigateUrl = "~/eToolKit/ResearchInquiry.aspx?ReturnPath=" & Request.Url.PathAndQuery
                Me.AddLearningNetworkLinks()
                Me.ToolBoxMenuExtender.Collapsed = SessionInfo.CollapseToolBoxMenu
            End If

            If Me.ShowMemberResources Then
                Me.MemberResourcesMoreLink.Enabled = CurrentUser.HasEToolkitAccess

                '   Rick Christenham (09/10/2007):  NRC eToolkit Enhancement II:
                '                                   Determine what groups the user belongs to so that
                '                                   we can filter member resources displayed.
                Dim tkServer As ToolkitServer = SessionInfo.EToolKitServer
                Dim serviceTypeId As Integer, selectedViewId As Integer
                Dim groupId As Integer
                If tkServer IsNot Nothing Then
                    serviceTypeId = tkServer.MemberGroupPreference.ServiceTypeId
                    selectedViewId = tkServer.MemberGroupPreference.SelectedViewId
                    groupId = tkServer.MemberGroupPreference.GroupId
                End If

                Me.MemberResourcesList.DataSource = MemberResource.GetRecentMemberResources(serviceTypeId, selectedViewId, SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, groupId)
                Me.MemberResourcesList.DataBind()
                Me.MemberResourcesExtender.Collapsed = SessionInfo.CollapseMemberResources
            End If

            If Me.ShowActionPlans Then
                Dim docTree As DocumentTree

                'Get the document tree
                docTree = DocumentTree.GetApbDocumentTree(CurrentUser.SelectedGroup.GroupId, CurrentUser.Member.MemberId, 4)

                If docTree Is Nothing OrElse docTree.Nodes.Count = 0 Then
                    ActionPlansNotAvailable.Visible = True
                    ActionPlansTree.Visible = False
                Else
                    ActionPlansNotAvailable.Visible = False
                    ActionPlansTree.Visible = True
                    'Add each root folder to the tree
                    ActionPlansTree.Nodes.Clear()
                    For Each docNode As DocumentNode In docTree.Nodes
                        LoadFolder(docNode, ActionPlansTree.Nodes)
                    Next
                End If
                Me.ActionPlansMenuExtender.Collapsed = SessionInfo.CollapseActionPlansMenu
            End If
        End If
    End Sub

    Private Sub AddLearningNetworkLinks()
        Dim forumUrl As String = ""
        Dim archiveUrl As String = ""
        Dim movieBaseUrl As String = Me.Page.ResolveUrl("~/eToolKit/Movies/MoviePlayer.aspx?MovieTitle=")
        Dim movieAlias As String = ""
        Dim movieUrl As String = ""

        forumUrl = Config.LNForumUrls.ForumLink(SessionInfo.SelectedDimensionName)
        archiveUrl = Config.LNArchiveUrls.ArchiveLink(SessionInfo.SelectedDimensionName)
        movieAlias = Config.DimensionMovieAliases.MovieAlias(SessionInfo.SelectedDimensionName)

        If forumUrl = "" Then
            Me.LnForumsLink.Visible = False
        Else
            Me.LnForumsLink.Visible = True
            Me.LnForumsLink.NavigateUrl = Config.NrcPickerUrl & forumUrl
        End If
        If archiveUrl = "" Then
            Me.LnArchiveLink.Visible = False
        Else
            Me.LnArchiveLink.Visible = True
            Me.LnArchiveLink.NavigateUrl = Config.NrcPickerUrl & archiveUrl
        End If
        If movieAlias = "" Then
            Me.PatientEyesLink.Visible = False
        Else
            movieUrl = movieBaseUrl & movieAlias
            Me.PatientEyesLink.Visible = True
            Dim javaScript As String = "javascript: void OpenWindow('" & movieUrl & "', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=780,height=700,resizable=1')"
            Me.PatientEyesLink.NavigateUrl = javaScript
        End If

    End Sub

    Private ReadOnly Property DateRangeString() As String
        Get
            Dim preference As MemberGroupReportPreference = SessionInfo.EToolKitServer.MemberGroupPreference
            Return String.Format("{0} {1} - {2} {3}", MonthName(preference.ReportStartMonth), preference.ReportStartYear, MonthName(preference.ReportEndMonth), preference.ReportEndYear)
        End Get
    End Property

    Private Function MonthName(ByVal monthNumber As Integer) As String
        Select Case monthNumber
            Case 1
                Return "Jan"
            Case 2
                Return "Feb"
            Case 3
                Return "Mar"
            Case 4
                Return "Apr"
            Case 5
                Return "May"
            Case 6
                Return "Jun"
            Case 7
                Return "Jul"
            Case 8
                Return "Aug"
            Case 9
                Return "Sep"
            Case 10
                Return "Oct"
            Case 11
                Return "Nov"
            Case 12
                Return "Dec"
            Case Else
                Return ""
        End Select
    End Function

    Private Function LoadModelNav() As String
        Dim sbHTML As New StringBuilder
        Dim tkServer As ToolkitServer = SessionInfo.EToolKitServer

        'Determine what page we are on...
        Dim strURL As String = Request.Url.AbsoluteUri.ToString
        Dim astrURL() As String = Split(strURL, "/")
        Dim strThisPageTemp As String = astrURL(UBound(astrURL))
        Dim astrThisPage() As String = Split(strThisPageTemp, ".")
        Dim strThisPage As String = astrThisPage(0)

        With sbHTML
            Dim unitNodeType As NodeType = NodeType.Node
            Dim viewNodeType As NodeType = NodeType.Node
            Dim dimensionNodeType As NodeType = NodeType.Node

            If Me.ShowDimensionSelection Then
                dimensionNodeType = NodeType.Elbow
            ElseIf Me.ShowViewSelection Then
                viewNodeType = NodeType.Elbow
            Else
                unitNodeType = NodeType.Elbow
            End If


            'Start the node table...
            .Append("<TABLE border=""0"" cellPadding=""0"" cellSpacing=""0"" width=""100%"">" & vbCrLf)

            .Append(BuildNode(DateRangeString, "DataSelection.aspx", NodeType.None, True, False))
            .Append(BuildNode(tkServer.ServiceTypeName, "DataSelection.aspx", NodeType.Node, False, True))
            .Append(BuildNode(tkServer.SelectedUnitName.Replace("&nbsp;", ""), "DataSelection.aspx", unitNodeType, False, True))

            If Me.ShowViewSelection Then
                Dim viewUrl As String
                If tkServer.MemberGroupPreference.IsChooseQuestionSelected Then
                    viewUrl = "QuestionSelection.aspx"
                Else
                    viewUrl = "DataSelection.aspx"
                End If
                .Append(BuildNode(SessionInfo.SelectedViewName, viewUrl, viewNodeType, False, True))
            End If

            If Me.ShowDimensionSelection Then
                Dim dimensionUrl As String = "ThemeSelection.aspx"
                .Append(BuildNode(SessionInfo.SelectedDimensionName, dimensionUrl, NodeType.Elbow, False, True))
            End If


            'End the HTML Table...
            .Append("</TABLE>")

        End With

        'Write the StringBuilder object to the Literal...
        Return sbHTML.ToString

    End Function

    Private Function BuildNode(ByVal Label As String, ByVal Action As String, ByVal Connector As NodeType, ByVal TopNode As Boolean, ByVal NeedSpacer As Boolean, Optional ByVal Width As String = "100%") As String
        Dim sbHTML As New StringBuilder

        With sbHTML
            If NeedSpacer Then
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD colSpan=""2"">")
                .Append(DrawNavNodeConnector(12, NodeType.Spacer))
                .Append("</TD></TR>" & vbCrLf)
            End If

            .Append(vbTab & "<TR>" & vbCrLf)
            If Not (TopNode) Then
                .Append(vbTab & vbTab & "<TD>" & vbCrLf)
                .Append(vbTab & vbTab & DrawNavNodeConnector(Label.ToString.Length, Connector) & "</TD>" & vbCrLf)
            End If

            If TopNode Then
                .Append(vbTab & vbTab & "<TD colSpan=""2"" width=""100%"">" & vbCrLf)

                'Start the drop shadow...
                .Append("<TABLE cellSpacing=""0"" cellPadding=""0"" bgColor=""#7c7c7c"" border=""0"">" & vbCrLf)
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD vAlign=""top"">" & vbCrLf)

                'Start actual node - outline...
                .Append("<TABLE border=""0"" cellPadding=""1"" cellSpacing=""0"" bgcolor=""#cccccc"">" & vbCrLf)
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD vAlign=""top"">" & vbCrLf)

                'Inner box...
                .Append("<TABLE border=""0"" cellPadding=""1"" cellSpacing=""2"" bgcolor=""#f1f2f3"">" & vbCrLf)

            Else
                .Append(vbTab & vbTab & "<TD width=""100%"">" & vbCrLf)

                'Start the drop shadow...
                .Append("<TABLE cellSpacing=""0"" cellPadding=""0"" width=""100%"" bgColor=""#7c7c7c"" border=""0"">" & vbCrLf)
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD vAlign=""top"" width=""100%"">" & vbCrLf)

                'Start actual node - outline...
                .Append("<TABLE border=""0"" cellPadding=""1"" cellSpacing=""0"" width=""100%"" bgcolor=""#cccccc"">" & vbCrLf)
                .Append(vbTab & "<TR>" & vbCrLf)
                .Append(vbTab & vbTab & "<TD vAlign=""top"">" & vbCrLf)

                'Inner box...
                .Append("<TABLE border=""0"" cellPadding=""1"" cellSpacing=""2"" width=""100%"" bgcolor=""#f1f2f3"">" & vbCrLf)
            End If

            .Append(vbTab & "<TR>" & vbCrLf)

            .Append(vbTab & vbTab & "<TD class=""SelectionTreeItem"" OnMouseOver=""this.className='SelectionTreeItemHover';"" OnMouseOut=""this.className='SelectionTreeItem';"" width=""100%"" onClick=""document.location.href='" & Action & "'"" style=""cursor: hand;"">" & vbCrLf)
            .Append("<FONT face=""Verdana, Arial, Helvetica"" size=""1"">" & Label & "</FONT>" & vbCrLf)
            .Append(vbTab & vbTab & "</TD></TR></TABLE></TD></TR></TABLE>" & vbCrLf)

            'End Drop Shadow...
            .Append(vbTab & vbTab & "</TD>" & vbCrLf)
            .Append(vbTab & vbTab & "<TD vAlign=""top"" bgcolor=""#7c7c7c""><IMG src=""img/ghost_lav.gif"" width=""1"" height=""3""></TD>" & vbCrLf)
            .Append(vbTab & "</TR>" & vbCrLf)
            .Append(vbTab & "<TR>" & vbCrLf)
            .Append(vbTab & vbTab & "<TD colSpan=""2"" bgcolor=""#7c7c7c""><IMG src=""img/ghost_solid.gif"" width=""3"" height=""1""></TD>" & vbCrLf)
            .Append(vbTab & "</TR>" & vbCrLf)
            .Append("</TABLE>" & vbCrLf)

            .Append("</TD></TR>" & vbCrLf)
        End With

        Return sbHTML.ToString

    End Function

#Region " Draw the Connector "
    Private Enum NodeType
        None = -1
        Node = 0
        Elbow = 1
        Spacer = 3
    End Enum
    Private Function DrawNavNodeConnector(ByVal NodeSize As Integer, ByVal NodeType As NodeType) As String
        'Dimension the node objects...
        Dim intWidth As Integer = 13
        Dim intHeight As Integer = 30

        If NodeSize > 14 Then
            intHeight = 46
        End If

        If NodeSize > 23 Then
            intHeight = 62
        End If

        If NodeType = NodeType.Spacer Then
            intHeight = 4
        End If

        Dim b As Bitmap
        b = New Bitmap(intWidth, intHeight)

        Dim g As Graphics = Graphics.FromImage(b)
        Dim c As Color
        Dim objBrush As SolidBrush
        Dim objRect As Rectangle

        'Draw the background of the image...
        c = Color.White
        objBrush = New SolidBrush(c)
        objRect = New Rectangle(0, 0, intWidth, intHeight)

        g.FillRectangle(objBrush, objRect)

        'Draw the connector line...
        Dim p As Pen
        Dim pStart As Point
        Dim pEnd As Point

        Select Case NodeType
            Case NodeType.Node
                'First the Shadow...
                c = Color.FromArgb(214, 214, 214)
                p = New Pen(c, 1)

                pStart = New Point(6, 0)
                pEnd = New Point(6, intHeight)
                g.DrawLine(p, pStart, pEnd)

                pStart = New Point(6, (intHeight \ 2) + 1)
                pEnd = New Point(intWidth, (intHeight \ 2) + 1)
                g.DrawLine(p, pStart, pEnd)

                'Actual Connector Line...
                c = Color.FromArgb(124, 124, 124)
                p = New Pen(c, 1)

                pStart = New Point(5, 0)
                pEnd = New Point(5, intHeight)
                g.DrawLine(p, pStart, pEnd)

                pStart = New Point(5, (intHeight \ 2))
                pEnd = New Point(intWidth, (intHeight \ 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeType.Elbow
                'First the Shadow...
                c = Color.FromArgb(214, 214, 214)
                p = New Pen(c, 1)

                pStart = New Point(6, 0)
                pEnd = New Point(6, (intHeight \ 2) + 1)
                g.DrawLine(p, pStart, pEnd)

                pStart = New Point(6, (intHeight \ 2) + 1)
                pEnd = New Point(intWidth, (intHeight \ 2) + 1)
                g.DrawLine(p, pStart, pEnd)

                'Actual Connector Line...
                c = Color.FromArgb(124, 124, 124)
                p = New Pen(c, 1)

                pStart = New Point(5, 0)
                pEnd = New Point(5, (intHeight \ 2))
                g.DrawLine(p, pStart, pEnd)

                pStart = New Point(5, (intHeight \ 2))
                pEnd = New Point(intWidth, (intHeight \ 2))
                g.DrawLine(p, pStart, pEnd)
            Case NodeType.Spacer
                'First the Shadow...
                c = Color.FromArgb(214, 214, 214)
                p = New Pen(c, 1)

                pStart = New Point(6, 0)
                pEnd = New Point(6, intHeight)
                g.DrawLine(p, pStart, pEnd)

                'Actual Connector Line...
                c = Color.FromArgb(124, 124, 124)
                p = New Pen(c, 1)

                pStart = New Point(5, 0)
                pEnd = New Point(5, intHeight)
                g.DrawLine(p, pStart, pEnd)
        End Select

        'Save the new image...

        Dim strFileName As String = Guid.NewGuid.ToString.Replace("-", "")
        Dim strFilePath As String = Request.PhysicalApplicationPath.ToString & "eToolKit\temp_img\" & strFileName & ".png"
        b.Save(strFilePath, ImageFormat.Png)

        'Clean up...
        g.Dispose()
        b.Dispose()

        Dim strImage As String = "<IMG alt="""" border=""0"" src=""temp_img/" & strFileName & ".png"" height=""" & intHeight & """ width=""" & intWidth & """>"

        'Return the HTML to display the image...
        Return strImage

    End Function

#End Region

#Region " Action Plan "

    Private Sub LoadFolder(ByVal docNode As DocumentNode, ByVal nodes As TreeNodeCollection)
        Dim treeNode As New TreeNode

        'Set the properties for this folder node
        treeNode.Text = docNode.Name
        treeNode.ToolTip = docNode.Name
        treeNode.SelectAction = TreeNodeSelectAction.None
        If (docNode.Expanded) Then treeNode.Expand()

        'Load up each of the documents in this folder
        For Each doc As Document In docNode.Documents
            LoadDocument(treeNode, doc)
        Next

        'Now recursively load up each sub folder
        For Each childNode As DocumentNode In docNode.Nodes
            LoadFolder(childNode, treeNode.ChildNodes)
        Next

        'Add this node to the parent node collection
        nodes.Add(treeNode)

    End Sub

    Private Sub LoadDocument(ByVal folderNode As TreeNode, ByVal doc As Document)
        Dim treeNode As New TreeNode

        'Set the properties for this document node
        treeNode.Text = doc.Name
        treeNode.ToolTip = doc.Name
        treeNode.NavigateUrl = "~/Shared/DownloadDocument.aspx?id=" & doc.DocumentNodeId
        treeNode.Target = "_Blank"

        'Add document to the parent node collection
        folderNode.ChildNodes.Add(treeNode)

    End Sub

#End Region

    Protected Function NormalizeSpace(ByVal input As Object) As String
        Static pattern As New System.Text.RegularExpressions.Regex("\s+", RegexOptions.Compiled)
        Return pattern.Replace(DirectCast(input, String), " ").Trim()
    End Function

End Class