<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.Transform>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit</h2>

    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftAjax.js") %>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Scripts/MicrosoftMvcValidation.js") %>"></script>

    <% Html.EnableClientValidation(); %>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>

            <%: Html.HiddenFor(model => model.TransformId)%>
            <%: Html.HiddenFor(model => model.CreateDate)%>
            <%: Html.HiddenFor(model => model.CreateUser)%>
            <%: Html.HiddenFor(model => model.UpdateDate)%>
            <%: Html.HiddenFor(model => model.UpdateUser)%>
            
            <table id="edit">
            <tr>
                <td><%: Html.LabelFor(model => model.TransformName) %></td>
                <td><%: Html.TextBoxFor(model => model.TransformName) %></td>
                <td><%: Html.ValidationMessageFor(model => model.TransformName) %></td>
            </tr>
            <tr>
                <td>Import Libraries</td>
                <td>
                    <ul id="simplelist">
                    <% foreach (var v in NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models.Utils.TransformLibraries(Model.TransformId) ) { %>
                        <li><input type="checkbox" name="importLibraries" value="<%: v.TransformLibraryId %>" 
                        <%if(v.IsImported){ %>checked="checked"<% } %> /><%: v.TransformLibraryName %></li>
                    <% } %>
                    </ul>
                </td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Save Changes" /></td>
                <td></td>
            </tr>
            </table>

        </fieldset>

    <% } %>

    <h5>Last Modified by <%: Model.GetLastModString() %></h5>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

