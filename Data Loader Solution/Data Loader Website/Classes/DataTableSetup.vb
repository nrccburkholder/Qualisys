Imports System.data

Public Class DataTableSetup
    Inherits DataTable

    Public Const ParentDataSetSessionName As String = "MyUploads"
    Public Const UploadedTableSession As String = "Uploaded"

    Public Class UploadDataTable
        Public Const _TransactionID As String = "ID"
        Public Const _UploadFileId As String = "ClientFileId"
        Public Const _ClientFilePath As String = "OrigFileName"
        Public Const _FileNotes As String = "UserNotes"
        Public Const _FileType As String = "UploadAction"
        Public Const _UploadFileState As String = "UploadFileState"
        Public Const _GroupID As String = "GroupID"
        Public Const _MemberId As String = "MemberId"
        Public Const _ProjectManager As String = "PM"
        Public Const _ProjectManagerID As String = "PMID"
        Public Const _Package As String = "Package"
        Public Const _PackOrPM As String = "PackagePM"
        Public Const _ControlID As String = "ControlID"
        Public Const _UploadActionID As String = "UploadActionID"
        Public Const _UploadFileTypeID As String = "UploadFileTypeID"
        Public Const _DataTableName As String = "FileUploads"
        Public Const _AutoIncrementSeed As Integer = 1
        Public Const _AutoIncrementStep As Integer = 1
        Public Const _AutoIncrement As Boolean = True
        Public Const _AutoIncrementColumn As String = UploadDataTable._TransactionID


        ''' <summary>Retrieves the array of all the columns for the Upload Datatable</summary>
        ''' <value></value>
        ''' <CreateBy>Brock Fleming</CreateBy>
        ''' <RevisionList>
        ''' <list type="table">
        ''' <listheader>
        ''' <term></term>
        ''' <description>Description</description>
        ''' </listheader>
        ''' <item>
        ''' <term></term>
        ''' <description></description>
        ''' </item>
        ''' <item>
        ''' <term></term>
        ''' <description></description>
        ''' </item>
        ''' </list>
        ''' </RevisionList>
        Public Shared ReadOnly Property DataTableColumnArraylist() As ArrayList
            Get
                Return FillDataTableColumnArraylist()
            End Get
        End Property

        Private Shared Function FillDataTableColumnArraylist() As ArrayList
            Dim ColArray As New ArrayList()
            ColArray.Add(_TransactionID)
            ColArray.Add(_UploadFileId)
            ColArray.Add(_ClientFilePath)
            ColArray.Add(_FileNotes)
            ColArray.Add(_FileType)
            ColArray.Add(_UploadFileState)
            ColArray.Add(_GroupID)
            ColArray.Add(_MemberId)
            ColArray.Add(_ProjectManager)
            ColArray.Add(_Package)
            ColArray.Add(_PackOrPM)
            ColArray.Add(_ControlID)
            ColArray.Add(_UploadActionID)
            ColArray.Add(_UploadFileTypeID)
            ColArray.Add(_ProjectManagerID)
            Return ColArray
        End Function
    End Class

    Public Class UploadedFileDataTable
        Public Const _FileName As String = "FileName"
        Public Const _FileType As String = "FileType"
        Public Const _Packages As String = "Packages"
        Public Const _Status As String = "Status"
        Public Const _DataTableName As String = "UploadedFiles"


        ''' <summary>Retrieves the array of all the columns for the Uploaded Datatable</summary>
        ''' <value></value>
        ''' <CreateBy>Brock Fleming</CreateBy>
        ''' <RevisionList>
        ''' <list type="table">
        ''' <listheader>
        ''' <term></term>
        ''' <description>Description</description>
        ''' </listheader>
        ''' <item>
        ''' <term></term>
        ''' <description></description>
        ''' </item>
        ''' <item>
        ''' <term></term>
        ''' <description></description>
        ''' </item>
        ''' </list>
        ''' </RevisionList>
        Public Shared ReadOnly Property DataTableColumnArraylist() As ArrayList
            Get
                Return FillDataTableColumnArraylist()
            End Get
        End Property

        Private Shared Function FillDataTableColumnArraylist() As ArrayList
            Dim ColArray As New ArrayList()
            ColArray.Add(_FileName)
            ColArray.Add(_FileType)
            ColArray.Add(_Packages)
            ColArray.Add(_Status)
            Return ColArray
        End Function


    End Class



End Class
