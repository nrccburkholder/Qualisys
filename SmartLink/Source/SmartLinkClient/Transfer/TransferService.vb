Imports System.Collections.ObjectModel
Imports NRC.SmartLink.Common
Imports NRC.SmartLink.Transfer.Lib

Public Class TransferService

#Region "PrivateTypes"
    Private Enum WebConnectionStatus
        ConnectionAvailable = 0
        WebServiceUnavailable = 1
        PossibleProxyIssue = 2
        PossibleNetworkIssue = 3
        PossibleDNSIssue = 4
        NoInternetConnection = 5
    End Enum
#End Region

#Region "Private Variables"

    ''' <summary>
    ''' ReadOnly constant that contains the name of this class
    ''' </summary>
    ReadOnly _CLASSNAME As String = "TransferService.vb"

    Private WithEvents _ObjWatcher As Watcher

    ''' <summary>
    ''' Location of the upload folder
    ''' </summary>
    ''' <remarks>Module level variable based on the value returned from the Watcher:GetApplicationParameters method</remarks>
    Private _Path As String = String.Empty
    ''' <summary>
    ''' Module level array variable that contains the list of polling folder
    ''' </summary>
    ''' <remarks>in addition to the main polling1 and polling2</remarks>
    Private _extPollingPaths() As String
    ''' <summary>
    ''' Module level variable to hold the number of folders that are in the extended polling folder array
    ''' </summary>
    Private _extPollingFldrsCount As Integer = 0
    ''' <summary>
    ''' The path to the directory that will contain files that generated an error during processing.
    ''' </summary>
    ''' <remarks>Module level variable based on the value returned to Watcher:GetApplicationParameters method</remarks>
    Private _ErrorsDir As String = String.Empty
    ''' <summary>
    ''' Timer object that triggers a scan of all polling folders
    ''' </summary>
    ''' <remarks>The list of scanned folders should include the Upload, Polling folders 1 and 2 and all folders in the extended polling folders array.</remarks>
    Private _DirTimer As New System.Timers.Timer
    ''' <summary>
    ''' This module level variable used to store the body message for any email sent to the user.
    ''' </summary>
    ''' <remarks>It is primarily used as a convienience to have one variable used for any email message required by any procedure in the class.</remarks>
    Private _EmailBody As String = String.Empty
    ''' <summary>
    ''' Location of one of the main polling folders
    ''' </summary>
    ''' <remarks>Module level variable based on the value returned from Watcher:GetApplicationParameters method</remarks>
    Private _PollingPath1 As String = String.Empty
    ''' <summary>
    ''' Location of one of the main polling folders
    ''' </summary>
    ''' <remarks>Module level variable based on the value returned from the Watcher:GetApplicationParameters method</remarks>
    Private _PollingPath2 As String = String.Empty
    ''' <summary>
    ''' The path to which files are copied from the polling folder(s) if BackupFiles flag is set to True
    ''' </summary>
    ''' <remarks>Module level variable based on the value returned to Watcher:GetApplicationParameters method</remarks>
    Private _BackupDir As String = String.Empty
    ''' <summary>
    ''' Module level variable used as the parameter for the TrimEnd method of the System.String class
    ''' </summary>
    ''' <remarks>The parameter must be an array of characters. So to facilitate writing the code for TrimEnd method this array variable is utilized.</remarks>
    Private _chArr() As Char = {CChar("\")}
    ''' <summary>
    ''' Module level variable for the attribute ErrorLogFile
    ''' </summary>
    ''' <remarks>Based on the value returned to Watcher:GetApplicationParameters method</remarks>
    Private _ErrorLogFile As String

    ''' <summary>
    ''' Module level variable set to an instance of the NRC_EMail class
    ''' </summary>
    ''' <remarks>The NRC_EMail class is embedded in this project.</remarks>
    Private _objMailer As New Mailer


#End Region

#Region "Public Variables"

    ''' <summary>
    ''' Module level variable set to an instance of NRCEventLog
    ''' </summary>
    Public Shared _objEventLog As New NRCEventLog
    ''' <summary>
    ''' Application name derived from assembly information
    ''' </summary>
    Public Shared _AppName As String = String.Empty 'My.Application.Info.Title 'FileVersionInfo.GetVersionInfo(System.Reflection.Assembly.GetExecutingAssembly.Location).ProductName


#End Region 'Public Variables

    Protected Overrides Sub OnStart(ByVal args() As String)
        Log.LogTrace(Settings.ConvertToBool(Settings.GetTransferServiceSetting("TraceFlag", "False")))
        Settings.CurrentServiceName = Settings.TRANSFER_SVC_NAME

        ' Debug code -- gives 10 seconds to attach to the service when debugging.
#If CONFIG = "Debug" Then
        System.Threading.Thread.Sleep(15000)
        'System.Diagnostics.Debugger.Break() ' Works pretty good!
#End If
        ' _AppName is often used as an EventSource when writing to the event log.
        ' Event sources are automatically registered on the computer by the service's deployment project.
        ' If the event source is not registered on the computer an error will occur
        ' writing to the event log so we set the _AppName to the name of the service here.
        _AppName = Me.ServiceName

        Dim msg As String = String.Empty

        If Settings.ConvertToBool(Settings.GetTransferServiceSetting("IsActivated", "False")) Then
            Log.WriteInfo("The NRC SmartLink Transfer Service starting time: " & Now().ToString())
            StartUp()
        Else
            Log.WriteInfo("The NRC SmartLink Transfer service is not currently configured " &
                "as activated. The service may have started successfully but " &
                "no actions will be performed.")
        End If
    End Sub

    Protected Overrides Sub OnStop()
        ' Add code here to perform any tear-down necessary to stop your service.

        EventLog.WriteEntry(_AppName & " - Stopping Time: " &
            Now(), EventLogEntryType.Information)

        _ObjWatcher = Nothing

    End Sub

    ''' <summary>
    ''' Create the new Watcher Class and extract some application parameters for later initialization
    ''' </summary>
    Private Sub StartUp()

        Dim strProcName As String = "StartUp"
        Dim sMsg As String = String.Empty
        Dim sCaption As String = String.Empty
        Dim intI As Integer = 1
        Dim sFullFileName As String = String.Empty

        Try
            Log.WriteTrace("Initializing Watcher object.")

            ' Create the watcher instance.
            _ObjWatcher = New Watcher()

            ' The watcher loads configuration data when it is instantiated so the 
            ' Transfer service will just copy the config data from the Watcher instance.

            _Path = _ObjWatcher.Path
            _ErrorsDir = _ObjWatcher.ErrorsDir
            _PollingPath1 = _ObjWatcher.PollingPath1
            _PollingPath2 = _ObjWatcher.PollingPath2
            _BackupDir = _ObjWatcher.BackupDir
            _extPollingFldrsCount = _ObjWatcher.extPollingFldrs.Count

            'Use the properties of the Watcher object to initialize the Mail object for SLT
            With _objMailer
                .HTMLTemplateLoc = Watcher.EmailTemplateLoc
                .MsgPriority = Net.Mail.MailPriority.High
                .SendTo = Watcher.EmailSendTo
                .SentFrom = Watcher.EmailSentFrom
                .SrvrLoc = Watcher.EmailSrvrLoc
                .Subject = Watcher.EmailSubject
            End With

            ReDim _extPollingPaths(_extPollingFldrsCount)

            sCaption = "NRC SmartLink Transfer service startup problem"

            '### thopow 08/20/2007 DevHI #4614 - Enable service to identify files already sent to NRC web service 
            '    without renaming files and to prevent re-sending ones that already were sent and renamed with "_To_NRC"
            '    after the AllowFileRename setting has been switched to "No"

            '### thopow 08/12/2007 DevHI #4579 - Enable the SLT service to have more than just 2 polling folders
            Try
                For intI = 1 To _extPollingFldrsCount
                    _extPollingPaths(intI) = CStr(_ObjWatcher.extPollingFldrs(intI))

                    '### thopow 09/12/2007 DevHI#4675 Error when setting extended polling folders to drives or other Polling Paths
                    If Replace(_extPollingPaths(intI), "/", "\").Trim(_chArr).Length < 3 Then
                        Throw (New Exception("The NRC SLT service has been stopped because the extended polling folder, " & _extPollingPaths(intI) & ", cannot be the root folder of a drive."))
                    ElseIf Replace(_extPollingPaths(intI), "/", "\") = Replace(_PollingPath1, "/", "\") Then
                        Throw (New Exception("The NRC SLT service has been stopped because the extended polling folder, " & _extPollingPaths(intI) & ", cannot be the same as Polling Path 1."))
                    ElseIf Replace(_extPollingPaths(intI), "/", "\") = Replace(_PollingPath2, "/", "\") Then
                        Throw (New Exception("The NRC SLT service has been stopped because the extended polling folder, " & _extPollingPaths(intI) & ", cannot be the same as Polling Path 2."))
                    ElseIf Replace(_extPollingPaths(intI), "/", "\") = Replace(_Path, "/", "\") Then
                        Throw (New Exception("The NRC SLT service has been stopped because the extended polling folder, " & _extPollingPaths(intI) & ", cannot be the same as the Main Polling Path."))
                    ElseIf Replace(_extPollingPaths(intI), "/", "\") = Replace(_BackupDir, "/", "\") Then
                        Throw (New Exception("The NRC SLT service has been stopped because the extended polling folder, " & _extPollingPaths(intI) & ", cannot be the same as the backup path."))
                    End If
                    '### thopow 09/12/2007

                    If Not System.IO.Directory.Exists(_extPollingPaths(intI)) Then
                        System.IO.Directory.CreateDirectory(_extPollingPaths(intI))
                    End If

                    If Not VerifyPathPermissions(_extPollingPaths(intI)) Then
                        Me.Stop()
                    End If
                Next

                Log.WriteTrace("Found " & _extPollingFldrsCount.ToString & " additional polling folders.")

            Catch ex As Exception
                Log.WriteError("An error has caused NRC SmartLink Transfer service to stop: " + ex.Message +
                                     "Contact your network administrator or NRC for assistance.", ex)
                _objMailer.SendEmail("ERROR: (StartUP) ", ex)
                Me.Stop()
            End Try

            Dim dirValues As String() = New String() {_Path, _ObjWatcher.WorkDir, _ObjWatcher.BackupDir, _ErrorsDir}
            Dim dirNames As String() = New String() {"upload", "working", "backup", "errors"}

            For i As Integer = 0 To dirValues.Length - 1
                '### auggur 10/23/2006 check the Upload folder, work folder, backup folder, and errors folder.
                'to make sure they are set to local directories.
                ' Changed by: thopow at: 6/22/2007-14:22:51 See DevHI#4343
                If InStr(dirValues(i), "\\") > 0 Then
                    Log.WriteError("An error has caused NRC SmartLink Transfer service to stop: " +
                                         dirNames(i) + " folder location should be local, not a network path. " +
                                         "Contact your network administrator or NRC for assistance.")
                    'Event log and msgbox can better utilize multi-line text format
                    Dim msg As String = _AppName & " - ERROR: (StartUP) " + dirNames(i) +
                                "folder location should be local, not a network path. " &
                                vbCrLf & dirValues(i)
                    _objMailer.SendEmail(msg)
                    Me.Stop()
                Else
                    If Not dirNames(i).Equals("backup") OrElse _ObjWatcher.BackupFiles.ToUpper = "YES" Then
                        If Not VerifyPathPermissions(dirValues(i)) Then
                            Log.WriteTrace("Couldn't verify permissions for " & dirNames(i) & " directory: " & dirValues(i) & ", stopping.")
                            Me.Stop()
                        End If
                    End If
                End If
            Next

            'Be sure that email messages get sent with high priority
            _objMailer.MsgPriority = Net.Mail.MailPriority.High

        Catch ex As Exception
            _objMailer.SendEmail("An error has caused NRC SmartLink Transfer service to stop: " + ex.Message +
                                "Contact your network administrator or NRC for assistance.", ex)
            Log.WriteError("An error has caused NRC SmartLink Transfer service to stop: " + ex.Message +
                                "Contact your network administrator or NRC for assistance.", ex)
            Me.Stop()
        End Try


        Try
            '### auggur 12/05/2008 added check to see if the a polling path has been selected.
            If _ObjWatcher.PollingPath1 <> String.Empty Then
                If Not System.IO.Directory.Exists(_ObjWatcher.PollingPath1) Then
                    If Not VerifyPathPermissions(_ObjWatcher.PollingPath1, True) Then
                        Me.Stop()
                    End If
                End If
            End If

            '### auggur 12/05/2008 added check to see if the a polling path has been selected.
            If _ObjWatcher.PollingPath2.ToString.Trim <> "" Then
                If Not System.IO.Directory.Exists(_ObjWatcher.PollingPath2) Then
                    If Not VerifyPathPermissions(_ObjWatcher.PollingPath2, True) Then
                        Me.Stop()
                    End If
                End If
            End If

        Catch ex As Exception
            _objMailer.SendEmail("An error has caused NRC SmartLink Transfer service to stop " +
                                 "while verifying permissions for polling folders: " + ex.Message +
                                 "Contact your network administrator or NRC for assistance.", ex)
            Log.WriteError("An error has caused NRC SmartLink Transfer service to stop " +
                                 "while verifying permissions for polling folders: " + ex.Message +
                                 "Contact your network administrator or NRC for assistance.", ex)
            Me.Stop()
        End Try

        'Initialize Timer
        Log.WriteTrace("Initialize timer events and start timer.")
        AddHandler _DirTimer.Elapsed, AddressOf DirTimerElapsed
        _DirTimer.Interval = New TimeSpan(0, 0, _ObjWatcher.PollingIntervalInSeconds).TotalMilliseconds
        _DirTimer.Enabled = True


        ' Start Watcher Timer
        _DirTimer.Start()
    End Sub

#Region "check file to see if operations can be performed"

    ''' <summary>
    ''' Create test file to see if required operations can be performed in designated directory i.e. permission level is sufficient
    ''' </summary>
    ''' <param name="DirPath">The directory path that is to bechecked</param>
    ''' <param name="IsPolling">Flag used to determine if we need to test the Modify capability which is required for renaming a file</param>
    Public Function VerifyPathPermissions(ByRef DirPath As String, Optional ByVal IsPolling As Boolean = False) As Boolean

        Dim strProcName As String = "VerifyPathPermissions"

        Try
            If (DirPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.ProgramFiles) _
                Or DirPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.System) _
                Or DirPath.ToUpper Like "*WINDOWS*" _
                Or DirPath.ToUpper Like "*WINNT*") _
                Or DirPath Like System.Environment.SystemDirectory & "*" Then

                Throw New Exception("VerifyPathPermissions: The polling path, " & DirPath &
                                    ", cannot be the same as a folder " &
                                    "that is restricted by the Operating System")
            End If

            '_objTrace.WriteTrace(True, "Current Path is " & DirPath)
            If System.IO.Directory.Exists(DirPath) Then
                'Create a test file and rename it.
                With My.Computer.FileSystem
                    If IsPolling Then
                        'This will test the Modify capability which is required for renaming a file
                        .CreateDirectory(DirPath & "\TestFolder")
                        .DeleteDirectory(DirPath & "\TestFolder", FileIO.DeleteDirectoryOption.DeleteAllContents)
                    End If

                    If .FileExists(DirPath & "\Test_Rename.txt") Then
                        .DeleteFile(DirPath & "\Test_Rename.txt")
                    End If

                    If .FileExists(DirPath & "\Test.txt") Then
                        .DeleteFile(DirPath & "\Test.txt")
                    End If

                    .WriteAllText(DirPath & "\Test.txt", "This is text for a test file", False)
                    .RenameFile(DirPath & "\Test.txt", "Test_Rename.txt")
                    .DeleteFile(DirPath & "\Test_Rename.txt")
                End With

                Return True
                '_objTrace.WriteTrace(True, "Verified Path  is " & DirPath)
            End If
            '_objTrace.WriteTrace(True, "Verified Path  is " & DirPath)


        Catch ex As System.Exception

            'If an error occurs then notify user that the folder has insufficient permissions

            DirPath = DirPath.TrimEnd(_chArr)

            If My.Computer.FileSystem.FileExists(DirPath & "\Test.txt") Then
                My.Computer.FileSystem.DeleteFile(DirPath & "\Test.txt")
            End If

            ' Handle exception here
            Dim sMsg As String
            sMsg = "NRC SmartLink Transfer service does not have permission" & vbCrLf &
                    "to perform the required file operations." & vbCrLf & vbCrLf &
                    "Access is denied to the directory, " & vbCrLf & DirPath & vbCrLf & vbCrLf &
                    "Please contact your system administrator."

            Log.WriteError(sMsg, ex)
            Return False
        End Try

    End Function

    ''' <summary>
    ''' Checks the file to see if another process has initiated a file lock.
    ''' </summary>
    ''' <param name="Filename">The name and location of the file to be tested for availability</param>
    ''' <param name="WaitInSeconds">The interval used between retesting for availability</param>
    Public Shared Function HasExclusiveAccess(ByVal Filename As String, Optional ByVal WaitInSeconds As Integer = 5) As Boolean
        'Checks to see if no other application is using the file before performing
        'any operations on it. Specifically when a file is still being copied over into the 
        'data directory.
        Dim blnResult As Boolean
        Dim intTries As Integer
        'Dim sMsg As String
        Dim fs As System.IO.FileStream = Nothing

        'if the file does not exist there is no need to do this check
        If Not System.IO.File.Exists(Filename) Then
            Return True
        End If

        While blnResult = False And intTries < WaitInSeconds
            Try
                fs = New System.IO.FileStream(Filename, FileMode.Append, FileAccess.Write, FileShare.None)
                blnResult = True
                Exit While
            Catch ex As Exception
                blnResult = False
                intTries += 1
                System.Threading.Thread.Sleep(1000)
            Finally
                If fs IsNot Nothing Then
                    fs.Close()
                    fs.Dispose()
                    fs = Nothing
                End If
            End Try
        End While

        Return blnResult

    End Function

#End Region

#Region "Directory Polling Routines"


    ''' <summary>
    ''' Copies any files from the extra polling folders that were selected by the user
    ''' </summary>
    ''' <param name="sPollingPath">Full filename and path of the file to be sent.</param>
    ''' <remarks>Note that after copying the files down to the upload folder the file will be renamed by adding the following suffix "_ToNRC" plus datetime stamp or be tagged with a custom property by Edanmo.OLEStorage project.
    ''' Called by:
    '''   CopyFilesToUploadFolder
    ''' </remarks>

    Private Sub CopyFilesToUploadFolder(ByVal sPollingPath As String)

        'This procedure copies any files from the extra polling folders that were selected
        'by the user, note that after copying the files down to the upload folder the file
        'will be renamed by adding the following suffix "_ToNRC" plus datetime stamp.
        Dim strProcName As String = "CopyFilesToUploadFolder"
        Dim sFullFileName As String = String.Empty
        Dim sNewFullFileName As String = String.Empty
        Dim sFileNm_DTstamp As String = String.Empty
        Dim sExcludeFileTypes As String = String.Empty
        ' This array will hold all of the files in the polling directory
        Dim ImportFiles As ReadOnlyCollection(Of String)
        ' This will put all of the files in the current directory into the
        ' ImportFiles array
        Dim enFiles As System.Collections.IEnumerator
        Dim sDateTime As String = String.Empty
        Dim sRnamedFileFullPath As String = String.Empty
        Dim sFNameExt As String = String.Empty
        Dim sShortFName As String = String.Empty

        'check to make sure that extra polling directories have been chosen and that they in fact exist.
        Try
            If sPollingPath.Trim.Length = 0 Then
                Exit Sub
            End If
            If Not My.Computer.FileSystem.DirectoryExists(sPollingPath) Then
                Exit Sub
            End If
            ' Get any available files in the polling directory
            ImportFiles = My.Computer.FileSystem.GetFiles(sPollingPath, FileIO.SearchOption.SearchTopLevelOnly, "*.*")
            enFiles = ImportFiles.GetEnumerator

            '### auggur 10/30/2006 get the list file types to exclude from upload
            'including the key word for uploaded files "_ToNRC"
            sExcludeFileTypes = _ObjWatcher.ExcludeFileTypes

            While enFiles.MoveNext
                sFullFileName = enFiles.Current.ToString

                'Before checking for ExclusiveAccess we need to be sure that the Read-Only 
                'file Attribute has not been set because this would cause the 
                'HasExclusiveAccess() function to get stuck in a continuous loop.
                If (File.GetAttributes(sFullFileName) And FileAttributes.ReadOnly) = FileAttributes.ReadOnly Then
                    Throw (New Exception("Cannot process Read-Only files, " & sFullFileName & "."))
                End If

                'These WriteTrace calls are to assist with debugging
                '_objTrace.WriteTrace(True, CStr(sFullFileName & " has '_ToNRC' in the filename = " & _
                '                    (InStr(Watcher.GetJustFileName(sFullFileName), "_ToNRC") > 0)))

                '_objTrace.WriteTrace(True, CStr(sFullFileName & " has been tagged with custom property = " & _
                '                    FileHasNRC_TrxfrProp(sFullFileName)))

                '_objTrace.WriteTrace(True, CStr(sFullFileName & " has an excluded file type in the filename extension = " & _
                '                    (InStr(Watcher.GetFileExtension(sFullFileName), sExcludeFileTypes) > 0)))

                'Use this string version of the double data type equivalent for NOW() to ensure unique file name
                sDateTime = CType(CType(Now.ToOADate(), Double), String)
                sDateTime = Replace(sDateTime, ".", "_")


                '### auggur 10/30/2006 only copy file types that have not been previously uploaded to NRC
                If InStr(Watcher.GetJustFileName(sFullFileName), "_ToNRC") > 0 _
                        OrElse InStr(Watcher.GetFileExtension(sFullFileName), sExcludeFileTypes) > 0 _
                        OrElse FileHasNRC_TrxfrProp_ADS(sFullFileName) Then
                    'or if the file extension matches one of the excluded extensions
                    'or the file has already been tagged with the custom property, NRC_TrxfrDate
                    'Then skip the current file and let the While enFiles.MoveNext method advance to the next file
                Else
                    'Delay processing by amount of TransferDelayInterval
                    Dim dtLastModDate As Date = File.GetLastWriteTime(sFullFileName)
                    Dim dtCurrentDateTime As Date = Now
                    'Use this trace statement for debug purposes
                    '_objTrace.WriteTrace(True, "Last Mod Date = " & dtLastModDate & _
                    '                            "; Mod date + " & _ObjWatcher.TransferDelayInterval.ToString & _
                    '                            " minutes = " & dtLastModDate.AddMinutes(_ObjWatcher.TransferDelayInterval) & _
                    '                            "; Current Date = " & dtCurrentDateTime & _
                    '                            "; ((Mod Date + interval) < Current time) = " & (dtLastModDate.AddMinutes(_ObjWatcher.TransferDelayInterval) < dtCurrentDateTime))

                    If dtLastModDate.AddMinutes(_ObjWatcher.TransferDelayInterval) < dtCurrentDateTime Then
                        'branching code here dependent on AllowFileNameChanges setting
                        If _ObjWatcher.AllowFileRename.ToUpper = "YES" Then

                            If Watcher.GetJustFileName(sFullFileName).Length > 175 Then
                                'The file name is too long so that when it gets renamed, 
                                'by appending a date-time stamp, it will raise an exception 
                                'as it gets copied to the Upload folder

                                sShortFName = Watcher.GetJustFileName(sFullFileName)
                                sFNameExt = Watcher.GetFileExtension(sShortFName)
                                Replace(sShortFName, sFNameExt, String.Empty)
                                sShortFName = Left(sShortFName, 175) & "." & sFNameExt

                                Do While HasExclusiveAccess(sFullFileName, 5) = False
                                    'wait until the file is free for renaming
                                Loop

                                'Rename to shortened version of the file name
                                My.Computer.FileSystem.RenameFile(sFullFileName, sShortFName)

                                Log.WriteInfo("A file with a very long file name was found, " &
                                      Watcher.GetJustPath(sFullFileName) &
                                     ". The filename has been shortened to, " & sShortFName & ", " &
                                     "and normal processing has resumed.")

                                'now set the sFullFileName to the shortened file name.
                                sFullFileName = Watcher.GetJustPath(sFullFileName) & "\" & sShortFName

                            End If

                            'Build the new filename to be used as the destination filename when copied to UpLoadFldr
                            sFileNm_DTstamp = Watcher.GetJustFileName(sFullFileName).Replace(Watcher.GetFileExtension(sFullFileName), "")
                            If Right$(sFileNm_DTstamp, 1) = "." Then
                                'Remove trailing period
                                sFileNm_DTstamp = Left$(sFileNm_DTstamp, sFileNm_DTstamp.Length - 1)
                            End If
                            sFileNm_DTstamp = sFileNm_DTstamp & "_" & sDateTime

                            '### auggur 10/10/2006 
                            'check to make sure the file is completely copied over and that file operations
                            'can be performed on it before proceeding.
                            If System.IO.File.Exists(sFullFileName) = True Then
                                Do While HasExclusiveAccess(sFullFileName, 5) = False
                                    'do nothing
                                Loop

                                '### auggur 09/22/2006 added code to delete any spaces in the file name
                                If InStr(Watcher.GetJustFileName(sFullFileName), " ") > 0 Then
                                    My.Computer.FileSystem.RenameFile(sFullFileName, Watcher.GetJustFileName(sFullFileName).Replace(" ", "_"))
                                    sFullFileName = Watcher.GetJustPath(sFullFileName) & Watcher.GetJustFileName(sFullFileName).Replace(" ", "_")
                                End If

                                '### auggur 10/03/2006 added code to delete any "~" characters in the file name
                                If InStr(Watcher.GetJustFileName(sFullFileName), "~") > 0 Then
                                    My.Computer.FileSystem.RenameFile(sFullFileName, Watcher.GetJustFileName(sFullFileName).Replace("~", "_"))
                                    sFullFileName = Watcher.GetJustPath(sFullFileName) & Watcher.GetJustFileName(sFullFileName).Replace("~", "_")
                                End If

                                '### auggur 08/24/2006 add a default UNKNOWN file extension to files that come in without extensions
                                If Watcher.GetFileExtension(sFullFileName) = "UNKNOWN" Then
                                    sNewFullFileName = sFullFileName.Replace(".", "") & ".unknown"
                                    My.Computer.FileSystem.RenameFile(sFullFileName, Watcher.GetJustFileName(sNewFullFileName))
                                    sFullFileName = sNewFullFileName
                                End If

                                'Make sure that the file being copied is not attached to another process
                                If System.IO.File.Exists(sFullFileName) = True Then
                                    Do While HasExclusiveAccess(sFullFileName, 5) = False
                                        'do nothing
                                    Loop

                                    'Make sure the file is not an SmartLink file before renaming
                                    If Not sFullFileName.ToUpper().Contains("_DBX.XML") Then
                                        sNewFullFileName = sFileNm_DTstamp & "." & Watcher.GetFileExtension(sFullFileName)
                                    Else
                                        sNewFullFileName = System.IO.Path.GetFileName(sFullFileName)
                                    End If

                                    'Copy the current file to the Upload folder with the new filename (includes Date/Time stamp in double format)
                                    My.Computer.FileSystem.CopyFile(sFullFileName, _Path & "\" & sNewFullFileName, True)
                                    Log.WriteTrace(sFullFileName & " has been copied to " & _Path & "\" & sNewFullFileName)

                                    'Make sure that the OS has finished copying the file to its destination before proceeding
                                    If System.IO.File.Exists(sFullFileName) = True Then
                                        Do While HasExclusiveAccess(_Path & "\" & Watcher.GetJustFileName(sFullFileName), 5) = False
                                            'do nothing
                                        Loop

                                        sNewFullFileName = sFileNm_DTstamp & "_ToNRC." & Watcher.GetFileExtension(sFullFileName)
                                        If My.Computer.FileSystem.FileExists(sFullFileName) Then
                                            My.Computer.FileSystem.RenameFile(sFullFileName, sNewFullFileName)
                                        End If

                                        'Make sure that the file is not attached to another 
                                        'process before checking the custom parameter
                                        If System.IO.File.Exists(sFullFileName) = True Then
                                            Do While HasExclusiveAccess(sFullFileName, 5) = False
                                                'do nothing
                                            Loop
                                        Else
                                            'skip the current file and let the [While enFiles.MoveNext] method advance to the next file
                                        End If
                                    Else
                                        'skip the current file and let the [While enFiles.MoveNext] method advance to the next file
                                    End If

                                Else
                                    'skip the current file and let the [While enFiles.MoveNext] method advance to the next file
                                End If
                            Else
                                'skip the current file and let the [While enFiles.MoveNext] method advance to the next file
                            End If
                        Else
                            ' Allow_File_Rename is turned off. 
                            ' Files that have been copied to the Upload folder will be marked with custom property

                            sFNameExt = "." & Watcher.GetFileExtension(sFullFileName)
                            sNewFullFileName = Watcher.GetJustFileName(sFullFileName)

                            'Only rename if the file is not a Smartlink file
                            If Not sFullFileName.ToUpper().Contains("_DBX.XML") Then
                                sNewFullFileName = Replace(sNewFullFileName, sFNameExt, "") & "_" & sDateTime
                                sNewFullFileName = sNewFullFileName & sFNameExt
                            End If

                            If System.IO.File.Exists(sFullFileName) = True Then
                                'Make sure that the file being copied is not attached to another process
                                Do While HasExclusiveAccess(sFullFileName, 5) = False
                                    'do nothing
                                Loop
                            Else
                                'skip the current file and let the [While enFiles.MoveNext] method advance to the next file
                            End If

                            sRnamedFileFullPath = System.IO.Path.Combine(
                                _Path, Watcher.GetJustFileName(sNewFullFileName))

                            My.Computer.FileSystem.CopyFile(sFullFileName, sRnamedFileFullPath, True)

                            Log.WriteTrace(sFullFileName & " has been copied to " & sRnamedFileFullPath)

                            If System.IO.File.Exists(sRnamedFileFullPath) = True Then
                                'Make sure that the OS has finished copying the file to its destination before proceeding
                                Do While HasExclusiveAccess(sRnamedFileFullPath, 5) = False
                                    'do nothing
                                Loop

                                'We cannot designate that this file has been upload by renaming it so
                                'create custom property for the file 
                                If System.IO.File.Exists(sFullFileName) = True Then
                                    Apply_NRC_Txfr_Prop_ADS(sFullFileName)
                                End If
                            End If
                        End If
                    Else
                        If InStr(Watcher.GetJustFileName(sFullFileName), "_ToNRC") = 0 Then
                            '_objTrace.WriteTrace(True, "The last modification for the file, " & sFullFileName & ", was at " & dtLastModDate)
                            'This file has not been sent to NRC and we are waiting for the 
                            'interval between now and the last modified date to be more
                            'than the TransferDelayInterval so move to next file in list.
                        End If
                    End If
                End If
            End While

        Catch ex As Exception
            Dim msg As String = "An error has occurred and the NRC SLT service has stopped " +
                                "while copying files to upload folder: " + ex.Message +
                                "Contact your system administrator or NRC for assistance."
            Log.WriteError(msg, ex)
            _objMailer.SendEmail(msg, ex)
            End
        End Try

    End Sub


    ''' <summary>
    ''' When the timer event has triggered then scan the polling folders for unprocessed files
    ''' </summary>
    ''' <remarks>
    ''' 1) OnStart sets the event handlers for Timer, events1. The interval between timer events is set in Settings.xml file
    ''' 2) Turn of the Watcher Class timer until we are done processing any files. 
    ''' 3) The Watcher Class timer will be turned back on at the end of this routine so it  can process any files that have been processed. 
    ''' 4) The Directory Timer will be turned back on by the Watcher class when it is done processing any files sent to it.
    ''' </remarks>
    Private Sub DirTimerElapsed(ByVal source As Object, ByVal e As System.Timers.ElapsedEventArgs)

        Dim strProcName As String = "DirTimerElapsed"
        Dim sNewFullFileName As String = String.Empty
        Dim sExcludeFileTypes As String = String.Empty
        Dim sFullFileName As String = String.Empty
        Dim sDateTime As String
        Dim intI As Integer = 0

        'These variables will handle the wait interval to retry sending the file after failure
        Static iMinutestoWait As Integer
        Static iTryCount As Integer

        _DirTimer.Enabled = False  'Stop the Directory timer 

        If _ObjWatcher Is Nothing Then
            _ObjWatcher = New Watcher
        End If

        ' This array will hold all of the files in the "data" directory
        Dim ImportFiles As ReadOnlyCollection(Of String)

        '### auggur 10/31/2006 if any additional folders to poll have been selected then 
        'copy the files from those folders down to the upload folder before processing them.
        'EventLog.WriteEntry(_APPNAME, "Checking Polling folder 1 - " & _PollingPath1)
        If System.IO.Directory.Exists(_PollingPath1) Then
            CopyFilesToUploadFolder(_PollingPath1)
        End If

        'EventLog.WriteEntry(_APPNAME, "Checking Polling folder 2 - " & _PollingPath2)
        If System.IO.Directory.Exists(_PollingPath2) Then
            CopyFilesToUploadFolder(_PollingPath2)
        End If


        '### thopow 08/09/2007 DvHI #4579 Enable the DE-RT service to have more than just 2 polling folders.
        If _extPollingFldrsCount > 0 Then
            For intI = 1 To _extPollingFldrsCount
                'EventLog.WriteEntry(_APPNAME, "Checking Extended Polling folder " & intI & " - " & _ObjWatcher.extPollingFldrs(intI).ToString)
                If System.IO.Directory.Exists(_ObjWatcher.extPollingFldrs(intI).ToString) Then
                    CopyFilesToUploadFolder(_ObjWatcher.extPollingFldrs(intI).ToString)
                End If
            Next
        End If

        ' Get any available files in the directory
        ImportFiles = My.Computer.FileSystem.GetFiles(_Path, FileIO.SearchOption.SearchTopLevelOnly, "*.*")

        ' This will put all of the files in the current directory into the ImportFiles array
        Dim enFiles As System.Collections.IEnumerator

        enFiles = ImportFiles.GetEnumerator

        '### auggur 10/30/2006 get the list file types to exclude from upload
        sExcludeFileTypes = _ObjWatcher.ExcludeFileTypes

        While enFiles.MoveNext
            Try

                sFullFileName = enFiles.Current.ToString

                'Delay processing by amount of TransferDelayInterval
                Dim dtLastModDate As Date = File.GetLastWriteTime(sFullFileName)
                Dim dtCurrentDateTime As Date = Now
                'Use this trace log entry for debug purposes only
                'having it active in production environment will add unnecessary overhead to the application
                '_objTrace.WriteTrace(True, "Last Mod Date = " & dtLastModDate & _
                '                   "; Mod date + " & _ObjWatcher.TransferDelayInterval.ToString & _
                '                   " minutes = " & dtLastModDate.AddMinutes(_ObjWatcher.TransferDelayInterval) & _
                '                   "; Current Date = " & dtCurrentDateTime & _
                '                   "; ((Mod Date + interval) < Current time) = " & (dtLastModDate.AddMinutes(_ObjWatcher.TransferDelayInterval) < dtCurrentDateTime))

                If dtLastModDate.AddMinutes(_ObjWatcher.TransferDelayInterval) < dtCurrentDateTime Then

                    '### auggur 10/10/2006 
                    'check to make sure the file is completely copied over and that file operations
                    'can be performed on it before proceeding.
                    If Not HasExclusiveAccess(sFullFileName, 5) Then
                        Log.WriteInfo("The file '" & sFullFileName & "' is locked. Skipping file for this iteration")
                        Exit Try
                    End If



                    '### auggur 09/22/2006 added code to delete any spaces in the file name
                    If InStr(Watcher.GetJustFileName(sFullFileName), " ") > 0 Then
                        My.Computer.FileSystem.RenameFile(sFullFileName, Watcher.GetJustFileName(sFullFileName).Replace(" ", ""))
                        sFullFileName = Watcher.GetJustPath(sFullFileName) & Watcher.GetJustFileName(sFullFileName).Replace(" ", "")
                    End If
                    '### auggur 10/03/2006 added code to delete any "~" characters in the file name
                    If InStr(Watcher.GetJustFileName(sFullFileName), "~") > 0 Then
                        My.Computer.FileSystem.RenameFile(sFullFileName, Watcher.GetJustFileName(sFullFileName).Replace("~", ""))
                        sFullFileName = Watcher.GetJustPath(sFullFileName) & Watcher.GetJustFileName(sFullFileName).Replace("~", "")
                    End If

                    '### auggur 08/24/2006 add a default unknown file extension to files that come in without extensions
                    If Watcher.GetFileExtension(sFullFileName) = "UNKNOWN" Then
                        sNewFullFileName = sFullFileName.Replace(".", "") & ".unknown"
                        My.Computer.FileSystem.RenameFile(sFullFileName, Watcher.GetJustFileName(sNewFullFileName))
                        sFullFileName = sNewFullFileName
                    End If

                    '## auggur 08/22/2006 eliminate multimple file extension on zip files
                    'ie. files coming in with names like myfile.zip.zip
                    If InStr(sFullFileName.ToLower, ".zip") > 0 Then
                        'delete all .zip occurrences weather is one or more than one
                        'and add only one .zip extension and rename then incoming zip 
                        'file only if the file names are different
                        sNewFullFileName = sFullFileName.ToLower.Replace(".zip", "") & ".zip"
                        If sFullFileName.ToLower <> sNewFullFileName Then
                            Rename(sFullFileName, sNewFullFileName)
                            'update the file path string
                            sFullFileName = sFullFileName.ToLower.Replace(".zip", "") & ".zip"
                        End If
                    End If

                    '### auggur 10/06/2006 check for an internet connection since it will be required
                    ' for the web service to work, if one is not present then log to the application event log
                    ' and keep trying until a connection is detected. Note that it will only be logged once.
                    '### thopow 08/23/2008 Made some changes to force the service to stop should 
                    ' it not be able to connect to the NRC web service.
                    '### elibad 02/04/2009 We don't want to stop the service when the internet conection is not available
                    ' We will retry later
                    'If NRC_WebServiceAvailable() = False Then
                    '    _objTrace.WriteError("A message was recorded in the Application Event Log " & _
                    '                         "and an email was sent to the designated recipient. " & _
                    '                         "Contact your network administrator or NRC for assistance. Time: " & Now())

                    '    Dim msg As String = strProcName & " - No internet connection available. Checking site: " _
                    '        & Watcher.InternetCheckURL & " Time: " & Now()

                    '    EventLog.WriteEntry(msg, EventLogEntryType.Information)

                    '    Me.Stop()
                    'End If
                    '### thopow 08/23/2008


                    '### auggur 10/30/2006 only process file types that are not excluded
                    Dim tempExt As String
                    tempExt = "." & Watcher.GetFileExtension(sFullFileName)
                    If tempExt.Length < 4 Then
                        tempExt.PadRight(4, CChar(CType(0, String)))
                    End If

                    'Use this string version of the double data type equivalent for NOW() to ensure unique file name
                    sDateTime = CType(CType(Now.ToOADate(), Double), String)
                    sDateTime = Replace(sDateTime, ".", "_")

                    '### thopow 06/21/2007 DevHI#4445
                    'Rename the source file to note that it has been uploaded.
                    sNewFullFileName = Left(Watcher.GetJustFileName(sFullFileName), InStr(Watcher.GetJustFileName(sFullFileName), ".") - 1) & "_" & sDateTime & tempExt

                    If InStr(sExcludeFileTypes.ToUpper, tempExt.ToUpper) > 0 Then
                        'move file names with bad extensions and/or bad characters in the file name to a garbage folder.
                        System.IO.File.Move(sFullFileName, _ObjWatcher.ErrorsDir + "\" + sNewFullFileName)

                        Log.WriteInfo("Attempted to upload a file with disallowed extension." & vbCrLf &
                                            _ObjWatcher.ErrorsDir & "\" & sNewFullFileName)

                        Exit Try
                    End If

                    'When copying a file to the Upload folder and renaming it at the same time, as is done 
                    'when Allow_File_Rename = No, a zero length file is left behind in the Upload folder.
                    'When this file gets uploaded to the web service then many, many copies are 
                    'generated on NRC in-house file servers.

                    Dim objFileInfo As System.IO.FileInfo
                    objFileInfo = My.Computer.FileSystem.GetFileInfo(sFullFileName)
                    '_objTrace.WriteTrace(True, sFullFileName & " is " & objFileInfo.Length & " bytes.")
                    If objFileInfo.Length = 0 Then
                        System.IO.File.Move(sFullFileName, _ObjWatcher.ErrorsDir & "\" & sNewFullFileName)

                        '_objTrace.WriteTrace(True, "zero length file has been deleted " & sFullFileName)
                    Else

                        Try

                            If Not _ObjWatcher.TransferTheFile(sFullFileName) Then
                                Dim msg As String = "Error while attempting to send file to NRC Web Service, " & sFullFileName
                                Log.WriteError(msg)

                                'Calculate wait time before retrying to sending file
                                iTryCount += 1
                                If iTryCount <= Watcher.MaxInetAccessTries Then
                                    iMinutestoWait = Watcher.IntervalBetweenTries
                                ElseIf iTryCount = Watcher.MaxInetAccessTries + 1 Then
                                    iMinutestoWait = Watcher.PauseBeforeFinalWSChk
                                ElseIf (iMinutestoWait * 2) < 1440 Then
                                    iMinutestoWait = iMinutestoWait * 2
                                Else
                                    iMinutestoWait = 1440
                                End If
                                Exit While
                            Else
                                iMinutestoWait = 0
                                iTryCount = 0
                            End If


                        Catch ex As Exception
                            Log.WriteError("An error has occurred sending files: " + ex.Message, ex)
                        End Try


                    End If
                End If

            Catch ex As Exception
                Log.WriteError("Encountered error in DirTimerElapsed: " + ex.Message, ex)
            End Try
        End While

        If iMinutestoWait > 0 Then
            Dim wConnectionStatus As ConnectionStatus = WebService.DiagnoseConnection()
            Dim sMsg As String = ""

            If wConnectionStatus = ConnectionStatus.NoConnection Then
                sMsg = "Unable to confirm availability for the NRC web service: " &
                vbCrLf & "The SmartLink Transfer service was unable to connect " &
                "with any of the test web sites." _
                & vbCrLf & "It would appear that there is no internet access from the computer named, " & My.Computer.Name & ". " & vbCrLf _
                & vbCrLf & "Please contact NRC as soon as possible."
            ElseIf wConnectionStatus = ConnectionStatus.CheckIPUp Then
                sMsg = "Unable to confirm availability for the NRC web service: " _
                & vbCrLf & "This may be due to the presence " _
                & "of a proxy firewall on your network."
            ElseIf wConnectionStatus = ConnectionStatus.BadHost Then
                sMsg = "Unable to confirm availability of the NRC web service: " _
                & vbCrLf _
                & vbCrLf & "This may be due to the presence of a proxy server/firewall " _
                & vbCrLf & "or an outdated domain name server on your local network."
            ElseIf wConnectionStatus <> ConnectionStatus.OK Then
                sMsg = "Unable to confirm availability of the NRC web service: " _
                & vbCrLf _
                & "This may be due to a problem with network traffic " _
                & "or the NRC web service itself."
            End If
            sMsg += vbCrLf + "Check the log file for more details."

            If wConnectionStatus = ConnectionStatus.OK _
                Or (wConnectionStatus = ConnectionStatus.PageUp And iMinutestoWait < 1440) Then
                'Nothing more needs to be done here
            Else
                'Send email
                Log.WriteError(sMsg)

                With _objMailer
                    .SrvrLoc = Watcher.EmailSrvrLoc
                    .SentFrom = Watcher.EmailSentFrom
                    .SendTo = Watcher.EmailSendTo
                    .Subject = Watcher.EmailSubject
                    .HTMLTemplateLoc = Watcher.EmailTemplateLoc
                    .MessageBody = sMsg

                    .SendEmail(sMsg)
                    .ClearAttachments()
                End With
            End If
        End If

        _ObjWatcher = Nothing

        If iMinutestoWait > 0 Then
            Log.WriteTrace("There was a problem sending this file. Will wait " & iMinutestoWait & " minutes before trying again")
            System.Threading.Thread.Sleep(New TimeSpan(0, iMinutestoWait, 0))
        End If

        _DirTimer.Enabled = True   'Start the watcher class timer

    End Sub

    ''' <summary>
    ''' Checks the file to see if it has been tagged with an NRC custom property
    ''' </summary>
    ''' <remarks>Passes the file designated in the methods parameter to an instance of the Edanmo.OleStorage.Property project and reads for any existing custom properties and checks to see if the NRC custom property has been added.</remarks>
    ''' <param name="Filename">The name and location of the file to be tested for custom NRC file property</param>
    ''' <returns>True or False</returns>
    Private Function FileHasNRC_TrxfrProp_ADS(ByVal Filename As String) As Boolean
        Dim sText As String = String.Empty
        Dim strProcName As String = "FileHasNRC_TrxfrProp_ADS"
        Dim bFoundADS As Boolean = False
        Dim bChkForGUIDIsDone As Boolean = False
        Dim bChkForADSIsDone As Boolean = False

        Do Until (bChkForGUIDIsDone And bChkForADSIsDone) Or bFoundADS

            Try
                If Not bChkForGUIDIsDone Then
                    'If the GUID StrgProp exists then there will be no error and sText will be empty
                    sText = AlternateDataStreams.ADSFile.Read(Filename, "{4c8cc155-6c1e-11d1-8e41-00c04fb9386d}")
                    bChkForGUIDIsDone = True
                    bFoundADS = True
                    Log.WriteTrace(Filename & " OLD custom tag already present.")
                End If

                If Not bChkForADSIsDone And Not bFoundADS Then
                    sText = AlternateDataStreams.ADSFile.Read(Filename, "NRC_SLT_TxfrDate")
                    If sText <> String.Empty Then
                        bFoundADS = True
                        Log.WriteTrace(Filename & " custom tag was already created.")
                    End If
                End If

            Catch ex As Exception
                If ex.Message.Contains("{4c8cc155-6c1e-11d1-8e41-00c04fb9386d}") Then
                    'The GUID custom property was not found but is confirmed to not be attached to the main file
                    'so we set bChkForGUIDIsDone to True so that next time we loop we skip the read attempt.
                    bChkForGUIDIsDone = True
                ElseIf ex.Message.Contains("NRC_SLT_TxfrDate") Then
                    'The ADS was not found and we are done checking for appropriate ADSs 
                    'so we can set bChkForADSIsDone = True and exit loop
                    bChkForADSIsDone = True
                Else
                    Log.WriteError("Encountered error in FileHasNRC_TrxfrProp_ADS: " + ex.Message, ex)
                End If

            End Try
        Loop

        Return bFoundADS

    End Function


    'Private Function FileHasNRC_TrxfrProp(ByVal Filename As String) As Boolean

    '    Dim strProcName As String = "FileHasNRC_TrxfrProp"
    '    Dim PropStg As Edanmo.OleStorage.PropertyStorage
    '    Dim PropSetStg As Edanmo.OleStorage.PropertySetStorage
    '    Dim blnResult As Boolean
    '    Dim intTries As Integer

    '    'Debug.WriteLine(Filename & " FileHasNRC_TrxfrProp-Start:" & Now)

    '    Do Until blnResult = True Or intTries > 1

    '        Try

    '            PropSetStg = New Edanmo.OleStorage.PropertySetStorage(Filename)

    '            If PropSetStg.Elements.Count > 0 Then
    '                PropStg = PropSetStg.Open(Edanmo.OleStorage.PropertySetStorage.FMTID_UserProperties)

    '                Dim Prop As Edanmo.OleStorage.StatPropStg
    '                Dim Props As Edanmo.OleStorage.PropertyStorage.StatPropStgCollection

    '                Props = PropStg.Elements

    '                For Each Prop In PropStg.Elements
    '                    If Prop.Name = "NRC_SLT_TxfrDate" Then
    '                        If CType(PropStg(Prop).ToString, Date) <= Now Then

    '                            '_objTrace.WriteTrace(True, Filename & " already has custom tag. ")

    '                            blnResult = True
    '                        End If
    '                    End If
    '                Next
    '            Else
    '                blnResult = False
    '            End If

    '        Catch ex As Exception
    '            If InStr(ex.Message, "STG_E_LOCKVIOLATION") > 0 Or InStr(ex.Message, "STG_E_FILENOTFOUND") > 0 Then
    '                blnResult = False
    '                '_objTrace.WriteTrace(True, Filename & " Encountered lock violation " & intTries & " times.")
    '                intTries += 1
    '                System.Threading.Thread.Sleep(2000)
    '            Else

    '                EventLog.WriteEntry("FileHasNRC_TrxfrProp - ERROR: 1050 - Checking file for existence of NRC_SLT_TxfrDate custom property : " _
    '                                    + Filename + " " + ex.Message, EventLogEntryType.Error)
    '                _objTrace.WriteTrace(True, "An error has occurred and the NRC SLT service has stopped. " & _
    '                                    "See the Windows Application Event log and the SmartLink Transfer error log for more details. " & _
    '                                    "Contact your system administrator or NRC for assistance.", ex)
    '                _objTrace.WriteError("Error: FileHasNRC_TrxfrProp " & ex.Message)

    '                'Set the number of tries in order to trigger an exit from the Do/Loop
    '                intTries = 7
    '            End If

    '        End Try

    '    Loop

    '    If Not PropStg Is Nothing Then
    '        PropStg.Close()
    '    End If
    '    If Not PropSetStg Is Nothing Then
    '        PropSetStg.Close()
    '    End If

    '    'Debug.WriteLine("FileHasNRC_TrxfrProp-Stop:" & Now)
    '    Return blnResult

    'End Function

    ''' <summary>
    ''' Creates a custom property and saves it to the files OleStorage.property page
    ''' </summary>
    ''' <remarks>The file is passed to the ADS project where the .NET OleStorage.Property class is used to tag the file with the custom property that can later be read to verify that the specified file has been uploaded to NRC web service.</remarks>
    ''' <param name="Filename">The name and location of the file to recieve the custom property</param>
    ''' <returns>Success or Failure</returns>
    Private Function Apply_NRC_Txfr_Prop_ADS(ByVal Filename As String) As Boolean
        Dim strProcName As String = "Apply_NRC_Txfr_Prop_ADS"

        Try

            AlternateDataStreams.ADSFile.Write(Now.ToString, Filename, "NRC_SLT_TxfrDate")
            Log.WriteTrace(Filename & " custom tag was just created.")
            Return True

        Catch ex As Exception
            Log.WriteError("Encountered error in FileHasNRC_TrxfrProp_ADS: ", ex)
        End Try
        Return False
    End Function
#End Region

    Protected Sub WriteEventLogEntry(ByVal msg As String)
        WriteEventLogEntry(msg, EventLogEntryType.Information)
    End Sub

    Protected Sub WriteEventLogEntry(ByVal msg As String, ByVal entryType As EventLogEntryType)
        EventLog.WriteEntry(Me.ServiceName, msg, entryType)
    End Sub

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Protected Overrides Sub Finalize()
        Array.Clear(_chArr, 0, 1)
        MyBase.Finalize()
    End Sub
End Class
