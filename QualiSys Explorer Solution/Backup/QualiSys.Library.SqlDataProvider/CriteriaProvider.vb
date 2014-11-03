Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data
Public Class CriteriaProvider
    Inherits Nrc.QualiSys.Library.DataProvider.CriteriaProvider

    ''' <summary>
    ''' Creates an instance of a criteria  from a datareader
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Shared Function PopulateCriteria(ByVal rdr As SafeDataReader) As Criteria
        Dim newObj As New Criteria(rdr.GetInteger("STUDY_ID"))
        ReadOnlyAccessor.CriteriaId(newObj) = rdr.GetInteger("CriteriaStmt_Id")
        newObj.InitialCriteriaStatement = rdr.GetString("strCriteriaString")
        newObj.Name = rdr.GetString("STRCRITERIASTMT_NM", Nothing).Trim
        Return newObj
    End Function

    ''' <summary>
    ''' Returns an instance of a criteria
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectCriteria(ByVal criteriaStatementId As Integer) As Criteria
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectCriteria, criteriaStatementId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateCriteria(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    ''' <summary>
    ''' Creates an instance of a criteria clause from a datareader
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Shared Function PopulateCriteriaClause(ByVal rdr As SafeDataReader) As CriteriaClause
        Dim newObj As New CriteriaClause
        ReadOnlyAccessor.CriteriaClauseId(newObj) = rdr.GetInteger("CRITERIACLAUSE_ID")
        newObj.CriteriaPhraseId = rdr.GetInteger("CRITERIAPHRASE_ID")
        newObj.CriteriaStatementId = rdr.GetInteger("CRITERIASTMT_ID")
        newObj.HighValue = rdr.GetString("STRHIGHVALUE")
        newObj.LowValue = rdr.GetString("STRLOWVALUE")
        newObj.Operator = DirectCast(rdr.GetInteger("INTOPERATOR"), CriteriaClause.Operators)
        newObj.StudyTable = StudyTable.Get(rdr.GetInteger("TABLE_ID"))
        newObj.StudyTableColumn = StudyTableColumn.Get(newObj.StudyTable.Id, rdr.GetInteger("FIELD_ID"))
        Return newObj
    End Function


    ''' <summary>
    ''' Returns collection of criteria clauses
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectCriteriaClauseByStatementAndPhraseId(ByVal criteriaStatementId As Integer, ByVal criteriaPhraseId As Integer) As System.Collections.ObjectModel.Collection(Of CriteriaClause)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectCriteriaClauseByStatementAndPhraseId, criteriaStatementId, criteriaPhraseId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of CriteriaClause)(rdr, AddressOf PopulateCriteriaClause)
        End Using
    End Function

    ''' <summary>
    ''' Creates an instance of a criteria in value from a datareader
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Shared Function PopulateCriteriaInValue(ByVal rdr As SafeDataReader) As CriteriaInValue
        Dim newObj As New CriteriaInValue
        ReadOnlyAccessor.CriteriaInValueId(newObj) = rdr.GetInteger("CRITERIAINLIST_ID")
        newObj.CriteriaClauseId = rdr.GetInteger("CRITERIACLAUSE_ID")
        newObj.Value = rdr.GetString("STRLISTVALUE")
        Return newObj
    End Function


    ''' <summary>
    ''' Returns a collection of a criteria in lists
    ''' </summary>
    ''' <param name="criteriaClauseId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectCriteriaInListByCriteriaClause(ByVal criteriaClauseId As Integer) As System.Collections.ObjectModel.Collection(Of CriteriaInValue)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectCriteriaInListByCriteriaClause, criteriaClauseId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of CriteriaInValue)(rdr, AddressOf PopulateCriteriaInValue)
        End Using
    End Function


    ''' <summary>
    ''' Creates an instance of a criteria phrase from a datareader
    ''' </summary>
    ''' <param name="rdr"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend Shared Function PopulateCriteriaPhrase(ByVal rdr As SafeDataReader) As CriteriaPhrase
        Dim newobj As New CriteriaPhrase
        newobj.Id = rdr.GetInteger("CriteriaPhrase_Id")
        newobj.CriteriaStatementId = rdr.GetInteger("CRITERIASTMT_ID")
        Return newobj
    End Function

    ''' <summary>
    ''' Returns a collection of a criteria phrases
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Overrides Function SelectCriteriaPhraseByCriteriaStatementId(ByVal criteriaStatementId As Integer) As System.Collections.ObjectModel.Collection(Of CriteriaPhrase)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectCriteriaPhraseByCriteriaStatementId, criteriaStatementId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of CriteriaPhrase)(rdr, AddressOf PopulateCriteriaPhrase)
        End Using
    End Function

    ''' <summary>
    ''' Deletes a criteria
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Friend Shared Sub DeleteCriteria(ByVal criteriaStatementId As Integer, ByVal tran As DbTransaction)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteCriteria, criteriaStatementId)
        ExecuteNonQuery(cmd, tran)
    End Sub

    ''' <summary>
    ''' Deletes all criateria phrases for a criteria
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <param name="tran"></param>
    ''' <remarks></remarks>
    Private Shared Sub DeleteCriteriaPhrases(ByVal criteriaStatementId As Integer, ByVal tran As DbTransaction)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteCriteriaPhrases, criteriaStatementId)
        ExecuteNonQuery(cmd, tran)
    End Sub

    ''' <summary>
    ''' Inserts a criteria  
    ''' </summary>
    ''' <param name="criteria"></param>
    ''' <param name="dummyName"></param>
    ''' <param name="tran"></param>
    ''' <returns></returns>
    ''' <remarks>This version is used when the criteria object is part of a sampleunit.  When criteria
    ''' statements are added to units, no rule name is added. 
    ''' </remarks>
    Friend Shared Function InsertCriteria(ByVal criteria As Criteria, ByVal dummyName As String, ByVal tran As DbTransaction) As Integer
        criteria.Name = dummyName
        Return InsertCriteria(criteria, tran)
    End Function

    ''' <summary>
    ''' Inserts a criteria
    ''' </summary>
    ''' <param name="criteria"></param>
    ''' <param name="tran"></param>
    ''' <returns></returns>
    ''' <remarks>This version is used when the criteria object is not part of a sampleunit.</remarks>
    Friend Shared Function InsertCriteria(ByVal criteria As Criteria, ByVal tran As DbTransaction) As Integer
        Dim criteriaId As Integer
        Dim phraseId As Integer
        Dim clauseId As Integer
        Dim inValueId As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertCriteria, criteria.StudyId, criteria.Name, criteria.CriteriaStatement())
        criteriaId = ExecuteInteger(cmd, tran)

        For Each phrase As CriteriaPhrase In criteria.Phrases
            phraseId += 1
            For Each clause As CriteriaClause In phrase.Clauses
                clauseId = InsertCriteriaClause(criteriaId, phraseId, clause.StudyTable.Id, clause.StudyTableColumn.Id, clause.Operator, clause.LowValue, clause.HighValue, tran)
                If clause.Operator = CriteriaClause.Operators.[In] OrElse clause.Operator = CriteriaClause.Operators.NotIn Then
                    For Each value As CriteriaInValue In clause.ValueList
                        inValueId = InsertCriteriaInValue(clauseId, value.Value, tran)
                    Next
                End If
            Next
        Next
        ReadOnlyAccessor.CriteriaId(criteria) = criteriaId
        Return criteriaId
    End Function

    ''' <summary>
    ''' Inserts a criteria clause
    ''' </summary>
    ''' <param name="criteriaStatementId"></param>
    ''' <param name="criteriaPhraseId"></param>
    ''' <param name="tableId"></param>
    ''' <param name="fieldId"></param>
    ''' <param name="operator"></param>
    ''' <param name="lowValue"></param>
    ''' <param name="highValue"></param>
    ''' <param name="tran"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function InsertCriteriaClause(ByVal criteriaStatementId As Integer, ByVal criteriaPhraseId As Integer, ByVal tableId As Integer, ByVal fieldId As Integer, ByVal [operator] As CriteriaClause.Operators, ByVal lowValue As String, ByVal highValue As String, ByVal tran As DbTransaction) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertCriteriaClause, criteriaStatementId, criteriaPhraseId, tableId, fieldId, CInt([operator]), lowValue, highValue)
        Return ExecuteInteger(cmd, tran)
    End Function

    ''' <summary>
    ''' Inserts a criteria in value
    ''' </summary>
    ''' <param name="criteriaClauseId"></param>
    ''' <param name="value"></param>
    ''' <param name="tran"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function InsertCriteriaInValue(ByVal criteriaClauseId As Integer, ByVal value As String, ByVal tran As DbTransaction) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertCriteriaInValue, criteriaClauseId, value)
        Return ExecuteInteger(cmd, tran)
    End Function

    ''' <summary>
    ''' Updates a criteria
    ''' </summary>
    ''' <param name="criteria"></param>
    ''' <param name="tran"></param>
    ''' <remarks>When a criteria is updated, all phrases are deleted and readded.</remarks>
    Friend Shared Sub UpdateCriteria(ByVal criteria As Criteria, ByVal tran As DbTransaction)
        Dim phraseId As Integer
        Dim clauseId As Integer
        Dim inValueId As Integer

        'Delete all criteria phrases, and then reinsert the phrases
        DeleteCriteriaPhrases(criteria.Id.Value, tran)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateCriteria, criteria.Id, criteria.Name, criteria.CriteriaStatement())
        ExecuteNonQuery(cmd, tran)

        For Each phrase As CriteriaPhrase In criteria.Phrases
            phraseId += 1
            'Phrase Id is not an identity in database, so we need to update here
            phrase.Id = phraseId
            For Each clause As CriteriaClause In phrase.Clauses
                clauseId = InsertCriteriaClause(criteria.Id.Value, phraseId, clause.StudyTable.Id, clause.StudyTableColumn.Id, clause.Operator, clause.LowValue, clause.HighValue, tran)
                ReadOnlyAccessor.CriteriaClauseId(clause) = clauseId
                If clause.Operator = CriteriaClause.Operators.[In] OrElse clause.Operator = CriteriaClause.Operators.NotIn Then
                    For Each value As CriteriaInValue In clause.ValueList
                        inValueId = InsertCriteriaInValue(clauseId, value.Value, tran)
                        value.Id = inValueId
                    Next
                End If
            Next
        Next

        'Reset the initial criteria statement.  This is used to determine if the object is dirty
        criteria.InitialCriteriaStatement = criteria.CriteriaStatement()
    End Sub
End Class
