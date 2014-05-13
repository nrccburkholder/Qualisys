Option Strict On
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections
Imports System.ComponentModel
Imports System.IO
Imports System.Web.Mail
Imports System.Windows.Forms

Namespace WinForms

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.ExceptionReport
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This class is used to display and report exceptions in a Windows Forms application.
    ''' The ExceptionReport object will display a message box for the user to see the exception
    ''' details and give them the option of "reporting" the exception.  When the exception is 
    ''' reported an email is generated with the exception details and a screen shot of the
    ''' user's desktop when the exception occurred.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/7/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class ExceptionReport

#Region " Private Members "
        Private mScreenShot As Bitmap
        Private mImagePath As String
        Private mException As Exception
        Private mReportSender As String
        Private mReportRecipient As String
        Private mReportSubject As String
        Private mUserMessage As String
        Private mSMTPServer As String

#End Region

#Region " Public Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The email address of the person sending the exception report
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property ReportSender() As String
            Get
                Return mReportSender
            End Get
            Set(ByVal Value As String)
                mReportSender = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The email address of the recipient(s) of the exception report
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property ReportRecipient() As String
            Get
                Return mReportRecipient
            End Get
            Set(ByVal Value As String)
                mReportRecipient = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The email subject line of the exception report
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property ReportSubject() As String
            Get
                Return mReportSubject
            End Get
            Set(ByVal Value As String)
                mReportSubject = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The message entered by the user to describe how the exception was generated
        ''' </summary>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property UserMessage() As String
            Get
                Return mUserMessage
            End Get
            Set(ByVal Value As String)
                mUserMessage = Value
            End Set
        End Property

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The SMTP server to use in sending the exception email
        ''' </summary>
        ''' <value></value>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Property SMTPServer() As String
            Get
                Return mSMTPServer
            End Get
            Set(ByVal Value As String)
                mSMTPServer = Value
            End Set
        End Property

#End Region

#Region " Constructors "
        Sub New(ByVal ex As Exception)
            mException = ex
            mSMTPServer = "smtp.nationalresearch.com"
        End Sub
#End Region

#Region " Public Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Submits the exception report
        ''' </summary>
        ''' <param name="sendEmail">if true, an email will be sent with the exception details</param>
        ''' <param name="logToSQL">if true, the exception will be logged to a SQL server table</param>
        ''' <remarks>
        ''' SQL Server Logging is not functional...how can you do this for multiple apps and DBs?
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub ReportException(ByVal sendEmail As Boolean, ByVal logToSQL As Boolean)
            GetScreenShot()

            If sendEmail Then
                EmailReport()
            End If
            If logToSQL Then
                SQLReport()
            End If
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Displays the message box detailing the exception to the user.  This message box also
        ''' gives the user the option of "reporting" the exception.
        ''' 
        ''' The SMTPServer, ReportRecipient, and ReportSubject properties should have been set
        ''' before this method is called
        ''' </summary>
        ''' <param name="title">The text to appear in the message box title bar</param>
        ''' <param name="sendEmail">if true, an email report will be generated if the user reports the exception</param>
        ''' <param name="logToSQL">if true, an SQL log entry will be created if the user reports the exception</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub ShowException(ByVal title As String, ByVal sendEmail As Boolean, ByVal logToSQL As Boolean)
            Dim frm As New ExceptionMessage(mException, title)
            frm.StartPosition = FormStartPosition.CenterScreen
            GetScreenShot()

            If frm.ShowDialog = DialogResult.OK Then
                If Me.ShowReportUI() = DialogResult.OK Then
                    ReportException(sendEmail, logToSQL)
                End If
            End If

            DeleteImage()
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Shows the Exception Report Form where the user enters the recipient email
        ''' address and writes a description of how the exception occurred.
        ''' </summary>
        ''' <returns>returns a DialogResult value indicating if the user clicked "OK" or "Cancel"</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function ShowReportUI() As Windows.Forms.DialogResult
            GetScreenShot()

            Dim frm As New ReportUI(Me, mScreenShot, "Error Report")

            Return frm.ShowDialog
        End Function

#End Region

#Region " Private Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' If the screen shot has not yet been captured and stored then this method does so
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub GetScreenShot()
            If mScreenShot Is Nothing Then
                mScreenShot = ScreenScraper.PerformCapture
                StoreImage(mScreenShot)
            End If
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Stores the image to a JPEG file in the user's application data folder 
        ''' with a timestamp name
        ''' </summary>
        ''' <param name="img">the image to be stored</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub StoreImage(ByVal img As Bitmap)
            Dim appFolder As String = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)
            Dim fileName As String = DateTime.Now.ToString.Replace(" ", "").Replace("/", "").Replace(":", "").Replace("PM", "").Replace("AM", "")
            fileName &= ".jpg"
            Dim filePath As String = appFolder & "\" & fileName

            img.Save(filePath, Imaging.ImageFormat.Jpeg)

            mImagePath = filePath
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Deletes the temporary screen capture JPEG in the user's application data folder
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub DeleteImage()
            File.Delete(mImagePath)
            mImagePath = ""
            mScreenShot = Nothing
        End Sub


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Generates and sends the exception report
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub EmailReport()
            Dim mail As New MailMessage
            Dim img As Bitmap = ScreenScraper.PerformCapture
            Dim attach As MailAttachment

            'Get the screen shot if we need to
            GetScreenShot()

            attach = New MailAttachment(mImagePath)
            mail.Attachments.Add(attach)
            mail.To = mReportRecipient
            mail.From = mReportSender
            mail.Subject = mReportSubject
            mail.Body = GetExceptionHtml()
            mail.BodyFormat = MailFormat.Html

            System.Web.Mail.SmtpMail.SmtpServer = mSMTPServer
            System.Web.Mail.SmtpMail.Send(mail)
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Generates the HTML for the body of the email
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Function GetExceptionHtml() As String
            Dim sb As New System.Text.StringBuilder
            Dim stack As String
            Dim inStack As String

            Dim tableStyle As String = "{background-color: #033791; font-family: Tahoma, Verdana, Arial; font-size:X-Small;}"
            Dim headerStyle As String = "{Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)}"
            Dim labelStyle As String = "{background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold}"
            Dim dataStyle As String = "{background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap}"
            Dim infostyle As String = "{background-color: #FFFFFF; padding: 5px}"
            Dim message As String

            sb.Append("<HTML>")
            sb.Append("<HEAD>")
            sb.Append("<STYLE>")
            sb.AppendFormat(".NotifyTable{0}", tableStyle)
            sb.AppendFormat(".HeaderRow{0}", headerStyle)
            sb.AppendFormat(".LabelCell{0}", labelStyle)
            sb.AppendFormat(".DataCell{0}", dataStyle)
            sb.AppendFormat(".InfoCell{0}", infostyle)
            sb.Append("</STYLE>")
            sb.Append("</HEAD>")

            sb.Append("<BODY>")
            sb.Append("<TABLE Class=""NotifyTable"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">")
            sb.Append("<TR><TD Class=""HeaderRow"" Colspan=""2"">" & mReportSubject & "</TD></TR>")
            sb.AppendFormat("<TR><TD Class=""LabelCell"">User Name:</TD><TD Class=""DataCell"">{0}</TD></TR>", Environment.UserName)
            sb.AppendFormat("<TR><TD Class=""LabelCell"">Date Occurred:</TD><TD Class=""DataCell"">{0}</TD></TR>", DateTime.Now.ToString)
            sb.AppendFormat("<TR><TD Class=""LabelCell"">Machine Name:</TD><TD Class=""DataCell"">{0}</TD></TR>", Environment.MachineName)
            sb.AppendFormat("<TR><TD Class=""LabelCell"">Exception:</TD><TD Class=""DataCell"">{0}</TD></TR>", mException.Message)
            If TypeOf mException Is NRC.Data.SqlCommandException Then
                sb.AppendFormat("<TR><TD Class=""LabelCell"">SQL Command:</TD><TD Class=""DataCell"">{0}</TD></TR>", DirectCast(mException, NRC.Data.SqlCommandException).CommandText)
            End If
            sb.AppendFormat("<TR><TD Class=""LabelCell"">Source:</TD><TD Class=""DataCell"">{0}</TD></TR>", mException.Source)

            If Not mException.StackTrace Is Nothing Then
                stack = mException.Message & ":" & vbCrLf & mException.StackTrace
                stack = stack.Replace(" at", "<BR> at")

                sb.AppendFormat("<TR><TD Class=""LabelCell"">Stack Trace:</TD><TD Class=""DataCell"">{0}</TD></TR>", stack)
            End If

            If Not mException.InnerException Is Nothing Then
                If Not mException.InnerException.Message Is Nothing Then
                    inStack = mException.InnerException.Message & ":" & vbCrLf
                End If
                inStack &= mException.InnerException.StackTrace
                inStack = inStack.Replace(" at", "<BR> at")

                sb.AppendFormat("<TR><TD Class=""LabelCell"">Inner Stack Trace:</TD><TD Class=""DataCell"">{0}</TD></TR>", inStack)
            End If

            If mUserMessage.Length > 0 Then
                sb.AppendFormat("<TR><TD Class=""LabelCell"">User Message:</TD><TD Class=""DataCell"">{0}</TD></TR>", mUserMessage.Replace(vbCrLf, "<BR>"))
            End If

            sb.Append("</TABLE></TD></TR>")

            sb.AppendFormat("<TR><TD Class=""InfoCell"" Colspan=""2"">{0}</TD></TR>", message)
            sb.Append("</TABLE>")


            sb.Append("</BODY>")
            sb.Append("</HTML>")

            Return sb.ToString
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Not yet implemented
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/7/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub SQLReport()

        End Sub

#End Region



#Region " ExceptionMessage Class "
        Public Class ExceptionMessage
            Inherits NRC.WinForms.DialogForm

            Private mException As Exception
            Private mTitle As String
            Private mIsSqlCommandException As Boolean = False

#Region " Windows Form Designer generated code "

            Public Sub New(ByVal ex As Exception, ByVal title As String)
                MyBase.New()

                'This call is required by the Windows Form Designer.
                InitializeComponent()

                'Add any initialization after the InitializeComponent() call
                mException = ex
                mTitle = title
            End Sub

            'Form overrides dispose to clean up the component list.
            Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
                If disposing Then
                    If Not (components Is Nothing) Then
                        components.Dispose()
                    End If
                End If
                MyBase.Dispose(disposing)
            End Sub

            'Required by the Windows Form Designer
            Private components As System.ComponentModel.IContainer

            'NOTE: The following procedure is required by the Windows Form Designer
            'It can be modified using the Windows Form Designer.  
            'Do not modify it using the code editor.
            Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
            Friend WithEvents btnClose As System.Windows.Forms.Button
            Friend WithEvents lblStackLabel As System.Windows.Forms.Label
            Friend WithEvents txtStackTrace As System.Windows.Forms.TextBox
            Friend WithEvents btnDetails As System.Windows.Forms.LinkLabel
            Friend WithEvents btnReport As System.Windows.Forms.LinkLabel
            Friend WithEvents lblMessage As System.Windows.Forms.Label
            Friend WithEvents lblSqlCommand As System.Windows.Forms.Label
            Friend WithEvents txtSqlCommand As System.Windows.Forms.TextBox
            <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
                Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager("NRC.ExceptionReport", System.Reflection.Assembly.GetCallingAssembly)
                Me.lblStackLabel = New System.Windows.Forms.Label
                Me.txtStackTrace = New System.Windows.Forms.TextBox
                Me.PictureBox1 = New System.Windows.Forms.PictureBox
                Me.btnDetails = New System.Windows.Forms.LinkLabel
                Me.btnReport = New System.Windows.Forms.LinkLabel
                Me.btnClose = New System.Windows.Forms.Button
                Me.lblMessage = New System.Windows.Forms.Label
                Me.lblSqlCommand = New System.Windows.Forms.Label
                Me.txtSqlCommand = New System.Windows.Forms.TextBox
                Me.SuspendLayout()
                '
                'mPaneCaption
                '
                Me.mPaneCaption.Name = "mPaneCaption"
                Me.mPaneCaption.Size = New System.Drawing.Size(494, 26)
                '
                'lblStackLabel
                '
                Me.lblStackLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.lblStackLabel.Location = New System.Drawing.Point(8, 106)
                Me.lblStackLabel.Name = "lblStackLabel"
                Me.lblStackLabel.Size = New System.Drawing.Size(72, 23)
                Me.lblStackLabel.TabIndex = 1
                Me.lblStackLabel.Text = "Stack Trace:"
                Me.lblStackLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
                Me.lblStackLabel.Visible = False
                '
                'txtStackTrace
                '
                Me.txtStackTrace.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
                Me.txtStackTrace.BackColor = System.Drawing.SystemColors.Control
                Me.txtStackTrace.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
                Me.txtStackTrace.Location = New System.Drawing.Point(88, 106)
                Me.txtStackTrace.Multiline = True
                Me.txtStackTrace.Name = "txtStackTrace"
                Me.txtStackTrace.ReadOnly = True
                Me.txtStackTrace.ScrollBars = System.Windows.Forms.ScrollBars.Both
                Me.txtStackTrace.Size = New System.Drawing.Size(400, 175)
                Me.txtStackTrace.TabIndex = 2
                Me.txtStackTrace.Text = "Exception: Could not clean DataFile_id 219: Index and length must refer to a loca" & _
                "tion within the string.  Parameter name: length     " & Microsoft.VisualBasic.ChrW(13) & Microsoft.VisualBasic.ChrW(10) & "at System.String.Substring" & _
                "(Int32 startIndex, Int32 length)     " & Microsoft.VisualBasic.ChrW(13) & Microsoft.VisualBasic.ChrW(10) & "at NRC.AddressCleaning.CName.Clean(enumCo" & _
                "untryCodes CountryID, Boolean ProperCase, Int32 NameHandle)     " & Microsoft.VisualBasic.ChrW(13) & Microsoft.VisualBasic.ChrW(10) & "at NRC.Address" & _
                "Cleaning.CNames.CleanAll(Int32 FileID, Int32 StudyID, Int32 BatchSize, CMetaGrou" & _
                "ps& MetaGroups)     " & Microsoft.VisualBasic.ChrW(13) & Microsoft.VisualBasic.ChrW(10) & "at NRC.AddressCleaning.Cleaner.CleanAll(Int32 FileID, Int3" & _
                "2 StudyID, Int32 BatchSize, Boolean Silent)     " & Microsoft.VisualBasic.ChrW(13) & Microsoft.VisualBasic.ChrW(10) & "at NRC.AddressCleaner.AddressC" & _
                "leaner.Clean(Int32 dataFileID)"
                Me.txtStackTrace.Visible = False
                Me.txtStackTrace.WordWrap = False
                '
                'PictureBox1
                '
                Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
                Me.PictureBox1.Location = New System.Drawing.Point(24, 40)
                Me.PictureBox1.Name = "PictureBox1"
                Me.PictureBox1.Size = New System.Drawing.Size(32, 32)
                Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
                Me.PictureBox1.TabIndex = 3
                Me.PictureBox1.TabStop = False
                '
                'btnDetails
                '
                Me.btnDetails.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
                Me.btnDetails.FlatStyle = System.Windows.Forms.FlatStyle.System
                Me.btnDetails.Location = New System.Drawing.Point(8, 108)
                Me.btnDetails.Name = "btnDetails"
                Me.btnDetails.Size = New System.Drawing.Size(80, 20)
                Me.btnDetails.TabIndex = 4
                Me.btnDetails.TabStop = True
                Me.btnDetails.Text = "Show Details..."
                '
                'btnReport
                '
                Me.btnReport.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
                Me.btnReport.FlatStyle = System.Windows.Forms.FlatStyle.System
                Me.btnReport.Location = New System.Drawing.Point(104, 108)
                Me.btnReport.Name = "btnReport"
                Me.btnReport.Size = New System.Drawing.Size(120, 20)
                Me.btnReport.TabIndex = 5
                Me.btnReport.TabStop = True
                Me.btnReport.Text = "Report Error..."
                '
                'btnClose
                '
                Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
                Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
                Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.System
                Me.btnClose.Location = New System.Drawing.Point(408, 108)
                Me.btnClose.Name = "btnClose"
                Me.btnClose.TabIndex = 6
                Me.btnClose.Text = "Close"
                '
                'lblMessage
                '
                Me.lblMessage.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
                Me.lblMessage.Location = New System.Drawing.Point(96, 48)
                Me.lblMessage.Name = "lblMessage"
                Me.lblMessage.Size = New System.Drawing.Size(384, 48)
                Me.lblMessage.TabIndex = 7
                Me.lblMessage.Text = "An unhandled exception has occurred.  This process will be terminated."
                '
                'lblSqlCommand
                '
                Me.lblSqlCommand.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.lblSqlCommand.Location = New System.Drawing.Point(8, 288)
                Me.lblSqlCommand.Name = "lblSqlCommand"
                Me.lblSqlCommand.Size = New System.Drawing.Size(72, 23)
                Me.lblSqlCommand.TabIndex = 1
                Me.lblSqlCommand.Text = "Command:"
                Me.lblSqlCommand.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
                Me.lblSqlCommand.Visible = False
                '
                'txtSqlCommand
                '
                Me.txtSqlCommand.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
                Me.txtSqlCommand.BackColor = System.Drawing.SystemColors.Control
                Me.txtSqlCommand.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
                Me.txtSqlCommand.Location = New System.Drawing.Point(88, 288)
                Me.txtSqlCommand.Name = "txtSqlCommand"
                Me.txtSqlCommand.ReadOnly = True
                Me.txtSqlCommand.ScrollBars = System.Windows.Forms.ScrollBars.Both
                Me.txtSqlCommand.Size = New System.Drawing.Size(400, 20)
                Me.txtSqlCommand.TabIndex = 2
                Me.txtSqlCommand.Text = ""
                Me.txtSqlCommand.Visible = False
                Me.txtSqlCommand.WordWrap = False
                '
                'ExceptionMessage
                '
                Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
                Me.CancelButton = Me.btnClose
                Me.ClientSize = New System.Drawing.Size(496, 138)
                Me.Controls.Add(Me.lblMessage)
                Me.Controls.Add(Me.btnClose)
                Me.Controls.Add(Me.btnReport)
                Me.Controls.Add(Me.btnDetails)
                Me.Controls.Add(Me.PictureBox1)
                Me.Controls.Add(Me.txtStackTrace)
                Me.Controls.Add(Me.lblStackLabel)
                Me.Controls.Add(Me.lblSqlCommand)
                Me.Controls.Add(Me.txtSqlCommand)
                Me.DockPadding.All = 1
                Me.Name = "ExceptionMessage"
                Me.Text = "ExceptionMessage"
                Me.Controls.SetChildIndex(Me.txtSqlCommand, 0)
                Me.Controls.SetChildIndex(Me.lblSqlCommand, 0)
                Me.Controls.SetChildIndex(Me.lblStackLabel, 0)
                Me.Controls.SetChildIndex(Me.txtStackTrace, 0)
                Me.Controls.SetChildIndex(Me.PictureBox1, 0)
                Me.Controls.SetChildIndex(Me.btnDetails, 0)
                Me.Controls.SetChildIndex(Me.btnReport, 0)
                Me.Controls.SetChildIndex(Me.btnClose, 0)
                Me.Controls.SetChildIndex(Me.lblMessage, 0)
                Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
                Me.ResumeLayout(False)

            End Sub

#End Region

            Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
                Me.DialogResult = Windows.Forms.DialogResult.Cancel
            End Sub

            Private Sub ExceptionMessage_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
                LoadExceptionMessage()
            End Sub

            Private Sub LoadExceptionMessage()
                mIsSqlCommandException = (TypeOf mException Is NRC.Data.SqlCommandException)
                Me.Caption = mTitle
                lblMessage.Text = mException.Message
                'adjust lblMessage's height based on message's row number
                Dim row As Integer = mException.Message.Replace(vbCrLf, vbCr).Replace(vbLf, vbCr).Split(CChar(vbCr)).Length
                Dim height As Integer = (lblMessage.Font.Height) * row
                If (height > lblMessage.Height) Then
                    Dim offset As Integer = height - lblMessage.Height
                    Me.Height += offset
                    lblStackLabel.Top += offset
                    txtStackTrace.Top += offset
                    lblSqlCommand.Top += offset
                    txtSqlCommand.Top += offset
                    lblMessage.Height += offset
                End If

                If Not mException.StackTrace Is Nothing Then
                    txtStackTrace.Text = mException.Message & ":" & vbCrLf & mException.StackTrace '.Replace(" at", vbCrLf & " at")
                Else
                    txtStackTrace.Text = ""
                End If

                If Not mException.InnerException Is Nothing Then
                    txtStackTrace.Text &= vbCrLf & "--------Inner Exception--------" & vbCrLf

                    If Not mException.InnerException.Message Is Nothing Then
                        txtStackTrace.Text &= mException.InnerException.Message & ":" & vbCrLf
                    End If

                    If Not mException.InnerException.StackTrace Is Nothing Then
                        txtStackTrace.Text &= mException.InnerException.StackTrace
                    End If
                End If

                If mIsSqlCommandException Then
                    txtSqlCommand.Text = DirectCast(mException, NRC.Data.SqlCommandException).CommandText
                End If
            End Sub

            Private Sub btnDetails_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnDetails.LinkClicked
                If btnDetails.Text = "Show Details..." Then
                    btnDetails.Text = "Hide Details..."
                    lblStackLabel.Visible = True
                    txtStackTrace.Visible = True
                    Me.Height += 200
                    If mIsSqlCommandException Then
                        lblSqlCommand.Visible = True
                        txtSqlCommand.Visible = True
                        Me.Height += 20
                    End If
                Else
                    btnDetails.Text = "Show Details..."
                    lblStackLabel.Visible = False
                    txtStackTrace.Visible = False
                    Me.Height -= 200
                    If mIsSqlCommandException Then
                        lblSqlCommand.Visible = False
                        txtSqlCommand.Visible = False
                        Me.Height -= 20
                    End If
                End If

                Me.Refresh()
            End Sub

            Private Sub btnReport_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles btnReport.LinkClicked
                Me.DialogResult = Windows.Forms.DialogResult.OK
            End Sub
        End Class
#End Region

#Region " ReportUI Class "
        Private Class ReportUI
            Inherits NRC.WinForms.DialogForm

            Private mReport As ExceptionReport
            Private mScreenShot As Drawing.Bitmap
            Private mTitle As String

#Region " Windows Form Designer generated code "

            Public Sub New(ByVal report As ExceptionReport, ByVal img As Drawing.Bitmap, ByVal title As String)
                MyBase.New()

                'This call is required by the Windows Form Designer.
                InitializeComponent()

                'Add any initialization after the InitializeComponent() call
                mReport = report
                mScreenShot = img
                mTitle = title
            End Sub

            'Form overrides dispose to clean up the component list.
            Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
                If disposing Then
                    If Not (components Is Nothing) Then
                        components.Dispose()
                    End If
                End If
                MyBase.Dispose(disposing)
            End Sub

            'Required by the Windows Form Designer
            Private components As System.ComponentModel.IContainer

            'NOTE: The following procedure is required by the Windows Form Designer
            'It can be modified using the Windows Form Designer.  
            'Do not modify it using the code editor.
            Friend WithEvents btnOK As System.Windows.Forms.Button
            Friend WithEvents btnCancel As System.Windows.Forms.Button
            Friend WithEvents Label1 As System.Windows.Forms.Label
            Friend WithEvents txtRecipient As System.Windows.Forms.TextBox
            Friend WithEvents Label2 As System.Windows.Forms.Label
            Friend WithEvents imgScreen As System.Windows.Forms.PictureBox
            Friend WithEvents txtMessage As System.Windows.Forms.TextBox
            <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
                Me.btnOK = New System.Windows.Forms.Button
                Me.btnCancel = New System.Windows.Forms.Button
                Me.Label1 = New System.Windows.Forms.Label
                Me.imgScreen = New System.Windows.Forms.PictureBox
                Me.txtRecipient = New System.Windows.Forms.TextBox
                Me.Label2 = New System.Windows.Forms.Label
                Me.txtMessage = New System.Windows.Forms.TextBox
                Me.SuspendLayout()
                '
                'mPaneCaption
                '
                Me.mPaneCaption.Name = "mPaneCaption"
                Me.mPaneCaption.Size = New System.Drawing.Size(622, 26)
                '
                'btnOK
                '
                Me.btnOK.Anchor = System.Windows.Forms.AnchorStyles.Bottom
                Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
                Me.btnOK.Location = New System.Drawing.Point(384, 288)
                Me.btnOK.Name = "btnOK"
                Me.btnOK.TabIndex = 3
                Me.btnOK.Text = "OK"
                '
                'btnCancel
                '
                Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
                Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
                Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
                Me.btnCancel.Location = New System.Drawing.Point(480, 288)
                Me.btnCancel.Name = "btnCancel"
                Me.btnCancel.TabIndex = 4
                Me.btnCancel.Text = "Cancel"
                '
                'Label1
                '
                Me.Label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.Label1.Location = New System.Drawing.Point(24, 48)
                Me.Label1.Name = "Label1"
                Me.Label1.Size = New System.Drawing.Size(56, 16)
                Me.Label1.TabIndex = 29
                Me.Label1.Text = "Recipient:"
                Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
                Me.Label1.TabStop = False
                '
                'imgScreen
                '
                Me.imgScreen.Location = New System.Drawing.Point(352, 56)
                Me.imgScreen.Name = "imgScreen"
                Me.imgScreen.Size = New System.Drawing.Size(256, 200)
                Me.imgScreen.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
                Me.imgScreen.TabIndex = 3
                Me.imgScreen.TabStop = False
                '
                'txtRecipient
                '
                Me.txtRecipient.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.txtRecipient.Location = New System.Drawing.Point(88, 48)
                Me.txtRecipient.Name = "txtRecipient"
                Me.txtRecipient.Size = New System.Drawing.Size(248, 21)
                Me.txtRecipient.TabIndex = 1
                Me.txtRecipient.Text = "HelpDesk@NationalResearch.com"
                '
                'Label2
                '
                Me.Label2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.Label2.Location = New System.Drawing.Point(24, 96)
                Me.Label2.Name = "Label2"
                Me.Label2.Size = New System.Drawing.Size(312, 56)
                Me.Label2.TabIndex = 199
                Me.Label2.Text = "Please provide a detailed description of how the error occurred, including instru" & _
                "ctions for recreating the error."
                Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
                Me.Label2.TabStop = False
                '
                'txtMessage
                '
                Me.txtMessage.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
                Me.txtMessage.Location = New System.Drawing.Point(24, 160)
                Me.txtMessage.Multiline = True
                Me.txtMessage.Name = "txtMessage"
                Me.txtMessage.Size = New System.Drawing.Size(312, 144)
                Me.txtMessage.TabIndex = 2
                Me.txtMessage.Text = ""
                '
                'ReportUI
                '
                Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
                Me.CancelButton = Me.btnCancel
                Me.ClientSize = New System.Drawing.Size(624, 328)
                Me.Controls.Add(Me.txtRecipient)
                Me.Controls.Add(Me.imgScreen)
                Me.Controls.Add(Me.Label1)
                Me.Controls.Add(Me.btnOK)
                Me.Controls.Add(Me.btnCancel)
                Me.Controls.Add(Me.Label2)
                Me.Controls.Add(Me.txtMessage)
                Me.DockPadding.All = 1
                Me.Name = "ReportUI"
                Me.Text = "ReportUI"
                Me.StartPosition = FormStartPosition.CenterScreen
                Me.Controls.SetChildIndex(Me.txtMessage, 0)
                Me.Controls.SetChildIndex(Me.Label2, 0)
                Me.Controls.SetChildIndex(Me.btnCancel, 0)
                Me.Controls.SetChildIndex(Me.btnOK, 0)
                Me.Controls.SetChildIndex(Me.Label1, 0)
                Me.Controls.SetChildIndex(Me.imgScreen, 0)
                Me.Controls.SetChildIndex(Me.txtRecipient, 0)
                Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
                Me.ResumeLayout(False)

            End Sub

#End Region

            Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
                If txtRecipient.Text.Trim.Length = 0 Then
                    MessageBox.Show("You must enter a recipient!", "Exception Report Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Exit Sub
                End If
                mReport.ReportRecipient = txtRecipient.Text
                mReport.UserMessage = txtMessage.Text
                Me.DialogResult = Windows.Forms.DialogResult.OK
            End Sub

            Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
                Me.DialogResult = Windows.Forms.DialogResult.Cancel
            End Sub

            Private Sub ReportUI_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
                Me.Caption = mTitle
                Me.imgScreen.Image = mScreenShot
            End Sub

            Private Sub txtRecipient_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles txtRecipient.Validating
                Dim input As String = txtRecipient.Text.Replace(",", ";")
                Dim emails() As String = input.Split(Char.Parse(";"))
                Dim email As String
                Dim start As Integer

                If input.Length = 0 Then Exit Sub

                txtRecipient.Text = ""

                For Each email In emails
                    email = email.Trim
                    If email.IndexOf(Char.Parse("@")) < 1 Then
                        start = email.IndexOf(Char.Parse(" "))
                        If start > -1 Then
                            email = email.Remove(1, start)
                        End If

                        email &= "@NationalResearch.com"
                    End If

                    txtRecipient.Text &= email & "; "
                Next

                If txtRecipient.Text.Length > 0 Then
                    txtRecipient.Text = txtRecipient.Text.Substring(0, txtRecipient.Text.Length - 2)
                End If
            End Sub

            Private Sub txtRecipient_Validated(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtRecipient.Validated

            End Sub
        End Class

#End Region

    End Class

End Namespace