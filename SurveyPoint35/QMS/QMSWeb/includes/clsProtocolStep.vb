Public Enum tblProtocolSteps
    ProtocolStepID = 0
    ProtocolID = 1
    Name = 2
    ProtocolStepTypeID = 3
    StartDay = 4
    ProtocolStepTypeName = 5

End Enum

Public Enum qmsProtocolStepType
    MAILING = 1
    BATCHING = 2
    DATAENTRY = 3
    VERIFICATION = 4
    CATI = 5
    REMINDER = 6
    EXPORT = 7
    IMPORT = 8
    REPORT = 9

End Enum

<Obsolete("Use QMS.clsProtocolSteps")> _
Public Class clsProtocolStep
    Inherits clsDBEntity

    Private _iProtocolID As Integer = 0

    Private _iProtocolStepTypeID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblProtocolSteps) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblProtocolSteps.ProtocolStepID Then
                Me._iEntityID = Value

            ElseIf eField = tblProtocolSteps.ProtocolID Then
                Me._iProtocolID = Value

            ElseIf eField = tblProtocolSteps.ProtocolStepTypeID Then
                Me._iProtocolStepTypeID = Value

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Public Overrides Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = Me.Details(tblProtocolSteps.ProtocolStepID)
                    Me._iProtocolID = Me.Details(tblProtocolSteps.ProtocolID)

                End If
            End If
        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "ProtocolSteps"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO ProtocolSteps (ProtocolID, Name, ProtocolStepTypeID, StartDay) "
        Me._sInsertSQL &= "VALUES ({1}, {2}, {3}, {4}) "

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE ProtocolSteps SET ProtocolID = {1}, Name = {2}, ProtocolStepTypeID = {3}, StartDay = {4} "
        Me._sUpdateSQL &= "WHERE ProtocolStepID = {0} "

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM ProtocolStepParameters WHERE ProtocolStepID = {0}"
        Me._sDeleteSQL &= "DELETE FROM ProtocolSteps WHERE ProtocolStepID = {0}"

        'SELECT SQL
        Me._sSelectSQL = "SELECT ps.ProtocolStepID, ps.ProtocolID, ps.Name, ps.ProtocolStepTypeID, ps.StartDay, pst.Name AS ProtocolStepTypeName "
        Me._sSelectSQL &= "FROM ProtocolSteps ps INNER JOIN "
        Me._sSelectSQL &= "ProtocolStepTypes pst ON ps.ProtocolStepTypeID = pst.ProtocolStepTypeID "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("ps.ProtocolStepID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblProtocolSteps.ProtocolID)) Then
                sWHERESQL &= String.Format("ps.ProtocolID = {0} AND ", Details(tblProtocolSteps.ProtocolID))

            End If

            If Me.Details(tblProtocolSteps.Name).ToString.Length > 0 Then
                sWHERESQL &= String.Format("ps.Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblProtocolSteps.Name)))

            End If

            If Not IsDBNull(Me.Details(tblProtocolSteps.ProtocolStepTypeID)) Then

                sWHERESQL &= String.Format("ps.ProtocolStepTypeID = {0} AND ", Details(tblProtocolSteps.ProtocolStepTypeID))

            End If

            If Not IsDBNull(Me.Details(tblProtocolSteps.StartDay)) Then
                sWHERESQL &= String.Format("ps.StartDay = {0} AND ", Details(tblProtocolSteps.StartDay))

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblProtocolSteps.ProtocolStepID), _
                            DMI.DataHandler.QuoteString(Details(tblProtocolSteps.ProtocolID)), _
                            DMI.DataHandler.QuoteString(Details(tblProtocolSteps.Name)), _
                            Details(tblProtocolSteps.ProtocolStepTypeID), _
                            Details(tblProtocolSteps.StartDay))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblProtocolSteps.ProtocolStepID), _
                            DMI.DataHandler.QuoteString(Details(tblProtocolSteps.ProtocolID)), _
                            DMI.DataHandler.QuoteString(Details(tblProtocolSteps.Name)), _
                            Details(tblProtocolSteps.ProtocolStepTypeID), _
                            Details(tblProtocolSteps.StartDay))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblProtocolSteps.ProtocolStepID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("ProtocolStepID") = 0
        dr.Item("ProtocolID") = Me._iProtocolID
        dr.Item("Name") = ""
        dr.Item("ProtocolStepTypeID") = Me._iProtocolStepTypeID
        dr.Item("StartDay") = 0

    End Sub

    Public Function GetProtocolStepTypes() As DataTable
        Dim sSQL As String

        If Me._dsEntity.Tables.IndexOf("ProtocolStepTypes") > -1 Then
            Me._dsEntity.Tables.Remove("ProtocolStepTypes")

        End If

        sSQL = "SELECT ProtocolStepTypeID, Name FROM ProtocolStepTypes ORDER BY ProtocolStepTypeID "

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "ProtocolStepTypes") Then

            Return Me._dsEntity.Tables("ProtocolStepTypes")

        End If

    End Function

    Public Sub InitProtocolStepParameters()
        Dim sSQL As String

        sSQL = "DELETE FROM ProtocolStepParameters WHERE ProtocolStepID = {0}; "
        sSQL &= "INSERT INTO ProtocolStepParameters (ProtocolStepID, ProtocolStepTypeParamID, ProtocolStepParamValue) "
        sSQL &= "(SELECT ProtocolStepID, ProtocolStepTypeParamID, ProtocolStepParamValue FROM v_ProtocolStepParameters WHERE ProtocolStepID = {0}) "
        sSQL = String.Format(sSQL, Me.Details(tblProtocolSteps.ProtocolStepID))

        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

    End Sub

    Public Function GetProtocolStepParameters() As DataTable
        Dim psp As New clsProtocolStepParam(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("ProtocolStepParameters") > -1 Then
            Me._dsEntity.Tables.Remove("ProtocolStepParameters")

        End If

        psp.Details(tblProtocolStepParams.ProtocolStepID) = Me._iEntityID
        dt = psp.GetDetails.Tables("ProtocolStepParameters").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

    Public Shared Function GetParameters(ByVal iProtocolStepID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = String.Format("SELECT ProtocolStepParamID, ProtocolStepTypeParamID, ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepID = {0}", iProtocolStepID)

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

End Class
