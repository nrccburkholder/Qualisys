Imports System.ComponentModel
Imports System.Text
Imports System.Web.UI
Namespace Web
    <ToolboxData("<{0}:MenuBoxV1 runat=server></{0}:MenuBoxV1>")> _
    Public Class MenuBoxV1
        Inherits System.Web.UI.WebControls.WebControl

#Region " Application Variables "

        Private mstrHTML As String = ""
        Private mintMenuPadding As Integer = 8
        Private MenuItems As New MenuItemCollectionV1
        Private mstrMenuTitle As String = "MenuBox v1.1"
        Private mstrMenuWidth As String = "165"
        Private mstrImagesPath As String = "../img/"
        Private mbolIsUpLevel As Boolean

#End Region

#Region " Application Properties "

        Public Enum mbStyle
            Standard = 0
            SoftBlue = 1
            SilverBox = 2
            PurpleBox = 3
        End Enum

        Private mbsStyle As mbStyle = 0

        <Bindable(True), Category("MenuBox")> _
    Property MenuStyle() As mbStyle
            Get
                Return mbsStyle
            End Get
            Set(ByVal Value As mbStyle)
                mbsStyle = Value
            End Set
        End Property

        <Bindable(True), Category("MenuBox")> _
    Property MenuPadding() As Integer
            Get
                Return mintMenuPadding
            End Get
            Set(ByVal Value As Integer)
                mintMenuPadding = Value
            End Set
        End Property

        <Bindable(True), Category("MenuBox")> _
     ReadOnly Property Items() As MenuItemCollectionV1
            Get
                Return MenuItems
            End Get
        End Property

        <Bindable(True), Category("MenuBox")> _
    Property MenuTitle() As String
            Get
                Return mstrMenuTitle
            End Get
            Set(ByVal Value As String)
                mstrMenuTitle = Value
            End Set
        End Property

        <Bindable(True), Category("MenuBox")> _
    Property MenuWidth() As String
            Get
                Return mstrMenuWidth
            End Get
            Set(ByVal Value As String)
                mstrMenuWidth = Value
            End Set
        End Property

        <Bindable(True), Category("MenuBox")> _
    Property ImagesPath() As String
            Get
                Return mstrImagesPath
            End Get
            Set(ByVal Value As String)
                mstrImagesPath = Value
            End Set
        End Property

#End Region

#Region " Render and Page Load Functions "

        Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)
            Dim sbHTML As New StringBuilder

            'Write out the default, design time menubox...
            If mstrHTML = "" Then
                BuildSpacer(sbHTML)
                BuildHeader(sbHTML)
                BuildDesignTimeContent(sbHTML)
                BuildFooter(sbHTML)
            Else
                'Build the actual menu...
                sbHTML.Append(mstrHTML)
            End If

            'Output the menu object...
            output.Write(sbHTML.ToString)

        End Sub

        Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

            mbolIsUpLevel = IsUpLevel()
            mstrHTML = GenerateMenuBox()

        End Sub

        Private Function GenerateMenuBox() As String
            Dim sbHTML As New StringBuilder


            'GenJavascript(sbHTML)
            BuildSpacer(sbHTML)
            BuildHeader(sbHTML)
            BuildContent(sbHTML)
            BuildFooter(sbHTML)

            Return sbHTML.ToString

        End Function

#End Region

#Region " Generate Javascript "

        Private Sub GenJavascript(ByRef sbHTML)

        End Sub

#End Region

#Region " Generate the HTML "

        Private Sub BuildHeader(ByRef sbHTML)
            Select Case mbsStyle
                Case mbStyle.Standard

                Case mbStyle.SoftBlue
                    sbHTML.Append(vbTab & "<TABLE cellSpacing=""0"" cellPadding=""0"" width=""" & mstrMenuWidth & """ border=""0"">" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & "<TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""0"" cellPadding=""0"" width=""100%"" border=""0"">" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD vAlign=""top"" bgColor=""#6598cc""><IMG alt="""" src=""" & mstrImagesPath & "mTopRCrnr.gif""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%"" bgColor=""#6598cc""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD vAlign=""top"" bgColor=""#6598cc""><IMG alt="""" src=""" & mstrImagesPath & "mTopLCrnr.gif""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & "<TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""0"" cellPadding=""0"" width=""100%"" border=""0"">" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    'sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#003399"" colSpan=""2"" height=""25"" class=""TableHeaderBlue"">&nbsp;<FONT face=""Verdana"" color=""#ffffff"" size=""2""><STRONG>" & mstrMenuTitle & "</STRONG></FONT></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#003399"" colSpan=""2"" height=""25"" class=""TableHeaderBlue"" style=""background-color: #003399; filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=1, StartColorStr='#003399', EndColorStr='#6699CC');"">&nbsp;<FONT face=""Verdana"" color=""#ffffff"" size=""2""><STRONG>" & mstrMenuTitle & "</STRONG></FONT></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#666666""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#cccccc""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%"">" & vbCrLf)
                    'sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""2"" cellPadding=""0"" width=""100%"" border=""0"" bgcolor=""#ffffff"" class=""TableBodyBlueNoBrdrs"">" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""2"" cellPadding=""0"" width=""100%"" border=""0"" bgcolor=""#ffffff"" style=""background-color: #ffffff; filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=1, StartColorStr='#fdfefe', EndColorStr='#ceddee');"">" & vbCrLf)
                Case mbStyle.SilverBox
                    sbHTML.Append("<TABLE cellSpacing=""0"" cellPadding=""0"" width=""" & mstrMenuWidth & """ border=""0"">" & vbCrLf)
                    sbHTML.Append(vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "<TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & "<TABLE style=""BORDER-RIGHT: #7c7c7c 1px solid; BORDER-TOP: #7c7c7c 1px solid; BORDER-LEFT: #7c7c7c 1px solid; BORDER-BOTTOM: #7c7c7c 1px solid"" cellSpacing=""1"" cellPadding=""5"" width=""100%"" bgColor=""#e3e4e3"" border=""0"">" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TD style=""FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr='#666666', EndColorStr='#999999'); BACKGROUND-COLOR: #999999"" height=""25""><FONT face=""Verdana, Arial, Helvetica"" color=""#ffffff"" size=""2""><STRONG>" & mstrMenuTitle & "</STRONG></FONT></TD></TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TD>" & vbCrLf & vbCrLf)
                Case mbStyle.PurpleBox
                    With sbHTML
                        .Append("<TABLE cellSpacing=""0"" cellPadding=""0"" width=""" & mstrMenuWidth & """ border=""0"">" & vbCrLf)
                        .Append(vbTab & "<TR>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD><IMG alt="""" src=""" & mstrImagesPath & "tmnu_topleft.gif""></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD width=""100%"" background=""" & mstrImagesPath & "tmnu_top.gif""><IMG alt="""" height=""8"" src=""" & mstrImagesPath & "ghost.gif"" width=""1""></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD><IMG alt="""" src=""" & mstrImagesPath & "tmnu_topright.gif""></TD>" & vbCrLf)
                        .Append(vbTab & "</TR>" & vbCrLf)

                        .Append(vbTab & "<TR>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD background=""" & mstrImagesPath & "tmnu_left.gif""><IMG alt="""" src=""" & mstrImagesPath & "tmnu_left.gif""></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD vAlign=""top"" width=""100%"" background=""" & mstrImagesPath & "tmnu_back.gif"">" & vbCrLf)

                        .Append(vbTab & vbTab & vbTab & "<TABLE cellSpacing=""2"" cellPadding=""0"" width=""100%"" border=""0"">" & vbCrLf)
                        .Append(vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TD><FONT face=""Verdana, Arial, Helvetica"" size=""2""><STRONG>" & mstrMenuTitle & "</STRONG></FONT></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                        .Append(vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TD><IMG alt="""" height=""2"" src=""" & mstrImagesPath & "ghost.gif"" width=""2""></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                    End With
            End Select
        End Sub

        Private Sub BuildDesignTimeContent(ByRef sbHTML)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD style=""background-color: #ffffcc; border: solid 1px #ff9900; cursor: hand;"">" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""1"" cellPadding=""1"" width=""100%"" border=""0"">" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD vAlign=""top""><FONT color=""#7c7c7c"">" & Chr(149) & "</FONT></TD>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%""><FONT face=""Verdana, Arial, Helvetica"" size=""2"">")
            sbHTML.Append("Sample Menu Item</FONT></TD>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)

            'Break...
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR><TD align=""center""><TABLE cellSpacing=""0"" cellPadding=""0"" width=""95%"" border=""0"">" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR><TD bgcolor=""#cccccc""><IMG src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD></TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD></TR></TABLE>" & vbCrLf)

            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD style=""padding: 1px;"">" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""1"" cellPadding=""1"" width=""100%"" border=""0"">" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD vAlign=""top""><FONT color=""#7c7c7c"">" & Chr(149) & "</FONT></TD>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%""><FONT face=""Verdana, Arial, Helvetica"" size=""2"">")
            sbHTML.Append("Sample Menu Item</FONT></TD>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)

        End Sub

        Private Sub BuildContent(ByRef sbHTML)
            Select Case mbsStyle
                Case mbStyle.Standard

                Case mbStyle.SoftBlue

                    Dim objItem As MenuItemV1
                    For Each objItem In MenuItems
                        If objItem.Label = "#" Then
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR><TD align=""center""><TABLE cellSpacing=""0"" cellPadding=""0"" width=""95%"" border=""0"">" & vbCrLf)
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR><TD bgcolor=""#cccccc""><IMG src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD></TR>" & vbCrLf)
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD></TR></TABLE>" & vbCrLf)
                        Else
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                            If objItem.Action <> "" Then
                                If mbolIsUpLevel And Left(objItem.Action.ToUpper, 11) = "JAVASCRIPT:" Then
                                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD class=""MenuItem"" OnClick=""" & Replace(objItem.Action, "Javascript:", "") & """ OnMouseOver=""this.className='MenuItemSelected';"" OnMouseOut=""this.className='MenuItem';"">" & vbCrLf)
                                ElseIf mbolIsUpLevel Then
                                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD class=""MenuItem"" OnClick=""document.location.href='" & objItem.Action & "';"" OnMouseOver=""this.className='MenuItemSelected';"" OnMouseOut=""this.className='MenuItem';"">" & vbCrLf)
                                Else
                                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD>" & vbCrLf)
                                End If
                            Else
                                If mbolIsUpLevel Then
                                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD class=""MenuItem"">" & vbCrLf)
                                Else
                                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD>" & vbCrLf)
                                End If
                            End If
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""1"" cellPadding=""1"" width=""100%"" border=""0"">" & vbCrLf)
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                            If objItem.Bulleted Then
                                sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD vAlign=""top""><FONT color=""#7c7c7c"">" & Chr(149) & "</FONT></TD>" & vbCrLf)
                                sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%""><FONT face=""Verdana, Arial, Helvetica"" size=""2"">")
                            Else
                                sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%""><FONT face=""Verdana, Arial, Helvetica"" size=""2"">")
                            End If

                            If objItem.Action <> "" Then
                                If Not mbolIsUpLevel Then
                                    sbHTML.Append("<a href=""" & objItem.Action & """>")
                                End If
                                sbHTML.Append(objItem.Label)
                                If Not mbolIsUpLevel Then
                                    sbHTML.Append("</a>")
                                End If
                            Else
                                sbHTML.Append(objItem.Label)
                            End If

                            sbHTML.Append("</FONT></TD>" & vbCrLf)

                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
                            sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                        End If
                    Next

                Case mbStyle.SilverBox

                    Dim objItem As MenuItemV1
                    sbHTML.Append("<TABLE cellSpacing=""2"" cellPadding=""0"" width=""100%"" border=""0"">" & vbCrLf)
                    For Each objItem In MenuItems
                        If objItem.Label = "#" Then 'Draw a break...
                            sbHTML.Append("<TR><TD align=""center""><TABLE cellSpacing=""0"" cellPadding=""0"" width=""95%"" border=""0"">" & vbCrLf)
                            sbHTML.Append("<TR><TD bgcolor=""#cccccc""><IMG src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD></TR>" & vbCrLf)
                            sbHTML.Append("</TD></TR></TABLE></TD></TR>")
                        Else
                            sbHTML.Append("   <TR>" & vbCrLf)
                            sbHTML.Append("       <TD vAlign=""top""><FONT color=""#7c7c7c"">" & Chr(149) & "</FONT></TD>" & vbCrLf)
                            sbHTML.Append("       <TD width=""100%""><FONT face=""Verdana"" color=""#000000"" size=""2"">" & objItem.Label & "</FONT></TD>" & vbCrLf)
                            sbHTML.Append("   </TR>" & vbCrLf)
                        End If
                    Next
                    sbHTML.Append("</TABLE>" & vbCrLf)
                Case mbStyle.PurpleBox
                    With sbHTML
                        Dim objItem As MenuItemV1
                        For Each objItem In MenuItems
                            If objItem.Label = "#" Then
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR><TD align=""center""><TABLE cellSpacing=""0"" cellPadding=""0"" width=""95%"" border=""0"">" & vbCrLf)
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR><TD bgcolor=""#cccccc""><IMG src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD></TR>" & vbCrLf)
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD></TR></TABLE>" & vbCrLf)
                            Else
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                                If objItem.Action <> "" Then
                                    If mbolIsUpLevel And Left(objItem.Action.ToUpper, 11) = "JAVASCRIPT:" Then
                                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD class=""MenuItem"" OnClick=""" & Replace(objItem.Action, "Javascript:", "") & """ OnMouseOver=""this.className='tMenuItemSelected';"" OnMouseOut=""this.className='MenuItem';"">" & vbCrLf)
                                    ElseIf mbolIsUpLevel Then
                                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD class=""MenuItem"" OnClick=""document.location.href='" & objItem.Action & "';"" OnMouseOver=""this.className='tMenuItemSelected';"" OnMouseOut=""this.className='MenuItem';"">" & vbCrLf)
                                    Else
                                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD>" & vbCrLf)
                                    End If
                                Else
                                    If mbolIsUpLevel Then
                                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD class=""MenuItem"">" & vbCrLf)
                                    Else
                                        .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD>" & vbCrLf)
                                    End If
                                End If
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TABLE cellSpacing=""1"" cellPadding=""1"" width=""100%"" border=""0"">" & vbCrLf)
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                                If objItem.Bulleted Then
                                    .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD vAlign=""top""><FONT color=""#7c7c7c"">" & Chr(149) & "</FONT></TD>" & vbCrLf)
                                    .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%""><FONT face=""Verdana, Arial, Helvetica"" size=""2"">")
                                Else
                                    .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%""><FONT face=""Verdana, Arial, Helvetica"" size=""2"">")
                                End If

                                If objItem.Action <> "" Then
                                    If Not mbolIsUpLevel Then
                                        .Append("<a href=""" & objItem.Action & """>")
                                    End If
                                    .Append(objItem.Label)
                                    If Not mbolIsUpLevel Then
                                        .Append("</a>")
                                    End If
                                Else
                                    .Append(objItem.Label)
                                End If

                                .Append("</FONT></TD>" & vbCrLf)

                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
                                .Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                            End If
                        Next
                    End With
            End Select
        End Sub

        Private Sub BuildFooter(ByRef sbHTML)
            Select Case mbsStyle
                Case mbStyle.Standard

                Case mbStyle.SoftBlue
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#666666""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#cccccc""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD width=""100%"" bgColor=""#6598cc""><IMG height=""8"" width=""8"" alt="""" src=""" & mstrImagesPath & "ghost.gif""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#666666""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD colspan=""2"" bgColor=""#666666""><IMG height=""1"" alt="""" src=""" & mstrImagesPath & "ghost_solid.gif"" width=""6""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "<TD bgColor=""#666666""><IMG alt="""" src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""1""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & "</TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "</TR>" & vbCrLf)
                    sbHTML.Append(vbTab & "</TABLE>" & vbCrLf)
                Case mbStyle.SilverBox
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & vbTab & "</TD></TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & vbTab & "<TR><TD></TD></TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "</TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "<TD vAlign=""top"" background=""" & mstrImagesPath & "tbl_shdwV.gif""><IMG alt="""" src=""" & mstrImagesPath & "tbl_shdw1.gif""></TD></TR>" & vbCrLf)
                    sbHTML.Append(vbTab & "<TR>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "<TD background=""" & mstrImagesPath & "tbl_shdwH.gif""><IMG alt="""" src=""" & mstrImagesPath & "tbl_shdw5.gif""></TD>" & vbCrLf)
                    sbHTML.Append(vbTab & vbTab & "<TD><IMG alt="""" src=""" & mstrImagesPath & "tbl_shdw3.gif""></TD></TR></TABLE>" & vbCrLf & vbCrLf)
                Case mbStyle.PurpleBox
                    With sbHTML
                        .Append(vbTab & vbTab & vbTab & "</TABLE>" & vbCrLf)
                        .Append(vbTab & vbTab & "</TD>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD background=""" & mstrImagesPath & "tmnu_right.gif""><IMG alt="""" src=""" & mstrImagesPath & "tmnu_right.gif""></TD>" & vbCrLf)
                        .Append(vbTab & "</TR>" & vbCrLf)
                        .Append(vbTab & "<TR>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD><IMG alt="""" src=""" & mstrImagesPath & "tmnu_botleft.gif""></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & "<TD background=""" & mstrImagesPath & "tmnu_bottom.gif"" width=""100%""><IMG alt="""" height=""11"" src=""" & mstrImagesPath & "ghost.gif"" width=""1""></TD>" & vbCrLf)
                        .Append(vbTab & vbTab & "	<TD><IMG alt="""" src=""" & mstrImagesPath & "tmnu_botright.gif""></TD>" & vbCrLf)
                        .Append(vbTab & "</TR>" & vbCrLf)
                        .Append("</TABLE>" & vbCrLf)
                    End With
            End Select
        End Sub

        Private Sub BuildSpacer(ByRef sbHTML)
            With sbHTML
                .Append("<TABLE border=""0"" cellPadding=""0"" cellSpacing=""0"" bgcolor=""#ffffff"">")
                .Append("<TR><TD>")
                .Append("<IMG src=""" & mstrImagesPath & "ghost.gif"" width=""1"" height=""" & mintMenuPadding & """>")
                .Append("</TD></TR></TABLE>")
            End With
        End Sub

#End Region

#Region " Browser Check "

        Private Function IsUpLevel() As Boolean
            Dim strBrowser As String = Page.Request.Browser.Browser
            Dim intVersion As Integer = Page.Request.Browser.MajorVersion

            If strBrowser = "Netscape" And intVersion >= 7 Then
                Return True
            ElseIf strBrowser = "IE" And intVersion >= 5 Then
                Return True
            Else
                Return False
            End If

        End Function

#End Region

    End Class

#Region " MenuItemCollection "

    Public Class MenuItemCollectionV1
        Inherits System.Collections.CollectionBase

        Public Sub New()
            MyBase.New()
        End Sub

        Public Function AddItem(ByVal Label As String, ByVal Action As String, ByVal ToolTip As String, ByVal Bulleted As Boolean, ByVal Highlighted As Boolean) As MenuItemV1
            Dim objMenuItem As New MenuItemV1

            With objMenuItem
                .Label = Label
                .Action = Action
                .ToolTip = ToolTip
                .Bulleted = Bulleted
                .Highlighted = Highlighted
            End With

            list.Add(objMenuItem)

        End Function

        Public Function AddBreak() As MenuItemV1
            Dim objMenuItem As New MenuItemV1

            With objMenuItem
                .Label = "#"
                .Action = ""
                .ToolTip = ""
                .Bulleted = False
                .Highlighted = False
            End With

            list.Add(objMenuItem)

        End Function

        Public ReadOnly Property Item(ByVal index As Integer) As MenuItemV1
            Get
                Return CType(List.Item(index), MenuItemV1)
            End Get
        End Property

    End Class

    Public Class MenuItemV1
        Private mstrItemLabel As String
        Private mstrItemAction As String
        Private mstrItemToolTip As String
        Private mbolBulleted As Boolean
        Private mbolHighlighted As Boolean

        Public Property Label() As String
            Get
                Return mstrItemLabel
            End Get
            Set(ByVal Value As String)
                mstrItemLabel = Value
            End Set
        End Property

        Public Property Action() As String
            Get
                Return mstrItemAction
            End Get
            Set(ByVal Value As String)
                mstrItemAction = Value
            End Set
        End Property

        Public Property ToolTip() As String
            Get
                Return mstrItemToolTip
            End Get
            Set(ByVal Value As String)
                mstrItemToolTip = Value
            End Set
        End Property

        Public Property Bulleted() As Boolean
            Get
                Return mbolBulleted
            End Get
            Set(ByVal Value As Boolean)
                mbolBulleted = Value
            End Set
        End Property

        Public Property Highlighted() As Boolean
            Get
                Return mbolHighlighted
            End Get
            Set(ByVal Value As Boolean)
                mbolHighlighted = Value
            End Set
        End Property

    End Class

#End Region
End Namespace
