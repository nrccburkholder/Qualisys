Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_DataSelection
    Inherits ToolKitPage

    Private Shared ReadOnly mMonthList As String() = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
    Protected Overrides ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return True
        End Get
    End Property


    Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        Me.InitializeServiceTypes()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.InitializeDates()
            Me.InitializeUnitSelection()
            Me.InitializeSelectedUnit()
            Me.InitializeViewSelections()
            NextButton.Attributes.Add("OnClick", "ShowLoadingMessage(false);")
        End If
    End Sub

#Region " Initialize Dates "
    Private Sub InitializeDates()
        Me.PopulateMonths()
        Me.PopulateYears()

        'Set select start date
        StartMonth.SelectedValue = MemberGroupPreference.ReportStartMonth.ToString
        StartYear.SelectedValue = MemberGroupPreference.ReportStartYear.ToString

        'Set select end date
        EndMonth.SelectedValue = MemberGroupPreference.ReportEndMonth.ToString
        EndYear.SelectedValue = MemberGroupPreference.ReportEndYear.ToString

    End Sub

    Private Sub PopulateMonths()
        Dim itemSelected As Boolean = False
        Dim i As Integer = 1

        StartMonth.Items.Clear()
        EndMonth.Items.Clear()
        For Each month As String In mMonthList
            StartMonth.Items.Add(New ListItem(month, i.ToString))
            EndMonth.Items.Add(New ListItem(month, i.ToString))
            i += 1
        Next
    End Sub

    Private Sub PopulateYears()
        Dim thisYear As Integer = Date.Today.Year
        Dim yearsToShow As Integer = 3 'Number of years to display
        Dim itemSelected As Boolean = False
        Dim i As Integer

        StartYear.Items.Clear()
        EndYear.Items.Clear()
        For i = 0 To yearsToShow - 1
            Dim year As Integer = thisYear - i
            StartYear.Items.Add(New ListItem(year.ToString, year.ToString))
            EndYear.Items.Add(New ListItem(year.ToString, year.ToString))
        Next
    End Sub

#End Region

#Region " Initialize Service Types"
    Private Sub InitializeServiceTypes()
        Dim tblServiceTypes As DataTable = Me.ToolKitServer.ServiceTypes.Tables(0)
        Dim row As DataRow
        Dim rb As RadioButton
        Dim lit As Literal
        Dim buttonSelected As Boolean = False
        Dim hasData As Boolean = False
        Dim hasAccess As Boolean = False

        ''Get the service type id

        For Each row In tblServiceTypes.Rows
            rb = New RadioButton
            rb.GroupName = "ServiceTypes"
            rb.Text = row("strTKDimension_Nm").ToString
            rb.ID = "ServiceType" & row("TKDimension_ID").ToString
            rb.AutoPostBack = True
            rb.Attributes.Add("OnClick", "ShowLoadingMessage(true);")

            'Check to see if the client has questions for this service type
            hasData = CType(row("bitHasQuestions"), Boolean)
            'They only have access if it has questions
            rb.Enabled = hasData

            'Auto-select the first one they have access to
            If Not buttonSelected AndAlso hasData Then
                If MemberGroupPreference.ServiceTypeId = 0 Then
                    rb.Checked = True
                    MemberGroupPreference.ServiceTypeId = CInt(row("TKDimension_ID"))
                    buttonSelected = True
                ElseIf MemberGroupPreference.ServiceTypeId = CInt(row("TKDimension_ID")) Then
                    rb.Checked = True
                    buttonSelected = True
                End If
            End If

            AddHandler rb.CheckedChanged, AddressOf ServiceType_CheckedChanged
            lit = New Literal
            lit.Text = "<BR />"
            ServiceTypesPlaceHolder.Controls.Add(rb)
            ServiceTypesPlaceHolder.Controls.Add(lit)
        Next
        If Not buttonSelected Then
            MemberGroupPreference.ServiceTypeId = -1
            MemberGroupPreference.SelectedUnit = ""
            MemberGroupPreference.SelectedViewId = 0
        End If
    End Sub
#End Region

#Region " Initialize Unit Selection "

    Private Sub InitializeUnitSelection()
        Me.UnitTree.Attributes.Add("OnClick", "UnitSelection_OnClick(this, event);")
        Dim rootNodes As List(Of SampleUnitTreeNode) = ToolKitServer.GetUnitTree

        Me.UnitTree.Nodes.Clear()
        For Each node As SampleUnitTreeNode In rootNodes
            Dim clientNode As New TreeNode(node.Name, node.Id.ToString)
            clientNode.PopulateOnDemand = True
            clientNode.SelectAction = TreeNodeSelectAction.None
            clientNode.Expand()
            Me.UnitTree.Nodes.Add(clientNode)
        Next
    End Sub

    Private Sub InitializeSelectedUnit()
        SessionInfo.SelectedUnitValuePath = ""

        Dim valuePath As String = SessionInfo.SelectedUnitValuePath
        Dim i As Integer = 0
        Dim j As Integer
        If String.IsNullOrEmpty(valuePath) Then
            Dim suNodes As List(Of SampleUnitTreeNode) = ToolKitServer.GetUnitTree()
            valuePath = SampleUnitTreeNode.FindNodeByUniqueId(suNodes, MemberGroupPreference.SelectedUnit)
            If valuePath Is Nothing Then
                MemberGroupPreference.SelectedUnit = ""
            Else
                valuePath = valuePath.Trim("/"c)
            End If
        End If
        If Not String.IsNullOrEmpty(valuePath) Then
            Dim values() As String = valuePath.Split(Char.Parse("/"))
            Dim searchPath As String = ""
            Dim node As TreeNode = Nothing
            For Each value As String In values
                searchPath &= value
                node = Me.UnitTree.FindNode(searchPath)
                If node IsNot Nothing Then
                    If i < (values.Length - 1) Then node.Expand()
                Else
                    Exit Sub
                End If
                searchPath &= "/"
                i += 1
            Next
            If node IsNot Nothing Then
                node.Checked = True
                node.Selected = True
            End If
        Else
            For Each node As TreeNode In Me.UnitTree.Nodes
                If node.Value = MemberGroupPreference.SelectedUnit Then
                    node.Checked = True
                    node.Selected = True
                ElseIf node.ChildNodes.Count > 0 Then
                    For j = 0 To node.ChildNodes.Count - 1
                        If node.ChildNodes.Item(j).Value = MemberGroupPreference.SelectedUnit Then
                            node.ChildNodes.Item(j).Checked = True
                            node.ChildNodes.Item(j).Selected = True
                            node.ChildNodes.Item(j).Parent.Expand()
                        End If
                    Next
                End If
            Next
        End If

    End Sub

    Private Sub PopulateUnitNode(ByVal node As TreeNode)
        Dim valuePath As String = node.ValuePath
        Dim rootNodes As List(Of SampleUnitTreeNode) = ToolKitServer.GetUnitTree
        Dim sourceNode As SampleUnitTreeNode = SampleUnitTreeNode.FindNode(rootNodes, valuePath)
        If sourceNode IsNot Nothing Then
            For Each suNode As SampleUnitTreeNode In sourceNode.Nodes
                Dim newNode As New TreeNode(suNode.Name, suNode.Id.ToString)
                node.ChildNodes.Add(newNode)

                'If this is a SampleUnit then we need to also expand all children
                If suNode.NodeType = SampleUnitTreeNodeType.Unit Then
                    PopulateUnitNode(newNode)
                    newNode.Expanded = True
                    newNode.PopulateOnDemand = False
                Else
                    'If not SampleUnit than populate children on demand if applicable
                    newNode.PopulateOnDemand = suNode.HasChildren
                End If
                newNode.SelectAction = TreeNodeSelectAction.None
            Next
        End If
    End Sub

    Private Function HasChildUnits(ByVal unitList() As Legacy.ToolkitServer.UnitStructure, ByVal parentUnitId As Integer) As Boolean
        For Each unit As Legacy.ToolkitServer.UnitStructure In unitList
            If unit.intParentUnitID = parentUnitId Then
                Return True
            End If
        Next

        Return False
    End Function
#End Region

#Region " Initialize View Selection "
    Private Sub InitializeViewSelections()
        ViewTypeList.Items.Clear()

        If MemberGroupPreference.SelectedUnit <> "" Then
            ' TODO: Decide how to properly reset the ToolKitServer's mbolDimDataLoaded variable
            ToolKitServer.Invalidate()
            ' TODO: Decide why ViewTypeList.DataBind is causing problems.
            'ViewTypeList.DataSource = ToolKitServer.GetTreeData(Me.ToolKitServer.ServiceTypeID)
            'ViewTypeList.DataBind()
            Dim treeData As DataSet = ToolKitServer.GetTreeData(MemberGroupPreference.ServiceTypeId)
            For Each row As DataRow In treeData.Tables(0).Rows
                Dim item As New ListItem(CStr(row!strDimension_nm), CStr(row!Dimension_id))
                item.Enabled = (CBool(row!bitHasChild) OrElse CBool(row!HasResults))
                ViewTypeList.Items.Add(item)
            Next
            Dim item2 As New ListItem("Choose a question", "-1")
            ViewTypeList.Items.Add(item2)
            Try
                ViewTypeList.SelectedValue = MemberGroupPreference.SelectedViewId.ToString()
            Catch ex As ArgumentOutOfRangeException
                ' Invalid selection indicates no selection...
            End Try
        Else
            ViewTypeList.DataSource = Nothing
        End If

    End Sub

#End Region

    Private Sub ServiceType_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.SaveServiceType()
        Me.InitializeUnitSelection()
        Me.InitializeViewSelections()
    End Sub

    Private Sub UnitTree_TreeNodeCheckChanged(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles UnitTree.TreeNodeCheckChanged
        SaveUnit()
        Me.SavePreferences()
        Me.InitializeViewSelections()
    End Sub

    Private Sub UnitTree_TreeNodeCollapsed(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles UnitTree.TreeNodeCollapsed
        ' TODO: Discover why the tree will not expand w/o this handler
    End Sub

    Private Sub UnitTree_TreeNodeExpanded(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles UnitTree.TreeNodeExpanded
        ' TODO: Discover why the tree will not expand w/o this handler
    End Sub

    Private Sub UnitTree_TreeNodePopulate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles UnitTree.TreeNodePopulate
        Me.PopulateUnitNode(e.Node)
    End Sub

    Protected Sub NextButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NextButton.Click
        If Page.IsValid Then
            Me.SaveDates()
            Me.SaveServiceType()
            Me.SaveUnit()
            Me.SaveViewSelection()
            Me.SavePreferences()
            If MemberGroupPreference.IsChooseQuestionSelected Then
                Response.Redirect("QuestionSelection.aspx")
            Else
                Response.Redirect("ThemeSelection.aspx")
            End If
            'Response.Redirect("ViewSelection.aspx")
        End If
    End Sub

    Private Sub SaveDates()
        'Save selected dates
        MemberGroupPreference.ReportStartDate = New DateTime(CInt(StartYear.SelectedItem.Value), CInt(StartMonth.SelectedItem.Value), 1)
        MemberGroupPreference.ReportEndDate = New DateTime(CInt(EndYear.SelectedItem.Value), CInt(EndMonth.SelectedItem.Value), 1)
    End Sub

    Private Sub SaveServiceType()
        'Save selected service type
        For Each ctrl As Control In Me.ServiceTypesPlaceHolder.Controls
            Dim rb As RadioButton = TryCast(ctrl, RadioButton)
            If rb IsNot Nothing AndAlso rb.Checked Then
                MemberGroupPreference.ServiceTypeId = CInt(rb.ID.Replace("ServiceType", ""))
                MemberGroupPreference.SelectedUnit = ""
                SessionInfo.SelectedUnitValuePath = ""
                Exit For
            End If
        Next
        MemberGroupPreference.SelectedViewId = 0
    End Sub

    Private Sub SaveUnit()
        'Save selected sample unit
        MemberGroupPreference.SelectedUnit = ""
        SessionInfo.SelectedUnitValuePath = ""

        Dim checkedNodes As TreeNodeCollection = Me.UnitTree.CheckedNodes
        If checkedNodes.Count = 1 Then
            Dim checkedNode As TreeNode = checkedNodes(0)
            Dim suNodes As List(Of SampleUnitTreeNode) = ToolKitServer.GetUnitTree
            Dim suNode As SampleUnitTreeNode = SampleUnitTreeNode.FindNode(suNodes, checkedNode.ValuePath)
            If suNode IsNot Nothing Then
                MemberGroupPreference.SelectedUnit = suNode.UniqueId
                SessionInfo.SelectedUnitValuePath = checkedNode.ValuePath
                MemberGroupPreference.SelectedViewId = 0
            End If
        End If

    End Sub

    Private Sub SaveViewSelection()
        'Save selected View type
        MemberGroupPreference.SelectedViewId = CInt(Me.ViewTypeList.SelectedItem.Value)
        SessionInfo.SelectedViewName = Me.ViewTypeList.SelectedItem.Text
    End Sub

    Protected Sub TreeSelectionValidator_ServerValidate(ByVal source As System.Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles TreeSelectionValidator.ServerValidate
        args.IsValid = (UnitTree.CheckedNodes.Count = 1)
    End Sub

    Private Sub ViewSelectionValidator_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles ViewSelectionValidator.ServerValidate
        args.IsValid = (ViewTypeList.SelectedIndex <> -1)
    End Sub

End Class

