Friend Class ChartRecodeReader
    Inherits CmsRecodeReader

#Region " Constructors "

    Public Sub New(ByVal rdr As IDataReader)

        MyBase.New(rdr)

    End Sub

#End Region

#Region " Schema Initialization "

    Protected Overrides Sub InitResponseColumnAliases()

        MyBase.InitResponseColumnAliases()

        AddResponseColumnAlias("CHTORG", "Q021803")
        AddResponseColumnAlias("CHTORG", "Q021943")
        'AddResponseColumnAlias("CHTWAIT", "")
        'AddResponseColumnAlias("CHTTEST", "")
        'AddResponseColumnAlias("CHTCHECK", "")
        AddResponseColumnAlias("CHTSAME", "Q021822")
        AddResponseColumnAlias("CHTSAME", "Q021963")
        AddResponseColumnAlias("CHTMED", "Q021841")
        AddResponseColumnAlias("CHTMED", "Q021983")
        AddResponseColumnAlias("CHTSIGN", "Q021843")
        AddResponseColumnAlias("CHTSIGN", "Q026618")
        AddResponseColumnAlias("CHTINT", "Q012064")
        AddResponseColumnAlias("CHTINTAV", "Q012065")

    End Sub

    Protected Overrides Sub InitSchemaTable()

        MyBase.InitSchemaTable()

        'Header Columns
        AddStringColumnToSchema("pe-number", 50, CmsColumnType.Header)
        AddIntegerColumnToSchema("PENUMBERCOUNT", CmsColumnType.Header)

        'Reponse Columns
        AddStringColumnToSchema("CHTORG", 1, CmsColumnType.PatientResponse)
        'AddStringColumnToSchema("CHTWAIT", 1, CmsColumnType.PatientResponse)
        'AddStringColumnToSchema("CHTTEST", 1, CmsColumnType.PatientResponse)
        'AddStringColumnToSchema("CHTCHECK", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("CHTSAME", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("CHTMED", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("CHTSIGN", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("CHTINT", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("CHTINTAV", 1, CmsColumnType.PatientResponse)

    End Sub

#End Region

#Region " Get Field Methods "

    Protected Overrides Function GetHeaderField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "PE-NUMBER"
                Return mReader("penumber")

            Case "PENUMBERCOUNT"
                If String.IsNullOrEmpty(mReader("NumberofPENumbers").ToString) Then
                    Return 1
                Else
                    Return mReader("NumberofPENumbers")
                End If

            Case Else
                Return MyBase.GetHeaderField(columnName)

        End Select

    End Function

    Protected Overrides Function GetRecodedCoreValue(ByVal columnName As String, ByVal value As Object) As Object

        Select Case columnName.ToUpper
            Case "Q021803", "Q021943", "Q021822", "Q021963", "Q021843", "Q026618"
                'Standard Four point scale
                Return RecodeStandard(value, 1, 4)

            Case "Q021841", "Q021983"
                'Standard Six point scale
                Return RecodeStandard(value, 1, 6)

            Case "Q012064"
                'Standard Two point scale
                Return RecodeStandard(value, 1, 2)

            Case "Q012065"
                'CHTINTAV question
                Return RecodeCHTINTAV(value)

            Case Else
                Return MyBase.GetRecodedCoreValue(columnName, value)

        End Select

    End Function

#End Region

#Region " Recoding Methods "

    Private Function RecodeCHTINTAV(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        If intVal >= 1 AndAlso intVal <= 4 Then
            Return intVal
        ElseIf intVal = -89 Then
            Return 8
        Else
            Return "M"
        End If

    End Function

#End Region

End Class
