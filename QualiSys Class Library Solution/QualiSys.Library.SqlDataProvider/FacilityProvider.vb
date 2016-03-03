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
        newObj.RowType = rdr.GetString("RowType")
        newObj.GroupID = rdr.GetString("GroupID")
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

    Public Overrides Function [Select](ByVal facilityId As Integer, Optional ByVal isPracticeSite As Boolean = False) As Facility
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectFacility, facilityId, isPracticeSite)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateFacility(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectAll(Optional ByVal isPracticeSite As Boolean? = False) As FacilityList
        Dim facList As New FacilityList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllFacilities, isPracticeSite, DBNull.Value, DBNull.Value, DBNull.Value)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                facList.Add(PopulateFacility(rdr))
            End While
        End Using
        Return facList
    End Function

    Public Overrides Function SelectByClientId(ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean? = False) As FacilityList
        Dim facList As New FacilityList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectFacilityByClientId, clientId, isPracticeSite)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not (rdr Is Nothing) Then
                While rdr.Read
                    facList.Add(PopulateFacility(rdr))
                End While
            End If
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

    Public Overrides Function allowUnassignment(ByVal facilityId As Integer, ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean = False) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowUnassignmentFacility, facilityId, clientId, isPracticeSite)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)
    End Function

    Public Overrides Sub AssignFacilityToClient(ByVal facilityId As Integer, ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean = False)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AssignFacilityToClient, facilityId, clientId, isPracticeSite)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UnassignFacilityFromClient(ByVal facilityId As Integer, ByVal clientId As Integer, Optional ByVal isPracticeSite As Boolean = False)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UnassignFacilityFromClient, facilityId, clientId, isPracticeSite)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Function SelectAllSiteGroups() As DataSet
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllSiteGroupsAndPracticeSites)

        Dim ds As New DataSet()
        ds = ExecuteDataSet(cmd)

        Dim keyColumn As DataColumn = ds.Tables(0).Columns("SiteGroup_Id")
        Dim foreignKeyColumn1 As DataColumn = ds.Tables(1).Columns("SiteGroup_Id")

        ds.Relations.Add("FK_Master_Detail", keyColumn, foreignKeyColumn1)

        Return ds
    End Function

    Private Function PopulateSiteGroup(ByVal rdr As SafeDataReader) As SiteGroup
        Dim newObj As SiteGroup = SiteGroup.NewSiteGroup
        Dim privateInterface As ISiteGroup = newObj

        newObj.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("SiteGroup_ID")
        newObj.SiteGroup_ID = rdr.GetInteger("SiteGroup_ID")
        newObj.AssignedID = rdr.GetString("AssignedID")
        newObj.GroupName = rdr.GetString("GroupName")
        newObj.Addr1 = rdr.GetString("Addr1")
        newObj.Addr2 = rdr.GetString("Addr2")
        newObj.City = rdr.GetString("City")
        newObj.ST = rdr.GetString("ST")
        newObj.Zip5 = rdr.GetString("Zip5")
        newObj.Phone = rdr.GetString("Phone")
        newObj.GroupOwnership = rdr.GetString("GroupOwnership")
        newObj.GroupContactName = rdr.GetString("GroupContactName")
        newObj.GroupContactPhone = rdr.GetString("GroupContactPhone")
        newObj.GroupContactEmail = rdr.GetString("GroupContactEmail")
        newObj.MasterGroupID = rdr.GetInteger("MasterGroupID")
        newObj.MasterGroupName = rdr.GetString("MasterGroupName")
        newObj.IsActive = rdr.GetBoolean("bitActive")

        newObj.PracticeSites = SelectPracticeSiteBySiteGroupId(newObj.SiteGroup_ID)

        newObj.EndPopulate()

        Return newObj

    End Function

    Private Function SelectPracticeSiteBySiteGroupId(ByVal siteGroupId As Integer) As PracticeSiteList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectPracticeSitesBySiteGroupId, siteGroupId)

        Dim practiceSiteList As New PracticeSiteList
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                practiceSiteList.Add(PopulatePracticeSite(rdr))
            End While
        End Using
        Return practiceSiteList
    End Function

    Private Function PopulatePracticeSite(ByVal rdr As SafeDataReader) As PracticeSite


        Dim newObj As PracticeSite = PracticeSite.NewPracticeSite
        Dim privateInterface As IPracticeSite = newObj

        privateInterface.Id = rdr.GetInteger("PracticeSite_ID")
        newObj.PracticeSite_ID = rdr.GetInteger("PracticeSite_ID")
        newObj.AssignedID = rdr.GetString("AssignedID")
        newObj.SiteGroup_ID = rdr.GetInteger("SiteGroup_ID")
        newObj.PracticeName = rdr.GetString("PracticeName")
        newObj.Addr1 = rdr.GetString("Addr1")
        newObj.Addr2 = rdr.GetString("Addr2")
        newObj.City = rdr.GetString("City")
        newObj.ST = rdr.GetString("ST")
        newObj.Zip5 = rdr.GetString("Zip5")
        newObj.Phone = rdr.GetString("Phone")
        newObj.PracticeOwnership = rdr.GetString("PracticeOwnership")
        newObj.PatVisitsWeek = rdr.GetInteger("PatVisitsWeek")
        newObj.ProvWorkWeek = rdr.GetInteger("ProvWorkWeek")
        newObj.PracticeContactName = rdr.GetString("PracticeContactName")
        newObj.PracticeContactPhone = rdr.GetString("PracticeContactPhone")
        newObj.PracticeContactEmail = rdr.GetString("PracticeContactEmail")
        newObj.SampleUnit_id = rdr.GetInteger("SampleUnit_id")
        newObj.bitActive = rdr.GetBoolean("bitActive")

        Return newObj

    End Function

    Public Overrides Sub UpdateSiteGroup(ByVal siteGroup As SiteGroup)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSiteGroup, siteGroup.SiteGroup_ID,
                                                       siteGroup.IsActive, siteGroup.AssignedID,
                                                       siteGroup.GroupName, siteGroup.Addr1, siteGroup.Addr2, siteGroup.City,
                                                       siteGroup.ST, siteGroup.Zip5, siteGroup.Phone, siteGroup.GroupOwnership,
                                                       siteGroup.GroupContactName, siteGroup.GroupContactPhone, siteGroup.GroupContactEmail,
                                                       siteGroup.MasterGroupID, siteGroup.MasterGroupName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdatePracticeSite(ByVal practiceSite As PracticeSite)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdatePracticeSite, practiceSite.PracticeSite_ID, practiceSite.bitActive, practiceSite.AssignedID,
                                                       practiceSite.SiteGroup_ID, practiceSite.PracticeName, practiceSite.Addr1,
                                                       practiceSite.Addr2, practiceSite.City, practiceSite.ST, practiceSite.Zip5,
                                                       practiceSite.Phone, practiceSite.PracticeOwnership, practiceSite.PatVisitsWeek,
                                                       practiceSite.ProvWorkWeek, practiceSite.PracticeContactName, practiceSite.PracticeContactPhone,
                                                       practiceSite.PracticeContactEmail, practiceSite.SampleUnit_id)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub InsertSiteGroup(ByVal siteGroup As SiteGroup)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSiteGroup, siteGroup.AssignedID,
                                                       siteGroup.GroupName, siteGroup.Addr1, siteGroup.Addr2, siteGroup.City,
                                                       siteGroup.ST, siteGroup.Zip5, siteGroup.Phone, siteGroup.GroupOwnership,
                                                       siteGroup.GroupContactName, siteGroup.GroupContactPhone, siteGroup.GroupContactEmail,
                                                       siteGroup.MasterGroupID, siteGroup.MasterGroupName, siteGroup.IsActive)
        Dim newId As Integer = ExecuteInteger(cmd)
        Dim privateInterface As ISiteGroup = siteGroup
        privateInterface.Id = newId
    End Sub

    Public Overrides Sub InsertPracticeSite(ByVal practiceSite As PracticeSite)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertPracticeSite, practiceSite.AssignedID,
                                                       practiceSite.SiteGroup_ID, practiceSite.PracticeName, practiceSite.Addr1,
                                                       practiceSite.Addr2, practiceSite.City, practiceSite.ST, practiceSite.Zip5,
                                                       practiceSite.Phone, practiceSite.PracticeOwnership, practiceSite.PatVisitsWeek,
                                                       practiceSite.ProvWorkWeek, practiceSite.PracticeContactName, practiceSite.PracticeContactPhone,
                                                       practiceSite.PracticeContactEmail, practiceSite.SampleUnit_id, practiceSite.bitActive)
        Dim newId As Integer = ExecuteInteger(cmd)
        Dim privateInterface As IPracticeSite = practiceSite
        practiceSite.Id = newId
    End Sub

End Class
