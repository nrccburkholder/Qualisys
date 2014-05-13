Public Delegate Sub SchedulerCallBackMethod(ByVal data As Object)

Public Class Scheduler

    Private mCallback As SchedulerCallBackMethod

    Private Property Callback() As SchedulerCallBackMethod
        Get
            Return mCallback
        End Get
        Set(ByVal value As SchedulerCallBackMethod)
            mCallback = value
        End Set
    End Property

    Private mData As Object
    Private Property Data() As Object
        Get
            Return mData
        End Get
        Set(ByVal value As Object)
            mData = value
        End Set
    End Property

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.Enabled = False
    End Sub

    Public Sub ScheduleTask(ByVal interval As Integer, ByVal callback As SchedulerCallBackMethod, ByVal data As Object)
        Me.Callback = callback
        Me.Data = data
        Me.Interval = interval
        Me.Enabled = True
    End Sub

    Protected Overrides Sub OnTick(ByVal e As System.EventArgs)
        MyBase.OnTick(e)
        Me.Enabled = False
        Me.mCallback(Me.mData)
    End Sub

End Class
