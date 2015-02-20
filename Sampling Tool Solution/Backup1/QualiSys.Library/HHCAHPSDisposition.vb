Imports NRC.Framework.BusinessLogic

Public Interface IHHCAHPSDisposition
	Property HHCAHPSDispositionID As Integer
End Interface

<Serializable()> _
Public Class HHCAHPSDisposition
	Inherits BusinessBase(Of HHCAHPSDisposition)
	Implements IHHCAHPSDisposition

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mHHCAHPSDispositionID As Integer
	Private mDispositionId As Integer
	Private mHHCAHPSValue As String = String.Empty
	Private mHHCAHPSHierarchy As Integer
	Private mHHCAHPSDesc As String = String.Empty
#End Region

#Region " Public Properties "
	Public Property HHCAHPSDispositionID As Integer Implements IHHCAHPSDisposition.HHCAHPSDispositionID
		Get
			Return mHHCAHPSDispositionID
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mHHCAHPSDispositionID Then
				mHHCAHPSDispositionID = value
				PropertyHasChanged("HHCAHPSDispositionID")
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
	Public Property HHCAHPSValue As String
		Get
			Return mHHCAHPSValue
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mHHCAHPSValue Then
				mHHCAHPSValue = value
				PropertyHasChanged("HHCAHPSValue")
			End If
		End Set
	End Property
	Public Property HHCAHPSHierarchy As Integer
		Get
			Return mHHCAHPSHierarchy
		End Get
		Set(ByVal value As Integer)
			If Not value = mHHCAHPSHierarchy Then
				mHHCAHPSHierarchy = value
				PropertyHasChanged("HHCAHPSHierarchy")
			End If
		End Set
	End Property
	Public Property HHCAHPSDesc As String
		Get
			Return mHHCAHPSDesc
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mHHCAHPSDesc Then
				mHHCAHPSDesc = value
				PropertyHasChanged("HHCAHPSDesc")
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
	Public Shared Function NewHHCAHPSDisposition As HHCAHPSDisposition
		Return New HHCAHPSDisposition
	End Function
	
	Public Shared Function [Get](ByVal hHCAHPSDispositionID As Integer) As HHCAHPSDisposition
		Return HHCAHPSDispositionProvider.Instance.SelectHHCAHPSDisposition(hHCAHPSDispositionID)
	End Function

	Public Shared Function GetAll() As HHCAHPSDispositionCollection
		Return HHCAHPSDispositionProvider.Instance.SelectAllHHCAHPSDispositions()
	End Function
	Public Shared Function GetByDispositionId(ByVal dispositionId As Integer) As HHCAHPSDispositionCollection
		Return HHCAHPSDispositionProvider.Instance.SelectHHCAHPSDispositionsByDispositionId(dispositionId)
	End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mHHCAHPSDispositionID
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
		HHCAHPSDispositionID = HHCAHPSDispositionProvider.Instance.InsertHHCAHPSDisposition(Me)
	End Sub
	
	Protected Overrides Sub Update
		HHCAHPSDispositionProvider.Instance.UpdateHHCAHPSDisposition(Me)
	End Sub
	Protected Overrides Sub DeleteImmediate()
		HHCAHPSDispositionProvider.Instance.DeleteHHCAHPSDisposition(Me)
	End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


