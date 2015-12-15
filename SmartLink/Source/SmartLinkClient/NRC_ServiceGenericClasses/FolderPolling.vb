Imports System.IO

'********************************************************************'
' Created by Elibad - 04/11/2007
'
'  These classes provide functionality to read the files that exist in a folder
'  with or without a filter, letting the developer loop through the files, 
'  read the properties and do other type of manipulations to the files within the folder
'*********************************************************************


Namespace Miscellaneous.FolderPolling
    Public Class FileOperation
        Implements IDisposable
#Region "Private fields"
        ''' <summary>
        ''' This field holds the name of the file for the backup of current file
        ''' </summary>
        Private _sBackupFileName As String

        ''' <summary>
        ''' This field holds the current file
        ''' </summary>
        Private _sFileName As String = String.Empty

        ''' <summary>
        ''' This field shows when the main Directory has been defined
        ''' </summary>
        Private _bMainDirDefined As Boolean = False

        ''' <summary>
        ''' This field shows when error directory has been defined
        ''' </summary>
        Private _bErrorFiles As Boolean = False

        ''' <summary>
        ''' This field shows when backup directory has been defined
        ''' </summary>
        Private _bBackupFiles As Boolean = False

        ''' <summary>
        ''' This field holds the backup path
        ''' </summary>
        Private _sBackupDirectory As String = String.Empty

        ''' <summary>
        ''' This field holds the error path
        ''' </summary>
        Private _sErrorDirectory As String = String.Empty

        ''' <summary>
        ''' This field holds the working path
        ''' </summary>
        Private _sMainDirectory As String = String.Empty

        Private _bValidFileName As Boolean = False

        ''' <summary>
        ''' This field knows when the class should make automatic backups of files
        ''' </summary>
        Private _bAutomaticBackups As Boolean

        ''' <summary>
        ''' This field controls when the class should not preserve the backup file
        ''' </summary>
        Private _bDropBackup As Boolean = False

        Protected disposed As Boolean = False
#End Region

#Region "Constructors"

        ''' <param name="FileName">Name of the file to be used</param>
        ''' <param name="MainDirectory">Path for the working Directory</param>
        ''' <param name="ErrorDirectory">Path for the Error Directory</param>
        ''' <param name="BackupDirectory">Path for the Backup Directory</param>

        Public Sub New(ByVal FileName As String, Optional ByVal MainDirectory As String = "", Optional ByVal ErrorDirectory As String = "C:\NRC\Errors", Optional ByVal BackupDirectory As String = "C:\NRC\Backups", Optional ByVal BackupFileName As String = "")
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If
            'Set values for Main variables
            If System.IO.File.Exists(FileName) Then
                _sFileName = FileName
                _bValidFileName = True
            Else
                Throw New System.Exception("Invalid File Name" & vbCrLf & vbCrLf & "The File does not exist..." & vbCrLf & FileName)
                _bValidFileName = False
            End If
            _sBackupFileName = BackupFileName
            If System.IO.Directory.Exists(MainDirectory) Then
                _sMainDirectory = MainDirectory
            ElseIf MainDirectory <> "" Then
                Throw New System.Exception("Invalid Path for Main Directory" & vbCrLf & vbCrLf & "The Folder does not exist..." & vbCrLf & MainDirectory)
            End If

            If System.IO.Directory.Exists(ErrorDirectory) Then
                _sErrorDirectory = ErrorDirectory
            ElseIf ErrorDirectory.ToLower = "c:\NRC\errors" Then
                System.IO.Directory.CreateDirectory(ErrorDirectory)
                _sErrorDirectory = ErrorDirectory
            End If

            If System.IO.Directory.Exists(BackupDirectory) Then
                _sBackupDirectory = BackupDirectory
            ElseIf BackupDirectory.ToLower = "c:\NRC\backups" Then
                System.IO.Directory.CreateDirectory(BackupDirectory)
                _sBackupDirectory = BackupDirectory
            End If

            ' checks for invalid data on main variables
            If _sMainDirectory <> String.Empty Then
                _bMainDirDefined = True
            Else
                _bMainDirDefined = False
            End If
            If _sBackupDirectory <> String.Empty Then
                _bBackupFiles = True
            Else
                _bBackupFiles = False
            End If
            If _sErrorDirectory <> String.Empty Then
                _bErrorFiles = True
            Else
                _bErrorFiles = False
            End If

        End Sub
#End Region

#Region "Properties"
        ''' <summary>
        ''' This property shows the name and path of working file
        ''' </summary>
        Public Property FullName() As String
            Get
                FullName = _sFileName
            End Get
            Set(ByVal value As String)
                _bValidFileName = False
                If _bDropBackup Then
                    DeleteBackup()
                End If
                If System.IO.File.Exists(value) Then
                    _sFileName = value
                    _sBackupFileName = String.Empty
                    If _bAutomaticBackups Then
                        Backup()
                    End If
                    _bValidFileName = True
                ElseIf value <> String.Empty Then
                    Throw New System.Exception("Invalid File Name" & vbCrLf & vbCrLf & "The File does not exist")
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the name of backup file. This name will be auto generated by the class
        ''' </summary>
        Public ReadOnly Property BackupFileName() As String
            Get
                BackupFileName = _sBackupFileName
            End Get
        End Property

        ''' <summary>
        ''' This property shows just the file name
        ''' </summary>
        Public ReadOnly Property FileName() As String
            Get
                FileName = GetName()
            End Get
        End Property

        ''' <summary>
        ''' This property shows just the file extension
        ''' </summary>
        Public ReadOnly Property FileExtension() As String
            Get
                FileExtension = GetExtension()
            End Get
        End Property

        ''' <summary>
        ''' This property shows just the path location
        ''' </summary>
        Public ReadOnly Property Path() As String
            Get
                Path = GetPath()
            End Get
        End Property

        ''' <summary>
        ''' This property shows the Error Path folder.
        ''' </summary>
        ''' <remarks>If this property is not defined the path will default to "C:\NRC\Errors"</remarks>
        Public Property ErrorPath() As String
            Get
                ErrorPath = _sErrorDirectory
            End Get
            Set(ByVal value As String)
                If System.IO.Directory.Exists(value) Then
                    _sErrorDirectory = value
                    _bErrorFiles = True
                ElseIf value <> "" Then
                    Throw New System.Exception("Invalid Path for Error Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the Backup Path folder.
        ''' </summary>
        ''' <remarks>If this property is not defined the Backup path will default to "C:\NRC\backups"</remarks>
        Public Property BackupPath() As String
            Get
                BackupPath = _sBackupDirectory
            End Get
            Set(ByVal value As String)
                If System.IO.Directory.Exists(value) Then
                    _sBackupDirectory = value
                    _bBackupFiles = True
                ElseIf value <> "" Then
                    Throw New System.Exception("Invalid Path for Backup Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the path of the main folder
        ''' </summary>
        ''' <remarks>
        ''' If defined the property sub path will be able to extract the sub folders after the Base path otherwise will sub path will return an empty string
        ''' 
        ''' Example:
        ''' 
        ''' Base Path: "C:\folder1"
        ''' FullName: "C:\folder1\folder2\otherfolder\file1.txt
        ''' 
        ''' Sub path will be: "\folder2\otherfolder"
        ''' </remarks>
        Public Property BasePath() As String
            Get
                BasePath = _sMainDirectory
            End Get
            Set(ByVal value As String)
                If System.IO.Directory.Exists(value) Then
                    _sMainDirectory = value
                    _bMainDirDefined = True
                ElseIf value <> "" Then
                    Throw New System.Exception("Invalid Path for Base Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the sub folder path
        ''' </summary>
        ''' <remarks>This property needs the property BasePath to be defined.</remarks>
        Public ReadOnly Property SubPath() As String
            Get
                SubPath = GetJustSubPath()
            End Get
        End Property

        ''' <summary>
        ''' This property defines if the class should create an automatic backup of current file
        ''' </summary>
        Public Property AutomaticBackups() As Boolean
            Get
                AutomaticBackups = _bAutomaticBackups
            End Get
            Set(ByVal value As Boolean)
                _bAutomaticBackups = value
                If _bAutomaticBackups Then
                    Backup()
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property defines if the class should drop the backup files 
        ''' after operation with current file has been completed
        ''' </summary>
        Public Property DropBackup() As Boolean
            Get
                DropBackup = _bDropBackup
            End Get
            Set(ByVal value As Boolean)
                _bDropBackup = value
            End Set
        End Property
#End Region

#Region "Methods"
        ''' <summary>
        ''' This Method obtains the extension of the current file
        ''' </summary>
        Private Function GetExtension() As String
            GetExtension = String.Empty
            If _bValidFileName Then
                GetExtension = GetExtension(_sFileName)
            End If
        End Function

        ''' <summary>
        ''' This Method obtains the extension of the file
        ''' </summary>
        Public Function GetExtension(ByVal FileName As String) As String
            Dim i As Integer = Len(FileName)
            Dim TheFileCharacter As String
            GetExtension = String.Empty
            For i = Len(FileName) To 1 Step -1
                TheFileCharacter = Mid(FileName, i, 1)
                If TheFileCharacter <> "." Then
                    GetExtension = TheFileCharacter & GetExtension
                Else
                    i = 1
                End If
            Next

            'Sets result to UNKNOWN for files that come in without extension
            If GetExtension = FileName Then
                GetExtension = "UNKNOWN"
            End If

        End Function

        ''' <summary>
        ''' This Method checks if the current file has exclusive access
        ''' </summary>
        Public Function HasExclusiveAccess(ByVal WaitInSeconds As Integer) As Boolean
            'Checks to see if no other application is using the file before performing
            'any operations on it. Specifically when a file is still being copied over into the 
            'data directory.

            Return HasExclusiveAccess(Me._sFileName, WaitInSeconds)

        End Function


        ''' <summary>
        ''' This Method obtains just the path for the current file
        ''' </summary>
        Private Function GetPath() As String
            GetPath = String.Empty
            If _bValidFileName Then
                GetPath = _sFileName.Substring(0, _sFileName.Length - My.Computer.FileSystem.GetName(_sFileName).Length)
            End If
        End Function

        ''' <summary>
        ''' This Method obtains just the path for the current file
        ''' </summary>
        Public Function GetPath(ByVal FileName As String) As String
            GetPath = FileName.Substring(0, FileName.Length - My.Computer.FileSystem.GetName(FileName).Length)
        End Function

        ''' <summary>
        ''' This Method obtains just the file name of the current file
        ''' </summary>
        Private Function GetName() As String
            GetName = String.Empty
            If _bValidFileName Then
                If _bMainDirDefined And _sFileName.Trim.Length > 0 Then
                    GetName = My.Computer.FileSystem.GetName(_sFileName)
                End If
            End If
        End Function

        ''' <summary>
        ''' This Method obtains just the file name of the current file
        ''' </summary>
        Public Function GetName(ByVal FileName As String) As String
            GetName = String.Empty
            If FileName.Trim.Length > 0 Then
                GetName = My.Computer.FileSystem.GetName(FileName)
            End If
        End Function

        ''' <summary>
        ''' This Method deletes the current file
        ''' </summary>
        Public Sub Delete()
            If System.IO.File.Exists(_sFileName) Then
                Try
                    System.IO.File.Delete(_sFileName)
                Catch ex As Exception
                    Throw New Exception_PathNotFound(_sFileName, ex)
                End Try
            End If
        End Sub

        ''' <summary>
        ''' This Method deletes backup the current file
        ''' </summary>
        Public Sub DeleteBackup()
            If System.IO.File.Exists(_sBackupFileName) Then
                System.IO.File.Delete(_sBackupFileName)
                _sBackupFileName = String.Empty
            End If
        End Sub

        ''' <summary>
        ''' This Method creates a backup of the current file on the Backup Directory
        ''' </summary>
        Public Sub Backup()
            Dim sNewFileName As String
            'makes sure the backup can be done
            If _bBackupFiles _
                And _sBackupDirectory <> String.Empty _
                And _bMainDirDefined _
                And _sBackupFileName = String.Empty _
                And _bValidFileName Then
                Try
                    'creates an unique name for the backup file using date and time
                    sNewFileName = GetName(_sFileName)
                    If Mid(sNewFileName, Len(sNewFileName) - 3, 1) = "." Then
                        sNewFileName = Left(sNewFileName, Len(sNewFileName) - 4) _
                            & "_" & My.Computer.Clock.LocalTime.Year.ToString & My.Computer.Clock.LocalTime.Month.ToString _
                            & My.Computer.Clock.LocalTime.Day.ToString _
                            & "_" & My.Computer.Clock.LocalTime.Hour.ToString & My.Computer.Clock.LocalTime.Minute.ToString _
                            & My.Computer.Clock.LocalTime.Second.ToString & My.Computer.Clock.LocalTime.Millisecond.ToString _
                            & Right(sNewFileName, 4)
                    End If
                    System.IO.File.Copy(_sFileName, _sBackupDirectory & "\" & sNewFileName)
                    _sBackupFileName = _sBackupDirectory & "\" & sNewFileName
                Catch ex As Exception
                    'EventLog.WriteEntry("PatientView Driver", "Error Backing up file.  Error message was:  " & ex.ToString, EventLogEntryType.Error)
                End Try
            ElseIf _sBackupDirectory = String.Empty And _sBackupFileName = String.Empty Then
                Throw New System.Exception("Can not make backup of current file" & vbCrLf & vbCrLf & "The BackupPath needs to be declared")
            End If
        End Sub

        ''' <summary>
        ''' This Method moves the current file to the Error directory
        ''' </summary>
        Public Sub MoveToErrorFolder()
            'makes sure the file can be moved to error directory
            If _bErrorFiles And _bValidFileName Then
                'makes sure the file does not exist already on error directory
                If Not System.IO.File.Exists(_sErrorDirectory & "\" & GetName(_sFileName)) _
                And System.IO.File.Exists(_sFileName) Then
                    System.IO.File.Move(_sFileName, _sErrorDirectory & "\" & GetName(_sFileName))
                End If
            ElseIf Not _bErrorFiles Then
                Throw New System.Exception("Can not move file to Error Folder" & vbCrLf & vbCrLf & "The ErrorPath needs to be declared")
            End If
        End Sub

        ''' <summary>
        ''' This Method restores current file from backup file
        ''' </summary>
        Public Sub RestoreFromBackup()
            If _sBackupFileName <> String.Empty And _bValidFileName Then
                System.IO.File.Copy(_sBackupFileName, _sFileName, True)
            ElseIf _sBackupFileName = String.Empty Then
                Throw New System.Exception("Can not restore file" & vbCrLf & vbCrLf & "There is no backup for current file")
            End If
        End Sub


        ''' <summary>
        ''' This Methos obatins just the subdirectory path for the current path after the main Directory
        ''' </summary>
        Private Function GetJustSubPath() As String
            GetJustSubPath = String.Empty
            If _bValidFileName Then
                If (_sFileName.Length - My.Computer.FileSystem.GetName(_sFileName).Length > _sMainDirectory.Length + 1) Then
                    GetJustSubPath = _sFileName.Substring(_sMainDirectory.Length + 1, _sFileName.Length - My.Computer.FileSystem.GetName(_sFileName).Length - _sMainDirectory.Length - 1)
                Else
                    GetJustSubPath = "None"
                End If
            End If
        End Function

        ''' <summary>
        ''' This method cleans the filename from any invalid characters
        ''' </summary>
        Public Sub CleanFileName()
            Dim sNewFullFileName As String
            'This code will delete any spaces in the file name
            If _bValidFileName Then
                If InStr(GetName(), " ") > 0 Then
                    My.Computer.FileSystem.RenameFile(_sFileName, GetName(_sFileName.Replace(" ", "")))
                    _sFileName = GetPath() & GetName(_sFileName.Replace(" ", ""))
                End If
                'deletes any "~" characters in the file name
                If InStr(GetName(), "~") > 0 Then
                    My.Computer.FileSystem.RenameFile(_sFileName, GetName(_sFileName.Replace("~", "")))
                    _sFileName = GetPath(_sFileName) & GetName(_sFileName.Replace("~", ""))
                End If

                'defaults UNKNOWN file extension to files that come in without extensions
                If GetExtension(_sFileName) = "UNKNOWN" Then
                    sNewFullFileName = _sFileName.Replace(".", "") & ".unknown"
                    My.Computer.FileSystem.RenameFile(_sFileName, GetName(sNewFullFileName))
                    _sFileName = sNewFullFileName
                End If
                'eliminates multimple file extension on zip files
                'ie. files coming in with names like myfile.zip.zip
                If InStr(_sFileName.ToLower, ".zip") > 0 Then
                    'delete all .zip occurrences weather is one or more than one
                    'and add only one .zip extension and rename then incoming zip 
                    'file only if the file names are different
                    sNewFullFileName = _sFileName.ToLower.Replace(".zip", "") & ".zip"
                    If _sFileName.ToLower <> sNewFullFileName Then
                        Rename(_sFileName, sNewFullFileName)
                        'update the file path string
                        _sFileName = _sFileName.ToLower.Replace(".zip", "") & ".zip"
                    End If
                End If
            End If
        End Sub
        ''' <summary>
        ''' This method creates a copy of the current object
        ''' </summary>
        Public Function Copy() As FileOperation
            Copy = New FileOperation(Me.FullName, Me.Path, Me.ErrorPath, Me.BackupPath, Me.BackupFileName)
        End Function

        Protected Overridable Sub dispose(ByVal disposing As Boolean)
            If Not Me.disposed Then
                If disposing Then

                End If
            End If
            If _bDropBackup Then
                DeleteBackup()
            End If
            Me.disposed = True
        End Sub

        Public Shared Function HasExclusiveAccess(ByVal FileName As String, ByVal WaitInSeconds As Integer) As Boolean
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
                    FI.Attributes = IO.FileAttributes.Normal
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
                        System.Threading.Thread.Sleep(1000)
                    End Try
                End While
            Else
                Throw New System.Exception("Invalid FileName" & vbCrLf & vbCrLf & "The current File does not exist")
            End If
            Return blnResult
        End Function

#End Region

#Region "IDisposable support"
        Public Sub Dispose() Implements IDisposable.Dispose
            dispose(True)
            GC.SuppressFinalize(Me)
        End Sub


        Protected Overrides Sub Finalize()
            dispose(False)
            MyBase.Finalize()
        End Sub

#End Region
    End Class


    Public Class FolderPolling
        Implements IDisposable
#Region "Private Variables"
        ''' <summary>
        ''' This field holds the working path
        ''' </summary>
        Private _sMainDirectory As String = String.Empty
        ''' <summary>
        ''' This field holds the current directory
        ''' </summary>
        Private _sCurrentDirectory As String = String.Empty
        ''' <summary>
        ''' This field holds the current file
        ''' </summary>
        Private _foCurrentFile As FileOperation
        ''' <summary>
        ''' This array holds a list of all directories within the working folder
        ''' </summary>
        Private _sAllDirectories() As String
        ''' <summary>
        ''' This array holds a list of all files within the working folder
        ''' </summary>
        Private _sAllFiles() As String
        ''' <summary>
        ''' This field holds the error path
        ''' </summary>
        Private _sErrorDirectory As String = String.Empty
        ''' <summary>
        ''' This field holds the backup path
        ''' </summary>
        Private _sBackupDirectory As String = String.Empty
        ''' <summary>
        ''' This field shows when backup directory has been defined
        ''' </summary>
        Private _bBackupFiles As Boolean = False
        ''' <summary>
        ''' This field shows when error directory has been defined
        ''' </summary>
        Private _bErrorFiles As Boolean = False
        ''' <summary>
        ''' This field shows when the main Directory has been defined
        ''' </summary>
        Private _bMainDirDefined As Boolean = False
        ''' <summary>
        ''' This field controls when the class should not preserve the backup file
        ''' </summary>
        Private _bDropBackup As Boolean = False
        ''' <summary>
        ''' This field controls when the class should look for files inside subdirectories
        ''' </summary>
        Private _bRecursive As Boolean = False
        ''' <summary>
        ''' This field holds an enumerator for all the subdirectories within the main directory
        ''' </summary>
        Private _enDirectories As System.Collections.IEnumerator
        ''' <summary>
        ''' This field holds an enumerator for all the files in Main Directory
        ''' </summary>
        Private _enFiles As System.Collections.IEnumerator

        ''' <summary>
        ''' This field knows when the class should make automatic backups of files
        ''' </summary>
        Private _bAutomaticBackups As Boolean
        ''' <summary>
        ''' This field manipulates the files within the subdirectory
        ''' </summary>
        Private _fpSubdirectory As FolderPolling

        Protected disposed As Boolean

        Private _bGetfiles As Boolean
        Private _sFilter As String = "*.*"
        Private _bSubDirectoryUsed As Boolean = False

#End Region

#Region "Constructor Methods"
        ''' <param name="MainDirectory">Path to the Working Folder</param>
        Public Sub New(ByVal MainDirectory As String, Optional ByVal Recursive As Boolean = True)
            InitializeVariables(MainDirectory, "", "", False, Recursive)
        End Sub

        ''' <param name="MainDirectory">Path to the Working Folder</param>
        ''' <param name="ErrorDirectory">Path to the Error Folder</param>
        Public Sub New(ByVal MainDirectory As String, ByVal ErrorDirectory As String, Optional ByVal Recursive As Boolean = True)
            InitializeVariables(MainDirectory, ErrorDirectory, "", False, Recursive)
        End Sub

        ''' <param name="MainDirectory">Path to the Working Folder</param>
        ''' <param name="ErrorDirectory">Path to the Error Folder</param>
        ''' <param name="BackupDirectory">Path to the Backup Folder</param>
        ''' <param name="AutomaticBackup">Optional - When true the class will create Automatic backups</param>
        Public Sub New(ByVal MainDirectory As String, ByVal ErrorDirectory As String, ByVal BackupDirectory As String, Optional ByVal AutomaticBackup As Boolean = False, Optional ByVal Recursive As Boolean = True)
            InitializeVariables(MainDirectory, ErrorDirectory, BackupDirectory, AutomaticBackup, Recursive)
        End Sub
#End Region

#Region "Private Methods"
        ''' <param name="MainDirectory">Path for the working Directory</param>
        ''' <param name="ErrorDirectory">Path for the Error Directory</param>
        ''' <param name="BackupDirectory">Path for the Backup Directory</param>
        ''' <param name="AutomaticBackup">When true the class will create Automatic backups</param>
        Private Sub InitializeVariables(ByVal MainDirectory As String, ByVal ErrorDirectory As String, ByVal BackupDirectory As String, ByVal AutomaticBackup As Boolean, ByVal Recursive As Boolean)

            'this is thrown only if needed
            Dim ex As Exception

            'Set values for Main variables
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If
            If System.IO.Directory.Exists(MainDirectory) Then
                _sMainDirectory = MainDirectory
            Else
                ex = New System.Exception("Invalid Path for Main Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                ex.Data.Add("FolderPolling::InitializeVariables::MainDirectory", MainDirectory)
                Throw ex
            End If
            If System.IO.Directory.Exists(ErrorDirectory) Then
                _sErrorDirectory = ErrorDirectory
            ElseIf ErrorDirectory <> String.Empty Then
                ex = New System.Exception("Invalid Path for Error Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                ex.Data.Add("FolderPolling::InitializeVariables::ErrorDirectory", ErrorDirectory)
                Throw ex
            End If
            If System.IO.Directory.Exists(BackupDirectory) Then
                _sBackupDirectory = BackupDirectory
            ElseIf BackupDirectory <> String.Empty Then
                ex = New System.Exception("Invalid Path for Backup Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                ex.Data.Add("FolderPolling::InitializeVariables::BackupDirectory", BackupDirectory)
                Throw ex
            End If
            _bRecursive = Recursive
            ' checks for invalid data on main variables
            If _sMainDirectory <> String.Empty Then
                _bMainDirDefined = True
            Else
                _bMainDirDefined = False
            End If
            If _sBackupDirectory <> String.Empty Then
                _bBackupFiles = True
            Else
                _bBackupFiles = False
            End If
            If _sErrorDirectory <> String.Empty Then
                _bErrorFiles = True
            Else
                _bErrorFiles = False
            End If
            If _bMainDirDefined And _bBackupFiles Then
                _bAutomaticBackups = AutomaticBackup
            Else
                _bAutomaticBackups = False
            End If
        End Sub

        ''' <summary>
        ''' This Method opens the main folder and grabs the first file
        ''' </summary>
        Private Function GetFiles() As Boolean
            Dim bContinue As Boolean
            GetFiles = False

            If _bMainDirDefined And Not _bGetfiles Then 'Makes sure the Main directory has been defined
                _bGetfiles = True
                _bSubDirectoryUsed = False

                ' reads the sub directories names
                Try
                    _sAllDirectories = System.IO.Directory.GetDirectories(_sMainDirectory)
                Catch ex As Exception
                    Dim pnf_ex As Exception_PathNotFound = New Exception_PathNotFound(_sMainDirectory, ex)
                    ex.Data.Add("FolderPolling::GetFiles::MainDirectory", _sMainDirectory)
                    Throw ex
                End Try

                _enDirectories = _sAllDirectories.GetEnumerator

                If _sAllDirectories.Length > 0 And _bRecursive Then ' makes sure there are subfolders
                    bContinue = True
                    Do
                        If _enDirectories.MoveNext Then
                            _sCurrentDirectory = _enDirectories.Current.ToString
                            If _fpSubdirectory Is Nothing Then
                                _fpSubdirectory = New FolderPolling(_sCurrentDirectory, _sErrorDirectory, _sBackupDirectory, _bAutomaticBackups, _bRecursive)
                            Else
                                _fpSubdirectory.Directory = _sCurrentDirectory
                                _fpSubdirectory.ErrorDirectory = _sErrorDirectory
                                _fpSubdirectory.BackupDirectory = _sBackupDirectory
                                _fpSubdirectory.AutomaticBackups = _bAutomaticBackups
                                _fpSubdirectory.Recursive = _bRecursive
                            End If
                            _fpSubdirectory.Filter = _sFilter
                            _fpSubdirectory.DropBackup = _bDropBackup
                        Else
                            bContinue = False
                        End If
                    Loop While Not _fpSubdirectory.GetFiles() And bContinue

                Else
                    _enDirectories = Nothing
                End If
                ' reads the file names within the main folder
                Try
                    _sAllFiles = System.IO.Directory.GetFiles(_sMainDirectory, _sFilter)
                Catch ex As Exception
                    Throw New Exception_PathNotFound(_sMainDirectory, ex)
                End Try
                _enFiles = _sAllFiles.GetEnumerator
                If _enFiles.MoveNext() Then 'makes sure there are files
                    If _foCurrentFile Is Nothing Then
                        _foCurrentFile = New FileOperation(_enFiles.Current.ToString, _sMainDirectory, _sErrorDirectory, _sBackupDirectory)
                    Else
                        _foCurrentFile.FullName = _enFiles.Current.ToString
                        _foCurrentFile.BasePath = _sMainDirectory
                        _foCurrentFile.ErrorPath = _sErrorDirectory
                        _foCurrentFile.BackupPath = _sBackupDirectory
                    End If
                    _foCurrentFile.AutomaticBackups = _bAutomaticBackups
                    _foCurrentFile.DropBackup = _bDropBackup
                    _foCurrentFile.CleanFileName()
                Else
                    If Not _foCurrentFile Is Nothing Then
                        _foCurrentFile.Dispose()
                        _foCurrentFile = Nothing
                    End If

                    Me.NextFile()
                End If
                If Not _foCurrentFile Is Nothing Then
                    GetFiles = True
                End If
            End If
        End Function

        Public Sub DeleteFiles(ByVal Recursive As Boolean)
            Dim sAllDirectories() As String
            Dim enListDirectories As System.Collections.IEnumerator
            Dim sFiles() As String
            Dim enListFiles As System.Collections.IEnumerator

            Try
                sFiles = System.IO.Directory.GetFiles(_sMainDirectory)
            Catch ex As Exception
                Throw New Exception_PathNotFound(_sMainDirectory, ex)
            End Try

            enListFiles = sFiles.GetEnumerator

            Do While enListFiles.MoveNext
                System.IO.File.Delete(enListFiles.Current.ToString)
            Loop

            If Recursive Then

                Try
                    sAllDirectories = System.IO.Directory.GetDirectories(_sMainDirectory)
                Catch ex As Exception
                    Throw New Exception_PathNotFound(_sMainDirectory, ex)
                End Try

                enListDirectories = _sAllDirectories.GetEnumerator
                Do While enListDirectories.MoveNext
                    System.IO.Directory.Delete(enListDirectories.Current.ToString, Recursive)
                Loop
            End If

        End Sub

        Public Sub DeleteEmptyFolders(ByVal Recursive As Boolean)
            Dim sSubDirectories() As String
            Dim enListDirectories As System.Collections.IEnumerator

            ' Droping object variables
            If Not _fpSubdirectory Is Nothing Then
                _fpSubdirectory.Dispose()
            End If

            _fpSubdirectory = Nothing
            If Not _foCurrentFile Is Nothing Then
                _foCurrentFile.Dispose()
            End If

            _foCurrentFile = Nothing
            _sAllDirectories = Nothing
            _sAllFiles = Nothing
            _enDirectories = Nothing
            _enFiles = Nothing


            ' Delete folders
            If Recursive Then

                Try
                    sSubDirectories = System.IO.Directory.GetDirectories(_sMainDirectory)
                Catch ex As Exception
                    Throw New Exception_PathNotFound(_sMainDirectory, ex)
                End Try

                enListDirectories = sSubDirectories.GetEnumerator
                If sSubDirectories.Length > 0 Then

                    Do While enListDirectories.MoveNext
                        DeleteFolder(enListDirectories.Current.ToString, Recursive)
                    Loop
                End If
            End If

        End Sub

        Private Sub DeleteFolder(ByVal Path As String, Optional ByVal Recursive As Boolean = False)
            Dim sSubDirectories() As String
            Dim enListDirectories As System.Collections.IEnumerator

            Try
                sSubDirectories = System.IO.Directory.GetDirectories(Path)
            Catch ex As Exception
                Throw New Exception_PathNotFound(Path, ex)
            End Try

            enListDirectories = sSubDirectories.GetEnumerator

            If sSubDirectories.Length > 0 And Recursive Then

                Do While enListDirectories.MoveNext
                    DeleteFolder(enListDirectories.Current.ToString, Recursive)
                Loop
            End If

            Try
                sSubDirectories = Nothing
                enListDirectories = Nothing
                GC.Collect()
                System.IO.Directory.Delete(Path)
            Catch

            End Try
        End Sub


#End Region

#Region "Public Properties"
        ''' <summary>
        ''' This property defines if the class should drop the backup files 
        ''' after operation with current file has been completed
        ''' </summary>
        Public Property DropBackup() As Boolean
            Get
                DropBackup = _bDropBackup
            End Get
            Set(ByVal value As Boolean)
                _bDropBackup = value
                If Not _foCurrentFile Is Nothing Then
                    _foCurrentFile.DropBackup = value
                End If
                If Not _fpSubdirectory Is Nothing Then
                    _fpSubdirectory.DropBackup = value
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property defines the filter to be used while retrieving the files
        ''' </summary>
        Public Property Filter() As String
            Get
                Filter = _sFilter
            End Get
            Set(ByVal value As String)
                If value = String.Empty Then
                    _sFilter = "*.*"
                Else
                    _sFilter = value
                End If

                Me.Directory = Me.Directory
            End Set
        End Property

        ''' <summary>
        ''' This property defines if the class should get files through the subdirectories
        ''' </summary>
        Public Property Recursive() As Boolean
            Get
                Recursive = _bRecursive
            End Get
            Set(ByVal value As Boolean)
                _bRecursive = value
                If Not _fpSubdirectory Is Nothing Then
                    _fpSubdirectory.Recursive = value
                End If
                Me._bGetfiles = False
            End Set
        End Property
        ''' <summary>
        ''' This property defines if the class should create an automatic backup of current file
        ''' </summary>
        Public Property AutomaticBackups() As Boolean
            Get
                AutomaticBackups = _bAutomaticBackups
            End Get
            Set(ByVal value As Boolean)
                _bAutomaticBackups = value
                If Not _foCurrentFile Is Nothing Then
                    _foCurrentFile.AutomaticBackups = value
                End If
                If Not _fpSubdirectory Is Nothing Then
                    _fpSubdirectory.AutomaticBackups = _bAutomaticBackups
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the working path
        ''' </summary>
        Public Property Directory() As String
            Get
                Directory = _sMainDirectory
            End Get
            Set(ByVal value As String)
                'makes sure is a valid path
                _bGetfiles = False
                If Not _foCurrentFile Is Nothing Then
                    _foCurrentFile.FullName = ""
                End If
                If Not _fpSubdirectory Is Nothing Then
                    _fpSubdirectory.Dispose(True)
                    _fpSubdirectory = Nothing
                End If
                If value <> String.Empty And System.IO.Directory.Exists(value) Then
                    _sMainDirectory = value
                    _bMainDirDefined = True
                Else
                    _bMainDirDefined = False
                    Throw New System.Exception("Invalid Path for Main Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the working file
        ''' </summary>
        Public ReadOnly Property CurrentFile() As FileOperation
            Get
                CurrentFile = _foCurrentFile
            End Get
        End Property

        ''' <summary>
        ''' This property shows the Error path
        ''' </summary>
        Public Property ErrorDirectory() As String
            Get
                ErrorDirectory = _sErrorDirectory
            End Get
            Set(ByVal value As String)
                'makes sure is a valid path
                If System.IO.Directory.Exists(value) Then
                    _sErrorDirectory = value
                    If Not _fpSubdirectory Is Nothing Then
                        _fpSubdirectory.ErrorDirectory = value
                    End If
                    If Not _foCurrentFile Is Nothing Then
                        _foCurrentFile.ErrorPath = value
                    End If
                    _bErrorFiles = True
                ElseIf value <> String.Empty Then
                    _bErrorFiles = False
                    Throw New System.Exception("Invalid Path for Error Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                End If
            End Set
        End Property

        ''' <summary>
        ''' This property shows the Backup path
        ''' </summary>
        Public Property BackupDirectory() As String
            Get
                BackupDirectory = _sBackupDirectory
            End Get
            Set(ByVal value As String)
                'makes sure is a valid path
                If System.IO.Directory.Exists(value) Then
                    _sBackupDirectory = value
                    If Not _fpSubdirectory Is Nothing Then
                        _fpSubdirectory.BackupDirectory = value
                    End If
                    If Not _foCurrentFile Is Nothing Then
                        _foCurrentFile.BackupPath = value
                    End If
                    _bBackupFiles = True
                ElseIf value <> String.Empty Then
                    _bBackupFiles = False
                    Throw New System.Exception("Invalid Path for Backup Directory" & vbCrLf & vbCrLf & "The Folder does not exist")
                End If
            End Set
        End Property

#End Region

#Region "Public methods"

        ''' <summary>
        ''' This Method select the next file in the list
        ''' if recursive option is enabled will look for next file within subdirectories
        ''' </summary>
        Public Function NextFile() As Boolean
            Dim sNextFile As String = String.Empty

            NextFile = False

            If Not _bGetfiles Then
                If GetFiles() Then
                    NextFile = True
                    Exit Function
                End If
            End If

            If _enFiles Is Nothing Then
                Exit Function
            End If

            If _enFiles.MoveNext() Then
                ' if next file exists then grab file name
                sNextFile = _enFiles.Current.ToString
                If File.Exists(sNextFile) Then
                    _foCurrentFile.FullName = _enFiles.Current.ToString
                    _foCurrentFile.CleanFileName()
                End If
                NextFile = True
            ElseIf _bRecursive And Not _fpSubdirectory Is Nothing Then 'if there is no file available on main directory take next file name from subdirectory
                If Not _bSubDirectoryUsed Then 'if is the first time grab current filename
                    _bSubDirectoryUsed = True
                    If Not _fpSubdirectory.CurrentFile Is Nothing Then
                        _foCurrentFile = _fpSubdirectory.CurrentFile.Copy
                        sNextFile = _foCurrentFile.FullName
                        If _foCurrentFile.FullName <> "" Then
                            NextFile = True
                        End If
                    ElseIf _fpSubdirectory.NextFile Then
                        _foCurrentFile = _fpSubdirectory.CurrentFile.Copy
                        sNextFile = _foCurrentFile.FullName
                        NextFile = True
                    ElseIf Me.NextFile() Then
                        sNextFile = _foCurrentFile.FullName
                        NextFile = True
                    End If


                ElseIf _fpSubdirectory.NextFile Then ' if not first time grab next filename
                    _foCurrentFile = _fpSubdirectory.CurrentFile.Copy
                    sNextFile = _foCurrentFile.FullName
                    NextFile = True

                    'if no more files move to next directory

                ElseIf Not _enDirectories Is Nothing And Not _fpSubdirectory Is Nothing Then
                    If _enDirectories.MoveNext Then
                        _fpSubdirectory.Directory = CType(_enDirectories.Current, Directory).ToString
                        _sCurrentDirectory = CType(_enDirectories.Current, Directory).ToString

                        If _fpSubdirectory.GetFiles() Then
                            _foCurrentFile = _fpSubdirectory.CurrentFile.Copy
                            sNextFile = _foCurrentFile.FullName
                            NextFile = True
                        End If
                    End If
                End If
            End If

            If Not _foCurrentFile Is Nothing Then
                _foCurrentFile.BasePath = _sMainDirectory
            End If

            If NextFile Then
                If Not File.Exists(sNextFile) Then
                    NextFile = Me.NextFile()
                End If
            End If

        End Function


#End Region

#Region "IDisposable Support"
        Protected Overridable Sub dispose(ByVal disposing As Boolean)
            If Not Me.disposed Then
                If disposing Then
                    If Not _foCurrentFile Is Nothing Then
                        _foCurrentFile.Dispose()
                        _foCurrentFile = Nothing
                    End If
                    If Not _fpSubdirectory Is Nothing Then
                        _fpSubdirectory.Dispose()
                        _fpSubdirectory = Nothing
                    End If

                End If
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

#End Region

    End Class
End Namespace

