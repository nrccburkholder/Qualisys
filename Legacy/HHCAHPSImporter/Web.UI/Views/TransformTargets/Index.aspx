<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.Transform>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Transform Editor - Transform Targets
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%: Model.TransformName %> Transform Targets</h2>

    <table>
        <tr>
            <th></th>
            <th>
                TargetName
            </th>
            <th>
                TargetTable
            </th>
            <th>
                LastModDate
            </th>
            <th>
                LastModuser
            </th>
        </tr>

    <% if (Model.TransformDefinition != null)
       {
           foreach (var item in Model.TransformDefinition.ToList())
           { %>
    
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { id = item.TransformTargetId })%> |
                <%: Html.ActionLink("Details", "Details", new { id = item.TransformTargetId })%> |
                <%: Html.ActionLink("Delete", "Delete", new { id = item.TransformTargetId })%> |
                <%: Html.ActionLink("Mappings", "../TransformMappings/Index", new { transformTargetId = item.TransformTargetId })%>
            </td>
            <td>
                <%: item.TransformTarget.TargetName%>
            </td>
            <td>
                <%: item.TransformTarget.TargetTable%>
            </td>
            <td>
                <%: String.Format("{0:g}", item.LastModDate) %>
            </td>
            <td>
                <%: item.LastModUser %>
            </td>
        </tr>
    
    <% }
       }%>

    </table>

    <p>
        <%: Html.ActionLink("Create new Target", "Create", new { transformId = Model.TransformId })%> |
        <%: Html.ActionLink("Back to list of Transforms", "../Transforms/Index") %> 
    </p>

</asp:Content>

