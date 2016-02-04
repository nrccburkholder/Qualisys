Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_ColumnDefinition
    Property ColumnDefID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_ColumnDefinition
    Inherits BusinessBase(Of SPTI_ColumnDefinition)
    Implements ISPTI_ColumnDefinition

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mColumnDefID As Integer
    Private mFileTemplateID As Integer
    Private mName As String = String.Empty
    Private mOrdinal As Integer
    Private mFixedStringLength As Integer
    Private mDateTypeID As Integer
    Private mDateCreated As Date
    Private mActive As Integer
    Private mArchive As Integer
    Private mDataType As SPTI_DataType = Nothing
    Private mFormatingRuleID As Integer
    Private mFormatingRule As SPTI_FormattingRule = Nothing
#End Region

#Region " Public Properties "
    ''' <summary>Unique ID</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ColumnDefID() As Integer Implements ISPTI_ColumnDefinition.ColumnDefID
        Get
            Return mColumnDefID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mColumnDefID Then
                mColumnDefID = value
                PropertyHasChanged("ColumnDefID")
            End If
        End Set
    End Property
    ''' <summary>FK to the owning file template</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FileTemplateID() As Integer
        Get
            Return mFileTemplateID
        End Get
        Set(ByVal value As Integer)
            If Not value = mFileTemplateID Then
                mFileTemplateID = value
                PropertyHasChanged("FileTemplateID")
            End If
        End Set
    End Property
    ''' <summary>Name of the column def</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    ''' <summary>The order of the column def relative to others owned by the file template.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Ordinal() As Integer
        Get
            Return mOrdinal
        End Get
        Set(ByVal value As Integer)
            If Not value = mOrdinal Then
                mOrdinal = value
                PropertyHasChanged("Ordinal")
            End If
        End Set
    End Property
    ''' <summary>If fixed length col, this tells the width if this column.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FixedStringLength() As Integer
        Get
            Return mFixedStringLength
        End Get
        Set(ByVal value As Integer)
            If Not value = mFixedStringLength Then
                mFixedStringLength = value
                PropertyHasChanged("FixedStringLength")
            End If
        End Set
    End Property
    ''' <summary>Tells what data type the column is.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DateTypeID() As Integer
        Get
            Return mDateTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mDateTypeID Then
                mDateTypeID = value
                Me.mDataType = Nothing
                PropertyHasChanged("DateTypeID")
            End If
        End Set
    End Property
    ''' <summary>data the column was added to the db.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    ''' <summary></summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Active() As Integer
        Get
            Return mActive
        End Get
        Set(ByVal value As Integer)
            If Not value = mActive Then
                mActive = value
                PropertyHasChanged("Active")
            End If
        End Set
    End Property
    ''' <summary></summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Archive() As Integer
        Get
            Return mArchive
        End Get
        Set(ByVal value As Integer)
            If Not value = mArchive Then
                mArchive = value
                PropertyHasChanged("Archive")
            End If
        End Set
    End Property
    ''' <summary>BO representation of the data type for the column.  Used in gui binding.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DataType() As SPTI_DataType
        Get
            If Me.mDataType Is Nothing Then
                Me.mDataType = SPTI_DataType.Get(Me.mDateTypeID)
            End If
            Return Me.mDataType
        End Get
        Set(ByVal value As SPTI_DataType)
            If Not Me.mDataType.DateTypeID = value.DateTypeID Then
                Me.mDataType = value
                PropertyHasChanged("DataType")
            End If            
        End Set
    End Property
    ''' <summary>BO representation of the formatting rule.  Used in gui binding.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FormatingRule() As SPTI_FormattingRule
        Get
            If Me.mFormatingRule Is Nothing Then
                Me.mFormatingRule = SPTI_FormattingRule.Get(Me.mFormatingRuleID)
            End If
            Return Me.mFormatingRule
        End Get
        Set(ByVal value As SPTI_FormattingRule)
            If Not Me.mFormatingRule.FormatingRuleID = value.FormatingRuleID Then
                Me.mFormatingRule = value
                PropertyHasChanged("FormatingRule")
            End If
        End Set
    End Property
    ''' <summary>Used in gui binding.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property DataTypeName() As String
        Get
            Return Me.DataType.Name
        End Get
    End Property
    ''' <summary>Used in gui binding.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property FormatingRuleName() As String
        Get
            Return Me.FormatingRule.Name
        End Get
    End Property
    ''' <summary>ID of the formatting rule tied to this column.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FormatingRuleID() As Integer
        Get
            Return Me.mFormatingRuleID
        End Get
        Set(ByVal value As Integer)
            If Not Me.FormatingRuleID = value Then
                Me.mFormatingRuleID = value
                Me.mFormatingRule = Nothing
                PropertyHasChanged("FormatingRuleID")
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    ''' <summary>Default used by DAL</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New()
        Me.CreateNew()
    End Sub
    ''' <summary>Use this when prepopulating values.</summary>
    ''' <param name="fileTemplateID"></param>
    ''' <param name="name"></param>
    ''' <param name="ordinal"></param>
    ''' <param name="fixedStringLength"></param>
    ''' <param name="dataTypeID"></param>
    ''' <param name="formatingRuleID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New(ByVal fileTemplateID As Integer, ByVal name As String, ByVal ordinal As Integer, ByVal fixedStringLength As Integer, ByVal dataTypeID As Integer, ByVal formatingRuleID As Integer)
        Me.CreateNew()
        Me.FileTemplateID = fileTemplateID
        Me.Name = name
        Me.Ordinal = ordinal
        Me.FixedStringLength = fixedStringLength
        Me.DateTypeID = dataTypeID
        Me.FormatingRuleID = formatingRuleID
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSPTI_ColumnDefinition() As SPTI_ColumnDefinition
        Return New SPTI_ColumnDefinition
    End Function
    Public Shared Function NewSPTI_ColumnDefinition(ByVal fileTemplateID As Integer, ByVal name As String, ByVal ordinal As Integer, ByVal fixedStringLength As Integer, ByVal dataTypeID As Integer, ByVal formatingRuleID As Integer) As SPTI_ColumnDefinition
        Return New SPTI_ColumnDefinition(fileTemplateID, name, ordinal, fixedStringLength, dataTypeID, formatingRuleID)
    End Function
    Public Shared Function [Get](ByVal columnDefID As Integer) As SPTI_ColumnDefinition
        Return DataProviders.SPTI_ColumnDefinitionsProvider.Instance.SelectSPTI_ColumnDefinition(columnDefID)
    End Function

    Public Shared Function GetAll() As SPTI_ColumnDefinitionCollection
        Return DataProviders.SPTI_ColumnDefinitionsProvider.Instance.SelectAllSPTI_ColumnDefinitions()
    End Function
#End Region
    ''' <summary>Return column collection by file template id.</summary>
    ''' <param name="fileTemplateID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetByFileTemplateID(ByVal fileTemplateID As Integer) As SPTI_ColumnDefinitionCollection
        Return DataProviders.SPTI_ColumnDefinitionsProvider.Instance.SelectSPTI_ColumnDefinitionsByFileTemplateID(fileTemplateID)
    End Function
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mColumnDefID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf ValidateColumnName, "Name")
    End Sub
    Public Function ValidateColumnName(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean        
        Dim tempArray() As String = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", _
                                    "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", _
                                    "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", _
                                    "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "_"}
        Dim charList As New List(Of String)(tempArray)
        If Me.mName.Length = 0 Then
            e.Description = "Column Name can not be empty"
            Return False
        ElseIf Me.mName.ToLower = "id" Then
            e.Description = "Can not name your column defintion 'ID'"
            Return False
        Else
            Dim firstChar As String = Me.mName.Substring(0, 1)
            If Not charList.Contains(firstChar) OrElse firstChar = "_" OrElse IsNumeric(firstChar) Then
                e.Description = "The first character of the column name must be A-Z"
                Return False
            End If
            Dim blnInValid As Boolean = False
            For Each c As Char In Me.mName.ToCharArray
                If Not charList.Contains(CStr(c)) Then
                    e.Description = "Column Name contains 1 or more invalid characters"
                    Return False
                End If
            Next
        End If
        Return True
    End Function
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>Add new column def to the dal</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        ColumnDefID = DataProviders.SPTI_ColumnDefinitionsProvider.Instance.InsertSPTI_ColumnDefinition(Me)
    End Sub

    ''' <summary>Update column def to the dal.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        DataProviders.SPTI_ColumnDefinitionsProvider.Instance.UpdateSPTI_ColumnDefinition(Me)
    End Sub

    ''' <summary>Delete column def from the dal.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        DataProviders.SPTI_ColumnDefinitionsProvider.Instance.DeleteSPTI_ColumnDefinition(mColumnDefID)
    End Sub

#End Region

#Region " Public Methods "
    Friend Function GetColumnCreateSQL(ByVal importAsString As Boolean) As String
        Dim retVal As String = ""
        retVal = "[" & Me.Name & "] "
        If importAsString Then
            retVal += "[varchar] (2000) NULL"
        Else
            Select Case Me.DateTypeID
                Case 1   'String
                    retVal += "[varchar] (2000) NULL"
                Case 2   ' Integer
                    retVal += "[int] NULL"
                Case 3   'Decimal
                    retVal += "[decimal] (18,4) NULL"
                Case 4   'DateTime
                    retVal += "[datetime] NULL"
                Case 5   'Memo
                    retVal += "[varchar] (2000) NULL"
                Case Else 'Default to varchar
                    retVal += "[varchar] (2000) NULL"
            End Select
        End If        
        Return retVal
    End Function
    Friend Function GetColumnName() As String
        Return "[" & Me.Name & "]"
    End Function
    Friend Function GetFormatedColumnValue(ByVal value As Object, ByVal isFixedLength As Boolean, ByVal trimString As Boolean, ByVal delimeterValue As String) As String
        Dim retVal As String
        If IsDBNull(value) Then
            retVal = ""
        Else
            retVal = CStr(value)
        End If
        If trimString Then
            retVal = Trim(retVal)
        End If
        'IIf short date, then format mm/dd/yyyy
        If IsDate(retVal) Then
            If retVal.Length = 9 OrElse retVal.Length = 8 Then
                retVal = CDate(retVal).ToString("MM/dd/yyyy")
            End If
        End If
        If isFixedLength Then
            retVal = retVal.PadRight(Me.FixedStringLength)
        Else
            'Must Encapsulate delimiters.
            If retVal.IndexOf(delimeterValue) >= 0 Then
                retVal = Replace(retVal, Chr(34), "/" & Chr(34))
                retVal = Chr(34) & retVal & Chr(34)
            End If
        End If
        Return retVal
    End Function
#End Region

End Class