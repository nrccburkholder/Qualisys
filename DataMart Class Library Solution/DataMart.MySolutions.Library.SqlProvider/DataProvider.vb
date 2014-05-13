Imports System.Collections.ObjectModel
Imports Nrc.Framework.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.Text
Public Class DataProvider
    Inherits Nrc.DataMart.MySolutions.Library.DataProvider

    Const SqlQueryContainedIgnoredWords As Integer = &H1DC3
    Const OleDbQueryContainedIgnoredWords As Integer = &H80041605

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.DataMartDb
        End Get
    End Property

    Private ReadOnly Property RscmDb() As Database
        Get
            Return DatabaseHelper.RscmDb
        End Get
    End Property

    Private ReadOnly Property NrcAuthDb() As Database
        Get
            Return DatabaseHelper.NrcAuthDb
        End Get
    End Property

    Private ReadOnly Property IndexDb() As Database
        Get
            Return DatabaseHelper.IndexDb
        End Get
    End Property

#Region " SP Declarations "

    Private Class SP

        Public Const DeleteOneClickDefinition As String = "dbo.DCL_DeleteOneClickDefinition"
        Public Const DeleteOneClickDefinitionsByOneClickType As String = "dbo.DCL_DeleteOneClickDefinitionsByOneClickType"
        Public Const InsertOneClickDefinition As String = "dbo.DCL_InsertOneClickDefinition"
        Public Const SelectOneClickDefinition As String = "dbo.DCL_SelectOneClickDefinition"
        Public Const SelectOneClickDefinitionsByOneClickType As String = "dbo.DCL_SelectOneClickDefinitionsByOneClickType"
        Public Const SelectAllOneClickDefinitions As String = "dbo.DCL_SelectAllOneClickDefinitions"
        Public Const UpdateOneClickDefinition As String = "dbo.DCL_UpdateOneClickDefinition"

        Public Const DeleteOneClickReport As String = "dbo.DCL_DeleteOneClickReport"
        Public Const InsertOneClickReport As String = "dbo.DCL_InsertOneClickReport"
        Public Const SelectOneClickReport As String = "dbo.DCL_SelectOneClickReport"
        Public Const SelectOneClickReportsByClientUserId As String = "dbo.DCL_SelectOneClickReportsByClientUserId"
        Public Const SelectAllOneClickReports As String = "dbo.DCL_SelectAllOneClickReports"
        Public Const UpdateOneClickReport As String = "dbo.DCL_UpdateOneClickReport"

        Public Const DeleteOneClickType As String = "dbo.DCL_DeleteOneClickType"
        Public Const InsertOneClickType As String = "dbo.DCL_InsertOneClickType"
        Public Const SelectOneClickType As String = "dbo.DCL_SelectOneClickType"
        Public Const SelectAllOneClickTypes As String = "dbo.DCL_SelectAllOneClickTypes"
        Public Const UpdateOneClickType As String = "dbo.DCL_UpdateOneClickType"

        Public Const SelectStudyTable As String = "dbo.DCL_SelectStudyTable"
        Public Const SelectStudyTableColumn As String = "dbo.DCL_SelectStudyTableColumn"
        Public Const SelectStudyTableColumns As String = "dbo.DCL_SelectStudyTableColumns"
        Public Const SelectAllStudyTables As String = "dbo.DCL_SelectAllStudyTables"
        Public Const UpdateStudyTableColumn As String = "dbo.DCL_UpdateStudyTableColumn"

        Public Const SelectCommentFiltersByGroupId As String = "dbo.DCL_SelectCommentFiltersByGroupId"
        Public Const InsertCommentFilter As String = "dbo.DCL_InsertCommentFilter"
        Public Const UpdateCommentFilter As String = "dbo.DCL_UpdateCommentFilter"
        Public Const DeleteCommentFilter As String = "dbo.DCL_DeleteCommentFilter"
        Public Const ValidateStudyTableColumnFormula As String = "dbo.DCL_ValidateStudyTableColumnFormula"
        Public Const InsertCalculatedStudyTableColumn As String = "dbo.DCL_NewCalculatedMetafield"
        Public Const CreateBigView As String = "SP_DBM_MakeView"

        Public Const SelectManagedContent As String = "dbo.CM_Select_Content"
        Public Const SelectManagedContentCategories As String = "dbo.CM_Select_ContentCategories"
        Public Const SelectManagedContentKeys As String = "dbo.CM_Select_ContentKeys"
        Public Const InsertManagedContent As String = "dbo.CM_Insert_Content"
        Public Const UpdateManagedContent As String = "dbo.CM_Update_Content"
        Public Const DeleteManagedContent As String = "dbo.CM_Delete_Content"

        Public Const SelectThemeQuestionsByThemeId As String = "dbo.DCL_SelectThemeQuestionsByThemeId"
        Public Const SelectThemeQuestionsByQuestionId As String = "dbo.DCL_SelectThemeQuestionsByQuestionId"
        Public Const InsertThemeQuestion As String = "dbo.DCL_InsertQuestionToTheme"
        Public Const DeleteThemeQuestion As String = "dbo.DCL_DeleteQuestionFromTheme"

        Public Const SelectAllServiceTypes As String = "dbo.DCL_SelectAllServiceTypes"
        Public Const InsertServiceType As String = "dbo.DCL_InsertServiceType"
        Public Const UpdateServiceType As String = "dbo.DCL_UpdateServiceType"
        Public Const DeleteServiceType As String = "dbo.DCL_DeleteServiceType"
        Public Const InsertView As String = "dbo.DCL_InsertView"
        Public Const UpdateView As String = "dbo.DCL_UpdateView"
        Public Const DeleteView As String = "dbo.DCL_DeleteView"
        Public Const InsertTheme As String = "dbo.DCL_InsertTheme"
        Public Const UpdateTheme As String = "dbo.DCL_UpdateTheme"
        Public Const DeleteTheme As String = "dbo.DCL_DeleteTheme"

        Public Const SelectQuestionContent As String = "dbo.DCL_SelectQuestionContent"
        Public Const UpdateQuestionContent As String = "dbo.DCL_UpdateQuestionContent"
        Public Const InsertQuestionContent As String = "dbo.DCL_InsertQuestionContent"
        Public Const RelateQuestionContent As String = "dbo.DCL_RelateQuestionContent"
        Public Const UnrelateQuestionContent As String = "dbo.DCL_UnrelateQuestionContent"
        Public Const SelectRelatedQuestions As String = "dbo.DCL_SelectRelatedQuestions"

        Public Const SelectMemberResource As String = "dbo.DCL_SelectMemberResource"
        Public Const SelectMemberResourceByTitle As String = "DCL_SelectMemberResourceByTitle"
        Public Const SelectRecentMemberResource As String = "dbo.DCL_SelectRecentMemberResource"
        Public Const SearchTextMemberResource As String = "dbo.DCL_SearchTextMemberResource"
        Public Const InsertMemberResource As String = "dbo.DCL_InsertMemberResource"
        Public Const UpdateMemberResource As String = "dbo.DCL_UpdateMemberResource"
        Public Const DeleteMemberResource As String = "dbo.DCL_DeleteMemberResource"

        Public Const InsertMemberResourceQuestion As String = "dbo.DCL_InsertMemberResourceQuestion"
        Public Const UpdateMemberResourceQuestion As String = "dbo.DCL_UpdateMemberResourceQuestion"
        Public Const DeleteMemberResourceQuestion As String = "dbo.DCL_DeleteMemberResourceQuestion"

        Public Const InsertMemberResourceOtherType As String = "dbo.DCL_InsertMemberResourceOtherType"
        Public Const DeleteMemberResourceOtherType As String = "dbo.DCL_DeleteMemberResourceOtherType"

        ''' <summary>
        ''' Stored procedure used to insert a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
        ''' </summary>
        ''' <remarks>
        '''   <para>
        '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
        '''   </para>
        ''' </remarks>
        Public Const InsertMemberResourceGroup As String = "dbo.DCL_InsertMemberResourceGroup"
        ''' <summary>
        ''' Stored procedure used to update a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
        ''' </summary>
        ''' <remarks>
        '''   <para>
        '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
        '''   </para>
        ''' </remarks>
        Public Const UpdateMemberResourceGroup As String = "dbo.DCL_UpdateMemberResourceGroup"
        ''' <summary>
        ''' Stored procedure used to delete a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
        ''' </summary>
        ''' <remarks>
        '''   <para>
        '''   Rick Christenham (09/06/2007): NRC eToolkit Enhancement II
        '''   </para>
        ''' </remarks>
        Public Const DeleteMemberResourceGroup As String = "dbo.DCL_DeleteMemberResourceGroup"

        Public Const InsertIndexSearchResult As String = "dbo.DCL_InsertIndexServerResult"
        Public Const SearchIndexSearchResult As String = "Select FileName, Rank from SCOPE() WHERE FREETEXT('{1}')"
        Public Const ClearIndexSearchResult As String = "dbo.DCL_ClearIndexServerResult"

        Public Const SearchQuestionSearchText As String = "dbo.DCL_SearchTextQuestionSearchWork"

        Public Const SelectResourceType As String = "dbo.DCL_SelectResourceType"
        Public Const SelectResourceTypeByDescription As String = "dbo.DCL_SelectResourceTypeByDescription"
        Public Const InsertResourceType As String = "dbo.DCL_InsertResourceType"
        Public Const UpdateResourceType As String = "dbo.DCL_UpdateResourceType"
        Public Const DeleteResourceType As String = "dbo.DCL_DeleteResourceType"

        Public Const SelectResourceOtherType As String = "dbo.DCL_SelectResourceOtherType"
        Public Const SelectResourceOtherTypeByDescription As String = "dbo.DCL_SelectResourceOtherTypeByDescription"
        Public Const InsertResourceOtherType As String = "dbo.DCL_InsertResourceOtherType"
        Public Const UpdateResourceOtherType As String = "dbo.DCL_UpdateResourceOtherType"
        Public Const DeleteResourceOtherType As String = "dbo.DCL_DeleteResourceOtherType"

        Public Const SelectNotifyMethod As String = "dbo.DCL_SelectNotifyMethod"

        Public Const SelectAnalysisMeasure As String = "dbo.DCL_SelectAnalysisMeasure"

        Public Const SelectMemberReportPreference As String = "dbo.DCL_SelectMemberReportPreference"
        Public Const InsertMemberReportPreference As String = "dbo.DCL_InsertMemberReportPreference"
        Public Const UpdateMemberReportPreference As String = "dbo.DCL_UpdateMemberReportPreference"
        Public Const DeleteMemberReportPreference As String = "dbo.DCL_DeleteMemberReportPreference"

        Public Const SelectMemberGroupReportPreference As String = "dbo.DCL_SelectMemberGroupReportPreference"
        Public Const InsertMemberGroupReportPreference As String = "dbo.DCL_InsertMemberGroupReportPreference"
        Public Const UpdateMemberGroupReportPreference As String = "dbo.DCL_UpdateMemberGroupReportPreference"
        Public Const DeleteMemberGroupReportPreference As String = "dbo.DCL_DeleteMemberGroupReportPreference"

        Public Const SelectToolkitContentNotifyMember As String = "dbo.Auth_SelectToolkitContentNotifyMember"

    End Class

#End Region

#Region " CommentFilter Procs "
    Private Function PopulateCommentFilter(ByVal rdr As SafeDataReader) As CommentFilter
        Dim newObject As CommentFilter = CommentFilter.NewCommentFilter
        newObject.BeginPopulate()
        newObject.StudyTableColumnId = rdr.GetInteger("Field_id")
        newObject.GroupId = rdr.GetInteger("User_id")
        newObject.Name = rdr.GetString("strFieldLabel")
        newObject.IsDisplayed = rdr.GetBoolean("bitGeneral_Display")
        newObject.IsExported = rdr.GetBoolean("bitGeneral_Export")
        newObject.IsDisplayedOnServiceAlert = rdr.GetBoolean("bitSA_Display")
        newObject.IsExportedOnServiceAlert = rdr.GetBoolean("bitSA_Export")
        newObject.AllowGroupBy = rdr.GetBoolean("bitCommentFilter")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectCommentFiltersByGroupId(ByVal groupId As Integer) As CommentFilterCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCommentFiltersByGroupId, groupId)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of CommentFilterCollection, CommentFilter)(rdr, AddressOf PopulateCommentFilter)
        End Using
    End Function

    Public Overrides Sub InsertCommentFilter(ByVal filter As CommentFilter)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertCommentFilter, filter.StudyTableColumnId, filter.GroupId, filter.Name, filter.IsDisplayed, filter.IsExported, filter.IsDisplayedOnServiceAlert, filter.IsExportedOnServiceAlert, filter.AllowGroupBy)
        ExecuteNonQuery(Db, cmd)
    End Sub


    Public Overrides Sub UpdateCommentFilter(ByVal filter As CommentFilter)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateCommentFilter, filter.StudyTableColumnId, filter.GroupId, filter.Name, filter.IsDisplayed, filter.IsExported, filter.IsDisplayedOnServiceAlert, filter.IsExportedOnServiceAlert, filter.AllowGroupBy)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteCommentFilter(ByVal studyTableColumnId As Integer, ByVal groupId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteCommentFilter, studyTableColumnId, groupId)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " OneClickDefinition Procs "

    Private Function PopulateOneClickDefinition(ByVal rdr As SafeDataReader) As OneClickDefinition

        Dim newObject As New OneClickDefinition
        Dim privateInterface As IOneClickDefinition = newObject

        privateInterface.OneClickDefinitionId = rdr.GetInteger("OneClickDefinition_id")
        newObject.OneClickTypeId = rdr.GetInteger("OneClickType_id")
        newObject.CategoryName = rdr.GetString("strCategory_Nm")
        newObject.OneClickReportName = rdr.GetString("strOneClickReport_Nm")
        newObject.OneClickReportDescription = rdr.GetString("strOneClickReport_Dsc")
        newObject.ReportId = rdr.GetInteger("Report_id")
        newObject.Order = rdr.GetInteger("intOrder")
        newObject.ResetDirtyFlag()

        Return newObject

    End Function


    Public Overrides Function SelectOneClickDefinition(ByVal oneClickDefinitionId As Integer) As OneClickDefinition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOneClickDefinition, oneClickDefinitionId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateOneClickDefinition(rdr)
            End If
        End Using

    End Function


    Public Overrides Function SelectOneClickDefinitionsByOneClickType(ByVal oneClickTypeId As Integer) As Collection(Of OneClickDefinition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOneClickDefinitionsByOneClickType, oneClickTypeId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of OneClickDefinition)(rdr, AddressOf PopulateOneClickDefinition)
        End Using

    End Function


    Public Overrides Function SelectAllOneClickDefinitions() As Collection(Of OneClickDefinition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllOneClickDefinitions)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of OneClickDefinition)(rdr, AddressOf PopulateOneClickDefinition)
        End Using

    End Function


    Public Overrides Function InsertOneClickDefinition(ByVal oneClickTypeId As Integer, ByVal categoryName As String, _
                                                       ByVal oneClickReportName As String, ByVal oneClickReportDescription As String, _
                                                       ByVal reportId As Integer, ByVal order As Integer) As OneClickDefinition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertOneClickDefinition, _
                                                       oneClickTypeId, categoryName, oneClickReportName, oneClickReportDescription, _
                                                       reportId, order)

        Dim newId As Integer = ExecuteInteger(Db, cmd)

        Return Me.SelectOneClickDefinition(newId)

    End Function


    Public Overrides Sub UpdateOneClickDefinition(ByVal instance As OneClickDefinition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateOneClickDefinition, _
                                                       instance.OneClickDefinitionId, instance.OneClickTypeId, instance.CategoryName, _
                                                       instance.OneClickReportName, instance.OneClickReportDescription, instance.ReportId, _
                                                       instance.Order)

        ExecuteNonQuery(Db, cmd)

    End Sub


    Public Overrides Sub DeleteOneClickDefinition(ByVal oneClickDefinitionId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteOneClickDefinition, oneClickDefinitionId)

        ExecuteNonQuery(Db, cmd)

    End Sub


    Public Overrides Sub DeleteOneClickDefinitionsByOneClickType(ByVal oneClickTypeId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteOneClickDefinitionsByOneClickType, oneClickTypeId)

        ExecuteNonQuery(Db, cmd)

    End Sub

#End Region

#Region " OneClickReport Procs "

    Private Function PopulateOneClickReport(ByVal rdr As SafeDataReader) As OneClickReport

        Dim newObject As New OneClickReport
        Dim privateInterface As IOneClickReport = newObject

        privateInterface.Id = rdr.GetInteger("OneClickReport_id")
        newObject.ClientuserId = rdr.GetInteger("Clientuser_id")
        newObject.CategoryName = rdr.GetString("strCategory_nm")
        newObject.Name = rdr.GetString("strOneClickReport_nm")
        newObject.Description = rdr.GetString("strOneClickReport_dsc")
        newObject.ReportId = rdr.GetInteger("Report_id")
        newObject.Order = rdr.GetInteger("intOrder")
        newObject.ResetDirtyFlag()

        Return newObject

    End Function


    Public Overrides Function SelectOneClickReport(ByVal id As Integer) As OneClickReport

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOneClickReport, id)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateOneClickReport(rdr)
            End If
        End Using

    End Function


    Public Overrides Function SelectOneClickReportsByClientUserId(ByVal clientUserId As Integer) As Collection(Of OneClickReport)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOneClickReportsByClientUserId, clientUserId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of OneClickReport)(rdr, AddressOf PopulateOneClickReport)
        End Using

    End Function


    Public Overrides Function SelectAllOneClickReports() As Collection(Of OneClickReport)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllOneClickReports)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of OneClickReport)(rdr, AddressOf PopulateOneClickReport)
        End Using

    End Function


    Public Overrides Function InsertOneClickReport(ByVal clientuserId As Integer, ByVal categoryName As String, ByVal name As String, _
                                                   ByVal description As String, ByVal reportId As Integer, ByVal order As Integer) As OneClickReport

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertOneClickReport, clientuserId, categoryName, name, description, reportId, order)

        Dim newId As Integer = ExecuteInteger(Db, cmd)

        Return Me.SelectOneClickReport(newId)

    End Function


    Public Overrides Sub UpdateOneClickReport(ByVal instance As OneClickReport)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateOneClickReport, _
                                                       instance.Id, instance.ClientuserId, instance.CategoryName, instance.Name, _
                                                       instance.Description, instance.ReportId, instance.Order)

        ExecuteNonQuery(Db, cmd)

    End Sub


    Public Overrides Sub DeleteOneClickReport(ByVal id As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteOneClickReport, id)

        ExecuteNonQuery(Db, cmd)

    End Sub

#End Region

#Region " OneClickType Procs "

    Private Function PopulateOneClickType(ByVal rdr As SafeDataReader) As OneClickType

        Dim newObject As New OneClickType
        Dim privateInterface As IOneClickType = newObject

        privateInterface.OneClickTypeId = rdr.GetInteger("OneClickType_id")
        newObject.OneClickTypeName = rdr.GetString("strOneClickType_Nm")
        newObject.ResetDirtyFlag()

        Return newObject

    End Function


    Public Overrides Function SelectOneClickType(ByVal oneClickTypeId As Integer) As OneClickType

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectOneClickType, oneClickTypeId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateOneClickType(rdr)
            End If
        End Using

    End Function


    Public Overrides Function SelectAllOneClickTypes() As Collection(Of OneClickType)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllOneClickTypes)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of OneClickType)(rdr, AddressOf PopulateOneClickType)
        End Using

    End Function


    Public Overrides Function InsertOneClickType(ByVal oneClickTypeName As String) As OneClickType

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertOneClickType, oneClickTypeName)

        Dim newId As Integer = ExecuteInteger(Db, cmd)

        Return Me.SelectOneClickType(newId)

    End Function


    Public Overrides Sub UpdateOneClickType(ByVal instance As OneClickType)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateOneClickType, instance.OneClickTypeId, instance.OneClickTypeName)

        ExecuteNonQuery(Db, cmd)

    End Sub


    Public Overrides Sub DeleteOneClickType(ByVal oneClickTypeId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteOneClickType, oneClickTypeId)

        ExecuteNonQuery(Db, cmd)

    End Sub

#End Region

#Region "Study Table Procs"
    Private Function PopulateStudyTable(ByVal rdr As SafeDataReader) As StudyTable
        Dim newObj As New StudyTable
        Dim privateInterface As IStudyTable = newObj

        privateInterface.Id = rdr.GetInteger("Table_id")
        newObj.Name = rdr.GetString("strTable_nm")
        newObj.Description = rdr.GetString("strTable_dsc")
        newObj.StudyId = rdr.GetInteger("Study_id")
        privateInterface.IsView = CType(rdr("IsView"), Boolean)
        Return newObj
    End Function

    Public Overrides Function [Select](ByVal tableId As Integer) As StudyTable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyTable, tableId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If rdr.Read Then
                Return PopulateStudyTable(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectByStudyId(ByVal studyId As Integer) As Collection(Of StudyTable)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllStudyTables, studyId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of StudyTable)(rdr, AddressOf PopulateStudyTable)
        End Using
    End Function

    Public Overrides Function SelectFromStudyTable(ByVal studyId As Integer, ByVal tableName As String, ByVal whereClause As String, ByVal rowsToReturn As Integer) As DataTable
        Dim sql As New SqlCommandBuilder
        sql.AddLine("SELECT TOP {0} *", rowsToReturn)
        sql.AddLine("FROM S{0}.{1} (NOLOCK)", studyId, tableName)
        sql.AddLine(whereClause)

        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql.ToString)
        cmd.CommandTimeout = 120

        Dim ds As DataSet = ExecuteDataSet(Db, cmd)
        If Not ds Is Nothing AndAlso ds.Tables.Count = 1 Then
            Return ds.Tables(0)
        Else
            Throw New Exception("Query did not return properly.")
        End If

    End Function

#End Region

#Region "Study Table Column Procs"
    Private Function PopulateStudyTableColumn(ByVal rdr As SafeDataReader) As StudyTableColumn
        Dim newObj As New StudyTableColumn
        Dim privateInterface As IStudyTableColumn = newObj

        newObj.BeginPopulate()

        privateInterface.StudyId = rdr.GetInteger("Study_id")
        privateInterface.Id = rdr.GetInteger("Field_id")
        privateInterface.Name = rdr.GetString("strField_nm")
        privateInterface.Description = rdr.GetString("strField_Dsc")
        Select Case rdr.GetString("strFieldDataType").ToUpper
            Case "S"
                privateInterface.DataType = StudyTableColumn.ColumnDataType.String
            Case "I"
                privateInterface.DataType = StudyTableColumn.ColumnDataType.Integer
            Case "D"
                privateInterface.DataType = StudyTableColumn.ColumnDataType.DateTime
        End Select
        privateInterface.Length = rdr.GetInteger("intFieldLength")
        privateInterface.TableId = rdr.GetInteger("Table_id")
        newObj.IsAvailableOnEReports = rdr.GetBoolean("bitAvailableFilter")
        newObj.DisplayName = rdr.GetString("strCustomFieldName")
        newObj.Formula = rdr.GetString("strFormula")
        privateInterface.IsCalculated = rdr.GetBoolean("bitCalculated")

        newObj.EndPopulate()
        Return newObj
    End Function

    Public Overrides Function SelectStudyTableColumns(ByVal studyId As Integer, ByVal tableId As Integer) As Collection(Of StudyTableColumn)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyTableColumns, studyId, tableId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateCollection(Of StudyTableColumn)(rdr, AddressOf PopulateStudyTableColumn)
        End Using
    End Function

    Public Overrides Function SelectStudyTableColumn(ByVal tableId As Integer, ByVal fieldId As Integer) As StudyTableColumn
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyTableColumn, tableId, fieldId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If rdr.Read Then
                Return PopulateStudyTableColumn(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Sub UpdateStudyTableColumn(ByVal column As StudyTableColumn)
        If column.IsCalculated Then
            'Calling the NonCalculated code ensures that general properties (like 
            'isAvailableOneReports) get updated
            UpdateNonCalculatedStudyTableColumn(column)
            'Calling the Calculated code ensures that calculated column specific properties get updated
            If column.FormulaHasChanged Then UpdateCalculatedStudyTableColumn(column)
        Else
            UpdateNonCalculatedStudyTableColumn(column)
        End If

    End Sub

    Private Sub UpdateCalculatedStudyTableColumn(ByVal column As StudyTableColumn)
        Dim warningMessages As String = Nothing
        InsertUpdateCalculateStudyTableColumn(column.StudyId, column.Name, column.Description, column.DisplayName, column.Formula, warningMessages, True)
    End Sub

    Private Sub UpdateNonCalculatedStudyTableColumn(ByVal column As StudyTableColumn)
        Dim displayNameNullable As New Object
        Dim formulaNullable As New Object

        If column.DisplayName Is Nothing OrElse column.DisplayName.Length = 0 Then
            displayNameNullable = DBNull.Value
        Else
            displayNameNullable = column.DisplayName
        End If

        If column.Formula Is Nothing OrElse column.Formula.Length = 0 Then
            formulaNullable = DBNull.Value
        Else
            formulaNullable = column.Formula
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateStudyTableColumn, column.StudyId, column.TableId, column.FieldId, displayNameNullable, column.IsAvailableOnEReports, column.IsCalculated, formulaNullable)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Function ValidateStudyTableColumnFormula(ByVal studyId As Integer, ByVal formula As String, ByRef message As String) As Boolean
        Try
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ValidateStudyTableColumnFormula, studyId, formula)
            ExecuteNonQuery(Db, cmd)
            message = "Syntax check was successful."
        Catch ex As Exception
            message = "Syntax check failed." & vbCrLf & ex.Message
            Return False
        End Try

        Return True
    End Function

    Public Overrides Function InsertCalculatedStudyTableColumn(ByVal studyId As Integer, ByVal name As String, ByVal description As String, ByVal displayName As String, ByVal formula As String, ByRef warningMessages As String) As StudyTableColumn
        Return InsertUpdateCalculateStudyTableColumn(studyId, name, description, displayName, formula, warningMessages, False)
    End Function

    Private Function InsertUpdateCalculateStudyTableColumn(ByVal studyId As Integer, ByVal name As String, ByVal description As String, ByVal displayName As String, ByVal formula As String, ByRef warningMessages As String, ByVal override As Boolean) As StudyTableColumn
        Dim displayNameNullable As New Object

        If displayName Is Nothing OrElse displayName.Length = 0 Then
            displayNameNullable = DBNull.Value
        Else
            displayNameNullable = displayName
        End If

        If formula Is Nothing OrElse formula.Length = 0 Then
            Throw New Exception("Formula is not specified for calculated column")
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertCalculatedStudyTableColumn, studyId, name, description, displayNameNullable, formula, override)
        Dim fieldId As Integer
        Dim tableId As Integer
        Dim newColumn As StudyTableColumn = Nothing

        Try
            Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
                If rdr.Read Then
                    fieldId = rdr.GetInteger("field_id")
                    tableId = rdr.GetInteger("table_id")
                    newColumn = SelectStudyTableColumn(tableId, fieldId)
                End If
                If rdr.NextResult Then
                    If rdr.Read Then
                        warningMessages &= rdr.GetString("message") & vbCrLf
                    End If
                End If
            End Using
        Catch ex As Exception
            Throw
        Finally
            'The big view needs to be readded regardless of the outcome
            CreateBigView(studyId)
        End Try
        Return newColumn
    End Function

    Private Sub CreateBigView(ByVal studyId As Integer)
        Dim study As String
        study = "s" + studyId.ToString.Trim
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CreateBigView, study, "Big_Table", "", "")
        ExecuteNonQuery(Db, cmd)
    End Sub
#End Region

#Region " Managed Content Procs "

    Private Function PopulateManagedContent(ByVal rdr As SafeDataReader) As ManagedContent
        Dim newObject As ManagedContent = ManagedContent.NewManagedContent
        Dim privateInterface As IManagedContent = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("ContentId")
        privateInterface.Category = rdr.GetString("Category")
        privateInterface.Key = rdr.GetString("Key")
        newObject.Teaser = rdr.GetString("Teaser")
        newObject.Content = rdr.GetString("Content")
        newObject.IsActive = rdr.GetBoolean("IsActive")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.DateModified = rdr.GetDate("DateModified")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectManagedContentByKey(ByVal category As String, ByVal key As String) As ManagedContent
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.SelectManagedContent, category, key, True, "Alpha")
        Using rdr As New SafeDataReader(ExecuteReader(RscmDb, cmd))
            If rdr.Read Then
                Return PopulateManagedContent(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectManagedContentByCategory(ByVal category As String, ByVal includeInactive As Boolean) As ManagedContentCollection
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.SelectManagedContent, category, DBNull.Value, includeInactive, DBNull.Value)
        Using rdr As New SafeDataReader(ExecuteReader(RscmDb, cmd))
            Return PopulateList(Of ManagedContentCollection, ManagedContent)(rdr, AddressOf PopulateManagedContent)
        End Using
    End Function

    Public Overrides Function SelectAllManagedContent(ByVal includeInactive As Boolean) As ManagedContentCollection
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.SelectManagedContent, DBNull.Value, DBNull.Value, includeInactive, DBNull.Value)
        Using rdr As New SafeDataReader(ExecuteReader(RscmDb, cmd))
            Return PopulateList(Of ManagedContentCollection, ManagedContent)(rdr, AddressOf PopulateManagedContent)
        End Using
    End Function

    Public Overrides Function InsertManagedContent(ByVal instance As ManagedContent) As Integer
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.InsertManagedContent, instance.Category, instance.Key, instance.Content, instance.Teaser)
        Return ExecuteInteger(RscmDb, cmd)
    End Function

    Public Overrides Sub UpdateManagedContent(ByVal instance As ManagedContent)
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.UpdateManagedContent, instance.Category, instance.Key, instance.Content, instance.Teaser, instance.IsActive)
        ExecuteNonQuery(RscmDb, cmd)
    End Sub

    Public Overrides Sub DeleteManagedContent(ByVal category As String, ByVal key As String)
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.DeleteManagedContent, category, key)
        ExecuteNonQuery(RscmDb, cmd)
    End Sub

    Public Overrides Function SelectManagedContentCategories() As List(Of String)
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.SelectManagedContentCategories)
        Dim categories As New List(Of String)
        Using rdr As New SafeDataReader(ExecuteReader(RscmDb, cmd))
            While rdr.Read
                categories.Add(rdr.GetString("Category"))
            End While
        End Using

        Return categories
    End Function

    Public Overrides Function SelectManagedContentKeys(ByVal category As String) As List(Of String)
        Dim cmd As DbCommand = RscmDb.GetStoredProcCommand(SP.SelectManagedContentKeys, category)
        Dim keys As New List(Of String)
        Using rdr As New SafeDataReader(ExecuteReader(RscmDb, cmd))
            While rdr.Read
                keys.Add(rdr.GetString("Key"))
            End While
        End Using

        Return keys

    End Function

#End Region

#Region " ThemeQuestion Procs "
    Private Function PopulateThemeQuestion(ByVal rdr As SafeDataReader) As ThemeQuestion
        Dim newObject As ThemeQuestion = ThemeQuestion.NewThemeQuestion
        newObject.BeginPopulate()
        newObject.ServiceTypeId = rdr.GetInteger("ServiceTypeId")
        newObject.ServiceTypeName = rdr.GetString("ServiceTypeName")
        newObject.ViewId = rdr.GetInteger("ViewId")
        newObject.ViewName = rdr.GetString("ViewName")
        newObject.ThemeId = rdr.GetInteger("ThemeId")
        newObject.ThemeName = rdr.GetString("ThemeName")
        newObject.QuestionId = rdr.GetInteger("QstnCore")
        newObject.QuestionText = rdr.GetString("strFullQuestion")
        newObject.IsPending = rdr.GetBoolean("IsPending")

        If newObject.IsPending Then
            newObject.Status = rdr.GetEnum(Of ThemeQuestionStatus)("QuestionRollupStatusId")
            newObject.DateSubmitted = rdr.GetDate("DateSubmitted")
            newObject.UserName = rdr.GetString("UserName")
        Else
            newObject.Status = ThemeQuestionStatus.Live
            newObject.DateSubmitted = Nothing
            newObject.UserName = String.Empty
        End If

        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectThemeQuestionsByQuestionId(ByVal questionId As Integer) As ThemeQuestionCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectThemeQuestionsByQuestionId, questionId)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of ThemeQuestionCollection, ThemeQuestion)(rdr, AddressOf PopulateThemeQuestion)
        End Using

    End Function

    Public Overrides Function SelectThemeQuestionsByThemeId(ByVal themeId As Integer) As ThemeQuestionCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectThemeQuestionsByThemeId, themeId)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of ThemeQuestionCollection, ThemeQuestion)(rdr, AddressOf PopulateThemeQuestion)
        End Using
    End Function

    Public Overrides Sub InsertThemeQuestion(ByVal themeId As Integer, ByVal questionId As Integer, ByVal userName As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertThemeQuestion, themeId, questionId, userName)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteThemeQuestion(ByVal themeId As Integer, ByVal questionId As Integer, ByVal userName As String)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteThemeQuestion, themeId, questionId, userName)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Improvement Model Methods "
    Private Function PopulateServiceType(ByVal rdr As SafeDataReader) As ServiceType
        Dim newObject As ServiceType = ServiceType.NewServiceType
        Dim privateInterface As IServiceType = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("ServiceTypeId")
        newObject.Name = rdr.GetString("ServiceTypeName")
        newObject.PrivilegeId = rdr.GetInteger("Privilege_id")
        newObject.EndPopulate()
        Return newObject
    End Function
    Private Function PopulateView(ByVal rdr As SafeDataReader) As View
        Dim newObject As View = View.NewView
        Dim privateInterface As IView = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("ViewId")
        privateInterface.ServiceTypeId = rdr.GetInteger("ServiceTypeId")
        newObject.Name = rdr.GetString("ViewName")
        newObject.IsHcahps = rdr.GetBoolean("IsHcahps")
        newObject.EndPopulate()
        Return newObject
    End Function
    Private Function PopulateTheme(ByVal rdr As SafeDataReader) As Theme
        Dim newObject As Theme = Theme.NewTheme
        Dim privateInterface As ITheme = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("ThemeId")
        privateInterface.ViewId = rdr.GetInteger("ViewId")
        newObject.Name = rdr.GetString("ThemeName")
        newObject.EndPopulate()
        Return newObject
    End Function
    Public Overrides Function SelectAllServiceTypes() As ServiceTypeCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllServiceTypes)

        Dim returnList As New ServiceTypeCollection
        Dim serviceTypeList As New List(Of ServiceType)
        Dim viewList As New List(Of View)
        Dim themeList As New List(Of Theme)

        Dim serviceTypeLookup As New Dictionary(Of Integer, ServiceType)
        Dim viewLookup As New Dictionary(Of Integer, View)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            While rdr.Read
                serviceTypeList.Add(PopulateServiceType(rdr))
            End While

            If rdr.NextResult Then
                While rdr.Read
                    viewList.Add(PopulateView(rdr))
                End While

                If rdr.NextResult Then
                    While rdr.Read
                        themeList.Add(PopulateTheme(rdr))
                    End While
                End If
            End If
        End Using

        For Each st As ServiceType In serviceTypeList
            serviceTypeLookup.Add(st.Id, st)
            returnList.Add(st)
        Next

        For Each v As View In viewList
            viewLookup.Add(v.Id, v)
            serviceTypeLookup(v.ServiceTypeId).Views.Add(v)
        Next

        For Each t As Theme In themeList
            viewLookup(t.ViewId).Themes.Add(t)
        Next

        Return returnList
    End Function

    Public Overrides Function InsertServiceType(ByVal obj As ServiceType) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertServiceType, obj.Name, obj.PrivilegeId)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateServiceType(ByVal obj As ServiceType)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateServiceType, obj.Id, obj.Name, obj.PrivilegeId)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteServiceType(ByVal serviceTypeId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteServiceType, serviceTypeId)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Function InsertTheme(ByVal obj As Theme) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertTheme, obj.ViewId, obj.Name)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateTheme(ByVal obj As Theme)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateTheme, obj.Id, obj.Name)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteTheme(ByVal themeId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTheme, themeId)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Function InsertView(ByVal obj As View) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertView, obj.ServiceTypeId, obj.Name, obj.IsHcahps)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateView(ByVal obj As View)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateView, obj.Id, obj.Name, obj.IsHcahps)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteView(ByVal viewId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteView, viewId)
        ExecuteNonQuery(Db, cmd)
    End Sub


#End Region

#Region " Question Content Methods "
    Public Overrides Function SelectQuestionContentByQuestionId(ByVal questionId As Integer) As QuestionContent
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionContent, questionId)
        Dim content As New QuestionContent
        content.BeginPopulate()
        Dim privateinterface As IQuestionContent = content

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            privateinterface.QuestionId = questionId

            If rdr.Read Then
                content.QuestionText = rdr.GetString("strFullQuestion")
            Else
                Return Nothing
            End If

            If Not rdr.NextResult Then
                Throw New SqlCommandException(cmd, New ToolKitDataAccessException("Invalid Question Content Results"))
            End If

            While rdr.Read
                content.ContentSetGuid = rdr.GetGuid("ContentSetGuid")
                Dim html As String = rdr.GetString("txtContent")
                Dim isNew As Boolean = CType(rdr.GetValue("UpdatedContent"), Boolean)

                Select Case rdr.GetEnum(Of QuestionContentType)("ContentType_id")
                    Case QuestionContentType.QuestionImportance
                        content.ImportanceHtml = html
                        content.ImportanceIsNew = isNew
                    Case QuestionContentType.QuickCheck
                        content.QuickCheckHtml = html
                        content.QuickCheckIsNew = False
                    Case QuestionContentType.Recommendations
                        content.RecommendationsHtml = html
                        content.RecommendationsIsNew = isNew
                    Case QuestionContentType.Resources
                        content.ResourcesHtml = html
                        content.ResourcesIsNew = isNew
                End Select
            End While
        End Using

        content.EndPopulate()
        Return content

    End Function

    ''' <summary></summary>
    ''' <param name="contentSetGuid"></param>
    ''' <param name="contentType"></param>
    ''' <param name="html"></param>
    ''' <param name="isNew"></param>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>Steve Kennedy - 12-21-2007</term>
    ''' <description>Resized cmd parameter to length of html parameter before executing
    ''' cmd.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Overrides Sub UpdateQuestionContent(ByVal contentSetGuid As System.Guid, ByVal contentType As QuestionContentType, ByVal html As String, ByVal isNew As Boolean)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateQuestionContent, contentSetGuid, contentType, html, isNew)
        cmd.Parameters(3).Size = html.Length
        ExecuteNonQuery(Db, cmd)
    End Sub


    ''' <summary></summary>
    ''' <param name="questionId"></param>
    ''' <param name="contentSetGuid"></param>
    ''' <param name="contentType"></param>
    ''' <param name="html"></param>
    ''' <param name="isNew"></param>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>12-21-2007 - Steve Kennedy</term>
    ''' <description>Resized cmd parameter to length of html parameter before executing
    ''' cmd.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Overrides Sub InsertQuestionContent(ByVal questionId As Integer, ByVal contentSetGuid As System.Guid, ByVal contentType As QuestionContentType, ByVal html As String, ByVal isNew As Boolean)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertQuestionContent, questionId, contentSetGuid, contentType, html, isNew)
        cmd.Parameters(4).Size = html.Length
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Function SelectRelatedQuestions(ByVal questionId As Integer) As System.Data.DataTable
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectRelatedQuestions, questionId)
        Return ExecuteDataSet(Db, cmd).Tables(0)
    End Function

    Public Overrides Sub RelateQuestionContent(ByVal sourceQuestionId As Integer, ByVal relatedQuestionId As Integer, ByVal useRelatedQuestionContent As Boolean)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.RelateQuestionContent, sourceQuestionId, relatedQuestionId, useRelatedQuestionContent)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub UnrelateQuestionContent(ByVal questionId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UnrelateQuestionContent, questionId)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Member Resources methods "

    Private Function PopulateMemberResource(ByVal rdr As SafeDataReader) As MemberResource
        Dim newObject As MemberResource = MemberResource.NewMemberResource
        Dim privateInterface As IMemberResource = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Id")
        newObject.Title = rdr.GetString("Title")
        newObject.Author = rdr.GetString("Author")
        newObject.FilePath = rdr.GetString("FilePath")
        newObject.OriginalPath = rdr.GetString("OriginalPath")
        newObject.AbstractHtml = rdr.GetString("AbstractHtml")
        newObject.AbstractPlainText = rdr.GetString("AbstractPlainText")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.DateModified = rdr.GetDate("DateModified")
        newObject.ResourceTypeId = rdr.GetInteger("ResourceTypeId")
        newObject.EndPopulate()
        Return newObject
    End Function

    Private Function PopulateMemberResourceQuestion(ByVal rdr As SafeDataReader) As MemberResourceQuestion
        Dim newObject As MemberResourceQuestion = MemberResourceQuestion.NewMemberResourceQuestion
        Dim privateInterface As IMemberResourceQuestion = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Id")
        newObject.DocumentId = rdr.GetInteger("DocumentId")
        newObject.ServiceTypeId = rdr.GetInteger("ServiceTypeId")
        newObject.ViewId = rdr.GetInteger("ViewId")
        newObject.ThemeId = rdr.GetInteger("ThemeId")
        newObject.QuestionId = rdr.GetInteger("QuestionId")
        newObject.EndPopulate()
        Return newObject
    End Function

    Private Function PopulateMemberResourceOtherType(ByVal rdr As SafeDataReader) As MemberResourceOtherType
        Dim newObject As MemberResourceOtherType = MemberResourceOtherType.NewMemberResourceOtherType
        Dim privateInterface As IMemberResourceOtherType = newObject
        newObject.BeginPopulate()
        privateInterface.DocumentId = rdr.GetInteger("DocumentId")
        privateInterface.OtherTypeId = rdr.GetInteger("OtherTypeId")
        newObject.Description = rdr.GetString("Description")
        newObject.EndPopulate()
        Return newObject
    End Function

    ''' <summary>
    ''' Populates a <see cref="MemberResourceGroup">MemberResourceGroup</see> object with values from the database.
    ''' </summary>
    ''' <param name="rdr"><see cref="SafeDataReader">SafeDataReader</see></param>
    ''' <returns><see cref="MemberResourceGroup">MemberResourceGroup</see></returns>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/11/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Private Function PopulateMemberResourceGroup(ByVal rdr As SafeDataReader) As MemberResourceGroup
        Dim newObject As MemberResourceGroup = MemberResourceGroup.NewMemberResourceGroup
        Dim privateInterface As IMemberResourceGroup = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Id")
        newObject.DocumentId = rdr.GetInteger("DocumentId")
        newObject.GroupId = rdr.GetInteger("GroupId")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectMemberResource(ByVal id As Integer) As MemberResource
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberResource, id)
        Return SelectMemberResource(cmd)
    End Function

    Public Overrides Function SelectMemberResourceByTitle(ByVal title As String) As MemberResource
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberResourceByTitle, title)
        Return SelectMemberResource(cmd)
    End Function

    Private Overloads Function SelectMemberResource(ByVal cmd As DbCommand) As MemberResource
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then Return Nothing

            Dim resource As MemberResource = PopulateMemberResource(rdr)

            Dim questions As Collection(Of MemberResourceQuestion) = GetQuestions(rdr)
            Dim tags As Collection(Of MemberResourceOtherType) = GetTags(rdr)
            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
            Dim groups As Collection(Of MemberResourceGroup) = GetGroups(rdr)

            AssociateQuestions(resource, questions)
            AssociateOtherTypes(resource, tags)
            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
            AssociateGroups(resource, groups)

            Return resource
        End Using
    End Function

    Public Overrides Function SelectAllMemberResource() As MemberResourceCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberResource)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Dim resources As MemberResourceCollection = PopulateList(Of MemberResourceCollection, MemberResource)(rdr, AddressOf PopulateMemberResource)

            Dim questions As Collection(Of MemberResourceQuestion) = GetQuestions(rdr)
            Dim tags As Collection(Of MemberResourceOtherType) = GetTags(rdr)
            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
            Dim groups As Collection(Of MemberResourceGroup) = GetGroups(rdr)

            AssociateQuestions(resources, questions)
            AssociateOtherTypes(resources, tags)
            '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II
            AssociateGroups(resources, groups)

            Return resources
        End Using
    End Function

    Public Overrides Function SelectRecentMemberResource(ByVal serviceTypeId As Integer, ByVal viewId As Integer, ByVal themeId As Integer, ByVal questionId As Integer, ByVal groupId As Integer) As MemberResourceCollection
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
        '                                   Pass groupId parameter into stored procedure.
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectRecentMemberResource, serviceTypeId, viewId, themeId, questionId, groupId)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of MemberResourceCollection, MemberResource)(rdr, AddressOf PopulateMemberResource)
        End Using
    End Function

    Public Overrides Function SearchTextMemberResource(ByVal resultSet As Guid, ByVal text As String, ByVal serviceTypeId As Integer, ByVal groupId As Integer) As MemberResourceCollection
        '   Rick Christenham (09/11/2007):  NRC eToolkit Enhancement II:
        '                                   Pass groupId parameter into stored procedure.
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SearchTextMemberResource, resultSet, text, serviceTypeId, groupId)
        Try
            Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
                Dim resources As MemberResourceCollection = PopulateList(Of MemberResourceCollection, MemberResource)(rdr, AddressOf PopulateMemberResource)

                Dim questions As Collection(Of MemberResourceQuestion) = GetQuestions(rdr)
                Dim tags As Collection(Of MemberResourceOtherType) = GetTags(rdr)

                AssociateQuestions(resources, questions)
                AssociateOtherTypes(resources, tags)
                Return resources
            End Using
        Catch ex As SqlCommandException When TypeOf ex.InnerException Is SqlException AndAlso DirectCast(ex.InnerException, SqlException).Number = SqlQueryContainedIgnoredWords
            ' TODO: Decide if the exception should be logged
            Return New MemberResourceCollection()
        End Try
    End Function

    Private Function GetQuestions(ByVal rdr As SafeDataReader) As Collection(Of MemberResourceQuestion)
        Dim questions As Collection(Of MemberResourceQuestion)
        If rdr.NextResult Then
            questions = PopulateCollection(Of MemberResourceQuestion)(rdr, AddressOf PopulateMemberResourceQuestion)
        Else
            questions = New MemberResourceQuestionCollection()
        End If
        Return questions
    End Function

    Private Function GetTags(ByVal rdr As SafeDataReader) As Collection(Of MemberResourceOtherType)
        Dim tags As Collection(Of MemberResourceOtherType)
        If rdr.NextResult Then
            tags = PopulateCollection(Of MemberResourceOtherType)(rdr, AddressOf PopulateMemberResourceOtherType)
        Else
            tags = New MemberResourceOtherTypeCollection()
        End If
        Return tags
    End Function

    ''' <summary>
    ''' Returns a <see cref="Collection">collection</see> of <see cref="MemberResourceGroup">MemberResourceGroup</see> objects.
    ''' </summary>
    ''' <param name="rdr"><see cref="SafeDataReader">SafeDataReader</see></param>
    ''' <returns><see cref="Collection">collection</see> of <see cref="MemberResourceGroup">MemberResourceGroup</see> objects</returns>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/11/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Private Function GetGroups(ByVal rdr As SafeDataReader) As Collection(Of MemberResourceGroup)
        Dim groups As Collection(Of MemberResourceGroup)
        If rdr.NextResult Then
            groups = PopulateCollection(Of MemberResourceGroup)(rdr, AddressOf PopulateMemberResourceGroup)
        Else
            groups = New MemberResourceGroupCollection()
        End If
        Return groups
    End Function

    Private Shared Sub AssociateQuestions(ByVal resource As MemberResource, ByVal questions As Collection(Of MemberResourceQuestion))
        For Each item As MemberResourceQuestion In questions
            resource.Questions.Add(item)
        Next
    End Sub

    Private Shared Sub AssociateQuestions(ByVal resources As MemberResourceCollection, ByVal questions As Collection(Of MemberResourceQuestion))
        For Each item As MemberResourceQuestion In questions
            resources.Find(item.DocumentId).Questions.Add(item)
        Next
    End Sub

    Private Shared Sub AssociateOtherTypes(ByVal resource As MemberResource, ByVal tags As Collection(Of MemberResourceOtherType))
        For Each item As MemberResourceOtherType In tags
            resource.OtherTypes.Add(item)
        Next
    End Sub

    Private Shared Sub AssociateOtherTypes(ByVal resources As MemberResourceCollection, ByVal tags As Collection(Of MemberResourceOtherType))
        For Each item As MemberResourceOtherType In tags
            resources.Find(item.DocumentId).OtherTypes.Add(item)
        Next
    End Sub

    ''' <summary>
    ''' Associates a <see cref="Collection">collection</see> of <see cref="MemberResourceGroup">MemberResourceGroup</see> objects 
    ''' with a specified <see cref="MemberResource">MemberResource</see> object.
    ''' </summary>
    ''' <param name="resource"><see cref="MemberResource">MemberResource</see> object</param>
    ''' <param name="groups"><see cref="Collection">collection</see> of <see cref="MemberResourceGroup">MemberResourceGroup</see> objects</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/11/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Private Shared Sub AssociateGroups(ByVal resource As MemberResource, ByVal groups As Collection(Of MemberResourceGroup))
        For Each item As MemberResourceGroup In groups
            resource.Groups.Add(item)
        Next
    End Sub

    ''' <summary>
    ''' Associates a <see cref="Collection">collection</see> of <see cref="MemberResourceGroup">MemberResourceGroup</see> objects 
    ''' with a specified <see cref="MemberResource">MemberResource</see> object.
    ''' </summary>
    ''' <param name="resources"><see cref="MemberResource">MemberResource</see> object</param>
    ''' <param name="groups"><see cref="Collection">collection</see> of <see cref="MemberResourceGroup">MemberResourceGroup</see> objects</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/11/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Private Shared Sub AssociateGroups(ByVal resources As MemberResourceCollection, ByVal groups As Collection(Of MemberResourceGroup))
        For Each item As MemberResourceGroup In groups
            resources.Find(item.DocumentId).Groups.Add(item)
        Next
    End Sub

    Public Overrides Function InsertMemberResource(ByVal obj As MemberResource) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMemberResource, obj.Title, obj.Author, obj.FilePath, obj.OriginalPath, obj.AbstractHtml, obj.AbstractPlainText, obj.ResourceTypeId)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateMemberResource(ByVal obj As MemberResource)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMemberResource, obj.Id, obj.Title, obj.Author, obj.FilePath, obj.OriginalPath, obj.AbstractHtml, obj.AbstractPlainText, obj.ResourceTypeId)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteMemberResource(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMemberResource, id)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Member Resource Question methods "

    Public Overrides Function InsertMemberResourceQuestion(ByVal obj As MemberResourceQuestion) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMemberResourceQuestion, obj.DocumentId, obj.ServiceTypeId, obj.ViewId, obj.ThemeId, obj.QuestionId)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateMemberResourceQuestion(ByVal obj As MemberResourceQuestion)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMemberResourceQuestion, obj.Id, obj.DocumentId, obj.ServiceTypeId, obj.ViewId, obj.ThemeId, obj.QuestionId)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteMemberResourceQuestion(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMemberResourceQuestion, id)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Member Resource Other Type methods "

    Public Overrides Function InsertMemberResourceOtherType(ByVal obj As MemberResourceOtherType) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMemberResourceOtherType, obj.DocumentId, obj.OtherTypeId)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub DeleteMemberResourceOtherType(ByVal documentId As Integer, ByVal otherTypeId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMemberResourceOtherType, documentId, otherTypeId)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Member Resource Group methods "

    ''' <summary>
    ''' Inserts a new <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
    ''' </summary>
    ''' <param name="obj"><see cref="MemberResourceGroup">MemberResourceGroup</see> object to save</param>
    ''' <returns><see cref="Integer">Integer</see> value representing the primary key</returns>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Public Overrides Function InsertMemberResourceGroup(ByVal obj As MemberResourceGroup) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMemberResourceGroup, obj.DocumentId, obj.GroupId)
        Return ExecuteInteger(Db, cmd)
    End Function
    ''' <summary>
    ''' Updates a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
    ''' </summary>
    ''' <param name="obj"><see cref="MemberResourceGroup">MemberResourceGroup</see> to save</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Public Overrides Sub UpdateMemberResourceGroup(ByVal obj As MemberResourceGroup)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMemberResourceGroup, obj.Id, obj.DocumentId, obj.GroupId)
        ExecuteNonQuery(Db, cmd)
    End Sub
    ''' <summary>
    ''' Deletes a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
    ''' </summary>
    ''' <param name="id"><see cref="Integer">Integer</see> value representing the primary key of the record to delete</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Public Overrides Sub DeleteMemberResourceGroup(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMemberResourceGroup, id)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Index Search Results methods "

    Public Overrides Function InsertIndexSearchResult(ByVal instance As IndexSearchResult) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertIndexSearchResult, instance.Title, instance.ResultSet, instance.Rank)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Function SearchIndexSearchResult(ByVal resultSet As Guid, ByVal text As String) As IndexSearchResultCollection
        ' Format Index Server query.
        Dim query As String = String.Format(SP.SearchIndexSearchResult, resultSet, text.Replace("'", "''"))
        Dim cmd As DbCommand = IndexDb.GetSqlStringCommand(query)
        Dim helper As New IndexSearchResultHelper(resultSet)
        Try
            Using rdr As New SafeDataReader(ExecuteReader(IndexDb, cmd))
                Return PopulateList(Of IndexSearchResultCollection, IndexSearchResult)(rdr, AddressOf helper.PopulateIndexSearchResult)
            End Using
        Catch ex As SqlCommandException When TypeOf ex.InnerException Is OleDbException AndAlso DirectCast(ex.InnerException, OleDbException).ErrorCode = OleDbQueryContainedIgnoredWords
            ' TODO: Decide if the exception should be logged
            Return New IndexSearchResultCollection()
        End Try
    End Function

    Public Overrides Sub ClearIndexSearchResult(ByVal resultSet As Guid)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ClearIndexSearchResult, resultSet)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Question Search Results methods"

    Private Function PopulateQuestionSearchWork(ByVal rdr As SafeDataReader) As QuestionSearchWork
        Dim newObject As QuestionSearchWork = QuestionSearchWork.NewQuestionSearchWork
        newObject.BeginPopulate()
        newObject.QstnCore = rdr.GetInteger("QstnCore")
        newObject.QuestionText = rdr.GetString("strFullQuestion")
        newObject.Rank = rdr.GetInteger("Rank")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SearchQuestionSearchText(ByVal resultSet As Guid, ByVal text As String) As QuestionSearchWorkCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SearchQuestionSearchText, resultSet, text)
        Try
            Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
                Return PopulateList(Of QuestionSearchWorkCollection, QuestionSearchWork)(rdr, AddressOf PopulateQuestionSearchWork)
            End Using
        Catch ex As SqlCommandException When TypeOf ex.InnerException Is SqlException AndAlso DirectCast(ex.InnerException, SqlException).Number = SqlQueryContainedIgnoredWords
            ' TODO: Decide if the exception should be logged
            Return New QuestionSearchWorkCollection()
        Catch ex As SqlException When ex.Number = SqlQueryContainedIgnoredWords
            ' TODO: Decide if the exception should be logged
            Return New QuestionSearchWorkCollection()
        End Try
    End Function

#End Region

#Region " Resource Type methods "

    Private Function PopulateResourceType(ByVal rdr As SafeDataReader) As ResourceType
        Dim newObject As ResourceType = ResourceType.NewResourceType
        Dim privateInterface As IResourceType = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Id")
        newObject.Description = rdr.GetString("Description")
        newObject.AlwaysShow = rdr.GetBoolean("AlwaysShow")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectResourceType(ByVal id As Integer) As ResourceType
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResourceType, id)
        Return SelectResourceType(cmd)
    End Function

    Public Overrides Function SelectResourceTypeByDescription(ByVal description As String) As ResourceType
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResourceTypeByDescription, description)
        Return SelectResourceType(cmd)
    End Function

    Private Overloads Function SelectResourceType(ByVal cmd As DbCommand) As ResourceType
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateResourceType(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllResourceType() As ResourceTypeCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResourceType)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of ResourceTypeCollection, ResourceType)(rdr, AddressOf PopulateResourceType)
        End Using
    End Function

    Public Overrides Function InsertResourceType(ByVal obj As ResourceType) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertResourceType, obj.Description, obj.AlwaysShow)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateResourceType(ByVal obj As ResourceType)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateResourceType, obj.Id, obj.Description, obj.AlwaysShow)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteResourceType(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteResourceType, id)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Resource Other Type methods "

    Private Function PopulateResourceOtherType(ByVal rdr As SafeDataReader) As ResourceOtherType
        Dim newObject As ResourceOtherType = ResourceOtherType.NewResourceOtherType
        Dim privateInterface As IResourceOtherType = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Id")
        newObject.Description = rdr.GetString("Description")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectResourceOtherType(ByVal id As Integer) As ResourceOtherType
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResourceOtherType, id)
        Return SelectResourceOtherType(cmd)
    End Function

    Public Overrides Function SelectResourceOtherTypeByDescription(ByVal description As String) As ResourceOtherType
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResourceOtherTypeByDescription, description)
        Return SelectResourceOtherType(cmd)
    End Function

    Private Overloads Function SelectResourceOtherType(ByVal cmd As DbCommand) As ResourceOtherType
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateResourceOtherType(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllResourceOtherType() As ResourceOtherTypeCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResourceOtherType)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of ResourceOtherTypeCollection, ResourceOtherType)(rdr, AddressOf PopulateResourceOtherType)
        End Using
    End Function

    Public Overrides Function InsertResourceOtherType(ByVal obj As ResourceOtherType) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertResourceOtherType, obj.Description)
        Return ExecuteInteger(Db, cmd)
    End Function

    Public Overrides Sub UpdateResourceOtherType(ByVal obj As ResourceOtherType)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateResourceOtherType, obj.Id, obj.Description)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteResourceOtherType(ByVal id As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteResourceOtherType, id)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Notify Method methods "

    Private Function PopulateNotifyMethod(ByVal rdr As SafeDataReader) As NotifyMethod
        Dim newObject As NotifyMethod = NotifyMethod.NewNotifyMethod
        Dim privateInterface As INotifyMethod = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetByte("NotifyMethod_ID")
        newObject.Label = rdr.GetString("NotifyMethodLabel")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectNotifyMethod(ByVal id As Integer) As NotifyMethod
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectNotifyMethod, id)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateNotifyMethod(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllNotifyMethod() As NotifyMethodCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectNotifyMethod)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of NotifyMethodCollection, NotifyMethod)(rdr, AddressOf PopulateNotifyMethod)
        End Using
    End Function

#End Region

#Region " Analysis Measure methods "

    Private Function PopulateAnalysisMeasure(ByVal rdr As SafeDataReader) As AnalysisMeasure
        Dim newObject As AnalysisMeasure = AnalysisMeasure.NewAnalysisMeasure
        Dim privateInterface As IAnalysisMeasure = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetByte("Analysis_ID")
        newObject.Name = rdr.GetString("strAnalysis_NM")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectAnalysisMeasure(ByVal id As Integer) As AnalysisMeasure
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAnalysisMeasure, id)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateAnalysisMeasure(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllAnalysisMeasure() As AnalysisMeasureCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAnalysisMeasure)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of AnalysisMeasureCollection, AnalysisMeasure)(rdr, AddressOf PopulateAnalysisMeasure)
        End Using
    End Function

#End Region

#Region " Member Report Preference methods "

    Private Function PopulateMemberReportPreference(ByVal rdr As SafeDataReader) As MemberReportPreference
        Dim newObject As MemberReportPreference = MemberReportPreference.NewMemberReportPreference
        Dim privateInterface As IMemberReportPreference = newObject
        newObject.BeginPopulate()
        privateInterface.MemberId = rdr.GetInteger("Member_ID")
        newObject.ContentNotifyMethod = rdr.GetEnum(Of EmailNotifyMethod)("ContentNotifyMethod_ID")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.DateUpdated = rdr.GetDate("DateUpdated")
        newObject.EndPopulate()
        Return newObject
    End Function

    Public Overrides Function SelectMemberReportPreference(ByVal memberId As Integer) As MemberReportPreference
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberReportPreference, memberId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMemberReportPreference(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllMemberReportPreference() As MemberReportPreferenceCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberReportPreference)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of MemberReportPreferenceCollection, MemberReportPreference)(rdr, AddressOf PopulateMemberReportPreference)
        End Using
    End Function

    Public Overrides Sub InsertMemberReportPreference(ByVal obj As MemberReportPreference)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMemberReportPreference, obj.MemberId, obj.ContentNotifyMethod)
        ExecuteInteger(Db, cmd)
    End Sub

    Public Overrides Sub UpdateMemberReportPreference(ByVal obj As MemberReportPreference)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMemberReportPreference, obj.MemberId, obj.ContentNotifyMethod)
        ExecuteNonQuery(Db, cmd)
    End Sub

    Public Overrides Sub DeleteMemberReportPreference(ByVal memberId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMemberReportPreference, memberId)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Member Report Preference methods "

    Private Function PopulateMemberGroupReportPreference(ByVal rdr As SafeDataReader) As MemberGroupReportPreference
        Dim newObject As MemberGroupReportPreference = MemberGroupReportPreference.NewMemberGroupReportPreference
        Dim privateInterface As IMemberGroupReportPreference = newObject
        newObject.BeginPopulate()
        privateInterface.MemberId = rdr.GetInteger("Member_ID")
        privateInterface.GroupId = rdr.GetInteger("Group_ID")
        newObject.QualityProgramId = rdr.GetInteger("QualityProgram_ID")
        privateInterface.QualityProgramName = rdr.GetString("strQualityProgram_nm")
        newObject.CompDatasetId = rdr.GetInteger("CompDataset_ID")
        privateInterface.CompDatasetName = rdr.GetString("strCompDataset_lbl")
        newObject.AnalysisId = rdr.GetEnum(Of Legacy.ToolkitServer.AnalysisVariable)("Analysis_ID")
        Dim today As DateTime = DateTime.Today
        newObject.ReportStartDate = GetDate(rdr, "ReportDateBegin", New DateTime(today.Year - 1, today.Month, 1))
        newObject.ReportEndDate = GetDate(rdr, "ReportDateEnd", today.Date)
        newObject.ServiceTypeId = rdr.GetInteger("ServiceTypeId")
        newObject.SelectedUnit = rdr.GetString("Unit")
        newObject.SelectedViewId = rdr.GetInteger("ViewId")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.DateUpdated = rdr.GetDate("DateUpdated")
        newObject.EndPopulate()
        Return newObject
    End Function

    Private Shared Function GetDate(ByVal rdr As SafeDataReader, ByVal name As String, ByVal [default] As DateTime) As DateTime
        Dim value As DateTime = rdr.GetDate(name).Date
        If value = DateTime.MinValue Then Return [default]
        Return value
    End Function

    Public Overrides Function SelectMemberGroupReportPreference(ByVal memberId As Integer, ByVal groupId As Integer) As MemberGroupReportPreference
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberGroupReportPreference, memberId, groupId)

        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateMemberGroupReportPreference(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllMemberGroupReportPreference() As MemberGroupReportPreferenceCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberGroupReportPreference)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            Return PopulateList(Of MemberGroupReportPreferenceCollection, MemberGroupReportPreference)(rdr, AddressOf PopulateMemberGroupReportPreference)
        End Using
    End Function

    Public Overrides Sub InsertMemberGroupReportPreference(ByVal obj As MemberGroupReportPreference)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMemberGroupReportPreference, obj.MemberId, obj.GroupId, obj.QualityProgramId, obj.CompDatasetId, obj.AnalysisId, obj.ReportStartDate, obj.ReportEndDate, obj.ServiceTypeId, obj.SelectedUnit, obj.SelectedViewId)
        ExecuteInteger(Db, cmd)
    End Sub

    Public Overrides Sub UpdateMemberGroupReportPreference(ByVal obj As MemberGroupReportPreference)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMemberGroupReportPreference, obj.MemberId, obj.GroupId, obj.QualityProgramId, obj.CompDatasetId, obj.AnalysisId, obj.ReportStartDate, obj.ReportEndDate, obj.ServiceTypeId, obj.SelectedUnit, obj.SelectedViewId)
        ExecuteNonQuery(Db, cmd)
        RefreshMemberGroupReportPreference(obj)
    End Sub

    Private Sub RefreshMemberGroupReportPreference(ByVal obj As MemberGroupReportPreference)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMemberGroupReportPreference, obj.MemberId, obj.GroupId)
        Using rdr As New SafeDataReader(ExecuteReader(Db, cmd))
            If Not rdr.Read Then Return
            Dim privateInterface As IMemberGroupReportPreference = obj
            privateInterface.QualityProgramName = rdr.GetString("strQualityProgram_nm")
            privateInterface.CompDatasetName = rdr.GetString("strCompDataset_lbl")
        End Using
    End Sub

    Public Overrides Sub DeleteMemberGroupReportPreference(ByVal memberId As Integer, ByVal groupId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMemberGroupReportPreference, memberId, groupId)
        ExecuteNonQuery(Db, cmd)
    End Sub

#End Region

#Region " Member Notify Method methods "

    Private Function PopulateMemberNotifyMethod(ByVal rdr As SafeDataReader) As MemberContentNotifyMethod
        Dim newObject As MemberContentNotifyMethod = MemberContentNotifyMethod.NewMemberNotifyMethod
        Dim privateInterface As IMemberContentNotifyMethod = newObject
        newObject.BeginPopulate()
        privateInterface.MemberId = rdr.GetInteger("Member_ID")
        newObject.ContentNotifyMethod = rdr.GetEnum(Of EmailNotifyMethod)("ContentNotifyMethod_ID")
        newObject.EndPopulate()
        Return newObject
    End Function


    Public Overrides Function SelectContentNotifyMemberIds(ByVal notifyMethod As EmailNotifyMethod) As Integer()
        Dim cmd As DbCommand = NrcAuthDb.GetStoredProcCommand(SP.SelectToolkitContentNotifyMember)

        Using rdr As New SafeDataReader(ExecuteReader(NrcAuthDb, cmd))
            Dim memberNotifyMethods As MemberNotifyMethodCollection = PopulateList(Of MemberNotifyMethodCollection, MemberContentNotifyMethod)(rdr, AddressOf PopulateMemberNotifyMethod)
            Dim memberIds As New Collection(Of Integer)
            For Each entry As MemberContentNotifyMethod In memberNotifyMethods
                If entry.ContentNotifyMethod = notifyMethod Then
                    memberIds.Add(entry.MemberId)
                End If
            Next
            Dim values(memberIds.Count - 1) As Integer
            memberIds.CopyTo(values, 0)
            Return values
        End Using
    End Function

#End Region

End Class
