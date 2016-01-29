<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.Web.UI.Models.ClientDetailInfo>" %>
<%@ Assembly Name="System.Data" %>
<%@ Assembly Name="System.Data.Linq, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Client
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Details for <%: Model.ClientDetail.ClientName %></h2>

        <fieldset>
            <legend>Fields</legend>
            <table id="edit">
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetail.Client_id) %></td>
                    <td><%: Model.ClientDetail.Client_id %></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetail.ClientName) %></td>
                    <td><%: Model.ClientDetail.ClientName %></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetail.CCN) %></td>
                    <td><%: Model.ClientDetail.CCN %></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetail.Study_id) %></td>
                    <td><%: Model.ClientDetail.Study_id %></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.ClientDetail.Survey_id) %></td>
                    <td><%: Model.ClientDetail.Survey_id %></td>
                    <td></td>
                </tr>
                <tr>
                    <td><%: Html.LabelFor(model => model.Languages) %></td>
                    <td><%: Model.ClientDetail.Languages %></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Transforms</td>
                    <td>
                        <ul id="simplelist">
                        <% if (Model.Transform != null)
                           { %>
                               
                               <li><%: Model.Transform.TransformName %>:</li>
                               
                               <%
                                foreach (var transformDef in Model.Transform.TransformDefinition)
                                { %>
                                    <li> 
                                        <%: 
                                            Html.ActionLink(
                                            string.Format("{0} - {1}", transformDef.Transform.TransformName, transformDef.TransformTarget.TargetName),
                                            "TransformMappings", new { clientId = Model.ClientDetail.Client_id, studyId = Model.ClientDetail.Study_id, surveyId = Model.ClientDetail.Survey_id, transformId = transformDef.TransformId, transformTargetId = transformDef.TransformTargetId }
                                            )
                                        %>
                                    </li>
                        <%      }
                        } %>
                        </ul>
                        </td>
                    <td></td>
                </tr>
            </table>
        </fieldset>

    <div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

