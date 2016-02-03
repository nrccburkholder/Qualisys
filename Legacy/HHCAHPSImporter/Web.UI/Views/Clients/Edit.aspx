<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.Web.UI.Models.ClientEditInfo>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Client
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit Client</h2>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>
        
        <%: Html.HiddenFor(model => model.ClientId)%>
        <%: Html.HiddenFor(model => model.StudyId)%>
        <%: Html.HiddenFor(model => model.SurveyId)%>
        <%: Html.HiddenFor(model => model.CurrentTransformId)%>

        <fieldset>
            <legend>Fields</legend>
            <table id="edit">
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetailInfo.Client_id)%></td>
                    <td><%: Model.ClientDetailInfo.Client_id%></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetailInfo.ClientName)%></td>
                    <td><%: Model.ClientDetailInfo.ClientName%></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetailInfo.CCN)%></td>
                    <td><%: Model.ClientDetailInfo.CCN%></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetailInfo.Study_id)%></td>
                    <td><%: Model.ClientDetailInfo.Study_id%></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetailInfo.Survey_id)%></td>
                    <td><%: Model.ClientDetailInfo.Survey_id%></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetailInfo.Languages) %></td>
                    <td><%: Model.ClientDetailInfo.ClientDetail.Languages %></td>
<%--                    <td><%: Html.TextBoxFor(model => model.ClientDetailInfo.ClientDetail.Languages)%></td>
                    <td><%: Html.ValidationMessageFor(model => model.ClientDetailInfo.ClientDetail.Languages)%></td>--%>
                </tr>
                <tr>
                    <td>Transform:</td>
                    <td>
                        <ul id="simplelist">
                        <li>
                            <% if (Model.CurrentTransformId == -1 ) { %> 
                                <input type="radio" name="selectedTransformId" value='-1' checked="checked" />None 
                            <% }
                            else { %>
                                <input type="radio" name="selectedTransformId" value='-1'  />None
                            <% } %>
                        </li>

                        <% if (Model.AvailableTransforms != null) {
                               foreach (HHCAHPSImporter.ImportProcessor.DAL.Generated.Transform t in Model.AvailableTransforms) {%> 
                               <li> 
                                    <% if (Model.CurrentTransformId.Equals( t.TransformId )) { %>
                                            <input type="radio" name="selectedTransformId" value='<%: t.TransformId %>' checked="checked"  /><%: t.TransformName %>
                                        <% } else { %>
                                            <input type="radio" name="selectedTransformId" value='<%: t.TransformId %>'  /><%: t.TransformName %>
                                    <% } %>
                                </li> 
                                <% }
                           } %>
                        </ul>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" value="Save" /></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>

    <% } %>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

