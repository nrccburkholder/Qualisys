Imports NRC.DataLoader.Library
Imports NRC.Qualisys.QLoader.Library
Imports NRC.NRCAuthLib
''' <summary>This class takes an UploadFilePackage object as the constructor parameter and
''' Populates its properties for later use in UploadEmailManager class.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class eMailInfo
    Public Sub New(ByRef pkg As UploadFilePackage, ByVal pMailType As UploadNotificationMailType, ByRef pUploadedFile As UploadFile)
        If pkg Is Nothing Then
            Throw New Exception("Underlying DtsPackage object cannot be nothing")
        End If
        Me.mEMailType = pMailType
        Me.mUploadedFile = pUploadedFile
        Me.mUploadFilePackage = pkg
    End Sub

    Public Sub New(ByRef pProjectManager As ProjectManager, ByVal pMailType As UploadNotificationMailType, ByRef pUploadedFile As UploadFile)
        If pProjectManager Is Nothing Then
            Throw New Exception("Underlying Measurement Services Manager object cannot be nothing")
        End If
        Me.mEMailType = pMailType
        Me.mProjectManager = pProjectManager.FullName
        Me.mUploadedFile = pUploadedFile
    End Sub

    Private mProjectManager As String
    Private mTeamID As Integer
    Private mEMailType As UploadNotificationMailType
    Private mUploadedFile As UploadFile
    Private mUploadFilePackage As UploadFilePackage
#Region "Public Properties"
    ''' <summary>Currently unused. Desired feauture.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ProjectManager() As String
        Get
            If Not UploadedFile.ProjectManager Is Nothing Then
                Return UploadedFile.ProjectManager.FullName
            Else
                Return String.Empty
            End If

        End Get
    End Property
    Public ReadOnly Property UserName() As String
        Get
            Return CurrentUser.Member.FullName
        End Get
    End Property
    Public ReadOnly Property OwnerEmail() As String
        Get
            Dim Mem As String = String.Empty
            Dim MemId As Integer = UsedDTSPackage.OwnerMemberID.Value
            Mem = NRC.NRCAuthLib.Member.GetMember(MemId).EmailAddress
            Return Mem
        End Get
    End Property


    Public ReadOnly Property EMailType() As UploadNotificationMailType
        Get
            Return mEMailType
        End Get
    End Property
    Public ReadOnly Property PackageName() As String
        Get
            Return UsedDTSPackage.PackageFriendlyName
        End Get
    End Property
    Public ReadOnly Property StudyName() As String
        Get
            Return Study.StudyName
        End Get
    End Property
    Public ReadOnly Property ClientName() As String
        Get
            Return Study.ClientName
        End Get
    End Property
    ''' <summary>Returns just the file name with the extension from the original full
    ''' path of the uploaded file.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>05/28/2008- Arman Mnatsakanyan</term>
    ''' <description>Modified to return just the file name instead of the full
    ''' path.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property OriginalFileName() As String
        Get
            Return IO.Path.GetFileName(UploadedFile.OrigFileName)
        End Get
    End Property
    Public ReadOnly Property SavedFileName() As String
        Get
            Return UploadedFile.FileName
        End Get
    End Property
    Public ReadOnly Property UploadedFile() As UploadFile
        Get
            Return mUploadedFile
        End Get
    End Property
    Public ReadOnly Property Study() As Study
        Get
            Return UsedDTSPackage.Study
        End Get
    End Property
    Public ReadOnly Property UploadDate() As Date
        Get
            Return UploadedFile.UploadFileState.datOccurred
        End Get
    End Property
#End Region
#Region "Private Properties"
    Public ReadOnly Property UsedDTSPackage() As DTSPackage
        Get
            Return FilePackage.Package
        End Get
    End Property

    Private ReadOnly Property FilePackage() As UploadFilePackage
        Get
            Return mUploadFilePackage
        End Get
    End Property
#End Region

End Class
