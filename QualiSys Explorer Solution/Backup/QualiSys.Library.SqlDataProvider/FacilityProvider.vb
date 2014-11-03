Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class FacilityProvider
    Inherits DataProvider.FacilityProvider

#Region " Populate Methods "
    Private Function BooleanToStatus(ByVal dbValue As Nullable(Of Boolean)) As Facility.ClassificationStatus
        If dbValue.HasValue Then
            If dbValue.Value Then
                Return Facility.ClassificationStatus.Yes
            Else
                Return Facility.ClassificationStatus.No
            End If
        Else
            Return Facility.ClassificationStatus.Unknown
        End If
    End Function

    Private Function StatusToBoolean(ByVal status As Facility.ClassificationStatus) As Object
        Select Case status
            Case Facility.ClassificationStatus.Yes
                Return True
            Case Facility.ClassificationStatus.No
                Return False
            Case Facility.ClassificationStatus.Unknown
                Return DBNull.Value
            Case Else
                Throw New ArgumentOutOfRangeException("status")
        End Select
    End Function

    Private Function PopulateFacility(ByVal rdr As SafeDataReader) As Facility
        Dim newObj As Facility = Facility.NewFacility
        Dim privateInterface As IFacility = newObj

        newObj.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("SUFacility_id")
        newObj.Name = rdr.GetString("strFacility_nm")
        newObj.City = rdr.GetString("City")
        newObj.State = rdr.GetString("State")
        newObj.Country = rdr.GetString("Country")
        'newObj.RegionId = rdr.GetInteger("Region_id")
        newObj.AdmitNumber = rdr.GetNullableInteger("AdmitNumber")
        newObj.BedSize = rdr.GetNullableInteger("BedSize")
        newObj.IsPediatric = BooleanToStatus(rdr.GetNullableBoolean("bitPeds"))
        newObj.IsTeaching = BooleanToStatus(rdr.GetNullableBoolean("bitTeaching"))
        newObj.IsTrauma = BooleanToStatus(rdr.GetNullableBoolean("bitTrauma"))
        newObj.IsReligious = BooleanToStatus(rdr.GetNullableBoolean("bitReligious"))
        newObj.IsGovernment = BooleanToStatus(rdr.GetNullableBoolean("bitGovernment"))
        newObj.IsRural = BooleanToStatus(rdr.GetNullableBoolean("bitRural"))
        newObj.IsForProfit = BooleanToStatus(rdr.GetNullableBoolean("bitForProfit"))
        newObj.IsRehab = BooleanToStatus(rdr.GetNullableBoolean("bitRehab"))
        newObj.IsCancerCenter = BooleanToStatus(rdr.GetNullableBoolean("bitCancerCenter"))
        newObj.IsPicker = BooleanToStatus(rdr.GetNullableBoolean("bitPicker"))
        newObj.IsFreeStanding = BooleanToStatus(rdr.GetNullableBoolean("bitFreeStanding"))
        newObj.AhaId = rdr.GetNullableInteger("AHA_id")
        If Not rdr.IsDBNull("MedicareNumber") Then
            newObj.MedicareNumber = MedicareNumber.Get(rdr.GetString("MedicareNumber"))
        End If
        newObj.IsHcahpsAssigned = rdr.GetBoolean("IsHcahpsAssigned")
        newObj.EndPopulate()

        Return newObj
    End Function

#End Region

    Public Overrides Function [Select](ByVal facilityId As Integer) As Facility
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectFacility, facilityId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateFacility(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectAll() As FacilityList
        Dim facList As New FacilityList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllFacilities)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                facList.Add(PopulateFacility(rdr))
            End While
        End Using
        Return facList
    End Function

    Public Overrides Function SelectByClientId(ByVal clientId As Integer) As FacilityList
        Dim facList As New FacilityList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectFacilityByClientId, clientId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                facList.Add(PopulateFacility(rdr))
            End While
        End Using
        Return facList
    End Function

    Public Overrides Function SelectByAhaId(ByVal ahaId As Integer) As System.Collections.ObjectModel.Collection(Of Facility)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectFacilityByAhaId, ahaId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Facility)(rdr, AddressOf PopulateFacility)
        End Using

    End Function

    Public Overrides Function SelectAllFacilityRegions() As System.Collections.ObjectModel.Collection(Of FacilityRegion)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllFacilityRegions)

        Dim regionList As New Collection(Of FacilityRegion)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                regionList.Add(GetNewFacilityRegion(rdr.GetInteger("Region_id"), rdr.GetString("strRegion_nm")))
            End While
        End Using
        Return regionList
    End Function

    Public Overrides Sub Delete(ByVal facilityId As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteFacility, facilityId)

        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub Insert(ByVal fac As Facility)
        Dim medNum As Object
        Dim region As Object

        If fac.MedicareNumber Is Nothing Then
            medNum = DBNull.Value
        Else
            medNum = fac.MedicareNumber.MedicareNumber
        End If

        If fac.RegionId = 0 Then
            region = DBNull.Value
        Else
            region = fac.RegionId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertFacility, fac.AhaId, fac.Name, fac.City, fac.State, fac.Country, _
                                        region, fac.AdmitNumber, fac.BedSize, StatusToBoolean(fac.IsPediatric), StatusToBoolean(fac.IsTeaching), _
                                        StatusToBoolean(fac.IsTrauma), StatusToBoolean(fac.IsReligious), StatusToBoolean(fac.IsGovernment), _
                                        StatusToBoolean(fac.IsRural), StatusToBoolean(fac.IsForProfit), StatusToBoolean(fac.IsRehab), _
                                        StatusToBoolean(fac.IsCancerCenter), StatusToBoolean(fac.IsPicker), StatusToBoolean(fac.IsFreeStanding), _
                                        medNum)


        Dim newId As Integer = ExecuteInteger(cmd)
        Dim privateInterface As IFacility = fac
        privateInterface.Id = newId
    End Sub

    Public Overrides Sub Update(ByVal fac As Facility)
        Dim medNum As Object
        Dim region As Object

        If fac.MedicareNumber Is Nothing Then
            medNum = DBNull.Value
        Else
            medNum = fac.MedicareNumber.MedicareNumber
        End If

        If fac.RegionId = 0 Then
            region = DBNull.Value
        Else
            region = fac.RegionId
        End If
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateFacility, fac.Id, fac.AhaId, fac.Name, fac.City, fac.State, fac.Country, _
                                        region, fac.AdmitNumber, fac.BedSize, StatusToBoolean(fac.IsPediatric), StatusToBoolean(fac.IsTeaching), _
                                        StatusToBoolean(fac.IsTrauma), StatusToBoolean(fac.IsReligious), StatusToBoolean(fac.IsGovernment), _
                                        StatusToBoolean(fac.IsRural), StatusToBoolean(fac.IsForProfit), StatusToBoolean(fac.IsRehab), _
                                        StatusToBoolean(fac.IsCancerCenter), StatusToBoolean(fac.IsPicker), StatusToBoolean(fac.IsFreeStanding), _
                                        medNum)

        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function AllowDelete(ByVal facilityId As Integer) As Boolean
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.AllowDeleteFacility, facilityId)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)
    End Function

    Public Overrides Function allowUnassignment(ByVal facilityId As Integer, ByVal clientId As Integer) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowUnassignmentFacility, facilityId, clientId)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)
    End Function

    Public Overrides Sub AssignFacilityToClient(ByVal facilityId As Integer, ByVal clientId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AssignFacilityToClient, facilityId, clientId)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UnassignFacilityFromClient(ByVal facilityId As Integer, ByVal clientId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UnassignFacilityFromClient, facilityId, clientId)
        ExecuteNonQuery(cmd)
    End Sub

End Class
