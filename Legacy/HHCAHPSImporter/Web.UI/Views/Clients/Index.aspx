<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<HHCAHPSImporter.ImportProcessor.DAL.Generated.ClientDetail>>" %>

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
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { clientId=item.Client_id, studyId=item.Study_id, surveyId=item.Survey_id }) %> |
                <%: Html.ActionLink("Details", "Details", new { clientId = item.Client_id, studyId = item.Study_id, surveyId = item.Survey_id })%> | 
                <%: Html.ActionLink("DataFiles", "DataFiles", new { clientId = item.Client_id })%> 
            </td>
            <td>
                <%: item.Client_id %>
            </td>
            <td>
                <%: item.ClientName %>
            </td>
            <td>
                <%: item.CCN %>
            </td>
            <td>
                <%: item.Study_id %>
            </td>
            <td>
                <%: item.Survey_id %>
            </td>
            <td>
                <%: item.Languages %>
            </td>
        </tr>
    
    <% } %>

    </table>

<%--    <p>
        <%: Html.ActionLink("Create New", "Create") %>
    </p>--%>

</asp:Content>

