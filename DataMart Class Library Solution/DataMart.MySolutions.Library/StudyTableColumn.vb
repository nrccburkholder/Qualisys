Imports Nrc.Framework.BusinessLogic

Public Interface IStudyTableColumn

    Property Id() As Integer
    Property TableId() As Integer
    Property Name() As String
    Property Description() As String
    Property DataType() As StudyTableColumn.ColumnDataType
    Property Length() As Integer
    Property StudyId() As Integer
    Property IsCalculated() As Boolean

End Interface

Public Class StudyTableColumn
    Inherits BusinessBase(Of StudyTableColumn)
    Implements IStudyTableColumn

    Public Enum ColumnDataType
        [Integer]
        [String]
        [DateTime]
    End Enum

#Region " Private Instance Fields "

#Region " Persisted Fields "
    Private mFieldId As Integer
    Private mTableId As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mDataType As ColumnDataType
    Private mLength As Integer
    Private mIsAvailableOnEReports As Boolean
    Private mDisplayName As String = String.Empty
    Private mIsCalculated As Boolean
    Private mFormula As String = String.Empty
    Private mStudyId As Integer
    Private mInstanceId As Guid = Guid.NewGuid

    Private mFormulaHasChanged As Boolean
#End Region

#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    Public Property FieldId() As Integer Implements IStudyTableColumn.Id
        Get
            Return mFieldId
        End Get
        Private Set(ByVal value As Integer)
            mFieldId = value
        End Set
    End Property

    Public Property StudyId() As Integer Implements IStudyTableColumn.StudyId
        Get
            Return mStudyId
        End Get
        Private Set(ByVal value As Integer)
            mStudyId = value
        End Set
    End Property

    Public Property TableId() As Integer Implements IStudyTableColumn.TableId
        Get
            Return mTableId
        End Get
        Private Set(ByVal value As Integer)
            mTableId = value
        End Set
    End Property

    Public Property Name() As String Implements IStudyTableColumn.Name
        Get
            Return mName
        End Get
        Private Set(ByVal value As String)
            mName = value
        End Set
    End Property

    Public Property Description() As String Implements IStudyTableColumn.Description
        Get
            Return mDescription
        End Get
        Private Set(ByVal value As String)
            mDescription = value
        End Set
    End Property

    Public Property DataType() As ColumnDataType Implements IStudyTableColumn.DataType
        Get
            Return mDataType
        End Get
        Private Set(ByVal value As ColumnDataType)
            mDataType = value
        End Set
    End Property

    Public Property Length() As Integer Implements IStudyTableColumn.Length
        Get
            Return mLength
        End Get
        Private Set(ByVal value As Integer)
            mLength = value
        End Set
    End Property

    Public Property IsAvailableOnEReports() As Boolean
        Get
            Return mIsAvailableOnEReports
        End Get
        Set(ByVal value As Boolean)
            If value <> mIsAvailableOnEReports Then
                mIsAvailableOnEReports = value
                Me.PropertyHasChanged()
                Me.PropertyHasChanged("Name")
                Me.PropertyHasChanged("DisplayName")
            End If
        End Set
    End Property

    Public Property IsCalculated() As Boolean Implements IStudyTableColumn.IsCalculated
        Get
            Return mIsCalculated
        End Get
        Private Set(ByVal value As Boolean)
            mIsCalculated = value
        End Set
    End Property

    Public Property DisplayName() As String
        Get
            Return mDisplayName
        End Get
        Set(ByVal value As String)
            If mDisplayName <> value Then
                mDisplayName = value
                Me.PropertyHasChanged()
                Me.PropertyHasChanged("Name")
            End If
        End Set
    End Property

    Public Property Formula() As String
        Get
            Return mFormula
        End Get
        Set(ByVal value As String)
            If mFormula <> value Then
                mFormula = value
                Me.PropertyHasChanged()
                mFormulaHasChanged = True
            End If
        End Set
    End Property

#End Region

    Public ReadOnly Property FormulaHasChanged() As Boolean
        Get
            Return mFormulaHasChanged
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
#End Region

#Region "Overrides"
    Public Overrides Sub EndPopulate()
        MyBase.EndPopulate()
        mFormulaHasChanged = False
    End Sub

    Protected Overrides Sub MarkOld()
        MyBase.MarkOld()
        mFormulaHasChanged = False
    End Sub

    Protected Overrides Function GetIdValue() As Object
        Return mInstanceId
    End Function

    Protected Overrides Sub AddBusinessRules()
        MyBase.AddBusinessRules()

        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Formula", 5000))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("DisplayName", 42))
        Me.ValidationRules.AddRule(AddressOf ValidateCalculatedFormulaExists, "Formula")
        Me.ValidationRules.AddRule(AddressOf ValidateStudyTableColumnFormula, "Formula")
        Me.ValidationRules.AddRule(AddressOf ValidateName, "Name")
        Me.ValidationRules.AddRule(AddressOf ValidateDisplayName, "DisplayName")
    End Sub

    Public Overrides Function ToString() As String
        Return mName
    End Function
#End Region

#Region " DB CRUD Methods "
    Public Shared Function GetStudyTableColumns(ByVal studyId As Integer, ByVal tableId As Integer) As Collection(Of StudyTableColumn)
        Return DataProvider.Instance.SelectStudyTableColumns(studyId, tableId)
    End Function

    Public Shared Function [Get](ByVal tableId As Integer, ByVal fieldId As Integer) As StudyTableColumn
        Return DataProvider.Instance.SelectStudyTableColumn(tableId, fieldId)
    End Function

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateStudyTableColumn(Me)
        Me.MarkOld()
    End Sub

    Public Shared Function ValidateStudyTableColumnFormula(ByVal studyId As Integer, ByVal formula As String, ByRef message As String) As Boolean
        Return DataProvider.Instance.ValidateStudyTableColumnFormula(studyId, formula, message)
    End Function

    Public Shared Function InsertCalculatedStudyTableColumn(ByVal studyId As Integer, ByVal name As String, ByVal description As String, ByVal displayName As String, ByVal formula As String, ByRef warningMessages As String) As StudyTableColumn
        Return DataProvider.Instance.InsertCalculatedStudyTableColumn(studyId, name, description, displayName, formula, warningMessages)
    End Function

#End Region

#Region "Validation Methods"
    Private Function ValidateCalculatedFormulaExists(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If IsCalculated Then
            If Me.Formula = String.Empty Then
                e.Description = "A formula must be specified for a calculated column."
                Return False
            End If
        End If
        Return True
    End Function

    Private Function ValidateStudyTableColumnFormula(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If IsCalculated Then
            Return StudyTableColumn.ValidateStudyTableColumnFormula(Me.StudyId, Me.Formula, e.Description)
        End If
        Return True
    End Function

    Private Function ValidateName(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.IsAvailableOnEReports AndAlso String.IsNullOrEmpty(DisplayName) Then
            'We can't use unit in the column name if there is no display name
            If Me.Name.ToLower.Contains("unit") Then
                e.Description = "'Unit' cannot be part of the name used in eReports.  Please specify a display name that does not include 'Unit'."
                Return False
            End If
        End If

        If Me.IsChild Then
            For Each column As StudyTableColumn In DirectCast(Me.Parent, StudyTableColumnList)
                'Verify that the name is not already in use
                If Not column.Equals(Me) Then
                    If column.Name.ToUpper = Me.Name.ToUpper Then
                        e.Description = "Specified name is already used.  Please change."
                        Return False
                    End If
                End If

                'Verify that the name doesn't match a display name
                If Not column.Equals(Me) Then
                    If column.DisplayName.ToUpper = Me.Name.ToUpper Then
                        e.Description = "Specified name matches a display name that is already used.  Please change."
                        Return False
                    End If
                End If
            Next
        End If
        Return True
    End Function

    Private Function ValidateDisplayName(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        If Me.IsAvailableOnEReports AndAlso Not String.IsNullOrEmpty(DisplayName) Then
            'We can't use unit in the display name
            If Me.DisplayName.ToLower.Contains("unit") Then
                e.Description = "'Unit' cannot be part of the display name.  Please specify a display name that does not include 'Unit'."
                Return False
            End If

            If Me.IsChild Then
                For Each column As StudyTableColumn In DirectCast(Me.Parent, StudyTableColumnList)
                    'Verify that the display name is not already in use
                    If Not column.Equals(Me) Then
                        If column.DisplayName.ToUpper = Me.DisplayName.ToUpper Then
                            e.Description = "Specified display name is already used.  Please change."
                            Return False
                        End If
                    End If

                    'Verify that the display name doesn't match a name
                    If Not column.Equals(Me) Then
                        If column.Name.ToUpper = Me.DisplayName.ToUpper Then
                            e.Description = "Specified display name matches a name that is already used.  Please change."
                            Return False
                        End If
                    End If
                Next
            End If
        End If
        Return True
    End Function
#End Region

End Class

