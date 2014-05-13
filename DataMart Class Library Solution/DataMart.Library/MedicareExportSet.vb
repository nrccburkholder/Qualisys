Public Class MedicareExportSet

#Region " Private Fields "
    Private mMedicareExportSetId As Integer
    Private mMedicareNumber As String = String.Empty
    Private mExportName As String = String.Empty
    Private mExportStartDate As Date
    Private mExportEndDate As Date
    Private mDirectsOnly As Boolean
    Private mReturnsOnly As Boolean
    Private mCreatedEmployeeName As String = String.Empty
    Private mExportFileGUID As Guid
    Private mExportSetTypeID As Integer
    Private mDateCreated As Date

    Private mIsDirty As Boolean

#End Region

#Region " Public Properties "
    Public Property MedicareExportSetId() As Integer
        Get
            Return mMedicareExportSetId
        End Get
        Friend Set(ByVal value As Integer)
            If Not value = mMedicareExportSetId Then
                mMedicareExportSetId = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property MedicareNumber() As String
        Get
            Return mMedicareNumber
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMedicareNumber Then
                mMedicareNumber = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ExportName() As String
        Get
            Return mExportName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mExportName Then
                mExportName = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ExportStartDate() As Date
        Get
            Return mExportStartDate
        End Get
        Set(ByVal value As Date)
            If Not value = mExportStartDate Then
                mExportStartDate = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ExportEndDate() As Date
        Get
            Return mExportEndDate
        End Get
        Set(ByVal value As Date)
            If Not value = mExportEndDate Then
                mExportEndDate = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property DirectsOnly() As Boolean
        Get
            Return mDirectsOnly
        End Get
        Set(ByVal value As Boolean)
            If Not value = mDirectsOnly Then
                mDirectsOnly = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ReturnsOnly() As Boolean
        Get
            Return mReturnsOnly
        End Get
        Set(ByVal value As Boolean)
            If Not value = mReturnsOnly Then
                mReturnsOnly = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property CreatedEmployeeName() As String
        Get
            Return mCreatedEmployeeName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCreatedEmployeeName Then
                mCreatedEmployeeName = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ExportFileGUID() As Guid
        Get
            Return mExportFileGUID
        End Get
        Set(ByVal value As Guid)
            If Not value = mExportFileGUID Then
                mExportFileGUID = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ExportSetTypeID() As Integer
        Get
            Return mExportSetTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportSetTypeID Then
                mExportSetTypeID = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property
#End Region


#Region " DB CRUD Methods "
    Public Shared Function [Get](ByVal medicareExportSetId As Integer) As MedicareExportSet
        Return DataProvider.Instance.SelectMedicareExportSet(medicareExportSetId)
    End Function

    Public Shared Function CreateNewMedicareExportSet(ByVal medicarenumber As String, ByVal exportname As String, ByVal startDate As Date, ByVal endDate As Date, ByVal directsOnly As Boolean, ByVal returnsOnly As Boolean, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As MedicareExportSet
        Dim exportGuid As Guid = Guid.NewGuid
        Dim newId As Integer = DataProvider.Instance.InsertMedicareExportSet(medicarenumber, exportname, startDate, endDate, directsOnly, returnsOnly, exportGuid, exportType, createdEmployeeName)
        Return DataProvider.Instance.SelectMedicareExportSet(newId)
    End Function

    Public Shared Function GetFileGUIDsByClientGroup(ByVal surveyType As SurveyType, ByVal clientGroupName As String, ByVal sign As String, ByVal startDate As Date, ByVal endDate As Date) As Collection(Of MedicareExportSet)
        Return DataProvider.Instance.SelectFileGUIDsByClientGroup(surveyType, clientGroupName, sign, startDate, endDate)
    End Function

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Resets the is Dirty Flag to false.
    ''' </summary>
    ''' <remarks>This method should be called after saving changes.</remarks>
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
#End Region

End Class
