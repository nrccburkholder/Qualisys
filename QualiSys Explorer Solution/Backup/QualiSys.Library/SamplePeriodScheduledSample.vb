Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

<Serializable()> _
Public Class SamplePeriodScheduledSample
    Inherits BusinessBase(Of SamplePeriodScheduledSample)

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mSamplePeriodId As Integer
    Private mSampleNumber As Integer
    Private mScheduledSampleDate As Date
    Private mSampleSetId As Nullable(Of Integer)
    Private mSampleSet As SampleSet
    Private mCanceled As Boolean
#End Region

#Region " Public Properties "

    <Logable()> _
    Public Property Canceled() As Boolean
        Get
            Return mCanceled
        End Get
        Set(ByVal value As Boolean)
            If mCanceled <> value Then
                PropertyHasChanged("Canceled")
                If value = True Then PropertyHasChanged("ActualSampleDate")
                mCanceled = value
            End If
        End Set
    End Property

    Public ReadOnly Property ActualSampleDate() As Nullable(Of Date)
        Get
            Dim actualDate As Nullable(Of Date)
            If Canceled Then
                actualDate = AppConfig.Params("CanceledSampleDefaultDate").DateValue
                Return actualDate
            End If

            If Not Me.SampleSet Is Nothing Then actualDate = Me.SampleSet.DateCreated
            Return actualDate
        End Get
    End Property

    <Logable()> _
    Public Property SamplePeriodId() As Integer
        Get
            Return mSamplePeriodId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSamplePeriodId Then
                mSamplePeriodId = value
                PropertyHasChanged("SamplePeriodId")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property SampleNumber() As Integer
        Get
            Return mSampleNumber
        End Get
        Set(ByVal value As Integer)
            If Not value = mSampleNumber Then
                mSampleNumber = value
                PropertyHasChanged("SampleNumber")
            End If
        End Set
    End Property

    <Logable()> _
    Public Property ScheduledSampleDate() As Date
        Get
            Return mScheduledSampleDate
        End Get
        Set(ByVal value As Date)
            If Me.ActualSampleDate.HasValue Then
                Throw New Exception("The scheduled sample date cannot be changed once the sample has been run or canceled.")
            End If

            If Not value = mScheduledSampleDate Then
                mScheduledSampleDate = value
                PropertyHasChanged("ScheduledSampleDate")
            End If
        End Set
    End Property

    Public Property SampleSetId() As Nullable(Of Integer)
        Get
            Return mSampleSetId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            If value.HasValue Then
                If SampleSetId.HasValue = False OrElse Not value.Value = mSampleSetId.Value Then
                    mSampleSetId = value
                    PropertyHasChanged("SampleSetId")
                End If
            Else
                If SampleSetId.HasValue Then
                    mSampleSetId = value
                    PropertyHasChanged("SampleSetId")
                End If
            End If
        End Set
    End Property

    Public Property SampleSet() As SampleSet
        Get
            'Lazy Populate
            If mSampleSet Is Nothing Then
                If Me.SampleSetId.HasValue Then mSampleSet = SampleSet.GetSampleSet(Me.SampleSetId.Value)
            End If
            Return mSampleSet
        End Get
        Set(ByVal value As SampleSet)
            If Not value.Id = mSampleSet.Id Then
                mSampleSet = value
                PropertyHasChanged("SampleSet")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSamplePeriodScheduledSample() As SamplePeriodScheduledSample
        Return New SamplePeriodScheduledSample
    End Function

    Public Shared Function GetBySamplePeriodId(ByVal SamplePeriodId As Integer) As SamplePeriodScheduledSampleCollection
        Return DataProvider.SamplePeriodScheduledSampleProvider.Instance.SelectSamplePeriodScheduledSamples(SamplePeriodId)
    End Function

    Public Shared Function [Get](ByVal SamplePeriodId As Integer, ByVal SampleNumber As Integer) As SamplePeriodScheduledSample
        Return DataProvider.SamplePeriodScheduledSampleProvider.Instance.SelectSamplePeriodScheduledSample(SamplePeriodId, SampleNumber)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return String.Format("{0}:{1}", mSamplePeriodId.ToString, mSampleNumber.ToString)
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.CommonRules.IntegerMinValueRuleArgs("SamplePeriodId", 0))
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        DataProvider.SamplePeriodScheduledSampleProvider.Instance.InsertSamplePeriodScheduledSample(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.SamplePeriodScheduledSampleProvider.Instance.UpdateSamplePeriodScheduledSample(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.SamplePeriodScheduledSampleProvider.Instance.DeleteSamplePeriodScheduledSample(mSamplePeriodId, mSampleNumber)
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>
    ''' Called after updating the database.  This will mark the object as clean.
    ''' </summary>
    ''' <remarks>This is only needed when not using the save method of the class.  The save method will
    ''' automatically mark as clean.</remarks>
    Public Sub FinishedUpdating()
        Me.MarkClean()
    End Sub

    ''' <summary>
    ''' Called after inserting a new item in the database.  This will mark the object as old.
    ''' </summary>
    ''' <remarks>This is only needed when not using the save method of the class.  The save method will
    ''' automatically mark as old.</remarks>
    Public Sub FinishedInserting()
        Me.MarkOld()
    End Sub
#End Region

End Class

<Serializable()> _
Public Class SamplePeriodScheduledSampleCollection
    Inherits BusinessListBase(Of SamplePeriodScheduledSampleCollection, SamplePeriodScheduledSample)

    Public ReadOnly Property DeletedItems() As List(Of SamplePeriodScheduledSample)
        Get
            Return Me.DeletedList
        End Get
    End Property

    Public Sub ClearDeletedItems()
        Me.DeletedList.Clear()
    End Sub

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SamplePeriodScheduledSample = SamplePeriodScheduledSample.NewSamplePeriodScheduledSample
        Me.Add(newObj)
        Return newObj
    End Function

    ''' <summary>
    ''' Removes the item in the collection that contains the specified Sample Number
    ''' </summary>
    ''' <param name="i"></param>
    ''' <remarks></remarks>
    Public Sub RemoveBySampleNumber(ByVal i As Integer)
        For Each sample As SamplePeriodScheduledSample In Me
            If sample.SampleNumber = i Then
                Me.Remove(sample)
                Exit For
            End If
        Next
    End Sub
End Class
