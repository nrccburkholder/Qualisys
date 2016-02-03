<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.TransformTarget>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Transform Editor - Transform Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Transform Details</h2>

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

    <p>
        <%: Html.ActionLink("Edit", "Edit", new { id=Model.TransformTargetId }) %> |
        <%: Html.ActionLink("Back to List", "Index", new { transformId = Model.TransformId })%>
    </p>

</asp:Content>

