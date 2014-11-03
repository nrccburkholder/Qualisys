Imports Nrc.Framework.Data

Public Class USPS_ACS_Provider
    Inherits Nrc.QualiSys.Library.DataProvider.USPS_ACS_Provider


    Public Overrides Function SelectPartialMatchesByStatus(ByVal status As Integer) As DataSet

        Dim cmd As DbCommand = Db.GetStoredProcCommand("USPS_ACS_SelectPartialMatchesDataSetByStatus", status)

        Try
            Return Db.ExecuteDataSet(cmd)
        Catch ex As Exception
            Throw (New SqlCommandException(cmd, ex))
        End Try

    End Function

    Public Overrides Function SelectByStatus(ByVal status As Integer) As List(Of USPS_PartialMatch)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("USPS_ACS_SelectPartialMatchesByStatus", status)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))

            Return PopulateList(Of List(Of USPS_PartialMatch), USPS_PartialMatch)(rdr, AddressOf PopulateObject)
        End Using

    End Function

    Friend Shared Function PopulateObject(ByVal rdr As SafeDataReader) As USPS_PartialMatch

        Dim newObject As USPS_PartialMatch = New USPS_PartialMatch

        newObject.Id = rdr.GetInteger("USPS_ACS_ExtractFile_PartialMatch_id")
        newObject.ExtractFileID = rdr.GetInteger("USPS_ACS_ExtractFile_ID")
        newObject.Study_id = rdr.GetInteger("Study_ID")
        newObject.Lithocode = rdr.GetString("strLithocode")
        newObject.Pop_id = rdr.GetInteger("Pop_id")
        newObject.FirstName = rdr.GetString("popFname")
        newObject.LastName = rdr.GetString("popLname")
        newObject.Addr = rdr.GetString("popAddr")
        newObject.Addr2 = rdr.GetString("popAddr2")
        newObject.City = rdr.GetString("popCity")
        newObject.State = rdr.GetString("popSt")
        newObject.Zip = rdr.GetString("popZip5")
        'newObject.OldAddress = New USPS_Address(rdr.GetInteger("USPS_ACS_ExtractFile_PartialMatch_id"),
        '                                        rdr.GetString("FName"),
        '                                        rdr.GetString("LName"),
        '                                        rdr.GetString("PrimaryNumberOld"),
        '                                        rdr.GetString("PreDirectionalOld"),
        '                                        rdr.GetString("StreetNameOld"),
        '                                        rdr.GetString("StreetSuffixOld"),
        '                                        rdr.GetString("PostDirectionalOld"),
        '                                        rdr.GetString("UnitDesignatorOld"),
        '                                        rdr.GetString("SecondaryNumberOld"),
        '                                        rdr.GetString("CityOld"),
        '                                        rdr.GetString("StateOld"),
        '                                        rdr.GetString("Zip5Old"),
        '                                        String.Empty)
        'newObject.NewAddress = New USPS_Address(rdr.GetInteger("USPS_ACS_ExtractFile_PartialMatch_id"),
        '                                        rdr.GetString("FName"),
        '                                        rdr.GetString("LName"),
        '                                        rdr.GetString("PrimaryNumberNew"),
        '                                        rdr.GetString("PreDirectionalNew"),
        '                                        rdr.GetString("StreetNameNew"),
        '                                        rdr.GetString("StreetSuffixNew"),
        '                                        rdr.GetString("PostDirectionalNew"),
        '                                        rdr.GetString("UnitDesignatorNew"),
        '                                        rdr.GetString("SecondaryNumberNew"),
        '                                        rdr.GetString("CityNew"),
        '                                        rdr.GetString("StateNew"),
        '                                        rdr.GetString("Zip5New"),
        '                                        rdr.GetString("Plus4ZipNew"))




        Return newObject
    End Function

    Friend Shared Function PopulateList(Of C As {List(Of T), New}, T)(ByVal rdr As SafeDataReader, ByVal populateMethod As FillMethod(Of T)) As C
        Dim list As New C

        While rdr.Read
            list.Add(populateMethod(rdr))
        End While

        Return list

    End Function

End Class
