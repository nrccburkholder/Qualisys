<%@ Register TagPrefix="uc1" TagName="ucHeader" Src="ucHeader.ascx" %>
<%@ Register TagPrefix="uc1" TagName="ucFooter" Src="ucFooter.ascx" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="uploadguide.aspx.vb" Inherits="DataExchange.uploadguide"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>File Transfer User Manual</title>
		<script language="javascript" src="globalfunctions.js"></script>
		<script language="javascript">
		<!--
			var maxDays, maxDownloads;
			var bOpener = window.opener;
			var str;
			maxDays = <asp:Literal id="litMaxDays" runat="server"></asp:Literal>
			maxDownloads = <asp:Literal id="maxdownloads1" runat="server"></asp:Literal>
			
			function writeCloser(writer) {
				if ( bOpener && arguments.length > 0 ) {
					str += "<table><tr><td align=\"right\">";
					str += "<a href=\"javascript:window.close();\">Close Window</a>";
					str += "</td></tr></table>"
					document.write(str);					
				} else if (bOpener) {
					document.write("<a href=\"javascript:window.close();\">Close Window</a>");
				}
			}
		// -->
		</script>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body leftMargin="0" topMargin="0" MS_POSITIONING="FlowLayout">
		<uc1:ucheader id="UcHeader1" runat="server"></uc1:ucheader>
		<!-- start border -->
		<table width="760" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="3"><img src="img/ghost.gif" height="2"></td>
			</tr>
			<tr>
				<td class="nrcBorder" colspan="3"><img src="img/ghost.gif" height="2"></td>
			</tr>
			<tr>
				<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
				<td>
					<!-- start content-->
					<table width="100%">
						<tr>
							<td><IMG alt="" src="img/ghost.gif" width="15"></td>
							<td>
								<h2 class="h2help">File Transfer User Manual</h2>
								<p>Welcome to the new file transfer system. This enhanced system is designed to 
									make transfering files to NRC clients as easy and efficient as possible. Please 
									take a moment to familiarize yourself with the system. If, after reviewing the 
									manual, you have additional questions or comments please contact <A href="mailto:tsmidberg@nationalresearch.com?subject=NRC File Transfer Question or Comment">
										Ted Smidberg</A> or <A href="mailto:jcamp@nationalresearch.com?subject=NRC File Transfer Question or Comment">
										Joe Camp</A> for assistance.</p>
								<h3>Index</h3>
								<A href="#loggingin">Logging In</A><br>
								<A href="#uploading">Uploading Files</A><br>
								<A href="#downloading">Downloading Files</A> <a name="loggingin">
									<h3 class="h3help">Logging In</h3>
								</a>
								<table>
									<tr>
										<td vAlign="top">
											<p><strong class="hash">NRC Associates</strong><br>
												Enter your assigned user name and password. Click the "Sign In" buttom to 
												access the system.</p>
											<p><strong class="hash">File Downloads</strong><br>
												Enter the user name and password that was provided to you when notified of the 
												file download. After clicking the "Sign In" button you will be taken to your 
												download page.
											</p>
											<br>
											<br>
											<br>
											<br>
											<br>
											<br>
											<br>
											<br>
											<br>
											Mouse over the fields for a description of its usage. Click the field for 
											additional information.
										</td>
										<td vAlign="top">
											<span class="imgHeader">Login Screen</span><br>
											<IMG height="439" title="Screen capture of the login page." hspace="3" src="img/login.jpg"
												width="527" useMap="#login_Map" vspace="3" border="0"><br>
										</td>
									</tr>
									<tr>
										<td align="right" colspan="2">
											<script language="javascript">
							writeCloser();
											</script>
										</td>
									</tr>
								</table>
								<hr>
								<a name="uploading">
									<h3 class="h3help">Uploading Files</h3>
								</a>The information needed on the file upload page is relatively straight 
								forward and all of the fields are required.
								<ol>
									<li>
									Enter your client's first and last names.
									<li>
										Enter your client's e-mail address. <b>IMPORTANT:</b>
									An e-mail will be sent to this address after you upload your file. Be careful 
									to enter the correct address so your client recieves the notification message.
									<li>
									Provide a brief description of the file you're sending.
									<li>
									Click the "Browse" button to find the file you want to upload.
									<li>
										Click "Upload File" to upload the file.
									</li>
								</ol>
								<p>That's it, your file has been uploaded! An an e-mail has been sent to the 
									address you specified for your client to notify them. You will receive a copy 
									of the e-mail for your records. The e-mail message will contain a user name and 
									password to use to gain access to the file. See the <A href="#filedownload">file 
										download section</A> for more information. Repeat the process for any 
									additional files you need to transfer.</p>
								<p>Mouse over the fields for a description of its usage. Click the field for 
									additional information.</p>
								<span class="imgHeader">Upload Screen</span><br>
								<IMG height="542" title="Screen capture of the file upload page." src="img/postPage_2.jpg"
									width="730" useMap="#postPage_Map" border="0">
								<h3>File Upload Tips &amp; Tricks</h3>
								<ul>
									<li>
									If you have multiple files to send a single client put them all into a single 
									zip file. This way you don't need to upload and your client doesn't need to 
									download multiple files.
									<li>
									To prevent typing errors use the browse button to locate files rather than 
									typing directly into the file field. Remember, you can browse to networked 
									files and folders as well as your local machine.
									<li>
									If you're uploading a large file consider putting it into a zip file. Remember, 
									your client might not be accessing the download system from a high speed 
									connection.
									<li>
										Copy and paste the e-mail address from your contacts list for accuracy.
									</li>
								</ul>
								<table width="100%">
									<tr>
										<td align="right">
											<script language="javascript">
								writeCloser();
											</script>
										</td>
									</tr>
								</table>
								<hr width="100%">
								<a name="downloading">
									<h3 class="h3help">Downloading Files</h3>
								</a>
								<p>This section describes the process of downloading files from the data transfer 
									system. When a file is uploaded for you into the system you will receive an 
									e-mail similar to the following:</p>
								<table>
									<tr>
										<td><span class="imgHeader">Notification E-mail</span><br>
											<IMG src="img\email.gif" width="558" height="524" hspace="3" vspace="3" border="0" useMap="#emailmap"
												title="Screen capture of the notification e-mail.">
										</td>
										<td vAlign="middle">
											<p><span class="hash">Posted By:</span> is the person sending you the file.</p>
											<p><span class="hash">Post Time:</span> is the day the file was uploaded.</p>
											<p><span class="hash">Description:</span> is a brief description of your file.</p>
											<p><span class="hash">Expiration Date:</span> is the date your download will 
												expire. After this date the file will no longer be available. Currently you 
												have
												<script language="javascript">document.write(maxDays)</script>
												days to download a file.</p>
											<p><span class="hash">Maximum Downloads:</span> This value represents the maximum 
												number of times you are allowed to download a file. Once this limit is reached 
												the file will no longer be available. Currently the download limit is
												<script language="javascript">document.write(maxDownloads)</script>
												.
											</p>
											<p><span class="hash">Secure Site:</span> is a hyperlink to the download site. 
												Clicking it will take you to the login page.</p>
											<p><span class="hash">User Name:</span> is the login name you use to retrieve your 
												file.</p>
											<p><span class="hash">Password:</span> is the password you use to retrieve your 
												file.</p>
										</td>
									</tr>
									<tr>
										<td colSpan="2">When logging in to the site to download a file you may find it 
											helpful to copy and paste the user name and password. This will help to prevent 
											typing mistakes.<br>
											<br>
										</td>
									</tr>
									<tr>
										<td valign="top"><span class="imgHeader">Download Screen</span><br>
											<IMG src="Img/downloadscreen.gif" width="585" height="473" hspace="3" vspace="3" border="0"
												usemap="#dlMap" title="Screen capture of the file download screen."></td>
										<td vAlign="middle">
											<p><span class="hash">File Name</span> is the name of the file your are 
												downloading. Click this hyperlink to download your file. Depending upon the 
												file type and your web browser settings the file will either open in your 
												browser or you will be prompted to open or save the file. If you save the file 
												to your hard drive make a note of where you save the file so you can open it 
												after it downloads.</p>
											<p><span class="hash">Description:</span> is a brief description provided by the 
												person who uploaded your file.</p>
											<p><span class="hash">Date Uploaded:</span> is the date the file was uploaded.</p>
											<p><span class="hash">Last Downloaded:</span> is the date the file was downloaded. 
												This is "Never" if you have not yet retrieved the file.</p>
											<p><span class="hash">Removal Date:</span> You have
												<script language="javascript">document.write(maxDays)</script>
												days to download your file. The Removal Date is the last day the file will be 
												available for download.</p>
											<p><span class="hash">Number of Downloads:</span> You can download files up to
												<script language="javascript">document.write(maxDownloads)</script>
												times. This line represents the number of times you have already downloaded the 
												file.</p>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<table width="100%">
						<tr>
							<td align="right">
								<script language="javascript">
					writeCloser();
								</script>
							</td>
						</tr>
					</table>
					<!-- border table -->
				</td>
				<td class="nrcBorder" width="2"><img src="img/ghost.gif" width="2"></td>
			</tr>
			<tr>
				<td class="nrcBorder" colspan="3"><img src="img/ghost.gif" height="2"></td>
			</tr>
			<tr>
				<td colspan="3"><img src="img/ghost.gif" height="2"></td>
			</tr>
		</table>
		<!-- border table -->
		<uc1:ucFooter id="UcFooter1" runat="server"></uc1:ucFooter>
		<MAP name="postPage_Map">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="If you want to change your password click here."
				coords="584,113,706,134" href="help.html#pword">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Click here to provide feedback about the data transfer system."
				coords="465,114,576,133" href="help.html#feedback">
			<AREA onclick="winOpen(this.href);return false;" shape="POLY" alt="Click this button to upload the file."
				coords="160,410,255,410,257,408,271,408,276,416,276,427,269,434,257,434,254,431,160,432"
				href="help.html#upload">
			<AREA onclick="winOpen(this.href);return false;" shape="POLY" alt="Click this button to browse for the file you want to upload."
				coords="315,387,378,387,378,379,385,372,397,372,404,380,404,390,394,399,394,404,315,404,316,404"
				href="help.html#browse">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Click the Browse button to populate this field."
				coords="159,385,310,404" href="help.html#upfield">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Enter a brief description of the file you're uploading."
				coords="159,358,312,379" href="help.html#description">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Enter your client's e-mail address here. This is where a notification e-mail will be sent so make sure it's correct!"
				coords="159,331,313,351" href="help.html#email">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Enter your client's last name in this field."
				coords="160,304,313,324" href="help.html#lname">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Enter your client's last name in this field."
				coords="159,277,313,298" href="help.html#fname">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Clicking this button will log you out of the system."
				coords="647,449,700,471" href="help.html#logout">
		</MAP><MAP name="login_Map">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Click to login to the system."
				coords="145,326,202,347" href="help.html#usersignin">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Enter your password here. If you're attempting to download a file the password was contained in your notification e-mail."
				coords="104,299,202,319" href="help.html#userpword">
			<AREA onclick="winOpen(this.href);return false;" shape="RECT" alt="Enter your user name here. Your username was either assigned to you or contained in an e-mail notifying you of a file download."
				coords="104,272,203,293" href="help.html#uname">
		</MAP><map name="emailmap" id="postedby">
			<area shape="RECT" coords="23,285,520,309" href="#" alt="The person sending you the file."
				title="The person sending you the file." onClick="javascript: return false;">
			<area shape="RECT" coords="23,310,520,335" href="#" alt="Date and time file was uploaded."
				title="This is the date and time the file was uploaded into the file transfer system."
				onClick="javascript: return false;">
			<area shape="RECT" coords="23,336,520,359" href="#" alt="Description of the uploaded file."
				title="Description of the uploaded file." onClick="javascript: return false;">
			<area shape="RECT" coords="22,360,520,384" href="#" alt="Expiration date of the file. Your file will not be available after this date."
				title="Expiration date of the file. Your file will not be available after this date."
				onClick="javascript: return false;">
			<area shape="RECT" coords="22,385,520,410" href="#" alt="The maximum number of times you can download this file."
				title="The maximum number of times you can download this file." onClick="javascript: return false;">
			<area shape="RECT" coords="22,411,520,434" href="#" alt="Hyperlink to the web site where you can download your file. Click the link to go to the download site."
				title="Hyperlink to the web site where you can download your file. Click the link to go to the download site."
				onClick="javascript: return false;">
			<area shape="RECT" coords="22,435,520,459" href="#" alt="User name to login to the site to download this file. Copy and paste this value when logging in."
				title="User name to login to the site to download this file. Copy and paste this value when logging in."
				onClick="javascript: return false;">
			<area shape="RECT" coords="22,460,520,484" href="#" alt="Password to login to the site to download this file. Copy and paste this value when logging in."
				title="Password to login to the site to download this file. Copy and paste this value when logging in."
				onClick="javascript: return false;">
		</map><map name="dlMap" id="dlMap">
			<area shape="RECT" coords="35,223,353,244" href="#" alt="The name of the file you are downloading. Click to begin the download."
				title="The name of the file you are downloading. Click to begin the download." onClick="javascript: return false;">
			<area shape="RECT" coords="35,246,220,263" href="#" alt="Description of the file contents."
				title="Description of the file contents." onClick="javascript: return false;">
			<area shape="RECT" coords="35,266,239,283" href="#" alt="Date the file was uploaded."
				title="Date the file was uploaded." onClick="javascript: return false;">
			<area shape="RECT" coords="35,286,238,303" href="#" alt="Date you last downloaded this file."
				title="Date you last downloaded this file." onClick="javascript: return false;">
			<area shape="RECT" coords="35,305,351,325" href="#" alt="The last day this file will be available and number of days remaining."
				title="The last day this file will be available and number of days remaining." onClick="javascript: return false;">
			<area shape="RECT" coords="35,327,229,344" href="#" alt="Number of times remaining you can download this file."
				title="Number of times remaining you can download this file." onClick="javascript: return false;">
			<area shape="RECT" coords="502,351,558,374" href="#" alt="Click to logout of the file transfer system."
				title="Click to logout of the file transfer system." onClick="javascript: return false;">
			<area shape="RECT" coords="456,111,565,138" href="#" alt="Send questions and comments to NRC about the file transfer system."
				title="Send questions and comments to NRC about the file transfer system." onClick="javascript: return false;">
		</map>
	</body>
</HTML>
