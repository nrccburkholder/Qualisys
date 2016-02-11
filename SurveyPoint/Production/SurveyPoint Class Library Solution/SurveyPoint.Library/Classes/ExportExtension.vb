Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportExtension
    Property ExportExtensionID() As Integer
End Interface


''' <summary>This is a base class that allows us to pivot the extensions for Export groups, clients, and scripts.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public MustInherit Class ExportExtension
    Inherits BusinessBase(Of ExportExtension)
    Implements IExportExtension

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mExportExtensionID As Integer
    Private mColumnName As String = String.Empty
    Private mDisplayName As String = String.Empty
    Private mValue As String = String.Empty
    Private mRulesSet As Boolean = False
#End Region

#Region " Public Properties "
    ''' <summary>This should always be 0 as this object is never saved to a database.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Property ExportExtensionID() As Integer Implements IExportExtension.ExportExtensionID

        Get
            Return mExportExtensionID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mExportExtensionID Then
                mExportExtensionID = value
                PropertyHasChanged("ExportExtensionID")
            End If
        End Set
    End Property
    ''' <summary>The acutal column name of the extension in the data base. Ex, miscchar1,....</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ColumnName() As String
        Get
            Return mColumnName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mColumnName Then
                mColumnName = value
                PropertyHasChanged("ColumnName")
            End If
        End Set
    End Property
    ''' <summary>The user is allowed to customize column names.  For example, they can make MiscChar1 = [WAC Column].  This property hold that new value.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DisplayName() As String
        Get
            Return mDisplayName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDisplayName Then
                mDisplayName = value
                PropertyHasChanged("DisplayName")
                SetParentProperty(Me.ColumnName & "Name", value)
            End If
        End Set
    End Property
    ''' <summary>This value of the extension being held.  Example, Miscchar1 = [Coventry]</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Value() As String
        Get
            If Me.mColumnName.IndexOf("MiscNum") > -1 Then
                If IsNumeric(mValue) Then
                    Return CStr(Val(mValue))
                Else
                    Return mValue
                End If                           
            ElseIf Me.mColumnName.IndexOf("MiscDate") > -1 Then
                If IsDate(Me.mValue) Then
                    Dim dte As Date = Date.Parse(Me.mValue)
                    Return dte.ToString("MM/dd/yyyy")
                Else
                    Return mValue
                End If
            Else
            Return mValue
            End If
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = Me.mValue Then
                Me.mValue = value
                PropertyHasChanged("Value")
                SetParentProperty(Me.ColumnName, value)
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    Protected Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mExportExtensionID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Validation rules can NOT be set here as the values must be populated first to know which rules that wire to.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        'ValidationRules.AddRule(AddressOf StringRule, "DisplayName")
        'If ColumnName Is Nothing Then
        '    Exit Sub
        'ElseIf ColumnName.IndexOf("MiscChar") > -1 Then
        '    ValidationRules.AddRule(AddressOf StringRule, "Value")
        'ElseIf ColumnName.IndexOf("MiscNum") > -1 Then
        '    ValidationRules.AddRule(AddressOf DateRule, "Value")
        'ElseIf ColumnName.IndexOf("MiscDate") > -1 Then
        '    ValidationRules.AddRule(AddressOf NumbericRule, "Value")
        'End If
    End Sub
    
    ''' <summary>Determines the actuall data type of the Value property, then associates the appropriate business rule.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub SetRules()
        If Not Me.mRulesSet Then
            ValidationRules.AddRule(AddressOf StringRule, "DisplayName")
            If ColumnName Is Nothing Then
                Exit Sub
            ElseIf ColumnName.IndexOf("MiscChar") > -1 Then
                ValidationRules.AddRule(AddressOf StringRule, "Value")
            ElseIf ColumnName.IndexOf("MiscNum") > -1 Then
                ValidationRules.AddRule(AddressOf NumbericRule, "Value")
            ElseIf ColumnName.IndexOf("MiscDate") > -1 Then
                ValidationRules.AddRule(AddressOf DateRule, "Value")
            End If
            Me.mRulesSet = True
        End If
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub


#End Region

#Region " Protected Methods "
    ''' <summary>This object hold a pivot view of values stored in a parent object.  This method forces the derived class to set the parents properties based off of the changing values in this object.</summary>
    ''' <param name="colName"></param>
    ''' <param name="setValue"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected MustOverride Sub SetParentProperty(ByVal colName As String, ByVal setValue As String)
#End Region
#Region " Public Methods "
    ''' <summary>Validates that the value and Description columns are varchar() either null or less than 100 chars.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function StringRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given"
        If val IsNot Nothing Then
            If val.Length > 100 Then
                retVal = False
                retMsg = "String length must be under 100 characters."
            Else
                Return True
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>Validates that the value given is null or a valid decimal value.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function NumbericRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim decVal As Decimal = 0
        If val IsNot Nothing Then
            If val = "" Then
                Return True
            ElseIf Decimal.TryParse(val, decVal) Then
                Return True
            Else
                Me.Value = ""
                Return True
            End If
        End If
    End Function
    ''' <summary>Validates that the value is null or a date type greater than 1901.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function DateRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = Me.Value 'TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given"
        If val IsNot Nothing Then
            Dim tempDate As DateTime
            Dim isDate As Boolean = DateTime.TryParse(val, tempDate)
            If val = String.Empty Then
                Return True
            ElseIf isDate = False Then
                'retMsg = "A non-date value was given."
                Me.Value = ""
                Return True
            ElseIf tempDate.Year < 1901 Then
                'retMsg = "Date value out of range."
                Me.Value = ""
                Return True
            Else
                Return True
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function    
#End Region

End Class
