Public Class DTSDestination
    Inherits DTSDataSet

#Region " Private Members "
    Private mTableID As Integer
    Private mTableName As String
    Private mUsedInPackage As Boolean
    Private mHasDupCheckDefined As Boolean
#End Region

#Region " Public Properties "
    Public Property TableID() As Integer
        Get
            Return Me.mTableID
        End Get
        Set(ByVal Value As Integer)
            Me.mTableID = Value
        End Set
    End Property
    Public Property TableName() As String
        Get
            Return Me.mTableName
        End Get
        Set(ByVal Value As String)
            Me.mTableName = Value
        End Set
    End Property
    Public Property UsedInPackage() As Boolean
        Get
            Return Me.mUsedInPackage
        End Get
        Set(ByVal Value As Boolean)
            If Not Value = Me.mUsedInPackage Then
                Me.mUsedInPackage = Value

                Dim destCol As DestinationColumn
                Dim sourceCol As SourceColumn
                For Each destCol In Me.Columns
                    For Each sourceCol In destCol.SourceColumns
                        If Value Then
                            sourceCol.MapCount += 1
                        Else
                            sourceCol.MapCount -= 1
                        End If
                    Next
                Next

                RaiseEvent mUsedInPackageChanged(Me)
            End If
        End Set
    End Property
    Public Property HasDupCheckDefined() As Boolean
        Get
            Return Me.mHasDupCheckDefined
        End Get
        Set(ByVal Value As Boolean)
            Me.mHasDupCheckDefined = Value
        End Set
    End Property

#End Region

    Public Event mUsedInPackageChanged As UsedTablesChangedEventHandler

    Sub New(ByVal package As DTSPackage)
        MyBase.New(DataSetTypes.SQL)
    End Sub

    Public Overrides Function ToString() As String
        Return Me.TableName
    End Function

    Public Function NewColumn() As DestinationColumn
        Dim col As New DestinationColumn(Me)
        Return col
    End Function

    Public Overrides Function GetRecordCount(ByVal filePath As String) As Integer
        Return 0
    End Function

    Public Overrides Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As DataTable
        Return Nothing
    End Function

    Protected Overrides Function GetSchema(ByVal filePath As String) As DataTable
        Return Nothing
    End Function

    Public Overrides Function ValidateFile(ByVal filePath As String, ByRef errMsg As String) As FileValidationResults
        Return FileValidationResults.ValidFile
    End Function

End Class
