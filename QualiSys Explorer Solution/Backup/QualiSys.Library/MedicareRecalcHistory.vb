Imports Nrc.Framework.BusinessLogic

''' <summary>Interface to encapsulate key and allow DAL to do key assignment.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Interface IMedicareRecalcHistory

    Property MedicareReCalcLogId() As Integer

End Interface

''' <summary>This class represents a historical record of when a medicare numbers proportion was recalculated.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class MedicareRecalcHistory
    Inherits BusinessBase(Of MedicareRecalcHistory)
    Implements IMedicareRecalcHistory

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicareReCalcLogId As Integer
    Private mMedicareNumber As String = String.Empty
    Private mMedicareName As String = String.Empty
    Private mMedicarePropCalcTypeID As Integer
    Private mMedicarePropDataTypeID As Integer
    Private mEstRespRate As Decimal
    Private mEstIneligibleRate As Decimal
    Private mEstAnnualVolume As Integer
    Private mSwitchToCalcDate As Date
    Private mAnnualReturnTarget As Integer
    Private mProportionCalcPct As Decimal
    Private mSamplingLocked As Boolean
    Private mProportionChangeThreshold As Decimal
    Private mCensusForced As Boolean
    Private mMemberId As Integer
    Private mDateCalculated As Date
    Private mHistoricRespRate As Decimal
    Private mHistoricAnnualVolume As Integer
    Private mForcedCalculation As Boolean
    Private mPropSampleCalcDate As Date

#End Region

#Region " Public Properties "

    ''' <summary>PK for object.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareReCalcLogId() As Integer Implements IMedicareRecalcHistory.MedicareReCalcLogId
        Get
            Return mMedicareReCalcLogId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mMedicareReCalcLogId Then
                mMedicareReCalcLogId = value
                PropertyHasChanged("MedicareReCalcLogId")
            End If
        End Set
    End Property

    ''' <summary>FK to Medicare Lookup for object.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMedicareNumber Then
                mMedicareNumber = value
                PropertyHasChanged("MedicareNumber")
            End If
        End Set
    End Property

    ''' <summary>Name of the Medicare lookup.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareName() As String
        Get
            Return mMedicareName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMedicareName Then
                mMedicareName = value
                PropertyHasChanged("MedicareName")
            End If
        End Set
    End Property

    ''' <summary>Type of calculation to use (estimated or calculated from historic)</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicarePropCalcTypeID() As Integer
        Get
            Return mMedicarePropCalcTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mMedicarePropCalcTypeID Then
                mMedicarePropCalcTypeID = value
                PropertyHasChanged("MedicarePropCalcTypeID")
            End If
        End Set
    End Property

    ''' <summary>The actual type of calculation used (estimated or calculated from historic).</summary>
    ''' <value></value>
    ''' <CreatedBy>Keith Charron</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicarePropDataTypeID() As Integer
        Get
            Return mMedicarePropDataTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mMedicarePropDataTypeID Then
                mMedicarePropDataTypeID = value
                PropertyHasChanged("MedicarePropDataTypeID")
            End If
        End Set
    End Property

    ''' <summary>Estimate of respose rate used in calculation.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EstRespRate() As Decimal
        Get
            Return mEstRespRate
        End Get
        Set(ByVal value As Decimal)
            mEstRespRate = value
            PropertyHasChanged("EstRespRate")
        End Set
    End Property

    ''' <summary>Estimate of Ineligible rate used in calculation.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EstIneligibleRate() As Decimal
        Get
            Return mEstIneligibleRate
        End Get
        Set(ByVal value As Decimal)
            mEstIneligibleRate = value
            PropertyHasChanged("EstIneligibleRate")
        End Set
    End Property

    ''' <summary>Estaimate of annual volume used in calcuation.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EstAnnualVolume() As Integer
        Get
            Return mEstAnnualVolume
        End Get
        Set(ByVal value As Integer)
            mEstAnnualVolume = value
            PropertyHasChanged("EstAnnualVolume")
        End Set
    End Property

    ''' <summary>Date at which to switch from using estimates to using historic rates.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SwitchToCalcDate() As Date
        Get
            Return mSwitchToCalcDate
        End Get
        Set(ByVal value As Date)
            mSwitchToCalcDate = value
            PropertyHasChanged("SwitchToCalcDate")
        End Set
    End Property

    ''' <summary>Historic annual return target.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property AnnualReturnTarget() As Integer
        Get
            Return mAnnualReturnTarget
        End Get
        Set(ByVal value As Integer)
            mAnnualReturnTarget = value
            PropertyHasChanged("AnnualReturnTarget")
        End Set
    End Property

    ''' <summary>The proportion that was calculated.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ProportionCalcPct() As Decimal
        Get
            Return mProportionCalcPct
        End Get
        Set(ByVal value As Decimal)
            mProportionCalcPct = value
            PropertyHasChanged("ProportionCalcPct")
        End Set
    End Property

    ''' <summary>If threshold percentage is exceeded between calculations, then sampling locks.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SamplingLocked() As Boolean
        Get
            Return mSamplingLocked
        End Get
        Set(ByVal value As Boolean)
            mSamplingLocked = value
            PropertyHasChanged("SamplingLocked")
        End Set
    End Property

    ''' <summary>Percent of change between calculations that will lock sampling.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ProportionChangeThreshold() As Decimal
        Get
            Return mProportionChangeThreshold
        End Get
        Set(ByVal value As Decimal)
            mProportionChangeThreshold = value
            PropertyHasChanged("ProportionChangeThreshold")
        End Set
    End Property

    Public Property CensusForced() As Boolean
        Get
            Return mCensusForced
        End Get
        Set(ByVal value As Boolean)
            mCensusForced = value
            PropertyHasChanged("CensusForced")
        End Set
    End Property

    ''' <summary>ID of the signed in user.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MemberId() As Integer
        Get
            Return mMemberId
        End Get
        Set(ByVal value As Integer)
            mMemberId = value
            PropertyHasChanged("MemberId")
        End Set
    End Property

    ''' <summary>Date the calculation was performed.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DateCalculated() As Date
        Get
            Return mDateCalculated
        End Get
        Set(ByVal value As Date)
            mDateCalculated = value
            PropertyHasChanged("DateCalculated")
        End Set
    End Property

    ''' <summary>Historic response rate.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property HistoricRespRate() As Decimal
        Get
            Return mHistoricRespRate
        End Get
        Set(ByVal value As Decimal)
            mHistoricRespRate = value
            PropertyHasChanged("HistoricRespRate")
        End Set
    End Property

    ''' <summary>Historic annual volume.</summary>
    ''' <value></value>
    ''' <CreatedBy>Keith Charron</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property HistoricAnnualVolume() As Integer
        Get
            Return mHistoricAnnualVolume
        End Get
        Set(ByVal value As Integer)
            mHistoricAnnualVolume = value
            PropertyHasChanged("HistoricAnnualVolume")
        End Set
    End Property

    ''' <summary>Flags whether calculation was time based or user based.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ForcedCalculation() As Boolean
        Get
            Return mForcedCalculation
        End Get
        Set(ByVal value As Boolean)
            mForcedCalculation = value
            PropertyHasChanged("ForcedCalculation")
        End Set
    End Property

    ''' <summary>This is the date for the quarter the calcuation is being done in.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property PropSampleCalcDate() As Date
        Get
            Return Me.mPropSampleCalcDate
        End Get
        Set(ByVal value As Date)
            Me.mPropSampleCalcDate = value
            PropertyHasChanged("PropSampleCalcDate")
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    ''' <summary>Create a new object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewMedicareRecalcHistory() As MedicareRecalcHistory

        Return New MedicareRecalcHistory

    End Function

    ''' <summary>Get object by its data store id.</summary>
    ''' <param name="medicareReCalcLogId"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal medicareReCalcLogId As Integer) As MedicareRecalcHistory

        Return DataProvider.MedicareRecalcHistoryProvider.Instance.Get(medicareReCalcLogId)

    End Function

    ''' <summary>Get all recalc history object from data store.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As MedicareRecalcHistoryCollection

        Return DataProvider.MedicareRecalcHistoryProvider.Instance.GetAll()

    End Function

    ''' <summary>Get the lastest record by medicare number.</summary>
    ''' <param name="medicareNumber"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetLatestByMedicareNumber(ByVal medicareNumber As String, ByVal latestDate As Date) As MedicareRecalcHistory

        Return DataProvider.MedicareRecalcHistoryProvider.Instance.GetLatestByMedicareNumber(medicareNumber, latestDate)

    End Function

    ''' <summary>Get the lastest record by medicare number and sample date.</summary>
    ''' <param name="medicareNumber"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetLatestBySampleDate(ByVal medicareNumber As String, ByVal sampleDate As Date) As MedicareRecalcHistory

        Return DataProvider.MedicareRecalcHistoryProvider.Instance.GetLatestBySampleDate(medicareNumber, sampleDate)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mMedicareReCalcLogId
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

    ''' <summary>Dal insert.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()

        mMedicareReCalcLogId = DataProvider.MedicareRecalcHistoryProvider.Instance.Insert(Me)
        Me.MarkOld()

    End Sub

    ''' <summary>Dal Update</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()

        DataProvider.MedicareRecalcHistoryProvider.Instance.Update(Me)

    End Sub

    ''' <summary>Dal Delete</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()

        DataProvider.MedicareRecalcHistoryProvider.Instance.Delete(Me.mMedicareReCalcLogId)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
