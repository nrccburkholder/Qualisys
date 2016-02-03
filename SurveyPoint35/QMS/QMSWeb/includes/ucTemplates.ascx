<%@ Control Language="vb" AutoEventWireup="false" Codebehind="ucTemplates.ascx.vb" Inherits="QMSWeb.ucTemplates" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td style="background-color:#f0f0f0">
            <asp:Literal id="ltTemplateResults" runat="server"></asp:Literal>
        </td>
    </tr>
    <tr>
        <td style="background-color:#f0f0f0">
        <div style="height:500px;overflow:scroll">
        <asp:datagrid id="dgTemplates" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False"
	        AllowPaging="True" PageSize="500">
	        <AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
	        <ItemStyle VerticalAlign="Top"></ItemStyle>
	        <Columns>
		        <asp:TemplateColumn>
			        <ItemTemplate>
				        <asp:CheckBox id="cbSelected" runat="server" EnableViewState="False"></asp:CheckBox>
			        </ItemTemplate>
		        </asp:TemplateColumn>
		        <asp:TemplateColumn SortExpression="TemplateID" HeaderText="ID">
			        <ItemTemplate>
				        <asp:HyperLink id=HyperLink1 runat="server" NavigateUrl='<%# String.Format("../filedefinitions/templatedetails.aspx?id={0}&amp;r={1}", DataBinder.Eval(Container, "DataItem.TemplateID"), Server.UrlEncode(ReferrerURL))%>' Text='<%# DataBinder.Eval(Container, "DataItem.TemplateID") %>'>
				        </asp:HyperLink>
			        </ItemTemplate>
		        </asp:TemplateColumn>
		        <asp:HyperLinkColumn DataNavigateUrlField="SurveyID" DataNavigateUrlFormatString="../surveys/surveydetails.aspx?id={0}"
			        DataTextField="SurveyName" SortExpression="SurveyName" HeaderText="Survey"></asp:HyperLinkColumn>
		        <asp:HyperLinkColumn DataNavigateUrlField="ClientID" DataNavigateUrlFormatString="../clients/clientdetails.aspx?id={0}"
			        DataTextField="ClientName" SortExpression="ClientName" HeaderText="Client"></asp:HyperLinkColumn>
		        <asp:HyperLinkColumn DataNavigateUrlField="ScriptID" DataNavigateUrlFormatString="../scripts/scriptdetails.aspx?id={0}"
			        DataTextField="ScriptName" SortExpression="ScriptName" HeaderText="Script"></asp:HyperLinkColumn>
		        <asp:HyperLinkColumn DataNavigateUrlField="FileDefID" DataNavigateUrlFormatString="../filedefinitions/FileDefinitionDetails.aspx?id={0}"
			        DataTextField="FileDefName" SortExpression="FileDefName" HeaderText="FileDef"></asp:HyperLinkColumn>
		        <asp:TemplateColumn>
			        <ItemStyle Wrap="False"></ItemStyle>
			        <ItemTemplate>
				        <asp:HyperLink id=hlDetails runat="server" Text="Details" NavigateUrl='<%# String.Format("../filedefinitions/templatedetails.aspx?id={0}&amp;r={1}", DataBinder.Eval(Container, "DataItem.TemplateID"), Server.UrlEncode(ReferrerURL))%>' ImageUrl="../images/qms_view1_sym.gif">Details</asp:HyperLink>
			        </ItemTemplate>
		        </asp:TemplateColumn>
	        </Columns>
	        <PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>
        </asp:datagrid>
        </div>
        </td>
    </tr>
    <tr>
        <td style="background-color:#f0f0f0">
            <table border="0" cellpadding="2" cellspacing="0">
	            <tr valign="bottom">
		            <td nowrap style="background-color:#f0f0f0"><asp:dropdownlist id="ddlSurvey" runat="server" AutoPostBack="True" CssClass="sfselect"></asp:dropdownlist></td>
		            <td style="background-color:#f0f0f0"><asp:hyperlink id="hlAdd" runat="server" ImageUrl="../images/qms_add_btn.gif" NavigateUrl="filedefinitiondetails.aspx"> Create new template</asp:hyperlink></td>
		            <td style="background-color:#f0f0f0"><asp:imagebutton id="ibDelete" runat="server" ToolTip="Delete selected template" ImageUrl="../images/qms_delete_btn.gif"></asp:imagebutton></td>
	            </tr>
            </table>
          </td>
   </tr>
</table>
