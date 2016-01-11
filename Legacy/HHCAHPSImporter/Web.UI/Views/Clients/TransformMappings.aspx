<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.Web.UI.Models.ClientDetailInfo>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Transform Mappings for <%: Model.ClientDetail.ClientName %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Transform Mappings for <%: Model.ClientDetail.ClientName %></h2>
    <div>Transform: <%: Model.Transform.TransformName %></div>
    <div>Transform Target: <%:Model.TransformMappings[0].TransformTargetName %></div>

    <table>
        <tr>
            <th></th>
            <th>
                SourceFieldName
            </th>
            <th>
                TargetFieldName
            </th>
            <th>
                Transform
            </th>
            <th>
                LastModDate
            </th>
            <th>
                LastModUser
            </th>
        </tr>

    <% foreach (var item in Model.TransformMappings) { %>
    
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "EditTransformMapping", new { clientId = item.Client_id, studyId = item.Study_id, surveyId = item.Survey_id, transformId = item.TransformId, transformTargetId = item.TransformTargetId, transformMappingId = item.TransformMappingId })%> |
                <%: Html.ActionLink("Details", "TransformMappingDetails", new { clientId = item.Client_id, studyId = item.Study_id, surveyId = item.Survey_id, transformId = item.TransformId, transformTargetId = item.TransformTargetId, transformMappingId = item.TransformMappingId })%> |
                <%: Html.ActionLink("Delete", "DeleteTransformMapping", new { clientId = item.Client_id, studyId = item.Study_id, surveyId = item.Survey_id, transformId = item.TransformId, transformTargetId = item.TransformTargetId, transformMappingId = item.TransformMappingId })%>
            </td>

            <% if( string.IsNullOrEmpty(item.ClientSourceFieldName) ) { %>
            <td>
                <%: item.SourceFieldName %>
            </td>
            <% } else { %>
            <td class="clientOverrideValue">
                <%: item.ClientSourceFieldName%>
            </td>
            <% } %>

            <td>
                <%: item.TargetFieldName %>
            </td>

            <% if( string.IsNullOrEmpty(item.ClientTransformCode) ) { %>
            <td>
                <%: item.TransformCode %>
            </td>
            <% } else { %>
            <td class="clientOverrideValue">
                <%: item.ClientTransformCode %>
            </td>
            <% } %>

            <td>
                <%: item.LastModDate %>
            </td>
            <td>
                <%: item.LastModUser %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

