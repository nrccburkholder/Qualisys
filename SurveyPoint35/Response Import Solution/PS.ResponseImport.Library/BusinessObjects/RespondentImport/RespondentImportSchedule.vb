Imports PS.Framework.BusinessLogic
''' <summary>
''' Collection of RespondentImportSchedules (VRT, Mail...may be scheduled at different times and days).
''' </summary>
''' <remarks></remarks>
Public Class RespondentImportSchedules
    Inherits BusinessListBase(Of RespondentImportSchedule)
    ''' <summary>
    ''' This method checks to see if the current time is within the allowable scheduled times to run the Respondent Import.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function AllowRespondentFileProcessing() As Boolean
        Dim retVal As Boolean = False
        Dim currentDateTime As DateTime = Now()
        Dim currentDay As Integer = DatePart(DateInterval.Weekday, currentDateTime)
        For Each obj As RespondentImportSchedule In Me
            If obj.Day = currentDay Then
                Dim startTime As DateTime = CDate(currentDateTime.ToShortDateString() & " " & obj.StartTime)
                Dim endTime As DateTime = CDate(currentDateTime.ToShortDateString() & " " & obj.EndTime)
                If currentDateTime >= startTime AndAlso currentDateTime <= endTime AndAlso obj.Allow = 0 Then
                    retVal = False
                    Exit For
                ElseIf currentDateTime >= startTime AndAlso currentDateTime <= endTime AndAlso obj.Allow = 1 Then
                    retVal = True
                End If
            End If
        Next
        Return retVal
    End Function
End Class
Public Interface IRespondentImportSchedule
    Property RespondentImportScheduleID() As Integer
End Interface
''' <summary>
''' Contains the days and times that respondent imports may run.  Also contains flag to disallow the running
''' of respondent imports at certain times.
''' </summary>
''' <remarks></remarks>
Public Class RespondentImportSchedule
    Inherits BusinessBase(Of RespondentImportSchedule)
    Implements IRespondentImportSchedule


#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mRespondentImportScheduleID As Integer = 0
    Private mDay As Integer = 0
    Private mStartTime As String = String.Empty
    Private mEndTime As String = String.Empty
    Private mAllow As Integer = 0
    Private mDescription As String = String.Empty
#End Region
#Region " Properties "
    Public Property RespondentImportScheduleID() As Integer Implements IRespondentImportSchedule.RespondentImportScheduleID
        Get
            Return Me.mRespondentImportScheduleID
        End Get
        Protected Set(ByVal value As Integer)
            Me.mRespondentImportScheduleID = value
        End Set
    End Property
    Public Property Day() As Integer
        Get
            Return Me.mDay
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mDay = value) Then
                Me.mDay = value
                PropertyHasChanged("Day")
            End If
        End Set
    End Property
    Public Property StartTime() As String
        Get
            Return Me.mStartTime
        End Get
        Set(ByVal value As String)
            If Not Me.mStartTime = value Then
                Me.mStartTime = value
                PropertyHasChanged("StartTime")
            End If
        End Set
    End Property
    Public Property EndTime() As String
        Get
            Return Me.mEndTime
        End Get
        Set(ByVal value As String)
            If Not Me.mEndTime = value Then
                Me.mEndTime = value
                PropertyHasChanged("EndTime")
            End If
        End Set
    End Property
    Public Property Allow() As Integer
        Get
            Return Me.mAllow
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mAllow = value) Then
                Me.mAllow = value
                PropertyHasChanged("Allow")
            End If
        End Set
    End Property
    Public Property Description() As String
        Get
            Return Me.mDescription
        End Get
        Set(ByVal value As String)
            If Not Me.mDescription = value Then
                Me.mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewRespondentImportSchedule() As RespondentImportSchedule
        Return New RespondentImportSchedule
    End Function
    Public Shared Function GetRespondentImportSchedules() As RespondentImportSchedules
        Return RespondentImportScheduleProvider.Instance.GetRespondentImportSchedules()
    End Function
    Public Shared Function GetRespondentImportScheduleByID(ByVal RespondentImportScheduleID As Integer) As RespondentImportSchedule
        Return RespondentImportScheduleProvider.Instance.GetRespondentImportSchedule(RespondentImportScheduleID)
    End Function
#End Region
#Region " Data Access "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException
    End Sub

    Protected Overrides Sub Insert()
        Throw New NotImplementedException
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException
    End Sub
#End Region
#Region " Validation "
    Protected Overrides Sub AddBusinessRules()        
    End Sub    
#End Region


End Class
Public MustInherit Class RespondentImportScheduleProvider
#Region " Singleton Implementation "
    Private Shared mInstance As RespondentImportScheduleProvider
    Private Const mProviderName As String = "RespondentImportScheduleProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As RespondentImportScheduleProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of RespondentImportScheduleProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region " Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetRespondentImportSchedules() As RespondentImportSchedules
    Public MustOverride Function GetRespondentImportSchedule(ByVal respondentImportScheduleID As Integer) As RespondentImportSchedule
#End Region
End Class