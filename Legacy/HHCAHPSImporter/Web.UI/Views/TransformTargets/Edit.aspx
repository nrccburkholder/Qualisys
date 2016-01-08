<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.TransformTarget>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit</h2>

    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftAjax.js") %>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftMvcValidation.js") %>"></script>

    <% Html.EnableClientValidation(); %>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <%: Html.HiddenFor(model => model.TransformTargetId) %>
        <%: Html.HiddenFor(model => model.CreateUser) %>
        <%: Html.HiddenFor(model => model.CreateDate) %>
        <%: Html.HiddenFor(model => model.UpdateUser) %>
        <%: Html.HiddenFor(model => model.UpdateDate) %>
        
        <fieldset>
            <legend>Fields</legend>
            
            <table id="edit">
                <tr>
                    <td><%: Html.LabelFor(model => model.TargetName) %></td>
                    <td><%: Html.TextBoxFor(model => model.TargetName) %></td>
                    <td><%: Html.ValidationMessageFor(model => model.TargetName) %></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.TargetTable) %></td>
                    <td><%: Html.TextBoxFor(model => model.TargetTable) %></td>
                    <td><%: Html.ValidationMessageFor(model => model.TargetTable) %></td>
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
        <%: Html.ActionLink("Back to List", "Index", new { transformId = Model.TransformId })%>
    </div>

</asp:Content>

