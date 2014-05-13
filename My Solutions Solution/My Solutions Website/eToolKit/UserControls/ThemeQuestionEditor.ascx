<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ThemeQuestionEditor.ascx.vb" Inherits="Nrc.MySolutions.eToolKit_UserControls_ThemeQuestionEditor" %>
<div style="text-align: center; font-size: 12px;"><strong>Assigned Questions</strong></div>
<hr />
<div style="width: 100%; border: Solid 1px #636563;">
    <div style="background-color: #636563; color: #ffffff; text-align: center; font-weight: bold;">Assign a New Question</div>
    <div style="padding: 5px;">Question ID:  <asp:TextBox ID="QuestionIdTextBox" runat="server" Width="60px" Font-Size="10px"></asp:TextBox>  <asp:LinkButton ID="AssignButton" runat="Server" Text="Add Question" />
    </div>
    <asp:Label ID="QuestionErrorLabel" runat="server" ForeColor="Red"></asp:Label>
</div>
<br />
<asp:GridView ID="ThemeGrid" runat="server" AutoGenerateColumns="False" Width="100%" AllowSorting="True" DataKeyNames="QuestionId" CellPadding="3" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px">
    <FooterStyle BackColor="White" ForeColor="#000066" />
    <Columns>
        <asp:TemplateField>
            <HeaderTemplate>
                <input type="checkbox" onclick="ChangeAllCheckBoxStates(QuestionsCheckBoxIDs,this.checked);" />
            </HeaderTemplate>
            <ItemTemplate>
                <asp:CheckBox ID="SelectQuestionCheckBox" runat="server" Enabled='<%# IsQuestionCheckable(Eval("Status")) %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="QuestionId" HeaderText="ID" ReadOnly="True" SortExpression="QuestionId" />
        <asp:TemplateField HeaderText="Question" SortExpression="QuestionText" >
            <ItemTemplate>
                <a href="QuestionManager.aspx?QuestionID=<%# Eval("QuestionId") %>">
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("QuestionText") %>'></asp:Label>
                </a>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="StatusLabel" HeaderText="Status" ReadOnly="True" SortExpression="StatusLabel" />
    </Columns>
    <RowStyle ForeColor="#000066" />
    <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
    <HeaderStyle BackColor="#636563" Font-Bold="True" ForeColor="White" CssClass="ModelManagerGridHeader" />
    <AlternatingRowStyle BackColor="#f7f7f7" />
</asp:GridView> 
<asp:Label ID="GridErrorMessages" runat="server" ForeColor="Red"></asp:Label><br />
<asp:Button ID="DeleteCheckedButton" runat="server" Text="Delete Selected Questions" Width="175px" CssClass="DeleteCheckedButton" />