<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<HHCAHPSImporter.ImportProcessor.DAL.Generated.UploadedFileLogView>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            prettyPrint();

            // $(".abandonded-target").ezpz_tooltip();

            //hide the all of the element with class msg_body
            $(".errorBody").hide();
            //toggle the componenet with class msg_body
            $(".errorHead").click(function () {
                $(this).next(".errorBody").slideToggle(600);
            });

        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Upload Files</h2>

    <% Html.RenderPartial("DateSearch"); %>
    <table>
        <tr>
            <th>
            </th>
            <th>
                UploadFileId
            </th>
            <th>
                FileName
            </th>
            <th>
                File State
            </th>
            <th>
                DataFileId
            </th>
            <th>
                ModDate
            </th>
        </tr>

    <% foreach (var item in Model) { %>

        <tr>
            <td>
                <a href='file://<%: HHCAHPSImporter.Web.UI.Models.Utils.GetUploadFileDirectory(item) %>'>
                    <span id="Span2" style="float:left" class="ui-icon ui-icon-folder-open" ></span>
                </a>
            </td>
            <td>
                <%: item.UploadFile_id %>
            </td>
            <td>
                <%: item.File_Nm %>
            </td>
            <td>
                <% if (item.UploadFileState_id == (int)HHCAHPSImporter.ImportProcessor.DAL.UploadState.UploadedAbandoned )
                   { %>
                    <div class="errorHead" id='<%: string.Format("abandonded-target-u{0}", item.UploadFile_id) %>'><%: ((HHCAHPSImporter.ImportProcessor.DAL.UploadState)item.UploadFileState_id).ToString()%></div>
                    <div class="errorBody" id='<%: string.Format("abandonded-content-u{0}", item.UploadFile_id) %>'>
                        <ul id="simplelist">
                            <% foreach (var m in item.UploadStateParam.Split(new char[] { '\r', '\n' }).Where(t => t.Length > 0).ToList())
                               { %>
                            <li><%: m %></li>
                            <% } %>
                        </ul>
                    </div>
                <%}
                   else
                   { %>
                <%: ((HHCAHPSImporter.ImportProcessor.DAL.UploadState)item.UploadFileState_id).ToString()%>
                <% } %>
            </td>
            <td>
                <%: item.DataFile_id %>
            </td>
            <td>
                <%: String.Format("{0:g}", item.DateUploadFileStateChange) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

