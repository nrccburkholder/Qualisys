Imports Nrc.NRCAuthLib

Public Class OrgUnitPropertiesEditor

#Region " ListItem Class "
    Private Class ListItem(Of T)
        Private mLabel As String
        Private mValue As T

        Public ReadOnly Property Label() As String
            Get
                Return mLabel
            End Get
        End Property

        Public ReadOnly Property Value() As T
            Get
                Return mValue
            End Get
        End Property

        Public Sub New(ByVal lbl As String, ByVal val As T)
            Me.mLabel = lbl
            Me.mValue = val
        End Sub

    End Class
#End Region

#Region " Private Members "
    Private mParentOrgUnit As OrgUnit
    Private mOrgUnit As OrgUnit
    Private mAllowSave As Boolean
#End Region

#Region " Public Events "
    Public Event AllowSaveChanged As EventHandler
    Protected Overridable Sub OnAllowSaveChanged(ByVal e As EventArgs)
        RaiseEvent AllowSaveChanged(Me, e)
    End Sub
#End Region

#Region " Public Properties "
    Public Property AllowSave() As Boolean
        Get
            Return mAllowSave
        End Get
        Private Set(ByVal value As Boolean)
            If mAllowSave <> value Then
                mAllowSave = value
                OnAllowSaveChanged(EventArgs.Empty)
            End If
        End Set
    End Property

    Public ReadOnly Property OrgUnit() As OrgUnit
        Get
            Return mOrgUnit
        End Get
    End Property
#End Region

#Region " Private Properties "
    Private ReadOnly Property IsNewOrgUnit() As Boolean
        Get
            Return (mOrgUnit Is Nothing)
        End Get
    End Property
    Private ReadOnly Property SelectedOrgUnitType() As OrgUnit.OrgUnitTypeEnum
        Get
            Return DirectCast(Me.UnitTypeList.SelectedValue, OrgUnit.OrgUnitTypeEnum)
        End Get
    End Property
    Private ReadOnly Property SelectedClient() As Client
        Get
            Return DirectCast(Me.ClientList.SelectedItem, Client)
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New(ByVal parentOrgUnit As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mParentOrgUnit = parentOrgUnit
        Me.Init()
    End Sub

    Public Sub New(ByVal parentOrgUnit As OrgUnit, ByVal org As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mParentOrgUnit = parentOrgUnit
        mOrgUnit = org
        Me.Init()
    End Sub
#End Region

#Region " Public Methods "

    Public Sub SaveProperties()
        If Me.IsNewOrgUnit Then
            Me.CreateOrgUnit()
        Else
            Me.SaveChanges()
        End If
    End Sub

#End Region

#Region " Private Methods "
    Private Sub Init()
        PopulateOUTypes()
        PopulateClientList()

        If Not Me.IsNewOrgUnit Then
            Me.PopulateForm()
            Me.UnitTypeList.Enabled = False
            Me.ClientList.Enabled = False
        Else
            Me.UnitTypeList.SelectedValue = OrgUnit.OrgUnitTypeEnum.ClientOu
        End If

        Me.ValidateForm()
    End Sub

    Private Sub PopulateOUTypes()
        Me.UnitTypeList.Items.Clear()
        Dim items As New List(Of ListItem(Of OrgUnit.OrgUnitTypeEnum))

        items.Add(New ListItem(Of OrgUnit.OrgUnitTypeEnum)("NRC Organization", OrgUnit.OrgUnitTypeEnum.NrcOU))
        items.Add(New ListItem(Of OrgUnit.OrgUnitTypeEnum)("CS Team", OrgUnit.OrgUnitTypeEnum.TeamOU))
        items.Add(New ListItem(Of OrgUnit.OrgUnitTypeEnum)("Client Organization", OrgUnit.OrgUnitTypeEnum.ClientOu))

        Me.UnitTypeList.DataSource = items
        Me.UnitTypeList.DisplayMember = "Label"
        Me.UnitTypeList.ValueMember = "Value"
    End Sub

    Private Sub PopulateClientList()
        ClientList.Items.Clear()
        ClientList.DataSource = ClientCollection.GetClients
        ClientList.DisplayMember = "DisplayLabel"
        ClientList.ValueMember = "Id"
    End Sub

    Private Sub PopulateForm()
        Me.OrgUnitName.Text = mOrgUnit.Name
        Me.Description.Text = mOrgUnit.Description
        Me.UnitTypeList.SelectedValue = mOrgUnit.OrgUnitType
        Me.ClientList.SelectedValue = mOrgUnit.QPClientId
    End Sub

    Private Sub SaveChanges()
        mOrgUnit.Name = Me.OrgUnitName.Text
        mOrgUnit.Description = Me.Description.Text
        mOrgUnit.UpdateOrgUnit(CurrentUser.Member.MemberId)
    End Sub

    Private Sub CreateOrgUnit()
        Dim orgType As OrgUnit.OrgUnitTypeEnum = Me.SelectedOrgUnitType
        Dim clientId As Integer = Me.SelectedClient.Id
        mOrgUnit = NRCAuthLib.OrgUnit.CreateNewOrgUnit(Me.OrgUnitName.Text, Me.Description.Text, orgType, mParentOrgUnit.OrgUnitId, clientId, CurrentUser.Member.MemberId)
        mParentOrgUnit.OrgUnits.Add(mOrgUnit)
    End Sub

    Private Function ValidateName(ByRef errorMessage As String) As Boolean
        If Me.OrgUnitName.Text.Trim.Length = 0 Then
            errorMessage = "You must enter a name."
            Return False
        End If

        Return True
    End Function

    Private Function ValidateOrgUnitType(ByRef errorMessage As String) As Boolean
        Select Case CurrentUser.Member.MemberType
            Case Member.MemberTypeEnum.NRC_Admin
                Return True
            Case Member.MemberTypeEnum.Administrator
                If Me.SelectedOrgUnitType = OrgUnit.OrgUnitTypeEnum.ClientOu Then
                    Return True
                End If
        End Select

        errorMessage = "Your security privileges do not allow you to create/modify this type of Organizational Unit"
        Return False
    End Function


    Private Function ValidateForm() As Boolean
        Dim err As String = ""
        Dim isValid As Boolean = True

        If ValidateName(err) Then
            Me.ErrorProvider.SetError(Me.OrgUnitName, "")
        Else
            Me.ErrorProvider.SetError(Me.OrgUnitName, err)
            isValid = False
        End If

        If ValidateOrgUnitType(err) Then
            Me.ErrorProvider.SetError(Me.UnitTypeList, "")
        Else
            Me.ErrorProvider.SetError(Me.UnitTypeList, err)
            isValid = False
        End If

        Me.AllowSave = isValid

        Return isValid
    End Function


#End Region

    Private Sub OrgUnitName_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles OrgUnitName.Validating
        Me.ValidateForm()
    End Sub

    Private Sub Description_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles Description.Validating
        Me.ValidateForm()
    End Sub

    Private Sub UnitTypeList_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles UnitTypeList.Validating
        Me.ValidateForm()
    End Sub

    Private Sub ClientList_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles ClientList.Validating
        Me.ValidateForm()
    End Sub
End Class
