Imports System.Text.RegularExpressions

Public Class SourceColumn
    Inherits Column

#Region " Private Members "
    Private mSourceID As Integer = 0
    Private mMapCount As Integer = 0
    Private mOriginalName As String = ""
#End Region

#Region " Public Properties "
    Public Property SourceID() As Integer
        Get
            Return Me.mSourceID
        End Get
        Set(ByVal Value As Integer)
            Me.mSourceID = Value
        End Set
    End Property
    Public Property MapCount() As Integer
        Get
            Return Me.mMapCount
        End Get
        Set(ByVal Value As Integer)
            If Not Value = Me.mMapCount Then
                Me.mMapCount = Value
                RaiseEvent ColumnChanged(Me)
            End If
        End Set
    End Property

    Public Property OriginalName() As String
        Get
            Return Me.mOriginalName
        End Get
        Set(ByVal Value As String)
            Me.mOriginalName = Value
        End Set
    End Property

#End Region

    Public Event ColumnChanged As SourceColumnChangeEventHandler

    Sub New()

    End Sub
    Sub New(ByVal parent As DTSDataSet)
        MyBase.New(parent)
    End Sub
    Public Overrides Function ToString() As String
        Return String.Format("DTSSource(""{0}"")", Me.ColumnName)
    End Function

    Public Overrides Function Clone() As Object
        Dim column As New SourceColumn

        With column
            .mColumnName = Me.mColumnName
            .mDataType = Me.mDataType
            .mLength = Me.mLength
            .mOrdinal = Me.mOrdinal
            .mParent = Me.mParent
            .mSourceID = Me.mSourceID
            .mMapCount = Me.mMapCount
            .mOriginalName = Me.mOriginalName
        End With

        Return (column)
    End Function

    Public Shared Function IsDefaultColumnName(ByVal name As String) As Boolean
        Static pattern As String = SourceColumn.DEFAULT_COLUMN_NAME + "\d\d\d"

        If (name.Length <> 6) Then Return False
        Return (Regex.Match(name, pattern, RegexOptions.IgnoreCase).Success)
    End Function

End Class
