Imports NRC.Framework.BusinessLogic
Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification

Public Interface IToBeSeeded

    Property SeedId() As Integer

End Interface

<Serializable()> _
Public Class ToBeSeeded
	Inherits BusinessBase(Of ToBeSeeded)
	Implements IToBeSeeded

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mSeedId As Integer
    Private mSurveyId As Integer
    Private mYearQtr As String = String.Empty
    Private mIsSeeded As Boolean
    Private mdatSeeded As Date
    Private mSurveyTypeId As Integer

    Private mSurveyType As SurveyType = Nothing
    Private mSurvey As Survey = Nothing

#End Region

#Region " Public Properties "

    Public Property SeedId() As Integer Implements IToBeSeeded.SeedId
        Get
            Return mSeedId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mSeedId Then
                mSeedId = value
                PropertyHasChanged("SeedId")
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
            End If
        End Set
    End Property

    Public Property YearQtr() As String
        Get
            Return mYearQtr
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mYearQtr Then
                mYearQtr = value
                PropertyHasChanged("YearQtr")
            End If
        End Set
    End Property

    Public Property IsSeeded() As Boolean
        Get
            Return mIsSeeded
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsSeeded Then
                mIsSeeded = value
                PropertyHasChanged("IsSeeded")
            End If
        End Set
    End Property

    Public Property datSeeded() As Date
        Get
            Return mdatSeeded
        End Get
        Set(ByVal value As Date)
            If Not value = mdatSeeded Then
                mdatSeeded = value
                PropertyHasChanged("datSeeded")
            End If
        End Set
    End Property

    Public Property SurveyTypeId() As Integer
        Get
            Return mSurveyTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyTypeId Then
                mSurveyTypeId = value
                PropertyHasChanged("SurveyTypeId")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property SurveyType() As SurveyType
        Get
            If mSurveyType Is Nothing Then
                mSurveyType = SurveyType.Get(mSurveyTypeId)
            End If

            Return mSurveyType
        End Get
    End Property

    Public ReadOnly Property Survey() As Survey
        Get
            If mSurvey Is Nothing Then
                mSurvey = Survey.Get(mSurveyId)
            End If

            Return mSurvey
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewToBeSeeded() As ToBeSeeded

        Return New ToBeSeeded

    End Function

    Public Shared Function [Get](ByVal seedId As Integer) As ToBeSeeded

        Return ToBeSeededProvider.Instance.SelectToBeSeeded(seedId)

    End Function

    Public Shared Function GetBySurveyIDSampleDate(ByVal surveyId As Integer, ByVal startDate As Nullable(Of Date)) As ToBeSeeded

        Return ToBeSeededProvider.Instance.SelectToBeSeededBySurveyIDYearQtr(surveyId, GetYearQtrFromDate(startDate))

    End Function

    Public Shared Function GetIncompleteByYearQtr(ByVal yrQtr As String) As ToBeSeededCollection

        Return ToBeSeededProvider.Instance.SelectToBeSeededsIncompleteByYearQtr(yrQtr)

    End Function

    Public Shared Function GetAll() As ToBeSeededCollection

        Return ToBeSeededProvider.Instance.SelectAllToBeSeededs()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mSeedId
        End If
    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        SeedId = ToBeSeededProvider.Instance.InsertToBeSeeded(Me)

    End Sub

    Protected Overrides Sub Update()

        ToBeSeededProvider.Instance.UpdateToBeSeeded(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        ToBeSeededProvider.Instance.DeleteToBeSeeded(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Shared Function GetYearQtrFromDate(ByVal startDate As Date) As String

        'Build year quarter string
        Return String.Format("{0}Q{1}", startDate.Year, DatePart(DateInterval.Quarter, startDate))

    End Function

    Public Shared Function GetYearQtrFromDate(ByVal startDate As Nullable(Of Date)) As String

        Dim dat As Date

        'Determine the date to use
        If startDate.HasValue Then
            dat = startDate.Value
        Else
            dat = Date.Now
        End If

        'Build year quarter string
        Return GetYearQtrFromDate(dat)

    End Function

    Public Shared Function IsTimeToPopulateForQuarter(ByVal yrQtr As String) As Boolean

        Return ToBeSeededProvider.Instance.IsTimeToPopulateForQuarter(yrQtr)

    End Function

    Public Shared Function SendNotification(ByVal srvyTypes As SurveyTypeCollection, ByVal yrQtr As String, ByVal logOnly As Boolean) As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty
        Dim oldYrQtr As String = GetYearQtrFromDate(Date.Now.AddMonths(-3))

        Try
            'Determine who the recipients are going to be
            toList.Add("CMSGroup@NRCPicker.com")
            bccList.Add("Testing@NRCPicker.com")

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production OrElse logOnly Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set the environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Create the message object
            Dim msg As Message = New Message("SeededMailingNotification", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("YearQtr", yrQtr)
                    .Add("Environment", environmentName)
                    .Add("OldYearQtr", oldYrQtr)
                End With

                'Get table data
                Dim seededTable As DataTable = GetSeededDataTable(srvyTypes)
                Dim notSeededTable As DataTable = GetNotSeededDataTable(oldYrQtr)

                'Add the replacement tables
                With .ReplacementTables
                    .Add("Seeded_Text", seededTable)
                    .Add("NotSeeded_Text", notSeededTable)
                    .Add("Seeded_Html", seededTable)
                    .Add("NotSeeded_Html", notSeededTable)
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            Dim bodyText As String = msg.BodyText

            'Send the message
            If Not logOnly Then msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send Notification Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}", vbCrLf, ex.Message, ex.Source, ex.StackTrace)

        End Try

    End Function

    Public Shared Function SendExceptionNotification(ByVal serviceName As String, ByVal errMessage As String, ByVal errEx As Exception, ByVal logOnly As Boolean) As String

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim recipientNoteText As String = String.Empty
        Dim recipientNoteHtml As String = String.Empty
        Dim environmentName As String = String.Empty
        Dim exceptionText As String = String.Empty
        Dim exceptionHtml As String = String.Empty
        Dim sqlCommand As String = String.Empty
        Dim stackHtml As String = String.Empty
        Dim stackText As String = String.Empty
        Dim innerStackHtml As String = String.Empty
        Dim innerStackText As String = String.Empty

        Try
            'Determine who the recipients are going to be
            toList.Add("MDIQualiSys@NationalResearch.com")
            bccList.Add("Testing@NRCPicker.com")

            'Determine recipients bases on the environment
            If AppConfig.EnvironmentType <> EnvironmentTypes.Production OrElse logOnly Then
                'We are not in production
                'Add the real recipients to the note
                recipientNoteText = String.Format("{0}{0}Production To:{0}", vbCrLf)
                For Each email As String In toList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production CC:{0}", vbCrLf)
                For Each email As String In ccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteText &= String.Format("{0}Production BCC:{0}", vbCrLf)
                For Each email As String In bccList
                    recipientNoteText &= email & vbCrLf
                Next
                recipientNoteHtml = recipientNoteText.Replace(vbCrLf, "<BR>")

                'Clear the lists
                toList.Clear()
                ccList.Clear()
                bccList.Clear()

                'Populate the toList with the Testing group only
                toList.Add("Testing@NRCPicker.com")

                'Set the environment string
                environmentName = String.Format("({0})", AppConfig.EnvironmentName)
            End If

            'Deal with InvalidFileException
            exceptionText = errEx.Message
            exceptionHtml = errEx.Message.Replace(vbCrLf, "<BR>")

            'Build the SQL Command string
            If TypeOf errEx Is Nrc.Framework.Data.SqlCommandException Then
                sqlCommand = DirectCast(errEx, Nrc.Framework.Data.SqlCommandException).CommandText
            Else
                sqlCommand = "N/A"
            End If

            'Build the stack trace strings
            If errEx.StackTrace IsNot Nothing Then
                stackText = errEx.StackTrace

                stackHtml = errEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at")
                If (stackHtml.StartsWith("<BR>&nbsp;&nbsp;at")) Then
                    stackHtml = stackHtml.Substring("<BR>".Length)
                End If
            Else
                stackText = "N/A"
                stackHtml = "N/A"
            End If

            'Build the inner exception strings
            If errEx.InnerException IsNot Nothing Then
                Dim innerEx As Exception = errEx.InnerException
                Do While innerEx IsNot Nothing
                    'Text version

                    'HTML version
                    If innerStackText.Length > 0 Then
                        innerStackText &= vbCrLf
                        innerStackHtml &= "<BR>"
                    End If

                    If innerEx.Message IsNot Nothing OrElse innerEx.StackTrace IsNot Nothing Then
                        innerStackText &= "--------Inner Exception--------" & vbCrLf
                        innerStackHtml &= "--------Inner Exception--------" & "<BR>"

                        If innerEx.Message IsNot Nothing Then
                            innerStackText &= innerEx.Message & vbCrLf
                            innerStackHtml &= innerEx.Message.Replace(vbCrLf, "<BR>") & "<BR>"
                        End If

                        If innerEx.StackTrace IsNot Nothing Then
                            innerStackText &= innerEx.StackTrace & vbCrLf
                            innerStackHtml &= innerEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at") & "<BR>"
                        End If
                    End If

                    'Prepare for next pass
                    innerEx = innerEx.InnerException
                Loop
            Else
                innerStackText = "N/A"
                innerStackHtml = "--------Inner Exception--------<BR>N/A<BR>-------------------------------"
            End If

            'Create the message object
            Dim msg As Message = New Message("SeededMailingServiceException", AppConfig.SMTPServer)

            'Set the message properties
            With msg
                'To recipient
                For Each email As String In toList
                    .To.Add(email)
                Next

                'Cc recipient
                For Each email As String In ccList
                    .Cc.Add(email)
                Next

                'Bcc recipient
                For Each email As String In bccList
                    .Bcc.Add(email)
                Next

                'Add the replacement values
                With .ReplacementValues
                    .Add("ServiceName", serviceName)
                    .Add("Environment", environmentName)
                    .Add("Message", errMessage)
                    .Add("DateOccurred", DateTime.Now.ToString)
                    .Add("MachineName", Environment.MachineName)
                    .Add("ExceptionText", exceptionText)
                    .Add("ExceptionHtml", exceptionHtml)
                    .Add("Source", errEx.Source)
                    .Add("SQLCommand", sqlCommand)
                    .Add("StackTraceHtml", stackHtml)
                    .Add("StackTraceText", stackText)
                    .Add("InnerExceptionHtml", innerStackHtml & recipientNoteHtml)
                    .Add("InnerExceptionText", innerStackText & recipientNoteText)
                End With
            End With

            'Merge the template
            msg.MergeTemplate()

            'Get the body text
            Dim bodyText As String = msg.BodyText

            'Send the message
            If Not logOnly Then msg.Send()

            'Return the body text
            Return bodyText

        Catch ex As Exception
            'Return this exception
            Return String.Format("Exception encountered while attempting to send Exception Email!{0}{0}{1}{0}{0}Source: {2}{0}{0}Stack Trace:{0}{3}{0}{0}Original Exception{0}{0}{4}{0}{0}Source: {5}{0}{0}Stack Trace:{0}{6}", vbCrLf, ex.Message, ex.Source, ex.StackTrace, errEx.Message, errEx.Source, errEx.StackTrace)

        End Try

    End Function

#End Region

#Region " Private Methods "

    Private Shared Function GetSeededDataTable(ByVal srvyTypes As SurveyTypeCollection) As DataTable

        Dim table As New DataTable

        'Add the columns
        With table
            With .Columns
                .Add("SurveyType", GetType(String))
                .Add("ClientName", GetType(String))
                .Add("ClientID", GetType(String))
                .Add("StudyName", GetType(String))
                .Add("StudyID", GetType(String))
                .Add("SurveyName", GetType(String))
                .Add("SurveyID", GetType(String))
            End With
        End With

        'Populate the table
        For Each srvyType As SurveyType In srvyTypes
            If srvyType.SeedSurveys.Count > 0 Then
                For Each srvy As Survey In srvyType.SeedSurveys
                    'Create a new row
                    Dim row As DataRow = table.NewRow

                    'Populate the row
                    row.Item("SurveyType") = srvyType.Description
                    row.Item("ClientName") = srvy.Study.Client.Name.Trim
                    row.Item("ClientID") = srvy.Study.ClientId.ToString
                    row.Item("StudyName") = srvy.Study.Name.Trim
                    row.Item("StudyID") = srvy.StudyId.ToString
                    row.Item("SurveyName") = srvy.Name.Trim
                    row.Item("SurveyID") = srvy.Id.ToString

                    'Add the row to the table
                    table.Rows.Add(row)
                Next
            End If
        Next

        Return table

    End Function

    Private Shared Function GetNotSeededDataTable(ByVal oldYrQtr As String) As DataTable

        Dim table As New DataTable

        'Add the columns
        With table
            With .Columns
                .Add("SurveyType", GetType(String))
                .Add("ClientName", GetType(String))
                .Add("ClientID", GetType(String))
                .Add("StudyName", GetType(String))
                .Add("StudyID", GetType(String))
                .Add("SurveyName", GetType(String))
                .Add("SurveyID", GetType(String))
            End With
        End With

        'Get the incomplete ToBeSeeded records for last quarter
        Dim notSeededs As ToBeSeededCollection = GetIncompleteByYearQtr(oldYrQtr)

        'Populate the table
        For Each seed As ToBeSeeded In notSeededs
            'Create a new row
            Dim row As DataRow = table.NewRow

            'Populate the row
            row.Item("SurveyType") = seed.SurveyType.Description
            row.Item("ClientName") = seed.Survey.Study.Client.Name.Trim
            row.Item("ClientID") = seed.Survey.Study.ClientId.ToString
            row.Item("StudyName") = seed.Survey.Study.Name.Trim
            row.Item("StudyID") = seed.Survey.StudyId.ToString
            row.Item("SurveyName") = seed.Survey.Name.Trim
            row.Item("SurveyID") = seed.Survey.Id.ToString

            'Add the row to the table
            table.Rows.Add(row)
        Next

        Return table

    End Function

#End Region

End Class


