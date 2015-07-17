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

                'TODO  

                MessageBox.Show(dr(10).ToString())

            Next

        End If


        For Each relation As DataRelation In dTable.ChildRelations

            Dim childTable As DataTable = relation.ChildTable

            If Not childTable.GetChanges Is Nothing Then

                For Each drow As DataRow In childTable.GetChanges.Rows

                    MessageBox.Show(drow("SiteGroup_ID").ToString())
                Next

            End If

        Next




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
End Class

