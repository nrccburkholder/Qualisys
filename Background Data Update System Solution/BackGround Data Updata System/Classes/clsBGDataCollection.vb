Imports System.Data.SqlClient

Public Class clsBGDataCollection
    Inherits System.Collections.CollectionBase

    Private mobjPanel As Panel
    Private mintStudyID As Integer
    Private mintSurveyID As Integer
    Private mintPopID As Integer


    Public Sub New(ByRef objPanel As Panel)

        'Store the values passed in
        mobjPanel = objPanel

    End Sub


    Public Function Add(ByVal strFieldName As String, ByVal strDataType As String, ByVal intMaxLength As Integer, _
                        ByVal strValidValues As String, ByVal bolRequired As Boolean) As BackgroundData

        'Create the BGData object
        Dim objBGData As New BackgroundData(strFieldName:=strFieldName, strDataType:=strDataType, intMaxLength:=intMaxLength, _
                                            strValidValues:=strValidValues, bolRequired:=bolRequired)

        'Get the current value
        Dim strSql As String = "SELECT " & strFieldName & " FROM s" & mintStudyID.ToString & ".Population " & _
                               "WHERE Pop_id = " & mintPopID.ToString

        'Open the database connection
        'Dim objConnection As SqlConnection = New SqlConnection(connectionString:=GetSQLConnectString(strApplication:=gkstrRegBase))
        Dim objConnection As SqlConnection = New SqlConnection(connectionString:=Config.QP_ProdConnection)
        objConnection.Open()

        'Build the command
        Dim objCommand As SqlCommand = New SqlCommand(strSql)
        With objCommand
            .Connection = objConnection
            .CommandTimeout = 600
            .CommandType = CommandType.Text
        End With

        'Populate the data reader
        Dim objReader As SqlDataReader = objCommand.ExecuteReader

        'Store the current value
        objReader.Read()
        If objReader.HasRows Then
            If Not IsDBNull(objReader(strFieldName)) Then
                objBGData.Data = objReader(strFieldName)
            End If
        End If

        'Cleanup
        objReader.Close()
        objConnection.Close()

        'Add this object to the collection
        List.Add(objBGData)

        'Add this object to the form
        objBGData.Dock = DockStyle.Top
        mobjPanel.Controls.Add(objBGData)

        'Return a reference to the new object
        Return objBGData

    End Function


    Public Sub Remove(ByVal intIndex As Integer)

        'Check to see if there is an object at the supplied index.
        If intIndex > Count - 1 Or intIndex < 0 Then
            'If no object exists do nothing

        Else
            'Invokes the RemoveAt method of the List object.
            mobjPanel.Controls.Remove(List.Item(intIndex))
            List.RemoveAt(intIndex)

        End If

    End Sub


    Public Sub ClearAll()

        'Clear the control
        mobjPanel.Controls.Clear()

        'Clear the list
        List.Clear()

    End Sub


    Public ReadOnly Property Item(ByVal intIndex As Integer) As BackgroundData

        Get
            Try
                ' The appropriate item is retrieved from the List object and 
                ' explicitly cast to the BackgroundData type, then returned to the 
                ' caller.
                Return CType(List.Item(intIndex), BackgroundData)

            Catch
                Return Nothing

            End Try

        End Get

    End Property


    Public Sub PopFromDB(ByVal intStudyID As Integer, ByVal intSurveyID As Integer, ByVal intPopID As Integer)

        'Store the values passed in
        mintStudyID = intStudyID
        mintSurveyID = intSurveyID
        mintPopID = intPopID

        'Build the command
        Dim objCommand As SqlCommand = New SqlCommand("sp_BDUS_GetMetaFieldInfo")
        With objCommand
            .Connection = Globals.gobjConnection
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intSurveyID", SqlDbType.Int).Value = intSurveyID
        End With

        'Populate the data reader
        Dim objReader As SqlDataReader = objCommand.ExecuteReader

        'Populate the collection
        While objReader.Read
            Add(strFieldName:=objReader("strField_Nm"), _
                strDataType:=objReader("strFieldDataType"), _
                intMaxLength:=IIf(IsDBNull(objReader("intFieldLength")), 0, objReader("intFieldLength")), _
                strValidValues:=IIf(IsDBNull(objReader("strValidValues")), "", objReader("strValidValues")), _
                bolRequired:=IIf(IsDBNull(objReader("bitRequired")), False, objReader("bitRequired")))
        End While

        'Cleanup
        objReader.Close()

        'Set the tab order
        Dim intCnt As Integer
        Dim intTabIndex As Integer = 0
        For intCnt = Count - 1 To 0 Step -1
            CType(List.Item(intCnt), BackgroundData).TabIndex = intTabIndex
            If intTabIndex = 0 Then CType(List.Item(intCnt), BackgroundData).Focus()
            intTabIndex += 1
        Next

    End Sub


    Public Function IsDataValid(ByRef strMsg As String) As Boolean

        Dim objBGData As BackgroundData

        'Loop through each data object and check them
        For Each objBGData In List
            If Not objBGData.IsDataValid(strMsg:=strMsg) Then
                Exit For
            End If
        Next

        'Determine return value
        If strMsg.Length > 0 Then
            Return False
        Else
            Return True
        End If

    End Function


    Public ReadOnly Property SetClause() As String
        Get
            Dim strSet As String = ""
            Dim objBGData As BackgroundData

            'Loop through each data object and get the update
            For Each objBGData In List
                strSet &= IIf(strSet.Length = 0, "", ", ") & objBGData.SetClause
            Next

            'Return the set clause
            Return strSet

        End Get
    End Property


    '** Added 08-25-04 JJF
    Public ReadOnly Property FieldList() As String
        Get
            Dim strFields As String = ""
            Dim objBGData As BackgroundData

            'Loop through each data object and get the field name
            For Each objBGData In List
                strFields &= IIf(strFields.Length = 0, "", ", ") & objBGData.FieldName
            Next

            'Return the field list
            Return strFields

        End Get
    End Property
    '** End of add 08-25-04 JJF

End Class
