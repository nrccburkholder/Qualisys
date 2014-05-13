<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ServiceTypeEditor.ascx.vb" Inherits="Nrc.MySolutions.eToolKit_UserControls_ServiceTypeEditor" %>
<div style="text-align: center; font-size: 12px;"><strong>eToolKit Service Types</strong></div>
<hr />
<div style="width: 100%; border: Solid 1px #636563;">
    <div style="background-color: #636563; color: #ffffff; text-align: center; font-weight: bold;">Add a New Service Type</div>
    <div style="padding: 5px;">
        <table>
            <tr>
                <td>Service Type Name:</td>
                <td><asp:TextBox ID="NewServiceTypeName" runat="server" Width="180px" Font-Size="10px"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Security Privilege:</td>
                <td><asp:DropDownList ID="PrivilegeDropDown" runat="server" Font-Size="10px" Width="186px"></asp:DropDownList></td>
            </tr>
        </table>
        <div style="text-align:right;"><asp:LinkButton ID="AddServiceTypeButton" runat="Server" Text="Add Service Type" /></div>
    </div>
</div>
<br />
<asp:GridView ID="ServiceTypeGrid" runat="server" AutoGenerateColumns="False" Width="100%" DataKeyNames="Id" CellPadding="3" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px">
    <FooterStyle BackColor="White" ForeColor="#000066" />
    <Columns>
        <asp:TemplateField>
            <HeaderTemplate>
                <input type="checkbox" onclick="ChangeAllCheckBoxStates(ServiceTypeCheckBoxIDs,this.checked);" />
            </HeaderTemplate>
            <ItemTemplate>
                <asp:CheckBox ID="DeleteCheckBox" runat="server" />
            </ItemTemplate>
        </asp:TemplateField>    
        <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="True" />
        <asp:TemplateField HeaderText="Name">
            <EditItemTemplate>
                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:LinkButton ID="GridLinkButton" runat="server" Text='<%# Bind("Name") %>' OnClick="GridItemClicked" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Security Privilege">
            <EditItemTemplate>
                <asp:DropDownList ID="EditPrivilegeDropDown" runat="server"></asp:DropDownList>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%# Bind("PrivilegeId") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:CommandField ShowEditButton="True" />
    </Columns>
    <RowStyle ForeColor="#000066" />
    <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
    <HeaderStyle BackColor="#636563" Font-Bold="True" ForeColor="White" CssClass="ModelManagerGridHeader" />
    <EmptyDataRowStyle BorderStyle="None" />
    <EmptyDataTemplate>
        <div style="padding: 30px; text-align: center; background-color: #F9F9F9;">There are no themes in this view.</div>
    </EmptyDataTemplate>
    <AlternatingRowStyle BackColor="#F7F7F7" />
</asp:GridView> 
<asp:Label ID="GridErrorMessages" runat="server" ForeColor="Red"></asp:Label>
<br />
<asp:Button ID="DeleteCheckedButton" runat="server" Text="Delete Selected Service Types" Width="195px" CssClass="DeleteCheckedButton" OnClientClick="return confirm('Are you sure you want to delete the selected service types?');" />