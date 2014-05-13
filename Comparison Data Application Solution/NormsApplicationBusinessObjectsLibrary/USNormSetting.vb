Public Class USNormSetting

#Region " Private Members"

    Private mNormLabel As String
    Private mNormID As Integer
    Private mNormDescription As String
    Private mMinClientCheck As Boolean = True
    Private mCriteriaStatement As String
    Private mMonthSpan As Integer = 36
    Private mOngoing As Boolean = True
    Private mComparisons As New USComparisonTypeCollection
    Private mMinDate As DateTime
    Private mMaxDate As DateTime
    Private mLastUpdate As DateTime

    Private mChanged As Boolean
#End Region

#Region " Public Properties"

    Public Property Changed() As Boolean

        Get
            If mChanged = True Then
                Return True
            Else
                For Each comparison As USComparisonType In mComparisons
                    If comparison.Changed Then Return True
                Next
            End If
            Return False
        End Get
        Set(ByVal value As Boolean)
            mChanged = value
        End Set
    End Property

    Public Property NormID() As Integer
        Get
            Return mNormID
        End Get
        Set(ByVal Value As Integer)
            mNormID = Value
        End Set
    End Property

    Public Property NormLabel() As String
        Get
            Return mNormLabel
        End Get
        Set(ByVal Value As String)
            If mNormLabel <> Value Then mChanged = True
            mNormLabel = Value
        End Set
    End Property

    Public Property NormDescription() As String
        Get
            Return mNormDescription
        End Get
        Set(ByVal Value As String)
            If mNormDescription <> Value Then mChanged = True
            mNormDescription = Value
        End Set
    End Property

    Public Property CriteriaStatement() As String
        Get
            Return mCriteriaStatement
        End Get
        Set(ByVal Value As String)
            If mCriteriaStatement <> Value Then mChanged = True
            mCriteriaStatement = Value
        End Set
    End Property

    Public Property MinClientCheck() As Boolean
        Get
            Return mMinClientCheck
        End Get
        Set(ByVal Value As Boolean)
            If mMinClientCheck <> Value Then mChanged = True
            mMinClientCheck = Value
        End Set
    End Property

    Public Property Ongoing() As Boolean
        Get
            Return mOngoing
        End Get
        Set(ByVal Value As Boolean)
            If mOngoing <> Value Then mChanged = True
            mOngoing = Value
        End Set
    End Property

    Public Property MonthSpan() As Integer
        Get
            Return mMonthSpan
        End Get
        Set(ByVal Value As Integer)
            If mMonthSpan <> Value Then mChanged = True
            mMonthSpan = Value
        End Set
    End Property

    Public ReadOnly Property Comparisons() As USComparisonTypeCollection
        Get
            Return mComparisons
        End Get
    End Property

    Public Property MinDate() As DateTime
        Get
            Return mMinDate
        End Get
        Set(ByVal Value As DateTime)
            mMinDate = Value
        End Set
    End Property

    Public Property MaxDate() As DateTime
        Get
            Return mMaxDate
        End Get
        Set(ByVal Value As DateTime)
            mMaxDate = Value
        End Set
    End Property

    Public Property LastUpdate() As DateTime
        Get
            Return mLastUpdate
        End Get
        Set(ByVal Value As DateTime)
            mLastUpdate = Value
        End Set
    End Property
#End Region

#Region " Public Methods"
    Public Sub PopulateNorm()
        DataAccess.PopulateNorm(mNormID)
    End Sub

    Public Overrides Function ToString() As String
        Return mNormLabel
    End Function

    Public Shared Function GetAllNorms(ByVal UseProduction As Boolean) As USNormSettingCollection
        Dim ds As DataSet
        Dim tmpUSNormSetting As USNormSetting
        Dim tmpUSNormSettingCollection As New USNormSettingCollection
        ds = DataAccess.GetUSNormList(UseProduction)
        For Each row As DataRow In ds.Tables(0).Rows
            tmpUSNormSetting = New USNormSetting
            tmpUSNormSetting.mNormID = row("Norm_id")
            tmpUSNormSetting.mNormDescription = row("normdescription")
            tmpUSNormSetting.mNormLabel = row("NormLabel")
            tmpUSNormSetting.mCriteriaStatement = row("CriteriaStatement")
            tmpUSNormSetting.mOngoing = row("bitOngoing")
            tmpUSNormSetting.mMonthSpan = row("MonthSpan")
            tmpUSNormSetting.mMinClientCheck = row("bitMinClientCheck")
            tmpUSNormSetting.mMinDate = row("minDate")
            tmpUSNormSetting.mMaxDate = row("maxDate")
            If Not row.IsNull("updatedate") Then tmpUSNormSetting.mLastUpdate = row("updatedate")
            tmpUSNormSetting.mComparisons = USComparisonType.GetallComparisons(row("Norm_id"))
            tmpUSNormSettingCollection.Add(tmpUSNormSetting)
        Next
        Return tmpUSNormSettingCollection
    End Function

    Public Sub AddComparison(ByVal comparison As USComparisonType)
        mComparisons.Add(comparison)
    End Sub

    Public Sub DeleteComparison(ByVal comparison As USComparisonType)
        mComparisons.Remove(comparison)
    End Sub

    Public Sub Save(ByVal memberID As Integer)
        'The member mChanged only checks to see if the norm settings have changed.
        'The Changed property checks to see if the norm settings have changed or if
        'any of the comparisons in the mcomparisons collection have changed.
        If Changed Then
            If mNormID = 0 And mChanged Then
                'New Norm
                mNormID = DataAccess.InsertUSNormSetting(mNormLabel, mNormDescription, mMinClientCheck, mCriteriaStatement, mMonthSpan, mOngoing, memberID)
            ElseIf mChanged Then
                'Update Existing
                DataAccess.UpdateUSNormSetting(mNormID, mNormLabel, mNormDescription, mMinClientCheck, mCriteriaStatement, mMonthSpan, mOngoing, memberID)
            End If

            'We want to save the comparisons, but we must first save the individual percentile comparison so we can
            'get its ID and add it to the standard percentile type norms
            For Each comparison As USComparisonType In mComparisons
                If comparison.USNormType = USComparisonType.NormType.IndividualPercentile Then
                    If comparison.Changed Then comparison.save(mNormID, memberID)
                    For Each tmpComparison As USComparisonType In mComparisons
                        If tmpComparison.USNormType = USComparisonType.NormType.StandardPercentile OrElse tmpComparison.USNormType = USComparisonType.NormType.DecileNorm Then
                            tmpComparison.IndPercentileCompTypeID = comparison.CompTypeID
                        End If
                    Next
                    Exit For
                End If
            Next
            'Save the rest of the comparisons
            For Each comparison As USComparisonType In mComparisons
                If comparison.Changed And Not comparison.USNormType = USComparisonType.NormType.IndividualPercentile Then
                    comparison.save(mNormID, memberID)
                End If
            Next
            mChanged = False
        End If
    End Sub

#End Region

End Class
