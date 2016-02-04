Imports Nrc.SurveyPoint.Library
Public Class ExportLogSectionController
    Dim mExportLogs As ExportFileLogCollection
    Dim mSelectedExportGroupID As Integer = -1 'none selected by default
    Dim mSartDate As Date = Now()
    Dim mEndDate As Date = Now()

    Public Sub New(ByVal StartDate As Date, ByVal EndDate As Date, Optional ByVal ExportGroupID As Integer = -1)
        Me.StartDate = StartDate
        Me.EndDate = EndDate
        Me.SelectedExportGroupID = ExportGroupID
        Me.GetAllLogs()
    End Sub
    Public Property ExportFileLogs() As ExportFileLogCollection
        Get
            Return mExportLogs
        End Get
        Set(ByVal value As ExportFileLogCollection)
            mExportLogs = value
        End Set
    End Property
    Public Property EndDate() As Date
        Get
            Return mEndDate
        End Get
        Set(ByVal value As Date)
            mEndDate = value
        End Set
    End Property
    Public Property StartDate() As Date
        Get
            Return mSartDate
        End Get
        Set(ByVal value As Date)
            mSartDate = value
        End Set
    End Property
    Public Property SelectedExportGroupID() As Integer
        Get
            Return mSelectedExportGroupID
        End Get
        Set(ByVal value As Integer)
            mSelectedExportGroupID = value
        End Set
    End Property
    Public Sub GetByExportGroupID()
        Me.ExportFileLogs = ExportFileLog.GetByExportGroupID(SelectedExportGroupID, StartDate, EndDate)
    End Sub
    Public Sub GetAllLogs()
        Me.ExportFileLogs = ExportFileLog.GetAll(StartDate, EndDate)
    End Sub
End Class
