<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("#mindatepicker").datepicker();
        $("#maxdatepicker").datepicker();
    });
</script>

<% using (Html.BeginForm()) { %>
<table id="datesearch">
    <tr>
    <td>Min Date:&nbsp;<%: Html.TextBox("startDate", ViewData.Keys.Contains("startDate") ? ViewData["startDate"] : DateTime.Now.AddDays(-7).ToString("MM/dd/yyyy"), new { id = "mindatepicker", style = "width:75px" })%></td>
    <td>Max Date:&nbsp;<%: Html.TextBox("endDate", ViewData.Keys.Contains("endDate") ? ViewData["endDate"] : DateTime.Now.ToString("MM/dd/yyyy"), new { id = "maxdatepicker", style = "width:75px" })%></td>
    <td>Records:&nbsp;
    <%: Html.TextBox("take", ViewData.Keys.Contains("take")?ViewData["take"]:"25", new { style = "width:25px" })%>
    </td>
    <td>
        <%: Html.CheckBox("abandonedFilesOnly", ViewData.Keys.Contains("abandonedFilesOnly") ? Convert.ToBoolean(ViewData["abandonedFilesOnly"]) : false, new { id = "abandonedfilesonly" })%>
        Only Abandoned Files
        </td>
    <td><input type="submit" value="Search" /></td>
    </tr>
</table><% } %>
