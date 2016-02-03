Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_FormattingRule
    Property FormatingRuleID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_FormattingRule
    Inherits BusinessBase(Of SPTI_FormattingRule)
    Implements ISPTI_FormattingRule

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFormatingRuleID As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mDateCreated As Date
    Private mActive As Integer
    Private mArchive As Integer
#End Region

#Region " Public Properties "
    Public Property FormatingRuleID() As Integer Implements ISPTI_FormattingRule.FormatingRuleID
        Get
            Return mFormatingRuleID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFormatingRuleID Then
                mFormatingRuleID = value
                PropertyHasChanged("FormatingRuleID")
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
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property
    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
            End If
        End Set
    End Property
    Public Property Active() As Integer
        Get
            Return mActive
        End Get
        Set(ByVal value As Integer)
            If Not value = mActive Then
                mActive = value
                PropertyHasChanged("Active")
            End If
        End Set
    End Property
    Public Property Archive() As Integer
        Get
            Return mArchive
        End Get
        Set(ByVal value As Integer)
            If Not value = mArchive Then
                mArchive = value
                PropertyHasChanged("Archive")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewSPTI_FormattingRule() As SPTI_FormattingRule
        Return New SPTI_FormattingRule
    End Function

    Public Shared Function [Get](ByVal formatingRuleID As Integer) As SPTI_FormattingRule
        Return DataProviders.SPTI_FormatingRuleProvider.Instance.SelectSPTI_FormattingRule(formatingRuleID)
    End Function

    Public Shared Function GetAll() As SPTI_FormattingRuleCollection
        Return DataProviders.SPTI_FormatingRuleProvider.Instance.SelectAllSPTI_FormattingRules()
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mFormatingRuleID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        FormatingRuleID = DataProviders.SPTI_FormatingRuleProvider.Instance.InsertSPTI_FormattingRule(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProviders.SPTI_FormatingRuleProvider.Instance.UpdateSPTI_FormattingRule(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProviders.SPTI_FormatingRuleProvider.Instance.DeleteSPTI_FormattingRule(mFormatingRuleID)
    End Sub

#End Region

#Region " Public Methods "
    Public Function FormatFromRule(ByVal value As String) As String
        Dim retVal As String = Trim(value)
        Select Case Me.FormatingRuleID
            Case 2 'yyyyMMdd to date
                If retVal.Length = 8 Then
                    retVal = retVal.Substring(4, 2) & "/" & retVal.Substring(6, 2) & "/" & retVal.Substring(0, 4)
                End If
            Case 3 'MMddyyy to date
                If retVal.Length = 8 Then
                    retVal = retVal.Substring(0, 2) & "/" & retVal.Substring(2, 2) & "/" & retVal.Substring(4, 4)
                End If
            Case 4 'ddMMyyyy to date
                If retVal.Length = 8 Then
                    retVal = retVal.Substring(2, 2) & "/" & retVal.Substring(0, 2) & "/" & retVal.Substring(4, 4)
                End If
            Case 5 '##-MM-## to date
                If retVal.IndexOf("-"c) >= 0 Then
                    Dim str() As String = retVal.Split("-"c)
                    retVal = ParseMonthString(str(1)) & "/" & str(0) & "/" & "19" & str(2)
                End If                
            Case 6 '##-MM-#### to date
                If retVal.IndexOf("-"c) >= 0 Then
                    Dim str() As String = retVal.Split("-"c)
                    retVal = ParseMonthString(str(1)) & "/" & str(0) & "/" & str(2)
                End If
            Case 7 'Truncate Zipcode to 5 characters
                If retVal.Length > 5 Then
                    retVal = retVal.Substring(0, 5)
                End If
        End Select

        Return retVal
    End Function
    Private Function ParseMonthString(ByVal val As String) As String
        Select Case val.ToLower
            Case "jan"
                Return "1"
            Case "feb"
                Return "2"
            Case "mar"
                Return "3"
            Case "apr"
                Return "4"
            Case "may"
                Return "5"
            Case "jun"
                Return "6"
            Case "jul"
                Return "7"
            Case "aug"
                Return "8"
            Case "sep"
                Return "9"
            Case "oct"
                Return "10"
            Case "nov"
                Return "11"
            Case "dec"
                Return "12"
            Case Else
                Return ""
        End Select
    End Function
#End Region

End Class
