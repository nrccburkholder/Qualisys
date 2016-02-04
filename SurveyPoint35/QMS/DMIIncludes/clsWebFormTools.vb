Option Explicit On
Option Strict On

Imports System.Web
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports Microsoft.ApplicationBlocks.Data

Public Class WebFormTools

    'display a message box on page load
    Public Shared Sub Msgbox(ByRef p As System.Web.UI.Page, ByVal sMsg As String)
        Dim sScript As String

        If sMsg.Length > 0 Then
            sMsg = Replace(sMsg, "'", "\'")
            sScript = String.Format("<script language='javascript'>alert('{0}');</script>", sMsg)
            p.RegisterStartupScript("ss", sScript)

        End If

    End Sub

    'sets focus to a input field on page load
    Public Shared Sub SetFocus(ByRef p As System.Web.UI.Page, ByVal sControlName As String)
        Dim s As String

        s = "<script language = ""javascript"">"
        s &= String.Format("document.getElementById(""{0}"").focus();", sControlName)
        s &= "</script>"
        p.RegisterStartupScript("FocusManager", s)

    End Sub

#Region "Get HTML Control functions"
    Shared Function GetLiteral(ByVal sTxt As String) As Literal
        Dim lt As New Literal()

        lt.Text = sTxt

        Return lt

    End Function

    Shared Function GetCheckBox(ByVal sName As String, ByVal sValue As String, ByVal iChecked As Integer, Optional ByVal sID As String = "") As HtmlInputCheckBox
        Dim cb As New HtmlInputCheckBox()

        If sID.Length = 0 Then sID = sName

        cb.Name = sName
        cb.ID = sID
        cb.Value = sValue
        cb.Checked = CBool(iChecked)

        Return cb

    End Function

    Shared Function GetRadioButton(ByVal sName As String, ByVal sValue As String, ByVal iChecked As Integer, Optional ByVal sID As String = "", Optional ByVal sClass As String = "") As HtmlInputRadioButton
        Dim rb As New HtmlInputRadioButton()

        If sID.Length = 0 Then sID = sName

        rb.Name = sName
        rb.ID = sID
        rb.Value = sValue
        rb.Checked = CBool(iChecked)

        If sClass.Length > 0 Then rb.Attributes.Add("class", sClass)

        Return rb

    End Function

    Shared Function GetTextBox(ByVal sName As String, ByVal sText As String, Optional ByVal sClass As String = "") As HtmlInputText
        Dim tb As New HtmlInputText("Text")

        tb.ID = sName
        tb.Value = sText
        If sClass.Length > 0 Then tb.Attributes.Add("class", sClass)

        Return tb

    End Function

    Shared Function GetHiddenField(ByVal sID As String, ByVal sText As String) As HtmlInputHidden
        Dim hf As New HtmlInputHidden()

        hf.Name = sID
        hf.ID = sID
        hf.Value = sText

        Return hf

    End Function

    Shared Function GetDropDownList(ByVal sID As String, Optional ByVal sClass As String = "") As HtmlSelect
        Dim ddl As New HtmlSelect()

        ddl.ID = sID
        ddl.Items.Add("Select An Item")

        If sClass.Length > 0 Then ddl.Attributes.Add("class", sClass)

        Return ddl

    End Function

    Shared Function GetDropDownList(ByVal sID As String, ByVal dr As SqlClient.SqlDataReader, ByVal sValueField As String, ByVal sTextField As String, Optional ByVal sSetValue As String = "", Optional ByVal sClass As String = "") As HtmlSelect
        Dim ddl As New HtmlSelect()

        ddl.ID = sID
        ddl.DataValueField = sValueField
        ddl.DataTextField = sTextField
        ddl.DataSource = dr
        ddl.DataBind()

        If sSetValue.Length > 0 Then
            If Not IsNothing(ddl.Items.FindByValue(sSetValue)) Then
                ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(sSetValue))

            End If
        End If

        If sClass.Length > 0 Then ddl.Attributes.Add("class", sClass)

        Return ddl

    End Function

    Shared Function GetDropDownList(ByVal sID As String, ByVal sSQL As String, ByVal sValueField As String, ByVal sTextField As String, Optional ByVal sSetValue As String = "") As HtmlSelect
        Dim dr As SqlClient.SqlDataReader
        'TP Ent Lib Update
        dr = DirectCast(SqlHelper.Db(DataHandler.sConnection).ExecuteReader(CommandType.Text, sSQL), SqlClient.SqlDataReader)
        'dr = SqlHelper.ExecuteReader(DataHandler.sConnection, CommandType.Text, sSQL)

        Return GetDropDownList(sID, dr, sValueField, sTextField, sSetValue)

    End Function

#End Region

#Region "Text-based HTML Control functions"

    <Obsolete("Use CheckBoxHTML")> _
    Shared Function GetCheckBoxHTML(ByVal sName As String, ByVal sValue As String, ByVal iChecked As Integer, Optional ByVal sID As String = "", Optional ByVal sClass As String = "") As Literal
        Dim cb As New Literal()

        If sID.Length = 0 Then sID = sName

        cb.Text = String.Format("<input name=""{0}"" id=""{1}"" class=""{4}"" type=""checkbox"" value=""{2}"" {3} />", _
            sName, sID, sValue, IIf(iChecked = 1, "Checked", ""), sClass)

        Return cb

    End Function

    Shared Function TextBoxHTML(ByVal sName As String, ByVal sID As String, ByVal sValue As String, ByVal iMaxLen As Integer, ByVal sClass As String) As String
        If sID.Length = 0 Then sID = sName
        Return String.Format("<input type=""text"" id=""{0}"" name=""{1}"" maxlength=""{2}"" value=""{3}"" class=""{4}"">", _
            sID, sName, iMaxLen, sValue, sClass)

    End Function

    Shared Function CheckBoxHTML(ByVal sName As String, ByVal sID As String, ByVal sValue As String, ByVal bChecked As Boolean, ByVal sClass As String) As String
        If sID.Length = 0 Then sID = sName
        Return String.Format("<input type=""checkbox"" id=""{0}"" name=""{1}"" {2} value=""{3}"" class=""{4}"">", _
            sID, sName, IIf(bChecked, "checked", ""), sValue, sClass)

    End Function

    Shared Function DropDownListHTML(ByVal sName As String, ByVal sID As String, ByVal sSelectedValue As String, ByVal sqlDR As SqlClient.SqlDataReader, ByVal sValueField As String, ByVal sTextField As String, ByVal sClass As String, ByVal sDefaultValue As String, ByVal sDefaultText As String) As String
        Dim sbDDL As New Text.StringBuilder()

        If sID.Length = 0 Then sID = sName
        sbDDL.AppendFormat("<select id=""{0}"" name=""{1}"" class=""{2}"">", sID, sName, sClass)
        If sDefaultValue.Length > 0 And sDefaultText.Length > 0 Then
            sbDDL.AppendFormat("<option value=""{0}"">{1}</option>", sDefaultValue, sDefaultText)

        End If

        Do Until Not sqlDR.Read
            sbDDL.AppendFormat("<option value=""{0}"" {2}>{1}</option>", sqlDR.Item(sValueField), sqlDR.Item(sTextField), IIf(sqlDR.Item(sValueField).ToString = sSelectedValue, "selected", ""))

        Loop

        sbDDL.Append("</select>")

        Return sbDDL.ToString

    End Function

    Shared Function DropDownListHTML(ByVal sName As String, ByVal sID As String, ByVal sSelectedValue As String, ByVal arOptions As Array, ByVal sClass As String, ByVal sDefaultValue As String, ByVal sDefaultText As String) As String
        Dim sbDDL As New Text.StringBuilder()
        Dim i As Integer

        If sID.Length = 0 Then sID = sName
        sbDDL.AppendFormat("<select id=""{0}"" name=""{1}"" class=""{2}"">", sID, sName, sClass)
        If sDefaultValue.Length > 0 And sDefaultText.Length > 0 Then
            sbDDL.AppendFormat("<option value=""{0}"">{1}</option>", sDefaultValue, sDefaultText)

        End If


        For i = 0 To arOptions.Length - 1 Step 2
            sbDDL.AppendFormat("<option value=""{0}"" {2}>{1}</option>", arOptions.GetValue(i), arOptions.GetValue(i + 1), IIf(arOptions.GetValue(i).ToString = sSelectedValue, "selected", ""))

        Next

        sbDDL.Append("</select>")

        Return sbDDL.ToString

    End Function

#End Region
    Shared Function FindFormKey(ByRef httpR As HttpRequest, ByVal sKeyName As String) As String
        Dim rx As New System.Text.RegularExpressions.Regex(String.Format("[^:]*{0}$", sKeyName))
        Dim sKey As String

        For Each sKey In httpR.Form.AllKeys
            If rx.IsMatch(sKey) Then
                Return httpR.Form(sKey)

            End If
        Next

        Return ""

    End Function

    Shared Sub SetReferingURL(ByRef r As HttpRequest, ByRef hl As HyperLink)
        hl.NavigateUrl = r.UrlReferrer.PathAndQuery

    End Sub

    Shared Sub SetReferingURL(ByRef r As HttpRequest, ByRef hl As HyperLink, ByVal sNotURL As String, ByRef Session As System.Web.SessionState.HttpSessionState)
        Dim rx As Text.RegularExpressions.Regex

        'note: UrlReferrer is nothing if redirected from same page
        If Not IsNothing(r.UrlReferrer) AndAlso _
            Not rx.IsMatch(r.UrlReferrer.PathAndQuery, sNotURL) AndAlso _
            r.UrlReferrer.PathAndQuery <> r.RawUrl Then
            Dim sURL As String = r.UrlReferrer.PathAndQuery
            Session("refer") = sURL
            hl.NavigateUrl = sURL

        ElseIf Not IsNothing(Session("refer")) Then
            hl.NavigateUrl = Session("refer").ToString

        Else
            hl.NavigateUrl = r.UrlReferrer.PathAndQuery

        End If

    End Sub

    Shared Function ReflectURL(ByRef r As HttpRequest) As String
        If IsNothing(r.UrlReferrer) Then
            Return "../default.aspx"

        Else
            Return r.UrlReferrer.PathAndQuery

        End If
    End Function

    Shared Sub FillDDL(ByRef ddl As DropDownList, ByVal sListItems As String)
        Dim arListItems As String() = Split(sListItems, ";")
        Dim i As Integer

        For i = 0 To arListItems.Length - 1 Step 2
            ddl.Items.Add(New ListItem(arListItems(i + 1), arListItems(i)))

        Next

    End Sub

    Public Shared Sub GetSortOrderList(ByRef lc As ListControl, ByVal iItemOrder As Integer, ByVal iMaxOrder As Integer)
        Dim i As Integer
        Dim li As ListItem

        For i = 1 To iMaxOrder
            If i < iItemOrder Then
                lc.Items.Add(New ListItem(i.ToString, CStr(i - 1)))

            ElseIf i > iItemOrder Then
                lc.Items.Add(New ListItem(i.ToString, CStr(i + 1)))

            Else
                lc.Items.Add(New ListItem(i.ToString, i.ToString))

            End If
        Next

        li = lc.Items.FindByValue(iItemOrder.ToString)
        If Not IsNothing(li) Then li.Selected = True

    End Sub
    Public Shared Sub SetListControl(ByRef lc As ListControl, ByRef dt As DataTable, ByVal sValueCol As String)
        Dim dr As DataRow

        For Each dr In dt.Rows
            lc.Items.FindByValue(dr.Item(sValueCol).ToString).Selected = True

        Next

    End Sub

    Public Shared Sub SetListControl(ByRef lc As ListControl, ByVal sValueCol As Object)
        lc.SelectedIndex = lc.Items.IndexOf(lc.Items.FindByValue(sValueCol.ToString))

    End Sub

    Shared Sub DisplayMsgLabel(ByRef lblMsg As Label, ByVal sMsg As String, ByVal cColor As Drawing.Color)

        With lblMsg
            .Text = sMsg
            .Font.Bold = True
            .ForeColor = cColor
            .Visible = True

        End With

    End Sub

    Shared Sub ShowHidePanel(ByRef imgb As ImageButton, ByRef pnl As Panel, Optional ByVal sHideURL As String = "../images/qms_arrowup_sym.gif", Optional ByVal sShowURL As String = "../images/qms_arrowdown_sym.gif")

        If imgb.ImageUrl = sShowURL Then
            imgb.ImageUrl = sHideURL
            pnl.Visible = True

        Else
            imgb.ImageUrl = sShowURL
            pnl.Visible = False

        End If

    End Sub

    Shared Function GetTableCell(ByVal sText As String) As TableCell
        Dim tc As New TableCell()

        tc.Text = sText

        Return tc

    End Function

End Class
