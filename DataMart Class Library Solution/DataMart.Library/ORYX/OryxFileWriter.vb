Imports System.Text
Imports Nrc.DataMart.Library.ORYX
Namespace ORYX
    Public Class OryxFileWriter


#Region "Interchange Control"
        Const ICSegmentID As String = "ISA"
        Const ICFooterID As String = "IEA"
        Const AuthInfoQualifier As String = "00"
        Const AuthInfo As String = "          "
        Const TransmissionPassword As String = "HR6OX0F2  "
        Const InterchangeIDQualifier As String = "ZZ"
        Const SenderID As String = "0772-02        "
        Private ReadOnly Property PMSID() As Int32
            Get
                Return Convert.ToInt32(SenderID.Substring(0, 4))
            End Get
        End Property
        Const ReceiverID As String = "JCAHO          " '15 char
        Const InterchangeCtrlStdID As String = "J" '1 char
        Const InterchangeCtrlVersNum As String = "00307" '5 char
        Const AcknowledgementRequested As String = "0" '1 char
        Const TestIndicator As String = "P" '1 char
        Const ComponentElementSeparator As String = "~"
#End Region
#Region "Functional Group"
        Const FGSegmentID As String = "GS" '2 char
        Const FGFooterSegmentID As String = "GE" '2 char
        Const FunctionalIDCode As String = "HM" '2 char
        Const ResponsibleAgencyCode As String = "X" '2 char - yes I know it's only 1...
        Const Version As String = "003070001000" '12 char
#End Region
#Region "Transaction Set"
        Const TSSegmentID As String = "ST" '2 char
        Const TSFooterSegmentID As String = "SE" '2 char
        Const TranSetHcoCode As String = "OHL" '3 char
        Const TranSetCompCode As String = "OCL" '3 char
#End Region
#Region "body tags"
        Const HCOSegmentID As String = "ZHC"
        Const HCOPerformanceMeasureSegmentID As String = "ZP2"
        Const PerformanceItemDataQualifier As String = "M"
        Const HcoLevelSegmentID As String = "ZC2"
        Const CompPerformanceMeasureSegmentID As String = "ZP1"
        Const CompLevelSegmentID As String = "ZC1"
#End Region



        Dim FileText As StringBuilder
        Private _curDate As String
        Private _curTime As String
        Private _SegmentCounter As Int32 = 0
        Public Sub New()
            FileText = New StringBuilder()
            _curDate = Now.ToString("yyMMdd")
            _curTime = Now.ToString("HHmm")
        End Sub

#Region "header info"
        'Public Sub BuildFileHeader(ByVal FileControlNumber as String)
        '    BuildInterchangeControlHeader(FileControlNumber)
        'End Sub
        Public Sub BuildGroupHeader(ByVal FileType As X12FileType, ByVal GroupControlNumber As String)
            BuildFunctionalGroupHeader(GroupControlNumber)
            BuildTransactionSetHeader(FileType, GroupControlNumber)
        End Sub
        Public Sub BuildInterchangeControlHeader(ByVal ControlNumber As String)
            'Interchange Control Header
            With FileText
                .Append(ICSegmentID)
                .Append("*")
                .Append(AuthInfoQualifier)
                .Append("*")
                .Append(AuthInfo)
                .Append("*")
                .Append("01") 'Security information qualifier - only valid value is "01"
                .Append("*")
                .Append(TransmissionPassword)
                .Append("*")
                .Append(InterchangeIDQualifier)
                .Append("*")
                .Append(SenderID)
                .Append("*")
                .Append(InterchangeIDQualifier)
                .Append("*")
                .Append(ReceiverID)
                .Append("*")
                .Append(_curDate)
                .Append("*")
                .Append(_curTime)
                .Append("*")
                .Append(InterchangeCtrlStdID)
                .Append("*")
                .Append(InterchangeCtrlVersNum)
                .Append("*")
                .Append(ControlNumber)
                .Append("*")
                .Append(AcknowledgementRequested)
                .Append("*")
                .Append(TestIndicator)
                .Append("*")
                .Append(" ")
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
        Public Sub BuildFunctionalGroupHeader(ByVal ControlNumber As String)
            'Functional Group Header
            With FileText
                .Append(FGSegmentID)
                .Append("*")
                .Append(FunctionalIDCode)
                .Append("*")
                .Append(SenderID.Trim())
                .Append("*")
                .Append(ReceiverID.Trim())
                .Append("*")
                .Append(_curDate)
                .Append("*")
                .Append(_curTime)
                .Append("*")
                .Append(ControlNumber)
                .Append("*")
                .Append(ResponsibleAgencyCode)
                .Append("*")
                .Append(Version)
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
        Public Sub BuildTransactionSetHeader(ByVal FileType As X12FileType, ByVal ControlNumber As String)
            'Transaction Set Header
            _SegmentCounter = _SegmentCounter + 1
            With FileText
                .Append(TSSegmentID)
                .Append("*")
                If FileType = X12FileType.HCO Then
                    .Append(TranSetHcoCode)
                Else
                    .Append(TranSetCompCode)
                End If
                .Append("*")
                .Append(ControlNumber)
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
#End Region

#Region "body info"
        Public Sub BuildHCOGroupSegment(ByVal HCOID As Int32)
            _SegmentCounter = _SegmentCounter + 1
            With FileText
                .Append(HCOSegmentID)
                .Append("*")
                .Append(HCOID.ToString())
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
        Public Sub BuildHcoMeasurement(ByVal Measurement As OryxHcoData)
            BuildHcoLevelMeasurementIdentifier(Measurement)
            BuildHcoLevelMeasurementData(Measurement)
        End Sub
        Private Sub BuildHcoLevelMeasurementIdentifier(ByVal Measurement As OryxHcoData)
            _SegmentCounter = _SegmentCounter + 1
            With FileText
                .Append(HCOPerformanceMeasureSegmentID)
                .Append("*")
                .Append(Measurement.MeasureID.ToString())
                .Append("*")
                .Append(PerformanceItemDataQualifier)
                .Append("*")
                .Append(Month(Measurement.DataDate))
                .Append("*")
                .Append(Year(Measurement.DataDate))
                .Append("*")
                .Append(Measurement.DataSource) ' I think this is correct for "data received from health care org"
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
        Private Sub BuildHcoLevelMeasurementData(ByVal Measurement As OryxHcoData)
            If Measurement.DataSource = 2 _
            Or Measurement.DataSource = 3 _
            Or Measurement.DataSource = 5 Then
                Return 'we don't build ZC2 rows when we don't have any data
            End If
            _SegmentCounter = _SegmentCounter + 1
            With FileText
                .Append(HcoLevelSegmentID)
                .Append("*")
                .Append(Measurement.NumberOfCases)
                .Append("*")
                .Append(Measurement.Mean)
                .Append("*")
                .Append(Measurement.Median)
                .Append("*")
                .Append(Measurement.Min)
                .Append("*")
                .Append(Measurement.Max)
                .Append("*")
                .Append(Measurement.StandardDeviation) 'optional
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
        Public Sub BuildCompMeasurement(ByVal Measurement As OryxCompData)
            BuildCompMeasurementIdentifier(Measurement)
            BuildCompMeasurementData(Measurement)
        End Sub
        Private Sub BuildCompMeasurementIdentifier(ByVal Measurement As OryxCompData)
            _SegmentCounter = _SegmentCounter + 1
            With FileText
                .Append(CompPerformanceMeasureSegmentID)
                .Append("*")
                .Append(Measurement.MeasureID.ToString())
                .Append("*")
                .Append(PerformanceItemDataQualifier)
                .Append("*")
                .Append(Month(Measurement.DataDate))
                .Append("*")
                .Append(Year(Measurement.DataDate))
                .Append("*")
                .Append(Measurement.DataSource)
                .Append("*")
                .Append(Month(Measurement.StartingDate))
                .Append("*")
                .Append(Year(Measurement.StartingDate))
                .Append("*")
                .Append(Month(Measurement.EndingDate))
                .Append("*")
                .Append(Year(Measurement.EndingDate))
                .Append("*")
                .Append(Measurement.NumberOfHco)
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
        Private Sub BuildCompMeasurementData(ByVal Comp As OryxCompData)
            _SegmentCounter = _SegmentCounter + 1
            With FileText
                .Append(CompLevelSegmentID)
                .Append("*")
                .Append(Comp.NumOfCases)
                .Append("*")
                .Append(Comp.MeanAllCases)
                .Append("*")
                .Append(Comp.MedianAllCases)
                .Append("*")
                .Append(Comp.MinAllCases)
                .Append("*")
                .Append(Comp.MaxAllCases)
                .Append("*")
                .Append(Comp.MeanOfMeanValues)
                .Append("*")
                .Append(Comp.MedianOfMeanValues)
                .Append("*")
                .Append(Comp.MinMean)
                .Append("*")
                .Append(Comp.MaxMean)
                .Append("*")
                .Append(Comp.OverallMean)
                If Comp.NumberOfHco > 1 Then
                    .Append("*")
                    .Append(Comp.StandardDeviation)
                End If
                .Append(ComponentElementSeparator)
                .AppendLine()
            End With
        End Sub
#End Region

#Region "footer info"
        Public Sub BuildFileFooter(ByVal FileControlNumber As String)
            BuildInterchangeControlFooter(FileControlNumber)
        End Sub
        Public Sub BuildGroupFooter(ByVal GroupControlNumber As String)
            'Footer seems to be the same regardless if it is COMP or HCO
            BuildTransactionSetFooter(GroupControlNumber)
            BuildFunctionalGroupFooter(GroupControlNumber)
        End Sub
        Private Sub BuildTransactionSetFooter(ByVal ControlNumber As String)
            _SegmentCounter = _SegmentCounter + 1
            FileText.Append(TSFooterSegmentID)
            FileText.Append("*")
            FileText.Append(_SegmentCounter.ToString())
            FileText.Append("*")
            FileText.Append(ControlNumber)
            FileText.Append(ComponentElementSeparator)
            FileText.AppendLine()
        End Sub
        Private Sub BuildFunctionalGroupFooter(ByVal ControlNumber As String)
            FileText.Append(FGFooterSegmentID)
            FileText.Append("*")
            FileText.Append("1") ' number of sets included
            FileText.Append("*")
            FileText.Append(ControlNumber)
            FileText.Append(ComponentElementSeparator)
            FileText.AppendLine()
        End Sub
        Private Sub BuildInterchangeControlFooter(ByVal ControlNumber As String)
            With FileText
                .Append(ICFooterID)
                .Append("*")
                .Append("1") 'Number of functional groups
                .Append("*")
                .Append(ControlNumber)
                .Append(ComponentElementSeparator)
                .Append(Environment.NewLine)
            End With
        End Sub
#End Region
        Public Sub WriteFile(ByVal FullFilePath As String)
            System.IO.File.WriteAllText(FullFilePath, FileText.ToString())
        End Sub
    End Class
End Namespace