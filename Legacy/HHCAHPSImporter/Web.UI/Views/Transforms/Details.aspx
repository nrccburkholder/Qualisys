<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.Transform>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Details for <%: Model.TransformName %></h2>

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

    <fieldset>
        <legend>Imported Libraries</legend>
        <ul id="simplelist">
        <% foreach (var v in Model.TransformImports) { %>
            <li><%: Html.ActionLink(v.TransformLibrary.TransformLibraryName, "../Libraries/Details", new{id=v.TransformLibraryId}) %></li>
        <% } %>
        </ul>
    </fieldset>

    <p>
        <%: Html.ActionLink("Edit this " + Model.GetType().ToString().Split(new char[]{'.'}).Last<string>(), "Edit", new { id=Model.TransformId }) %> |
        <%: Html.ActionLink("Back to " + Model.GetType().ToString().Split(new char[] { '.' }).Last<string>() + " List", "Index")%>
    </p>

</asp:Content>

