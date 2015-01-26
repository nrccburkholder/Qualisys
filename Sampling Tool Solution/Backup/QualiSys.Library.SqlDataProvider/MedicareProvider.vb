Imports Nrc.Framework.Data
Imports Nrc.QualiSys.Library

Public Class MedicareProvider
    Inherits DataProvider.MedicareProvider

#Region " Populate Methods "

    Private Function PopulateMedicareNumber(ByVal rdr As SafeDataReader) As MedicareNumber

        Dim newObj As MedicareNumber = MedicareNumber.NewMedicareNumber
        newObj.BeginPopulate()
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.Name = rdr.GetString("MedicareName")
        newObj.ProportionCalcTypeID = rdr.GetEnum(Of MedicareProportionCalcTypes)("MedicarePropCalcType_ID")
        newObj.EstAnnualVolume = rdr.GetInteger("EstAnnualVolume")
        newObj.EstResponseRate = rdr.GetDecimal("EstRespRate")
        newObj.EstIneligibleRate = rdr.GetDecimal("EstIneligibleRate")
        newObj.SwitchToCalcDate = rdr.GetDate("SwitchToCalcDate")
        newObj.AnnualReturnTarget = rdr.GetInteger("AnnualReturnTarget")
        If rdr.GetByte("SamplingLocked") = 0 Then
            newObj.SamplingLocked = False
        Else
            newObj.SamplingLocked = True
        End If
        newObj.ProportionChangeThreshold = rdr.GetDecimal("ProportionChangeThreshold")
        If rdr.GetByte("CensusForced") = 0 Then
            newObj.CensusForced = False
        Else
            newObj.CensusForced = True
        End If
        newObj.PENumber = rdr.GetString("PENumber")
        newObj.IsActive = rdr.GetBoolean("Active")
        newObj.EndPopulate()

        Return newObj

    End Function

#End Region

    Public Overrides Function [Select](ByVal medicareNumber As String) As MedicareNumber

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareNumber, medicareNumber)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMedicareNumber(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectAll() As MedicareNumberList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareNumbers)
        Dim MedList As New MedicareNumberList

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                MedList.Add(PopulateMedicareNumber(rdr))
            End While
        End Using

        Return MedList

    End Function

    Public Overrides Function SelectAllAsDictionary() As System.Collections.Generic.Dictionary(Of String, MedicareNumber)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMedicareNumbers)

        Dim list As New Dictionary(Of String, MedicareNumber)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim medicareNum As MedicareNumber
            While rdr.Read
                medicareNum = PopulateMedicareNumber(rdr)
                list.Add(medicareNum.MedicareNumber, medicareNum)
            End While
        End Using

        Return list

    End Function

    Public Overrides Function SelectBySurveyID(ByVal surveyID As Integer) As MedicareNumberList

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareNumbersBySurveyID, surveyID)
        Dim MedList As New MedicareNumberList

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                MedList.Add(PopulateMedicareNumber(rdr))
            End While
        End Using

        Return MedList

    End Function

    Public Overrides Sub Insert(ByVal medicareNum As MedicareNumber)

        Dim samplingLocked As Byte
        Dim censusForced As Byte

        If medicareNum.SamplingLocked Then
            samplingLocked = 1
        Else
            samplingLocked = 0
        End If

        If medicareNum.CensusForced Then
            censusForced = 1
        Else
            censusForced = 0
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareNumber, medicareNum.MedicareNumber, medicareNum.Name, _
                                                       medicareNum.ProportionCalcTypeID, medicareNum.EstAnnualVolume, _
                                                       medicareNum.EstResponseRate, medicareNum.EstIneligibleRate, medicareNum.SwitchToCalcDate, _
                                                       medicareNum.AnnualReturnTarget, samplingLocked, medicareNum.ProportionChangeThreshold, _
                                                       censusForced, medicareNum.PENumber, medicareNum.IsActive)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub Update(ByVal medicareNum As MedicareNumber)

        Dim samplingLocked As Byte
        Dim censusForced As Byte

        If medicareNum.SamplingLocked Then
            samplingLocked = 1
        Else
            samplingLocked = 0
        End If

        If medicareNum.CensusForced Then
            censusForced = 1
        Else
            censusForced = 0
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMedicareNumber, medicareNum.MedicareNumber, medicareNum.Name, _
                                                       medicareNum.ProportionCalcTypeID, medicareNum.EstAnnualVolume, _
                                                       medicareNum.EstResponseRate, medicareNum.EstIneligibleRate, medicareNum.SwitchToCalcDate, _
                                                       medicareNum.AnnualReturnTarget, samplingLocked, medicareNum.ProportionChangeThreshold, _
                                                       censusForced, medicareNum.PENumber, medicareNum.IsActive)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub Delete(ByVal medicareNumber As String)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMedicareNumber, medicareNumber)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Function AllowDelete(ByVal medicareNumber As String) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowDeleteMedicareNumber, medicareNumber)
        Return ExecuteBoolean(cmd)

    End Function

    Public Overrides Function GetHistoricAnnualVolume(ByVal medicareNumber As String, ByVal propSampleDate As Date) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.GetHistoricAnnualVolumne, medicareNumber, propSampleDate)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Function GetHistoricRespRate(ByVal medicareNumber As String, ByVal propSampleDate As Date) As Decimal

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.GetHistoricRespRate, medicareNumber, propSampleDate, 0)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return CDec(rdr.Item(0)) / 100
            Else
                Return 0
            End If
        End Using

    End Function

    Public Overrides Function HasHistoricValues(ByVal medicareNumber As String, ByVal propSampleDate As Date) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.HasHistoricValues, medicareNumber, propSampleDate)
        Return ExecuteBoolean(cmd)

    End Function

    Public Overrides Function SelectSamplingLockedBySurveyIDs(ByVal surveyIDs As String) As System.Data.DataTable

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareSamplingLockedBySurveyIDs, surveyIDs)
        Return ExecuteDataSet(cmd).Tables(0)

    End Function

    Public Overrides Function SelectLockedSampleUnitsByMedicareNumber(ByVal medicareNumber As String) As System.Data.DataTable

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectLockedSampleUnitsByMedicareNumber, medicareNumber)
        Return ExecuteDataSet(cmd).Tables(0)

    End Function

    Public Overrides Sub LogUnlockSample(ByVal medicareNumber As String, ByVal memberId As Integer, ByVal dateUnlocked As Date)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplingUnlockedLog, medicareNumber, memberId, dateUnlocked)
        ExecuteNonQuery(cmd)

    End Sub

End Class
