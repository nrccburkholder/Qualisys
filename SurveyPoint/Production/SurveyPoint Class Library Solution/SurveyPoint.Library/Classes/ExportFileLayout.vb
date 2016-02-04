Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IFileLayout
    Property FileLayoutID() As Integer
End Interface

''' <summary>Each export group has a file layout.  Ex, Coventry - medcare.  This object represents one of those file types.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportFileLayout
    Inherits BusinessBase(Of ExportFileLayout)
    Implements IFileLayout

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFileLayoutID As Integer
    Private mFilelayoutName As String = String.Empty
    Private mVersionNumber As String = String.Empty
    Private mImplementationDate As Date
#End Region

#Region " Public Properties "
    ''' <summary>Key value of the FileLayout table.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FileLayoutID() As Integer Implements IFileLayout.FileLayoutID
        Get
            Return mFileLayoutID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFileLayoutID Then
                mFileLayoutID = value
                PropertyHasChanged("FileLayoutID")
            End If
        End Set
    End Property
    ''' <summary>FileLayoutName value from the file layout table.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FilelayoutName() As String
        Get
            Return mFilelayoutName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFilelayoutName Then
                mFilelayoutName = value
                PropertyHasChanged("FilelayoutName")
            End If
        End Set
    End Property
    ''' <summary>Version number of the file layout</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property VersionNumber() As String
        Get
            Return mVersionNumber
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVersionNumber Then
                mVersionNumber = value
                PropertyHasChanged("VersionNumber")
            End If
        End Set
    End Property
    ''' <summary>Date the file layout was implemented.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ImplementationDate() As Date
        Get
            Return mImplementationDate
        End Get
        Set(ByVal value As Date)
            If Not value = mImplementationDate Then
                mImplementationDate = value
                PropertyHasChanged("ImplementationDate")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new file layout instance</summary>
    ''' <returns>ExportFileLayout Instance</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportFileLayout() As ExportFileLayout
        Return New ExportFileLayout
    End Function

    ''' <summary>Retrieve a file layout instance from the DB based on a file layout id.</summary>
    ''' <param name="fileLayoutID"></param>
    ''' <returns>ExportFileLayout Instance</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal fileLayoutID As Integer) As ExportFileLayout
        Return ExportFileLayoutProvider.Instance.SelectFileLayout(fileLayoutID)
    End Function

    ''' <summary>Factory Method to return all FileLayout records in the database.</summary>
    ''' <returns>ExportFileLayoutCollection Instance</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As ExportFileLayoutCollection
        Return ExportFileLayoutProvider.Instance.SelectAllFileLayouts()
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Allows for key value associate of new objects.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mFileLayoutID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    ''' <summary>Called from private constructor</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>No current implmentation</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        'FileLayoutID = ExportFileLayoutProvider.Instance.InsertSPU_FileLayout(Me)
    End Sub

    ''' <summary>No current implmentation</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        'ExportFileLayoutProvider.Instance.UpdateSPU_FileLayout(Me)
    End Sub

    ''' <summary>No current implmentation</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        'ExportFileLayoutProvider.Instance.DeleteSPU_FileLayout(mFileLayoutID)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class