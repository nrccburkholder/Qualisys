<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.TransformLibrary>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Create Library
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("textarea.tabby").tabby();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Create Library</h2>

    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftAjax.js") %>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftMvcValidation.js") %>"></script>

    <% Html.EnableClientValidation(); %>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <%: Html.HiddenFor(model => model.TransformLibraryId)%>
        <%: Html.HiddenFor(model => model.CreateDate)%>
        <%: Html.HiddenFor(model => model.CreateUser)%>
        <%: Html.HiddenFor(model => model.UpdateDate)%>
        <%: Html.HiddenFor(model => model.UpdateUser)%>
        
        <fieldset>
            <legend>Fields</legend>

            <table id="edit">
                <tr>
                    <td><%: Html.LabelFor(model => model.TransformLibraryName) %></td>
                    <td><%: Html.TextBoxFor(model => model.TransformLibraryName) %></td>
                    <td><%: Html.ValidationMessageFor(model => model.TransformLibraryName) %></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.Code) %></td>
                    <td>
                        <%: Html.TextAreaFor(model => model.Code, new { @class = "tabby code", @rows = "20", @cols = "80", @WRAP = "OFF" })%>
                        <% try {
                                Model.ValidatedCode();
                            }
                            catch(Exception ex) { %>
                                <div class="input-validation-error">
                                    <ul id="simplelist">
                                    <% foreach( var e in ex.Message.Split( new char[]{'\r','\n'} ).Where( t => t.Length > 0 ) ) {%>
                                    <li><%: e %></li>
                                    <% } %>
                                    </ul>
                                </div>
                        <% } %>
                    </td>
                    <td><%: Html.ValidationMessageFor(model => model.Code) %></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" value="Save Changes" /></td>
                    <td></td>
                </tr>
            </table>           
        </fieldset>

    <% } %>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

