Imports Nrc.SurveyPoint.Library
''' <summary>Abstracts the logic of ViewExportLogSection</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportLogSectionController
    Dim mExportLogs As ExportFileLogCollection
    Dim mSelectedExportGroupID As Nullable(Of Integer) = Nothing 'none selected by default
    Dim mStartDate As Date = Now().AddMonths(-1)
    Dim mEndDate As Date = Now()
    Dim mShowLogsForSelelctedGroupOnly As Boolean = True
    Dim mShowLogModeHasChanged As Boolean

    ''' <summary>Keeps track of ShowLogsForSelelctedGroupOnly property change</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ShowLogModeHasChanged() As Boolean
        Get
            Return mShowLogModeHasChanged
        End Get
        Private Set(ByVal value As Boolean)
            mShowLogModeHasChanged = value
        End Set
    End Property
    ''' <summary>Should be set to true if the ShowSelected buttong on the navigator is checked</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ShowLogsForSelelctedGroupOnly() As Boolean
        Get
            Return mShowLogsForSelelctedGroupOnly
        End Get
        Set(ByVal value As Boolean)
            Me.ShowLogModeHasChanged = value <> mShowLogsForSelelctedGroupOnly
            If Me.ShowLogModeHasChanged Then
                mShowLogsForSelelctedGroupOnly = value
                Me.Refresh()
            End If
        End Set
    End Property

    ''' <summary>Constructor</summary>
    ''' <param name="StartDate"></param>
    ''' <param name="EndDate"></param>
    ''' <param name="ExportGroupID"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal StartDate As Date, ByVal EndDate As Date, ByVal ExportGroupID As Nullable(Of Integer))
        'Save 
        Me.mStartDate = StartDate
        Me.mEndDate = EndDate
        Me.mSelectedExportGroupID = ExportGroupID

       
        Me.Refresh()
    End Sub

   


    ''' <summary>Default constructor</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New()
    End Sub
    ''' <summary>Contains the log collection for selected group or all 
    ''' depending on the showselected mode</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportFileLogs() As ExportFileLogCollection
        Get
            Return mExportLogs
        End Get
        Set(ByVal value As ExportFileLogCollection)
            mExportLogs = value

        End Set
    End Property
    ''' <summary>End date for the date filter</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EndDate() As Date
        Get
            Return mEndDate
        End Get
        Set(ByVal value As Date)
            If mEndDate <> value Then
                mEndDate = value
                Me.Refresh()
            End If
        End Set
    End Property
    ''' <summary>Start Date for the date filter</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property StartDate() As Date
        Get
            Return mStartDate
        End Get
        Set(ByVal value As Date)
            If mStartDate <> value Then
                mStartDate = value
                Me.Refresh()
            End If
        End Set
    End Property
    ''' <summary>Keeps the Export Group ID selected on the navigator grid</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SelectedExportGroupID() As Nullable(Of Integer)
        Get
            Return mSelectedExportGroupID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            If mSelectedExportGroupID.HasValue Then
                If value.HasValue Then
                    'If mSelectedExportGroupID.Value <> value.Value Then
                    mSelectedExportGroupID = value
                    Me.Refresh()
                    'End If
                Else
                    mSelectedExportGroupID = value
                End If
            Else
                mSelectedExportGroupID = value
            End If

        End Set
    End Property
    ''' <summary>Fills the ExportFileLogs collection with the logs 
    ''' filtered by the selected group and date range</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub GetByExportGroupID()
        Me.ExportFileLogs = ExportFileLog.GetByExportGroupID(SelectedExportGroupID.Value, StartDate, EndDate)
    End Sub

    ''' <summary>Fills the ExportFileLogs collection with all logs by the given date range</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub GetAllLogs()
        Me.ExportFileLogs = ExportFileLog.GetAll(StartDate, EndDate)
    End Sub
    ''' <summary>Fills the ExportFileLogs collection with all logs if the mode is showall
    ''' or with the logs of the selected export group. The Collection is always filter by StartDate and EndDate </summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub Refresh()
        If Me.mSelectedExportGroupID.HasValue AndAlso Me.ShowLogsForSelelctedGroupOnly Then
            GetByExportGroupID()
        Else
            'If ShowLogModeHasChanged Then
            GetAllLogs()
            'End If
        End If
        Me.ShowLogModeHasChanged = False 'reset the flag
    End Sub
End Class
