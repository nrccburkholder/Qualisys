Imports Nrc.QualiSys.Library


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
        mUniqueSiteGroupId = Convert.ToInt32(ds.Tables(0).Compute("max(SiteGroup_id)", String.Empty))

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

        Dim dTable As New DataTable
        dTable = CType(SiteGroupBindingSource.DataSource, DataTable)

        Dim dtChanges As DataTable = dTable.GetChanges()

        If Not dtChanges Is Nothing Then

            For Each dr As DataRow In dtChanges.Rows

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
                                        .GroupOwnerShip = dr("GroupOwnership").ToString(),
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

            Next

        End If


        For Each relation As DataRelation In dTable.ChildRelations

            Dim childTable As DataTable = relation.ChildTable

            If Not childTable.GetChanges Is Nothing Then

                For Each drow As DataRow In childTable.GetChanges.Rows

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
                                                .bitActive = If(IsDBNull(drow("bitActive")), True, CBool(drow("bitActive")))}

                    If (practiceSite.PracticeSite_ID > 0) Then
                        SiteGroup.UpdatePracticeSite(practiceSite)
                    Else
                        SiteGroup.InsertPracticeSite(practiceSite)
                    End If

                Next

            End If

        Next

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

    Private Sub InitializeNewPracticeSiteRecord(ByVal rowHandle As Integer)

        ' The SiteGroup_id needs to be unique in the grid.  However, the assigned ID is just temporary for this session.  It will not be the value assigned in the database.
        gvPracticeSites.SetRowCellValue(rowHandle, gvPracticeSites.Columns("SiteGroup_ID"), UniqueSiteGroupId)
        gvPracticeSites.SetRowCellValue(rowHandle, gvPracticeSites.Columns("bitActive"), 1)
        gvPracticeSites.SetRowCellValue(rowHandle, gvPracticeSites.Columns("RecordState"), 1)


    End Sub

#End Region

#Region "public methods"

    Public Sub SetViewMode(ByVal viewMode As FacilityAdminSection.DataViewMode)

        PopulateSiteGroupList()

    End Sub

#End Region

#Region "Events"

    Private Sub gvPracticeSites_InitNewRow(sender As System.Object, e As DevExpress.XtraGrid.Views.Grid.InitNewRowEventArgs) Handles gvPracticeSites.InitNewRow
        InitializeNewPracticeSiteRecord(e.RowHandle)
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



#End Region

    Private Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        PopulateSiteGroupList()

    End Sub
End Class

