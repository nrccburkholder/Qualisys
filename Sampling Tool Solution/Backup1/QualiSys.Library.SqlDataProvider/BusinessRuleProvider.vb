Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data
Public Class BusinessRuleProvider
    Inherits Nrc.QualiSys.Library.DataProvider.BusinessRuleProvider

    ''' <summary>
    ''' Populates a business rule object usings a datareader
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Shared Function PopulateBusinessRule(ByVal rdr As SafeDataReader, ByVal survey As Survey) As BusinessRule
        Dim newObj As New BusinessRule(survey, Nothing)
        ReadOnlyAccessor.BusinessRuleId(newObj) = rdr.GetInteger("businessRule_Id")
        newObj.CriteriaId = rdr.GetInteger("CRITERIASTMT_Id")
        Select Case rdr.GetString("BusRule_CD")
            Case "A"
                newObj.RuleType = BusinessRule.BusinessRuleType.BadAddress
            Case "F"
                newObj.RuleType = BusinessRule.BusinessRuleType.BadPhone
            Case "Q"
                newObj.RuleType = BusinessRule.BusinessRuleType.DQ
            Case "M"
                newObj.RuleType = BusinessRule.BusinessRuleType.MinorExclusion
            Case "B"
                newObj.RuleType = BusinessRule.BusinessRuleType.Newborn
            Case "P"
                newObj.RuleType = BusinessRule.BusinessRuleType.Provider
            Case Else
                Throw New Exception("Error Reading Business Rule.  RuleType is invalid.")
        End Select

        newObj.ResetDirtyFlag()
        Return newObj
    End Function

    ''' <summary>
    ''' Creates an instance of an existing business rule
    ''' </summary>
    ''' <param name="businessRuleId"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectBusinessRule(ByVal businessRuleId As Integer, ByVal survey As Survey) As BusinessRule
        Dim busRule As BusinessRule = Nothing
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectBusinessRule, businessRuleId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                busRule = PopulateBusinessRule(rdr, survey)
            End If
        End Using
        busRule.Criteria = Criteria.Get(busRule.CriteriaId)

        Return busRule
    End Function

    ''' <summary>
    ''' Creates a collection of business rule objects
    ''' </summary>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectBusinessRulesBySurvey(ByVal survey As Survey) As System.Collections.ObjectModel.Collection(Of BusinessRule)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectBusinessRulesBySurveyId, survey.Id)

        Dim busRules As New Collection(Of BusinessRule)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                busRules.Add(PopulateBusinessRule(rdr, survey))
            End While
        End Using

        For Each busRule As BusinessRule In busRules
            busRule.Criteria = Criteria.Get(busRule.CriteriaId)
        Next

        Return busRules
    End Function
    ''' <summary>
    ''' Inserts a new business rule
    ''' </summary>
    ''' <param name="busRule"></param>
    ''' <param name="tran"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function InsertBusinessRule(ByVal busRule As BusinessRule, ByVal tran As DbTransaction) As Integer
        Dim ruleValue As String

        Select Case busRule.RuleType
            Case BusinessRule.BusinessRuleType.BadAddress
                ruleValue = "A"
            Case BusinessRule.BusinessRuleType.BadPhone
                ruleValue = "F"
            Case BusinessRule.BusinessRuleType.DQ
                ruleValue = "Q"
            Case BusinessRule.BusinessRuleType.MinorExclusion
                ruleValue = "M"
            Case BusinessRule.BusinessRuleType.Newborn
                ruleValue = "B"
            Case BusinessRule.BusinessRuleType.Provider
                ruleValue = "P"
            Case Else
                Throw New Exception("Error Inserting Business Rule.  No ruleType was set for object")
        End Select

        'Insert the criteria object
        busRule.CriteriaId = CriteriaProvider.InsertCriteria(busRule.Criteria, tran)

        'Insert the business rule record
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertBusinessRule, busRule.Survey.StudyId, busRule.Survey.Id, busRule.CriteriaId, ruleValue)
        Return ExecuteInteger(cmd, tran)
    End Function

    ''' <summary>
    ''' Deletes a business rule
    ''' </summary>
    ''' <param name="businessRuleObject"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Public Shared Sub DeleteBusinessRule(ByVal businessRuleObject As BusinessRule, ByVal tran As DbTransaction)

        'Delete the Criteria
        CriteriaProvider.DeleteCriteria(businessRuleObject.Criteria.Id.Value, tran)

        'Delete the Business Rule record
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteBusinessRule, businessRuleObject.Id)
        ExecuteNonQuery(cmd, tran)
    End Sub

    ''' <summary>
    ''' Updates a business rule
    ''' </summary>
    ''' <param name="businessRuleObject"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Public Shared Sub UpdateBusinessRule(ByVal businessRuleObject As BusinessRule, ByVal tran As DbTransaction)

        'Changed to a delete and re-insert business rule for database logging triggers to work.
        DeleteBusinessRule(businessRuleObject, tran)
        ReadOnlyAccessor.BusinessRuleId(businessRuleObject) = InsertBusinessRule(businessRuleObject, tran)

        'Update the criteria 
        CriteriaProvider.UpdateCriteria(businessRuleObject.Criteria, tran)
    End Sub
End Class
