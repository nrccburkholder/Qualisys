Public Class ExportGroupSelectedEventArgs
    Inherits EventArgs
    Private mSelectedExportGroupID As Integer
    Private mShowSelected As Boolean
    Public ReadOnly Property ShowSelected() As Boolean
        Get
            Return mShowSelected
        End Get
    End Property
    Public ReadOnly Property SelectedExportGroupID() As Integer
        Get
            Return mSelectedExportGroupID
        End Get
    End Property

    Public Sub New(ByVal selectedExportGroupID As Integer, Optional ByVal ShowSelected As Boolean = True)
        mSelectedExportGroupID = selectedExportGroupID
        mShowSelected = ShowSelected
    End Sub


End Class
