<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="progressbar.aspx.vb" Inherits="NRC.DataLoader.progressbar" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
  <title>Progress...</title>
  <meta http-equiv="expires" content="Tue, 01 Jan 1981 01:00:00 GMT">
  <% = Meta %>  
 </head>
 <body bgcolor="silver">
 <center>
  <table border="0" width="60%">
   <tr>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>Uploading:</b></font></td>
   </tr>
   <tr bgcolor="#999999">
    <td colspan = "2" align = "left">
     <table border="0" width="<% = Percent %>%" cellspacing="1" bgcolor="#c6d6ff">
      <tr><td align = "left"><font size="1"><center><% = Percent %>% Complete</center></font></td></tr>
     </table>
    </td>
   </tr>
   <tr>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Estimated&nbsp;Time&nbsp;Left:</font></td>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><% = State %></font>
       </td>
      </tr>
      <tr>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Transfer&nbsp;Rate:</font></td>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><% = Kbps %> KB/sec</font></td>
      </tr>
      <tr>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Information:</font></td>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><% = Note %></font></td>
      </tr>
      <tr>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Uploading&nbsp;File:</font></td>
       <td align = "left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><% = FileName %></font></td>
   </tr>
  </table>
  </center>
 </body>
</html>
