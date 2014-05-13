Namespace ORYX

    Public Class OryxMeasurementSettings

        Private SelectedMeasure As Int32
        Private IncludedQuestions As List(Of Int32)
        Private ChangedMaps As Dictionary(Of Int32, Dictionary(Of Int32, Nullable(Of Int32)))
        Private _NeedSaved As Boolean = False
        Public ReadOnly Property NeedSaved() As Boolean
            Get
                Return _NeedSaved
            End Get
        End Property
        Private _NeedScaleSaved As Boolean = False
        Public ReadOnly Property NeedScaleSaved() As Boolean
            Get
                Return _NeedScaleSaved
            End Get
        End Property
        Public Sub RefreshQuestions(ByVal MeasurementID As Int32)
            IncludedQuestions = Nothing
            IncludedQuestions = DataProvider.Instance.SelectOryxQuestions(MeasurementID)
        End Sub
        Public Function GetQuestionsByMeasure(ByVal MeasurementID As Int32) As List(Of Int32)
            If SelectedMeasure <> MeasurementID Then
                SelectedMeasure = MeasurementID
                RefreshQuestions(MeasurementID)
            End If
            Return IncludedQuestions
        End Function
        Public Function GetQuestionText(ByVal QstnCore As Int32) As List(Of String)
            Return DataProvider.Instance.SelectQuestionText(QstnCore)
        End Function
        Public Function GetQuestionScale(ByVal QstnCore As Int32) As DataTable
            Dim tbl As DataTable = DataProvider.Instance.SelectScale(QstnCore)
            tbl.Columns.Add("Mapping")
            Dim Map As Dictionary(Of Int32, Nullable(Of Int32)) = GetQuestionMapping(QstnCore)
            For Each r As DataRow In tbl.Rows
                Dim val As Integer = Convert.ToInt32(r("Value"))
                If Map.ContainsKey(val) Then
                    r("Mapping") = Map(val)
                End If
            Next
            Return tbl
        End Function
        Public Function GetQuestionMapping(ByVal QstnCore As Int32) As Dictionary(Of Int32, Nullable(Of Int32))
            Return DataProvider.Instance.SelectOryxAnswerMappings(QstnCore)
        End Function
        Public Sub EditQuestionMapping(ByVal QuestionID As Int32, ByVal FromValue As Int32, ByVal ToValue As Nullable(Of Int32))
            _NeedScaleSaved = True
            If ChangedMaps Is Nothing Then
                ChangedMaps = New Dictionary(Of Int32, Dictionary(Of Int32, Nullable(Of Int32)))
            End If
            If Not ChangedMaps.ContainsKey(QuestionID) Then
                ChangedMaps.Add(QuestionID, New Dictionary(Of Int32, Nullable(Of Int32)))
            End If
            If Not ChangedMaps(QuestionID).ContainsKey(FromValue) Then
                ChangedMaps(QuestionID).Add(FromValue, ToValue)
            Else
                ChangedMaps(QuestionID)(FromValue) = ToValue
            End If
        End Sub
        Public Sub AddQuestion(ByVal QuestionID As Int32)
            If Not IncludedQuestions.Contains(QuestionID) Then
                _NeedSaved = True
                IncludedQuestions.Add(QuestionID)
            End If
        End Sub
        Public Sub RemoveQuestion(ByVal QuestionID As Int32)
            If IncludedQuestions.Contains(QuestionID) Then
                _NeedSaved = True
                IncludedQuestions.Remove(QuestionID)
            End If
        End Sub

        Public Sub AbandonChangesAndRefresh()
            RefreshQuestions(SelectedMeasure)
            _NeedSaved = False
        End Sub
        Public Sub AbandonScaleChanges()
            If ChangedMaps IsNot Nothing Then
                ChangedMaps.Clear()
            End If
            _NeedScaleSaved = False
        End Sub
        Public Sub SaveChanges()
            If NeedSaved Then
                SaveQuestionChanges()
            End If
            If NeedScaleSaved Then
                SaveScaleChanges()
            End If
            AbandonChangesAndRefresh()
        End Sub
        Private Sub SaveQuestionChanges()
            DataProvider.Instance.DeleteQuestionsByMeasure(SelectedMeasure)
            For Each q As Int32 In IncludedQuestions
                DataProvider.Instance.AddQuestionToMeasure(SelectedMeasure, q)
            Next
        End Sub
        Public Sub SaveScaleChanges()
            If ChangedMaps IsNot Nothing Then
                For Each q As Int32 In ChangedMaps.Keys
                    For Each NRCValue As Int32 In ChangedMaps(q).Keys
                        If ChangedMaps(q)(NRCValue).HasValue Then
                            DataProvider.Instance.UpdateAnswerMapping(q, NRCValue, ChangedMaps(q)(NRCValue).Value)
                        Else
                            DataProvider.Instance.UpdateAnswerMapping(q, NRCValue, Nothing)
                        End If
                    Next
                Next
                _NeedScaleSaved = False
            End If
        End Sub

        Public Shared Sub CreateNewMeasurement(ByVal MeasurementID As Int32)
            DataProvider.Instance.AddMeasurement(MeasurementID)
        End Sub
    End Class
End Namespace