<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.TransformMapping>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Details
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            prettyPrint();

            //hide the all of the element with class msg_body
            $(".runtimeVariablesBody").hide();
            //toggle the componenet with class msg_body
            $(".runtimeVariablesHead").click(function () {
                $(this).next(".runtimeVariablesBody").slideToggle(600);
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Tranform Mapping Details</h2>

    <% Html.RenderPartial("RuntimeVariables"); %>

    <fieldset>
        <legend><%: Model.TransformTarget.TransformDefinition.FirstOrDefault().Transform.TransformName %>.<%: Model.TransformTarget.TargetTable %>.<%: Model.TargetFieldname %></legend>
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
                    <!-- <pre class="brush: vbnet;">< %:Model.Transform.Trim()% ></pre> -->
                    <pre class="prettyprint linenums:1 lang-vb"><%: Model.Transform%></pre>
                </td>
                <!-- <td>< %: Html.TextAreaFor(model => model.Transform, new { @rows = "20", @cols = "80", @readonly="true" }) % ></td> -->
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
        <%: Html.ActionLink("Edit", "Edit", new { id=Model.TransformMappingId }) %> |
        <%: Html.ActionLink("Back to List", "Index", new { transformTargetId = Model.TransformTargetId } )%>
    </p>

</asp:Content>

