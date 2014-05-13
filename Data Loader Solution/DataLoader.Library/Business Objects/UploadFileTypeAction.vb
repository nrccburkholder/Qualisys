Imports Nrc.Framework.BusinessLogic

Public Interface IUploadFileTypeAction
    Property Id() As Integer
End Interface

''' <summary>Maps to UploadFileTypeAction table in QLoader database. UploadFileTypeAction is a lookup table
''' that currently has only 2 rows. </summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class UploadFileTypeAction
    Inherits BusinessBase(Of UploadFileTypeAction)
    Implements IUploadFileTypeAction


    Public Class AvailableActions
        Public Const Packages As String = "Packages"
        Public Const ProjectManagers As String = "Project Managers"
        
    End Class

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
#End Region

#Region " Public Properties "
    ''' <summary>Maps to UploadFileTypeAction_id field in UploadFileTypeAction table.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Id() As Integer Implements IUploadFileTypeAction.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    ''' <summary>Maps to UploadFileTypeAction_Nm field in UploadFileTypeAction table.</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
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
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewUploadFileTypeAction() As UploadFileTypeAction
        Return New UploadFileTypeAction
    End Function

    ''' <summary>Executes LD_SelectUploadFileTypeAction SP through 
    ''' the shared instance of UploadFileTypeActionProvider and populates an
    '''  UploadFileTypeAction object with the returned row.</summary>
    ''' <param name="id">The id of the record in UploadFileTypeAction table</param>
    ''' <returns>UploadFileTypeAction object</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal id As Integer) As UploadFileTypeAction
        Return UploadFileTypeActionProvider.Instance.SelectUploadFileTypeAction(id)
    End Function

    ''' <summary>Executes LD_SelectUploadFileTypeActionByName SP through 
    ''' the shared instance of UploadFileTypeActionProvider and populates an
    '''  UploadFileTypeAction object with the returned row.</summary>
    ''' <param name="name">The name field value in UploadFileTypeAction table</param>
    ''' <returns>UploadFileTypeAction object</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetByName(ByVal name As String) As UploadFileTypeAction
        Return UploadFileTypeActionProvider.Instance.SelectUploadFileTypeActionByName(name)
    End Function

    ''' <summary>Executes LD_SelectAllUploadFileTypeActions SP through 
    ''' the shared instance of UploadFileTypeActionProvider and populates an
    '''  UploadFileTypeAction object with the returned row.</summary>
    ''' <returns>UploadFileTypeAction object</returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As UploadFileTypeActionCollection
        Return UploadFileTypeActionProvider.Instance.SelectAllUploadFileTypeActions()
    End Function

#End Region



#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
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
        Id = UploadFileTypeActionProvider.Instance.InsertUploadFileTypeAction(Me)
    End Sub

    Protected Overrides Sub Update()
        UploadFileTypeActionProvider.Instance.UpdateUploadFileTypeAction(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        UploadFileTypeActionProvider.Instance.DeleteUploadFileTypeAction(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


