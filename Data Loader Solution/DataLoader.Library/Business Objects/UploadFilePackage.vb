Imports Nrc.Framework.BusinessLogic
Imports Nrc.Qualisys.QLoader.Library
Public Interface IUploadFilePackage
    Property Id() As Integer
End Interface

''' <summary>UploadFilePackage business class. Any uploaded file can have 1 or more
''' associated DTS packages. Therefore UploadFile has a collection of
''' UploadFilePackage (UploadFilePackageCollection). Maps to UploadFilePackage table in QP_Load DB</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class UploadFilePackage
    Inherits BusinessBase(Of UploadFilePackage)
    Implements IUploadFilePackage

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mUploadFileId As Integer
    Private mPackageId As Nullable(Of Integer)
    Private mPackage As DTSPackage
#End Region

#Region " Public Properties "
    ''' <summary>Maps to the identity field of UploadFilePackage</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Id() As Integer Implements IUploadFilePackage.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    ''' <summary>UploadFileID() maps to UploadFile_id field in UploadFilePackage table
    ''' and is a foreign key to UploadFile.UploadFile_id.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Property UploadFileId() As Integer
        Get
            Return mUploadFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mUploadFileId Then
                mUploadFileId = value
                PropertyHasChanged("UploadFileId")
            End If
        End Set
    End Property
 
    ''' <summary>Package() property maps to PackageID field in UploadFilePackage table
    ''' and is a Foreign key to Package table that holds DTS packages.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Property Package() As DTSPackage
        Get
            If mPackage Is Nothing Then
                mPackage = DTSPackage.GetPackageByID(mPackageId)
            End If
            Return mPackage
        End Get
        Set(ByVal value As DTSPackage)
            If value IsNot Nothing Then
                mPackageId = value.PackageID
            End If
            If value IsNot mPackage Then
                mPackage = value
                PropertyHasChanged("Package")
            End If
        End Set
    End Property
    ''' <summary>Should be used in Populate method only.</summary>
    ''' <param name="id"></param>
    Public Sub SetPackageID(ByVal id As Integer)
        If Me.mPackageId.HasValue = False Then
            Me.mPackageId = id
        Else
            Throw New Exception("PackageID can be assigned only once in the populate method. Change the Package object instead.")
        End If
    End Sub
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewUploadFilePackage() As UploadFilePackage
        Return New UploadFilePackage
    End Function

    'Public Shared Function [Get](ByVal id As Integer) As UploadFilePackage
    '    Return UploadFilePackageProvider.Instance.SelectUploadFilePackage(id)
    'End Function

    'Public Shared Function GetAll() As UploadFilePackageCollection
    '    Return UploadFilePackageProvider.Instance.SelectAllUploadFilePackages()
    'End Function
    Public Shared Function GetByUploadFile(ByVal pUploadFile As UploadFile) As UploadFilePackageCollection
        Return UploadFilePackageProvider.Instance.SelectUploadFilePackagesByUploadFile(pUploadFile)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        Id = UploadFilePackageProvider.Instance.InsertUploadFilePackage(Me)
    End Sub

    Protected Overrides Sub Update()
        UploadFilePackageProvider.Instance.UpdateUploadFilePackage(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        UploadFilePackageProvider.Instance.DeleteUploadFilePackage(mId)
    End Sub
    Public Overrides Sub Save()
        MyBase.Save()
    End Sub
#End Region

#Region " Public Methods "

#End Region

End Class

