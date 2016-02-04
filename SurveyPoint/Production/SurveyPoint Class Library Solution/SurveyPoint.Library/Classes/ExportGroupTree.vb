Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.IO

Public Interface IExportGroupTree
    Property ExportGroupID() As Integer
End Interface

''' <summary>This class allows for a read only collection of export groups.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportGroupTree
    Inherits BusinessBase(Of ExportGroupTree)
    Implements IExportGroupTree

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid

    Private mExportGroupID As Integer
    Private mName As String = String.Empty
#End Region

#Region " Public Properties "

    ''' <summary>Kek Field for Export Group</summary>
    ''' <value>Export Group ID</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportGroupID() As Integer Implements IExportGroupTree.ExportGroupID
        Get
            Return mExportGroupID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportGroupID Then
                mExportGroupID = value
                PropertyHasChanged("ExportGroupID")
            End If
        End Set
    End Property
    ''' <summary>Export Group Name</summary>
    ''' <value>export Group Name</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
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

#End Region

#Region " Constructors "
    Protected Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new (read only) export group.</summary>
    ''' <returns>Export Group Tree object</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportGroup() As ExportGroupTree
        Return New ExportGroupTree
    End Function

    ''' <summary>Retruns an existing export group from the DB into a EG tree object.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <returns>ExportGroupTree object</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal exportGroupID As Integer) As ExportGroupTree
        Return ExportGroupTreeProvider.Instance.SelectExportGroup(exportGroupID)
    End Function

    ''' <summary>Factory method to return a collection of read only export group objects.</summary>
    ''' <returns>Export group tree collection.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As ExportGroupTreeCollection
        Return ExportGroupTreeProvider.Instance.SelectAllExportGroups()
    End Function

    ''' <summary>Let you send in a name to check if that names export group exists in the db.</summary>
    ''' <param name="pstrExportGroupName"></param>
    ''' <returns>True if exists, false if not.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CheckExportGroupByName(ByVal pstrExportGroupName As String, ByVal exportGroupId As Integer) As Boolean
        Return ExportGroupTreeProvider.Instance.CheckExportGroupByName(pstrExportGroupName, exportGroupId)
    End Function

    ''' <summary>Allows you to make full copy of an existing export group by sending in the new export group name.</summary>
    ''' <param name="oldExportID"></param>
    ''' <param name="newExportName"></param>
    ''' <returns>The new Export group id.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CopyExport(ByVal oldExportID As Integer, ByVal newExportName As String) As Integer
        Return ExportGroupTreeProvider.Instance.CopyExport(oldExportID, newExportName)
    End Function

#End Region

#Region " Basic Overrides "
    ''' <summary>Uniquely ID the object whether new or existing.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mExportGroupID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Wires the Validation method to their properties.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf ValidateExportName, "Name")        
    End Sub
#End Region

#Region " Data Access "
    ''' <summary></summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub


    ''' <summary>Deletes an existing export group (along with its child objects) from the database.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        'TODO:  Make sure this implments a delete all!
        ExportGroupTreeProvider.Instance.DeleteExportGroup(mExportGroupID)
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>Validates the new name of the exportgroup.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns>True if valid, false if invalid.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateExportName(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim exName As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        If exName Is Nothing OrElse exName = "" Then
            e.Description = "No export name was given."
            Return False
        ElseIf exName.Length > 100 Then
            e.Description = "Export name can not be greater than 100 characters."
            Return False
        Else
            Return True
        End If
    End Function
   
#End Region

End Class
