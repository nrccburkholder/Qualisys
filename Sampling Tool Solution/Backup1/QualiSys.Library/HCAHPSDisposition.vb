Imports NRC.Framework.BusinessLogic

Public Interface IHCAHPSDisposition
	Property HCAHPSDispositionID As Integer
End Interface

<Serializable()> _
Public Class HCAHPSDisposition
	Inherits BusinessBase(Of HCAHPSDisposition)
	Implements IHCAHPSDisposition

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mHCAHPSDispositionID As Integer
	Private mDispositionId As Integer
	Private mHCAHPSValue As String = String.Empty
	Private mHCAHPSHierarchy As Integer
	Private mHCAHPSDesc As String = String.Empty
#End Region

#Region " Public Properties "
	Public Property HCAHPSDispositionID As Integer Implements IHCAHPSDisposition.HCAHPSDispositionID
		Get
			Return mHCAHPSDispositionID
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mHCAHPSDispositionID Then
				mHCAHPSDispositionID = value
				PropertyHasChanged("HCAHPSDispositionID")
			End If		
		End Set
	End Property
	Public Property DispositionId As Integer
		Get
			Return mDispositionId
		End Get
		Set(ByVal value As Integer)
			If Not value = mDispositionId Then
				mDispositionId = value
				PropertyHasChanged("DispositionId")
			End If
		End Set
	End Property
	Public Property HCAHPSValue As String
		Get
			Return mHCAHPSValue
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mHCAHPSValue Then
				mHCAHPSValue = value
				PropertyHasChanged("HCAHPSValue")
			End If
		End Set
	End Property
	Public Property HCAHPSHierarchy As Integer
		Get
			Return mHCAHPSHierarchy
		End Get
		Set(ByVal value As Integer)
			If Not value = mHCAHPSHierarchy Then
				mHCAHPSHierarchy = value
				PropertyHasChanged("HCAHPSHierarchy")
			End If
		End Set
	End Property
	Public Property HCAHPSDesc As String
		Get
			Return mHCAHPSDesc
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mHCAHPSDesc Then
				mHCAHPSDesc = value
				PropertyHasChanged("HCAHPSDesc")
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
	Public Shared Function NewHCAHPSDisposition As HCAHPSDisposition
		Return New HCAHPSDisposition
	End Function
	
	Public Shared Function [Get](ByVal hCAHPSDispositionID As Integer) As HCAHPSDisposition
		Return HCAHPSDispositionProvider.Instance.SelectHCAHPSDisposition(hCAHPSDispositionID)
	End Function

	Public Shared Function GetAll() As HCAHPSDispositionCollection
		Return HCAHPSDispositionProvider.Instance.SelectAllHCAHPSDispositions()
	End Function
	Public Shared Function GetByDispositionId(ByVal dispositionId As Integer) As HCAHPSDispositionCollection
		Return HCAHPSDispositionProvider.Instance.SelectHCAHPSDispositionsByDispositionId(dispositionId)
	End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mHCAHPSDispositionID
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
		HCAHPSDispositionID = HCAHPSDispositionProvider.Instance.InsertHCAHPSDisposition(Me)
	End Sub
	
	Protected Overrides Sub Update
		HCAHPSDispositionProvider.Instance.UpdateHCAHPSDisposition(Me)
	End Sub
	Protected Overrides Sub DeleteImmediate()
		HCAHPSDispositionProvider.Instance.DeleteHCAHPSDisposition(Me)
	End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


