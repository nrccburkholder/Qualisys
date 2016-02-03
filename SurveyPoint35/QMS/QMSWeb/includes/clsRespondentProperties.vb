Public Enum tblRespondentProperties
    RespondentPropertyID = 0
    RespondentID = 1
    PropertyName = 2
    PropertyValue = 3

End Enum

<Obsolete("Use QMS.clsRespondentProperties")> _
Public Class clsRespondentProperties
    Inherits clsDBEntity

    Private _iRespondentID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal uField As tblRespondentProperties) As Object
        Get
            Return MyBase.Details(uField.ToString)

        End Get

        Set(ByVal Value As Object)

            If uField = tblRespondentProperties.RespondentID Then
                _iRespondentID = Value

            ElseIf uField = tblRespondentProperties.RespondentPropertyID Then
                _iEntityID = Value

            End If

            MyBase.Details(uField.ToString) = Value

        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "RespondentProperties"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO RespondentProperties(RespondentID, PropertyName, PropertyValue) "
        Me._sInsertSQL &= "VALUES({1}, {2}, {3}) "

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE RespondentProperties SET PropertyName = {2}, PropertyValue = {3} "
        Me._sUpdateSQL &= "WHERE RespondentPropertyID = {0} "

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM RespondentProperties WHERE RespondentPropertyID = {0}"

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT * FROM RespondentProperties "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As New System.Text.StringBuilder()

        If Me._iEntityID > 0 Then
            sWHERESQL.AppendFormat("RespondentPropertyID = {0} AND ", Me._iEntityID)

        Else

            If Me.Details(tblRespondentProperties.RespondentID).ToString.Length > 0 Then _
                sWHERESQL.AppendFormat("RespondentID = {0} AND ", Details(tblRespondentProperties.RespondentID))

            If Me.Details(tblRespondentProperties.PropertyName).ToString.Length > 0 Then _
                sWHERESQL.AppendFormat("PropertyName = {0} AND ", UCase(DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyName))))

            If Me.Details(tblRespondentProperties.PropertyValue).ToString.Length > 0 Then _
                sWHERESQL.AppendFormat("PropertyValue = {0} AND ", DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyValue)))

        End If

        If sWHERESQL.Length > 0 Then
            sWHERESQL.Insert(0, "WHERE ")
            sWHERESQL.Remove(sWHERESQL.Length - 4, 4)

        End If

        sWHERESQL.Insert(0, _sSelectsql)

        Return sWHERESQL.ToString

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblRespondentProperties.RespondentPropertyID), _
                            Details(tblRespondentProperties.RespondentID), _
                            UCase(DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyName))), _
                            DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyValue)))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblRespondentProperties.RespondentPropertyID), _
                            Details(tblRespondentProperties.RespondentID), _
                            UCase(DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyName))), _
                            DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyValue)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblRespondentProperties.RespondentPropertyID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("RespondentPropertyID") = 0
        dr.Item("RespondentID") = _iRespondentID
        dr.Item("PropertyName") = ""
        dr.Item("PropertyValue") = ""

    End Sub

    Public Sub AddProperty()
        Dim dr As DataRow

        dr = Me._dsEntity.Tables(Me._sTableName).NewRow
        Me.SetRecordDefaults(dr)

        Me._dsEntity.Tables(Me._sTableName).Rows.Add(dr)

    End Sub

    Protected Overrides Function VerifyInsert() As String
        Dim sSQL As String

        If Me._iEntityID = 0 Then
            sSQL = String.Format("SELECT COUNT(RespondentPropertyID) FROM RespondentProperties WHERE RespondentID = {0} AND PropertyName = {1}", _
                    Details(tblRespondentProperties.RespondentID), _
                    UCase(DMI.DataHandler.QuoteString(Details(tblRespondentProperties.PropertyName))))

            If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
                Return String.Format("Property {0} already exists. Please correct the property name.", Me.Details(tblRespondentProperties.PropertyName))

            End If

        End If

        Return ""

    End Function

End Class
