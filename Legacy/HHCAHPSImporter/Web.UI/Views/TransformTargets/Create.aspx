<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.TransformTarget>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Transform Editor - Create Transform Target
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Create Transform Target</h2>

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
                    <td><input type="submit" value="Save" /></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>
    <% } %>

    <div>
        <%: Html.ActionLink("Back to List", "Index", new { transformId = Page.Request.Params["transformId"] })%>
    </div>

</asp:Content>

