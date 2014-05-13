Imports NRC.Framework.BusinessLogic

Public Interface IVendorWebFile_Data
	Property Id As Integer
End Interface

<Serializable()> _
Public Class VendorWebFile_Data
	Inherits BusinessBase(Of VendorWebFile_Data)
	Implements IVendorWebFile_Data

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mId As Integer
	Private mVendorFileId As Integer
	Private mSurveyId As Integer
	Private mSamplesetId As Integer
	Private mLitho As String = String.Empty
	Private mWAC As String = String.Empty
	Private mFName As String = String.Empty
	Private mLName As String = String.Empty
    Private mLangId As Integer
    Private mEmailAddr As String = String.Empty
    Private mwbServDate As Nullable(Of Date)
	Private mwbServInd1 As String = String.Empty
	Private mwbServInd2 As String = String.Empty
	Private mwbServInd3 As String = String.Empty
	Private mwbServInd4 As String = String.Empty
	Private mwbServInd5 As String = String.Empty
    Private mwbServInd6 As String = String.Empty
    Private mExternalRespondentID As String = String.Empty
    Private mSentToVendor As Boolean = False

#End Region

#Region " Public Properties "
	Public Property Id As Integer Implements IVendorWebFile_Data.Id
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
	Public Property WAC As String
		Get
			Return mWAC
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mWAC Then
				mWAC = value
				PropertyHasChanged("WAC")
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
    Public Property LangId() As Integer
        Get
            Return mLangId
        End Get
        Set(ByVal value As Integer)
            If Not value = mLangId Then
                mLangId = value
                PropertyHasChanged("LangId")
            End If
        End Set
    End Property
	Public Property EmailAddr As String
		Get
			Return mEmailAddr
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mEmailAddr Then
				mEmailAddr = value
				PropertyHasChanged("EmailAddr")
			End If
		End Set
	End Property
    Public Property WbServDate() As Nullable(Of Date)
        Get
            Return mwbServDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            mwbServDate = value
            PropertyHasChanged("WbServDate")
        End Set
    End Property
    Public Property wbServInd1() As String
        Get
            Return mwbServInd1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mwbServInd1 Then
                mwbServInd1 = value
                PropertyHasChanged("wbServInd1")
            End If
        End Set
    End Property
	Public Property wbServInd2 As String
		Get
			Return mwbServInd2
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mwbServInd2 Then
				mwbServInd2 = value
				PropertyHasChanged("wbServInd2")
			End If
		End Set
	End Property
	Public Property wbServInd3 As String
		Get
			Return mwbServInd3
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mwbServInd3 Then
				mwbServInd3 = value
				PropertyHasChanged("wbServInd3")
			End If
		End Set
	End Property
	Public Property wbServInd4 As String
		Get
			Return mwbServInd4
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mwbServInd4 Then
				mwbServInd4 = value
				PropertyHasChanged("wbServInd4")
			End If
		End Set
	End Property
	Public Property wbServInd5 As String
		Get
			Return mwbServInd5
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mwbServInd5 Then
				mwbServInd5 = value
				PropertyHasChanged("wbServInd5")
			End If
		End Set
	End Property
	Public Property wbServInd6 As String
		Get
			Return mwbServInd6
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mwbServInd6 Then
				mwbServInd6 = value
				PropertyHasChanged("wbServInd6")
			End If
		End Set
	End Property
    Public Property ExternalRespondentID() As String
        Get
            Return mExternalRespondentID
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mExternalRespondentID Then
                mExternalRespondentID = value
                PropertyHasChanged("ExternalRespondentID")
            End If
        End Set
    End Property
    Public Property SentToVendor() As Boolean
        Get
            Return mSentToVendor
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSentToVendor Then
                mSentToVendor = value
                PropertyHasChanged("SentToVendor")
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
	Public Shared Function NewVendorWebFile_Data As VendorWebFile_Data
		Return New VendorWebFile_Data
	End Function
	
	Public Shared Function [Get](ByVal id As Integer) As VendorWebFile_Data
		Return VendorWebFile_DataProvider.Instance.SelectVendorWebFile_Data(id)
	End Function

	Public Shared Function GetAll() As VendorWebFile_DataCollection
		Return VendorWebFile_DataProvider.Instance.SelectAllVendorWebFile_Datas()
	End Function
    Public Shared Function GetByVendorFileId(ByVal vendorFileId As Integer, ByVal HidePII As Boolean) As VendorWebFile_DataCollection
        Return VendorWebFile_DataProvider.Instance.SelectVendorWebFile_DatasByVendorFileId(vendorFileId, HidePII)
    End Function
    Public Shared Function GetByLitho(ByVal litho As String) As VendorWebFile_Data
        Return VendorWebFile_DataProvider.Instance.SelectVendorWebFile_DatasByLitho(litho)
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
		Id = VendorWebFile_DataProvider.Instance.InsertVendorWebFile_Data(Me)
	End Sub
	
	Protected Overrides Sub Update
		VendorWebFile_DataProvider.Instance.UpdateVendorWebFile_Data(Me)
	End Sub
	Protected Overrides Sub DeleteImmediate()
		VendorWebFile_DataProvider.Instance.DeleteVendorWebFile_Data(Me)
	End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


