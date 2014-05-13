
Imports System.Text
Namespace ORYX

    Public Enum X12FileType
        HCO
        COMP
    End Enum
    Public Delegate Sub ReportProgressDelegate(ByVal PercentDone As Int32, ByVal Msg As String)
    Public Delegate Sub ErrorEncounteredDelegate(ByVal ex As Exception)
    Public Delegate Sub ExportCompleteDelegate()
    Public Class OryxExporter
        Const MonthKeyFormat As String = "yyyyMM"
        Private _Path As String = String.Empty
        Public Property OutputPath() As String
            Get
                If _Path = String.Empty Then
                    _Path = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory)
                End If
                Return _Path
            End Get
            Set(ByVal value As String)
                _Path = value
            End Set
        End Property
        Dim _StopLock As New Object()
        Dim _StopFlag As Boolean
        Public Property StopFlag() As Boolean
            Get
                SyncLock (_StopLock)
                    Return _StopFlag
                End SyncLock
            End Get
            Set(ByVal value As Boolean)
                SyncLock (_StopLock)
                    _StopFlag = value
                End SyncLock
            End Set
        End Property
        Dim _RunLock As New Object()
        Dim _RunningExport As Boolean = False
        Public Property RunningExport() As Boolean
            Get
                SyncLock (_RunLock)
                    Return _RunningExport
                End SyncLock
            End Get
            Set(ByVal value As Boolean)
                SyncLock (_RunLock)
                    _RunningExport = value
                End SyncLock
            End Set
        End Property
        Dim _HCOIDs As Dictionary(Of Int32, Collection(Of ExportSet))
        Dim _Quarter As Int32
        Dim _Year As Int32
        Dim _OnProgress As ReportProgressDelegate
        Dim _OnError As ErrorEncounteredDelegate
        Dim _OnComplete As ExportCompleteDelegate

        Public Sub New()
            _HCOIDs = New Dictionary(Of Int32, Collection(Of ExportSet))
        End Sub
        Public Sub StopExport()
            StopFlag = True
        End Sub
        Public Sub CreateExportAsync( _
                    ByVal exportSets As Collection(Of ExportSet), _
                    ByVal filePath As String, _
                    ByVal ExportQuarter As Int32, _
                    ByVal ExportYear As Int32, _
                    ByVal OnProgress As ReportProgressDelegate, _
                    ByVal OnError As ErrorEncounteredDelegate, _
                    ByVal OnComplete As ExportCompleteDelegate)
            If RunningExport Then
                If Not OnError Is Nothing Then
                    OnError(New Exception("An export is currently running."))
                    Return
                End If
            Else
                RunningExport = True
            End If

            OutputPath = filePath
            _Quarter = ExportQuarter
            _Year = ExportYear
            _OnProgress = OnProgress
            _OnError = OnError
            _OnComplete = OnComplete
            If FillHCOList(exportSets) Then
                Dim t As New System.Threading.Thread(AddressOf InternalCreateExport)
                t.IsBackground = True
                t.Start()
            Else
                If Not OnError Is Nothing Then
                    RunningExport = False
                    OnError(New Exception("There are no ORYX HCOs associated with at least one of the chosen export sets."))
                End If
            End If
        End Sub
        Private Sub InternalCreateExport()
            Dim AllMeasurements As New SortedDictionary(Of Int32, OryxMeasurement)
            Dim MeasurementHCOCount As New Dictionary(Of Int32, Int32)
            Dim AllHCOData As New List(Of OryxHcoData)
            Dim CurrentProgress As Int32 = Convert.ToInt32(10 / _HCOIDs.Count)
            Try

                AllHCOData = WriteHcoFile(AllMeasurements, _
                    MeasurementHCOCount, _
                    CurrentProgress)
                If StopFlag Then
                    RunningExport = False
                    Return
                End If

                WriteCompFile(AllMeasurements, _
                    MeasurementHCOCount, _
                    AllHCOData, _
                    CurrentProgress)
                If StopFlag Then
                    RunningExport = False
                    Return
                End If

                RunningExport = False
                _OnComplete()

            Catch ex As Exception
                If _OnError IsNot Nothing Then
                    RunningExport = False
                    _OnError(ex)
                End If
            End Try
        End Sub
        Private Function WriteHcoFile(ByVal AllMeasurements As SortedDictionary(Of Int32, OryxMeasurement), _
            ByVal MeasurementHCOCount As Dictionary(Of Int32, Int32), _
            ByRef CurrentProgress As Int32) As List(Of OryxHcoData)

            Dim oryxWriter As New OryxFileWriter()
            Dim AllHCOData As New List(Of OryxHcoData)
            Dim MeasurementList As List(Of OryxMeasurement)
            Dim ExportSetData As DataTable = Nothing
            Dim increment As Int32
            Dim FileControlNumber As Int32 = DataProvider.Instance.SelectOryxLastUsedFileNum() + 1
            Dim FileControlTag As String = DateTime.Now.ToString("yyMMdd") + FileControlNumber.ToString().PadLeft(3, "0"c)

            If CallProgress(0, "Initializing File") Then
                Return Nothing
            End If

            oryxWriter.BuildInterchangeControlHeader(FileControlTag)
            oryxWriter.BuildFunctionalGroupHeader(FileControlTag)
            oryxWriter.BuildTransactionSetHeader(X12FileType.HCO, FileControlTag)

            For Each HCO As Int32 In _HCOIDs.Keys
                oryxWriter.BuildHCOGroupSegment(HCO)

                If CallProgress(CurrentProgress, "Extracting Data") Then
                    Return Nothing
                End If

                Try
                    ExportSetData = GetExportDataTable(_HCOIDs(HCO))
                    'TODO: log export with 'insertExportFile' and 'InsertExportFileSet'
                Catch ex As Exception
                    If Not _OnError = Nothing Then
                        _OnError(ex)
                    End If
                    Return Nothing
                End Try

                Dim FilteredExportData As DataTable = FilterDataToParentSampleUnit(ExportSetData, HCO)
                MeasurementList = GetMeasurements(HCO)
                If MeasurementList.Count = 0 Then
                    ' do we want to give a warning?
                    Continue For
                End If

                CurrentProgress = Convert.ToInt32(CurrentProgress + 10 / _HCOIDs.Count)
                If CallProgress(CurrentProgress, "Recoding Data") Then
                    Return Nothing
                End If

                RecodeAnswers(FilteredExportData, MeasurementList)
                increment = Convert.ToInt32((40 / _HCOIDs.Count) * (1 / MeasurementList.Count)) 'estimated as 40% of export time
                For Each m As OryxMeasurement In MeasurementList

                    CurrentProgress = CurrentProgress + increment
                    If CallProgress(CurrentProgress, "Building HCO Section") Then
                        Return Nothing
                    End If

                    For Each d As OryxHcoData In GetHCOData(FilteredExportData, HCO, _Quarter, _Year, m)
                        oryxWriter.BuildHcoMeasurement(d)
                        AllHCOData.Add(d)
                        'we need a list of all the used measurements for Comp data
                        If Not AllMeasurements.ContainsKey(m.MeasurementID) Then
                            AllMeasurements.Add(m.MeasurementID, m)
                        End If
                        If Not MeasurementHCOCount.ContainsKey(m.MeasurementID) Then
                            MeasurementHCOCount.Add(m.MeasurementID, 0)
                        End If
                    Next

                    MeasurementHCOCount(m.MeasurementID) = MeasurementHCOCount(m.MeasurementID) + 1
                Next
                'Writing a csv file of the export (with mapped answer and oryx measurement answer columns) for QP purposes.
                Dim writer As New Nrc.Framework.Data.CsvWriter(FilteredExportData)
                Dim recordCount As Integer = writer.Write(String.Format("{0}\HCO{3}Q{1}{2}.csv", OutputPath, _Quarter, _Year, HCO))
            Next
            oryxWriter.BuildGroupFooter(FileControlTag)
            oryxWriter.BuildFileFooter(FileControlTag)
            oryxWriter.WriteFile(String.Format("{0}\p077202.p{1}", OutputPath, FileControlNumber))
            DataProvider.Instance.UpdateOryxLastUsedFileNum(FileControlNumber)
            Return AllHCOData
        End Function
        Private Sub WriteCompFile(ByVal AllMeasurements As SortedDictionary(Of Int32, OryxMeasurement), _
            ByVal MeasurementHCOCount As Dictionary(Of Int32, Int32), _
            ByVal AllHCOData As List(Of OryxHcoData), _
            ByRef CurrentProgress As Int32)

            Dim FileControlNumber As Int32 = DataProvider.Instance.SelectOryxLastUsedFileNum() + 1
            Dim FileControlTag As String = DateTime.Now.ToString("yyMMdd") + FileControlNumber.ToString().PadLeft(3, "0"c)

            Dim oryxWriter As New OryxFileWriter()
            oryxWriter.BuildInterchangeControlHeader(FileControlTag)
            oryxWriter.BuildGroupHeader(X12FileType.COMP, FileControlTag)

            Dim DataByMeasure As Dictionary(Of Int32, List(Of OryxHcoData)) = GroupHCODataByMeasure(AllHCOData)
            Dim increment As Int32 = Convert.ToInt32(40 * 1 / AllMeasurements.Count) 'estimated as 40% of export time
            For Each m As OryxMeasurement In AllMeasurements.Values
                CurrentProgress = CurrentProgress + increment
                If CallProgress(CurrentProgress, "Building Comp Section") Then
                    Return
                End If
                For Each d As OryxCompData In GetCompData(DataByMeasure(m.MeasurementID), _Quarter, _Year, m, MeasurementHCOCount)
                    oryxWriter.BuildCompMeasurement(d)
                Next
            Next
            oryxWriter.BuildGroupFooter(FileControlTag)
            oryxWriter.BuildFileFooter(FileControlTag)
            If CallProgress(100, "Writing File") Then
                Return
            End If
            oryxWriter.WriteFile(String.Format("{0}\p077202.p{1}", OutputPath, FileControlNumber))
            DataProvider.Instance.UpdateOryxLastUsedFileNum(FileControlNumber)
        End Sub
        ''' <summary>
        ''' Checks for a cancel, then sends message back to _OnProgress event.
        ''' </summary>
        ''' <param name="pct">Percent done</param>
        ''' <param name="msg">Message to display</param>
        ''' <returns>Abort process</returns>
        ''' <remarks></remarks>
        Private Function CallProgress(ByVal pct As Int32, ByVal msg As String) As Boolean
            Try
                If StopFlag And _OnComplete IsNot Nothing And _OnComplete.Target IsNot Nothing Then
                    _OnComplete()
                    Return True
                End If
                If Not _OnProgress = Nothing And _OnComplete.Target IsNot Nothing Then
                    _OnProgress(pct, msg)
                    Return False
                End If
            Catch
                Dim i As Int32 = 1
            End Try
            Return True
        End Function
        Private Function GetExportDataTable(ByVal exportSets As System.Collections.ObjectModel.Collection(Of ExportSet)) As DataTable
            Dim Reader As IDataReader
            Reader = DataProvider.Instance.SelectExportFileData( _
                BuildListOfExportSetIDs(exportSets).ToArray, _
                True, _
                False, _
                False, _
                Guid.NewGuid, False, True)
            Dim InputData As New DataTable()
            InputData.Load(Reader, LoadOption.OverwriteChanges)
            Return InputData
        End Function
        Private Function FillHCOList(ByVal Exports As Collection(Of ExportSet)) As Boolean
            For Each e As ExportSet In Exports
                Dim HCOid As Integer = DataProvider.Instance.SelectORYXHCOByExportSet(e.Id)
                If HCOid > 0 Then
                    If _HCOIDs.ContainsKey(HCOid) Then
                        _HCOIDs(HCOid).Add(e)
                    Else
                        Dim HCOExports As Collection(Of ExportSet) = New Collection(Of ExportSet)
                        HCOExports.Add(e)
                        _HCOIDs.Add(HCOid, HCOExports)
                    End If
                Else
                    Return False
                End If
            Next
            Return _HCOIDs.Count > 0
        End Function
        Private Function BuildListOfExportSetIDs(ByVal exportSets As Collection(Of ExportSet)) As List(Of Int32)
            Dim IDList As New List(Of Int32)
            For Each export As ExportSet In exportSets
                IDList.Add(export.Id)
            Next
            Return IDList
        End Function
        Private Function GetMeasurements(ByVal HCOID As Int32) As List(Of OryxMeasurement)
            Dim result As New List(Of OryxMeasurement)
            Dim Measurements As List(Of Int32) = DataProvider.Instance.SelectOryxMeasurements(HCOID)
            For Each MID As Int32 In Measurements
                result.Add(New OryxMeasurement(MID))
            Next
            Return result
        End Function
        Private Sub RecodeAnswers(ByVal data As DataTable, ByVal Measurements As List(Of OryxMeasurement))
            'collect column names
            Dim QuestionColumns As New Dictionary(Of String, OryxQuestion)
            For Each m As OryxMeasurement In Measurements
                For Each q As OryxQuestion In m.Questions
                    QuestionColumns.Add(GetColumnName(q), q)
                    data.Columns.Add(GetMappedColumnName(q), System.Type.GetType("System.Int32"))
                Next
            Next

            For Each row As DataRow In data.Rows
                For Each c As String In QuestionColumns.Keys
                    If data.Columns.Contains(c) AndAlso row(c) IsNot Nothing AndAlso Not IsDBNull(row(c)) Then
                        data.Columns(c).ReadOnly = False
                        Dim mappedAnswer As Nullable(Of Int32) = QuestionColumns.Item(c).MapAnswer(Convert.ToInt32(row(c)))
                        If Not mappedAnswer.HasValue Then
                            row(ConvertToMappedName(c)) = DBNull.Value
                        Else
                            row(ConvertToMappedName(c)) = mappedAnswer
                        End If
                        'QuestionColumns.Remove(c)  'does this mess up the indexing of the for loop?
                    End If
                Next
            Next

        End Sub
        Private Function GetHCOData(ByVal HCOdata As DataTable, _
            ByVal HCO As Int32, _
            ByVal Quarter As Int32, _
            ByVal Year As Int32, _
            ByVal measurement As OryxMeasurement) As List(Of OryxHcoData)

            Dim LastMonth As Int32 = Quarter * 3
            Dim FirstMonth As Int32 = LastMonth - 2

            Dim Result As New List(Of OryxHcoData)

            For i As Int32 = FirstMonth To LastMonth
                Dim DataDate As New Date(Year, i, 1)
                Dim MonthData As DataTable = GroupDataByMonth(HCOdata, DataDate)
                Dim Scores As List(Of Double) = GetMeasurementScores(measurement, MonthData, HCOdata)

                If (Scores.Count > 0) Then
                    Result.Add(New OryxHcoData(HCO, _
                        measurement.MeasurementID, _
                        DataDate, _
                        1, _
                        Scores.Count, _
                        GetMean(Scores), _
                        GetMedian(Scores), _
                        GetMin(Scores), _
                        GetMax(Scores), _
                        GetStdDev(Scores), _
                        Scores))
                Else
                    Result.Add(New OryxHcoData(HCO, measurement.MeasurementID, DataDate, 3, 0, 0, 0, 0, 0, 0, New List(Of Double))) 'add missing month items
                End If
            Next
            Return Result
        End Function
        Private Function GetCompData(ByVal HCOData As List(Of OryxHcoData), ByVal Quarter As Int32, ByVal year As Int32, ByVal Measurement As OryxMeasurement, ByVal MeasurementCounts As Dictionary(Of Int32, Int32)) As List(Of OryxCompData)
            Dim result As New List(Of OryxCompData)
            Dim LastMonth As Int32 = Quarter * 3
            Dim FirstMonth As Int32 = LastMonth - 2

            Dim DataByMonth As Dictionary(Of String, List(Of OryxHcoData)) = GroupHCODataByDate(HCOData)
            Dim MonthData As List(Of OryxHcoData)

            For i As Int32 = FirstMonth To LastMonth
                Dim ThisMonth As Date = New Date(year, i, 1)
                MonthData = DataByMonth(ThisMonth.ToString(MonthKeyFormat))

                Dim Scores As List(Of Double) = AddAllScores(MonthData)
                Dim Means As List(Of Double) = GetListOfMeans(MonthData)
                Dim CaseCount As List(Of Double) = GetListOfCaseCounts(MonthData)
                result.Add(New OryxCompData(Measurement.MeasurementID, _
                               1, _
                               ThisMonth, _
                               ThisMonth, _
                                ThisMonth, _
                               MeasurementCounts(Measurement.MeasurementID), _
                               Scores.Count, _
                               GetMean(CaseCount), _
                               GetMedian(CaseCount), _
                               Convert.ToInt32(GetMin(CaseCount)), _
                               Convert.ToInt32(GetMax(CaseCount)), _
                               GetMean(Means), _
                               GetMedian(Means), _
                               GetMin(Means), _
                               GetMax(Means), _
                               GetMean(Scores), _
                               GetStdDev(Means)))
            Next
            Return result
        End Function
        Private Function AddAllScores(ByVal HCOData As List(Of OryxHcoData)) As List(Of Double)
            Dim result As New List(Of Double)
            For Each d As OryxHcoData In HCOData
                For Each s As Double In d.Scores
                    result.Add(s)
                Next
            Next
            Return result
        End Function

        Private Function GetMeasurementScores(ByVal measurement As OryxMeasurement, ByVal data As DataTable, ByVal ReportTable As DataTable) As List(Of Double)
            Dim SumOfAnswers As Int32 = 0
            Dim Scores As New List(Of Double)
            Dim HadData As Boolean
            Dim MeasurementColumnName As String = "ORYX" + measurement.MeasurementID.ToString()
            If Not ReportTable.Columns.Contains(MeasurementColumnName) Then
                ReportTable.Columns.Add(MeasurementColumnName, Type.GetType("System.Double"))
            End If
            For Each row As DataRow In data.Rows
                SumOfAnswers = 0
                HadData = False
                'Each measurement can have multiple questions.
                For Each q As OryxQuestion In measurement.Questions
                    Dim ColumnName As String = GetMappedColumnName(q)
                    If data.Columns.Contains(ColumnName) _
                    AndAlso row(ColumnName) IsNot Nothing _
                    AndAlso Not IsDBNull(row(ColumnName)) Then
                        HadData = True
                        SumOfAnswers = SumOfAnswers + Convert.ToInt32(row(ColumnName))
                    End If
                Next
                'We want the average score of the answers on those questions.
                If HadData Then
                    Dim score As Double = SumOfAnswers / measurement.Questions.Count
                    AddScoreToReportTable(ReportTable, Convert.ToInt32(row("LithoCd")), MeasurementColumnName, score)
                    Scores.Add(score)
                End If
            Next
            Return Scores
        End Function
        Private Sub AddScoreToReportTable(ByVal ReportTable As DataTable, ByVal litho As Int32, ByVal ColumnName As String, ByVal Score As Double)
            For Each r As DataRow In ReportTable.Rows
                If Convert.ToInt32(r("LithoCd")) = litho Then
                    r(ColumnName) = Score
                    Return
                End If
            Next
        End Sub
        Private Function GroupHCODataByDate(ByVal HCOData As List(Of OryxHcoData)) As Dictionary(Of String, List(Of OryxHcoData))
            Dim group As New Dictionary(Of String, List(Of OryxHcoData))
            For Each hco As OryxHcoData In HCOData
                If Not group.ContainsKey(hco.DataDate.ToString(MonthKeyFormat)) Then
                    group.Add(hco.DataDate.ToString(MonthKeyFormat), New List(Of OryxHcoData))
                End If
                group.Item(hco.DataDate.ToString(MonthKeyFormat)).Add(hco)
            Next
            Return group
        End Function
        Private Function FilterDataToParentSampleUnit(ByVal data As DataTable, ByVal HCO As Int32) As DataTable
            Dim result As DataTable = data.Clone()
            Dim ParentSampleUnits As Collection(Of Int32) = DataProvider.Instance.SelectParentSampleUnitIDsByOryxHCOID(HCO)

            If data.Columns.Contains("SampUnit") Then
                For Each r As DataRow In data.Rows
                    If r("SampUnit") IsNot Nothing _
                    AndAlso Not IsDBNull(r("SampUnit")) _
                    AndAlso ParentSampleUnits.Contains(Convert.ToInt32(r("SampUnit"))) Then
                        result.ImportRow(r)
                    End If
                Next
            End If
            Return result
        End Function
        Private Function GroupHCODataByMeasure(ByVal HCOData As List(Of OryxHcoData)) As Dictionary(Of Int32, List(Of OryxHcoData))
            Dim group As New Dictionary(Of Int32, List(Of OryxHcoData))
            For Each hco As OryxHcoData In HCOData
                If Not group.ContainsKey(hco.MeasureID) Then
                    group.Add(hco.MeasureID, New List(Of OryxHcoData))
                End If
                group.Item(hco.MeasureID).Add(hco)
            Next
            Return group
        End Function
        Private Function GroupDataByMonth(ByVal data As DataTable, ByVal MonthDate As Date) As DataTable
            Return GroupDataByMonth(data, MonthDate, MonthDate)
        End Function
        Private Function GroupDataByMonth(ByVal data As DataTable, ByVal StartMonth As Date, ByVal EndMonth As Date) As DataTable
            Dim MonthData As DataTable = data.Clone()

            Dim RowDate As Date
            For Each row As DataRow In data.Rows
                RowDate = Convert.ToDateTime(row("serdate"))
                If Year(RowDate) >= Year(StartMonth) _
                And Year(RowDate) <= Year(EndMonth) _
                And Month(RowDate) >= Month(StartMonth) _
                And Month(RowDate) <= Month(EndMonth) Then
                    MonthData.ImportRow(row)
                End If
            Next
            Return MonthData
        End Function
        Public Function GetColumnName(ByVal Question As OryxQuestion) As String
            Dim num As String = Question.QuestionID.ToString()
            Return "Q" + num.PadLeft(6, "0"c)
        End Function
        Public Function GetMappedColumnName(ByVal Question As OryxQuestion) As String
            Dim num As String = Question.QuestionID.ToString()
            Return "M" + num.PadLeft(6, "0"c)
        End Function
        Public Function ConvertToMappedName(ByVal UnmappedColumnName As String) As String
            Return UnmappedColumnName.Replace("Q"c, "M"c)
        End Function
        Private Function GetMean(ByVal scores As List(Of Double)) As Double
            If scores.Count < 1 Then
                Return 0
            End If
            Dim total As Double
            For Each s As Double In scores
                total = total + s
            Next
            Return total / scores.Count
        End Function
        Private Function GetMedian(ByVal scores As List(Of Double)) As Double
            scores.Sort()
            If scores.Count < 1 Then
                Return 0
            ElseIf scores.Count = 2 Then 'if we only have 2 items, we take the first - this is what the old system was doing, not sure if it is right.
                Return scores(0)
            End If
            Dim result As Double
            Dim MiddleIndex As Int32 = Convert.ToInt32(Math.Floor(scores.Count / 2))
            result = scores(MiddleIndex)
            'if odd, we round the index up for the median.  if the count is 1, we already have the median. 
            If scores.Count > 1 AndAlso Not (scores.Count Mod 2) = 0 Then
                result = (scores(MiddleIndex) + scores(MiddleIndex + 1)) / 2
            End If
            Return result
        End Function
        Private Function GetMin(ByVal scores As List(Of Double)) As Double
            If scores.Count = 1 Then
                Return scores(0)
            End If

            Dim result As Double = Double.MaxValue
            For Each s As Double In scores
                If s < result Then
                    result = s
                End If
            Next
            Return result
        End Function
        Private Function GetMax(ByVal scores As List(Of Double)) As Double
            If scores.Count = 1 Then
                Return scores(0)
            End If

            Dim result As Double = Double.MinValue
            For Each s As Double In scores
                If s > result Then
                    result = s
                End If
            Next
            Return result
        End Function
        Private Function GetStdDev(ByVal scores As List(Of Double)) As Double
            If scores.Count < 2 Then
                Return 0
            End If

            Dim Average As Double = GetMean(scores)
            Dim SumOfDeviations As Double = 0
            For Each s As Double In scores
                SumOfDeviations = SumOfDeviations + ((s - Average) * (s - Average))
            Next
            Return Math.Sqrt(SumOfDeviations / (scores.Count - 1))
        End Function
        Private Function GetListOfMeans(ByVal data As List(Of OryxHcoData)) As List(Of Double)
            Dim result As New List(Of Double)
            For Each d As OryxHcoData In data
                result.Add(d.Mean)
            Next
            Return result
        End Function
        Private Function GetListOfCaseCounts(ByVal data As List(Of OryxHcoData)) As List(Of Double)
            Dim result As New List(Of Double)
            For Each d As OryxHcoData In data
                result.Add(d.NumberOfCases)
            Next
            result.Sort()
            Return result
        End Function


        Protected Overrides Sub Finalize()
            MyBase.Finalize()
        End Sub
    End Class
End Namespace