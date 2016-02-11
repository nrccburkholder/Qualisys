Public Enum tblScriptScreenCategories
    ScriptScreenCategoryID = 0
    ScriptScreenID = 1
    AnswerCategoryID = 2
    JumpToScriptScreenID = 3
    Text = 4
    AnswerCategoryValue = 5
    AnswerCategoryText = 6
    AnswerCategoryTypeName = 7
    ShowCategory = 8

End Enum

<Obsolete("use QMS.clsScriptScreenCategories")> _
Public Class clsScriptScreenCategories
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Protected _iScriptScreenID As Integer

    Default Public Overloads Property Details(ByVal eField As tblScriptScreenCategories) As Object
        Get
            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblScriptScreenCategories.ScriptScreenCategoryID Then
                Me._iEntityID = Value

            ElseIf eField = tblScriptScreenCategories.ScriptScreenID Then
                Me._iScriptScreenID = Value

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
                    Me._iEntityID = Me.Details(tblScriptScreenCategories.ScriptScreenCategoryID)
                    Me._iScriptScreenID = Me.Details(tblScriptScreenCategories.ScriptScreenID)

                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "ScriptScreenCategories"

        'INSERT SQL
        Me._sInsertSQL = "INSERT INTO ScriptScreenCategories (ScriptScreenID, AnswerCategoryID, JumpToScriptScreenID, Text) "
        Me._sInsertSQL &= "VALUES({1}, {2}, {3}, {4}) "

        'UPDATE SQL
        Me._sUpdateSQL = "UPDATE ScriptScreenCategories SET ScriptScreenID = {1}, AnswerCategoryID = {2}, JumpToScriptScreenID = {3}, Text = {4} "
        Me._sUpdateSQL &= "WHERE ScriptScreenCategoryID = {0}"

        'DELETE SQL
        Me._sDeleteSQL = "DELETE FROM ScriptScreenCategories WHERE ScriptScreenCategoryID = {0} "

        'SELECT SQL
        Me._sSelectSQL = "SELECT * FROM v_ScriptScreenCategories "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblScriptScreenCategories.ScriptScreenCategoryID), _
                            Details(tblScriptScreenCategories.ScriptScreenID), _
                            Details(tblScriptScreenCategories.AnswerCategoryID), _
                            Details(tblScriptScreenCategories.JumpToScriptScreenID), _
                            DMI.DataHandler.QuoteString(Details(tblScriptScreenCategories.Text)))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblScriptScreenCategories.ScriptScreenCategoryID), _
                            Details(tblScriptScreenCategories.ScriptScreenID), _
                            Details(tblScriptScreenCategories.AnswerCategoryID), _
                            Details(tblScriptScreenCategories.JumpToScriptScreenID), _
                            DMI.DataHandler.QuoteString(Details(tblScriptScreenCategories.Text)))

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL = String.Format("ScriptScreenCategoryID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Details(tblScriptScreenCategories.ScriptScreenID)) Then
                sWHERESQL = String.Format("ScriptScreenID = {0} AND ", Details(tblScriptScreenCategories.ScriptScreenID))

            End If

            If Not IsDBNull(Details(tblScriptScreenCategories.AnswerCategoryID)) Then
                If Details(tblScriptScreenCategories.AnswerCategoryID) > 0 Then
                    sWHERESQL = String.Format("AnswerCategoryID = {0} AND ", Details(tblScriptScreenCategories.AnswerCategoryID))

                End If

            End If

            If Details(tblScriptScreenCategories.Text).ToString.Length > 0 Then
                sWHERESQL &= String.Format("Text = {0} AND ", Details(tblScriptScreenCategories.Text))

            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    'Builds delete SQL from dataset
    Protected Overrides Function GetDeleteSQL() As String

        Return String.Format(Me._sDeleteSQL, Details(tblScriptScreenCategories.ScriptScreenCategoryID))

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("ScriptScreenCategoryID") = 0
        dr.Item("ScriptScreenID") = Me._iScriptScreenID
        dr.Item("AnswerCategoryID") = 0
        dr.Item("JumpToScriptScreenID") = 0
        dr.Item("Text") = ""

    End Sub

End Class
