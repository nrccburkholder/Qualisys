<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.TransformMapping>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Existing Transform
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            prettyPrint();

            $("textarea.tabby").tabby();

            //hide the all of the element with class msg_body
            $(".runtimeVariablesBody").hide();
            //toggle the componenet with class msg_body
            $(".runtimeVariablesHead").click(function () {
                $(this).next(".runtimeVariablesBody").slideToggle(600);
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit Transform Mapping</h2>

    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftAjax.js") %>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftMvcValidation.js") %>"></script>

    <% Html.RenderPartial("RuntimeVariables"); %>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <%: Html.HiddenFor(model => model.TransformMappingId) %>
        <%: Html.HiddenFor(model => model.TransformTargetId)%>
        <%: Html.HiddenFor(model => model.CreateDate)%>
        <%: Html.HiddenFor(model => model.CreateUser)%>
        <%: Html.HiddenFor(model => model.UpdateDate)%>
        <%: Html.HiddenFor(model => model.UpdateUser)%>

        <fieldset>
            <legend><%: Model.TransformTarget.TransformDefinition.FirstOrDefault().Transform.TransformName %>.<%: Model.TransformTarget.TargetTable %>.<%: Model.TargetFieldname %></legend>

            <table>
                <tr>
                    <td><%: Html.LabelFor(model => model.SourceFieldName) %></td>
                    <td><%: Html.TextBoxFor(model => model.SourceFieldName) %></td>                
                    <td><%: Html.ValidationMessageFor(model => model.SourceFieldName) %></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.TargetFieldname) %></td>
                    <td><%: Html.TextBoxFor(model => model.TargetFieldname) %></td>                
                    <td><%: Html.ValidationMessageFor(model => model.TargetFieldname) %></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.Transform) %></td>
                    <td>
                        <%: Html.TextAreaFor(model => model.Transform, new { @class = "tabby code", @rows = "20", @cols = "80", @WRAP = "OFF" })%>
                        <% if (ViewData["ValidationError"] != null && !string.IsNullOrEmpty(ViewData["ValidationError"].ToString()))
                           { %>
                            <div class="input-validation-error">
                                <ul id="simplelist">
                                <% foreach (var e in ViewData["ValidationError"].ToString().Split(new char[] { '\r', '\n' }).Where(t => t.Length > 0)) {%>
                                <li><%: e %></li>
                                <% } %>
                                </ul>
                            </div>
                        <%  } %>
                    </td>                
                    <td><%: Html.ValidationMessageFor(model => model.Transform) %></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" value="Save Changes" /></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>

    <% } %>
    
    <h5>Last Modified by <%: Model.GetLastModString() %></h5>

    <div>
        <%: Html.ActionLink("Cancel edit", "Index", new { transformTargetId = Model.TransformTargetId })%>
    </div>

</asp:Content>

