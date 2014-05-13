<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ThemeEditor.ascx.vb" Inherits="Nrc.MySolutions.eToolKit_UserControls_ThemeEditor" %>
<div style="text-align: center; font-size: 12px;"><strong>eToolKit Themes</strong></div>
<hr />
<div style="width: 100%; border: Solid 1px #636563;">
    <div style="background-color: #636563; color: #ffffff; text-align: center; font-weight: bold;">Add a New Theme</div>
    <div style="padding: 5px;">Theme Name:  <asp:TextBox ID="NewThemeName" runat="server" Width="350px" Font-Size="10px"></asp:TextBox>  <asp:LinkButton ID="AddThemeButton" runat="Server" Text="Add Theme" /></div>
</div>
<br />
<asp:GridView ID="ThemeGrid" runat="server" AutoGenerateColumns="False" Width="100%" DataKeyNames="Id" CellPadding="3" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px">
    <FooterStyle BackColor="White" ForeColor="#000066" />
    <Columns>
        <asp:TemplateField>
            <HeaderTemplate>
                <input type="checkbox" onclick="ChangeAllCheckBoxStates(ThemeCheckBoxIDs,this.checked);" />
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
            <ItemStyle Width="100%" />
            <ItemTemplate>
                <asp:LinkButton ID="GridLinkButton" runat="server" Text='<%# Bind("Name") %>' OnClick="GridItemClicked" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
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
<asp:Label ID="GridErrorMessages" runat="server" Text="" ForeColor="Red"></asp:Label> 
<br />
<asp:Button ID="DeleteCheckedButton" runat="server" Text="Delete Selected Themes" Width="160px" CssClass="DeleteCheckedButton" OnClientClick="return confirm('Are you sure you want to delete the selected themes?');" />