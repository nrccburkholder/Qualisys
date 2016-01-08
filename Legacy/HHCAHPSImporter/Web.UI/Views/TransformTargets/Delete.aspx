<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.TransformTarget>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Delete
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Delete</h2>

    <h3>Are you sure you want to delete <%: Model.TargetName %> and all of it's dependencies?</h3>

    <fieldset>
        <legend>Fields</legend>
        <table>
            <tr>
                <td>TransformTargetId</td>
                <td><%: Model.TransformTargetId %></td>
            </tr>
            <tr>
                <td>TargetName</td>
                <td><%: Model.TargetName %></td>
            </tr>
            <tr>
                <td>TargetTable</td>
                <td><%: Model.TargetTable %></td>
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
            <%: Html.ActionLink("Back to List", "Index", new { transformId = Model.TransformId })%>
        </p>
    <% } %>

</asp:Content>

