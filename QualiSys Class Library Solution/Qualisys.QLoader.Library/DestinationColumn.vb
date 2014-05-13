Public Class DestinationColumn
    Inherits Column

#Region " Private Members "
    Private mDestinationID As Integer = 0
    Private mFormula As String = ""
    Private mSourceColumns As New ColumnCollection
    Private mFrequencyLimit As Integer = 0
    Private mCheckNulls As Boolean = False
    Private mIsMatchField As Boolean = False
    Private mIsDupCheckField As Boolean = False
    Private mIsSystemField As Boolean = False
    Private mIsPIIField As Boolean = False
    Private mIsTransferedToUS As Boolean = False
#End Region

#Region " Public Properties "
    Public Property DestinationID() As Integer
        Get
            Return Me.mDestinationID
        End Get
        Set(ByVal Value As Integer)
            Me.mDestinationID = Value
        End Set
    End Property
    Public Property Formula() As String
        Get
            Return Me.mFormula
        End Get
        Set(ByVal Value As String)
            Me.mFormula = Value
        End Set
    End Property
    Public Property SourceColumns() As ColumnCollection
        Get
            Return Me.mSourceColumns
        End Get
        Set(ByVal Value As ColumnCollection)
            Me.mSourceColumns = Value
        End Set
    End Property
    Public Property FrequencyLimit() As Integer
        Get
            Return Me.mFrequencyLimit
        End Get
        Set(ByVal Value As Integer)
            Me.mFrequencyLimit = Value
        End Set
    End Property
    Public Property CheckNulls() As Boolean
        Get
            Return Me.mCheckNulls
        End Get
        Set(ByVal Value As Boolean)
            Me.mCheckNulls = Value
        End Set
    End Property
    Public Property IsMatchField() As Boolean
        Get
            Return Me.mIsMatchField
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsMatchField = Value
        End Set
    End Property
    Public Property IsDupCheckField() As Boolean
        Get
            Return Me.mIsDupCheckField
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsDupCheckField = Value
        End Set
    End Property

    Public Property IsSystemField() As Boolean
        Get
            Return Me.mIsSystemField
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsSystemField = Value
        End Set
    End Property

    Public Property IsPIIField() As Boolean
        Get
            Return Me.mIsPIIField
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsPIIField = Value
        End Set
    End Property

    Public Property IsTransferedToUS() As Boolean
        Get
            Return Me.mIsTransferedToUS
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsTransferedToUS = Value
        End Set
    End Property
#End Region

    Sub New()

    End Sub
    Sub New(ByVal ParentDestination As DTSDestination)
        MyBase.New(ParentDestination)
    End Sub
    Public Overrides Function ToString() As String
        Return String.Format("DTSDestination(""{0}"")", Me.ColumnName)
    End Function
    Public Overrides Function DataTypeStringFull() As String
        Select Case Me.DataType
            Case DataTypes.DateTime
                Return "DateTime"
            Case DataTypes.Int
                Return "Int"
            Case DataTypes.Varchar
                Return String.Format("Varchar({0})", Me.Length)
            Case Else
                Return ""
        End Select
    End Function

    Public Overrides Function Clone() As Object
        Dim column As New DestinationColumn

        With column
            .mColumnName = Me.mColumnName
            .mDataType = Me.mDataType
            .mLength = Me.mLength
            .mOrdinal = Me.mOrdinal
            .mParent = Me.mParent
            .mDestinationID = Me.mDestinationID
            .mFormula = Me.mFormula
            If (Not Me.mSourceColumns Is Nothing) Then
                .mSourceColumns = Me.mSourceColumns.Clone
            End If
            .mFrequencyLimit = Me.mFrequencyLimit
            .mCheckNulls = Me.mCheckNulls
            .mIsMatchField = Me.mIsMatchField
            .mIsDupCheckField = Me.mIsDupCheckField
            .mIsSystemField = Me.mIsSystemField
            .mIsPIIField = Me.mIsPIIField
            .mIsTransferedToUS = Me.mIsTransferedToUS
        End With

        Return column

    End Function

End Class
