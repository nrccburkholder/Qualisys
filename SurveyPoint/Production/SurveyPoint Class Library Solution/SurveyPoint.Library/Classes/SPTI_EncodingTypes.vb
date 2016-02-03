Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_EncodingType
    Property EncodingTypeID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_EncodingType
    Inherits BusinessBase(Of SPTI_EncodingType)
    Implements ISPTI_EncodingType

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mEncodingTypeID As Integer
    Private mName As String = String.Empty
    Private mDateCreated As Date
    Private mActive As Integer
    Private mArchive As Integer
#End Region

#Region " Public Properties "
    ''' <summary>PK for the object</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property EncodingTypeID() As Integer Implements ISPTI_EncodingType.EncodingTypeID
        Get
            Return mEncodingTypeID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mEncodingTypeID Then
                mEncodingTypeID = value
                PropertyHasChanged("EncodingTypeID")
            End If
        End Set
    End Property
    ''' <summary>Name of the object (ANSI, etc...)</summary>
    ''' <value></value>
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
    ''' <summary>Data the record was created in the data store.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
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
    ''' <summary></summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
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
    ''' <summary></summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
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
    ''' <summary>Default Constructor.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Use to create a new Encoding Type</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewSPTI_EncodingType() As SPTI_EncodingType
        Return New SPTI_EncodingType
    End Function

    ''' <summary>Get from data store by encoding type id.</summary>
    ''' <param name="encodingTypeID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal encodingTypeID As Integer) As SPTI_EncodingType
        Return DataProviders.SPTI_EncodingTypesProvider.Instance.SelectSPTI_EncodingType(encodingTypeID)
    End Function

    ''' <summary>Get all encoding types into a collection.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As SPTI_EncodingTypeCollection
        Return DataProviders.SPTI_EncodingTypesProvider.Instance.SelectAllSPTI_EncodingTypes()
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mEncodingTypeID
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

    ''' <summary>Crud Insert</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        EncodingTypeID = 0 'TODO:SPTI_EncodingTypesProvider.Instance.InsertSPTI_EncodingType(Me)
    End Sub

    ''' <summary>Crud Update</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        'TODO:SPTI_EncodingTypesProvider.Instance.UpdateSPTI_EncodingType(Me)
    End Sub

    ''' <summary>Crud Delete</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        'TODO:SPTI_EncodingTypesProvider.Instance.DeleteSPTI_EncodingType(mEncodingTypeID)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
