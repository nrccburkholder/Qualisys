Namespace DataProvider
    Public MustInherit Class StudyTableProvider

#Region " Singleton Implementation "
        Private Shared mInstance As StudyTableProvider
        Private Const mProviderName As String = "StudyTableProvider"

        Public Shared ReadOnly Property Instance() As StudyTableProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of StudyTableProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function [Select](ByVal tableId As Integer) As StudyTable
        Public MustOverride Function SelectStudyTableColumn(ByVal tableId As Integer, ByVal fieldId As Integer) As StudyTableColumn
        Public MustOverride Function SelectStudyTableColumns(ByVal studyId As Integer, ByVal tableId As Integer) As Collection(Of StudyTableColumn)
        Public MustOverride Function SelectByStudyId(ByVal studyId As Integer) As Collection(Of StudyTable)
        Public MustOverride Function SelectFromStudyTable(ByVal studyId As Integer, ByVal tableName As String, ByVal whereClause As String, ByVal rowsToReturn As Integer) As DataTable
        Public MustOverride Function SelectHouseHoldingFieldsBySurveyId(ByVal surveyId As Integer) As StudyTableColumnCollection

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property StudyTableId(ByVal obj As StudyTable) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property
            Public Shared WriteOnly Property StudyTableIsView(ByVal obj As StudyTable) As Boolean
                Set(ByVal value As Boolean)
                    If obj IsNot Nothing Then
                        obj.IsView = value
                    End If
                End Set
            End Property

            Public Shared WriteOnly Property StudyTableColumnId(ByVal obj As StudyTableColumn) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class
    End Class

End Namespace
