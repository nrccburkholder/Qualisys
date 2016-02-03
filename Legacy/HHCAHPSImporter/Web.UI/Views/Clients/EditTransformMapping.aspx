<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.Web.UI.Models.ClientDetailInfo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	EditTransformMapping
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editing Transform for <%: Model.ClientDetail.ClientName %></h2>
    <div>Transform: <%: Model.TransformMappings[0].TransformName %></div>
    <div>Transform Target: <%: Model.TransformMappings[0].TransformTargetName %></div>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <%: Html.HiddenFor( model => model.ClientDetail.Client_id ) %>
        <%: Html.HiddenFor( model => model.ClientDetail.Study_id ) %>
        <%: Html.HiddenFor( model => model.ClientDetail.Survey_id ) %>
        <%: Html.HiddenFor( model => model.TransformMappings[0].TransformMappingId ) %>
        <%: Html.HiddenFor( model => model.TransformMappings[0].TransformTargetId ) %>
        <%: Html.HiddenFor( model => model.TransformMappings[0].TransformId ) %>
        
        <fieldset>
            <legend><%: Model.TransformMappings[0].TransformTargetTable %>.<%: Model.TransformMappings[0].TargetFieldName %></legend>

            <table id="edit">
                <tr>
                    <td><%: Html.LabelFor( model => model.TransformMappings[0].SourceFieldName ) %></td>
                    <td><%: Html.TextBoxFor( model => model.TransformMappings[0].ClientSourceFieldName ) %></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor( model => model.TransformMappings[0].TransformCode ) %></td>
                    <td><%: Html.TextAreaFor(model => model.TransformMappings[0].ClientTransformCode, new { @rows = "20", @cols = "80" }) %></td>
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
        <%: Html.ActionLink( "Back to List", "TransformMappings", new{clientId=Model.ClientDetail.Client_id, studyId=Model.ClientDetail.Study_id, surveyId=Model.ClientDetail.Survey_id, transformId=Model.Transform.TransformId, transformTargetId=Model.TransformMappings[0].TransformTargetId}) %>
    </div>

</asp:Content>


