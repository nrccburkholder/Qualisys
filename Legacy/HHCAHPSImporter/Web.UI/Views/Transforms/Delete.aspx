<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.Transform>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Delete
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Delete</h2>

    <h2>Are you sure you want to delete <%: Model.TransformName %> and all of its dependencies?</h2>

    <fieldset>
        <legend>Fields</legend>
        <table>
            <tr>
                <td>TransformId</td>
                <td><%: Model.TransformId %></td>
            </tr>
            <tr>
                <td>TransformName</td>
                <td><%: Model.TransformName %></td>
            </tr>
            <tr>
                <td>CreateDate</td>
                <td><%: String.Format("{0:g}", Model.CreateDate) %></td>
            </tr>
            <tr>
                <td>CreateUser</td>
                <td><%: Model.CreateUser %></td>
            </tr>
            <tr>
                <td>UpdateDate</td>
                <td><%: String.Format("{0:g}", Model.UpdateDate) %></td>
            </tr>
            <tr>
                <td>UpdateUser</td>
                <td><%: Model.UpdateUser %></td>
            </tr>
        </table>
    </fieldset>

    <% using (Html.BeginForm()) { %>
        <p>
		    <input type="submit" value="Delete" /> |
		    <%: Html.ActionLink("Back to List", "Index") %>
        </p>
    <% } %>

</asp:Content>

