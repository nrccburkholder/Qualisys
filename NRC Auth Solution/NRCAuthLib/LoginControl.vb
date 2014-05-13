Imports System.ComponentModel
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Drawing.Design

<ToolboxData("<{0}:LoginControl runat=server></{0}:LoginControl>")> _
Public Class LoginControl
    Inherits System.Web.UI.WebControls.WebControl
    Implements INamingContainer

    Public Enum ButtonTypeEnum
        Button = 0
        'HyperLink = 1
        Image = 2
    End Enum

    Public Enum ButtonPositionEnum
        Below = 0
        Right = 1
    End Enum

#Region " Private Members "
    Dim mTitleText As String = "Log In"
    Dim mTitleTextStyle As New WebControls.Style

    Dim mLockedText As String = "Account has been locked!  Contact your administrator or use the password recovery option."
    Dim mInvalidAddressText As String = "You are connecting from an invalid IP address."
    Dim mFailureText As String = "Your login attempt was not successful. Please try again."
    Dim mFailureTextStyle As New WebControls.Style

    Dim mInstructionText As String = "Please Sign In..."
    Dim mInstructionTextStyle As New WebControls.Style

    Dim mUserNameLabelText As String = "User:"
    Dim mPasswordLabelText As String = "Password:"
    Dim mLabelStyle As New WebControls.Style

    Dim mPasswordRecoveryText As String = "I forgot my password..."
    Dim mPasswordRecoveryUrl As String
    Dim mPasswordRecoveryIconUrl As String

    Dim mLoginHelpText As String = "Need help?"
    Dim mLoginHelpUrl As String
    Dim mLoginHelpIconUrl As String

    Dim mSubmitButtonImageUrl As String
    Dim mSubmitButtonText As String = "Log In"
    Dim mSubmitButtonType As ButtonTypeEnum = ButtonTypeEnum.Button
    Dim mSubmitButtonPosition As ButtonPositionEnum = ButtonPositionEnum.Below
    Dim mSubmitButtonStyle As New WebControls.Style

    Dim mDestinationPageUrl As String
    Dim mNotificationPageUrl As String

    Dim mCreateUserText As String = "New user..."
    Dim mCreateUserUrl As String

    Dim mHyperLinkStyle As New WebControls.Style
    Dim mTextBoxStyle As New WebControls.Style

    Dim mPasswordRequiredErrorMessage As String = "Password is required."
    Dim mUserNameRequiredErrorMessage As String = "User Name is required."

    Dim mApplicationName As String
#End Region

#Region " Public Properties "
    <Bindable(True), Category("Appearance"), DefaultValue("Log In")> _
    Public Overridable Property TitleText() As String
        Get
            Return mTitleText
        End Get

        Set(ByVal Value As String)
            mTitleText = Value
        End Set
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public Overridable ReadOnly Property TitleTextStyle() As WebControls.Style
        Get
            Return Me.mTitleTextStyle
        End Get
    End Property
    <Bindable(True), Category("Appearance")> _
    Public Property InvalidAddressText() As String
        Get
            Return Me.mInvalidAddressText
        End Get
        Set(ByVal Value As String)
            Me.mInvalidAddressText = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance")> _
    Public Property LockedText() As String
        Get
            Return Me.mLockedText
        End Get
        Set(ByVal Value As String)
            Me.mLockedText = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue("Your login attempt was not successful. Please try again.")> _
    Public Property FailureText() As String
        Get
            Return Me.mFailureText
        End Get
        Set(ByVal Value As String)
            Me.mFailureText = Value
        End Set
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public ReadOnly Property FailureTextStyle() As WebControls.Style
        Get
            Return Me.mFailureTextStyle
        End Get
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue("Please Sign In...")> _
    Public Property InstructionText() As String
        Get
            Return Me.mInstructionText
        End Get
        Set(ByVal Value As String)
            Me.mInstructionText = Value
        End Set
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public ReadOnly Property InstructionTextStyle() As WebControls.Style
        Get
            Return Me.mInstructionTextStyle
        End Get
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue("User:")> _
    Public Property UserNameLabelText() As String
        Get
            Return Me.mUserNameLabelText
        End Get
        Set(ByVal Value As String)
            Me.mUserNameLabelText = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue("Password:")> _
    Public Property PasswordLabelText() As String
        Get
            Return Me.mPasswordLabelText
        End Get
        Set(ByVal Value As String)
            Me.mPasswordLabelText = Value
        End Set
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public ReadOnly Property LabelStyle() As WebControls.Style
        Get
            Return Me.mLabelStyle
        End Get
    End Property
    <Bindable(True), Category("Links"), DefaultValue("I forgot my password...")> _
    Public Property PasswordRecoveryText() As String
        Get
            Return Me.mPasswordRecoveryText
        End Get
        Set(ByVal Value As String)
            Me.mPasswordRecoveryText = Value
        End Set
    End Property
    <Bindable(True), Category("Links"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property PasswordRecoveryUrl() As String
        Get
            Return Me.mPasswordRecoveryUrl
        End Get
        Set(ByVal Value As String)
            Me.mPasswordRecoveryUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property PasswordRecoveryIconUrl() As String
        Get
            Return Me.mPasswordRecoveryIconUrl
        End Get
        Set(ByVal Value As String)
            Me.mPasswordRecoveryIconUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Links"), DefaultValue("Need help?")> _
    Public Property LoginHelpText() As String
        Get
            Return Me.mLoginHelpText
        End Get
        Set(ByVal Value As String)
            Me.mLoginHelpText = Value
        End Set
    End Property
    <Bindable(True), Category("Links"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property LoginHelpUrl() As String
        Get
            Return Me.mLoginHelpUrl
        End Get
        Set(ByVal Value As String)
            Me.mLoginHelpUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property LoginHelpIconUrl() As String
        Get
            Return Me.mLoginHelpIconUrl
        End Get
        Set(ByVal Value As String)
            Me.mLoginHelpIconUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property SubmitButtonImageUrl() As String
        Get
            Return Me.mSubmitButtonImageUrl
        End Get
        Set(ByVal Value As String)
            Me.mSubmitButtonImageUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue("Log In")> _
    Public Property SubmitButtonText() As String
        Get
            Return Me.mSubmitButtonText
        End Get
        Set(ByVal Value As String)
            Me.mSubmitButtonText = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue(ButtonTypeEnum.Button)> _
    Public Property SubmitButtonType() As ButtonTypeEnum
        Get
            Return Me.mSubmitButtonType
        End Get
        Set(ByVal Value As ButtonTypeEnum)
            Me.mSubmitButtonType = Value
        End Set
    End Property
    <Bindable(True), Category("Appearance"), DefaultValue(ButtonPositionEnum.Below)> _
  Public Property SubmitButtonPosition() As ButtonPositionEnum
        Get
            Return Me.mSubmitButtonPosition
        End Get
        Set(ByVal Value As ButtonPositionEnum)
            Me.mSubmitButtonPosition = Value
        End Set
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public ReadOnly Property SubmitButtonStyle() As WebControls.Style
        Get
            Return Me.mSubmitButtonStyle
        End Get
    End Property
    <Bindable(True), Category("Behavior"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property DestinationPageUrl() As String
        Get
            Return Me.mDestinationPageUrl
        End Get
        Set(ByVal Value As String)
            Me.mDestinationPageUrl = Value
        End Set
    End Property
    '<Bindable(True), Category("Behavior"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    'Public Property DestinationPageUrl() As String
    '    Get
    '        Dim msg As Object = Me.ViewState.Item("DestinationPageUrl")
    '        If Not msg Is Nothing Then
    '            Return CType(msg, String)
    '        End If
    '        Return ""
    '    End Get
    '    Set(ByVal Value As String)
    '        Me.ViewState.Item("DestinationPageUrl") = Value
    '    End Set
    'End Property
    <Bindable(True), Category("Behavior"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property NotificationPageUrl() As String
        Get
            Return Me.mNotificationPageUrl
        End Get
        Set(ByVal Value As String)
            Me.mNotificationPageUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Links"), DefaultValue("New user...")> _
    Public Property CreateUserText() As String
        Get
            Return Me.mCreateUserText
        End Get
        Set(ByVal Value As String)
            Me.mCreateUserText = Value
        End Set
    End Property
    <Bindable(True), Category("Links"), DefaultValue(""), Editor("System.Web.UI.Design.ImageUrlEditor, System.Design", GetType(UITypeEditor))> _
    Public Property CreateUserUrl() As String
        Get
            Return Me.mCreateUserUrl
        End Get
        Set(ByVal Value As String)
            Me.mCreateUserUrl = Value
        End Set
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public ReadOnly Property HyperLinkStyle() As WebControls.Style
        Get
            Return Me.mHyperLinkStyle
        End Get
    End Property
    <Bindable(True), Category("Styles"), PersistenceMode(PersistenceMode.InnerProperty)> _
    Public ReadOnly Property TextBoxStyle() As WebControls.Style
        Get
            Return Me.mTextBoxStyle
        End Get
    End Property
    <Bindable(True), Category("Validation"), DefaultValue("Password is required.")> _
    Public Property PasswordRequiredErrorMessage() As String
        Get
            Return Me.mPasswordRequiredErrorMessage
        End Get
        Set(ByVal Value As String)
            Me.mPasswordRequiredErrorMessage = Value
        End Set
    End Property
    <Bindable(True), Category("Validation"), DefaultValue("User Name is required.")> _
    Property UserNameRequiredErrorMessage() As String
        Get
            Return Me.mUserNameRequiredErrorMessage
        End Get
        Set(ByVal Value As String)
            Me.mUserNameRequiredErrorMessage = Value
        End Set
    End Property

    <Bindable(True), Category("Behavior"), DefaultValue("Log In")> _
    Public Overridable Property ApplicationName() As String
        Get
            Return mApplicationName
        End Get

        Set(ByVal Value As String)
            mApplicationName = Value
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private Property IsMessageDisplayed() As Boolean
        Get
            Dim isDisplayed As Object = Me.ViewState.Item("IsMessageDisplayed")
            If Not isDisplayed Is Nothing Then
                Return CType(isDisplayed, Boolean)
            End If
            Return False
        End Get
        Set(ByVal Value As Boolean)
            Me.ViewState.Item("IsMessageDisplayed") = Value
            If Not lblMessage Is Nothing Then
                Me.lblMessage.Visible = Value
            End If
        End Set
    End Property
    Private Property MessageDisplayed() As String
        Get
            Dim msg As Object = Me.ViewState.Item("MessageDisplayed")
            If Not msg Is Nothing Then
                Return CType(msg, String)
            End If
            Return ""
        End Get
        Set(ByVal Value As String)
            Me.ViewState.Item("MessageDisplayed") = Value
            If Not lblMessage Is Nothing Then
                Me.lblMessage.Text = Value
            End If
        End Set
    End Property

#End Region

#Region " Overriding Properties "
    Protected Overrides ReadOnly Property TagKey() As HtmlTextWriterTag
        Get
            Return HtmlTextWriterTag.Div
        End Get
    End Property
#End Region

    'Child controls
    Private tblLogin As WebControls.Table
    Private lblTitle As WebControls.Label
    Private lblInstructions As WebControls.Label
    Private lblUserName As WebControls.Label
    Private txtUserName As WebControls.TextBox
    Private vldUserName As WebControls.RequiredFieldValidator
    Private lblPassword As WebControls.Label
    Private txtPassword As WebControls.TextBox
    Private vldPassword As WebControls.RequiredFieldValidator
    Private ctrlButton As Control
    Private btnSubmit As WebControls.Button
    Private btnImageSubmit As WebControls.ImageButton
    Private lnkCreateAccount As WebControls.HyperLink
    'Private lnkLoginHelp As WebControls.HyperLink
    Private lnkRecoverImage As WebControls.HyperLink
    Private lnkRecoverPassword As WebControls.HyperLink
    Private lblMessage As WebControls.Label


    Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)
        Me.EnsureChildControls()

        If System.Web.HttpContext.Current Is Nothing Then
            MyBase.Render(writer)
        Else
            MyBase.Render(writer)
        End If
    End Sub

    Protected Overrides Sub CreateChildControls()
        'Build all of the child controls
        Me.InitializeChildControls()
        Me.LayoutChildControls()
    End Sub

    Private Sub InitializeChildControls()
        'Initialize al of the sub controls

        tblLogin = New WebControls.Table
        tblLogin.ID = "tblLogin"
        tblLogin.CellSpacing = 0
        tblLogin.Width = Unit.Percentage(100)

        lblTitle = New WebControls.Label
        lblTitle.ID = "lblTitle"
        lblTitle.Text = Me.mTitleText

        lblInstructions = New WebControls.Label
        lblInstructions.ID = "lblInstructions"
        lblInstructions.Text = Me.mInstructionText

        lblMessage = New WebControls.Label
        lblMessage.ID = "lblMessage"
        lblMessage.Text = Me.MessageDisplayed
        lblMessage.Visible = Me.IsMessageDisplayed

        lblUserName = New WebControls.Label
        lblUserName.ID = "lblUserName"
        lblUserName.ControlStyle.CopyFrom(Me.mLabelStyle)
        lblUserName.Text = Me.mUserNameLabelText

        txtUserName = New WebControls.TextBox
        txtUserName.ID = "txtUserName"
        txtUserName.ControlStyle.CopyFrom(Me.mTextBoxStyle)

        vldUserName = New WebControls.RequiredFieldValidator
        vldUserName.ID = "vldUserName"
        vldUserName.ControlToValidate = txtUserName.ClientID
        vldUserName.Display = WebControls.ValidatorDisplay.Dynamic
        vldUserName.ErrorMessage = "*"
        vldUserName.ToolTip = Me.mUserNameRequiredErrorMessage
        vldUserName.EnableClientScript = True
        vldUserName.ControlStyle.CopyFrom(Me.mLabelStyle)
        vldUserName.ForeColor = System.Drawing.Color.Red
        vldUserName.Style.Add("cursor", "default")

        lblPassword = New WebControls.Label
        lblPassword.ID = "lblPassword"
        lblPassword.ControlStyle.CopyFrom(Me.mLabelStyle)
        lblPassword.Text = Me.mPasswordLabelText

        txtPassword = New WebControls.TextBox
        txtPassword.ID = "txtPassword"
        txtPassword.TextMode = WebControls.TextBoxMode.Password
        txtPassword.ControlStyle.CopyFrom(Me.mTextBoxStyle)

        vldPassword = New WebControls.RequiredFieldValidator
        vldPassword.ID = "vldPassword"
        vldPassword.ControlToValidate = txtPassword.ClientID
        vldPassword.Display = WebControls.ValidatorDisplay.Dynamic
        vldPassword.ErrorMessage = "*"
        vldPassword.ToolTip = Me.mPasswordRequiredErrorMessage
        vldPassword.EnableClientScript = True
        vldPassword.ControlStyle.CopyFrom(Me.mLabelStyle)
        vldPassword.ForeColor = System.Drawing.Color.Red
        vldPassword.Style.Add("cursor", "default")

        If Me.mSubmitButtonType = ButtonTypeEnum.Button Then
            btnSubmit = New WebControls.Button
            btnSubmit.ControlStyle.CopyFrom(Me.mSubmitButtonStyle)
            btnSubmit.Text = Me.mSubmitButtonText
            AddHandler btnSubmit.Click, AddressOf btnSubmit_Click
            ctrlButton = btnSubmit
        ElseIf Me.mSubmitButtonType = ButtonTypeEnum.Image Then
            btnImageSubmit = New WebControls.ImageButton
            btnImageSubmit.ImageUrl = mSubmitButtonImageUrl
            'btnImageSubmit.ControlStyle.CopyFrom(Me.mSubmitButtonStyle)
            'btnImageSubmit.Text = Me.mSubmitButtonText
            AddHandler btnImageSubmit.Click, AddressOf btnImageSubmit_Click
            ctrlButton = btnImageSubmit
        End If

        lnkCreateAccount = New WebControls.HyperLink
        lnkCreateAccount.ID = "lnkCreateAccount"
        lnkCreateAccount.Text = Me.mCreateUserText
        If Not Me.mCreateUserUrl = "" Then
            lnkCreateAccount.NavigateUrl = Me.ResolveUrl(Me.mCreateUserUrl)
        End If
        lnkCreateAccount.ControlStyle.CopyFrom(Me.mHyperLinkStyle)



        'lnkLoginHelp = New WebControls.HyperLink
        'lnkLoginHelp.ID = "lnkLoginHelp"
        'lnkLoginHelp.Text = Me.mLoginHelpText
        'If Not Me.mLoginHelpUrl = "" Then
        '    lnkLoginHelp.NavigateUrl = Me.ResolveUrl(Me.mLoginHelpUrl)
        'End If
        'lnkLoginHelp.ControlStyle.CopyFrom(Me.mHyperLinkStyle)

        Dim RecoverPwdURL As String = Me.ResolveUrl(Me.mPasswordRecoveryUrl) + "?PreviousPage=" + System.Web.HttpContext.Current.Request.Url.AbsolutePath

        lnkRecoverImage = New WebControls.HyperLink
        lnkRecoverImage.ID = "lnkRecoverImage"

        'TODO: don't hardcode this image
        lnkRecoverImage.ImageUrl = ResolveUrl("img/qMark.gif")

        'Dim ResxReader As System.Resources.ResourceReader = New Resources.ResourceReader("images.resx")
        'Dim ResxEnumerator As IDictionaryEnumerator = ResxReader.GetEnumerator()
        'ResxEnumerator.MoveNext()
        'lnkRecoverImage = 

        If Not Me.mPasswordRecoveryUrl = "" Then
            lnkRecoverImage.NavigateUrl = RecoverPwdURL
        End If
        lnkRecoverImage.ControlStyle.CopyFrom(Me.mHyperLinkStyle)


        lnkRecoverPassword = New WebControls.HyperLink
        lnkRecoverPassword.ID = "lnkRecoverPassword"
        lnkRecoverPassword.Text = " " + Me.mPasswordRecoveryText
        If Not Me.mPasswordRecoveryUrl = "" Then
            lnkRecoverPassword.NavigateUrl = RecoverPwdURL
        End If
        lnkRecoverPassword.ControlStyle.CopyFrom(Me.mHyperLinkStyle)
        'SK 08/29/2008 Update lnkRecoverPassword font size per Ted S.
        lnkRecoverPassword.Font.Size = FontUnit.Point(10)
    End Sub

    Private Sub LayoutChildControls()
        'Layout all of the controls
        Dim tr As WebControls.TableRow
        Dim td As WebControls.TableCell

        Me.Controls.Clear()

        'Add the title
        tr = New WebControls.TableRow
        td = New WebControls.TableCell
        If mSubmitButtonPosition = ButtonPositionEnum.Below Then
            td.ColumnSpan = 2
        Else
            td.ColumnSpan = 3
        End If
        td.ControlStyle.CopyFrom(Me.mTitleTextStyle)
        td.HorizontalAlign = HorizontalAlign.Center
        td.Controls.Add(lblTitle)
        tr.Cells.Add(td)
        tblLogin.Rows.Add(tr)

        'Add the instructions
        If Not Me.mInstructionText.Trim = "" Then
            tr = New WebControls.TableRow
            td = New WebControls.TableCell
            If mSubmitButtonPosition = ButtonPositionEnum.Below Then
                td.ColumnSpan = 2
            Else
                td.ColumnSpan = 3
            End If
            td.ControlStyle.CopyFrom(Me.mInstructionTextStyle)
            td.HorizontalAlign = HorizontalAlign.Center
            td.Controls.Add(lblInstructions)
            tr.Cells.Add(td)
            tblLogin.Rows.Add(tr)
        End If

        'Add the message
        tr = New WebControls.TableRow
        td = New WebControls.TableCell
        If mSubmitButtonPosition = ButtonPositionEnum.Below Then
            td.ColumnSpan = 2
        Else
            td.ColumnSpan = 3
        End If
        td.ControlStyle.CopyFrom(Me.mFailureTextStyle)
        td.HorizontalAlign = HorizontalAlign.Center
        td.Controls.Add(lblMessage)
        tr.Cells.Add(td)
        tblLogin.Rows.Add(tr)

        'Add the username label and textbox
        tr = New WebControls.TableRow
        td = New WebControls.TableCell
        td.HorizontalAlign = HorizontalAlign.Right
        td.Controls.Add(lblUserName)
        tr.Cells.Add(td)
        td = New WebControls.TableCell
        td.Controls.Add(txtUserName)
        td.Controls.Add(vldUserName)
        tr.Cells.Add(td)
        tblLogin.Rows.Add(tr)

        'Add the password label and textbox
        tr = New WebControls.TableRow
        td = New WebControls.TableCell
        td.HorizontalAlign = HorizontalAlign.Right
        td.Controls.Add(lblPassword)
        tr.Cells.Add(td)
        td = New WebControls.TableCell
        td.Controls.Add(txtPassword)
        td.Controls.Add(vldPassword)
        tr.Cells.Add(td)

        If mSubmitButtonPosition = ButtonPositionEnum.Right Then
            'Add the submit button
            td = New WebControls.TableCell
            td.Controls.Add(ctrlButton)
            tr.Cells.Add(td)
        End If
        tblLogin.Rows.Add(tr)

        If mSubmitButtonPosition = ButtonPositionEnum.Below Then
            'Add the submit button
            tr = New WebControls.TableRow
            td = New WebControls.TableCell
            td.ColumnSpan = 2
            td.HorizontalAlign = WebControls.HorizontalAlign.Right
            td.Controls.Add(ctrlButton)
            tr.Cells.Add(td)
            tblLogin.Rows.Add(tr)
        End If

        'If there is a new user link add it
        If Not Me.mCreateUserText.Trim = "" Then
            tr = New WebControls.TableRow
            td = New WebControls.TableCell
            If mSubmitButtonPosition = ButtonPositionEnum.Below Then
                td.ColumnSpan = 2
            Else
                td.ColumnSpan = 3
            End If
            td.Controls.Add(lnkCreateAccount)
            tr.Cells.Add(td)
            tblLogin.Rows.Add(tr)
        End If

        'If there is a password recovery link then add it
        Dim showRecover As Boolean = (Not Me.mPasswordRecoveryText.Trim = "")
        Dim showHelp As Boolean = (Not Me.mLoginHelpText.Trim = "")
        If showRecover OrElse showHelp Then
            tr = New WebControls.TableRow
            td = New WebControls.TableCell

            If mSubmitButtonPosition = ButtonPositionEnum.Below Then
                td.ColumnSpan = 2
            Else
                td.ColumnSpan = 3
            End If

            Dim spn As New HtmlControls.HtmlGenericControl("DIV")
            If showRecover Then               
                spn.Style.Add("float", "left")
                spn.Controls.Add(lnkRecoverImage)
                spn.Controls.Add(lnkRecoverPassword)
                td.Controls.Add(spn)
            End If

            'If showHelp Then
            '    spn = New HtmlControls.HtmlGenericControl("DIV")
            '    spn.Style.Add("float", "right")
            '    spn.Controls.Add(lnkLoginHelp)
            '    td.Controls.Add(spn)
            'End If
            tr.Cells.Add(td)

            tblLogin.Rows.Add(tr)
        End If



        'Add the table to the controls collection
        Me.Controls.Add(tblLogin)
    End Sub

    Private Sub btnImageSubmit_Click(ByVal sender As Object, ByVal e As ImageClickEventArgs)
        SubmitClicked()
    End Sub
    Private Sub btnSubmit_Click(ByVal sender As Object, ByVal e As EventArgs)
        SubmitClicked()
    End Sub

    Private Sub SubmitClicked()
        'Validate controls
        If Not Me.Page.IsValid Then
            Exit Sub
        End If

        'SK 08/29/2008 Keep Track Of How Many Times The Visitor Has Tried To Login
        If context.Session("LoginTriesCount") Is Nothing Then
            context.Session("LoginTriesCount") = 1
        Else
            context.Session("LoginTriesCount") = CType(context.Session("LoginTriesCount"), Integer) + 1
        End If


        Dim user As Member
        'Try to authenticate the user and display the appropriate error message on failure
        Select Case FormsAuth.SignIn(txtUserName.Text, txtPassword.Text, mApplicationName, user)
            Case FormsAuth.AuthResult.InvalidUserOrPassword
                Me.IsMessageDisplayed = True
                Me.MessageDisplayed = mFailureText
                'SK 08/29/2008 if user tries to login 3x and not succeeding, then take them to reset page per Ted S.
                If CType(context.Session("LoginTriesCount"), Integer) >= 3 Then
                    context.Session("LoginTriesCount") = Nothing
                    context.Response.Redirect(PasswordRecoveryUrl & "?msg=It appears that you may be having trouble. Please enter your e-mail address, and your logon information will be sent to you.")
                End If
            Case FormsAuth.AuthResult.InvalidIPAddress
                Me.IsMessageDisplayed = True
                Me.MessageDisplayed = mInvalidAddressText
            Case FormsAuth.AuthResult.UnauthorizedRequest
                Me.IsMessageDisplayed = True
                Me.MessageDisplayed = String.Format("Access to {0} denied!", mApplicationName)
            Case FormsAuth.AuthResult.AccountLocked
                Me.IsMessageDisplayed = True
                Me.MessageDisplayed = mLockedText
                'SK 08/29/2008 Automatically redirect to password reset page per Ted S.
                context.Response.Redirect(PasswordRecoveryUrl & "?username=" & txtUserName.Text.Trim & "&msg=Your account has been locked. Please enter your email address to reset your password.")
            Case FormsAuth.AuthResult.Success
                'Sign in was successful!!!!
                Me.IsMessageDisplayed = False
                Me.MessageDisplayed = ""

                'Get a destination Url and resolve it
                If mDestinationPageUrl Is Nothing OrElse mDestinationPageUrl.Trim = "" Then
                    If Not HttpContext.Current.Request.QueryString("ReturnURL") Is Nothing Then
                        mDestinationPageUrl = HttpContext.Current.Request.QueryString("ReturnURL")
                    Else
                        mDestinationPageUrl = HttpContext.Current.Request.Url.ToString
                    End If
                End If
                mDestinationPageUrl = Me.ResolveUrl(mDestinationPageUrl)
                mNotificationPageUrl = Me.ResolveUrl(mNotificationPageUrl)

                'If there is a notification page then grant temp ticket and redirect
                If Not Me.mNotificationPageUrl.Trim = "" Then
                    FormsAuth.SetTemporaryTicket(user, Me.mDestinationPageUrl)
                    HttpContext.Current.Response.Redirect(Me.mNotificationPageUrl)
                ElseIf Not Me.mDestinationPageUrl.Trim = "" Then
                    'If there is a destination url then grant the auth ticket and redirect
                    FormsAuth.SetAuthCookie(user)
                    HttpContext.Current.Response.Redirect(Me.mDestinationPageUrl)
                Else
                    'Just grant the auth ticket
                    FormsAuth.SetAuthCookie(user)
                End If
        End Select

        Me.txtUserName.Text = ""
    End Sub

    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        Dim ticket As System.Web.Security.FormsAuthenticationTicket
        'Check to see if there has been a previous session that expired
        If FormsAuth.IsExpiredSession(ticket) Then
            'Log the session expiration and renewal
            If Not Page.IsPostBack AndAlso Not ticket Is Nothing Then
                Dim user As Member = Member.GetMember(ticket.Name)
                SecurityLog.LogWebEvent(user.UserName, HttpContext.Current.Session.SessionID, mApplicationName, FormsAuth.PageName, "Requesting Expired Session", HttpContext.Current.Request.QueryString.ToString)
            End If

            'Show the user a message that indicates why they are back at the sign in screen.
            Me.MessageDisplayed = "Your session has expired please sign in again."
            Me.IsMessageDisplayed = True
        End If
    End Sub

End Class
