Public Class ExportButtonClickedEventArgs
    Inherits EventArgs

    Private mButtonClicked As ExportConfigurationButtonEnum
    Private mLogFileID As Integer
    Private mExportGroupID As Integer = 0 'Steve Kennedy - 3/3/2008 - for new export group
    Private mStartDate As Nullable(Of Date)
    Private mEndDate As Nullable(Of Date)
    Private mIsSubmitted As Boolean


    Public ReadOnly Property ButtonClicked() As ExportConfigurationButtonEnum
        Get
            Return mButtonClicked
        End Get
    End Property

    Public Property LogFileID() As Integer
        Get
            Return mLogFileID
        End Get
        Set(ByVal value As Integer)
            mLogFileID = value
        End Set
    End Property


    Public Property ExportGroupID() As Integer
        Get
            Return mExportGroupID
        End Get
        Set(ByVal value As Integer)
            mExportGroupID = value
        End Set
    End Property



    Public Property StartDate() As Nullable(Of Date)
        Get
            Return mStartDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            mStartDate = value
        End Set
    End Property

    Public Property EndDate() As Nullable(Of Date)
        Get
            Return mEndDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            mEndDate = value
        End Set
    End Property

    Public Property IsSubmitted() As Boolean
        Get
            Return mIsSubmitted
        End Get
        Set(ByVal value As Boolean)
            mIsSubmitted = value
        End Set
    End Property



    Public Sub New(ByVal buttonClicked As ExportConfigurationButtonEnum)
        mButtonClicked = buttonClicked
    End Sub
    Public Sub New(ByVal buttonClicked As ExportConfigurationButtonEnum, ByVal mExportGroupID As Integer)
        mButtonClicked = buttonClicked
        Me.mExportGroupID = mExportGroupID
    End Sub

    Public Sub New(ByVal buttonClicked As ExportConfigurationButtonEnum, ByVal mExportGroupID As Integer, ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal isSubmitted As Boolean)
        mButtonClicked = buttonClicked
        Me.mExportGroupID = mExportGroupID
        Me.mStartDate = startDate
        Me.mEndDate = endDate
        Me.mIsSubmitted = isSubmitted
    End Sub

    Public Sub New(ByVal logFileId As Integer)

        mButtonClicked = ExportConfigurationButtonEnum.ReRun
        Me.LogFileID = logFileId

    End Sub




End Class
