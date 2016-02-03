<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.TransformLibrary>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

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

    <h3>Are you sure you want to delete this?</h3>

        <table>
            <tr>
            <td>TransformLibraryId</td>
            <td><%: Model.TransformLibraryId %></td>
            </tr>
            <tr>
            <td>TransformLibraryName</td>
            <td><%: Model.TransformLibraryName %></td>
            </tr>
            <tr>
            <td>Code</td>
            <td><pre class="prettyprint linenums:1 lang-vb"><%: Model.Code %></pre></td>
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

    <fieldset>
        <legend>Referenced By</legend>
        <ul id="simplelist">
        <% if (Model.TransformImports != null)
           {
               foreach (var v in Model.TransformImports)
               { %>
            <li><%: Html.ActionLink(v.Transform.TransformName, "../Transforms/Details", new { id = v.TransformId })%></li>
        <%    }
           }%>
        </ul>
    </fieldset>

    <% using (Html.BeginForm()) { %>
        <p>
		    <input type="submit" value="Delete" /> |
		    <%: Html.ActionLink("Back to List", "Index") %>
        </p>
    <% } %>

</asp:Content>

