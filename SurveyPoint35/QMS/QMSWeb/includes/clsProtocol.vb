Public Enum tblProtocols
    ProtocolID = 0
    Name = 1
    Description = 2
    CreatedByUserID = 3
    CreatedBy = 4
    Keyword = 5

End Enum

<Obsolete("Use QMS.clsProtocols")> _
Public Class clsProtocol
    Inherits clsDBEntity

    Private _iCreatedByUserID As Integer = 0

    Private _sKeywordSearch As String = ""

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblProtocols) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblProtocols.ProtocolID Then
                Me._iEntityID = Value

            ElseIf eField = tblProtocols.CreatedByUserID Then
                Me._iCreatedByUserID = Value

            ElseIf eField = tblProtocols.Keyword Then
                Me._sKeywordSearch = Value
                Return

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "Protocols"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO Protocols (Name, Description, CreatedByUserID) "
        Me._sInsertSQL &= "VALUES ({1}, {2}, {3}) "

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE Protocols SET Name = {1}, Description = {2}, CreatedByUserID = {3} "
        Me._sUpdateSQL &= "WHERE ProtocolID = {0} "

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM ProtocolStepParameters WHERE ProtocolStepID "
        Me._sDeleteSQL &= "IN (SELECT ProtocolStepID FROM ProtocolSteps WHERE ProtocolID = {0}); " & vbCrLf
        Me._sDeleteSQL &= "DELETE FROM ProtocolSteps WHERE ProtocolID = {0}; " & vbCrLf
        Me._sDeleteSQL &= "DELETE FROM Protocols WHERE ProtocolID = {0}"

        'SELECT SQL
        Me._sSelectSQL = "SELECT p.ProtocolID, p.Name, p.Description, p.CreatedByUserID, ISNULL(u.FirstName + ' ', '') + u.LastName AS CreatedBy "
        Me._sSelectSQL &= "FROM Protocols p INNER JOIN Users u ON p.CreatedByUserID = u.UserID "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("p.ProtocolID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Me.Details(tblProtocols.Name).ToString.Length > 0 Then
                sWHERESQL &= String.Format("p.Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblProtocols.Name)))

            End If

            If Me.Details(tblProtocols.Description).ToString.Length > 0 Then
                sWHERESQL &= String.Format("p.Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblProtocols.Description)))

            End If

            If Not IsDBNull(Me.Details(tblProtocols.CreatedByUserID)) Then
                If Me.Details(tblProtocols.CreatedByUserID) > 0 Then
                    sWHERESQL &= String.Format("s.CreatedByUserID = {0} AND ", Details(tblProtocols.CreatedByUserID))

                End If

            End If

            If Me._sKeywordSearch <> "" Then
                sWHERESQL &= String.Format("p.Name + ' ' + p.Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Me._sKeywordSearch))

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

        sSQL = String.Format(sSQL, Details(tblProtocols.ProtocolID), _
                            DMI.DataHandler.QuoteString(Details(tblProtocols.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblProtocols.Description)), _
                            Details(tblProtocols.CreatedByUserID))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblProtocols.ProtocolID), _
                            DMI.DataHandler.QuoteString(Details(tblProtocols.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblProtocols.Description)), _
                            Details(tblProtocols.CreatedByUserID))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblProtocols.ProtocolID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("ProtocolID") = 0
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("CreatedByUserID") = Me._iCreatedByUserID

    End Sub

    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(SurveyInstanceID) FROM SurveyInstances WHERE ProtocolID = {0}", Me._iEntityID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
            Return String.Format("Protocol id {0} cannot be deleted. Survey instances are using protocol.\n", Me._iEntityID)

        Else
            Return ""

        End If

    End Function

    Public Function GetProtocolSteps() As DataTable
        Dim ps As New clsProtocolStep(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("ProtocolSteps") > -1 Then
            Me._dsEntity.Tables.Remove("ProtocolSteps")

        End If

        ps.Details(tblProtocolSteps.ProtocolID) = Me._iEntityID
        dt = ps.GetDetails().Tables("ProtocolSteps").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

    Public Sub AddProtocolStep(ByVal iProtocolStepTypeID As Integer)
        Dim dr As DataRow
        Dim sSQL As String

        sSQL = String.Format("SELECT Name FROM ProtocolStepTypes WHERE ProtocolStepTypeID = {0}", iProtocolStepTypeID)

        dr = Me._dsEntity.Tables("ProtocolSteps").NewRow

        dr.Item("ProtocolStepID") = 0
        dr.Item("ProtocolID") = Me._iEntityID
        dr.Item("Name") = ""
        dr.Item("ProtocolStepTypeID") = iProtocolStepTypeID
        dr.Item("ProtocolStepTypeName") = DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL).ToString
        dr.Item("StartDay") = 0

        Me._dsEntity.Tables("ProtocolSteps").Rows.Add(dr)

    End Sub

    Public Function GetProtocolStepParameters() As DataTable
        Dim psp As New clsProtocolStepParam(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("ProtocolStepParameters") > -1 Then
            Me._dsEntity.Tables.Remove("ProtocolStepParameters")

        End If

        psp.Details(tblProtocolStepParams.ProtocolID) = Me._iEntityID
        dt = psp.GetDetails.Tables("ProtocolStepParameters").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

End Class
