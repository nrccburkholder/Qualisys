Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.Notification
Imports Nrc.Framework.BusinessLogic.Configuration

<Serializable()> _
Public Class SubType
    'Inherits BusinessBase(Of SubType)

#Region "private fields"
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mSurveySubtype_id As Integer
    Private mSubType_Id As Integer
    Private mSurveyType_Id As Integer
    Private mSubType_NM As String = String.Empty
    Private mSubtypeCategory_Id As Integer
    Private mSubtypeCategory_NM As String
    Private mbitMultiSelect As Boolean
    Private mbitRuleOverride As Boolean
    Private mIsNew As Boolean = False
    Private mIsDirty As Boolean = False
    Private mNeedsDeleted As Boolean = False
    Private mWasSelected As Boolean = False
    Private mParentSubType_Id As Integer = 0
    Private mbitQuestionnaireRequired As Boolean = False
#End Region

#Region "public properties"

    Public Property SurveySubTypeId() As Integer
        Get
            Return mSurveySubtype_id
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveySubtype_id Then
                mSurveySubtype_id = value
            End If
        End Set
    End Property

    Public Property SubTypeId() As Integer
        Get
            Return mSubType_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mSubType_Id Then
                mSubType_Id = value
            End If
        End Set
    End Property

    Public Property SubTypeName() As String
        Get
            Return mSubType_NM
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSubType_NM Then
                mSubType_NM = value
            End If
        End Set
    End Property

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Concat(mSubType_NM, IIf(mbitRuleOverride = True, "*", ""))
        End Get

    End Property

    Public Property SurveyTypeId() As Integer
        Get
            Return mSurveyType_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyType_Id Then
                mSurveyType_Id = value
            End If
        End Set
    End Property

    Public Property SubtypeCategory_Id() As Integer
        Get
            Return mSubtypeCategory_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mSubtypeCategory_Id Then
                mSubtypeCategory_Id = value
            End If
        End Set
    End Property

    Public Property SubTypeCategoryName() As String
        Get
            Return mSubtypeCategory_NM
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSubtypeCategory_NM Then
                mSubtypeCategory_NM = value
            End If
        End Set
    End Property

    Public Property IsMultiSelect() As Boolean
        Get
            Return mbitMultiSelect
        End Get
        Set(ByVal value As Boolean)
            mbitMultiSelect = value
        End Set
    End Property

    Public Property IsRuleOverride() As Boolean
        Get
            Return mbitRuleOverride
        End Get
        Set(ByVal value As Boolean)
            mbitRuleOverride = value
        End Set
    End Property

    Public Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
        Set(ByVal value As Boolean)
            mIsDirty = value
        End Set
    End Property

    Public Property IsNew() As Boolean
        Get
            Return mIsNew
        End Get
        Set(ByVal value As Boolean)
            mIsNew = value
        End Set
    End Property

    Public Property NeedsDeleted() As Boolean
        Get
            Return mNeedsDeleted
        End Get
        Set(ByVal value As Boolean)
            mNeedsDeleted = value
        End Set
    End Property

    Public Property WasSelected() As Boolean
        Get
            Return mWasSelected
        End Get
        Set(ByVal value As Boolean)
            mWasSelected = value
        End Set
    End Property

    Public Property ParentSubTypeId() As Integer
        Get
            Return mParentSubType_Id
        End Get
        Set(ByVal value As Integer)
            If Not value = mParentSubType_Id Then
                mParentSubType_Id = value
            End If
        End Set
    End Property

    Public Property IsQuestionnaireRequired() As Boolean
        Get
            Return mbitQuestionnaireRequired
        End Get
        Set(ByVal value As Boolean)
            mbitQuestionnaireRequired = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New()


    End Sub

    Public Sub New(ByVal subtype_Id As Integer, ByVal Name As String, ByVal isSelected As Boolean)

        mSubType_Id = subtype_Id
        mSubType_NM = Name
        mWasSelected = isSelected

    End Sub

    Public Sub New(ByVal subtype_Id As Integer, ByVal Name As String, ByVal bitRuleOverride As Boolean, ByVal isSelected As Boolean)


        mSubType_Id = subtype_Id
        mSubType_NM = Name
        mbitRuleOverride = bitRuleOverride
        mWasSelected = isSelected
    End Sub


    Public Sub New(ByVal subtype_Id As Integer, ByVal SurveyID As Integer, ByVal Name As String, ByVal bitRuleOverride As Boolean, ByVal isSelected As Boolean)

        mSubType_Id = subtype_Id
        mSubType_NM = Name
        mSurveyType_Id = SurveyID
        mbitRuleOverride = bitRuleOverride
        mWasSelected = isSelected

    End Sub

    Public Sub New(ByVal subtype_Id As Integer, ByVal SurveyID As Integer, ByVal Name As String, ByVal bitRuleOverride As Boolean, ByVal isSelected As Boolean, ByVal parentSubType_Id As Integer, ByVal isQuestionnaireRequired As Boolean)

        mSubType_Id = subtype_Id
        mSubType_NM = Name
        mSurveyType_Id = SurveyID
        mbitRuleOverride = bitRuleOverride
        mWasSelected = isSelected
        mParentSubType_Id = parentSubType_Id
        mbitQuestionnaireRequired = isQuestionnaireRequired

    End Sub

#End Region

#Region "public methods"

    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

#End Region



End Class
