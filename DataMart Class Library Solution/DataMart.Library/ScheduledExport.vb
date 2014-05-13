Imports System.IO



Public Class ScheduledExport

#Region " Private Fields "
    Private mId As Integer
    Private mFileName As String
    Private mRunDate As DateTime
    Private mIncludeOnlyReturns As Boolean
    Private mIncludeOnlyDirects As Boolean
    Private mIncludePhoneFields As Boolean
    Private mExportFileType As ExportFileType
    Private mScheduledDate As DateTime
    Private mScheduledBy As String
    Private mExportSets As New Collection(Of ExportSet)
#End Region

#Region " Public Properties "
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property RunDate() As DateTime
        Get
            Return mRunDate
        End Get
        Set(ByVal value As DateTime)
            mRunDate = value
        End Set
    End Property

    Public Property IncludeOnlyReturns() As Boolean
        Get
            Return mIncludeOnlyReturns
        End Get
        Set(ByVal value As Boolean)
            mIncludeOnlyReturns = value
        End Set
    End Property

    Public Property IncludePhoneFields() As Boolean
        Get
            Return mIncludePhoneFields
        End Get
        Set(ByVal value As Boolean)
            mIncludePhoneFields = value
        End Set
    End Property

    Public Property IncludeOnlyDirects() As Boolean
        Get
            Return mIncludeOnlyDirects
        End Get
        Set(ByVal value As Boolean)
            mIncludeOnlyDirects = value
        End Set
    End Property
    Public Property ExportFileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            mFileName = value
        End Set
    End Property

    Public Property ExportFileType() As ExportFileType
        Get
            Return mExportFileType
        End Get
        Set(ByVal value As ExportFileType)
            mExportFileType = value
        End Set
    End Property

    Public Property ScheduledDate() As DateTime
        Get
            Return mScheduledDate
        End Get
        Set(ByVal value As DateTime)
            mScheduledDate = value
        End Set
    End Property

    Public Property ScheduledBy() As String
        Get
            Return mScheduledBy
        End Get
        Set(ByVal value As String)
            mScheduledBy = value
        End Set
    End Property

    Public ReadOnly Property ExportSets() As Collection(Of ExportSet)
        Get
            Return mExportSets
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
#End Region

#Region " Public Methods "

#Region " DB CRUD Methods "
    Public Shared Function [Get](ByVal scheduledExportId As Integer) As ScheduledExport
        Return DataProvider.Instance.SelectScheduledExport(scheduledExportId)
    End Function

    Public Shared Function GetAll(ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
        Return DataProvider.Instance.SelectAllScheduledExports(startFilterDate, endFilterDate)
    End Function

    Public Shared Function GetByClientId(ByVal clientId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
        Return DataProvider.Instance.SelectScheduledExportsByClientId(clientId, startFilterDate, endFilterDate)
    End Function

    Public Shared Function GetByStudyId(ByVal studyId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
        Return DataProvider.Instance.SelectScheduledExportsByStudyId(studyId, startFilterDate, endFilterDate)
    End Function

    Public Shared Function GetBySurveyId(ByVal surveyId As Integer, ByVal startFilterDate As Date, ByVal endFilterDate As Date) As Collection(Of ScheduledExport)
        Return DataProvider.Instance.SelectScheduledExportsBySurveyId(surveyId, startFilterDate, endFilterDate)
    End Function

    Public Shared Function GetNextScheduledExport() As ScheduledExport
        Return DataProvider.Instance.SelectNextScheduledExport
    End Function

    Public Shared Function CreateNew(ByVal exportSets As Collection(Of ExportSet), ByVal runDate As DateTime, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFiles As Boolean, ByVal fileType As ExportFileType, ByVal fileName As String, ByVal userName As String) As ScheduledExport
        If exportSets IsNot Nothing AndAlso exportSets.Count > 0 Then
            Dim newId As Integer = DataProvider.Instance.InsertScheduledExport(runDate, includeOnlyReturns, includeOnlyDirects, includePhoneFiles, fileType, fileName, userName)
            For Each export As ExportSet In exportSets
                DataProvider.Instance.InsertScheduledExportSet(newId, export.Id)
            Next

            Return DataProvider.Instance.SelectScheduledExport(newId)
        Else
            Throw New ArgumentNullException("exportSets")
        End If
    End Function

    Public Sub Update()
        DataProvider.Instance.UpdateScheduledExport(mId, mRunDate, mFileName)
    End Sub

    Public Shared Sub Delete(ByVal scheduledExportId As Integer)
        DataProvider.Instance.DeleteScheduledExport(scheduledExportId)
    End Sub

#End Region
    Public Sub CreateFile(ByVal outputFolderPath As String)
        Dim filePath As String = System.IO.Path.Combine(outputFolderPath, GenerateFileName)
        ExportFile.CreateExportFile(Me.ExportSets, filePath, mExportFileType, mIncludeOnlyReturns, mIncludeOnlyDirects, mIncludePhoneFields, "Export Service", True)
    End Sub
#End Region

#Region " Private Methods "
    ''' <summary>This method parses together the filename and extension.  If no file
    ''' name is set, the is defaults to ScheduledExport_FileID</summary>
    ''' <returns>Full File name</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20071213 - Tony Piccoli</term>
    ''' <description>Removed the File ID from the file name when a filename
    ''' exists.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Function GenerateFileName() As String
        Dim ext As String = GetFileExtension(mExportFileType)

        If String.IsNullOrEmpty(Me.ExportFileName) Then
            Return "ScheduledExport_" & Me.Id & ext
        Else
            'Return Nrc.Framework.IO.Path.CleanFileName(Me.ExportFileName) & " (" & Me.Id & ")" & ext
            Return Nrc.Framework.IO.Path.CleanFileName(Me.ExportFileName) & ext
        End If

    End Function

    Private Shared Function GetFileExtension(ByVal fileType As ExportFileType) As String
        Select Case fileType
            Case Library.ExportFileType.Csv
                Return ".csv"
            Case Library.ExportFileType.DBase
                Return ".dbf"
            Case Library.ExportFileType.Xml
                Return ".xml"
            Case Else
                Throw New ArgumentOutOfRangeException("Cannot create extension for unknown ExportFileType")
        End Select
    End Function


#End Region

End Class
