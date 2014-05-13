Imports System.IO
Imports System.Xml.Serialization
Imports System.Threading
<Serializable()> _
Public Class Schedule
    Implements IDisposable, ICloneable

#Region " Private Members "
    Private mEvents As New ScheduleEventCollection
    Private mIsEnabled As Boolean = False
    Private mEventThread As Thread
#End Region

#Region " StatusChanged Event  "
    Public Class StatusChangedEventArgs
        Inherits EventArgs

        Private mNewStatusId As Integer

        Public ReadOnly Property NewStatusId() As Integer
            Get
                Return mNewStatusId
            End Get
        End Property

        Public Sub New(ByVal newId As Integer)
            mNewStatusId = newId
        End Sub

    End Class
    Public Delegate Sub StatusChangedEventHandler(ByVal sender As Object, ByVal e As StatusChangedEventArgs)
    Public Event StatusChanged As StatusChangedEventHandler
#End Region

#Region " Public Properties "
    Public ReadOnly Property Events() As ScheduleEventCollection
        Get
            Return mEvents
        End Get
    End Property

    Public Property IsEnabled() As Boolean
        Get
            Return mIsEnabled
        End Get
        Set(ByVal Value As Boolean)
            If Not mIsEnabled = Value Then
                mIsEnabled = Value
                If Value Then
                    Me.CreateEventThread()
                Else
                    Me.AbortEventThread()
                End If
            End If
        End Set
    End Property

    Public Shared ReadOnly Property PersistancePath() As String
        Get
            Return String.Format("{0}\{1}\Schedule.xml", Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), Application.ProductName)
        End Get
    End Property

#End Region

#Region " Constructors "
    Sub New()

    End Sub

    'Private Sub New(ByVal sched As Schedule)
    '    Me.New()

    '    For Each evnt As ScheduleEvent In sched.mEvents
    '        Me.mEvents.Add(DirectCast(evnt.Clone, ScheduleEvent))
    '    Next
    'End Sub
#End Region

    Private Function GetTodaysNextEvent() As ScheduleEvent
        For Each evnt As ScheduleEvent In mEvents
            If evnt.HappensOnDay(Date.Now.DayOfWeek) AndAlso Not evnt.HasHappenedToday Then
                Return evnt
            End If
        Next

        Return Nothing
    End Function

#Region " Serialization "
    Private Sub Serialize(ByVal writer As Object)
        Dim tWriter As TextWriter = Nothing
        Dim xWriter As System.Xml.XmlTextWriter = Nothing
        Dim serializer As XmlSerializer

        Try
            serializer = New XmlSerializer(GetType(Schedule))
            If writer.GetType.IsSubclassOf(GetType(TextWriter)) Then

                tWriter = CType(writer, TextWriter)
                serializer.Serialize(tWriter, Me)
            ElseIf GetType(System.Xml.XmlTextWriter).IsInstanceOfType(writer) Then
                xWriter = CType(writer, System.Xml.XmlTextWriter)
                serializer.Serialize(xWriter, Me)
            Else
                Throw New ArgumentException("writer parameter must be of type TextWriter or XmlTextWriter.")
            End If
        Finally
            If Not tWriter Is Nothing Then
                tWriter.Close()
            End If
            If Not xWriter Is Nothing Then
                xWriter.Close()
            End If
        End Try
    End Sub

    Public Sub Serialize(ByVal fileName As String)
        Dim file As New FileInfo(fileName)
        If Not file.Directory.Exists Then
            file.Directory.Create()
        End If
        Dim writer As New System.Xml.XmlTextWriter(fileName, System.Text.Encoding.ASCII)
        Serialize(writer)
    End Sub
    Public Sub Serialize()
        Serialize(Schedule.PersistancePath)
    End Sub

    'Public Function Serialize() As String
    '    Dim sb As New System.Text.StringBuilder
    '    Dim writer As New StringWriter(sb)
    '    Serialize(writer)
    '    Return sb.ToString
    'End Function

    Public Shared Function Deserialize() As Schedule
        Dim serializer As XmlSerializer
        If Not File.Exists(Schedule.PersistancePath) Then
            Return New Schedule
        End If

        serializer = New XmlSerializer(GetType(Schedule))

        Using reader As New Xml.XmlTextReader(Schedule.PersistancePath)
            Return CType(serializer.Deserialize(reader), Schedule)
        End Using
    End Function

#End Region

    'Private Sub mTimer_Elapsed(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs) Handles mTimer.Elapsed
    '    'System.Threading.Thread.CurrentThread.Name = "In/Out Timer Thread"
    '    Debug.WriteLine("Timer comming alive to check for status change.")
    '    Dim evnt As ScheduleEvent = Me.GetNextEvent
    '    If Not evnt Is Nothing AndAlso evnt.HasHappenedToday Then
    '        Debug.WriteLine("Found an event to process: " & mNextEvent.ScheduledTime.ToString)
    '        RaiseEvent StatusChanged(Me, New StatusChangedEventArgs(mNextEvent.StatusId))
    '    End If
    '    'If Me.mNextEvent.HasHappenedToday Then
    '    '    Me.mNextEvent = Me.GetNextEvent()
    '    'End If
    'End Sub

    Private Sub CreateEventThread()
        If Not mIsEnabled Then
            Exit Sub
        End If

        'Abort previous thread if it exists
        Me.AbortEventThread()

        mEventThread = New Thread(AddressOf ScheduleEvent)

        mEventThread.Start()
    End Sub

    Private Sub ScheduleEvent()
        Dim evnt As ScheduleEvent = Me.GetTodaysNextEvent
        Dim span As TimeSpan
        Dim nowDate As DateTime = DateTime.Now
        Dim tomorrowDate As DateTime = DateTime.Now.AddDays(1)
        Dim targetDate As DateTime

        'If there is no event today then schedule then sleep until tomorrow
        If evnt Is Nothing Then
            targetDate = New DateTime(tomorrowDate.Year, tomorrowDate.Month, tomorrowDate.Day)
        Else
            'If there is an event today then sleep until that event
            targetDate = New DateTime(nowDate.Year, nowDate.Month, nowDate.Day, evnt.ScheduledTime.Hour, evnt.ScheduledTime.Minute, 0)
        End If

        'Get the timespan from now until our wake-up time
        span = targetDate.Subtract(nowDate)

        Debug.WriteLine("Current time is " & DateTime.Now.TimeOfDay.ToString)
        Debug.WriteLine("Scheduleing the event for " & DateTime.Now.Add(span).TimeOfDay.ToString)
        Try
            System.Threading.Thread.Sleep(span)
            ExecuteEvent(evnt)
        Catch ex As ThreadAbortException
            Debug.WriteLine("Thread Exception caught.  Exiting sub routine.")
            System.Threading.Thread.ResetAbort()
            Exit Sub
        End Try
    End Sub


    Private Sub ExecuteEvent(ByVal evnt As ScheduleEvent)
        Debug.WriteLine("Thread is now executing at time: " & DateTime.Now.TimeOfDay.ToString)

        If Not evnt Is Nothing Then
            Debug.WriteLine("Found an event to process: " & evnt.ScheduledTime.ToString)
            RaiseEvent StatusChanged(Me, New StatusChangedEventArgs(evnt.StatusId))
        End If
        mEventThread = Nothing
        CreateEventThread()
    End Sub

    Public Sub Dispose() Implements System.IDisposable.Dispose
        Me.AbortEventThread()
    End Sub

    Private Sub AbortEventThread()
        If Not Me.mEventThread Is Nothing Then
            If Not mEventThread.ThreadState = ThreadState.AbortRequested Then
                Debug.WriteLine("Aborting previous thread.")
                mEventThread.Abort()
                mEventThread = Nothing
            Else
                Debug.WriteLine("Previous thread already aborting.")
            End If
        End If
    End Sub

    Public Function Clone() As Object Implements System.ICloneable.Clone
        Dim sched As Schedule = DirectCast(Me.MemberwiseClone, Schedule)
        sched.mEventThread = Nothing
        sched.mIsEnabled = False
        Return sched
    End Function
End Class
