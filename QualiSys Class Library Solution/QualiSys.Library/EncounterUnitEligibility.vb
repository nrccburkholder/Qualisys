Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Data

Public Interface IEncounterUnitEligibility
    Property Id() As Integer
End Interface
Public Class EncounterUnitEligibility
    Inherits BusinessBase(Of EncounterUnitEligibility)
    Implements IEncounterUnitEligibility

    ''' <summary>
    ''' Class for management of results from QCL_SelectEncounterUnitEligibility
    ''' 
    ''' 		  SELECT   suu.SampleUnit_id, suu.Pop_id, suu.Enc_id, suu.DQ_Bus_Rule, suu.Removed_Rule, suu.EncDate, suu.HouseHold_id,
    ''' 		  suu.bitBadAddress, suu.bitBadPhone, suu.reportDate, rp.numRandom, suf.MedicareNumber as CCN
    ''' 		  		  FROM     #SampleUnit_Universe suu 
    ''' 		  INNER JOIN #randomPops rp ON suu.Pop_id = rp.Pop_id
    ''' 		  INNER JOIN SampleUnit su on suu.SampleUnit_id=su.SampleUnit_id
    ''' 		  LEFT JOIN SUFacility suf on su.SUFacility_id=suf.SUFacility_id
    ''' 		  ORDER BY rp.numrandom, Enc_id
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>

#Region " Private Members "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mEnc_Id As Integer
    Private mPop_id As Integer
    Private mSampleunit_id As Integer
    Private mDQ_Bus_Rule As Integer
    Private mRemoved_Rule As Integer
    Private mEncDate As Nullable(Of Date)
    Private mHouseHold_id As Nullable(Of Integer)
    Private mBitBadAddress As Boolean
    Private mBitBadPhone As Boolean
    Private mReportDate As Nullable(Of Date)
    Private mStipulatedOrder As Integer
    Private mCCN As String
    Private mSelector As Integer
#End Region

#Region " Overrides "
    Protected Overrides Function GetIdValue() As Object
        If IsNew Then
            Return mInstanceGuid
        Else
            Return Id
        End If
    End Function
#End Region

#Region " Public Properties "
    <Logable()> _
    Public Property Id() As Integer Implements IEncounterUnitEligibility.Id
        Get
            Return mEnc_Id
        End Get
        Private Set(ByVal value As Integer)
            If mEnc_Id <> value Then
                mEnc_Id = value
                PropertyHasChanged()
            End If
        End Set
    End Property

    Public Property Pop_id() As Integer
        Get
            Return mPop_id
        End Get
        Friend Set(ByVal value As Integer)
            mPop_id = value
        End Set
    End Property

    Public Property Sampleunit_id() As Integer
        Get
            Return mSampleunit_id
        End Get
        Friend Set(ByVal value As Integer)
            mSampleunit_id = value
        End Set
    End Property

    Public Property DQ_Bus_Rule() As Integer
        Get
            Return mDQ_Bus_Rule
        End Get
        Friend Set(ByVal value As Integer)
            mDQ_Bus_Rule = value
        End Set
    End Property

    Public Property Removed_Rule() As Integer
        Get
            Return mRemoved_Rule
        End Get
        Friend Set(ByVal value As Integer)
            mRemoved_Rule = value
        End Set
    End Property

    Public Property EncDate() As Nullable(Of Date)
        Get
            Return mEncDate
        End Get
        Friend Set(ByVal value As Nullable(Of Date))
            mEncDate = value
        End Set
    End Property

    Public Property HouseHold_id() As Nullable(Of Integer)
        Get
            Return mHouseHold_id
        End Get
        Friend Set(ByVal value As Nullable(Of Integer))
            mHouseHold_id = value
        End Set
    End Property

    Public Property BitBadAddress() As Boolean
        Get
            Return mBitBadAddress
        End Get
        Friend Set(ByVal value As Boolean)
            mBitBadAddress = value
        End Set
    End Property

    Public Property BitBadPhone() As Boolean
        Get
            Return mBitBadPhone
        End Get
        Friend Set(ByVal value As Boolean)
            mBitBadPhone = value
        End Set
    End Property

    Public Property ReportDate() As Nullable(Of Date)
        Get
            Return mReportDate
        End Get
        Friend Set(ByVal value As Nullable(Of Date))
            mReportDate = value
        End Set
    End Property

    Public Property StipulatedOrder() As Integer
        Get
            Return mStipulatedOrder
        End Get
        Friend Set(ByVal value As Integer)
            mStipulatedOrder = value
        End Set
    End Property

    Public Property CCN() As String
        Get
            Return mCCN
        End Get
        Friend Set(ByVal value As String)
            mCCN = value
        End Set
    End Property

    Public Property Selector() As Integer
        Get
            Return mSelector
        End Get
        Friend Set(ByVal value As Integer)
            mSelector = value
        End Set
    End Property


#End Region

#Region " Public Methods "

    Public Shared Function FillCollection(rdr As SafeDataReader) As EncounterUnitEligibilityCollection
        Dim collection As New EncounterUnitEligibilityCollection
        Dim encounter As EncounterUnitEligibility

        While rdr.Read
            encounter = New EncounterUnitEligibility

            encounter.Pop_id = rdr.GetInteger("pop_id")
            encounter.Id = rdr.GetInteger("enc_id")
            encounter.Sampleunit_id = rdr.GetInteger("Sampleunit_id")
            encounter.DQ_Bus_Rule = rdr.GetInteger("DQ_Bus_Rule")
            encounter.Removed_Rule = rdr.GetInteger("Removed_Rule")
            encounter.EncDate = rdr.GetNullableDate("EncDate")
            encounter.HouseHold_id = rdr.GetNullableInteger("HouseHold_id")
            encounter.BitBadAddress = rdr.GetBoolean("BitBadAddress")
            encounter.BitBadPhone = rdr.GetBoolean("BitBadPhone")
            encounter.ReportDate = rdr.GetNullableDate("ReportDate")
            encounter.StipulatedOrder = rdr.GetInteger("NumRandom")
            encounter.CCN = rdr.GetString("CCN")

            collection.Add(encounter)
        End While

        Return collection
    End Function

    Public Shared Function PareCollection(originalCollection As EncounterUnitEligibilityCollection, filter As EncounterUnitEligibility, Optional ByVal SystematicIncrement As Integer = 0) As EncounterUnitEligibilityCollection
        Dim newCollection As EncounterUnitEligibilityCollection
        newCollection = New EncounterUnitEligibilityCollection

        For Each enc As EncounterUnitEligibility In originalCollection
            If (enc.Sampleunit_id = filter.Sampleunit_id) Then
                newCollection.Add(enc)
            End If
        Next

        If SystematicIncrement = 0 Then
            Return newCollection
        Else
            Dim systematicCollection As EncounterUnitEligibilityCollection
            systematicCollection = New EncounterUnitEligibilityCollection

            Dim newCount As Integer = newCollection.Count
            Dim SysSelector As Integer = 1
            Do While systematicCollection.Count < newCount
                Do While newCollection(SysSelector - 1).Selector <> 0
                    SysSelector += 1
                    If SysSelector = newCount + 1 Then
                        SysSelector = 1
                    End If
                Loop
                newCollection(SysSelector - 1).Selector = SysSelector
                systematicCollection.Add(newCollection(SysSelector - 1))

                SysSelector += SystematicIncrement
                If SysSelector = newCount + 1 Then
                    SysSelector = 1
                End If
            Loop
            Return systematicCollection
        End If
    End Function

#End Region

End Class

<Serializable()> _
Public Class EncounterUnitEligibilityCollection
    Inherits BusinessListBase(Of EncounterUnitEligibilityCollection, EncounterUnitEligibility)
End Class