Public Class WeightType

    Public Enum ValidationCategories
        NameLength = 0
        ExportColumnNameLength = 1
        ExportColumnNameHasSpaces = 2
    End Enum

    Const MaxNameLength As Integer = 42
    Const MaxExportColumnNameLength As Integer = 8

#Region "Private Fields"
    Private mId As Integer
    Private mName As String
    Private mNeedsDelete As Boolean
    Private mIsDirty As Boolean
    Private mExportColumnName As String

    Private mValidationErrors As New Dictionary(Of ValidationCategories, String)
#End Region

#Region "constructors"
    Public Sub New()
        'Force property validation
        Me.Name = ""
        Me.ExportColumnName = ""
        Me.mIsDirty = True
    End Sub
#End Region

#Region "Public Properties"
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If Not (value.Length > 1 AndAlso value.Length <= MaxNameLength) Then
                If mValidationErrors.ContainsKey(ValidationCategories.NameLength) = False Then mValidationErrors.Add(ValidationCategories.NameLength, "Type Name '" + value + "' must be between 1 and " + MaxNameLength.ToString + " Characters.  Please change.")
            Else
                If mValidationErrors.ContainsKey(ValidationCategories.NameLength) Then mValidationErrors.Remove(ValidationCategories.NameLength)
            End If

            If value <> mName Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public Property ExportColumnName() As String
        Get
            Return mExportColumnName
        End Get
        Set(ByVal value As String)
            If Not (value.Length > 1 AndAlso value.Length <= MaxExportColumnNameLength) Then
                If mValidationErrors.ContainsKey(ValidationCategories.ExportColumnNameLength) = False Then mValidationErrors.Add(ValidationCategories.ExportColumnNameLength, "Export Column Name '" + value + "' must be between 1 and " + MaxExportColumnNameLength.ToString + " Characters.  Please change.")
            Else
                If mValidationErrors.ContainsKey(ValidationCategories.ExportColumnNameLength) Then mValidationErrors.Remove(ValidationCategories.ExportColumnNameLength)
            End If

            If value.Contains(" ") Then
                If mValidationErrors.ContainsKey(ValidationCategories.ExportColumnNameHasSpaces) = False Then mValidationErrors.Add(ValidationCategories.ExportColumnNameHasSpaces, "Export Column Name '" + value + "' has spaces.  Please remove all spaces.")
            Else
                If mValidationErrors.ContainsKey(ValidationCategories.ExportColumnNameHasSpaces) Then mValidationErrors.Remove(ValidationCategories.ExportColumnNameHasSpaces)
            End If

            If value <> mExportColumnName Then
                mExportColumnName = value
                mIsDirty = True
            End If
        End Set
    End Property

    Public ReadOnly Property IsNew() As Boolean
        Get
            Return mId = 0
        End Get
    End Property

    Public ReadOnly Property IsDeletable() As Boolean
        Get
            'Always query the database directly to ensure that we get the most current information
            Return DataProvider.Instance.IsWeightTypeDeletable(mId)
        End Get
    End Property

    Public Property NeedsDelete() As Boolean
        Get
            Return mNeedsDelete
        End Get
        Set(ByVal value As Boolean)
            mNeedsDelete = value
        End Set
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

    Public ReadOnly Property IsValid() As Boolean
        Get
            Return (mValidationErrors.Count = 0)
        End Get
    End Property

    Public ReadOnly Property ValidationErrors() As Dictionary(Of ValidationCategories, String)
        Get
            Return mValidationErrors
        End Get
    End Property
#End Region

#Region "Public Methods"
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
#End Region

#Region "DB CRUD"
    ''' <summary>
    ''' Loops through a collection of weight categories and determines the appropriate action to take
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared Sub UpdateWeightTypesCollection(ByVal weightTypes As Collection(Of WeightType))
        Dim deleteTypes As New Collection(Of WeightType)

        For Each type As WeightType In weightTypes
            If type.IsNew AndAlso type.NeedsDelete Then
                deleteTypes.Add(type)
            ElseIf type.IsNew AndAlso type.NeedsDelete = False Then
                type.Create()
            ElseIf type.NeedsDelete Then
                type.Delete()
                deleteTypes.Add(type)
            ElseIf type.IsDirty Then
                type.Update()
            End If
        Next

        For Each type As WeightType In deleteTypes
            weightTypes.Remove(type)
        Next
    End Sub

    Public Shared Function GetWeightTypes() As Collection(Of WeightType)
        Return DataProvider.Instance.SelectWeightTypes()
    End Function

    Public Shared Function GetWeightType(ByVal weightTypeId As Integer) As WeightType
        Return DataProvider.Instance.SelectWeightType(weightTypeId)
    End Function

    Public Sub Create()
        Dim id As Integer
        id = DataProvider.Instance.InsertWeightType(Me.Name, Me.ExportColumnName)
        Me.mId = id
    End Sub

    Public Sub Update()
        DataProvider.Instance.UpdateWeightType(Me.Id, Me.Name, Me.ExportColumnName)
        Me.mIsDirty = False
    End Sub

    Public Sub Delete()
        DataProvider.Instance.DeleteWeightType(Me.Id)
    End Sub
#End Region

#Region "Weight Loading Methods"
    Public Shared Function LoadWeightValues(ByVal studyId As Integer, ByVal rdr As IDataReader, ByVal samplePopIdColumnName As String, ByVal WeightValueColumnName As String, ByVal replace As Boolean, ByVal weightTypeId As Integer, ByVal employeeName As String) As Collection(Of String)
        Dim messages As Collection(Of String) = WeightType.LoadWeightData(studyId, rdr, samplePopIdColumnName, WeightValueColumnName, replace, weightTypeId, employeeName)
        Return messages
    End Function

    Private Shared Function LoadWeightData(ByVal studyId As Integer, ByVal rdr As IDataReader, ByVal samplePopIdColumnName As String, ByVal WeightValueColumnName As String, ByVal replace As Boolean, ByVal weightTypeId As Integer, ByVal employeeName As String) As Collection(Of String)
        Dim messages As New Collection(Of String)
        Try
            Dim tableName As String = DataProvider.Instance.CreateTemporaryWeightValuesTable(studyId)
            DataProvider.Instance.BulkLoadWeightValuesTable(rdr, samplePopIdColumnName, WeightValueColumnName, tableName)
            messages = DataProvider.Instance.InsertWeightValues(studyId, tableName, replace, weightTypeId, employeeName)
        Catch ex As SqlClient.SqlException
            Throw
        End Try
        Return messages
    End Function
#End Region
End Class
