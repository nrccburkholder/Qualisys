<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="NRC.Picker.SamplingService.Store.Models" %>
<%@ Assembly Name="System.Data.Entity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Sampling Service
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Sampling Service</h2>
    <br />
    <table>
    <tr>
        <th>Queue Order</th>
        <th>ID</th>
        <th>State</th>
        <th>Sampling Start Time</th>
        <th>Sampling End Time</th>
        <th>Sampling Time</th>
    </tr>

    <%
    foreach (QueuedDataset queueDataset in (IEnumerable<QueuedDataset>) ViewData["queuedDatasets"])
    {
    %>
    <tr>
        <td><%= queueDataset.DatasetQueueID %></td>
        <td><%= queueDataset.DatasetID %></td>

        <% if (queueDataset.StateString == State.Completed.ToString()) { %>
            <td><a href="/Report/<%= queueDataset.DatasetID %>" target="_blank"><%= queueDataset.StateString %></a></td>
        <% } else { %>
            <td><%= queueDataset.StateString %></td>
        <% } %>
        <td><%= queueDataset.SampleStartTime %></td>
        <td><%= queueDataset.SampleEndTime %></td>
        <td>
        <%
        TimeSpan ts = (queueDataset.SampleEndTime - queueDataset.SampleStartTime).Value;
        Writer.Write(ts.Minutes);
        Writer.Write(ts.Minutes > 1 ? " minutes" : " minute");
        %> 
        </td>
    </tr>
    <%
    }
    %>
    </table>
</asp:Content>
