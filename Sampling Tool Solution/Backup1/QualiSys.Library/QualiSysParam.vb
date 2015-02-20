Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a configurable parameter in the QualiSys system.
''' </summary>
Public Class QualisysParam

    Public Enum ParamDataType
        Numeric
        [String]
        [Date]
    End Enum

#Region " Private Instance Data "

#Region " Persisted Fields "
    Private mId As Integer
    Private mName As String
    Private mGroup As String
    Private mComments As String
    Private mParamType As ParamDataType
    Private mIntegerValue As Integer
    Private mStringValue As String
    Private mDateValue As Date
#End Region

    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "

#Region " Persisted Properties "
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
            If mName <> value Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property Group() As String
        Get
            Return mGroup
        End Get
        Set(ByVal value As String)
            If mGroup <> value Then
                mGroup = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property Comments() As String
        Get
            Return mComments
        End Get
        Set(ByVal value As String)
            If mComments <> value Then
                mComments = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property ParamType() As ParamDataType
        Get
            Return mParamType
        End Get
        Set(ByVal value As ParamDataType)
            If mParamType <> value Then
                mParamType = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property DateValue() As Date
        Get
            Return mDateValue
        End Get
        Set(ByVal value As Date)
            If mDateValue <> value Then
                mDateValue = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property IntegerValue() As Integer
        Get
            Return mIntegerValue
        End Get
        Set(ByVal value As Integer)
            If mIntegerValue <> value Then
                mIntegerValue = value
                mIsDirty = True
            End If
        End Set
    End Property
    Public Property StringValue() As String
        Get
            Return mStringValue
        End Get
        Set(ByVal value As String)
            If mStringValue <> value Then
                mStringValue = value
                mIsDirty = True
            End If
        End Set
    End Property
#End Region

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
#End Region

#Region " DB CRUD Methods "

    Public Shared Function GetParameter(ByVal paramName As String) As QualisysParam
        Return QualisysParamsProvider.Instance.[Select](paramName)
    End Function

#End Region

    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub


End Class