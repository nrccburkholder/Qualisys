''' <summary>
''' Represents a DataMart Sample Unit
''' </summary>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class SampleUnit

#Region " Private Fields "

    Private mId As Integer
    Private mName As String
    Private mSurveyId As Integer
    Private mParentSampleUnitId As Nullable(Of Integer)
    Private mChildUnits As Collection(Of SampleUnit)
    Private mMedicareNumber As String
    Private mMedicareName As String
    Private mIsHcahps As Boolean

    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    ''' <summary></summary>
    ''' <value></value>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The sample unit name</summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>Sample Unit SurveyID </summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The Parent Sample Unit Id for a sample unit </summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ParentSampleUnitId() As Nullable(Of Integer)
        Get
            Return mParentSampleUnitId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mParentSampleUnitId = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>The Parent Sample Unit Id for a sample unit </summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            mMedicareNumber = value
        End Set
    End Property

    ''' <summary>Medicare name for sample unit </summary>
    ''' <value></value>
    ''' <CreatedBy>Steve Grunberg</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareName() As String
        Get
            Return mMedicareName
        End Get
        Set(ByVal value As String)
            mMedicareName = value
        End Set
    End Property

    ''' <summary>The sample unit is HCAPS </summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property IsHcahps() As Boolean
        Get
            Return mIsHcahps
        End Get
        Set(ByVal value As Boolean)
            mIsHcahps = value
        End Set
    End Property

    ''' <summary>A collection of child sample units for this sample unit</summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ChildUnits() As Collection(Of SampleUnit)
        Get
            Return mChildUnits
        End Get
    End Property

    ''' <summary>A helper property for the UI to show the IDs with the name.</summary>
    ''' <value></value>
    ''' <CreatedBy></CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property DisplayLabel() As String
        Get
            Return mName & " (" & mId & ")"
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
#End Region

#Region " Public Methods "

#Region " DB CRUD Methods "
    Public Shared Function [Get](ByVal sampleUnitId As Integer) As SampleUnit
        Return DataProvider.Instance.SelectSampleUnit(sampleUnitId)
    End Function

    Public Shared Function GetByMedicareNumber(ByVal medicareNumber As String) As Collection(Of SampleUnit)
        Return DataProvider.Instance.SelectSampleUnitsByMedicareNumber(medicareNumber)
    End Function
#End Region

    ''' <summary>
    ''' Returns all the ExportSet objects that thave been created for the sample unit within the date range specified
    ''' </summary>
    ''' <param name="creationFilterStartDate">The starting date used to filter the results</param>
    ''' <param name="creationFilterEndDate">The ending date used to filter the results</param>
    ''' <returns>
    ''' Returns a collection of ExportSet objects belonging to the sample unit and were created
    ''' during the date range specified.
    ''' </returns>
    Public Function GetExportSets(ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)
        Return DataProvider.Instance.SelectExportSetsBySampleUnitId(mId, creationFilterStartDate, creationFilterEndDate, exportType)
    End Function

    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
#End Region

End Class
