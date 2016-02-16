<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<HHCAHPSImporter.Web.UI.Models.ClientInfo>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Client List</h2>

    <table>
        <tr>
            <th></th>
            <th>
                Client_id
            </th>
            <th>
                ClientName
            </th>
            <th>
                CCN
            </th>
            <th>
                Study_id
            </th>
            <th>
                Survey_id
            </th>
            <th>
                Languages
            </th>
            <th>
                File Format
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { clientId=item.ClientDetail.Client_id, studyId=item.ClientDetail.Study_id, surveyId=item.ClientDetail.Survey_id }) %> |
                <%: Html.ActionLink("Details", "Details", new { clientId = item.ClientDetail.Client_id, studyId = item.ClientDetail.Study_id, surveyId = item.ClientDetail.Survey_id })%> | 
                <%: Html.ActionLink("DataFiles", "DataFiles", new { clientId = item.ClientDetail.Client_id })%> 
            </td>
            <td>
                <%: item.ClientDetail.Client_id %>
            </td>
            <td>
                <%: item.ClientDetail.ClientName %>
            </td>
            <td>
                <%: item.ClientDetail.CCN %>
            </td>
            <td>
                <%: item.ClientDetail.Study_id %>
            </td>
            <td>
                <%: item.ClientDetail.Survey_id %>
            </td>
            <td>
                <%: item.ClientDetail.Languages %>
            </td>
            <td>
                <%: item.FileFormat %>
            </td>
        </tr>
    
    <% } %>

    </table>

<%--    <p>
        <%: Html.ActionLink("Create New", "Create") %>
    </p>--%>

</asp:Content>

