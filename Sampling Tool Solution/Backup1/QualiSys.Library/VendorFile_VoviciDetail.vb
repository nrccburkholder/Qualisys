Imports NRC.Framework.BusinessLogic

Public Interface IVendorFile_VoviciDetail
	Property VendorFile_VoviciDetailId As Integer
End Interface

<Serializable()> _
Public Class VendorFile_VoviciDetail
	Inherits BusinessBase(Of VendorFile_VoviciDetail)
	Implements IVendorFile_VoviciDetail

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mVendorFile_VoviciDetailId As Integer
	Private mSurveyId As Integer
	Private mMailingStepId As Integer
	Private mVoviciSurveyId As Integer
	Private mVoviciSurveyName As String = String.Empty
#End Region

#Region " Public Properties "
	Public Property VendorFile_VoviciDetailId As Integer Implements IVendorFile_VoviciDetail.VendorFile_VoviciDetailId
		Get
			Return mVendorFile_VoviciDetailId
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mVendorFile_VoviciDetailId Then
				mVendorFile_VoviciDetailId = value
				PropertyHasChanged("VendorFile_VoviciDetailId")
			End If		
		End Set
	End Property
	Public Property SurveyId As Integer
		Get
			Return mSurveyId
		End Get
		Set(ByVal value As Integer)
			If Not value = mSurveyId Then
				mSurveyId = value
				PropertyHasChanged("SurveyId")
			End If
		End Set
	End Property
	Public Property MailingStepId As Integer
		Get
			Return mMailingStepId
		End Get
		Set(ByVal value As Integer)
			If Not value = mMailingStepId Then
				mMailingStepId = value
				PropertyHasChanged("MailingStepId")
			End If
		End Set
	End Property
	Public Property VoviciSurveyId As Integer
		Get
			Return mVoviciSurveyId
		End Get
		Set(ByVal value As Integer)
			If Not value = mVoviciSurveyId Then
				mVoviciSurveyId = value
				PropertyHasChanged("VoviciSurveyId")
			End If
		End Set
	End Property
	Public Property VoviciSurveyName As String
		Get
			Return mVoviciSurveyName
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mVoviciSurveyName Then
				mVoviciSurveyName = value
				PropertyHasChanged("VoviciSurveyName")
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
	Public Shared Function NewVendorFile_VoviciDetail As VendorFile_VoviciDetail
		Return New VendorFile_VoviciDetail
	End Function
	
	Public Shared Function [Get](ByVal vendorFile_VoviciDetailId As Integer) As VendorFile_VoviciDetail
		Return VendorFile_VoviciDetailProvider.Instance.SelectVendorFile_VoviciDetail(vendorFile_VoviciDetailId)
	End Function

	Public Shared Function GetAll() As VendorFile_VoviciDetailCollection
		Return VendorFile_VoviciDetailProvider.Instance.SelectAllVendorFile_VoviciDetails()
	End Function
	Public Shared Function GetBySurveyId(ByVal surveyId As Integer) As VendorFile_VoviciDetailCollection
		Return VendorFile_VoviciDetailProvider.Instance.SelectVendorFile_VoviciDetailsBySurveyId(surveyId)
	End Function
	Public Shared Function GetByMailingStepId(ByVal mailingStepId As Integer) As VendorFile_VoviciDetailCollection
		Return VendorFile_VoviciDetailProvider.Instance.SelectVendorFile_VoviciDetailsByMailingStepId(mailingStepId)
	End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorFile_VoviciDetailId
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
		VendorFile_VoviciDetailId = VendorFile_VoviciDetailProvider.Instance.InsertVendorFile_VoviciDetail(Me)
	End Sub
	
	Protected Overrides Sub Update
		VendorFile_VoviciDetailProvider.Instance.UpdateVendorFile_VoviciDetail(Me)
	End Sub
	Protected Overrides Sub DeleteImmediate()
		VendorFile_VoviciDetailProvider.Instance.DeleteVendorFile_VoviciDetail(Me)
	End Sub
#End Region

#Region " Public Methods "
    ''' <summary>
    ''' Marks the object to be deleted during the next save
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub MarkDelete()
        Me.MarkDeleted()
    End Sub

    ''' <summary>
    ''' Resets the object's IsDeleted flag to false
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub MarkUnDelete()

        'Capture the current IsNew state
        Dim isNew As Boolean = Me.IsNew

        'Reset the IsDeleted flag to false
        Me.MarkNew()

        'Reset the IsNew flag if needed
        If Not isNew Then Me.MarkOld()

    End Sub
#End Region

End Class


