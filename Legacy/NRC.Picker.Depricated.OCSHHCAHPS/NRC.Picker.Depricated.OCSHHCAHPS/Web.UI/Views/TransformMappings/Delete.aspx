<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.TransformMapping>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Delete
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            prettyPrint();

        });
    </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Delete</h2>

    <h3>Are you sure you want to delete <%: Model.TargetFieldname %> from <%: Model.TransformTarget.TargetName %> ?</h3>

    <fieldset>
        <legend><%: Model.TransformTarget.TargetName %>.<%: Model.TargetFieldname %></legend>
        <table>
            <tr>
                <td>TransformMappingId</td>
                <td><%: Model.TransformMappingId %></td>
            </tr>
            <tr>
                <td>TransformTargetId</td>
                <td><%: Model.TransformTargetId %></td>
            </tr>
            <tr>
                <td>SourceFieldName</td>
                <td><%: Model.SourceFieldName %></td>
            </tr>
            <tr>
                <td>TargetFieldname</td>
                <td><%: Model.TargetFieldname %></td>
            </tr>
            <tr>
                <td>Transform</td>
                <td>
                    <pre class="prettyprint linenums:1 lang-vb"><%: Model.Transform%></pre>
                </td>
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
		    <%: Html.ActionLink("Back to List", "Index", new { transformTargetId = Model.TransformTargetId })%>
        </p>
    <% } %>

</asp:Content>

