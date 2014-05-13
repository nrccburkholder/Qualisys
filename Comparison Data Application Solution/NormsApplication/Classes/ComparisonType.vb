Option Strict On

Public Class ComparisonType

#Region " Private Fields"

    Private mTask As TaskType
    Private mCompTypeID As Integer
    Private mSelectionBox As String
    Private mSelectionType As String
    Private mDescription As String
    Private mNormType As NormType
    Private mNormParam As Integer

#End Region

#Region " Public Properties"

    Public Property Task() As TaskType
        Get
            Return Me.mTask
        End Get
        Set(ByVal Value As TaskType)
            mTask = Value
        End Set
    End Property

    Public Property CompTypeID() As Integer
        Get
            Return mCompTypeID
        End Get
        Set(ByVal Value As Integer)
            mCompTypeID = Value
        End Set
    End Property

    Public Property SelectionBox() As String
        Get
            Return mSelectionBox
        End Get
        Set(ByVal Value As String)
            mSelectionBox = Value
        End Set
    End Property

    Public Property SelectionType() As String
        Get
            Return mSelectionType
        End Get
        Set(ByVal Value As String)
            mSelectionType = Value
        End Set
    End Property

    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal Value As String)
            mDescription = Value
        End Set
    End Property

    Public Property NormType() As NormType
        Get
            Return mNormType
        End Get
        Set(ByVal Value As NormType)
            mNormType = Value
        End Set
    End Property

    Public Property NormParam() As Integer
        Get
            Return mNormParam
        End Get
        Set(ByVal Value As Integer)
            mNormParam = Value
        End Set
    End Property

    Public Property UnitIncludedInBenchmarkNorm() As Integer
        Get
            If (mNormType = NormType.BestNorm OrElse mNormType = NormType.WorstNorm) Then
                Return mNormParam
            Else
                Return 0
            End If
        End Get
        Set(ByVal Value As Integer)
            If (mNormType = NormType.BestNorm OrElse mNormType = NormType.WorstNorm) Then
                mNormParam = Value
            End If
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Shared Function DefaultNormParam(ByVal normType As NormType) As Integer
        Dim normParam As Integer

        Select Case normType
            Case normType.StandardNorm
                normParam = 0
            Case normType.BestNorm
                normParam = 1
            Case normType.WorstNorm
                normParam = 5
        End Select
        Return normParam
    End Function

#End Region

End Class
