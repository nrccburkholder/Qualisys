Imports Nrc.Framework.BusinessLogic

''' <summary>Allows DAL to assign key field to object.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Interface IMedicareGlobalCalculationDefault
    Property MedicareGlobalCalculationDefaultId() As Integer
End Interface

''' <summary>Represents MedicareGlobalCalcDefaults which are the default enteries from which Medicare values will be set.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class MedicareGlobalCalculationDefault
    Inherits BusinessBase(Of MedicareGlobalCalculationDefault)
    Implements IMedicareGlobalCalculationDefault

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicareGlobalCalculationDefaultId As Integer
    Private mRespRate As Decimal
    Private mIneligibleRate As Decimal
    Private mProportionChangeThreshold As Decimal
    Private mAnnualReturnTarget As Integer
    Private mForceCensusSamplePercentage As Decimal
    Private mMedicareCalcDateCollection As MedicareGlobalCalcDateCollection = Nothing
#End Region

#Region " Public Properties "
    ''' <summary>PK</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareGlobalCalculationDefaultId() As Integer Implements IMedicareGlobalCalculationDefault.MedicareGlobalCalculationDefaultId
        Get
            Return mMedicareGlobalCalculationDefaultId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mMedicareGlobalCalculationDefaultId Then
                mMedicareGlobalCalculationDefaultId = value
                PropertyHasChanged("MedicareGlobalCalculationDefaultId")
            End If
        End Set
    End Property

    ''' <summary>Percentage which we think we will get returns from our surveys.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property RespRate() As Decimal
        Get
            Return mRespRate
        End Get
        Set(ByVal value As Decimal)
            Me.mRespRate = value
            PropertyHasChanged("RespRate")
        End Set
    End Property
    ''' <summary>Percentage of returns that we think will be invalid.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property IneligibleRate() As Decimal
        Get
            Return mIneligibleRate
        End Get
        Set(ByVal value As Decimal)
            If Not value = mIneligibleRate Then
                mIneligibleRate = value
                PropertyHasChanged("IneligibleRate")
            End If
        End Set
    End Property
    ''' <summary>The allowed percentage change between recalculation that will lock sampling.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ProportionChangeThreshold() As Decimal
        Get
            Return mProportionChangeThreshold
        End Get
        Set(ByVal value As Decimal)
            If Not value = mProportionChangeThreshold Then
                mProportionChangeThreshold = value
                PropertyHasChanged("ProportionChangeThreshold")
            End If
        End Set
    End Property
    ''' <summary>Estimate of how many returns are needed.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property AnnualReturnTarget() As Integer
        Get
            Return mAnnualReturnTarget
        End Get
        Set(ByVal value As Integer)
            If Not value = mAnnualReturnTarget Then
                mAnnualReturnTarget = value
                PropertyHasChanged("AnnualReturnTarget")
            End If
        End Set
    End Property
    ''' <summary>If we are not getting enough returns per sample period to effective you a proportion below 100 percent, this will force the proportion to 100.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ForceCensusSamplePercentage() As Decimal
        Get
            Return mForceCensusSamplePercentage
        End Get
        Set(ByVal value As Decimal)
            If Not value = mForceCensusSamplePercentage Then
                mForceCensusSamplePercentage = value
                PropertyHasChanged("ForceCensusSamplePercentage")
            End If
        End Set
    End Property
    ''' <summary>A collection of dates that will help determine when to recalculate.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property MedicareCalcDateCollection() As MedicareGlobalCalcDateCollection
        Get
            If Not Me.mMedicareCalcDateCollection Is Nothing Then
                Return Me.mMedicareCalcDateCollection
            Else
                If Me.IsNew() Then
                    Me.mMedicareCalcDateCollection = New MedicareGlobalCalcDateCollection
                Else
                    Me.mMedicareCalcDateCollection = MedicareGlobalCalcDate.GetByMedicareGlobalCalcDefaultID(Me.mMedicareGlobalCalculationDefaultId)
                End If
                Return Me.mMedicareCalcDateCollection
            End If
        End Get
    End Property

    ''' <summary>Formatted resp rate so we can format and bind to UI.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property RespRateDisplay() As Decimal
        Get
            Return (Math.Round(100 * Me.mRespRate, 2))
        End Get
        Set(ByVal value As Decimal)
            Dim retVal As Decimal = 0
            If value <> 0 Then
                retVal = CDec(0.01 * value)            
            End If
            If retVal <> Me.mRespRate Then
                Me.mRespRate = retVal
                PropertyHasChanged("RespRateDisplay")
            End If
        End Set
    End Property
    ''' <summary>Formatted ineligible rate so we can format and bind to UI.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property IneligibleRateDisplay() As Decimal
        Get
            Return (Math.Round(100 * Me.mIneligibleRate, 2))
        End Get
        Set(ByVal value As Decimal)
            Dim retVal As Decimal = 0
            If value <> 0 Then
                retVal = CDec(0.01 * value)
            End If
            If retVal <> Me.mIneligibleRate Then
                Me.mIneligibleRate = retVal
                PropertyHasChanged("IneligibleRateDisplay")
            End If
        End Set
    End Property
    ''' <summary>Formatted propchangethreshold so we can format and bind to UI.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ProportionChangeThresholdDisplay() As Decimal
        Get
            Return (Math.Round(100 * Me.mProportionChangeThreshold, 2))
        End Get
        Set(ByVal value As Decimal)
            Dim retVal As Decimal = 0
            If value <> 0 Then
                retVal = CDec(0.01 * value)
            End If
            If retVal <> Me.mProportionChangeThreshold Then
                Me.mProportionChangeThreshold = retVal
                PropertyHasChanged("ProportionChangeThresholdDisplay")
            End If
        End Set
    End Property
    ''' <summary>Formatted force census percentage so we can format and bind to ui.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ForceCensusSamplePercentageDisplay() As Decimal
        Get
            Return (Math.Round(100 * Me.mForceCensusSamplePercentage, 2))
        End Get
        Set(ByVal value As Decimal)
            Dim retVal As Decimal = 0
            If value <> 0 Then
                retVal = CDec(0.01 * value)
            End If
            If retVal <> Me.mForceCensusSamplePercentage Then
                Me.mForceCensusSamplePercentage = retVal
                PropertyHasChanged("ForceCensusSamplePercentageDisplay")
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
    ''' <summary>Factory to create a new object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewMedicareGlobalCalculationDefault() As MedicareGlobalCalculationDefault
        Return New MedicareGlobalCalculationDefault
    End Function

    ''' <summary>Factory to get by PK.</summary>
    ''' <param name="MedicareGlobalCalculationDefaultId"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal MedicareGlobalCalculationDefaultId As Integer) As MedicareGlobalCalculationDefault
        Return DataProvider.MedicareGlobalCalculationDefaultProvider.Instance.Get(MedicareGlobalCalculationDefaultId)
    End Function

    ''' <summary>Factory to get all from DAL into a collection.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As MedicareGlobalCalculationDefaultCollection
        Return DataProvider.MedicareGlobalCalculationDefaultProvider.Instance.GetAll()
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mMedicareGlobalCalculationDefaultId
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>This method allows validation of this object as well as its child objects-collections.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateAll() As Boolean
        If Not Me.IsValid Then
            Return False
        End If
        For Each item As MedicareGlobalCalcDate In Me.MedicareCalcDateCollection
            If Not item.IsValid Then
                Return False
            End If
        Next
        Return True
    End Function
    ''' <summary>Adds pointers to methods used to validation objects properties.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        Me.ValidationRules.AddRule(AddressOf PercentageRule, "RespRateDisplay")
        Me.ValidationRules.AddRule(AddressOf PercentageRule, "IneligibleRateDisplay")
        Me.ValidationRules.AddRule(AddressOf PercentageRule, "ProportionChangeThresholdDisplay")
        Me.ValidationRules.AddRule(AddressOf PercentageRule, "ForceCensusSamplePercentageDisplay")
        Me.ValidationRules.AddRule(AddressOf ValidateAnnualTarget, "AnnualReturnTarget")
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>DAL Insert</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        MedicareGlobalCalculationDefaultId = DataProvider.MedicareGlobalCalculationDefaultProvider.Instance.Insert(Me)
    End Sub

    ''' <summary>Dal Update</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        DataProvider.MedicareGlobalCalculationDefaultProvider.Instance.Update(Me)
    End Sub

    ''' <summary>DAL Delete</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        DataProvider.MedicareGlobalCalculationDefaultProvider.Instance.Delete(mMedicareGlobalCalculationDefaultId)
    End Sub

    ''' <summary>Save the object, then sets up its child collection to be saved.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Save()
        MyBase.Save()
        MedicareGlobalCalcDate.DeleteCalcDatesByGlobalDefaultID(Me.mMedicareGlobalCalculationDefaultId)
        For Each item As MedicareGlobalCalcDate In Me.mMedicareCalcDateCollection
            'when this object is new, you must reassign the FK after the save.
            item.MedicareGlobalRecalDefaultId = Me.mMedicareGlobalCalculationDefaultId
            item.Save()
        Next
    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>Checks that percentage is between 0 and 100</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PercentageRule(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        Dim val As Decimal = 0
        Select Case e.PropertyName.ToLower
            Case "respratedisplay"
                val = Me.mRespRate
            Case "ineligibleratedisplay"
                val = Me.mIneligibleRate
            Case "proportionchangethresholddisplay"
                val = Me.mProportionChangeThreshold
            Case "forcecensussamplepercentagedisplay"
                val = Me.mForceCensusSamplePercentage
        End Select
        If val > 1 OrElse val < 0 Then
            e.Description = "Value must be a percentage between 0 and 100 percent."
            Return False
        Else
            Return True
        End If
    End Function
    ''' <summary>Checks that return target is between 0 and 2 billion.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateAnnualTarget(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.mAnnualReturnTarget < 0 OrElse Me.AnnualReturnTarget > 2000000000 Then
            e.Description = "Value must be between 0 and 2000000000"
            Return False
        Else
            Return True
        End If
    End Function    
#End Region

End Class