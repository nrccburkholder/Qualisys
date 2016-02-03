Public Class RespondentImportFolders
    Inherits List(Of RespondentImportFolder)

End Class
''' <summary>
''' Non-bussiness based class that acts as a container for folder sturctures used
''' in the respondent import processes.
''' </summary>
''' <remarks></remarks>
Public Class RespondentImportFolder
#Region " Fields "
    Private mbaseFolderPath As String = String.Empty
    Private mfolderType As SurveySystemType
#End Region
#Region " Constructors "
    Public Sub New(ByVal baseFolderPath As String, ByVal folderType As SurveySystemType)
        Me.mbaseFolderPath = baseFolderPath
        Me.mfolderType = folderType
    End Sub
#End Region
#Region " Properties "
    Public ReadOnly Property BaseFolderPath() As String
        Get
            Return Me.mbaseFolderPath
        End Get
    End Property
    Public ReadOnly Property FolderType() As String
        Get
            Return Me.mfolderType
        End Get
    End Property
    Public ReadOnly Property InDirectory() As String
        Get
            Return Me.mbaseFolderPath & "/IN"
        End Get
    End Property
    Public ReadOnly Property ProcessingDirectory() As String
        Get
            Return Me.mbaseFolderPath & "/Processing"
        End Get
    End Property
    Public ReadOnly Property ErrorsDirectory() As String
        Get
            Return Me.mbaseFolderPath & "/Errors"
        End Get
    End Property
    Public ReadOnly Property ManualDirectory() As String
        Get
            Return Me.mbaseFolderPath & "/Manual"
        End Get
    End Property
    Public ReadOnly Property ArchiveFolder() As String
        Get
            Return Me.mbaseFolderPath & "/Archive"
        End Get
    End Property
#End Region
End Class
