Imports System.IO
Imports System.Text
Imports System.Threading
Imports WindowsEventLog = System.Diagnostics.EventLog

Imports NRC.SmartLink.Common

Public Class Watcher

#Region "Private Variables"

    ''' <summary>
    ''' Module level constant for the name of the class used as part of the exception messages
    ''' </summary>
    ReadOnly _CLASSNAME As String = "Watcher.vb"
    ''' <summary>
    ''' Module level variable for the constant representing "YES"
    ''' </summary>
    ReadOnly _YES As String = "yes"
    ''' <summary>
    ''' Module level variable to reference the NRC EventLog object
    ''' </summary>
    Public Shared _objEventLog As New NRCEventLog

    ' Variables that hold the Application Configuration Parameters
    ''' <summary>
    ''' Module level variable for the attribute AppPath
    ''' </summary>
    Private _appPath As String = My.Application.Info.DirectoryPath  'System.AppDomain.CurrentDomain.BaseDirectory

    ''' <summary>
    ''' Module level variable for the attribute AppName derived from NRC_SLT property by the same name
    ''' </summary>
    Private _AppName As String = My.Application.Info.Title

    ''' <summary>
    ''' The location and name of the XML settings file
    ''' </summary>
    Private _settingFile As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute Path
    ''' </summary>
    Private _strPath As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute PollingPath1
    ''' </summary>
    Private _strPollingPath1 As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute PollingPath2
    ''' </summary>
    Private _strPollingPath2 As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute ErrorsDif
    ''' </summary>
    Private _ErrorsDir As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute WorkDir
    ''' </summary>
    ''' <remarks>Directory path to where files are Zipped</remarks>
    Private _strWorkDir As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute BackupDir
    ''' </summary>
    Private _strBackupDir As String 'Directory path to where files are backed up

    ''' <summary>
    ''' Module level variable for the attribute ExcludedFileTypes
    ''' </summary>
    ''' <remarks>file types to exclude from submitting to NRC</remarks>
    Private _strExcludeFileTypes As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute ErrorLogFile
    ''' </summary>
    Private _strErrorLogFile As String = String.Empty 'file path

    ''' <summary>
    ''' Module level variable for the attribute EventLogFile
    ''' </summary>
    Private _strEventLogFile As String = String.Empty 'file path

    ''' <summary>
    ''' Module level variable used as a paramter in creation and maintenance of the trace log file
    ''' </summary>
    Private _LogWSFiles As String = String.Empty 'YES/NO

    ''' <summary>
    ''' Module level variable for the attribute BackupFiles
    ''' </summary>
    Private _BackupFiles As String = String.Empty 'YES/NO

    ''' <summary>
    ''' Module level variable for the attribute AgencyID
    ''' </summary>
    Private _AgencyID As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute FileNo
    ''' </summary>
    Private _FileNo As Long = 0

    ''' <summary>
    ''' Module level variable for the attribute ProviderNumber
    ''' </summary>
    Private _ProviderNumber As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute AppKey
    ''' </summary>
    Private _AppKey As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute PollingIntervalInSeconds
    ''' </summary>
    Private _PollingIntervalInSeconds As Integer = 0

    ''' <summary>
    ''' Module level variable for the attribute AllowFileRename
    ''' </summary>
    Private _AllowFileRename As String

    ''' <summary>
    ''' Module level variable for the attribute PollingFldrs
    ''' </summary>
    Private _extPollingFldrs As New Collection

    ''' <summary>
    ''' Module level variable for the attribute TransferDelayInterval
    ''' </summary>
    Private _TransferDelayInterval As Double

    ''' <summary>
    ''' Module level variable that acts more like a constant but is used in this form to facilitate use as a parameter in the Trim method.
    ''' </summary>
    Private _chArr() As Char = {CChar("\")}

    ''' <summary>
    ''' Module level variable for the attribute TraceFlag
    ''' </summary>
    Public Shared _TraceFlag As String = String.Empty

    ''' <summary>
    ''' Module level variable to reference the mailer object
    ''' </summary>
    Public Shared _objMailer As New Mailer

    ''' <summary>
    ''' Module level variable for the attribute EmailSrvrLoc
    ''' </summary>
    Private Shared _EmailSrvrLoc As String

    ''' <summary>
    ''' Module level variable for the attribute EmailSendTo
    ''' </summary>
    Private Shared _EmailSendTo As String

    ''' <summary>
    ''' Module level variable for the attribute EmailSentFrom
    ''' </summary>
    Private Shared _EmailSentFrom As String

    ''' <summary>
    ''' Module level variable for the attribute EmailSubject
    ''' </summary>
    Private Shared _EmailSubject As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute EmailTemplateLoc
    ''' </summary>
    Private Shared _EmailTemplateLoc As String = String.Empty

    ''' <summary>
    ''' Module level variable for the attribute MaxInetAccessTries
    ''' </summary>
    Private Shared _MaxInetAccessTries As Integer = 0

    ''' <summary>
    ''' Module level variable for the attribute IntervalBetweenTries
    ''' </summary>
    Private Shared _IntervalBetweenTries As Integer = 0

    ''' <summary>
    ''' Module level variable for the attribute PauseBeforeFinalWSCheck
    ''' </summary>
    Private Shared _PauseBeforeFinalWSChk As Integer = 0

    'Private _sMainSettingsPath As String
    Private _DRT As WS_FileTransfer

    'End of Application Configuration Parameters

#End Region

#Region "Public Properties"
    ''' <summary>
    ''' File name for the HTML template used in email messages
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared ReadOnly Property EmailTemplateLoc() As String
        Get
            Return _EmailTemplateLoc
        End Get
    End Property

    ''' <summary>
    ''' Location of the application executable for locating the settings file, trace log or AppError log.
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public ReadOnly Property AppPath() As String
        Get
            Return _appPath
        End Get
    End Property

    ''' <summary>
    ''' Amount of time in minutes to wait before final check for NRC webservice availability
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared ReadOnly Property PauseBeforeFinalWSChk() As Integer
        Get
            Return _PauseBeforeFinalWSChk
        End Get
    End Property

    ''' <summary>
    ''' Maximum number of times NRC webservice availability is checked before final pause
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared ReadOnly Property MaxInetAccessTries() As Integer
        Get
            Return _MaxInetAccessTries
        End Get
    End Property

    ''' <summary>
    ''' Number of minutes between each attempt to reach NRC webservice before the final pause
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared ReadOnly Property IntervalBetweenTries() As Integer
        Get
            Return _IntervalBetweenTries
        End Get
    End Property

    ''' <summary>
    ''' Number of minutes after a file is dropped into a polling folder 
    ''' before it is added to the list of files to be sent to NRC. This allows for the client OS to 
    ''' finish writing the file into the polling folder.
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml
    ''' Called by:
    '''   CopyFilesToUploadFolder
    '''   DirTimerElapsed
    ''' </remarks>
    Public Property TransferDelayInterval() As Double
        Get
            Return _TransferDelayInterval
        End Get
        Set(ByVal value As Double)
            _TransferDelayInterval = value
        End Set
    End Property

    ''' <summary>
    ''' Identifier used to sequence the files sent to NRC from the SmartLink client. As soon as the file number is read and assigned to the FileNo property bthen it is incremented and saved back to the setting XML file
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml
    ''' Called by:
    '''   CopyFilesToUploadFolder
    '''   DirTimerElapsed
    ''' </remarks>
    Public ReadOnly Property FileNo() As Long
        Get
            _FileNo = CLng(Settings.GetTransferServiceSetting("FileNumber", "0"))
            'Increment the FileNumber
            _FileNo += 1

            'Save the updated FileNumber back to the settings xml file
            Settings.SetTransferServiceSetting("FileNumber", _FileNo.ToString())

            Return _FileNo
        End Get
    End Property

    ''' <summary>
    ''' List of Polling Folders in addition to the 2 main polling folders 
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property extPollingFldrs() As Collection
        Get
            Return _extPollingFldrs
        End Get
        Set(ByVal value As Collection)
            _extPollingFldrs = value
        End Set
    End Property

    ''' <summary>
    ''' Email address of the sender
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared Property EmailSentFrom() As String
        Get
            Return _EmailSentFrom
        End Get
        Set(ByVal value As String)
            _EmailSentFrom = value
        End Set
    End Property

    ''' <summary>
    ''' Email server loaction, i.e. SMTP1
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared Property EmailSrvrLoc() As String
        Get
            Return _EmailSrvrLoc
        End Get
        Set(ByVal value As String)
            _EmailSrvrLoc = value
        End Set
    End Property

    ''' <summary>
    ''' Email destination address
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared Property EmailSendTo() As String
        Get
            Return _EmailSendTo
        End Get
        Set(ByVal value As String)
            _EmailSendTo = value
        End Set
    End Property

    ''' <summary>
    ''' Email subject line
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Shared Property EmailSubject() As String
        Get
            Return _EmailSubject
        End Get
        Set(ByVal value As String)
            _EmailSubject = value
        End Set
    End Property

    ''' <summary>
    ''' Enable file renaming (allows files to be renamed with time/date stamp and "To_NRC")
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property AllowFileRename() As String
        Get
            Return _AllowFileRename
        End Get
        Set(ByVal value As String)
            _AllowFileRename = value.ToUpper
        End Set
    End Property

    ''' <summary>
    ''' Location of the upload folder
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property Path() As String
        Get
            Return _strPath
        End Get
        Set(ByVal Value As String)
            _strPath = Value
        End Set
    End Property

    ''' <summary>
    ''' Contains the agency M0010
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property AgencyID() As String
        Get
            Return _AgencyID
        End Get
        Set(ByVal Value As String)
            _AgencyID = Value
        End Set
    End Property

    ''' <summary>
    ''' First of 2 main polling paths
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property PollingPath1() As String
        Get
            Return _strPollingPath1
        End Get
        Set(ByVal Value As String)
            _strPollingPath1 = Value
        End Set
    End Property

    ''' <summary>
    ''' Second of 2 main polling paths
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property PollingPath2() As String
        Get
            Return _strPollingPath2
        End Get
        Set(ByVal Value As String)
            _strPollingPath2 = Value
        End Set
    End Property

    ''' <summary>
    ''' The path to the directory that will contain files that generated an error during processing
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property ErrorsDir() As String
        Get
            Return _ErrorsDir
        End Get
        Set(ByVal Value As String)
            _ErrorsDir = Value
        End Set
    End Property

    ''' <summary>
    ''' The path where files are copied to for the purpose of zipping and transmission
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property WorkDir() As String
        Get
            Return _strWorkDir
        End Get
        Set(ByVal Value As String)
            _strWorkDir = Value
        End Set
    End Property

    ''' <summary>
    ''' The path to which files are copied from the polling folder(s) if BackupFiles flag is set to True
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property BackupDir() As String
        Get
            Return _strBackupDir
        End Get
        Set(ByVal Value As String)
            _strBackupDir = Value
        End Set
    End Property

    ''' <summary>
    ''' Coma seperated list of file types (extensions) that should not be processed 
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property ExcludeFileTypes() As String
        Get
            Return _strExcludeFileTypes
        End Get
        Set(ByVal Value As String)
            _strExcludeFileTypes = Value
        End Set
    End Property

    ''' <summary>
    ''' Location of the file that will record successful file transfers
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property EventLogFile() As String
        Get
            Return _strEventLogFile
        End Get
        Set(ByVal Value As String)
            _strEventLogFile = Value
            _objEventLog.EventLogpath = Value
        End Set
    End Property

    ''' <summary>
    ''' Number of secconds between the end of processing 
    ''' a list files from polling folder and beginng of the next folder scan
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property PollingIntervalInSeconds() As Integer
        Get
            Return _PollingIntervalInSeconds
        End Get
        Set(ByVal Value As Integer)
            If Value <> 0 Then
                _PollingIntervalInSeconds = CType(Value, Integer)
            Else
                _PollingIntervalInSeconds = 2
            End If
        End Set
    End Property

    ''' <summary>
    ''' Flag used to determine if an entry will be made in the submitted files log.
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property LogWSFiles() As String
        Get
            Return _LogWSFiles
        End Get
        Set(ByVal value As String)
            _LogWSFiles = value
        End Set
    End Property

    ''' <summary>
    ''' Set this flag to True if you need to keep backup copy of files sent to NRC Web Service
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property BackupFiles() As String
        Get
            Return _BackupFiles
        End Get
        Set(ByVal value As String)
            _BackupFiles = value
        End Set
    End Property

    ''' <summary>
    ''' A 7 character alpha-numeric string to identify who is sending the file
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property ProviderNumber() As String
        Get
            Return _ProviderNumber
        End Get
        Set(ByVal value As String)
            _ProviderNumber = value
        End Set
    End Property

    ''' <summary>
    ''' Encryption code used when ZIPing files
    ''' </summary>
    ''' <remarks>Read from NRC_SLT.Settings.xml</remarks>
    Public Property AppKey() As String
        Get
            Return _AppKey
        End Get
        Set(ByVal value As String)
            _AppKey = value
        End Set
    End Property

    ''' <summary>
    ''' Returns the application's root configuration directory path.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property ConfigPath() As String
        Get
            Return Settings.ConfigRootDirPath
        End Get
    End Property
#End Region

#Region "Public Methods"

    ''' <summary>
    ''' Initializes the Watcher object
    ''' </summary>
    Public Sub New()
        Try
            ' Read in the Application Configuration Parameters from the XML File
            GetApplicationParameters()

            ' Check that the Directories we wish to access are present.  
            ' If not, create them
            Log.WriteTrace("Checking Directories")
            If Not CheckDirectories() Then
                Throw New ApplicationException("Unable to confirm availability of all directories.")
            End If

            _DRT = New WS_FileTransfer(_AppKey, _strWorkDir)

        Catch ex As Exception
            Log.WriteError("Watcher.New - Error: " + ex.Message, ex)
            Throw ex
        End Try

    End Sub

#End Region

#Region "Private Methods"
    ''' <summary>
    ''' Reads the XML settings file and sets application variables
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    Private Sub GetApplicationParameters()
        Dim strProcName As String = "GetApplicationParameters"
        Dim strParamName As String = String.Empty

        '### auggur 09/22/2006 depending on the mode that the application is running it should
        'only require mode specific settings. when deployed as client mode only use relevant
        'settings otherwise it will be hard to troubleshoot once its deployed to clients.
        'notice that shared settings will be left outside the if statement so they get set

        Dim configRootPath As String = Me.ConfigPath

        Try
            ' Get the main "Upload" folder path...
            strParamName = "Path"
            Path = Settings.GetTransferServiceSetting(strParamName).TrimEnd(_chArr)

            ' If the upload folder is not specified in the config,
            ' set it to the application default.
            If Path = "" Or Not System.IO.Directory.Exists(Path) Then
                Path = System.IO.Path.Combine(configRootPath, "FileUpload\Upload")
            End If

            strParamName = "PollingPath1"
            PollingPath1 = Settings.GetTransferServiceSetting("PollingFolder1").TrimEnd(_chArr)
            strParamName = "PollingPath2"
            PollingPath2 = Settings.GetTransferServiceSetting("PollingFolder2").TrimEnd(_chArr)

            strParamName = "ErrorsDir"
            'ErrorsDir = Settings.GetTransferServiceSetting("ErrorsDir")
            ErrorsDir = System.IO.Path.Combine(configRootPath, "FileUpload\Errors")
            strParamName = "WorkDir"
            'WorkDir = Settings.GetTransferServiceSetting("WorkDir")
            WorkDir = System.IO.Path.Combine(configRootPath, "FileUpload\Work")

            strParamName = "BackupFiles"
            BackupFiles = Settings.GetTransferServiceSetting("BackupFiles")
            strParamName = "BackupDir"
            BackupDir = Settings.GetTransferServiceSetting("BackupDir").TrimEnd(_chArr)

            strParamName = "EventLogFile"
            EventLogFile = Settings.GetFilePath2TransferServiceSubmittedFilesLogFile()

            strParamName = "LogWSFiles"
            LogWSFiles = Settings.GetTransferServiceSetting("LogWSFiles")

            strParamName = "ExcludeFileTypes"
            ExcludeFileTypes = Settings.GetTransferServiceSetting(strParamName)

            strParamName = "ProviderNumber"
            ProviderNumber = Settings.GetGeneralSetting(strParamName) ' GENERAL Setting!
            '_objTrace.WriteTrace(True, "ProviderNumber = " & ProviderNumber)

            strParamName = "AppKey"
            AppKey = Settings.GetTransferServiceSetting(strParamName)

            Log.LogTrace(Settings.GetTransferServiceSetting("TraceFlag"))

            strParamName = "PollingIntervalInSeconds"
            PollingIntervalInSeconds = CInt(Settings.GetTransferServiceSetting(strParamName))

            strParamName = "AgencyID"
            _AgencyID = Settings.GetGeneralSetting(strParamName) ' GENERAL Setting

            strParamName = "AllowFileRename"
            _AllowFileRename = Settings.GetTransferServiceSetting(strParamName).ToUpper

            '_objTrace.WriteTrace(True, "AllowFileRename = " & _AllowFileRename)

            strParamName = "TransferDelayInterval"
            _TransferDelayInterval = CType(Settings.GetTransferServiceSetting(strParamName), Integer)
            strParamName = "IntervalBetweenTries"
            _IntervalBetweenTries = CType(Settings.GetTransferServiceSetting(strParamName), Integer)
            strParamName = "MaxInetAccessTries"
            _MaxInetAccessTries = CType(Settings.GetTransferServiceSetting(strParamName), Integer)
            strParamName = "PauseBeforeFinalWSChk"
            _PauseBeforeFinalWSChk = CType(Settings.GetTransferServiceSetting(strParamName), Integer)

            ' Parameters used for EMAIL functionality 
            strParamName = "EmailSrvrLoc"
            _EmailSrvrLoc = Settings.GetGeneralSetting("SMTPServer") ' GENERAL Setting!
            strParamName = "EmailSubject"
            _EmailSubject = "NRC SLT Error Message"
            strParamName = "EmailSendTo"
            _EmailSendTo = Settings.GetGeneralSetting("OperatorEmail") ' GENERAL Setting!
            strParamName = "EmailSentFrom"
            _EmailSentFrom = "support@nationalresearch.com"
            strParamName = "EmailTemplateLoc"

            ' The email template file is expected to be located 
            ' in the application's root directory (not the config root directory).
            _EmailTemplateLoc = System.IO.Path.Combine(
                My.Application.Info.DirectoryPath, "\NRC_SLT_err_email_tmplt.htm")

            ' Assign email parameters to mailer object
            With _objMailer
                .SrvrLoc = _EmailSrvrLoc
                .Subject = _EmailSubject
                .SendTo = EmailSendTo
                .SentFrom = _EmailSentFrom
                .HTMLTemplateLoc = _EmailTemplateLoc
            End With

            ' Validate parameter values, as entered into settings file,
            ' to prevent errors related to out of range exceptions
            If _MaxInetAccessTries < 1 Then _MaxInetAccessTries = 1
            If _IntervalBetweenTries < 1 Then _IntervalBetweenTries = 1
            If _PauseBeforeFinalWSChk < 1 Then _PauseBeforeFinalWSChk = 1

            ' Get the polling folder locations from the config file.
            Dim pollingFolders() As String = Settings.GetTransferServicePollingFolders()
            If pollingFolders IsNot Nothing AndAlso pollingFolders.Count() > 0 Then
                For Each folder As String In pollingFolders
                    _extPollingFldrs.Add(folder)
                Next
            End If

        Catch ex As Exception
            Log.WriteError("GetApplicationParameters - Error: " & strParamName & " " & ex.Message, ex)
        End Try
    End Sub

    Private Sub CreateBackupFile(ByVal FileName As String)
        Dim sDateTime As String
        Dim tempExt As String
        Dim sShortFileName As String
        Dim sBackupFileName As String = String.Empty

        Try
            'Use this string version of the double data type equivalent for NOW() to ensure unique file name
            sDateTime = Now.ToString("yyyyMMddHHmmss") 'CType(CType(Now.ToOADate(), Double), String)
            tempExt = "." & Watcher.GetFileExtension(FileName)

            sShortFileName = Left(Watcher.GetJustFileName(FileName),
                            InStr(Watcher.GetJustFileName(FileName), ".") - 1) & "_" & sDateTime & tempExt

            sBackupFileName = BackupDir.Trim(_chArr) + "\" + sShortFileName

            Log.WriteError("Backing up the file: " + FileName + " TO: " + sBackupFileName)
            System.IO.File.Copy(FileName, sBackupFileName, True)

        Catch ex As Exception
            Log.WriteError("ERROR: 1061 - Error Attempting to backup file - " +
                                 FileName + " TO: " + sBackupFileName + vbCrLf + ex.Message, ex)
        End Try
    End Sub


    ''' <summary>
    ''' Determine if the directory paths exists and if not create them
    ''' </summary>
    ''' <remarks>Checks for the application, error and work directories</remarks>
    ''' <returns>Success or Failure</returns>
    Private Function CheckDirectories() As Boolean

        Dim strProcName As String = "CheckDirectories"

        ' Determine if the directory paths exists and if not create them
        Log.WriteTrace("Path: " + Path)
        If Path.Length > 0 Then
            Try
                If Not My.Computer.FileSystem.DirectoryExists(Path) Then
                    My.Computer.FileSystem.CreateDirectory(Path)
                End If
                '_objTrace.WriteTrace(_TraceME, "Path: " + Path + " is accessible.")
            Catch ex As Exception
                Log.WriteError("CheckDirectories - ERROR: 1039 - Can not access Path Dir: " + Path + " : " + ex.Message, ex)
                Return False
            End Try
        Else
            Log.WriteError("CheckDirectories - ERROR: 1040 - Path Parameter missing")
        End If

        Log.WriteTrace("ErrorsDir: " + ErrorsDir)
        If ErrorsDir.Length > 0 Then
            Try
                If Not My.Computer.FileSystem.DirectoryExists(ErrorsDir) Then
                    My.Computer.FileSystem.CreateDirectory(ErrorsDir)
                End If
                '_objTrace.WriteTrace(_TraceME, "ErrorsDir: " + ErrorsDir + " is accessible.")
            Catch ex As Exception
                Log.WriteError("ERROR: 1039 - Can not access Errors Dir" + " : " + ex.Message, ex)
                Return False
            End Try
        Else
            Log.WriteError("ERROR: 1040 - ErrorsDir Parameter missing")
        End If


        Log.WriteTrace("BackupDir: " + BackupDir)

        If BackupFiles.ToUpper().StartsWith("Y") Then
            If BackupDir.Length > 0 Then
                Try
                    If Not My.Computer.FileSystem.DirectoryExists(BackupDir) Then
                        My.Computer.FileSystem.CreateDirectory(BackupDir)
                    End If
                Catch ex As Exception
                    Log.WriteError("ERROR: 1031 - Can not access Backup Dir" + " : " + ex.Message, ex)
                    Return False
                End Try
            Else
                Log.WriteError("ERROR: 1037 - Backup Dir Parameter missing")
            End If
        End If

        Log.WriteTrace("WorkDir: " + WorkDir)
        If WorkDir.Length > 0 Then
            Try
                If Not My.Computer.FileSystem.DirectoryExists(WorkDir) Then
                    My.Computer.FileSystem.CreateDirectory(WorkDir)
                End If
            Catch ex As Exception
                Log.WriteError("ERROR: 1032 - Can not access Work Dir" + " : " + ex.Message, ex)
                Return False
            End Try
        Else
            Log.WriteError("ERROR: 1038 - Work Dir Parameter missing")
        End If

        Return True

    End Function

    ''' <summary>
    ''' This strips out the path and extension
    ''' </summary>
    ''' This strips out just the filename from a full path
    ''' <param name="TheCompletePath">Full path and filename</param>
    ''' <returns>Just the filename</returns>
    Public Shared Function GetJustFileName(ByVal TheCompletePath As String) As String

        ' Isn't this what you really want to use?  (i.e. C:\MyDirectory\MyFile.txt returns "MyFile")
        ' Return System.IO.Path.GetFileName(TheCompletePath)
        ' OR Return System.IO.Path.GetFileNameWithoutExtension(TheCompletePath)

        Dim i As Integer = Len(TheCompletePath)
        Dim TheFileCharacter As String

        GetJustFileName = String.Empty
        For i = Len(TheCompletePath) To 1 Step -1
            TheFileCharacter = Mid(TheCompletePath, i, 1)
            If TheFileCharacter <> "\" Then
                GetJustFileName = TheFileCharacter & GetJustFileName
            Else
                i = 1
            End If
        Next
    End Function

    ''' <summary>
    ''' This strips off the filename and extension and returns the path
    ''' </summary>
    ''' This strips out just the path from a full path and filename
    ''' <param name="TheCompletePath">Returns just the path</param>
    Public Shared Function GetJustPath(ByVal TheCompletePath As String) As String
        '### auggur 10/03/2006 updated code in this function shorten code and make
        'the function more accurate.
        GetJustPath = TheCompletePath.Substring(0, TheCompletePath.Length - My.Computer.FileSystem.GetName(TheCompletePath).Length)

    End Function



    ''' <summary>
    ''' This strips out the filename and returns the extension
    ''' </summary>
    Public Shared Function GetFileExtension(ByVal TheFileName As String) As String
        Dim i As Integer = Len(TheFileName)
        Dim TheFileCharacter As String

        GetFileExtension = String.Empty

        For i = Len(TheFileName) To 1 Step -1
            TheFileCharacter = Mid(TheFileName, i, 1)
            If TheFileCharacter <> "." Then
                GetFileExtension = TheFileCharacter & GetFileExtension
            Else
                i = 1
            End If
        Next
        '### auggur 08/23/2006 Return UNKNOWN for files that come in without extension
        If GetFileExtension = TheFileName Then
            GetFileExtension = "UNKNOWN"
        End If
    End Function

#End Region

#Region "Web Service Handler"

    '''' <summary>
    '''' This function kicks off the file transfer process by preparing the file, 
    '''' instansiating the FileTranfer object and invoking its WSFileTransfer method
    '''' and finally cleaning up in preparation for the next file.
    '''' </summary>
    '''' <param name="sFullFileName">Full path of the file once it has been processed</param>
    '''' <returns>Indicates success or failure</returns>
    '''' <remarks>
    '''' 1) If the user has requested a backup, then backup the file
    '''' 2) Validate provider number and create time/date stamp in form of data type double 
    '''' 3) Compress and encrypt the file with the ZipFile method
    '''' 4) Initialize web service object and transfer the file with the WSFileTransfer method
    '''' 5) Delete the zip/encrypted file from the Work Directory
    '''' 6) If the user requested logging, then log the file transfer
    '''' 7) Delete the file from the Upload folder.
    '''' </remarks>

    Public Function TransferTheFile(ByVal sFullFileName As String) As Boolean
        If File.Exists(sFullFileName) Then
            Dim iTryCount As Integer = 0
            Dim bTryAgain As Boolean = True

            'Create backup file
            If Me.BackupFiles.ToUpper = "YES" Or Me.BackupFiles.ToUpper = "TRUE" Then
                CreateBackupFile(sFullFileName)
            End If

            Do While bTryAgain
                Try
                    'Send File
                    If _DRT.TransmitData(sFullFileName) Then
                        LogFile(sFullFileName)

                        'Delete file after successfull transfer
                        If System.IO.File.Exists(sFullFileName) = True Then
                            Do While HasExclusiveAccess(sFullFileName, 3) = False
                                System.Threading.Thread.Sleep(500)
                            Loop
                            System.IO.File.Delete(sFullFileName)
                        End If
                        Return True
                    End If
                    bTryAgain = False
                Catch ex As Exception
                    iTryCount += 1
                    If iTryCount > 3 Then
                        bTryAgain = False
                        Log.WriteError("There was a problem sending the file", ex)
                        Return False
                    End If
                End Try

                If bTryAgain Then
                    System.Threading.Thread.Sleep(New TimeSpan(0, 1, 0))
                End If
            Loop
        Else
            Return False
        End If
    End Function

    Private Shared Function HasExclusiveAccess(ByVal FileName As String, ByVal WaitInSeconds As Integer) As Boolean
        'Checks to see if no other application is using the file before performing
        'any operations on it. Specifically when a file is still being copied over into the 
        'data directory.
        Dim blnResult As Boolean
        Dim intTries As Integer

        Dim FI As FileInfo

        blnResult = False
        If IO.File.Exists(FileName) Then

            FI = New IO.FileInfo(FileName)
            If FI.IsReadOnly Then
                FI.Attributes = FileAttributes.Normal
            End If

            While blnResult = False And intTries < WaitInSeconds
                Try
                    Dim fs As New FileStream(FileName, FileMode.Append, FileAccess.Write, FileShare.None)
                    fs.Close()
                    blnResult = True
                    Exit While
                Catch
                    blnResult = False
                    intTries += 1
                    Thread.Sleep(1000)
                End Try
            End While
        Else
            Throw New System.Exception("Invalid FileName" & vbCrLf & vbCrLf & "The current File does not exist")
        End If
        Return blnResult
    End Function

    Private Sub LogFile(ByVal FileName As String)
        Dim msg As New StringBuilder()

        Try
            If LogWSFiles.ToLower = _YES.ToLower Then
                Log.WriteTrace("Creating the Event Log: ")
                msg.Remove(0, msg.Length)
                msg.Append(GetJustFileName(FileName) + " was")

                msg.Append(" uploaded to the web Service")

                _objEventLog.LogToFile("NRC_SLT", msg.ToString)
            End If

        Catch ex As Exception
            'Since there was an error writing to the Trace log we will write to the AppEvent log
            _objEventLog.LogToFile(_AppName, "Error Creating the Event Log: " + ex.Message)
        End Try
    End Sub

#End Region

    Protected Overrides Sub Finalize()
        Array.Clear(_chArr, 0, 1)
        MyBase.Finalize()
    End Sub
End Class
