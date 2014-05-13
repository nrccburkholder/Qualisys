Imports NRC.Framework.BusinessLogic

Public Interface IVoviciDownloadLog
	Property VoviciDownloadId As Integer
End Interface

<Serializable()> _
Public Class VoviciDownloadLog
	Inherits BusinessBase(Of VoviciDownloadLog)
	Implements IVoviciDownloadLog

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mVoviciDownloadId As Integer
	Private mVoviciSurveyId As String = String.Empty
	Private mdatLastDownload As Date
#End Region

#Region " Public Properties "
	Public Property VoviciDownloadId As Integer Implements IVoviciDownloadLog.VoviciDownloadId
		Get
			Return mVoviciDownloadId
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mVoviciDownloadId Then
				mVoviciDownloadId = value
				PropertyHasChanged("VoviciDownloadId")
			End If		
		End Set
	End Property
	Public Property VoviciSurveyId As String
		Get
			Return mVoviciSurveyId
		End Get
		Set(ByVal value As String)
			If value Is Nothing Then value = String.Empty
			If Not value = mVoviciSurveyId Then
				mVoviciSurveyId = value
				PropertyHasChanged("VoviciSurveyId")
			End If
		End Set
	End Property
	Public Property datLastDownload As Date
		Get
			Return mdatLastDownload
		End Get
		Set(ByVal value As Date)
			If Not value = mdatLastDownload Then
				mdatLastDownload = value
				PropertyHasChanged("datLastDownload")
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
	Public Shared Function NewVoviciDownloadLog As VoviciDownloadLog
		Return New VoviciDownloadLog
	End Function
	
	Public Shared Function [Get](ByVal voviciDownloadId As Integer) As VoviciDownloadLog
		Return VoviciDownloadLogProvider.Instance.SelectVoviciDownloadLog(voviciDownloadId)
	End Function

	Public Shared Function GetAll() As VoviciDownloadLogCollection
		Return VoviciDownloadLogProvider.Instance.SelectAllVoviciDownloadLogs()
    End Function

    Public Shared Function GetBySurveyID(ByVal voviciSurveyId As String) As VoviciDownloadLog
        Return VoviciDownloadLogProvider.Instance.SelectVoviciDownloadLogBySurveyID(voviciSurveyId)
    End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVoviciDownloadId
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
		VoviciDownloadId = VoviciDownloadLogProvider.Instance.InsertVoviciDownloadLog(Me)
	End Sub
	
	Protected Overrides Sub Update
		VoviciDownloadLogProvider.Instance.UpdateVoviciDownloadLog(Me)
	End Sub
	Protected Overrides Sub DeleteImmediate()
		VoviciDownloadLogProvider.Instance.DeleteVoviciDownloadLog(Me)
	End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


