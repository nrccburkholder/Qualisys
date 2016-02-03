Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IWPSplitRespondent
    Property WPSplitRespondentID() As String
End Interface

''' <summary></summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class WPSplitRespondent
    Inherits BusinessBase(Of WPSplitRespondent)
    Implements IWPSplitRespondent

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mWPSplitRespondentID As String
    Private mFirstName As String
    Private mLastName As String
    Private mDOB As Nullable(Of Date)
#End Region

#Region " Public Properties "
    ''' <summary>Key value of the FileLayout table.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property WPSplitRespondentID() As String Implements IWPSplitRespondent.WPSplitRespondentID
        Get
            Return mWPSplitRespondentID
        End Get
        Private Set(ByVal value As String)
            If Not value = mWPSplitRespondentID Then
                mWPSplitRespondentID = value
                PropertyHasChanged("WPSplitRespondentID")
            End If
        End Set
    End Property
    Public Property FirstName() As String
        Get
            Return Me.mFirstName
        End Get
        Set(ByVal value As String)
            If Not Me.mFirstName = value Then
                Me.mFirstName = value
                PropertyHasChanged("FirstName")
            End If
        End Set
    End Property
    Public Property LastName() As String
        Get
            Return Me.mLastName
        End Get
        Set(ByVal value As String)
            If Not Me.mLastName = value Then
                Me.mLastName = value
                PropertyHasChanged("LastName")
            End If
        End Set
    End Property
    Public Property DOB() As Nullable(Of Date)
        Get
            Return Me.mDOB
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mDOB = value
            PropertyHasChanged("DOB")
        End Set
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new file layout instance</summary>
    ''' <returns>ExportFileLayout Instance</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewWPSplitRespondent() As WPSplitRespondent
        Return New WPSplitRespondent
    End Function

    Public Shared Sub InsertDeDupRespondent(ByVal id As String, ByVal lName As String, ByVal fName As String, ByVal dob As Nullable(Of Date))
        DataProviders.WPSplitRespondentProvider.Instance.InsertWPRespondentForDupCheck(id, fName, lName, dob)
    End Sub

    Public Shared Function GetDuplicateWPRespondents(ByVal id As String, ByVal clientID As Integer, ByVal surveyInstanceStarteDate As Nullable(Of Date)) As WPSplitRespondentCollection
        Return DataProviders.WPSplitRespondentProvider.Instance.GetDuplicateRespondents(id, clientID, surveyInstanceStarteDate)
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Allows for key value associate of new objects.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return Me.mWPSplitRespondentID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
#End Region

#Region " Data Access "
    ''' <summary>Called from private constructor</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>No current implmentation</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub

    ''' <summary>No current implmentation</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub

    ''' <summary>No current implmentation</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException("This method has not been implemented.")
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
