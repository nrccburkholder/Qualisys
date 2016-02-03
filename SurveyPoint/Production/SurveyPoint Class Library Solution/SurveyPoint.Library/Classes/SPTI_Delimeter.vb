Imports Nrc.Framework.BusinessLogic

Public Interface ISPTI_Delimeter
    Property DelimeterID() As Integer
End Interface

<Serializable()> _
Public Class SPTI_Delimeter
    Inherits BusinessBase(Of SPTI_Delimeter)
    Implements ISPTI_Delimeter

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDelimeterID As Integer
    Private mName As String = String.Empty
    Private mDateCreated As Date
    Private mActive As Integer
    Private mArchive As Integer
#End Region

#Region " Public Properties "
    Public Property DelimeterID() As Integer Implements ISPTI_Delimeter.DelimeterID
        Get
            Return mDelimeterID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mDelimeterID Then
                mDelimeterID = value
                PropertyHasChanged("DelimeterID")
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
    Public Shared Function NewSPTI_Delimeter() As SPTI_Delimeter
        Return New SPTI_Delimeter
    End Function

    Public Shared Function [Get](ByVal delimeterID As Integer) As SPTI_Delimeter
        Return DataProviders.SPTI_DelimeterProvider.Instance.SelectSPTI_Delimeter(delimeterID)
    End Function

    Public Shared Function GetAll() As SPTI_DelimeterCollection
        Return DataProviders.SPTI_DelimeterProvider.Instance.SelectAllSPTI_Delimeters()
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mDelimeterID
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
        DelimeterID = DataProviders.SPTI_DelimeterProvider.Instance.InsertSPTI_Delimeter(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProviders.SPTI_DelimeterProvider.Instance.UpdateSPTI_Delimeter(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProviders.SPTI_DelimeterProvider.Instance.DeleteSPTI_Delimeter(mDelimeterID)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class