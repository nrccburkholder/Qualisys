Imports System.Data
Imports System.Data.SqlClient

Public Class clsQuestion

    Private mintQstnCore As Integer
    Private mintSampleUnitID As Integer
    Private mbolMultiResponse As Boolean
    Private mobjValues As New ArrayList

    Public Sub New(ByVal intQstnCore As Integer, ByVal intQuestionFormID As Integer, ByVal bolMultiResponse As Boolean)

        MyBase.New()

        'Save the data passed in
        mintQstnCore = intQstnCore
        mbolMultiResponse = bolMultiResponse

        'Get the SampleUnitID
        PopQuestion(intQuestionFormID:=intQuestionFormID)

    End Sub

    Private Sub PopQuestion(ByVal intQuestionFormID As Integer)

        'Dim strConn As String = GetSQLConnectString(strApplication:="OfflineTransferResults")
        Dim strConn As String = Config.QP_ProdConnection

        'Open the connection
        Dim objConnection As SqlConnection = New SqlConnection(strConn)
        Dim objDataAdapter As SqlDataAdapter = New SqlDataAdapter

        'Build the additional info command
        Dim objCommand As SqlCommand = New SqlCommand("sp_OffTR_GetSampleUnitInfo", objConnection)
        With objCommand
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intQstnCore", SqlDbType.Int).Value = mintQstnCore
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int).Value = intQuestionFormID
        End With

        'Populate the additional info dataset
        objDataAdapter.SelectCommand = objCommand
        Dim objDataSet As DataSet = New DataSet
        objDataAdapter.Fill(objDataSet)

        'Populate the properties
        With objDataSet.Tables(0)
            If .Rows.Count = 0 Then
                'No sample unit found
                mintSampleUnitID = Globals.gkintSampleUnitMissing
            ElseIf .Rows(0).Item("QtyRec") > 1 Then
                'Multiple sample units found
                mintSampleUnitID = Globals.gkintSampleUnitMultiple
            Else
                'Store the sample unit id
                mintSampleUnitID = .Rows(0).Item("SampleUnit_id")
            End If
        End With

        'Cleanup
        objConnection.Close()

    End Sub

    Public Sub AddValue(ByVal objValue As Object)

        Dim intValue As Integer
        Dim bolSkip As Boolean

        'Determine the value to be used
        If mbolMultiResponse Then
            Try
                intValue = objValue
            Catch
                bolSkip = True
            End Try
        Else
            Try
                intValue = objValue
            Catch
                intValue = -9
            End Try
        End If

        'Add the value
        If Not bolSkip Then
            mobjValues.Add(intValue)
        End If

    End Sub

    Public ReadOnly Property QstnCore() As Integer
        Get
            Return mintQstnCore
        End Get
    End Property

    Public ReadOnly Property SampleUnitID() As Integer
        Get
            Return mintSampleUnitID
        End Get
    End Property

    Public ReadOnly Property MultiResponse() As Boolean
        Get
            Return mbolMultiResponse
        End Get
    End Property

    Public ReadOnly Property Values() As ArrayList
        Get
            Return mobjValues
        End Get
    End Property
End Class
