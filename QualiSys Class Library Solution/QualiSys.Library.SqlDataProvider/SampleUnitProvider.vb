Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class SampleUnitProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SampleUnitProvider

    ''' <summary>
    ''' Returns an instance of a sampleUnit from a datareader.
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks>This overload does not provide a parentUnit or childUnits collection</remarks>
    Private Function PopulateSampleUnit(ByVal rdr As SafeDataReader, ByVal survey As Survey) As SampleUnit

        Return PopulateSampleUnit(rdr, survey, Nothing, Nothing)

    End Function

    ''' <summary>
    ''' Returns an instance of a sampleUnit from a datareader.
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <param name="survey"></param>
    ''' <param name="parentUnit"></param>
    ''' <param name="childUnits"></param>
    ''' <returns></returns>
    ''' <remarks>This overload requires a parentUnit and childUnits collection</remarks>
    Private Function PopulateSampleUnit(ByVal rdr As SafeDataReader, ByVal survey As Survey, ByVal parentUnit As SampleUnit, ByVal childUnits As Collection(Of SampleUnit)) As SampleUnit

        Dim newObj As New SampleUnit(survey, parentUnit, childUnits)

        ReadOnlyAccessor.SampleUnitId(newObj) = rdr.GetInteger("SampleUnit_id")

        newObj.ParentSampleUnitId = rdr.GetNullableInteger("ParentSampleUnit_id")
        newObj.SurveyId = rdr.GetInteger("Survey_id")
        newObj.Name = rdr.GetString("strSampleUnit_nm")
        newObj.Target = rdr.GetInteger("intTargetReturn")
        newObj.Priority = rdr.GetInteger("priority")
        newObj.SelectionType = CType(rdr.GetInteger("SampleSelectionType_id"), SampleSelectionType)
        newObj.InitialResponseRate = rdr.GetInteger("numInitResponseRate")
        newObj.HistoricalResponseRate = rdr.GetInteger("numResponseRate")
        'newObj.IsHcahps = rdr.GetBoolean("bitHCAHPS")
        'newObj.IsACOcahps = rdr.GetBoolean("bitACOCAHPS")
        'newObj.IsHHcahps = rdr.GetBoolean("bitHHCAHPS")
        'newObj.IsCHART = rdr.GetBoolean("bitCHART")
        'newObj.IsMNCM = rdr.GetBoolean("bitMNCM")
        newObj.IsSuppressed = rdr.GetBoolean("bitSuppress")
        newObj.Priority = rdr.GetInteger("priority")
        newObj.FacilityId = rdr.GetInteger("sufacility_id")
        newObj.CriteriaStatementId = rdr.GetInteger("CriteriaStmt_id")
        newObj.SamplePlanId = rdr.GetInteger("SamplePlan_id")
        newObj.DontSampleUnit = Convert.ToBoolean(rdr.GetByte("DontSampleUnit"))
        Select Case rdr.GetInteger("SampleSelectionType_id")
            Case 1
                newObj.SelectionType = SampleSelectionType.Exclusive
            Case 2
                newObj.SelectionType = SampleSelectionType.MinorModule
            Case 3
                newObj.SelectionType = SampleSelectionType.NonExclusive
        End Select
        newObj.CAHPSType = CType(rdr.GetInteger("CAHPSType_Id"), CAHPSType)

        newObj.ResetDirtyFlag()

        Return newObj

    End Function

    ''' <summary>
    ''' Returns an instance of an existing unit.
    ''' </summary>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function [Select](ByVal sampleUnitId As Integer, ByVal survey As Survey) As SampleUnit

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnit, sampleUnitId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSampleUnit(rdr, survey)
            Else
                Return Nothing
            End If
        End Using

    End Function

    ''' <summary>
    ''' Returns a collection of child units for the specified parent
    ''' </summary>
    ''' <param name="parentSampleUnitId"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectByParentId(ByVal parentSampleUnitId As Integer, ByVal survey As Survey) As Collection(Of SampleUnit)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnitsByParentId, parentSampleUnitId)
        Dim units As New Collection(Of SampleUnit)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                units.Add(PopulateSampleUnit(rdr, survey))
            End While
        End Using

        If units.Count = 0 Then
            Return Nothing
        Else
            Return units
        End If

    End Function

    ''' <summary>
    ''' Returns a collection of all units for a survey.
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectBySurvey(ByVal survey As Survey) As Collection(Of SampleUnit)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnitsBySurveyId, survey.Id)

        Using ds As DataSet = ExecuteDataSet(cmd)
            ds.Relations.Add("ParentChild", ds.Tables(0).Columns("SampleUnit_id"), ds.Tables(0).Columns("ParentSampleUnit_id"))
            Dim units As New Collection(Of SampleUnit)

            Dim roots As DataRow() = ds.Tables(0).Select("ParentSampleUnit_id IS NULL", "SampleUnit_id")
            For Each row As DataRow In roots
                units.Add(FillSampleUnit(row, Nothing, survey))
            Next

            Return units
        End Using

    End Function

    ''' <summary>
    ''' Returns all sample units for a survey without parent/child relationship
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectAllForSurvey(ByVal survey As Survey) As System.Collections.ObjectModel.Collection(Of SampleUnit)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSampleUnitsBySurveyId, survey.Id)
        Dim units As New Collection(Of SampleUnit)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                units.Add(PopulateSampleUnit(rdr, survey))
            End While
        End Using

        Return units

    End Function

    ''' <summary>
    ''' This method is used to recursively populate a tree of sampleunits
    ''' </summary>
    ''' <param name="parentRow"></param>
    ''' <param name="parentUnit"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function FillSampleUnit(ByVal parentRow As DataRow, ByVal parentUnit As SampleUnit, ByVal survey As Survey) As SampleUnit

        Dim rows() As DataRow = {parentRow}
        Dim rdr As New SafeDataReader(New DataRowReader(rows))
        Dim unit As SampleUnit = Nothing

        If (rdr.Read) Then
            unit = PopulateSampleUnit(rdr, survey, parentUnit, New Collection(Of SampleUnit))
        End If

        Dim criteria As String = String.Format("ParentSampleUnit_id = {0}", unit.Id)
        Dim children As DataRow() = parentRow.Table.Select(criteria, "SampleUnit_id")

        For Each row As DataRow In children
            unit.ChildUnits.Add(FillSampleUnit(row, unit, survey))
        Next

        Return unit

    End Function

    ''' <summary>
    ''' This method adds a new record in the sampleplan table
    ''' </summary>
    ''' <param name="surveyId"></param>
    ''' <param name="qualisysEmployeeId"></param>
    ''' <param name="tran"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function InsertSamplePlan(ByVal surveyId As Integer, ByVal qualisysEmployeeId As Integer, ByVal tran As DbTransaction) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplePlan, qualisysEmployeeId, surveyId)
        Return ExecuteInteger(cmd, tran)

    End Function

    ''' <summary>
    ''' This Method recursively sets the sampleplan ID on existing units.
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <param name="sampleplanId"></param>
    ''' <remarks></remarks>
    Private Shared Sub UpdateSamplePlanId(ByVal unit As SampleUnit, ByVal sampleplanId As Integer)

        unit.SamplePlanId = sampleplanId

        For Each childUnit As SampleUnit In unit.ChildUnits
            UpdateSamplePlanId(childUnit, sampleplanId)
        Next

    End Sub

    ''' <summary>
    ''' This method is used to update a sampleUnit
    ''' </summary>
    ''' <param name="rootUnit"></param>
    ''' <param name="qualisysEmployeeId"></param>
    ''' <remarks></remarks>
    Public Overrides Sub Update(ByVal rootUnit As SampleUnit, ByVal qualisysEmployeeId As Integer)

        Dim surveyId As Integer
        Dim samplePlanId As Integer

        Using con As DbConnection = Db.CreateConnection
            con.Open()
            Using tran As DbTransaction = con.BeginTransaction
                Try
                    If rootUnit.ParentSampleUnitId.HasValue Then Throw New Exception("Only root units should be used as parameters for the update method of the sampleunit class.")
                    'If this is a new survey, we will need to add a sampleplan record
                    If rootUnit.SamplePlanId = 0 Then
                        samplePlanId = InsertSamplePlan(rootUnit.SurveyId, qualisysEmployeeId, tran)
                        UpdateSamplePlanId(rootUnit, samplePlanId)
                    End If

                    surveyId = rootUnit.SurveyId
                    IterateUnits(rootUnit, Nothing, tran)
                    tran.Commit()

                Catch ex As Exception
                    tran.Rollback()
                    Throw

                End Try
            End Using
        End Using

    End Sub

    ''' <summary>
    ''' This method traverses the entire sampleplan and does an insert, update, delete, or nothing to each unit.
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <param name="ParentUnitId"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Private Sub IterateUnits(ByVal unit As SampleUnit, ByVal ParentUnitId As Nullable(Of Integer), ByVal tran As DbTransaction)

        If unit.IsDirty OrElse unit.Criteria.IsDirty Then
            If unit.IsNew = False And unit.NeedsDelete = True Then
                DeleteUnit(unit.Id, tran)
            ElseIf unit.IsNew And unit.NeedsDelete = False Then
                InsertUnit(unit, ParentUnitId, tran)
            ElseIf unit.IsNew = False Then
                If unit.IsDirty Then UpdateUnit(unit, tran)
            End If
        End If

        For Each child As SampleUnit In unit.ChildUnits
            IterateUnits(child, unit.Id, tran)
        Next

    End Sub

    ''' <summary>
    ''' This method deletes and then reinserts services for the unit.
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Private Sub DeleteAndThenInsertServices(ByVal unit As SampleUnit, ByVal tran As DbTransaction)

        'Delete and then insert the services
        SampleUnitServiceTypeProvider.DeleteSampleUnitServiceByUnitId(unit.Id, tran)
        SampleUnitServiceTypeProvider.InsertSampleUnitService(unit.Id, unit.Service.Id, Nothing, tran)

        For Each service As SampleUnitServiceType In unit.Service.ChildServices
            SampleUnitServiceTypeProvider.InsertSampleUnitService(unit.Id, service.Id, Nothing, tran)
        Next

    End Sub

    ''' <summary>
    ''' Helper fuction for checking if the parent unit Id is null
    ''' </summary>
    ''' <param name="parentUnitId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetNullableParentSampleUnitId(ByVal parentUnitId As Nullable(Of Integer)) As Object

        Dim parentSampleUnitId As Object

        If parentUnitId.HasValue Then
            parentSampleUnitId = parentUnitId
        Else
            parentSampleUnitId = DBNull.Value
        End If

        Return parentSampleUnitId

    End Function

    ''' <summary>
    ''' Helper function to determine if the facility Id is null
    ''' </summary>
    ''' <param name="unitFacility"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetNullableFacilityId(ByVal unitFacility As Facility) As Object

        Dim facilityId As Object

        If unitFacility Is Nothing Then
            facilityId = DBNull.Value
        Else
            facilityId = unitFacility.Id
        End If

        Return facilityId

    End Function

    ''' <summary>
    ''' Helper function that returns the integer value for a unit selection value
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetUnitSelectionValue(ByVal unit As SampleUnit) As Integer

        Dim selectionType As Integer

        Select Case unit.SelectionType
            Case SampleSelectionType.Exclusive
                selectionType = 1

            Case SampleSelectionType.MinorModule
                selectionType = 2

            Case SampleSelectionType.NonExclusive
                selectionType = 3

            Case Else
                Throw New Exception("No selection type defined for unit")

        End Select

        Return selectionType

    End Function

    ''' <summary>
    ''' Inserts a unit into the database.
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <param name="ParentUnitId"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Private Sub InsertUnit(ByVal unit As SampleUnit, ByVal ParentUnitId As Nullable(Of Integer), ByVal tran As DbTransaction)

        Dim selectionType As Integer
        Dim parentSampleUnitId As Object = GetNullableParentSampleUnitId(ParentUnitId)
        Dim facilityId As Object = GetNullableFacilityId(unit.Facility)

        If ParentUnitId.HasValue Then unit.ParentSampleUnitId = ParentUnitId

        selectionType = GetUnitSelectionValue(unit)

        If unit.Criteria.IsValid = False Then Throw New Exception("No criteria exists for unit " + unit.DisplayLabel)

        unit.CriteriaStatementId = CriteriaProvider.InsertCriteria(unit.Criteria, "SampUnit", tran)
        unit.Criteria = Nothing 'This will force a repopulate if code checks property
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSampleUnit, unit.CriteriaStatementId, unit.SamplePlanId, _
                                                       parentSampleUnitId, unit.Name, unit.Target, unit.InitialResponseRate, _
                                                       facilityId, unit.IsSuppressed, _
                                                       unit.Priority, _
                                                       selectionType, unit.DontSampleUnit)
        Using rdr As New SafeDataReader(ExecuteReader(cmd, tran))
            If rdr.Read Then
                ReadOnlyAccessor.SampleUnitId(unit) = rdr.GetInteger("SampleUnit_id")
            End If
        End Using

        DeleteAndThenInsertServices(unit, tran)

    End Sub

    ''' <summary>
    ''' Updates a unit in the database.
    ''' </summary>
    ''' <param name="unit"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Private Sub UpdateUnit(ByVal unit As SampleUnit, ByVal tran As DbTransaction)

        Dim selectionType As Integer
        Dim parentSampleUnitId As Object = GetNullableParentSampleUnitId(unit.ParentSampleUnitId)
        Dim facilityId As Object = GetNullableFacilityId(unit.Facility)

        If unit.Criteria.IsDirty Then CriteriaProvider.UpdateCriteria(unit.Criteria, tran)
        If unit.QuestionSections.IsDirty Then unit.QuestionSections.Save()

        If unit.IsDirty Then
            selectionType = GetUnitSelectionValue(unit)
            DeleteAndThenInsertServices(unit, tran)
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSampleUnit, unit.Id, unit.CriteriaStatementId.Value, _
                                                           unit.SamplePlanId, parentSampleUnitId, unit.Name, unit.Target, _
                                                           unit.InitialResponseRate, unit.FacilityId, unit.IsSuppressed, _
                                                           unit.Priority, selectionType, unit.DontSampleUnit)
            ExecuteNonQuery(cmd, tran)
            unit.ResetDirtyFlag()
        End If

    End Sub

    ''' <summary>
    ''' Deletes a unit in the database.
    ''' </summary>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Private Sub DeleteUnit(ByVal sampleUnitId As Integer, ByVal tran As DbTransaction)

        Dim errorList As New Collection(Of String)
        Dim errorString As String = Nothing
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsSampleUnitDeletable, sampleUnitId, False)

        Using rdr As New SafeDataReader(ExecuteReader(cmd, tran))
            While rdr.Read
                errorList.Add(rdr.GetString("strMessage"))
            End While
        End Using

        If errorList.Count > 0 Then
            For Each str As String In errorList
                If errorString IsNot Nothing Then errorString += vbCrLf
                errorString += str
            Next
            Throw New Exception(errorString)
        End If

    End Sub

    ''' <summary>
    ''' Indicates whether a unit is deletable
    ''' </summary>
    ''' <param name="sampleUnitId"></param>
    ''' <param name="mUnDeletableReasons"></param>
    ''' <returns></returns>
    ''' <remarks>This method also takes a collection of strings that it adds messages to.  These
    ''' messages indicate the reasons why a unit cannot be deleted.</remarks>
    Public Overrides Function IsDeletable(ByVal sampleUnitId As Integer, ByRef mUnDeletableReasons As Collection(Of String)) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsSampleUnitDeletable, sampleUnitId, True)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                If rdr.GetInteger("Error") > 0 Then mUnDeletableReasons.Add(rdr.GetString("strMessage"))
            End While
        End Using

        If mUnDeletableReasons.Count > 0 Then
            Return False
        Else
            Return True
        End If

    End Function

End Class
