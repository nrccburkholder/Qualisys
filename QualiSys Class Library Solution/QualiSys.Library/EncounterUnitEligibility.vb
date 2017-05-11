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

    ''' <summary>
    ''' Fill Collection reads from the SafeDataReader and fills out a collection of those rows
    ''' </summary>
    ''' <param name="rdr">the SafeDataReader which reads in the rows</param>
    ''' <returns>the collection which matches the rows</returns>
    ''' <remarks></remarks>
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
            encounter.BitBadAddress = rdr.GetBoolean("BitBadAddress")
            encounter.BitBadPhone = rdr.GetBoolean("BitBadPhone")
            encounter.ReportDate = rdr.GetNullableDate("ReportDate")
            encounter.StipulatedOrder = rdr.GetInteger("NumRandom")
            encounter.CCN = rdr.GetString("CCN")
            encounter.Selector = 0

            collection.Add(encounter)
        End While

        Return collection
    End Function
    ''' <summary>
    ''' This method must comply with two requirements: systematic selection (every Xth encounter) and sampleunits grouped by encounter
    ''' </summary>
    ''' <param name="shiftedUniverse">The master list from QCL_SelectEncounterUnitEligibility</param>
    ''' <param name="locations">The list of locations in the originalCollection</param>
    ''' <param name="outgo_s">The outgo per location</param>
    ''' <param name="SystematicIncrement">The X in every Xth encounter</param>
    ''' <returns>The systematic ordered, encounter grouped EncounterUnitEligibilityCollection</returns>
    ''' <remarks></remarks>
    Public Shared Function SortForSystematic(ByVal shiftedUniverse As EncounterUnitEligibilityCollection, ByVal locations As List(Of Integer), ByVal outgo_s As Dictionary(Of Integer, Integer), ByVal SystematicIncrement As Integer) As EncounterUnitEligibilityCollection

        Dim sortedForSystematicCollection As EncounterUnitEligibilityCollection
        sortedForSystematicCollection = New EncounterUnitEligibilityCollection

        For Each location As Integer In locations
            If outgo_s(location) > 0 Then
                Dim locationEligibleCollection As EncounterUnitEligibilityCollection
                locationEligibleCollection = New EncounterUnitEligibilityCollection

                For Each enc As EncounterUnitEligibility In shiftedUniverse
                    If (enc.Sampleunit_id = location) And (enc.Removed_Rule = 0) Then
                        locationEligibleCollection.Add(enc)
                    End If
                Next

                Dim sortedLocationEligibleCollection As EncounterUnitEligibilityCollection
                sortedLocationEligibleCollection = New EncounterUnitEligibilityCollection

                'The following will order the new set in a systematic fashion.
                'For example, with locationCount 23 and increment of 5, the order should be: 1,6,11,16,21,3,8,13,18,23,5,10,15,20,2,7,12,17,22,4,9,14,19
                'For example, with locationCount 25 and increment of 5, the order should be: 1,6,11,16,21,2,7,12,17,22,3,8,13,18,23,4,9,14,19,24,5,10,15,20,25
                Dim locationCount As Integer = locationEligibleCollection.Count
                Dim SysSelector As Integer = 1
                Do While sortedLocationEligibleCollection.Count < locationCount
                    ' SystematicIncrement = 0 will census sample within the following block CJB 5/23/2016
                    Do While locationEligibleCollection(SysSelector - 1).Selector <> 0
                        SysSelector += 1
                        If SysSelector >= locationCount + 1 Then
                            SysSelector = 1
                        End If
                    Loop
                    locationEligibleCollection(SysSelector - 1).Selector = SysSelector
                    sortedLocationEligibleCollection.Add(locationEligibleCollection(SysSelector - 1))

                    SysSelector += SystematicIncrement
                    If SysSelector >= locationCount + 1 Then
                        SysSelector = SysSelector Mod locationCount
                        If SysSelector = 0 Then
                            SysSelector = 1
                        End If
                    End If
                Loop

                'Pick up the DQ's for this sample unit and include them for SPW purposes (DQ counts)
                For Each DQUnitEnc As EncounterUnitEligibility In shiftedUniverse
                    If (DQUnitEnc.Sampleunit_id = location) And (DQUnitEnc.Removed_Rule <> 0) Then
                        sortedLocationEligibleCollection.Add(DQUnitEnc)
                    End If
                Next

                Dim sortedLocationWithIndirectsCollection As EncounterUnitEligibilityCollection
                sortedLocationWithIndirectsCollection = New EncounterUnitEligibilityCollection

                'Pick up all the encounters as connected to this or any other sample units and include them for indirect sampling purposes (root unit, minor modules)
                For Each systematicEnc As EncounterUnitEligibility In sortedLocationEligibleCollection
                    For Each universeEnc As EncounterUnitEligibility In shiftedUniverse
                        If systematicEnc.Id = universeEnc.Id Then
                            sortedLocationWithIndirectsCollection.Add(universeEnc)
                        End If
                    Next
                Next

                sortedForSystematicCollection.AddCollection(sortedLocationWithIndirectsCollection)
            End If
        Next
        Return sortedForSystematicCollection

    End Function

#End Region

End Class

<Serializable()> _
Public Class EncounterUnitEligibilityCollection
    Inherits BusinessListBase(Of EncounterUnitEligibilityCollection, EncounterUnitEligibility)

    ''' <summary>
    ''' Tacks on the addCollection to the end of this collection
    ''' </summary>
    ''' <param name="addCollection">the collection to be added to the end</param>
    ''' <remarks></remarks>
    Public Sub AddCollection(addCollection As EncounterUnitEligibilityCollection)
        For Each enc As EncounterUnitEligibility In addCollection
            Me.Add(enc)
        Next
    End Sub
End Class