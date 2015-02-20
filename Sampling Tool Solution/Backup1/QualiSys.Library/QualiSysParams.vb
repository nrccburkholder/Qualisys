' This file is modified to include a setting for 1 or 2 person file loading approval process
'  similar class should be created in Qualisys.Qloader.Lybrary

Public NotInheritable Class QualisysParams

    Private Shared mParams As New Hashtable

    'When adding new values to this enumeration remember to modify
    'the GetParamKeyName function to return the appropriate string name
    'Added ApprovalMode by Arman (08/12/08)
    Private Enum ParamKey
        Country
        ApprovalMode
    End Enum
    Public Shared ReadOnly Property ApprovalMode() As ApprovalModes
        Get
            Dim param As QualisysParam = GetParam(ParamKey.ApprovalMode)
            Return CType(param.IntegerValue, ApprovalModes)
        End Get
    End Property
    Public Shared ReadOnly Property CountryCode() As CountryCode
        Get
            Dim param As QualisysParam = GetParam(ParamKey.Country)
            Select Case param.IntegerValue
                Case 1
                    Return CountryCode.UnitedStates
                Case 2
                    Return CountryCode.Canada
                Case Else
                    Throw New InvalidOperationException("The country code '" & param.IntegerValue.ToString & "' is not defined.")
            End Select
        End Get
    End Property

    Private Shared Function GetParam(ByVal key As ParamKey) As QualisysParam
        If mParams(key) Is Nothing Then
            Dim param As QualisysParam = QualisysParam.GetParameter(GetParamKeyName(key))
            If param Is Nothing Then
                Throw New ArgumentException("key", "Cannot load QualiSys Param '" & GetParamKeyName(key) & "'")
            Else
                mParams.Add(key, param)
            End If
        End If

        Return DirectCast(mParams(key), QualisysParam)
    End Function

    Private Sub New()
    End Sub

    ''' <summary>Added "Approval Mode" key by Arman</summary>
    ''' <param name="key"></param>
    ''' <returns></returns>
    Private Shared Function GetParamKeyName(ByVal key As ParamKey) As String
        Select Case key
            Case ParamKey.Country
                Return "Country"
            Case ParamKey.ApprovalMode
                Return "Approval Mode"
            Case Else
                Throw New ArgumentOutOfRangeException("key", "The ParamKey value specified does not have a valid name.")
        End Select
    End Function

    'Private Sub Add(ByVal param As QualiSysParam)
    '    mParams.Add(param.Name, param)
    'End Sub

End Class
