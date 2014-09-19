<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.Transform>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Transform Editor - Transforms
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Transforms</h2>

    <table>
        <tr>
            <th></th>
            <th>
                TransformName
            </th>
            <th>
                LastModDate
            </th>
            <th>
                LastModUser
            </th>
        </tr>

    <% foreach (var item in Model) { %>

        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { id=item.TransformId }) %> |
                <%: Html.ActionLink("Details", "Details", new { id=item.TransformId })%> |
                <!-- <%: Html.ActionLink("Delete", "Delete", new { id=item.TransformId })%> | -->
                <%: Html.ActionLink("Targets", "../TransformTargets/Index", new { transformId = item.TransformId })%>
            </td>
            <td>
                <%: item.TransformName %>
            </td>
            <td>
                <%: String.Format("{0:g}", item.LastModDate) %>
            </td>
            <td>
                <%: item.LastModUser %>
            </td>
        </tr>
    
    <% } %>

    </table>

    <p>
        <%: Html.ActionLink("Create New Transform", "Create") %>
    </p>

</asp:Content>

