Imports NRC.Framework.BusinessLogic

Public Interface IVendorPhoneFile_Data
	Property VendorFile_DataId As Integer
End Interface

<Serializable()> _
Public Class VendorPhoneFile_Data
	Inherits BusinessBase(Of VendorPhoneFile_Data)
	Implements IVendorPhoneFile_Data

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mVendorFile_DataId As Integer
	Private mVendorFileId As Integer
	Private mHCAHPSSamp As Integer
	Private mLitho As String = String.Empty
	Private mSurveyId As Integer
	Private mSamplesetId As Integer
	Private mPhone As String = String.Empty
	Private mAltPhone As String = String.Empty
	Private mFName As String = String.Empty
	Private mLName As String = String.Empty
	Private mAddr As String = String.Empty
	Private mAddr2 As String = String.Empty
	Private mCity As String = String.Empty
	Private mSt As String = String.Empty
	Private mZip5 As String = String.Empty
	Private mPhServDate As Date
	Private mLangID As Integer
	Private mTelematch As String = String.Empty
	Private mPhFacName As String = String.Empty
	Private mPhServInd1 As String = String.Empty
	Private mPhServInd2 As String = String.Empty
	Private mPhServInd3 As String = String.Empty
	Private mPhServInd4 As String = String.Empty
	Private mPhServInd5 As String = String.Empty
	Private mPhServInd6 As String = String.Empty
	Private mPhServInd7 As String = String.Empty
	Private mPhServInd8 As String = String.Empty
	Private mPhServInd9 As String = String.Empty
	Private mPhServInd10 As String = String.Empty
	Private mPhServInd11 As String = String.Empty
    Private mPhServInd12 As String = String.Empty
    Private mProvince As String = String.Empty
    Private mPostalCode As String = String.Empty
    Private mAgeRange As String = String.Empty
#End Region

#Region " Public Properties "
	Public Property VendorFile_DataId As Integer Implements IVendorPhoneFile_Data.VendorFile_DataId
		Get
			Return mVendorFile_DataId
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mVendorFile_DataId Then
				mVendorFile_DataId = value
				PropertyHasChanged("VendorFile_DataId")
			End If		
		End Set
	End Property
	Public Property VendorFileId As Integer
		Get
			Return mVendorFileId
		End Get
		Set(ByVal value As Integer)
			If Not value = mVendorFileId Then
				mVendorFileId = value
				PropertyHasChanged("VendorFileId")
			End If
		End Set
	End Property
	Public Property HCAHPSSamp As Integer
		Get
			Return mHCAHPSSamp
		End Get
		Set(ByVal value As Integer)
			If Not value = mHCAHPSSamp Then
				mHCAHPSSamp = value
				PropertyHasChanged("HCAHPSSamp")
			End If
		End Set
	End Property
	Public Property Litho As String
		Get
			Return mLitho
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mLitho Then
				mLitho = value
				PropertyHasChanged("Litho")
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
	Public Property SamplesetId As Integer
		Get
			Return mSamplesetId
		End Get
		Set(ByVal value As Integer)
			If Not value = mSamplesetId Then
				mSamplesetId = value
				PropertyHasChanged("SamplesetId")
			End If
		End Set
	End Property
	Public Property Phone As String
		Get
			Return mPhone
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhone Then
				mPhone = value
				PropertyHasChanged("Phone")
			End If
		End Set
	End Property
	Public Property AltPhone As String
		Get
			Return mAltPhone
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mAltPhone Then
				mAltPhone = value
				PropertyHasChanged("AltPhone")
			End If
		End Set
	End Property
	Public Property FName As String
		Get
			Return mFName
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mFName Then
				mFName = value
				PropertyHasChanged("FName")
			End If
		End Set
	End Property
	Public Property LName As String
		Get
			Return mLName
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mLName Then
				mLName = value
				PropertyHasChanged("LName")
			End If
		End Set
	End Property
	Public Property Addr As String
		Get
			Return mAddr
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mAddr Then
				mAddr = value
				PropertyHasChanged("Addr")
			End If
		End Set
	End Property
	Public Property Addr2 As String
		Get
			Return mAddr2
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mAddr2 Then
				mAddr2 = value
				PropertyHasChanged("Addr2")
			End If
		End Set
	End Property
	Public Property City As String
		Get
			Return mCity
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mCity Then
				mCity = value
				PropertyHasChanged("City")
			End If
		End Set
	End Property
	Public Property St As String
		Get
			Return mSt
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mSt Then
				mSt = value
				PropertyHasChanged("St")
			End If
		End Set
	End Property
	Public Property Zip5 As String
		Get
			Return mZip5
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mZip5 Then
				mZip5 = value
				PropertyHasChanged("Zip5")
			End If
		End Set
	End Property
	Public Property PhServDate As Date
		Get
			Return mPhServDate
		End Get
		Set(ByVal value As Date)
			If Not value = mPhServDate Then
				mPhServDate = value
				PropertyHasChanged("PhServDate")
			End If
		End Set
	End Property
	Public Property LangID As Integer
		Get
			Return mLangID
		End Get
		Set(ByVal value As Integer)
			If Not value = mLangID Then
				mLangID = value
				PropertyHasChanged("LangID")
			End If
		End Set
	End Property
	Public Property Telematch As String
		Get
			Return mTelematch
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mTelematch Then
				mTelematch = value
				PropertyHasChanged("Telematch")
			End If
		End Set
	End Property
	Public Property PhFacName As String
		Get
			Return mPhFacName
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhFacName Then
				mPhFacName = value
				PropertyHasChanged("PhFacName")
			End If
		End Set
	End Property
	Public Property PhServInd1 As String
		Get
			Return mPhServInd1
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd1 Then
				mPhServInd1 = value
				PropertyHasChanged("PhServInd1")
			End If
		End Set
	End Property
	Public Property PhServInd2 As String
		Get
			Return mPhServInd2
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd2 Then
				mPhServInd2 = value
				PropertyHasChanged("PhServInd2")
			End If
		End Set
	End Property
	Public Property PhServInd3 As String
		Get
			Return mPhServInd3
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd3 Then
				mPhServInd3 = value
				PropertyHasChanged("PhServInd3")
			End If
		End Set
	End Property
	Public Property PhServInd4 As String
		Get
			Return mPhServInd4
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd4 Then
				mPhServInd4 = value
				PropertyHasChanged("PhServInd4")
			End If
		End Set
	End Property
	Public Property PhServInd5 As String
		Get
			Return mPhServInd5
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd5 Then
				mPhServInd5 = value
				PropertyHasChanged("PhServInd5")
			End If
		End Set
	End Property
	Public Property PhServInd6 As String
		Get
			Return mPhServInd6
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd6 Then
				mPhServInd6 = value
				PropertyHasChanged("PhServInd6")
			End If
		End Set
	End Property
	Public Property PhServInd7 As String
		Get
			Return mPhServInd7
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd7 Then
				mPhServInd7 = value
				PropertyHasChanged("PhServInd7")
			End If
		End Set
	End Property
	Public Property PhServInd8 As String
		Get
			Return mPhServInd8
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd8 Then
				mPhServInd8 = value
				PropertyHasChanged("PhServInd8")
			End If
		End Set
	End Property
	Public Property PhServInd9 As String
		Get
			Return mPhServInd9
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd9 Then
				mPhServInd9 = value
				PropertyHasChanged("PhServInd9")
			End If
		End Set
	End Property
	Public Property PhServInd10 As String
		Get
			Return mPhServInd10
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd10 Then
				mPhServInd10 = value
				PropertyHasChanged("PhServInd10")
			End If
		End Set
	End Property
	Public Property PhServInd11 As String
		Get
			Return mPhServInd11
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd11 Then
				mPhServInd11 = value
				PropertyHasChanged("PhServInd11")
			End If
		End Set
	End Property
	Public Property PhServInd12 As String
		Get
			Return mPhServInd12
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mPhServInd12 Then
				mPhServInd12 = value
				PropertyHasChanged("PhServInd12")
			End If
		End Set
	End Property
    Public Property Province As String
        Get
            Return mProvince
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mProvince Then
                mProvince = value
                PropertyHasChanged("Province")
            End If
        End Set
    End Property
    Public Property PostalCode As String
        Get
            Return mPostalCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPostalCode Then
                mPostalCode = value
                PropertyHasChanged("PostalCode")
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
	Public Shared Function NewVendorPhoneFile_Data As VendorPhoneFile_Data
		Return New VendorPhoneFile_Data
	End Function
	
	Public Shared Function [Get](ByVal vendorFile_DataId As Integer) As VendorPhoneFile_Data
		Return VendorPhoneFile_DataProvider.Instance.SelectVendorPhoneFile_Data(vendorFile_DataId)
	End Function

	Public Shared Function GetAll() As VendorPhoneFile_DataCollection
		Return VendorPhoneFile_DataProvider.Instance.SelectAllVendorPhoneFile_Datas()
	End Function
	Public Shared Function GetByVendorFileId(ByVal vendorFileId As Integer) As VendorPhoneFile_DataCollection
		Return VendorPhoneFile_DataProvider.Instance.SelectVendorPhoneFile_DatasByVendorFileId(vendorFileId)
	End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorFile_DataId
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

    Public Function GeneratePhoneVendorCancelFile(ByVal vendor_id As Integer) As VendorPhoneFile_DataCollection
        Return VendorPhoneFile_DataProvider.Instance.GeneratePhoneVendorCancelFile(vendor_id)
    End Function

	Protected Overrides Sub Insert()
		VendorFile_DataId = VendorPhoneFile_DataProvider.Instance.InsertVendorPhoneFile_Data(Me)
	End Sub
	
	Protected Overrides Sub Update
		VendorPhoneFile_DataProvider.Instance.UpdateVendorPhoneFile_Data(Me)
	End Sub

    Public Sub MarkPhoneVendorCancelFileSent(ByVal vendor_id As Integer)
        VendorPhoneFile_DataProvider.Instance.MarkPhoneVendorCancelFileSent(vendor_id)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        VendorPhoneFile_DataProvider.Instance.DeleteVendorPhoneFile_Data(Me)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


