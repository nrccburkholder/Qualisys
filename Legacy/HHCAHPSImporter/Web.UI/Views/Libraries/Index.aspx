<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.TransformLibrary>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Libraries
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Libraries</h2>

    <table>
        <tr>
            <th></th>
            <th>
                TransformLibraryName
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
                <%: Html.ActionLink("Edit", "Edit", new { id=item.TransformLibraryId }) %> |
                <%: Html.ActionLink("Details", "Details", new { id=item.TransformLibraryId })%> |
                <%: Html.ActionLink("Delete", "Delete", new { id=item.TransformLibraryId })%>
            </td>
            <td>
                <%: item.TransformLibraryName %>
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
        <%: Html.ActionLink("Create New Library", "Create") %>
    </p>

</asp:Content>

