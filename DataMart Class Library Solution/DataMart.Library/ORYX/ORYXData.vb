Imports System.Math
Imports System.Collections
Namespace ORYX


#Region "File Elements"
    Public Class OryxHcoData
        Implements IComparable

        Private _HCO As Int32
        Public ReadOnly Property HCO() As Int32
            Get
                Return _HCO
            End Get
        End Property
        Private _MeasureID As Int32
        Public ReadOnly Property MeasureID() As Int32
            Get
                Return _MeasureID
            End Get
        End Property
        Private _DataDate As Date
        Public ReadOnly Property DataDate() As Date
            Get
                Return _DataDate
            End Get
        End Property
        Private _DataSource As Int32
        Public ReadOnly Property DataSource() As Int32
            Get
                Return _DataSource
            End Get
        End Property
        Private _NumberOfCases As Int32 'used?
        Public ReadOnly Property NumberOfCases() As Int32
            Get
                Return _NumberOfCases
            End Get
        End Property


        'these only get set if Datasource = 1
        Private _Mean As Double
        Public ReadOnly Property Mean() As Double
            Get
                Return Round(_Mean, 6)
            End Get
        End Property
        Private _Median As Double
        Public ReadOnly Property Median() As Double
            Get
                Return Round(_Median, 6)
            End Get
        End Property
        Private _Min As Double
        Public ReadOnly Property Min() As Double
            Get
                Return Round(_Min, 6)
            End Get
        End Property
        Private _Max As Double
        Public ReadOnly Property Max() As Double
            Get
                Return Round(_Max, 6)
            End Get
        End Property
        Private _StandardDeviation As Double
        Public ReadOnly Property StandardDeviation() As Double
            Get
                Return Round(_StandardDeviation, 6)
            End Get
        End Property
        Private _Scores As New List(Of Double)
        Public Property Scores() As List(Of Double)
            Get
                Return _Scores
            End Get
            Set(ByVal value As List(Of Double))
                _Scores = value
            End Set
        End Property
        Public Sub New()

        End Sub
        Public Sub New(ByVal HCO As Int32, ByVal MeasureID As Int32, ByVal DateMeasured As Date, ByVal DataSource As Int32, ByVal NumberOfCases As Int32, ByVal Mean As Double, ByVal Median As Double, ByVal Min As Double, ByVal Max As Double, ByVal StDev As Double, ByVal Scores As List(Of Double))
            Initialize(HCO, MeasureID, DateMeasured, DataSource, NumberOfCases, Mean, Median, Min, Max, StDev, Scores)
        End Sub
        Public Sub Initialize(ByVal HCO As Int32, ByVal MeasureID As Int32, ByVal DateMeasured As Date, ByVal DataSource As Int32, ByVal NumberOfCases As Int32, ByVal Mean As Double, ByVal Median As Double, ByVal Min As Double, ByVal Max As Double, ByVal StDev As Double, ByVal Scores As List(Of Double))
            _HCO = HCO
            _MeasureID = MeasureID
            _DataDate = DateMeasured
            _DataSource = DataSource
            _NumberOfCases = NumberOfCases
            _Mean = Mean
            _Median = Median
            _Min = Min
            _Max = Max
            _StandardDeviation = StDev
            _Scores = Scores
        End Sub
        Public Function CompareTo(ByVal x As Object) As Integer Implements System.IComparable.CompareTo
            Dim xx As OryxHcoData
            If TypeOf x Is OryxHcoData Then
                xx = CType(x, OryxHcoData)
            Else
                Return -1
            End If
            Return MeasureID.CompareTo(xx.MeasureID)
        End Function
    End Class

    Public Class OryxCompData
        Implements IComparable
        'ZP1 info
        Private _MeasureID As Int32
        Public ReadOnly Property MeasureID() As Int32
            Get
                Return _MeasureID
            End Get
        End Property
        Private _DataDate As Date
        Public ReadOnly Property DataDate() As Date
            Get
                Return _DataDate
            End Get
        End Property
        Private _DataSource As Int32
        Public ReadOnly Property DataSource() As Int32
            Get
                Return _DataSource
            End Get
        End Property
        Private _StartingDate As Date
        Public ReadOnly Property StartingDate() As Date
            Get
                Return _StartingDate
            End Get
        End Property
        Private _EndingDate As Date
        Public ReadOnly Property EndingDate() As Date
            Get
                Return _EndingDate
            End Get
        End Property
        Private _NumberOfHco As Int32
        Public ReadOnly Property NumberOfHco() As Int32
            Get
                Return _NumberOfHco
            End Get
        End Property

        'ZC1 info
        Private _NumOfCases As Int32
        Public ReadOnly Property NumOfCases() As Int32
            Get
                Return _NumOfCases
            End Get
        End Property
        Private _MeanAllCases As Double
        Public ReadOnly Property MeanAllCases() As Double
            Get
                Return Round(_MeanAllCases, 1)
            End Get
        End Property
        Private _MedianAllCases As Double
        Public ReadOnly Property MedianAllCases() As Double
            Get
                Return Round(_MedianAllCases, 1)
            End Get
        End Property
        Private _MinAllCases As Int32
        Public ReadOnly Property MinAllCases() As Int32
            Get
                Return _MinAllCases
            End Get
        End Property
        Private _MaxAllCases As Int32
        Public ReadOnly Property MaxAllCases() As Int32
            Get
                Return _MaxAllCases
            End Get
        End Property
        Private _MeanOfMeanValues As Double
        Public ReadOnly Property MeanOfMeanValues() As Double
            Get
                Return Round(_MeanOfMeanValues, 6)
            End Get
        End Property
        Private _MedianOfMedianValues As Double
        Public ReadOnly Property MedianOfMeanValues() As Double
            Get
                Return Round(_MedianOfMedianValues, 6)
            End Get
        End Property
        Private _MinMean As Double
        Public ReadOnly Property MinMean() As Double
            Get
                Return Round(_MinMean, 6)
            End Get
        End Property
        Private _MaxMean As Double
        Public ReadOnly Property MaxMean() As Double
            Get
                Return Round(_MaxMean, 6)
            End Get
        End Property
        Private _OverallMean As Double
        Public ReadOnly Property OverallMean() As Double
            Get
                Return Round(_OverallMean, 6)
            End Get
        End Property
        Private _StandardDeviation As Double
        Public ReadOnly Property StandardDeviation() As Double
            Get
                Return Round(_StandardDeviation, 6)
            End Get
        End Property

        Public Sub New(ByVal MeasureID As Int32, _
            ByVal DataSource As Int32, _
        ByVal DataDate As Date, _
            ByVal StartingDate As Date, _
            ByVal EndingDate As Date, _
            ByVal NumberOfHCO As Int32, _
            ByVal NumberOfCases As Int32, _
            ByVal MeanAllCases As Double, _
            ByVal MedianAllCases As Double, _
            ByVal MinAllCases As Int32, _
            ByVal MaxAllCases As Int32, _
            ByVal MeanMeanValue As Double, _
            ByVal MedianMedianValue As Double, _
            ByVal MinMean As Double, _
            ByVal MaxMean As Double, _
            ByVal OverallMean As Double, _
            ByVal StdDev As Double)
            _MeasureID = MeasureID
            _DataSource = DataSource
            _DataDate = DataDate
            _StartingDate = StartingDate
            _EndingDate = EndingDate
            _NumberOfHco = NumberOfHCO
            _NumOfCases = NumberOfCases
            _MeanAllCases = MeanAllCases
            _MedianAllCases = MedianAllCases
            _MinAllCases = MinAllCases
            _MaxAllCases = MaxAllCases
            _MeanOfMeanValues = MeanMeanValue
            _MedianOfMedianValues = MedianMedianValue
            _MinMean = MinMean
            _MaxMean = MaxMean
            _OverallMean = OverallMean
            _StandardDeviation = StdDev
        End Sub
        Public Function CompareTo(ByVal x As Object) As Integer Implements System.IComparable.CompareTo
            Dim xx As OryxCompData
            If TypeOf x Is OryxCompData Then
                xx = CType(x, OryxCompData)
            Else
                Return -1
            End If
            Return MeasureID.CompareTo(xx.MeasureID)
        End Function
    End Class
#End Region
 

    Public Class OryxMeasurement
        Private _measurementID As Int32
        Public ReadOnly Property MeasurementID() As Int32
            Get
                Return _measurementID
            End Get
        End Property
        Private _questions As List(Of OryxQuestion)
        Public ReadOnly Property Questions() As List(Of OryxQuestion)
            Get
                Return _questions
            End Get
        End Property
        Public Sub New(ByVal MeasurementID As Int32)
            _measurementID = MeasurementID
            _questions = New List(Of OryxQuestion)
            LoadQuestions()
        End Sub
        Private Sub LoadQuestions()
            Dim questions As List(Of Int32)
            questions = DataProvider.Instance.SelectOryxQuestions(MeasurementID)
            For Each q As Int32 In questions
                _questions.Add(New OryxQuestion(q))
            Next
        End Sub

    End Class

    Public Class OryxQuestion
        Private _QuestionID As Int32
        Public ReadOnly Property QuestionID() As Int32
            Get
                Return _QuestionID
            End Get
        End Property
        Private Mappings As Dictionary(Of Int32, Nullable(Of Int32))
        Public Sub New(ByVal QstnID As Int32)
            _QuestionID = QstnID
            LoadMappings()
        End Sub
        Private Sub LoadMappings()
            Mappings = DataProvider.Instance.SelectOryxAnswerMappings(QuestionID)
        End Sub
        Public Function MapAnswer(ByVal Value As Int32) As Nullable(Of Int32)
            If Mappings.ContainsKey(Value) Then
                Return Mappings(Value)
            End If
            Return Nothing
        End Function
    End Class

End Namespace
