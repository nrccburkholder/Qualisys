Imports Nrc.Qualisys.Library
Imports DevExpress.Data.Filtering


Public Class FacilityGroupSiteMappingSection

#Region " Private Members "

    Private mViewMode As FacilityAdminSection.DataViewMode
    Private mIsGridPopulated As Boolean
    Private mUniqueSiteGroupId As Integer

#End Region

#Region "Public Properties"
    Public ReadOnly Property UniqueSiteGroupId As Integer
        Get
            Return mUniqueSiteGroupId
        End Get
    End Property
#End Region

#Region "constructors"
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

    End Sub
#End Region

#Region "private methods"

    Private Sub PopulateSiteGroupList()

        Dim ds As DataSet

        ds = SiteGroup.GetAllSiteGroups()

        SiteGroupBindingSource.DataSource = ds.Tables(0)

        ' initialize
        If (ds.Tables(0).Rows.Count > 0) Then
            mUniqueSiteGroupId = Convert.ToInt32(ds.Tables(0).Compute("max(SiteGroup_id)", String.Empty))
        Else
            mUniqueSiteGroupId = 0
        End If

        gvSiteGroups.SetRowCellValue(GridControlEx.AutoFilterRowHandle, gvSiteGroups.Columns("bitActive"), True)
        gvPracticeSites.SetRowCellValue(GridControlEx.AutoFilterRowHandle, gvSiteGroups.Columns("bitActive"), True)
    End Sub


    Private Sub SaveChanges()

        'Commit any uncommitted changes
        If gvSiteGroups.IsEditing Then
            If gvSiteGroups.ValidateEditor Then
                gvSiteGroups.CloseEditor()
            End If
        End If

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        Dim siteGroupIDsNotDeleted As String = String.Empty
        Dim practiceSiteIDsNotDeleted As String = String.Empty

        Dim dTable As New DataTable
        dTable = CType(SiteGroupBindingSource.DataSource, DataTable)

        Dim dtChanges As DataTable = dTable.GetChanges()

        If Not dtChanges Is Nothing Then

            For Each dr As DataRow In dtChanges.Rows

                If (dr.RowState <> DataRowState.Deleted) Then
                    Dim siteGroup As New SiteGroup With {
                                            .SiteGroup_ID = If(IsDBNull(dr("SiteGroup_ID")), .SiteGroup_ID, CInt(dr("SiteGroup_ID"))),
                                            .AssignedID = dr("AssignedID").ToString(),
                                            .GroupName = dr("GroupName").ToString(),
                                            .Addr1 = dr("Addr1").ToString(),
                                            .Addr2 = dr("Addr2").ToString(),
                                            .City = dr("City").ToString(),
                                            .ST = dr("ST").ToString(),
                                            .Zip5 = dr("Zip5").ToString(),
                                            .Phone = dr("Phone").ToString(),
                                            .GroupOwnership = dr("GroupOwnership").ToString(),
                                            .GroupContactName = dr("GroupContactName").ToString(),
                                            .GroupContactPhone = dr("GroupContactPhone").ToString(),
                                            .GroupContactEmail = dr("GroupContactEmail").ToString(),
                                            .MasterGroupID = If(IsDBNull(dr("MasterGroupID")), .MasterGroupID, CInt(dr("MasterGroupID"))),
                                            .MasterGroupName = dr("MasterGroupName").ToString(),
                                            .IsActive = If(IsDBNull(dr("bitActive")), True, CBool(dr("bitActive")))}

                    If (CInt(dr("RecordState")) = 1) Then
                        siteGroup.InsertSiteGroup(siteGroup)
                    Else
                        siteGroup.UpdateSiteGroup(siteGroup)
                    End If
                Else
                    Dim sg As New SiteGroup With {
                                            .SiteGroup_ID = CInt(dr("SiteGroup_ID", DataRowVersion.Original))}

                    If SiteGroup.AllowSiteDelete(sg) Then
                        SiteGroup.DeleteSiteGroup(sg)
                    Else
                        siteGroupIDsNotDeleted = siteGroupIDsNotDeleted + ", " + sg.SiteGroup_ID.ToString
                    End If
                End If


            Next

        End If


        For Each relation As DataRelation In dTable.ChildRelations

            Dim childTable As DataTable = relation.ChildTable

            If Not childTable.GetChanges Is Nothing Then

                For Each drow As DataRow In childTable.GetChanges.Rows
                    'If Not CBool(drow("IsDeleted")) Then
                    If (drow.RowState <> DataRowState.Deleted) Then
                        Dim practiceSite As New PracticeSite With {
                                                    .PracticeSite_ID = If(IsDBNull(drow("PracticeSite_ID")), .PracticeSite_ID, CInt(drow("PracticeSite_ID"))),
                                                    .AssignedID = drow("AssignedID").ToString(),
                                                    .SiteGroup_ID = If(IsDBNull(drow("SiteGroup_ID")), .SiteGroup_ID, CInt(drow("SiteGroup_ID"))),
                                                    .PracticeName = drow("PracticeName").ToString(),
                                                    .Addr1 = drow("Addr1").ToString(),
                                                    .Addr2 = drow("Addr2").ToString(),
                                                    .City = drow("City").ToString(),
                                                    .ST = drow("ST").ToString(),
                                                    .Zip5 = drow("Zip5").ToString(),
                                                    .Phone = drow("Phone").ToString(),
                                                    .PracticeOwnership = drow("PracticeOwnership").ToString(),
                                                    .PatVisitsWeek = If(IsDBNull(drow("PatVisitsWeek")), .PatVisitsWeek, CInt(drow("PatVisitsWeek"))),
                                                    .ProvWorkWeek = If(IsDBNull(drow("ProvWorkWeek")), .ProvWorkWeek, CInt(drow("ProvWorkWeek"))),
                                                    .PracticeContactName = drow("PracticeContactName").ToString(),
                                                    .PracticeContactPhone = drow("PracticeContactPhone").ToString(),
                                                    .PracticeContactEmail = drow("PracticeContactEmail").ToString(),
                                                    .SampleUnit_id = If(IsDBNull(drow("SampleUnit_id")), .SampleUnit_id, CInt(drow("SampleUnit_id"))),
                                                    .bitActive = If(IsDBNull(drow("bitActive")), True, CBool(drow("bitActive"))),
                                                    .CCN = drow("CCN").ToString()}

                        If (practiceSite.PracticeSite_ID > 0) Then
                            SiteGroup.UpdatePracticeSite(practiceSite)
                        Else
                            SiteGroup.InsertPracticeSite(practiceSite)
                        End If

                    Else
                        Dim practiceSite As New PracticeSite With {
                                                    .PracticeSite_ID = CInt(drow("PracticeSite_ID", DataRowVersion.Original))}

                        If SiteGroup.AllowSiteDelete(practiceSite) Then
                            SiteGroup.DeletePracticeSite(practiceSite)
                        Else
                            practiceSiteIDsNotDeleted = practiceSiteIDsNotDeleted + ", " + practiceSite.PracticeSite_ID.ToString
                        End If
                    End If

                Next

            End If

        Next

        If siteGroupIDsNotDeleted.Length > 0 Then
            MessageBox.Show("The following Site Group IDs could not be deleted because they included Practice Sites which were mapped:" + siteGroupIDsNotDeleted.Remove(0, 1))
        End If

        If practiceSiteIDsNotDeleted.Length > 0 Then
            MessageBox.Show("The following Practice Site IDs could not be deleted because they were mapped:" + practiceSiteIDsNotDeleted.Remove(0, 1))
        End If

        PopulateSiteGroupList()

        'Reset the wait cursor
        Me.Cursor = Me.DefaultCursor

    End Sub


    Private Sub SetNextUniqueSiteGroupId()

        mUniqueSiteGroupId = mUniqueSiteGroupId + 1

    End Sub

    Private Sub InitializeNewSiteGroupRecord(ByVal rowHandle As Integer)

        SetNextUniqueSiteGroupId()

        ' The SiteGroup_id needs to be unique in the grid.  However, the assigned ID is just temporary for this session.  It will not be the value assigned in the database.
        gvSiteGroups.SetRowCellValue(rowHandle, gvSiteGroups.Columns("SiteGroup_ID"), UniqueSiteGroupId)
        gvSiteGroups.SetRowCellValue(rowHandle, gvSiteGroups.Columns("bitActive"), 1)
        gvSiteGroups.SetRowCellValue(rowHandle, gvSiteGroups.Columns("RecordState"), 1)


    End Sub

    Private Sub InitializeNewPracticeSiteRecord(ByVal view As DevExpress.XtraGrid.Views.Grid.GridView, ByVal rowHandle As Integer)

        ' The SiteGroup_id needs to be unique in the grid.  However, the assigned ID is just temporary for this session.  It will not be the value assigned in the database.
        view.SetRowCellValue(rowHandle, gvPracticeSites.Columns("SiteGroup_ID"), UniqueSiteGroupId)
        view.SetRowCellValue(rowHandle, gvPracticeSites.Columns("bitActive"), 1)
        view.SetRowCellValue(rowHandle, gvPracticeSites.Columns("RecordState"), 1)


    End Sub

#End Region

#Region "public methods"

    Public Sub SetViewMode(ByVal viewMode As FacilityAdminSection.DataViewMode)

        PopulateSiteGroupList()

    End Sub

#End Region

#Region "Events"

    Private Sub gvPracticeSites_InitNewRow(sender As System.Object, e As DevExpress.XtraGrid.Views.Grid.InitNewRowEventArgs) Handles gvPracticeSites.InitNewRow
        Dim view As DevExpress.XtraGrid.Views.Grid.GridView = TryCast(sender, DevExpress.XtraGrid.Views.Grid.GridView)

        InitializeNewPracticeSiteRecord(view, e.RowHandle)
    End Sub

    Private Sub gvSiteGroups_MasterRowExpanding(sender As System.Object, e As DevExpress.XtraGrid.Views.Grid.MasterRowCanExpandEventArgs) Handles gvSiteGroups.MasterRowExpanding

        Dim isNewRecord As Boolean = Convert.ToBoolean(gvSiteGroups.GetRowCellValue(e.RowHandle, "RecordState"))

        If Not isNewRecord Then
            e.Allow = True
        Else
            MessageBox.Show("You must save the new Site Group before adding Practice Sites")
            e.Allow = False
        End If


    End Sub

    Private Sub ApplyButton_Click(sender As System.Object, e As System.EventArgs) Handles ApplyButton.Click

        ' Save all changes made to the grid
        SaveChanges()

    End Sub

    Private Sub gvSiteGroups_InitNewRow(sender As System.Object, e As DevExpress.XtraGrid.Views.Grid.InitNewRowEventArgs) Handles gvSiteGroups.InitNewRow

        InitializeNewSiteGroupRecord(e.RowHandle)

    End Sub




    Private Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        PopulateSiteGroupList()

    End Sub

    Private Sub gvPracticeSites_ValidateRow(sender As Object, e As DevExpress.XtraGrid.Views.Base.ValidateRowEventArgs) Handles gvPracticeSites.ValidateRow

        ' Create a dictionary of the columns that will require values.  The Key will be the grid's fieldName, the Value will be the column's display name.
        Dim columns As New Dictionary(Of String, String)

        columns.Add("ST", "State")
        columns.Add("PracticeContactEmail", "Contact Email")

        ValidateColumnRequired(sender, e, columns)

    End Sub


    Private Sub gvSiteGroups_ValidateRow(sender As Object, e As DevExpress.XtraGrid.Views.Base.ValidateRowEventArgs) Handles gvSiteGroups.ValidateRow

        ' Create a dictionary of the columns that will require values.  The Key will be the grid's fieldName, the Value will be the column's display name.
        Dim columns As New Dictionary(Of String, String)

        columns.Add("ST", "State")

        ValidateColumnRequired(sender, e, columns)

    End Sub

#End Region

    Private Sub ValidateColumnRequired(sender As Object, e As DevExpress.XtraGrid.Views.Base.ValidateRowEventArgs, ByVal columns As Dictionary(Of String, String))

        Dim view As DevExpress.XtraGrid.Views.Grid.GridView = TryCast(sender, DevExpress.XtraGrid.Views.Grid.GridView)

        For Each item As KeyValuePair(Of String, String) In columns
            Dim col As DevExpress.XtraGrid.Columns.GridColumn = view.Columns(item.Key)

            Dim value As String = view.GetRowCellValue(e.RowHandle, col).ToString()

            If String.IsNullOrEmpty(value.ToString()) Then
                e.Valid = False
                view.SetColumnError(col, String.Format("'{0}' is required.", item.Value))
                e.ErrorText = "One or more required fields is missing!"
            End If
        Next

    End Sub

End Class

