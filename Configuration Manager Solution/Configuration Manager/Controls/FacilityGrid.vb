Imports Nrc.Qualisys.Library
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Columns

Public Class FacilityGrid

#Region "Private Fields"

    Private mShowIdentifierColumnsOnly As Boolean
    Private mVisibleIndexes As Dictionary(Of GridColumn, Integer)

#End Region

#Region "Public Properties"

    Public Property ShowIdentifierColumnsOnly() As Boolean
        Get
            Return Me.mShowIdentifierColumnsOnly
        End Get
        Set(ByVal value As Boolean)
            If value <> Me.mShowIdentifierColumnsOnly Then
                mShowIdentifierColumnsOnly = value
                Me.SuspendLayout()
                If value = True Then
                    'Set all to Invisible and then set specific ones to visible
                    Me.colFacilityName.Visible = True
                    Me.colFacilityMedicareNumber.Visible = True
                    Me.colPENumber.Visible = False  ' marked as not visible as per Dana S29 US6 07/13/2015
                    Me.colCity.Visible = True
                    Me.colState.Visible = True
                    Me.colRegionId.Visible = False
                    Me.colCountry.Visible = False
                    Me.colAhaId.Visible = False
                    Me.colAdmitNumber.Visible = False
                    Me.colBedSize.Visible = False
                    Me.colIsCancerCenter.Visible = False
                    Me.colIsForProfit.Visible = False
                    Me.colIsFreeStanding.Visible = False
                    Me.colIsGovernment.Visible = False
                    Me.colIsPediatric.Visible = False
                    Me.colIsPicker.Visible = False
                    Me.colIsRehab.Visible = False
                    Me.colIsReligious.Visible = False
                    Me.colIsRural.Visible = False
                    Me.colIsTrauma.Visible = False
                    Me.colIsTeaching.Visible = False
                Else
                    Me.colFacilityName.Visible = True
                    Me.colFacilityMedicareNumber.Visible = True
                    Me.colPENumber.Visible = False  ' marked as not visible as per Dana S29 US6 07/13/2015
                    Me.colCity.Visible = True
                    Me.colState.Visible = True
                    Me.colRegionId.Visible = True
                    Me.colCountry.Visible = True
                    Me.colAhaId.Visible = True
                    Me.colAdmitNumber.Visible = True
                    Me.colBedSize.Visible = True
                    Me.colIsCancerCenter.Visible = True
                    Me.colIsForProfit.Visible = True
                    Me.colIsFreeStanding.Visible = True
                    Me.colIsGovernment.Visible = True
                    Me.colIsPediatric.Visible = True
                    Me.colIsPicker.Visible = True
                    Me.colIsRehab.Visible = True
                    Me.colIsReligious.Visible = True
                    Me.colIsRural.Visible = True
                    Me.colIsTrauma.Visible = True
                    Me.colIsTeaching.Visible = True
                    Me.colFacilityName.VisibleIndex = 0
                    Me.colFacilityMedicareNumber.VisibleIndex = 1
                    Me.colPENumber.VisibleIndex = 2
                    Me.colCity.VisibleIndex = 3
                    Me.colState.VisibleIndex = 4
                    Me.colRegionId.VisibleIndex = 5
                    Me.colCountry.VisibleIndex = 6
                    Me.colAhaId.VisibleIndex = 7
                    Me.colAdmitNumber.VisibleIndex = 8
                    Me.colBedSize.VisibleIndex = 9
                    Me.colIsCancerCenter.VisibleIndex = 10
                    Me.colIsForProfit.VisibleIndex = 11
                    Me.colIsFreeStanding.VisibleIndex = 12
                    Me.colIsGovernment.VisibleIndex = 13
                    Me.colIsPediatric.VisibleIndex = 14
                    Me.colIsPicker.VisibleIndex = 15
                    Me.colIsRehab.VisibleIndex = 16
                    Me.colIsReligious.VisibleIndex = 17
                    Me.colIsRural.VisibleIndex = 18
                    Me.colIsTrauma.VisibleIndex = 19
                    Me.colIsTeaching.VisibleIndex = 20
                End If
                Me.ResumeLayout()
            End If
        End Set
    End Property

#End Region

#Region "Public Methods"

    Public Sub PopulateFacilityGrid(ByVal facilityList As FacilityList, ByVal medicareList As MedicareNumberList)

        'Populate Medicare Lookup
        medicareList.AllowNew = True
        MedicareNumberBindingSource.DataSource = medicareList

        'Populate State Lookup
        Me.FacilityStateBindingSource.DataSource = FacilityState.getAll

        'Populate TriStateLookupEdit values
        Me.TriStateComboBoxEdit.Items.Clear()
        For Each value As String In System.Enum.GetNames(GetType(Facility.ClassificationStatus))
            Me.TriStateComboBoxEdit.Items.Add(value)
        Next

        'Populate the Region Lookup
        Me.FacilityRegionBindingSource.DataSource = FacilityRegion.GetAll

        'Set Binding source to List
        FacilityBindingSource.DataSource = facilityList

    End Sub

    Public Sub RefreshMedicareBindings(ByVal medicareList As MedicareNumberList)

        'Populate Medicare Lookup
        medicareList.AllowNew = True
        MedicareNumberBindingSource.DataSource = medicareList

    End Sub

    ''' <summary>
    ''' Returns a count of the number of deleted rows
    ''' </summary>
    ''' <remarks></remarks>
    Public Function DeleteSelectedRows() As Integer

        Dim deletedRows As Integer = 0
        Dim selectedRows() As Integer = Me.FacilityGridView.GetSelectedRows
        'Reverse the items so we delete in reverse order.  This avoids problems with index numbers
        'Changing each time we delete an item.
        Array.Reverse(selectedRows)

        For Each i As Integer In selectedRows
            If i >= 0 Then
                Dim fac As Facility = DirectCast(FacilityGridView.GetRow(i), Facility)
                If fac IsNot Nothing Then
                    If CanAllFacilityGridDeleteRow(fac) Then
                        FacilityGridView.DeleteRow(i)
                        deletedRows += 1
                    End If
                End If
            End If
        Next

        Return deletedRows

    End Function


    ''' <summary>
    ''' Sets DataSources to nothing
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub ClearDataSources()

        Me.FacilityBindingSource.DataSource = Nothing
        Me.MedicareNumberBindingSource.DataSource = Nothing
        Me.FacilityRegionBindingSource.DataSource = Nothing
        Me.FacilityStateBindingSource.DataSource = Nothing

    End Sub

#End Region

#Region "Private Methods"

    Private Function CanAllFacilityGridDeleteRow(ByVal fac As Facility) As Boolean

        Dim retValue As Boolean = False

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor

        'If the facility being deleted is not a "New" facility then we need to store
        'it in our list of deleted facilities
        If fac IsNot Nothing Then
            If fac.IsNew Then
                'Set the return value
                retValue = True
            Else
                'Verify that this facility can be deleted
                If fac.AllowDelete Then
                    'Set the return value
                    retValue = True
                Else
                    'If it can't be deleted then display an error and cancel delete
                    MessageBox.Show("This facility cannot be deleted because it is still associated with sample units!", "Facility Delete Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If
            End If
        End If

        'Reset the wait cursor
        Me.Cursor = Me.DefaultCursor

        'Return
        Return retValue

    End Function

#End Region

#Region "Private Event Handlers"

    Private Sub MedicareNumberGridLookUpEdit_ButtonClick(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ButtonPressedEventArgs) Handles MedicareNumberGridLookUpEdit.ButtonClick

        If e.Button.Kind = DevExpress.XtraEditors.Controls.ButtonPredefines.Delete AndAlso Me.FacilityGridView.FocusedColumn.Equals(Me.colFacilityMedicareNumber) Then
            Me.FacilityGridView.SetFocusedValue(Nothing)
        End If

    End Sub

    Private Sub MedicareNumberGridLookUpEdit_Closed(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ClosedEventArgs) Handles MedicareNumberGridLookUpEdit.Closed

        'Using send keys to get a quick refresh of the PENumber column
        SendKeys.Send("{TAB}")
        SendKeys.Send("+{TAB}")

    End Sub
#End Region

End Class
