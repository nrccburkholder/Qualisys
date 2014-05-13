Imports Nrc.Framework.BusinessLogic


''' <summary>UploadFilePackageDisplay business object does not have a corresponding
''' table in the database. It wraps LD_SelectUploadFilesByStudyIDs SP results for displaying purposes
''' only.</summary>
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
Public Class UploadFilePackageDisplay
    Inherits BusinessBase(Of UploadFilePackageDisplay)

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private muploadfileId As Integer
    Private mfileName As String = String.Empty
    Private mpackageId As Integer
    Private mUploadFilePackageID As Integer
    Private mpackageName As String = String.Empty
    Private muploadstateName As String = String.Empty
    Private mstudyId As Integer
#End Region

#Region " Public Properties "
    ''' <summary>The value corresponds to UploadFile_id in UploadFile table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property uploadfileId() As Integer
        Get
            Return muploadfileId
        End Get
        Set(ByVal value As Integer)
            If Not value = muploadfileId Then
                muploadfileId = value
                PropertyHasChanged("uploadfileId")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to File_nm in UploadFile table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property fileName() As String
        Get
            Return mfileName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mfileName Then
                mfileName = value
                PropertyHasChanged("fileName")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to package_id in package table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property packageId() As Integer
        Get
            Return mpackageId
        End Get
        Set(ByVal value As Integer)
            If Not value = mpackageId Then
                mpackageId = value
                PropertyHasChanged("packageId")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to uploadfilepackage_id in UploadFilePackage table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property UploadFilePackageID() As Integer
        Get
            Return mUploadFilePackageID
        End Get
        Set(ByVal value As Integer)
            If Not value = mUploadFilePackageID Then
                mUploadFilePackageID = value
                PropertyHasChanged("UploadFilePackageID")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to strpackage_nm in package table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property packageName() As String
        Get
            Return mpackageName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mpackageName Then
                mpackageName = value
                PropertyHasChanged("packageName")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to uploadstate_nm in uploadstates table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property uploadstateName() As String
        Get
            Return muploadstateName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = muploadstateName Then
                muploadstateName = value
                PropertyHasChanged("uploadstateName")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to study_id in package table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property studyId() As Integer
        Get
            Return mstudyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mstudyId Then
                mstudyId = value
                PropertyHasChanged("studyId")
            End If
        End Set
    End Property
    ''' <summary>The value corresponds to datOccurred field in UploadFileState table when populated via GetByStudiesAndDateRange method.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Dim mDate As Date
    Public Property [Date]() As Date
        Get
            Return mDate
        End Get
        Set(ByVal value As Date)
            mDate = value
            PropertyHasChanged("[Date]")
        End Set
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewUploadFilePackageDisplay() As UploadFilePackageDisplay
        Return New UploadFilePackageDisplay
    End Function

    ''' <summary>Passes the parameters to LD_SelectUploadFilesByStudyIDs SP and 
    ''' returns UploadFilePackageDisplayCollection populated with the SP result. </summary>
    ''' <param name="StudyList"></param>
    ''' <param name="StartDate"></param>
    ''' <param name="EndDate"></param>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetByStudiesAndDateRange(ByVal StudyList As String, ByVal StartDate As Date, ByVal EndDate As Date) As UploadFilePackageDisplayCollection
        If String.IsNullOrEmpty(StudyList) Then
            Return Nothing
        Else
            Return UploadFilePackageDisplayProvider.Instance.GetByStudiesAndDateRange(StudyList, StartDate, EndDate)
        End If
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>The business object does not correspond to a real table row so it can't have an
    ''' identity column so we are fine to return just the guid.</summary>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        Return mInstanceGuid
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

    ''' <summary>We do not want to insert a record into a query result.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        Throw New NotSupportedException("UploadFilePackageDisplay is read only")
    End Sub

    ''' <summary>We do not want to update a record in a query result.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        Throw New NotSupportedException("UploadFilePackageDisplay is read only")
    End Sub

    ''' <summary>We don't want to delete anything from the source data.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        Throw New NotSupportedException("UploadFilePackageDisplay is read only")
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class



