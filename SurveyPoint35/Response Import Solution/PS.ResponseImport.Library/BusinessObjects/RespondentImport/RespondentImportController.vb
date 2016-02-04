Imports System.IO
Imports System.Text
Imports System.Net.Mail
''' <summary>
''' This is the controller class for respondent response imports.  A service will instantiate and call
''' the ProcessRespondentFiles method to import responses from data files set on the LAN.
''' </summary>
''' <remarks></remarks>
Public Class RespondentImportController
#Region " Private Fields "
    Private Const APPNAME As String = "RespondentImport"
    Private mVRTDirectory As String = String.Empty
    Private mMailDirectory As String = String.Empty
    Private mWebDirectory As String = String.Empty
    Private mPhoneDirectory As String = String.Empty
    Private mConfigVars As System.Collections.Hashtable = Nothing
    Private mRespImportSchedules As RespondentImportSchedules = Nothing
    Private Shared mSleepTime As Integer = 0
    Private mFolderList As New RespondentImportFolders()
#End Region
#Region " Constructors "
    Public Sub New()        
        LoadConfigVars()
    End Sub
#End Region
#Region " Properties "
    Public ReadOnly Property VRTDirectory() As String
        Get
            Return Me.mVRTDirectory
        End Get
    End Property
    Public ReadOnly Property MailDirectory() As String
        Get
            Return Me.mMailDirectory
        End Get
    End Property
    Public ReadOnly Property WebDirectory() As String
        Get
            Return Me.mWebDirectory
        End Get
    End Property
    Public ReadOnly Property PhoneDirectory() As String
        Get
            Return Me.mPhoneDirectory
        End Get
    End Property
    Public ReadOnly Property RespImportSchedules() As RespondentImportSchedules
        Get
            Return Me.mRespImportSchedules
        End Get
    End Property
    Public Shared ReadOnly Property SleepTime() As Integer
        Get
            Return mSleepTime
        End Get
    End Property
    Public ReadOnly Property RespImportFolders() As RespondentImportFolders
        Get
            Return Me.mFolderList
        End Get
    End Property
#End Region
#Region " Public Methods "
    ''' <summary>
    ''' This method 1st loops through the Manual folder for each Survey System Type.  These
    ''' do not run on a schedule and process immeadiately.  Next, it checks if there are any files in 
    ''' the processing folders.  This would load files that started, but errored off AND were not moved (due to error)
    ''' to the appropriate errors directory. (This should allow use to pick back up files that could not be processed
    ''' due to the LAN going down.
    ''' Lastly, loop through the processesing directory and process any files that are scheduled.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub ProcessRespondentFiles()
        'Start loop through the manual directories as these can be done irregardless of schedules.
        For Each fldr As RespondentImportFolder In Me.RespImportFolders
            ProcessFolder(fldr, RespImportDirectories.ManualFolder)
        Next
        Threading.Thread.Sleep(SleepTime)
        'Next, if schedule allows, process all the processing folders (This will be for files that error out.        
        For Each fldr As RespondentImportFolder In Me.RespImportFolders
            If RespImportSchedules.AllowRespondentFileProcessing Then
                ProcessFolder(fldr, RespImportDirectories.ProcessingFolder)
            End If
        Next
        'Lastly, if schedule allos, process all the in folders.
        For Each fldr As RespondentImportFolder In Me.RespImportFolders
            If RespImportSchedules.AllowRespondentFileProcessing Then
                ProcessFolder(fldr, RespImportDirectories.InFolder)
            End If
        Next
    End Sub
    Public Shared Sub ErrorNotify(ByVal err As String)
        Try
            Dim mMailMessage As New MailMessage()
            Dim toString As String = Config.EmailTo
            Dim fromString As String = Config.EmailFrom
            mMailMessage.From = New MailAddress(fromString)
            Dim tos() As String = toString.Split("|"c)
            For Each item As String In tos
                mMailMessage.To.Add(New MailAddress(item))
            Next
            mMailMessage.Subject = "Respondent Import Error"
            mMailMessage.IsBodyHtml = False
            mMailMessage.Body = "Respondent Import Service has errored and will no longer process." & vbCrLf &
                "The following error was encountered:" & vbCrLf &
                err
            Dim mSmtpClient As New SmtpClient(Config.SmtpServer)
            mSmtpClient.Send(mMailMessage)
        Catch ex As System.Exception
            'Do nothing, you're stopping the service if you reach this.
        End Try
    End Sub
    Public Shared Sub ErrorNotify(ByVal err As Exception)
        Try
            Dim mMailMessage As New MailMessage()
            Dim toString As String = Config.EmailTo
            Dim fromString As String = Config.EmailFrom
            mMailMessage.From = New MailAddress(fromString)
            Dim tos() As String = toString.Split("|"c)
            For Each item As String In tos
                mMailMessage.To.Add(New MailAddress(item))
            Next
            mMailMessage.Subject = "Respondent Import Error"
            mMailMessage.IsBodyHtml = False
            mMailMessage.Body = "Respondent Import Service has errored and will no longer process." & vbCrLf &
                "The following error was encountered:" & vbCrLf &
                err.GetType().ToString() & ": " & err.Message & vbCrLf &
                err.StackTrace
            Dim mSmtpClient As New SmtpClient(Config.SmtpServer)
            mSmtpClient.Send(mMailMessage)
        Catch ex As System.Exception
            'Do nothing, you're stopping the service if you reach this.
        End Try
    End Sub
#End Region
#Region " Private Methods "
    ''' <summary>
    ''' Load config variables used during the lifetime of the object.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub LoadConfigVars()
        Me.mConfigVars = RespondentImportControllerProvider.Instance.GetConfigVars(APPNAME)
        Me.mVRTDirectory = mConfigVars("VRTBaseDirectory")
        Me.mMailDirectory = mConfigVars("MailBaseDirectory")
        Me.mWebDirectory = mConfigVars("WebBaseDirectory")
        Me.mPhoneDirectory = mConfigVars("PhoneBaseDirectory")
        'TODO:  Make Threadsafe
        mSleepTime = mConfigVars("SleepTime")
        Me.mRespImportSchedules = RespondentImportSchedule.GetRespondentImportSchedules
        Me.mFolderList.Add(New RespondentImportFolder(Me.VRTDirectory, SurveySystemType.VRT))
        Me.mFolderList.Add(New RespondentImportFolder(Me.MailDirectory, SurveySystemType.MAIL))
        Me.mFolderList.Add(New RespondentImportFolder(Me.PhoneDirectory, SurveySystemType.PHONE))
        Me.mFolderList.Add(New RespondentImportFolder(Me.WebDirectory, SurveySystemType.WEB))
    End Sub
    ''' <summary>
    ''' This method loops through the files in a folder, copies it to the processing directory
    ''' and proccesses each file.
    ''' </summary>
    ''' <param name="fldr"></param>
    ''' <param name="fldrType"></param>
    ''' <remarks></remarks>
    Private Sub ProcessFolder(ByVal fldr As RespondentImportFolder, ByVal fldrType As RespImportDirectories)
        Dim folderPath As String = String.Empty
        Select Case fldrType
            Case RespImportDirectories.ManualFolder
                folderPath = fldr.ManualDirectory
            Case RespImportDirectories.InFolder
                folderPath = fldr.InDirectory
            Case RespImportDirectories.ProcessingFolder
                folderPath = fldr.ProcessingDirectory
        End Select
        'Only grab one at a time, so you pick up any added while you are processing.
        Dim folderFiles() As String = Directory.GetFiles(folderPath)
        While folderFiles.Count > 0
            Dim myFile As FileInfo = Nothing
            Try
                'First, copy the file to the processing directory.
                myFile = New FileInfo(folderFiles(0))
                Dim newFile As String = String.Empty
                If fldrType <> RespImportDirectories.ProcessingFolder Then
                    newFile = AppendGuidToFileName(myFile.Name)
                    myFile.MoveTo(fldr.ProcessingDirectory & "\" & newFile)
                Else
                    'TODO:  Does this need to change names???
                    newFile = myFile.Name
                End If
                myFile = Nothing
                'Now, Process the file.
                Dim procFile As New RespondentImportFile(newFile, fldr.ProcessingDirectory, fldr.ArchiveFolder, fldr.ErrorsDirectory, fldr.FolderType)
                'Allow time to prevent disk errors when copying large files.
                Threading.Thread.Sleep(200)
                procFile.ProcessFile()
            Catch ex As Exception
                'The Process File method will catch and move the file to the appropriate errors directory.
                'All we have to do here is throw the unexpected error and let the service handle it.
                Throw ex
            Finally
                myFile = Nothing
            End Try
            folderFiles = Directory.GetFiles(folderPath)
        End While
    End Sub
    ''' <summary>
    ''' This method appends a unique identifier to file names.
    ''' </summary>
    ''' <param name="fn"></param>
    ''' <returns>File name with GUID appended to the end.</returns>
    ''' <remarks></remarks>
    Private Function AppendGuidToFileName(ByVal fn As String) As String
        Dim retVal As String = fn
        Dim guidString As String = Guid.NewGuid.ToString()
        If retVal.IndexOf("."c) > 0 Then            
            retVal = retVal.Substring(0, retVal.LastIndexOf("."c)) & guidString & Right(retVal, (retVal.Length - retVal.LastIndexOf("."c)))
        Else
            retVal = retVal & guidString
        End If
        Return retVal
    End Function
#End Region
End Class
Public MustInherit Class RespondentImportControllerProvider
#Region " Singleton Implementation "
    Private Shared mInstance As RespondentImportControllerProvider
    Private Const mProviderName As String = "RespondentImportControllerProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As RespondentImportControllerProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of RespondentImportControllerProvider)(mProviderName)
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
    Public MustOverride Function GetConfigVars(ByVal appName As String) As Hashtable
#End Region
End Class
