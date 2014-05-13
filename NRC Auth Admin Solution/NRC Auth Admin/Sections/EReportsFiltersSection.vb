Imports Nrc.Datamart.MySolutions.Library
Imports Nrc.Datamart.Library
Imports System.Collections.ObjectModel

Public Class EReportsFiltersSection
    Private mSelectedStudy As Study
    Private WithEvents mClientStudyNavigator As ClientStudyNavigator
    Private WithEvents mClientStudySurveyTreeView As TreeView

#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)
        mClientStudyNavigator = TryCast(navCtrl, ClientStudyNavigator)
    End Sub

    Public Overrides Sub ActivateSection()
        MyBase.ActivateSection()
    End Sub

    Public Overrides Function AllowInactivate() As Boolean
        'Determine if anything needs to be saved
        If Me.EReportsFiltersEditor.IsDirty Then
            If Me.EReportsFiltersEditor.ColumnList.IsValid Then
                'Things have been changed and are valid so lets ask the user if they want to save
                Dim dialogResult As DialogResult = MessageBox.Show("Do you wish to save your changes?", "Save eReportsFilters Changes", MessageBoxButtons.YesNoCancel)
                If dialogResult = dialogResult.Yes Then
                    Me.EReportsFiltersEditor.Save()
                ElseIf dialogResult = Windows.Forms.DialogResult.Cancel Then
                    Return False
                End If
            Else
                'Things have changed, but they aren't valid
                Dim dialogResult As DialogResult = MessageBox.Show("You have unsaved changes.  Do you want to continue and lose all unsaved changes?", "Save eReportsFilters Changes", MessageBoxButtons.YesNo)
                If dialogResult = Windows.Forms.DialogResult.No Then
                    Return False
                End If
            End If
        End If

        Return True
    End Function

    Public Overrides Sub InactivateSection()
        MyBase.InactivateSection()
    End Sub

#End Region

#Region "properties"
    Public Property SelectedStudy() As Study
        Get
            Return mSelectedStudy
        End Get
        Set(ByVal value As Study)
            mSelectedStudy = value
        End Set
    End Property

#End Region

#Region "Event Handlers"
    Private Sub EReportsFiltersSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Enabled = False
        mClientStudySurveyTreeView = Me.mClientStudyNavigator.ClientStudyTree
    End Sub

    Private Sub mClientStudySurveyTreeView_BeforeSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles mClientStudySurveyTreeView.BeforeSelect
        'Determine if anything needs to be saved
        If Me.EReportsFiltersEditor.IsDirty Then
            If Me.EReportsFiltersEditor.ColumnList.IsValid Then
                'Things have been changed and are valid so lets ask the user if they want to save
                Dim dialogResult As DialogResult = MessageBox.Show("Do you wish to save your changes to the eReports Filters for study '" & SelectedStudy.DisplayLabel & "'?", "Save eReportsFilters Changes", MessageBoxButtons.YesNoCancel)
                If dialogResult = dialogResult.Yes Then
                    Me.EReportsFiltersEditor.Save()
                ElseIf dialogResult = Windows.Forms.DialogResult.Cancel Then
                    e.Cancel = True
                    Return
                End If
            Else
                'Things have changed, but they aren't valid
                Dim dialogResult As DialogResult = MessageBox.Show("Are you sure you want to switch studies and lose all unsaved changes?", "Save eReportsFilters Changes", MessageBoxButtons.YesNo)
                If dialogResult = Windows.Forms.DialogResult.No Then
                    e.Cancel = True
                    Return
                End If
            End If
        End If
    End Sub

    Private Sub mClientStudyNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mClientStudyNavigator.SelectionChanged
        mSelectedStudy = mClientStudyNavigator.SelectedStudy
        If mSelectedStudy Is Nothing Then
            Me.Enabled = False
            EReportsFiltersEditor.Clear()
        Else
            Me.Enabled = True
            EReportsFiltersEditor.Populate(GetUniqueStudyColumnsList, mSelectedStudy.Id)
        End If
    End Sub

#End Region

#Region "private methods"
    Private Function GetUniqueStudyColumnsList() As StudyTableColumnList
        Dim columnList As New Collection(Of StudyTableColumn)
        Dim tableCollection As Collection(Of StudyTable)
        Dim tableCount As Integer = 1
        Dim UniqueStudyTableList As New StudyTableColumnList

        If SelectedStudy IsNot Nothing Then
            tableCollection = StudyTable.GetAllStudyTables(SelectedStudy.Id)
        Else
            Return UniqueStudyTableList
        End If

        For Each stdyTable As StudyTable In tableCollection
            'Load the first table's columns without checking for Dups to optimize performance
            If tableCount = 1 Then
                For Each column As StudyTableColumn In stdyTable.Columns
                    If column.DataType = StudyTableColumn.ColumnDataType.String Then
                        columnList.Add(column)
                    End If
                Next
            Else
                'Check if a column with the same ID has already been loaded.  If not, then load
                'the column.  If the column has been loaded, but we find another instance of it that
                'has the 'AvailablefilteroneReports' property set to true, then load the new instance and
                'remove the original instance.
                For Each newColumn As StudyTableColumn In stdyTable.Columns
                    Dim ExistingColumn As StudyTableColumn = Nothing
                    Dim columnAlreadyLoaded As Boolean = False

                    'Can only use String columns as filters
                    If newColumn.DataType = StudyTableColumn.ColumnDataType.String Then
                        'Determine if column has already been loaded
                        For Each alreadyLoadedColumn As StudyTableColumn In columnList
                            If newColumn.FieldId = alreadyLoadedColumn.FieldId Then
                                columnAlreadyLoaded = True
                                ExistingColumn = alreadyLoadedColumn
                                Exit For
                            End If
                        Next

                        'Take appropriate action
                        If columnAlreadyLoaded = False Then
                            columnList.Add(newColumn)
                        ElseIf columnAlreadyLoaded = True AndAlso newColumn.IsAvailableOnEReports = True Then
                            'Replace the column already loaded with the one that has the IsAvailableOnEReports property set to true
                            columnList.Remove(ExistingColumn)
                            columnList.Add(newColumn)
                        End If
                    End If
                Next
            End If

            tableCount += 1
        Next

        For Each col As StudyTableColumn In columnList
            UniqueStudyTableList.Add(col)
        Next

        Return UniqueStudyTableList
    End Function
#End Region

End Class
