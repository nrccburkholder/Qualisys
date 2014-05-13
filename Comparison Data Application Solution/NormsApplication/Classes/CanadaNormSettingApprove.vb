Option Explicit On 
Option Strict On

Imports NormsApplicationBusinessObjectsLibrary

Imports NRC
Public Class CanadaNormSettingApprove

#Region " Private Fields"

    Public Enum CheckItemType
        GeneralSettings = 1
        SurveySelection = 2
        RollupSelection = 3
    End Enum

    Public Enum ApproveStatusType
        Waiting = 1
        Approved = 2
        Disapproved = 3
    End Enum

#End Region

#Region " Private Properties"

    Private mNormID As Integer
    Private mCheckItem As CheckItemType
    Private mModifierMemberID As Integer
    Private mModifierName As String
    Private mModifyDate As Date
    Private mApproveStatus As ApproveStatusType
    Private mApproverMemberID As Integer
    Private mApproverName As String
    Private mApproveDate As Date

#End Region

#Region " Public Properties"

    Public Property NormID() As Integer
        Get
            Return mNormID
        End Get
        Set(ByVal Value As Integer)
            mNormID = Value
        End Set
    End Property

    Public ReadOnly Property CheckItem() As CheckItemType
        Get
            Return mCheckItem
        End Get
    End Property

    Public Property ModifierMemberID() As Integer
        Get
            Return mModifierMemberID
        End Get
        Set(ByVal Value As Integer)
            mModifierMemberID = Value
        End Set
    End Property

    Public Property ModifierName() As String
        Get
            Return mModifierName
        End Get
        Set(ByVal Value As String)
            mModifierName = Value
        End Set
    End Property

    Public Property ModifyDate() As Date
        Get
            Return mModifyDate
        End Get
        Set(ByVal Value As Date)
            mModifyDate = Value
        End Set
    End Property

    Public Property ApproveStatus() As ApproveStatusType
        Get
            Return mApproveStatus
        End Get
        Set(ByVal Value As ApproveStatusType)
            mApproveStatus = Value
        End Set
    End Property

    Public Property ApproverMemberID() As Integer
        Get
            Return mApproverMemberID
        End Get
        Set(ByVal Value As Integer)
            mApproverMemberID = Value
        End Set
    End Property

    Public Property ApproverName() As String
        Get
            Return mApproverName
        End Get
        Set(ByVal Value As String)
            mApproverName = Value
        End Set
    End Property

    Public Property ApproveDate() As Date
        Get
            Return mApproveDate
        End Get
        Set(ByVal Value As Date)
            mApproveDate = Value
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Sub New(ByVal normID As Integer, _
                   ByVal checkItem As CheckItemType)
        mNormID = normID
        mCheckItem = checkItem
    End Sub

    Public Sub New(ByVal normID As Integer, _
                   ByVal checkItem As CheckItemType, _
                   ByVal modifierMemberID As Integer, _
                   ByVal modifierName As String, _
                   ByVal modifyDate As Date)
        mNormID = normID
        mCheckItem = checkItem
        mModifierMemberID = modifierMemberID
        mModifierName = modifierName
        mModifyDate = modifyDate
    End Sub

    Public Sub New(ByVal normID As Integer, _
                   ByVal checkItem As CheckItemType, _
                   ByVal modifierMemberID As Integer, _
                   ByVal modifierName As String, _
                   ByVal modifyDate As Date, _
                   ByVal approveStatus As ApproveStatusType)
        mNormID = normID
        mCheckItem = checkItem
        mModifierMemberID = modifierMemberID
        mModifierName = modifierName
        mModifyDate = modifyDate
        mApproveStatus = approveStatus
    End Sub

    Public Sub New(ByVal normID As Integer, _
                   ByVal checkItem As CheckItemType, _
                   ByVal modifierMemberID As Integer, _
                   ByVal modifierName As String, _
                   ByVal modifyDate As Date, _
                   ByVal approveStatus As ApproveStatusType, _
                   ByVal approverMemberID As Integer, _
                   ByVal approverName As String, _
                   ByVal approveDate As Date)
        mNormID = normID
        mCheckItem = checkItem
        mModifierMemberID = modifierMemberID
        mModifierName = modifierName
        mModifyDate = modifyDate
        mApproveStatus = approveStatus
        mApproverMemberID = approverMemberID
        mApproverName = approverName
        mApproveDate = approveDate
    End Sub

#End Region

#Region " Public Methods"

    Public Sub SetApproveStatus(ByVal approveStatus As ApproveStatusType, ByVal operatorMemberID As Integer)
        DataAccess.UpdateCanadaNormApproveStatus(mNormID, mCheckItem, approveStatus, operatorMemberID)

    End Sub

#End Region

End Class
