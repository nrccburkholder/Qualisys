Imports Nrc.Framework.BusinessLogic
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_UserControls_ThemeQuestionEditor
    Inherits System.Web.UI.UserControl
    Implements INamingContainer

#Region " Private/Protected Properties "

    Public Property ThemeId() As Integer
        Get
            If ViewState("ThemeId") Is Nothing Then
                Return 0
            Else
                Return CInt(ViewState("ThemeId"))
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("ThemeId") = value
        End Set
    End Property

    Private Property GridSortDirection() As ComponentModel.ListSortDirection
        Get
            If ViewState("GridSortDirection") Is Nothing Then
                Return ComponentModel.ListSortDirection.Ascending
            Else
                Return DirectCast(ViewState("GridSortDirection"), ComponentModel.ListSortDirection)
            End If
        End Get
        Set(ByVal value As ComponentModel.ListSortDirection)
            ViewState("GridSortDirection") = value
        End Set
    End Property

    Private Property GridSortExpression() As String
        Get
            If ViewState("GridSortExpression") Is Nothing Then
                Return String.Empty
            Else
                Return CType(ViewState("GridSortExpression"), String)
            End If
        End Get
        Set(ByVal value As String)
            ViewState("GridSortExpression") = value
        End Set
    End Property

#End Region

#Region " Page Events "

    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.QuestionErrorLabel.Text = ""
        Me.GridErrorMessages.Text = ""
    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        Me.InitCheckBoxJavascript()
    End Sub
#End Region

    Public Sub Populate()
        Me.BindThemeGrid()
    End Sub

#Region " Page Initialization "
    Private Sub InitCheckBoxJavascript()
        For Each row As GridViewRow In Me.ThemeGrid.Rows
            Dim cbx As CheckBox = DirectCast(row.FindControl("SelectQuestionCheckBox"), CheckBox)
            Page.ClientScript.RegisterArrayDeclaration("QuestionsCheckBoxIDs", String.Concat("'", cbx.ClientID, "'"))
        Next
    End Sub

    Private Sub BindThemeGrid()
        Dim questions As ThemeQuestionCollection

        questions = ThemeQuestion.GetByThemeId(Me.ThemeId)

        Dim sortedQuestions As New SortedBindingList(Of ThemeQuestion)(questions)
        If Not String.IsNullOrEmpty(Me.GridSortExpression) Then
            sortedQuestions.ApplySort(Me.GridSortExpression, Me.GridSortDirection)
        End If

        Me.ThemeGrid.DataSource = sortedQuestions
        Me.ThemeGrid.DataBind()
    End Sub
#End Region

#Region " Control Event Handlers "

    Private Sub ThemeGrid_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles ThemeGrid.Sorting
        If Me.GridSortExpression = e.SortExpression Then
            If Me.GridSortDirection = ComponentModel.ListSortDirection.Ascending Then
                Me.GridSortDirection = ComponentModel.ListSortDirection.Descending
            Else
                Me.GridSortDirection = ComponentModel.ListSortDirection.Ascending
            End If
        Else
            Me.GridSortDirection = ComponentModel.ListSortDirection.Ascending
        End If
        Me.GridSortExpression = e.SortExpression

        Me.BindThemeGrid()
    End Sub

    Protected Sub DeleteCheckedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteCheckedButton.Click
        Dim errorMessages As New List(Of String)

        For i As Integer = 0 To Me.ThemeGrid.Rows.Count - 1
            Dim cbx As CheckBox = TryCast(ThemeGrid.Rows(i).Cells(0).FindControl("SelectQuestionCheckBox"), CheckBox)
            If cbx IsNot Nothing Then
                If cbx.Checked Then
                    Dim questionId As Integer = CInt(Me.ThemeGrid.DataKeys(i).Value)
                    Try
                        ThemeQuestion.RemoveQuestionFromTheme(Me.ThemeId, questionId, CurrentUser.Name)
                    Catch ex As Exception
                        errorMessages.Add(String.Format("Question '{0}': {1}", questionId, ex.Message))
                    End Try
                End If
            End If
        Next

        If errorMessages.Count > 0 Then
            GridErrorMessages.Text = String.Join("<br />", errorMessages.ToArray)
        End If

        Me.BindThemeGrid()
    End Sub

    Protected Sub AssignButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AssignButton.Click
        Dim errorMessage As String = Nothing
        Dim questionId As Integer

        Try
            If Not Integer.TryParse(Me.QuestionIdTextBox.Text, questionId) Then
                errorMessage = String.Format("Question '{0}': Not a valid question ID", Me.QuestionIdTextBox.Text)
                Return
            End If

            ThemeQuestion.AddQuestionToTheme(Me.ThemeId, questionId, CurrentUser.Name)

            Me.QuestionIdTextBox.Text = ""

            Me.BindThemeGrid()

        Catch ex As Exception
            errorMessage = String.Format("Question '{0}': {1}", questionId, ex.Message)

        Finally
            If (errorMessage IsNot Nothing) Then
                QuestionErrorLabel.Text = errorMessage
            End If
        End Try

    End Sub

#End Region

#Region " Private/Protected Methods "

    Protected Function IsQuestionCheckable(ByVal statusValue As Object) As Boolean
        Dim status As ThemeQuestionStatus = DirectCast(statusValue, ThemeQuestionStatus)
        Return (status = ThemeQuestionStatus.Live OrElse status = ThemeQuestionStatus.PendingAdd)
    End Function

#End Region

End Class