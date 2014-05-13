
Public MustInherit Class DataProvider

#Region " Singleton Implementation "
    Private Shared mInstance As DataProvider
    Private Const mProviderName As String = "DataProvider"
    Public Shared ReadOnly Property Instance() As DataProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of DataProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectOneClickDefinition(ByVal oneClickDefinitionId As Integer) As OneClickDefinition
    Public MustOverride Function SelectOneClickDefinitionsByOneClickType(ByVal oneClickTypeId As Integer) As Collection(Of OneClickDefinition)
    Public MustOverride Function SelectAllOneClickDefinitions() As Collection(Of OneClickDefinition)
    Public MustOverride Function InsertOneClickDefinition(ByVal oneClickTypeId As Integer, ByVal categoryName As String, ByVal oneClickReportName As String, ByVal oneClickReportDescription As String, ByVal reportId As Integer, ByVal order As Integer) As OneClickDefinition
    Public MustOverride Sub UpdateOneClickDefinition(ByVal instance As OneClickDefinition)
    Public MustOverride Sub DeleteOneClickDefinition(ByVal oneClickDefinitionId As Integer)
    Public MustOverride Sub DeleteOneClickDefinitionsByOneClickType(ByVal oneClickTypeId As Integer)

    Public MustOverride Function SelectOneClickReport(ByVal id As Integer) As OneClickReport
    Public MustOverride Function SelectAllOneClickReports() As Collection(Of OneClickReport)
    Public MustOverride Function SelectOneClickReportsByClientUserId(ByVal clientUserId As Integer) As Collection(Of OneClickReport)
    Public MustOverride Function InsertOneClickReport(ByVal clientuserId As Integer, ByVal categoryName As String, ByVal name As String, ByVal description As String, ByVal reportId As Integer, ByVal order As Integer) As OneClickReport
    Public MustOverride Sub UpdateOneClickReport(ByVal instance As OneClickReport)
    Public MustOverride Sub DeleteOneClickReport(ByVal id As Integer)

    Public MustOverride Function SelectOneClickType(ByVal oneClickTypeId As Integer) As OneClickType
    Public MustOverride Function SelectAllOneClickTypes() As Collection(Of OneClickType)
    Public MustOverride Function InsertOneClickType(ByVal oneClickTypeName As String) As OneClickType
    Public MustOverride Sub UpdateOneClickType(ByVal instance As OneClickType)
    Public MustOverride Sub DeleteOneClickType(ByVal oneClickTypeId As Integer)

#Region " CommentFilter Method "
    Public MustOverride Function SelectCommentFiltersByGroupId(ByVal groupId As Integer) As CommentFilterCollection
    Public MustOverride Sub UpdateCommentFilter(ByVal filter As CommentFilter)
    Public MustOverride Sub InsertCommentFilter(ByVal filter As CommentFilter)
    Public MustOverride Sub DeleteCommentFilter(ByVal studyTableColumnId As Integer, ByVal groupId As Integer)
#End Region

#Region " Study Table Methods "
    Public MustOverride Function [Select](ByVal tableId As Integer) As StudyTable
    Public MustOverride Function SelectStudyTableColumn(ByVal tableId As Integer, ByVal fieldId As Integer) As StudyTableColumn
    Public MustOverride Function SelectStudyTableColumns(ByVal studyId As Integer, ByVal tableId As Integer) As Collection(Of StudyTableColumn)
    Public MustOverride Function SelectByStudyId(ByVal studyId As Integer) As Collection(Of StudyTable)
    Public MustOverride Function SelectFromStudyTable(ByVal studyId As Integer, ByVal tableName As String, ByVal whereClause As String, ByVal rowsToReturn As Integer) As DataTable
    Public MustOverride Sub UpdateStudyTableColumn(ByVal column As StudyTableColumn)
    Public MustOverride Function ValidateStudyTableColumnFormula(ByVal studyId As Integer, ByVal formula As String, ByRef message As String) As Boolean
    Public MustOverride Function InsertCalculatedStudyTableColumn(ByVal studyId As Integer, ByVal name As String, ByVal description As String, ByVal displayName As String, ByVal formula As String, ByRef warningMessages As String) As StudyTableColumn
#End Region

#Region " Managed Content Methods "
    Public MustOverride Function SelectManagedContentByKey(ByVal category As String, ByVal key As String) As ManagedContent
    Public MustOverride Function SelectManagedContentByCategory(ByVal category As String, ByVal includeInactive As Boolean) As ManagedContentCollection
    Public MustOverride Function SelectAllManagedContent(ByVal includeInactive As Boolean) As ManagedContentCollection
    Public MustOverride Function SelectManagedContentCategories() As List(Of String)
    Public MustOverride Function SelectManagedContentKeys(ByVal category As String) As List(Of String)
    Public MustOverride Function InsertManagedContent(ByVal instance As ManagedContent) As Integer
    Public MustOverride Sub UpdateManagedContent(ByVal instance As ManagedContent)
    Public MustOverride Sub DeleteManagedContent(ByVal category As String, ByVal key As String)
#End Region

#Region " Question Content "
    Public MustOverride Function SelectQuestionContentByQuestionId(ByVal questionId As Integer) As QuestionContent
    Public MustOverride Sub InsertQuestionContent(ByVal questionId As Integer, ByVal contentSetGuid As Guid, ByVal contentType As QuestionContentType, ByVal html As String, ByVal isNew As Boolean)
    Public MustOverride Sub UpdateQuestionContent(ByVal contentSetGuid As Guid, ByVal contentType As QuestionContentType, ByVal html As String, ByVal isNew As Boolean)
    Public MustOverride Sub RelateQuestionContent(ByVal sourceQuestionId As Integer, ByVal relatedQuestionId As Integer, ByVal useRelatedQuestionContent As Boolean)
    Public MustOverride Sub UnrelateQuestionContent(ByVal questionId As Integer)
    Public MustOverride Function SelectRelatedQuestions(ByVal questionId As Integer) As DataTable
#End Region

#Region " Improvement Model Methods "
    Public MustOverride Function SelectAllServiceTypes() As ServiceTypeCollection

    Public MustOverride Function InsertServiceType(ByVal obj As ServiceType) As Integer
    Public MustOverride Sub UpdateServiceType(ByVal obj As ServiceType)
    Public MustOverride Sub DeleteServiceType(ByVal serviceTypeId As Integer)

    Public MustOverride Function InsertTheme(ByVal obj As Theme) As Integer
    Public MustOverride Sub UpdateTheme(ByVal obj As Theme)
    Public MustOverride Sub DeleteTheme(ByVal themeId As Integer)
    Public MustOverride Function InsertView(ByVal obj As View) As Integer
    Public MustOverride Sub UpdateView(ByVal obj As View)
    Public MustOverride Sub DeleteView(ByVal viewId As Integer)

#End Region

#Region " ThemeQuestion Methods "
    Public MustOverride Function SelectThemeQuestionsByThemeId(ByVal themeId As Integer) As ThemeQuestionCollection
    Public MustOverride Function SelectThemeQuestionsByQuestionId(ByVal questionId As Integer) As ThemeQuestionCollection
    Public MustOverride Sub InsertThemeQuestion(ByVal themeId As Integer, ByVal questionId As Integer, ByVal userName As String)
    Public MustOverride Sub DeleteThemeQuestion(ByVal themeId As Integer, ByVal questionId As Integer, ByVal userName As String)
#End Region

#Region " Member Resources methods "

    Public MustOverride Function SelectMemberResource(ByVal id As Integer) As MemberResource
    Public MustOverride Function SelectMemberResourceByTitle(ByVal title As String) As MemberResource
    Public MustOverride Function SelectAllMemberResource() As MemberResourceCollection
    '   Rick Christenham (09/10/2007):  NRC eToolkit Enhancement II:
    '                                   Added new parameter to function to allow filtering on groups
    Public MustOverride Function SelectRecentMemberResource(ByVal serviceTypeId As Integer, ByVal viewId As Integer, ByVal themeId As Integer, ByVal questionId As Integer, ByVal groupId As Integer) As MemberResourceCollection
    '   Rick Christenham (09/10/2007):  NRC eToolkit Enhancement II:
    '                                   Added 2 new parameters to function to allow filtering on service type and groups
    Public MustOverride Function SearchTextMemberResource(ByVal resultSet As Guid, ByVal text As String, ByVal serviceTypeId As Integer, ByVal groupId As Integer) As MemberResourceCollection
    Public MustOverride Function InsertMemberResource(ByVal obj As MemberResource) As Integer
    Public MustOverride Sub UpdateMemberResource(ByVal obj As MemberResource)
    Public MustOverride Sub DeleteMemberResource(ByVal id As Integer)

#End Region

#Region " Member Resource Question methods "

    Public MustOverride Function InsertMemberResourceQuestion(ByVal obj As MemberResourceQuestion) As Integer
    Public MustOverride Sub UpdateMemberResourceQuestion(ByVal obj As MemberResourceQuestion)
    Public MustOverride Sub DeleteMemberResourceQuestion(ByVal id As Integer)

#End Region

#Region " Member Resource Other Type methods "

    Public MustOverride Function InsertMemberResourceOtherType(ByVal obj As MemberResourceOtherType) As Integer
    Public MustOverride Sub DeleteMemberResourceOtherType(ByVal documentId As Integer, ByVal otherTypeId As Integer)

#End Region

#Region " Member Resource Group methods "

    ''' <summary>
    ''' Base-class definition for inserting a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
    ''' </summary>
    ''' <param name="obj"><see cref="MemberResourceGroup">MemberResourceGroup</see> object to save</param>
    ''' <returns><see cref="Integer">Integer</see> value representing the primary key</returns>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Public MustOverride Function InsertMemberResourceGroup(ByVal obj As MemberResourceGroup) As Integer
    ''' <summary>
    ''' Base-class definition for updating a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
    ''' </summary>
    ''' <param name="obj"><see cref="MemberResourceGroup">MemberResourceGroup</see> object to save</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Public MustOverride Sub UpdateMemberResourceGroup(ByVal obj As MemberResourceGroup)
    ''' <summary>
    ''' Base-class definition for deleting a <see cref="MemberResourceGroup">MemberResourceGroup</see> record.
    ''' </summary>
    ''' <param name="id"><see cref="Integer">Integer</see> value representing the primary key of the record to delete</param>
    ''' <remarks>
    '''   <para>
    '''   Rick Christenham (09/07/2007): NRC eToolkit Enhancement II
    '''   </para>
    ''' </remarks>
    Public MustOverride Sub DeleteMemberResourceGroup(ByVal id As Integer)

#End Region

#Region " Index Search Result "

    Public MustOverride Function InsertIndexSearchResult(ByVal resource As IndexSearchResult) As Integer
    Public MustOverride Function SearchIndexSearchResult(ByVal resultSet As Guid, ByVal text As String) As IndexSearchResultCollection
    Public MustOverride Sub ClearIndexSearchResult(ByVal resultSet As Guid)

#End Region

#Region " Question Search methods "

    Public MustOverride Function SearchQuestionSearchText(ByVal resultSet As Guid, ByVal text As String) As QuestionSearchWorkCollection

#End Region

#Region " Resource Type methods "

    Public MustOverride Function SelectResourceType(ByVal id As Integer) As ResourceType
    Public MustOverride Function SelectResourceTypeByDescription(ByVal description As String) As ResourceType
    Public MustOverride Function SelectAllResourceType() As ResourceTypeCollection
    Public MustOverride Function InsertResourceType(ByVal obj As ResourceType) As Integer
    Public MustOverride Sub UpdateResourceType(ByVal obj As ResourceType)
    Public MustOverride Sub DeleteResourceType(ByVal id As Integer)

#End Region

#Region " Resource Other Type methods "

    Public MustOverride Function SelectResourceOtherType(ByVal id As Integer) As ResourceOtherType
    Public MustOverride Function SelectResourceOtherTypeByDescription(ByVal description As String) As ResourceOtherType
    Public MustOverride Function SelectAllResourceOtherType() As ResourceOtherTypeCollection
    Public MustOverride Function InsertResourceOtherType(ByVal obj As ResourceOtherType) As Integer
    Public MustOverride Sub UpdateResourceOtherType(ByVal obj As ResourceOtherType)
    Public MustOverride Sub DeleteResourceOtherType(ByVal id As Integer)

#End Region

#Region " Notify Method methods "

    Public MustOverride Function SelectNotifyMethod(ByVal id As Integer) As NotifyMethod
    Public MustOverride Function SelectAllNotifyMethod() As NotifyMethodCollection

#End Region

#Region " Analysis Measure methods "

    Public MustOverride Function SelectAnalysisMeasure(ByVal id As Integer) As AnalysisMeasure
    Public MustOverride Function SelectAllAnalysisMeasure() As AnalysisMeasureCollection

#End Region

#Region " Member Report Preference methods "

    Public MustOverride Function SelectMemberReportPreference(ByVal memberId As Integer) As MemberReportPreference
    Public MustOverride Function SelectAllMemberReportPreference() As MemberReportPreferenceCollection
    Public MustOverride Sub InsertMemberReportPreference(ByVal obj As MemberReportPreference)
    Public MustOverride Sub UpdateMemberReportPreference(ByVal obj As MemberReportPreference)
    Public MustOverride Sub DeleteMemberReportPreference(ByVal memberId As Integer)

#End Region

#Region " Member Report Preference methods "

    Public MustOverride Function SelectMemberGroupReportPreference(ByVal memberId As Integer, ByVal groupId As Integer) As MemberGroupReportPreference
    Public MustOverride Function SelectAllMemberGroupReportPreference() As MemberGroupReportPreferenceCollection
    Public MustOverride Sub InsertMemberGroupReportPreference(ByVal obj As MemberGroupReportPreference)
    Public MustOverride Sub UpdateMemberGroupReportPreference(ByVal obj As MemberGroupReportPreference)
    Public MustOverride Sub DeleteMemberGroupReportPreference(ByVal memberId As Integer, ByVal groupId As Integer)

#End Region

    Public MustOverride Function SelectContentNotifyMemberIds(ByVal notifyMethod As EmailNotifyMethod) As Integer()

End Class

