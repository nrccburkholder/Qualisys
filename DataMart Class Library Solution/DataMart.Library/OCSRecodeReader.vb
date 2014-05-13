Imports System

Friend Class OCSRecodeReader
    Inherits HHCAHPSRecodeReader

#Region " Private Members "

    Private mExportSetType As ExportSetType

#End Region

#Region " Constructors "

    Public Sub New(ByVal rdr As IDataReader)

        MyBase.New(rdr)

    End Sub

    Public Sub New(ByVal rdr As IDataReader, ByVal exportSetType As ExportSetType)

        MyBase.New(rdr)
        mExportSetType = exportSetType

    End Sub

#End Region

#Region " Schema Initialization "

    Protected Overrides Sub InitSchemaTable()

        MyBase.InitSchemaTable()

        'OCS section
        AddIntegerColumnToSchema("patient-id", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("soc-date", CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("branch-id", 50, CmsColumnType.PatientAdmin)

    End Sub

#End Region

#Region "Overrides Methods"

    Protected Overrides Function GetHeaderField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "PROVIDER-NAME"
                If mExportSetType = ExportSetType.OCSClient Then
                    Return mReader("MedicareName")
                Else
                    Return String.Empty
                End If

            Case "PROVIDER-ID"
                Return mReader("MedicareNumber")
                'If mexportSetType = ExportSetType.OCSClient Then
                '    Return mReader("MedicareNumber")
                'Else
                '    Return mReader("MedicareNumber").ToString.Trim.GetHashCode
                'End If

            Case "NPI"
                Return String.Empty

            Case Else
                Return MyBase.GetHeaderField(columnName)

        End Select

    End Function

    Protected Overrides Function GetPatientAdminField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "PROVIDER-ID"
                Return mReader("Medicare")
                'If mexportSetType = ExportSetType.OCSClient Then
                '    Return mReader("Medicare")
                'Else
                '    Return mReader("Medicare").ToString.Trim.GetHashCode
                'End If

            Case "NPI"
                Return String.Empty

            Case "PATIENT-ID"
                Return mReader("HHOASPID")

            Case "SOC-DATE"
                If Not String.IsNullOrEmpty(mReader("HHSOCDT").ToString) Then
                    Return CDate(mReader("HHSOCDT")).ToString("yyyyMMdd")
                Else
                    Return String.Empty
                End If

            Case "BRANCH-ID"
                Return mReader("HHBrnNum")

            Case Else
                Return MyBase.GetPatientAdminField(columnName)

        End Select

    End Function

#End Region

End Class
