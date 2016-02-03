Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportClientSelected
    Property ClientID() As Integer
End Interface

''' <summary></summary>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>2008-02-25 - Steve Kennedy</term>
''' <description>Renamed Class From SelectedExportClient to ExportClientSelected to
''' maintain naming consistancy.</description></listheader>
''' <item>
''' <term>2008-03-13 - Arman Mnatsakanyan</term>
''' <description>Moved the population of the Client extensions collection to the
''' provider class.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportClientSelected
    Inherits BusinessBase(Of ExportClientSelected)
    Implements IExportClientSelected

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mClientID As Integer
    Private mName As String = String.Empty
    Private mAddress1 As String = String.Empty
    Private mAddress2 As String = String.Empty
    Private mCity As String = String.Empty
    Private mState As String = String.Empty
    Private mPostalCode As String = String.Empty
    Private mTelephone As String = String.Empty
    Private mFax As String = String.Empty
    Private mActive As Byte


    'Private mCE_ClientExtensionID As Integer
    'Private mCE_ClientID As Integer
    'Private mCE_ExportGroupID As Integer
    'Private mCE_SurveyID As Integer
    Private mMiscChar1 As String = String.Empty
    Private mMiscChar1Name As String = String.Empty
    Private mMiscChar2 As String = String.Empty
    Private mMiscChar2Name As String = String.Empty
    Private mMiscChar3 As String = String.Empty
    Private mMiscChar3Name As String = String.Empty
    Private mMiscChar4 As String = String.Empty
    Private mMiscChar4Name As String = String.Empty
    Private mMiscChar5 As String = String.Empty
    Private mMiscChar5Name As String = String.Empty
    Private mMiscChar6 As String = String.Empty
    Private mMiscChar6Name As String = String.Empty
    Private mMiscDate1 As Nullable(Of Date)
    Private mMiscDate1Name As String = String.Empty
    Private mMiscDate2 As Nullable(Of Date)
    Private mMiscDate2Name As String = String.Empty
    Private mMiscDate3 As Nullable(Of Date)
    Private mMiscDate3Name As String = String.Empty
    Private mMiscNum2 As Nullable(Of Decimal)
    Private mMiscNum2Name As String = String.Empty
    Private mMiscNum1 As Nullable(Of Decimal)
    Private mMiscNum1Name As String = String.Empty
    Private mMiscNum3 As Nullable(Of Decimal)
    Private mMiscNum3Name As String = String.Empty

    Private mExportClientExtensionCollection As ExportClientExtensionCollection
#End Region

#Region " Public Properties "
    Public Property ClientID() As Integer Implements IExportClientSelected.ClientID
        Get
            Return mClientID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mClientID Then
                mClientID = value
                PropertyHasChanged("C_ClientID")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("C_Name")
            End If
        End Set
    End Property


    Public Property Address1() As String
        Get
            Return mAddress1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddress1 Then
                mAddress1 = value
                PropertyHasChanged("C_Address1")
            End If
        End Set
    End Property
    Public Property Address2() As String
        Get
            Return mAddress2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddress2 Then
                mAddress2 = value
                PropertyHasChanged("C_Address2")
            End If
        End Set
    End Property
    Public Property City() As String
        Get
            Return mCity
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCity Then
                mCity = value
                PropertyHasChanged("C_City")
            End If
        End Set
    End Property
    Public Property State() As String
        Get
            Return mState
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mState Then
                mState = value
                PropertyHasChanged("C_State")
            End If
        End Set
    End Property
    Public Property PostalCode() As String
        Get
            Return mPostalCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPostalCode Then
                mPostalCode = value
                PropertyHasChanged("C_PostalCode")
            End If
        End Set
    End Property
    Public Property Telephone() As String
        Get
            Return mTelephone
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTelephone Then
                mTelephone = value
                PropertyHasChanged("C_Telephone")
            End If
        End Set
    End Property
    Public Property Fax() As String
        Get
            Return mFax
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFax Then
                mFax = value
                PropertyHasChanged("C_Fax")
            End If
        End Set
    End Property
    Public Property Active() As Byte
        Get
            Return mActive
        End Get
        Set(ByVal value As Byte)
            If Not value = mActive Then
                mActive = value
                PropertyHasChanged("C_Active")
            End If
        End Set
    End Property
    ''' <summary>Keeps the Extension properties for the selected client</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>March 13 2008 - Arman Mnatsakanyan</term>
    ''' <description>Moved the population of the collection to the provider
    ''' class</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Property ExportClientExtensionCollection() As ExportClientExtensionCollection
        Get
            Return mExportClientExtensionCollection
        End Get
        Set(ByVal value As ExportClientExtensionCollection)
            mExportClientExtensionCollection = value
        End Set
    End Property

#Region "Extension Properties"
    Public Property MiscChar1() As String
        Get
            Return mMiscChar1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar1 Then
                mMiscChar1 = value
                PropertyHasChanged("MiscChar1")
            End If
        End Set
    End Property
    Public Property MiscChar1Name() As String
        Get
            Return mMiscChar1Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar1Name Then
                mMiscChar1Name = value
                PropertyHasChanged("MiscChar1Name")
            End If
        End Set
    End Property
    Public Property MiscChar2() As String
        Get
            Return mMiscChar2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar2 Then
                mMiscChar2 = value
                PropertyHasChanged("MiscChar2")
            End If
        End Set
    End Property
    Public Property MiscChar2Name() As String
        Get
            Return mMiscChar2Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar2Name Then
                mMiscChar2Name = value
                PropertyHasChanged("MiscChar2Name")
            End If
        End Set
    End Property
    Public Property MiscChar3() As String
        Get
            Return mMiscChar3
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar3 Then
                mMiscChar3 = value
                PropertyHasChanged("MiscChar3")
            End If
        End Set
    End Property
    Public Property MiscChar3Name() As String
        Get
            Return mMiscChar3Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar3Name Then
                mMiscChar3Name = value
                PropertyHasChanged("MiscChar3Name")
            End If
        End Set
    End Property
    Public Property MiscChar4() As String
        Get
            Return mMiscChar4
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar4 Then
                mMiscChar4 = value
                PropertyHasChanged("MiscChar4")
            End If
        End Set
    End Property
    Public Property MiscChar4Name() As String
        Get
            Return mMiscChar4Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar4Name Then
                mMiscChar4Name = value
                PropertyHasChanged("MiscChar4Name")
            End If
        End Set
    End Property
    Public Property MiscChar5() As String
        Get
            Return mMiscChar5
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar5 Then
                mMiscChar5 = value
                PropertyHasChanged("MiscChar5")
            End If
        End Set
    End Property
    Public Property MiscChar5Name() As String
        Get
            Return mMiscChar5Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar5Name Then
                mMiscChar5Name = value
                PropertyHasChanged("MiscChar5Name")
            End If
        End Set
    End Property
    Public Property MiscChar6() As String
        Get
            Return mMiscChar6
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar6 Then
                mMiscChar6 = value
                PropertyHasChanged("MiscChar6")
            End If
        End Set
    End Property
    Public Property MiscChar6Name() As String
        Get
            Return mMiscChar6Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar6Name Then
                mMiscChar6Name = value
                PropertyHasChanged("MiscChar6Name")
            End If
        End Set
    End Property
    Public Property MiscDate1() As Nullable(Of Date)
        Get
            Return mMiscDate1
        End Get
        Set(ByVal value As Nullable(Of Date))
            mMiscDate1 = value
            PropertyHasChanged("MiscDate1")
        End Set
    End Property
    Public Property MiscDate1Name() As String
        Get
            Return mMiscDate1Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscDate1Name Then
                mMiscDate1Name = value
                PropertyHasChanged("MiscDate1Name")
            End If
        End Set
    End Property
    Public Property MiscDate2() As Nullable(Of Date)
        Get
            Return mMiscDate2
        End Get
        Set(ByVal value As Nullable(Of Date))
            mMiscDate2 = value
            PropertyHasChanged("MiscDate2")
        End Set
    End Property
    Public Property MiscDate2Name() As String
        Get
            Return mMiscDate2Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscDate2Name Then
                mMiscDate2Name = value
                PropertyHasChanged("MiscDate2Name")
            End If
        End Set
    End Property
    Public Property MiscDate3() As Nullable(Of Date)
        Get
            Return mMiscDate3
        End Get
        Set(ByVal value As Nullable(Of Date))
            mMiscDate3 = value
            PropertyHasChanged("MiscDate3")
        End Set
    End Property
    Public Property MiscDate3Name() As String
        Get
            Return mMiscDate3Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscDate3Name Then
                mMiscDate3Name = value
                PropertyHasChanged("MiscDate3Name")
            End If
        End Set
    End Property
    Public Property MiscNum2() As Nullable(Of Decimal)
        Get
            Return mMiscNum2
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            mMiscNum2 = value
            PropertyHasChanged("MiscNum2")
        End Set
    End Property
    Public Property MiscNum2Name() As String
        Get
            Return mMiscNum2Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscNum2Name Then
                mMiscNum2Name = value
                PropertyHasChanged("MiscNum2Name")
            End If
        End Set
    End Property
    Public Property MiscNum1() As Nullable(Of Decimal)
        Get
            Return mMiscNum1
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            mMiscNum1 = value
            PropertyHasChanged("MiscNum1")
        End Set
    End Property
    Public Property MiscNum1Name() As String
        Get
            Return mMiscNum1Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscNum1Name Then
                mMiscNum1Name = value
                PropertyHasChanged("MiscNum1Name")
            End If
        End Set
    End Property
    Public Property MiscNum3() As Nullable(Of Decimal)
        Get
            Return mMiscNum3
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            mMiscNum3 = value
            PropertyHasChanged("MiscNum3")
        End Set
    End Property
    Public Property MiscNum3Name() As String
        Get
            Return mMiscNum3Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscNum3Name Then
                mMiscNum3Name = value
                PropertyHasChanged("MiscNum3Name")
            End If
        End Set
    End Property
#End Region

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewClient() As ExportClientSelected
        Return New ExportClientSelected
    End Function

    Public Shared Function GetSelectedClients(ByVal ExportGroup As ExportGroup, ByVal Survey As ExportSurvey) As ExportClientSelectedCollection
        Return ExportClientSelectedProvider.Instance.GetSelectedClients(ExportGroup, Survey)
    End Function

    Public Shared Function [Get](ByVal clientID As Integer) As ExportClientSelected
        Return ExportClientSelectedProvider.Instance.GetSelectedClientByClientID(clientID)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mClientID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar1")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar1Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar2")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar2Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar3")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar3Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar4")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar4Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar5")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar5Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar6")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar6Name")
        ValidationRules.AddRule(AddressOf NumericRule, "MiscNum1")
        ValidationRules.AddRule(AddressOf StringRule, "MiscNum1Name")
        ValidationRules.AddRule(AddressOf NumericRule, "MiscNum2")
        ValidationRules.AddRule(AddressOf StringRule, "MiscNum2Name")
        ValidationRules.AddRule(AddressOf NumericRule, "MiscNum3")
        ValidationRules.AddRule(AddressOf StringRule, "MiscNum3Name")
        ValidationRules.AddRule(AddressOf DateRule, "MiscDate1")
        ValidationRules.AddRule(AddressOf StringRule, "MiscDate1Name")
        ValidationRules.AddRule(AddressOf DateRule, "MiscDate2")
        ValidationRules.AddRule(AddressOf StringRule, "MiscDate2Name")
        ValidationRules.AddRule(AddressOf DateRule, "MiscDate3")
        ValidationRules.AddRule(AddressOf StringRule, "MiscDate3Name")
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        Throw New NotImplementedException("Cannot Insert. Business object doesn't represent a table or view")
    End Sub

    Protected Overrides Sub Update()
        Throw New NotImplementedException("Cannot Update. Business object doesn't represent a table or view")
    End Sub

    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException("Cannot Delete. Business object doesn't represent a table or view")
    End Sub

    Public Overrides Sub Save()
        'MyBase.Save()
        Throw New NotImplementedException("Cannot save.  Business object doesn't represent a table of view")
    End Sub
#End Region

#Region " Private Methods "
#End Region

#Region " Public Methods "
    Public Function StringRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given for client property."
        If val IsNot Nothing Then
            If val.Length > 100 Then
                retVal = False
                retMsg = "Client Property " & e.PropertyName & ": string length must be under 100 characters."
            Else
                Return True
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    Public Function NumericRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim decVal As Decimal = 0
        If val IsNot Nothing Then
            If Decimal.TryParse(val, decVal) Then
                Return True
            Else
                e.Description = "Client Property " & e.PropertyName & " was given a non numeric value was given."
                Return False
            End If
        Else
            'Null values are allowed
            Return True
        End If
    End Function
    Public Function DateRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given for client property"
        If val IsNot Nothing Then
            Dim tempDate As DateTime
            Dim isDate As Boolean = DateTime.TryParse(val, tempDate)
            If isDate = False Then
                retMsg = "Client Property " & e.PropertyName & ": A non-date value was given."
                retVal = False
            ElseIf tempDate.Year < 1901 Then
                retMsg = "Client Property " & e.PropertyName & ": Date value out of range."
                retVal = False
            Else
                Return True
            End If
        Else
            'Null values are allowed.
            Return True
        End If
        e.Description = retMsg
        Return retVal
    End Function
#End Region
End Class


