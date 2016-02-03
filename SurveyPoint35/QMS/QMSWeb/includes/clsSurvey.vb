Public Enum tblSurveys
    SurveyID = 0
    Name = 1
    Description = 2
    CreatedByUserID = 3
    CreatedOnDate = 4
    Active = 5
    CreatedBy = 6

End Enum

<Obsolete("Use QMS.clsSurveys")> _
Public Class clsSurvey
    Inherits clsDBEntity

    Private _iCreatedByUserID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblSurveys) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblSurveys.SurveyID Then
                Me._iEntityID = Value

            ElseIf eField = tblSurveys.CreatedByUserID Then
                Me._iCreatedByUserID = Value

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "Surveys"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO Surveys(Name, Description, CreatedByUserID, Active) "
        Me._sInsertSQL &= "VALUES({1},{2},{3},{5})"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE Surveys SET Name = {1}, Description = {2}, CreatedByUserID = {3}, Active = {5} "
        Me._sUpdateSQL &= "WHERE SurveyID = {0}"

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM Surveys WHERE SurveyID = {0}"

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT s.SurveyID, s.Name, s.Description, s.CreatedByUserID, s.CreatedOnDate, s.Active, ISNULL(u.FirstName, '') + ISNULL(' ' + u.LastName, '') AS CreatedBy "
        Me._sSelectSQL &= "FROM Surveys s INNER JOIN Users u "
        Me._sSelectSQL &= "ON s.CreatedByUserID = u.UserID "

    End Sub


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As New System.Text.StringBuilder()

        If Me._iEntityID > 0 Then
            sWHERESQL.AppendFormat("s.SurveyID = {0} AND ", Me._iEntityID)

        Else

            If Me.Details(tblSurveys.Name).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("s.Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblSurveys.Name)))

            End If

            If Me.Details(tblSurveys.Description).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("s.Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblSurveys.Description)))

            End If

            If Not IsDBNull(Me.Details(tblSurveys.CreatedByUserID)) Then
                If Me.Details(tblSurveys.CreatedByUserID) > 0 Then
                    sWHERESQL.AppendFormat("s.CreatedByUserID = {0} AND ", Details(tblSurveys.CreatedByUserID))

                End If

            End If

            If Me.Details(tblSurveys.Active).ToString.Length > 0 Then
                sWHERESQL.AppendFormat("s.Active = {0} AND ", Math.Abs(Details(tblSurveys.Active)))

            End If

        End If

        If sWHERESQL.Length > 0 Then
            sWHERESQL.Insert(0, "WHERE ")
            sWHERESQL.Remove(sWHERESQL.Length - 4, 4)

        End If

        sWHERESQL.Insert(0, Me._sSelectSQL)
        sWHERESQL.Append("ORDER BY Name")

        Return sWHERESQL.ToString

    End Function

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        sSQL = String.Format(sSQL, Details(tblSurveys.SurveyID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveys.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveys.Description)), _
                            Details(tblSurveys.CreatedByUserID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveys.CreatedOnDate)), _
                            Math.Abs(Details(tblSurveys.Active)))

        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        sSQL = String.Format(sSQL, Details(tblSurveys.SurveyID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveys.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblSurveys.Description)), _
                            Details(tblSurveys.CreatedByUserID), _
                            DMI.DataHandler.QuoteString(Details(tblSurveys.CreatedOnDate)), _
                            Math.Abs(Details(tblSurveys.Active)))

        Return sSQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(tblSurveys.SurveyID))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("SurveyID") = 0
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("CreatedByUserID") = Me._iCreatedByUserID
        dr.Item("CreatedOnDate") = Now()
        dr.Item("Active") = 1

    End Sub

    Protected Overrides Function VerifyDelete() As String
        Dim sSQL As String
        Dim ds As DataSet

        sSQL = "SELECT s.Active, COUNT(sq.SurveyQuestionID) AS SurveyQuestionCount "
        sSQL &= "FROM Surveys s LEFT OUTER JOIN SurveyQuestions sq "
        sSQL &= "ON s.SurveyID = sq.SurveyID "
        sSQL &= String.Format("WHERE s.SurveyID = {0} GROUP BY s.Active ", Me._iEntityID)

        If DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL, "VerifyDelete") Then
            If ds.Tables("VerifyDelete").Rows(0).Item("Active") = 0 Then
                If ds.Tables("VerifyDelete").Rows(0).Item("SurveyQuestionCount") = 0 Then
                    sSQL = "SELECT COUNT(SurveyInstanceID) FROM SurveyInstances "
                    sSQL &= String.Format("WHERE SurveyID = {0} ", Me._iEntityID)

                    If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) > 0 Then
                        Return String.Format("Survey id {0} cannot be deleted. Survey used by survey instances.\n", Me._iEntityID)

                    Else
                        Return ""

                    End If

                Else
                    Return String.Format("Survey id {0} cannot be deleted. Survey still has questions.\n", Me._iEntityID)

                End If
            Else
                Return String.Format("Survey id {0} cannot be deleted. Survey is still active.\n ", Me._iEntityID)

            End If
        End If

        Return "Error validating delete.\n "

    End Function

    Public Function GetSurveyQuestions() As DataTable
        Dim sSQL As String

        If Me._dsEntity.Tables.IndexOf("SurveyQuestions") > -1 Then
            Me._dsEntity.Tables.Remove("SurveyQuestions")

        End If

        sSQL = "SELECT sq.SurveyQuestionID, sq.SurveyID, sq.QuestionID, sq.DisplayNumber, "
        sSQL &= "sq.ItemOrder, q.Text AS QuestionText, q.QuestionTypeID, qt.Name AS QuestionTypeName "
        sSQL &= "FROM SurveyQuestions sq INNER JOIN Questions q "
        sSQL &= "ON sq.QuestionID = q.QuestionID INNER JOIN QuestionTypes qt "
        sSQL &= "ON q.QuestionTypeID = qt.QuestionTypeID "
        sSQL &= String.Format("WHERE sq.SurveyID = {0} ", Me._iEntityID)

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "SurveyQuestions") Then

            Return Me._dsEntity.Tables("SurveyQuestions")

        End If

    End Function

    Public Sub AddSurveyQuestion(ByVal iQuestionID As Integer)
        Dim sSQL As String

        sSQL = "INSERT INTO SurveyQuestions(SurveyID, QuestionID, ItemOrder) "
        sSQL &= "(SELECT {0}, {1}, ISNULL(MAX(sq.ItemOrder), 0) + 1 "
        sSQL &= "FROM SurveyQuestions sq "
        sSQL &= "WHERE (sq.SurveyID = {0})) "
        sSQL = String.Format(sSQL, Me._iEntityID, iQuestionID)

        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

    End Sub

    Public Function DeleteSurveyQuestion(ByVal iSurveyQuestionID As Integer) As Boolean
        Dim sSQL As String

        sSQL = String.Format("SELECT ISNULL(COUNT(SurveyQuestionID),0) FROM Responses WHERE SurveyQuestionID = {0}", iSurveyQuestionID)

        If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) = 0 Then
            sSQL = String.Format("SELECT COUNT(ScriptScreenID) FROM ScriptScreens WHERE SurveyQuestionID = {0}", iSurveyQuestionID)

            If CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL)) = 0 Then
                sSQL = String.Format("DELETE FROM SurveyQuestions WHERE SurveyQuestionID = {0} ", iSurveyQuestionID)

                DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

                Me.GetSurveyQuestions()
                Me.ResortSurveyQuestions()

                Return True

            Else
                Me._sErrorMsg &= String.Format("Survey question id {0} cannot be deleted. Survey question is referenced by scripts.\n", iSurveyQuestionID)

                Return False

            End If

        Else
            Me._sErrorMsg &= String.Format("Survey question id {0} cannot be deleted. Survey question as responses.\n", iSurveyQuestionID)

            Return False

        End If

        Return False

    End Function

    Public Sub ResortSurveyQuestions()
        Dim sSQL As String = ""
        Dim dv As DataView
        Dim drv As DataRowView
        Dim iItemOrder As Integer = 1

        dv = Me._dsEntity.Tables("SurveyQuestions").DefaultView
        dv.Sort = "ItemOrder"

        For Each drv In dv.Table.DefaultView
            sSQL &= String.Format("UPDATE SurveyQuestions SET ItemOrder = {1} WHERE SurveyQuestionID = {0}; " & vbCrLf, _
                                    drv.Item("SurveyQuestionID"), iItemOrder)
            drv.Item("ItemOrder") = iItemOrder

            iItemOrder += 1

        Next

        If sSQL.Length > 0 Then
            DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        End If

    End Sub

    Public Sub ResortSurveyQuestions(ByVal ht As Hashtable)
        Dim dr As DataRow
        Dim iQuestionID As Integer

        For Each dr In Me._dsEntity.Tables("SurveyQuestions").Rows
            iQuestionID = dr.Item("SurveyQuestionID")
            dr.Item("ItemOrder") = ht.Item(iQuestionID)

        Next

        Me.ResortSurveyQuestions()

    End Sub

    Public ReadOnly Property SurveyQuestionCount() As Integer
        Get

            If Me._dsEntity.Tables.IndexOf("SurveyQuestions") = -1 Then
                Me.GetSurveyQuestions()
            End If

            Return Me._dsEntity.Tables("SurveyQuestions").Rows.Count

        End Get

    End Property

    Public Function Copy(ByVal iSurveyID As Integer) As Integer
        Dim sSQL As String
        Dim iNewSurveyID As Integer

        'copy survey record
        sSQL = "INSERT INTO Surveys (Name, Description, CreatedByUserID, CreatedOnDate, Active) "
        sSQL &= "(SELECT 'Copy of ' + Name, Description, {1}, GETDATE(), Active FROM Surveys "
        sSQL &= "WHERE SurveyID = {0}); SELECT ISNULL(@@IDENTITY,0) "
        sSQL = String.Format(sSQL, iSurveyID, Me._iCreatedByUserID)
        iNewSurveyID = CInt(DMI.SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

        'copy survey question records
        sSQL = "INSERT INTO SurveyQuestions (SurveyID, QuestionID, DisplayNumber, ItemOrder) "
        sSQL &= "SELECT {1}, QuestionID, DisplayNumber, ItemOrder FROM SurveyQuestions "
        sSQL &= "WHERE SurveyID = {0} "
        sSQL = String.Format(sSQL, iSurveyID, iNewSurveyID)
        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        Return iNewSurveyID

    End Function

End Class
