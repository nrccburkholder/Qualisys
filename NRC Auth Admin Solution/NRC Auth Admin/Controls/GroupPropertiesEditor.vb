Imports Nrc.NRCAuthLib

Public Class GroupPropertiesEditor

#Region " Private Members "
    Private mOrgUnit As OrgUnit
    Private mGroup As Group
    Private mAllowSave As Boolean
#End Region

#Region " Public Events "
    Public Event AllowSaveChanged As EventHandler
#End Region

#Region " Public Properties "
    Public Property AllowSave() As Boolean
        Get
            Return mAllowSave
        End Get
        Private Set(ByVal value As Boolean)
            If mAllowSave <> value Then
                mAllowSave = value
                RaiseEvent AllowSaveChanged(Me, EventArgs.Empty)
            End If
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private ReadOnly Property IsNewGroup() As Boolean
        Get
            Return (mGroup Is Nothing)
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New(ByVal org As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mOrgUnit = org
        Me.Init()
    End Sub

    Public Sub New(ByVal org As OrgUnit, ByVal grp As Group)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mOrgUnit = org
        mGroup = grp
        Me.Init()
    End Sub
#End Region

#Region " Public Methods "

    Public Sub SaveProperties()
        If Me.IsNewGroup Then
            Me.CreateGroup()
        Else
            Me.SaveChanges()
        End If
    End Sub

#End Region

#Region " Control Event Handlers "
    Private Sub GroupName_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles GroupName.Validating
        Me.ValidateForm()
    End Sub

    Private Sub GroupEmail_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles GroupEmail.Validating
        Me.ValidateForm()
    End Sub

#End Region

#Region " Private Methods "
    Private Sub Init()

        If Not Me.IsNewGroup Then
            Me.PopulateForm()
        End If

        Me.ValidateForm()
    End Sub

    Private Sub PopulateForm()
        Me.GroupName.Text = mGroup.Name
        Me.GroupDescription.Text = mGroup.Description
        Me.GroupEmail.Text = mGroup.Email
    End Sub

    Private Sub SaveChanges()
        mGroup.Name = Me.GroupName.Text
        mGroup.Description = Me.GroupDescription.Text
        mGroup.Email = Me.GroupEmail.Text
        mGroup.UpdateGroup(CurrentUser.Member.MemberId)
    End Sub

    Private Sub CreateGroup()
        Dim newGroup As Group = Group.CreateNewGroup(mOrgUnit.OrgUnitId, GroupName.Text, GroupDescription.Text, GroupEmail.Text, CurrentUser.Member.MemberId)
        mOrgUnit.Groups.Add(newGroup)
    End Sub

    Private Function ValidateGroupName(ByRef errorMessage As String) As Boolean
        If Me.GroupName.Text.Trim.Length = 0 Then
            errorMessage = "You must enter a group name."
            Return False
        End If

        For Each grp As Group In Me.mOrgUnit.Groups
            If grp.Name.ToLower = Me.GroupName.Text.Trim.ToLower Then
                If Me.mGroup Is Nothing OrElse Me.mGroup.GroupId <> grp.GroupId Then
                    errorMessage = "The group name specified is already in use for this OrgUnit."
                    Return False
                End If
            End If
        Next

        Return True
    End Function

    Private Function ValidateGroupEmail(ByRef errorMessage As String) As Boolean
        Dim pattern As String = "^([0-9a-zA-Z]+['-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$"
        If Me.GroupEmail.Text.Trim.Length > 0 AndAlso Not System.Text.RegularExpressions.Regex.IsMatch(Me.GroupEmail.Text, pattern) Then
            errorMessage = "The email address is not valid."
            Return False
        End If

        Return True
    End Function

    Private Function ValidateForm() As Boolean
        Dim err As String = ""
        Dim isValid As Boolean = True

        If ValidateGroupName(err) Then
            Me.ErrorProvider.SetError(Me.GroupName, "")
        Else
            Me.ErrorProvider.SetError(Me.GroupName, err)
            isValid = False
        End If

        If ValidateGroupEmail(err) Then
            Me.ErrorProvider.SetError(Me.GroupEmail, "")
        Else
            Me.ErrorProvider.SetError(Me.GroupEmail, err)
            isValid = False
        End If

        Me.AllowSave = isValid

        Return isValid
    End Function


#End Region

End Class
