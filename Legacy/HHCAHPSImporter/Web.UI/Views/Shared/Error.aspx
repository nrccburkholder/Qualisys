<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<System.Web.Mvc.HandleErrorInfo>" %>

<asp:Content ID="errorTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Error
</asp:Content>

<asp:Content ID="errorContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Sorry, an error occurred while processing your request.
    </h2>
    <h3>
        <%: Model.Exception.Message %>
    </h3>
    <ul id="simplelist">
        <li>
            <%  foreach (string line in Model.Exception.StackTrace.Split(new char[] { '\r', '\n' }).Where(t => t.Length > 0).ToList()) { %>
                    <%: line  %>
            <% } %>
        </li>
    </ul>
</asp:Content>
