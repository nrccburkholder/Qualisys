Public Class USComparisonType
    Public Enum NormType
        StandardNorm = 1
        TopNPercent = 2
        BottomNPercent = 3
        IndividualPercentile = 4
        StandardPercentile = 5
        BestNorm = 6
        WorstNorm = 7
        DecileNorm = 8
    End Enum

#Region " Private Members"

    Private mCompTypeID As Integer
    Private mSelectionBox As String
    Private mSelectionType As String
    Private mDescription As String
    Private mNormType As NormType
    Private mNormParam As Integer
    Private mIndPercentileCompTypeID As Integer

    Private mChanged As Boolean

#End Region

#Region " Public Properties"

    Public ReadOnly Property Changed() As Boolean
        Get
            Return mChanged
        End Get
    End Property

    Public Property CompTypeID() As Integer
        Get
            Return mCompTypeID
        End Get
        Set(ByVal Value As Integer)
            mCompTypeID = Value
        End Set
    End Property

    Public Property IndPercentileCompTypeID() As Integer
        Get
            Return mIndPercentileCompTypeID
        End Get
        Set(ByVal Value As Integer)
            If mIndPercentileCompTypeID <> Value Then mChanged = True
            mIndPercentileCompTypeID = Value
        End Set
    End Property

    Public Property SelectionBox() As String
        Get
            Return mSelectionBox
        End Get
        Set(ByVal Value As String)
            If mSelectionBox <> Value Then mChanged = True
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
            If mDescription <> Value Then mChanged = True
            mDescription = Value
        End Set
    End Property

    Public Property USNormType() As NormType
        Get
            Return mNormType
        End Get
        Set(ByVal Value As NormType)
            mNormType = Value
            'set the default value for the NormParam
            Select Case mNormType
                Case NormType.StandardNorm
                    mNormParam = 0
                    mSelectionType = "N"
                Case NormType.BestNorm
                    mNormParam = 1
                    mSelectionType = "N"
                Case NormType.BottomNPercent
                    mSelectionType = "N"
                Case NormType.IndividualPercentile
                    mSelectionType = "I"
                Case NormType.StandardPercentile
                    mSelectionType = "P"
                Case NormType.TopNPercent
                    mSelectionType = "N"
                Case NormType.WorstNorm
                    mSelectionType = "N"
                Case NormType.DecileNorm
                    mSelectionType = "L"
            End Select
        End Set
    End Property

    Public Property NormParam() As Integer
        Get
            Return mNormParam
        End Get
        Set(ByVal Value As Integer)
            If mNormParam <> Value Then mChanged = True
            mNormParam = Value
        End Set
    End Property

#End Region

#Region " Public Methods"
    Public Function Save(ByVal NormID As Integer, ByVal memberID As Integer) As Integer
        If mChanged Then
            If mCompTypeID = 0 Then
                'New Comparison
                mCompTypeID = DataAccess.InsertUSComparisonType(NormID, mSelectionBox, mSelectionType, mDescription, mNormType, mNormParam, mIndPercentileCompTypeID, memberID)
                If mNormType = NormType.IndividualPercentile Then mIndPercentileCompTypeID = CompTypeID
            Else
                'Update Existing
                DataAccess.UpdateUSComparisonType(mCompTypeID, mSelectionBox, mDescription, mNormParam, memberID)
            End If
            'Reset the flag that indicates whether changes have occurred since the last save
            mChanged = False
            Return mCompTypeID
        End If
    End Function


    Public Shared Function GetallComparisons(ByVal norm_id As Integer) As USComparisonTypeCollection
        Dim ds As DataSet
        Dim tmpUSComparisonType As USComparisonType
        Dim tmpUSComparisonTypeCollection As New USComparisonTypeCollection
        ds = DataAccess.GetComparisonList(norm_id)
        For Each row As DataRow In ds.Tables(0).Rows
            tmpUSComparisonType = New USComparisonType
            With tmpUSComparisonType
                .mCompTypeID = row("CompType_ID")
                .mSelectionBox = row("Selection_Box")
                .mSelectionType = row("Selection_Type")
                .mDescription = row("Description")
                .mNormType = row("NormType")
                If Not row.IsNull("NormParam") Then .mNormParam = row("NormParam")
                If Not row.IsNull("IndPercCompType_ID") Then .mIndPercentileCompTypeID = row("IndPercCompType_ID")
            End With
            tmpUSComparisonTypeCollection.Add(tmpUSComparisonType)
        Next
        Return tmpUSComparisonTypeCollection
    End Function

#End Region
End Class
