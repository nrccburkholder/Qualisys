Imports Nrc.Framework.BusinessLogic

''' <summary>Allows for DAL to assign Key field of object.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Interface IMedicareGlobalCalcDate
    Property MedicareGlobalCalcDateId() As Integer
End Interface

''' <summary>Represents the MedicareGlobalRecalcDates table which holds the collection of dates used to determine when to recalculate for proportional sampling. </summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class MedicareGlobalCalcDate
    Inherits BusinessBase(Of MedicareGlobalCalcDate)
    Implements IMedicareGlobalCalcDate

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mMedicareGlobalCalcDateId As Integer
    Private mMedicareGlobalRecalDefaultId As Integer
    Private mRecalcMonth As Integer
#End Region

#Region " Public Properties "
    ''' <summary>Key Field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareGlobalCalcDateId() As Integer Implements IMedicareGlobalCalcDate.MedicareGlobalCalcDateId
        Get
            Return mMedicareGlobalCalcDateId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mMedicareGlobalCalcDateId Then
                mMedicareGlobalCalcDateId = value
                PropertyHasChanged("MedicareGlobalCalcDateId")
            End If
        End Set
    End Property
    ''' <summary>FK field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MedicareGlobalRecalDefaultId() As Integer
        Get
            Return mMedicareGlobalRecalDefaultId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMedicareGlobalRecalDefaultId Then
                mMedicareGlobalRecalDefaultId = value
                PropertyHasChanged("MedicareGlobalRecalDefaultId")
            End If
        End Set
    End Property
    ''' <summary>Date used to determine when to recalculate proportional sampling.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ReCalcMonth() As Integer
        Get
            Return mRecalcMonth
        End Get
        Set(ByVal value As Integer)
            If Not value = mRecalcMonth Then
                mRecalcMonth = value
                PropertyHasChanged("ReCalcMonth")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
    Private Sub New(ByVal medicareGlobalCalcDefaultID As Integer, ByVal reCalcMonth As Integer)
        Me.mMedicareGlobalRecalDefaultId = medicareGlobalCalcDefaultID
        Me.mRecalcMonth = reCalcMonth
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Create a new, empty object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewMedicareGlobalCalcDate() As MedicareGlobalCalcDate
        Return New MedicareGlobalCalcDate
    End Function
    ''' <summary>Create a new object with preset values.</summary>
    ''' <param name="medicareGlobalCalcDefaultID"></param>
    ''' <param name="month"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewMedicareGlobalCalcDate(ByVal medicareGlobalCalcDefaultID As Integer, ByVal month As Integer) As MedicareGlobalCalcDate
        Return New MedicareGlobalCalcDate(medicareGlobalCalcDefaultID, month)
    End Function

    ''' <summary>Retrieve the object by its PK</summary>
    ''' <param name="MedicareGlobalCalcDateId"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal MedicareGlobalCalcDateId As Integer) As MedicareGlobalCalcDate
        Return DataProvider.MedicareGlobalCalcDateProvider.Instance.Get(MedicareGlobalCalcDateId)
    End Function

    ''' <summary>Retrieve all object from the data store.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As MedicareGlobalCalcDateCollection
        Return DataProvider.MedicareGlobalCalcDateProvider.Instance.GetAll()
    End Function

    ''' <summary>Retrieve collection by their FK reference.</summary>
    ''' <param name="medicareGlobalCalcDefaultID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetByMedicareGlobalCalcDefaultID(ByVal medicareGlobalCalcDefaultID As Integer) As MedicareGlobalCalcDateCollection
        Return DataProvider.MedicareGlobalCalcDateProvider.Instance.GetByGlobalDefaultID(medicareGlobalCalcDefaultID)
    End Function
#End Region
    ''' <summary>Remove all calc dates by FK reference</summary>
    ''' <param name="medicareGlobalCalcDefaultID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Sub DeleteCalcDatesByGlobalDefaultID(ByVal medicareGlobalCalcDefaultID As Integer)
        DataProvider.MedicareGlobalCalcDateProvider.Instance.DeleteCalcDatesByGlobalDefaultID(medicareGlobalCalcDefaultID)
    End Sub
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mMedicareGlobalCalcDateId
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

    ''' <summary>Call DAL Insert.  Notice we have to mark old here when save called from parent object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        Me.mMedicareGlobalCalcDateId = DataProvider.MedicareGlobalCalcDateProvider.Instance.Insert(Me)
        Me.MarkOld()
    End Sub

    ''' <summary>Dal Update call.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        DataProvider.MedicareGlobalCalcDateProvider.Instance.Update(Me)
    End Sub

    ''' <summary>Dal Delete call.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        DataProvider.MedicareGlobalCalcDateProvider.Instance.Delete(mMedicareGlobalCalcDateId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class