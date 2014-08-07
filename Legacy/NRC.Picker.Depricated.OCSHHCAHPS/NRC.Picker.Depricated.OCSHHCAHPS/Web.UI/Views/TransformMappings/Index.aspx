<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.TransformTarget>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Transform Mappings
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            prettyPrint();

            //hide the all of the element with class msg_body
            $(".codeBody").hide();
            //toggle the componenet with class msg_body
            $(".codeHead").click(function () {
                $(this).next(".codeBody").slideToggle(600);
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Model.TargetName %> Transform Mappings</h2>

    <table>
        <tr>
            <th></th>
            <th>
                SourceFieldName
            </th>
            <th>
                TargetFieldname
            </th>
            <th>
                LastModDate
            </th>
            <th>
                LastModUser
            </th>
        </tr>

    <% foreach (var item in Model.TransformMapping.OrderBy( t => t.TargetFieldname )) { %>
    
        <tr>
            <td>
                <%: Html.ActionLink("Edit", "Edit", new { id=item.TransformMappingId }) %> |
                <%: Html.ActionLink("Details", "Details", new { id=item.TransformMappingId })%> |
                <%: Html.ActionLink("Delete", "Delete", new { id=item.TransformMappingId })%>
            </td>
            <td>
                <%: item.SourceFieldName %>
            </td>
            <td>
                <%: item.TargetFieldname %>
            </td>
            <td>
                <%: String.Format("{0:g}", item.LastModDate) %>
            </td>
            <td>
                <%: item.LastModUser %>
            </td>
        </tr>
        <tr>
            <td colspan="7">
                <div class="codeHead">view code</div>
                <div class="codeBody">
                    <pre class="prettyprint linenums:1 lang-vb"><%: item.Transform %></pre>
                </div>
            </td>
        </tr>
    
    <% } %>

    </table>
     
    <p>
        <%: Html.ActionLink("Create new Transform Mapping", "Create", new { transformTargetId = Model.TransformTargetId }) %> | 
        <%: Html.ActionLink("Back to Targets", "../TransformTargets/Index", new { transformId = Model.TransformDefinition.FirstOrDefault().TransformId }) %> 
    </p>

</asp:Content>

