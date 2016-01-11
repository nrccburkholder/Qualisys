Option Explicit On
'********************************************************************'
' Created by Elibad - 09/01/2007
'
'  This class is the base class for the Task Schedulers
'  These Classes can schedule any type of task based 
'  on different interval types (Hourly, Daily, Weekly, etc)
'*********************************************************************

Namespace Miscellaneous.TaskScheduler
    Public MustInherit Class Scheduler
        Implements IDisposable

        Private _iInterval As Integer
        Private _sFileName As String
        Private _dtLastRun As DateTime
        Private _dtNextRun As DateTime
        Private _bEnabled As Boolean
        Private _dStartDate As Date
        Private _dtTime As DateTime
        Private _tTimer As New System.Timers.Timer

        Protected disposed As Boolean = False
        Protected _bFirstRun As Boolean

        ''' <summary>
        ''' Generates the Next Run Date
        ''' </summary>
        Protected MustOverride Function GetNextOccurrence(ByVal BaseDate As DateTime) As DateTime

        ''' <summary>
        ''' This Event gets Trigered when the schedule reaches the next run Date and time
        ''' </summary>
        Public Event RunTask()

        ''' <summary>
        ''' Interval of recurrence
        ''' </summary>
        ''' <remarks>
        ''' Examples:
        ''' Interval = 2
        ''' 
        ''' If Recurrence Type = Daily then it will run every 2 Days
        ''' If Recurrence Type = Weekly then it will run every 2 Weeks
        ''' </remarks>
        Public Property Interval() As Integer
            Get
                Interval = _iInterval
            End Get
            Set(ByVal value As Integer)
                If value > 0 Then
                    _iInterval = value
                    If Me.Enabled Then
                        Me._bFirstRun = True
                        Me.UpdateNextOccurrence()
                    End If
                Else
                    Throw New System.Exception("Incorrect Interval value" & vbCrLf & vbCrLf & "Interval should be higher than 0")
                End If
            End Set
        End Property

        ''' <summary>
        ''' Date to start schedule
        ''' </summary>
        ''' <value>Default value is Date.Now</value>
        Public Property StartDate() As String
            Get
                StartDate = _dStartDate.ToString("MM/dd/yyyy")
            End Get
            Set(ByVal value As String)
                Try
                    _dStartDate = Date.Parse(value)
                Catch ex As Exception
                    Throw New System.Exception("Incorrect Date" & vbCrLf & vbCrLf & "Please provide a date using mm/dd/yyyy format")
                End Try

                If Me.Enabled Then
                    Me.UpdateNextOccurrence()
                End If
            End Set
        End Property

        ''' <summary>
        ''' Defines if the schedule is running
        ''' </summary>
        Public Property Enabled() As Boolean
            Get
                Enabled = _bEnabled
            End Get
            Set(ByVal value As Boolean)
                _bEnabled = value
                _tTimer.Enabled = value
                If Me.Enabled Then
                    Me._bFirstRun = True
                    Me.UpdateNextOccurrence()
                End If
            End Set
        End Property


        ''' <summary>
        ''' Time of the Day for Next recurrence
        ''' </summary>
        Public Property Time() As String
            Get
                Time = _dtTime.ToString("HH:mm")
            End Get
            Set(ByVal value As String)
                Try
                    _dtTime = DateTime.Parse(value)
                Catch ex As Exception
                    Throw New System.Exception("Incorrect Time" & vbCrLf & vbCrLf & "Please provide correct time value (24 hh:mm or hh:mm AM/PM)")
                End Try

                If Me.Enabled Then
                    Me._bFirstRun = True
                    Me.UpdateNextOccurrence()
                End If
            End Set
        End Property

        Public Sub New()
            Me.New("01:00:00")
        End Sub

        Public Sub New(ByVal Time As String)
            Me.New(1, Date.Today.ToString("MM/dd/yyyy"), Time, False)
        End Sub

        Public Sub New(ByVal Interval As Integer, ByVal StartDate As String, ByVal Time As String, ByVal Enabled As Boolean)
            'Initialize variables
            Me.Interval = Interval
            Me.StartDate = StartDate
            Me.Time = Time
            Me._bEnabled = Enabled
            Me._bFirstRun = True

            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If

            _dtLastRun = Date.Now
            _dtNextRun = Date.Now.AddDays(3)

            'Initialize internal Timer
            AddHandler _tTimer.Elapsed, AddressOf VerifySchedule

            ' Set the timer interval to the number of minutes set in the app.config file
            _tTimer.Interval = New TimeSpan(0, 0, 10).TotalMilliseconds

            _tTimer.AutoReset = False

            ' Turn on _tTimer
            _tTimer.Enabled = Enabled
        End Sub

        ''' <summary>
        ''' This Method is executed by the internal timer Tick event
        ''' </summary>
        ''' <remarks>This Method verifies wheter the Next run date has been reached</remarks>
        Private Sub VerifySchedule(ByVal sender As Object, ByVal e As System.Timers.ElapsedEventArgs)
            If Now > _dtNextRun Then
                _dtLastRun = _dtNextRun
                Me.UpdateNextOccurrence()
                RaiseEvent RunTask()
            End If
            _tTimer.Start()
        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        Private Sub SaveRunDates()
            Dim sDates As String
            sDates = "LastRun = '" & _dtLastRun.ToString("MM/dd/yyyy HH:mm:ss") & "'"
            '            & vbCrLf & "NextRun = '" & _dtNextRun.ToString("MM/dd/yyyy HH:mm:ss") & "'"
            My.Computer.FileSystem.WriteAllText(_sFileName, sDates, False)
        End Sub

        ''' <summary>
        ''' 
        ''' </summary>
        Private Sub LoadRunDates()
            Dim sData As String
            Dim iStart As Integer
            Dim iLenght As Integer

            If System.IO.File.Exists(_sFileName) Then
                sData = My.Computer.FileSystem.ReadAllText(_sFileName)
                iStart = "LastRun = '".Length + 1
                iLenght = sData.IndexOf("'", iStart) - (iStart)
                sData = "#" & sData.Substring(iStart, iLenght) & "#"
                _dtLastRun = Date.Parse(sData)
            End If
            If _dtLastRun < Date.Now.AddYears(-1) Then
                _dtLastRun = Date.Now
            End If
            If Me.Enabled Then
                Me.UpdateNextOccurrence()
            End If
        End Sub

        ''' <summary>
        ''' This Method updates the Next Run Date and Time with the proper value
        ''' </summary>
        Protected Sub UpdateNextOccurrence()
            If _dtLastRun > _dStartDate Then
                _dtNextRun = GetNextOccurrence(_dtLastRun)
            ElseIf _dStartDate > Date.Now Then
                _dtNextRun = GetNextOccurrence(_dStartDate)
            End If
        End Sub
        Public Sub Start()
            Me.Enabled = True
        End Sub

        Public Sub [Stop]()
            Me.Enabled = False
        End Sub

        ''' <summary>
        ''' This value determines how often the scheduler will verify that the next scheduled run has been reached
        ''' </summary>
        ''' <value>Default = 30 Seconds</value>
        Public Property ScheduleCheckInterval() As Integer
            Get
                ScheduleCheckInterval = CInt(_tTimer.Interval / 1000)
            End Get
            Set(ByVal value As Integer)
                If value > 0 Then
                    _tTimer.Interval = value * 1000
                End If
            End Set
        End Property

#Region "IDisposable support"
        Protected Overridable Sub dispose(ByVal disposing As Boolean)
            If Not Me.disposed Then
                If disposing Then

                End If
                'SaveRunDates()
            End If
            Me.disposed = True
        End Sub

        Public Sub Dispose() Implements IDisposable.Dispose
            dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        Protected Overrides Sub Finalize()
            dispose(False)
            MyBase.Finalize()
        End Sub

        ''' <summary>
        ''' Gets the Date and Time for Next Run
        ''' </summary>
        Public ReadOnly Property NextRun() As String
            Get
                NextRun = _dtNextRun.ToString("MM/dd/yyyy HH:mm")
                If Me.Enabled = False Then
                    NextRun = "Scheduler is Disabled"
                End If
            End Get
        End Property

#End Region

    End Class

    'Public MustInherit Class NRC_Scheduler
End Namespace
