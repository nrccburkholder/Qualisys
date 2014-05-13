Imports NRC.Framework.BusinessLogic
Imports System.ComponentModel

Public Interface IQUALPRO_PARAMS
    Property ParamId() As Integer
End Interface

<Serializable()> _
Public Class QualproParams
    Inherits BusinessBase(Of QualproParams)
    Implements IQUALPRO_PARAMS
    Implements ComponentModel.IDataErrorInfo


#Region " Private Fields "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mParamId As Integer
    Private mParamName As String = String.Empty
    Private mParam_Type As String = String.Empty
    Private mParamGroup As String = String.Empty
    Private mStrParamValue As String = String.Empty
    Private mNumParamValue As Nullable(Of Integer) = Nothing
    Private mDATPARAM_VALUE As Nullable(Of Date) = Nothing
    Private mComments As String = String.Empty
#End Region
#Region " Public Properties "
    Public Property PARAM_ID() As Integer Implements IQUALPRO_PARAMS.ParamId
        Get
            Return mParamId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mParamId Then
                mParamId = value
            End If
        End Set
    End Property
    Public Property STRPARAM_NM() As String
        Get
            Return mParamName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mParamName Then
                mParamName = value
                PropertyHasChanged("STRPARAM_NM")
                ValidationRules.CheckRules("PARAM_ID")
            End If
        End Set
    End Property
    Public Property STRPARAM_TYPE() As String
        Get
            Return mParam_Type
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mParam_Type Then
                mParam_Type = UCase(value)
                PropertyHasChanged("STRPARAM_TYPE")
                ValidationRules.CheckRules("PARAM_ID")
            End If
        End Set
    End Property
    Public Property STRPARAM_GRP() As String
        Get
            Return mParamGroup
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mParamGroup Then
                mParamGroup = value
                PropertyHasChanged("STRPARAM_GRP")
            End If
        End Set
    End Property
    Public Property STRPARAM_VALUE() As String
        Get
            Return mStrParamValue
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStrParamValue Then
                mStrParamValue = value
                PropertyHasChanged("STRPARAM_VALUE")
                'This will check for the whole object to be vlid
                ValidationRules.CheckRules("PARAM_ID")
            End If
        End Set
    End Property
    Public Property NUMPARAM_VALUE() As Nullable(Of Integer)
        Get
            Return mNumParamValue
        End Get
        Set(ByVal value As Nullable(Of Integer))
            mNumParamValue = value
            PropertyHasChanged("NUMPARAM_VALUE")
            'This will check for the whole object to be vlid
            ValidationRules.CheckRules("PARAM_ID")
        End Set
    End Property
    Public Property DATPARAM_VALUE() As Nullable(Of Date)
        Get
            Return mDATPARAM_VALUE
        End Get
        Set(ByVal value As Nullable(Of Date))
            mDATPARAM_VALUE = value
            PropertyHasChanged("DATPARAM_VALUE")
            'This will check for the whole object to be vlid
            ValidationRules.CheckRules("PARAM_ID")
        End Set
    End Property
    Public Property COMMENTS() As String
        Get
            Return mComments
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mComments Then
                mComments = value
                PropertyHasChanged("COMMENTS")
            End If
        End Set
    End Property

#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Methods "
    Public Shared Function NewQualproParams() As QualproParams
        Return New QualproParams()
    End Function
    Public Shared Function [Get](ByVal pARAMId As Integer) As QualproParams
        Return QualproParamsProvider.Instance.SelectQUALPRO_PARAMS(pARAMId)
    End Function
    Public Shared Function GetAll() As QUALPRO_PARAMSCollection
        Return QualproParamsProvider.Instance.SelectAllQUALPRO_PARAMS()
    End Function
    Public Shared Function GetByName(ByVal SettingName As String) As QualproParams
        Return QualproParamsProvider.Instance.SelectParamByName(SettingName)
    End Function
    Public Shared Function GetByPartialName(ByVal SettingName As String) As QUALPRO_PARAMSCollection
        Return QualproParamsProvider.Instance.SelectParamsLike(SettingName)
    End Function

#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mParamId
        End If
    End Function
    Private Sub ValidateWholeInstance()
        'Now validate the whole row
        If Me.IsNew Then
            Me.ValidationRules.AddRule(AddressOf VlidateUniqueness, "ParamId")
            ValidationRules.CheckRules("ParamId")
        End If
    End Sub
    Public Overrides Sub Save()
        ValidateWholeInstance()

        If IsValid Then
            MyBase.Save()
        End If
    End Sub
#End Region
#Region " Validation "
    Private Function VlidateUniqueness(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        'Don't check for uniqueness if there're other problems
        If Not Me.IsSavable Then
            Return True
        End If
        If GetByName(Me.STRPARAM_NM) IsNot Nothing Then
            e.Description = String.Format("There is already a setting named {0}", Me.STRPARAM_NM)
            Return False
        End If
        Return True
    End Function
    Private Function ValidateAtLeastOneValueExists(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        Dim Valid As Boolean = False
        If Me.NUMPARAM_VALUE.HasValue Then Valid = True
        If Me.DATPARAM_VALUE.HasValue Then Valid = True
        If Not String.IsNullOrEmpty(Me.STRPARAM_VALUE) Then Valid = True
        If Valid Then
            Return True
        Else
            e.Description = "At least one of the param values must be not null"
            Return False
        End If
    End Function
    Private Function ValidateParamType(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        Dim IsVaid As Boolean = True
        If Me.STRPARAM_TYPE.Length > 1 Then
            IsVaid = False
        End If
        If Not (UCase(Me.STRPARAM_TYPE) = "N" Or UCase(Me.STRPARAM_TYPE) = "D" Or UCase(Me.STRPARAM_TYPE) = "S") Then
            IsVaid = False
        End If
        If Not IsVaid Then
            e.Description = "Param_Type acceptable values are S, N or D."
        End If
        Return IsVaid
    End Function
    Private Function ValidateParameterMatchesType(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean
        Select Case Me.STRPARAM_TYPE
            Case "D"
                If Not Me.DATPARAM_VALUE.HasValue Then
                    e.Description = "Param_Type = 'D' but there is no value in DatParamValue field."
                    Return False
                End If
            Case "N"
                If Not Me.NUMPARAM_VALUE.HasValue Then
                    e.Description = "Param_Type = 'N' but there is no value in NumParamValue field."
                    Return False
                End If
            Case "S"
                If String.IsNullOrEmpty(Me.STRPARAM_VALUE) Then
                    e.Description = "Param_Type = 'S' but there is no value in StrParamValue field."
                    Return False
                End If
        End Select
        Return True
    End Function
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        'This are object level rules that I put on the ParamId property because BO implementation does not allow
        'Validation of the object as a whole.
        Me.ValidationRules.AddRule(AddressOf ValidateAtLeastOneValueExists, "PARAM_ID")
        Me.ValidationRules.AddRule(AddressOf ValidateParameterMatchesType, "PARAM_ID")

        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "STRPARAM_NM")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.CommonRules.MaxLengthRuleArgs("STRPARAM_NM", 50))
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "STRPARAM_TYPE")
        Me.ValidationRules.AddRule(AddressOf ValidateParamType, "STRPARAM_TYPE")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.CommonRules.MaxLengthRuleArgs("STRPARAM_TYPE", 1))
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "STRPARAM_GRP")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.CommonRules.MaxLengthRuleArgs("STRPARAM_GRP", 20))
        'Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Comments")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.CommonRules.MaxLengthRuleArgs("COMMENTS", 255))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.CommonRules.MaxLengthRuleArgs("STRPARAM_VALUE", 255))

    End Sub
#End Region
#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        PARAM_ID = QualproParamsProvider.Instance.InsertQUALPRO_PARAMS(Me)
    End Sub

    Protected Overrides Sub Update()
        QualproParamsProvider.Instance.UpdateQUALPRO_PARAMS(Me)
    End Sub
    Protected Overrides Sub DeleteImmediate()
        QualproParamsProvider.Instance.DeleteQualproParams(Me)
    End Sub
    Public Overrides Sub Delete()
        QualproParamsProvider.Instance.DeleteQualproParams(Me)
    End Sub
#End Region
End Class


