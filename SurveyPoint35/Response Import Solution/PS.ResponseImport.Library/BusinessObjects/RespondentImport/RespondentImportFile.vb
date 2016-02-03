Imports System.IO
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Data
''' <summary>
''' This class handles the importing for a single respondent answer file.
''' It is not a business base object as there is no need of a data store for
''' this object.
''' </summary>
''' <remarks></remarks>
Public Class RespondentImportFile    
#Region " Private Fields "
    Private mRespImportFileID As String = Guid.NewGuid().ToString
    Private mFileName As String = String.Empty
    Private mCurrentDirectory As String = String.Empty
    Private mOutputDirectory As String = String.Empty
    Private mErrorsDirectory As String = String.Empty
    Private mFileType As SurveySystemType = Nothing
    Private mFileLines As New List(Of String)
    Private mFileDefDataTable As DataTable = Nothing
    Private mRecordCount As Long = 0    
#End Region
#Region " Constructors "
    Public Sub New()

    End Sub
    Public Sub New(ByVal fn As String, ByVal cd As String, ByVal od As String, ByVal ed As String, ByVal ft As SurveySystemType)
        Me.mFileName = fn
        Me.mCurrentDirectory = cd
        Me.mOutputDirectory = od
        Me.mErrorsDirectory = ed
        Me.mFileType = ft
    End Sub
#End Region
#Region " Properties "
    Public Property FileName() As String
        Get
            Return Me.mFileName
        End Get
        Set(ByVal value As String)
            Me.mFileName = value
        End Set
    End Property    
    Public Property CurrentDirectory() As String
        Get
            Return Me.mCurrentDirectory
        End Get
        Set(ByVal value As String)
            Me.mCurrentDirectory = value
        End Set
    End Property
    Public Property OutputDirectory() As String
        Get
            Return Me.mOutputDirectory
        End Get
        Set(ByVal value As String)
            Me.mOutputDirectory = value
        End Set
    End Property    
    Public Property ErrorsDirectory() As String
        Get
            Return Me.mErrorsDirectory
        End Get
        Set(ByVal value As String)
            Me.mErrorsDirectory = value
        End Set
    End Property
    Public Property FileType() As SurveySystemType
        Get
            Return Me.mFileType
        End Get
        Set(ByVal value As SurveySystemType)
            Me.mFileType = value
        End Set
    End Property
    Public ReadOnly Property RecordCount() As Long
        Get
            Return Me.mRecordCount
        End Get
    End Property
    Public ReadOnly Property RespImportFileID() As String
        Get
            Return Me.mRespImportFileID
        End Get
    End Property
    Public ReadOnly Property CurrentDirFilePath() As String
        Get
            Return Me.CurrentDirectory & "\" & FileName
        End Get
    End Property

#End Region
#Region " Public Methods "
    ''' <summary>
    ''' Publicly exposed method to import the responses from the datafile.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub ProcessFile()
        'Make sure the file and folders exist.
        RespondentImportFileLog.AddLogEntry(Me.mRespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, 0, Nothing, "Begin import of file.", Me.FileType)
        ValidatePhysicalFile()
        RespondentImportFileLog.AddLogEntry(Me.mRespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, 0, Nothing, "Physical file validation complete.", Me.FileType)
        ImportFileData()       
    End Sub
#End Region
#Region " Private Methods "    
    ''' <summary>
    ''' This method validates the files and directories used in processing the file.
    ''' It does not move the file but rather throws an exception to let the controlling class handle
    ''' it.  This is because either the files or dir's needed to handle the move don't exist.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ValidatePhysicalFile()
        Dim retVal As New List(Of String)
        If Not (Directory.Exists(Me.CurrentDirectory)) Then
            retVal.Add("Current Directory does not exist.")
        End If
        If Not (Directory.Exists(Me.ErrorsDirectory)) Then
            retVal.Add("Errors Directory does not exist.")
        End If
        If Not (Directory.Exists(Me.OutputDirectory)) Then
            retVal.Add("Output directory does not exist.")
        End If
        If Not (File.Exists(Me.CurrentDirFilePath)) Then
            retVal.Add("The Current file to process does not exist.")
        End If
        If retVal.Count > 0 Then
            Dim sb As New StringBuilder
            For Each Str As String In retVal
                sb.AppendLine(Str)
            Next
            RespondentImportFileLog.AddLogEntry(Me.mRespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, 0, Nothing, Left(sb.ToString(), 7000), Me.FileType)
            Throw New AppException(retVal)
        End If
    End Sub
    ''' <summary>
    ''' This method reads the file line by line, validating and importing the responses into QMS.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ImportFileData()
        Dim sr As StreamReader = Nothing
        Try
            RespondentImportFileLog.AddLogEntry(Me.RespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, 0, Nothing, "Begining Import", Me.FileType)
            sr = New StreamReader(Me.CurrentDirFilePath, System.Text.Encoding.ASCII)
            Do While sr.Peek >= 0
                Dim strLine As String = sr.ReadLine
                'Put in memory so you can close the connection.                
                mFileLines.Add(strLine)
            Loop
            sr.Close()
            sr = Nothing
            Me.mRecordCount = mFileLines.Count
            RespondentImportFileLog.AddLogEntry(Me.RespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, Me.mRecordCount, Nothing, "Import Count", Me.FileType)
            For i As Long = 0 To Me.mFileLines.Count - 1
                If Me.mFileLines.Count - 1 = i AndAlso mFileLines(i).Length <= 1 Then
                    'Do nothing, this allows for a lf feed at the end of a file.
                Else
                    Dim fLine As New RespondentImportFileLine(Me.mFileLines(i), i, Me.RespImportFileID, Me.mFileType)
                    fLine.LoadLine()
                End If                
            Next
            RespondentImportFileLog.AddLogEntry(Me.RespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, Me.mRecordCount, Nothing, "Import Completed", Me.FileType)
            TransferFileToArchiveDir(Me.CurrentDirectory, Me.FileName)
            RespondentImportFileLog.AddLogEntry(Me.RespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, Me.mRecordCount, Now, "Import Archived", Me.FileType)
        Catch ex As Exception
            'Note that we do not rethrow the error.  we want to continue processing other
            'files even if this one errors out.
            If sr IsNot Nothing Then
                sr.Close()
                sr = Nothing
            End If
            RespondentImportFileLog.AddLogEntry(Me.RespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, Me.mRecordCount, Nothing, "Import Error:" & ex.Message & " StackTrack: " & Left(ex.StackTrace, 7000), Me.FileType)
            TransferFileToErrorDir(Me.CurrentDirectory, Me.FileName)
            RespondentImportFileLog.AddLogEntry(Me.RespImportFileID, LogSeverity.Informational, Me.FileName, Me.CurrentDirectory, Me.mRecordCount, Nothing, "Import File sent to Errors folder", Me.FileType)
        Finally
            If sr IsNot Nothing Then
                sr.Close()
                sr = Nothing
            End If
        End Try
    End Sub
    ''' <summary>
    ''' This methods moves the processesing file to the errors directory.
    ''' No exception handling here, this type of file i/o error will be handled at the serivice level.
    ''' </summary>
    ''' <param name="currentDir"></param>
    ''' <param name="currentName"></param>
    ''' <remarks></remarks>
    Private Sub TransferFileToErrorDir(ByVal currentDir As String, ByVal currentName As String)
        System.IO.File.Copy(currentDir & "\" & currentName, Me.ErrorsDirectory & "\" & Me.FileName, False)
        System.IO.File.Delete(currentDir & "\" & currentName)
    End Sub
    ''' <summary>
    ''' This method moves a file that has completed processing to the output/archive directory.
    ''' We make a sub directory 'YYYYMM' so that no folder grow too large.
    ''' </summary>
    ''' <param name="currentDir"></param>
    ''' <param name="currentName"></param>
    ''' <remarks></remarks>
    Private Sub TransferFileToArchiveDir(ByVal currentDir As String, ByVal currentName As String)
        Dim outputDir As String = Me.OutputDirectory & "\F" & Year(Now) & Month(Now)
        If Not Directory.Exists(outputDir) Then
            Directory.CreateDirectory(outputDir)
        End If
        File.Copy(currentDir & "\" & currentName, outputDir & "\" & currentName, False)
        File.Delete(currentDir & "\" & currentName)
    End Sub
#End Region
End Class
Public MustInherit Class RespondentImportFileProvider
#Region " Singleton Implementation "
    Private Shared mInstance As RespondentImportFileProvider
    Private Const mProviderName As String = "RespondentImportFileProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As RespondentImportFileProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of RespondentImportFileProvider)(mProviderName)
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

#End Region
End Class
