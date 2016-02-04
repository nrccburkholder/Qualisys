Option Explicit On
Option Strict On

Public Enum FileTypes
    NONE = 0
    COMMA_DELIMITED_TEXT = 1
    TAB_DELIMITED_TEXT = 2
    OTHER_DELIMITED_TEXT = 3
    FIXED_WIDTH_TEXT = 4

End Enum

Public MustInherit Class clsFileImportExport

    Protected _dsFileDef As New dsFileDef
    Protected _iFileType As FileTypes = FileTypes.NONE
    Protected _sFilename As String = ""
    Protected _bHasHeader As Boolean = False
    Protected _da As OleDb.OleDbDataAdapter
    Protected _sPath As String = ""
    Protected _sFile As String = ""
    Protected m_ExportHeaders As Boolean = False


    Public Sub New(Optional ByVal sFilename As String = "")
        Me.Filename = sFilename

    End Sub

    Public Overridable ReadOnly Property FileType() As FileTypes
        Get
            Return _iFileType

        End Get
    End Property

    Public Overridable Property Filename() As String
        Get
            Return _sFilename

        End Get
        Set(ByVal Value As String)
            _sFilename = Value
            _sPath = clsUtil.GetPath(_sFilename)
            _sFile = clsUtil.GetFile(_sFilename)

        End Set
    End Property

    Public Overridable Property FileDef() As dsFileDef
        Get
            Return _dsFileDef

        End Get
        Set(ByVal Value As dsFileDef)
            _dsFileDef = Value

        End Set
    End Property

    Public Overridable Property HasHeader() As Boolean
        Get
            Return _bHasHeader

        End Get
        Set(ByVal Value As Boolean)
            _bHasHeader = Value

        End Set
    End Property

    Public Overridable Property ExportHeaderRow() As Boolean
        Get
            Return m_ExportHeaders
        End Get
        Set(ByVal Value As Boolean)
            m_ExportHeaders = Value
        End Set
    End Property


    Public MustOverride Sub Fill(ByRef ds As DataSet, Optional ByVal sTable As String = "")

    Public MustOverride Sub Update(ByRef ds As DataSet, Optional ByVal sTable As String = "")

    Protected MustOverride Function ConnectionString() As String

    Protected Overridable Sub CreateTable()

    End Sub

End Class
