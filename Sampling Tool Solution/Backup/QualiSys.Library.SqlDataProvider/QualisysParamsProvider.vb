Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class QualisysParamsProvider
    Inherits Nrc.QualiSys.Library.DataProvider.QualisysParamsProvider

    Private Function PopulateQualisysParam(ByVal rdr As SafeDataReader) As QualisysParam
        Dim newObj As New QualisysParam
        Dim paramType As QualisysParam.ParamDataType
        Select Case rdr.GetString("strParam_Type").ToUpper
            Case "N"
                paramType = QualisysParam.ParamDataType.Numeric
            Case "S"
                paramType = QualisysParam.ParamDataType.String
            Case "D"
                paramType = QualisysParam.ParamDataType.Date
            Case Else
                Throw New ArgumentOutOfRangeException("strParam_Type", "The value '" & rdr.GetString("strParam_Type") & "' is not value for the strParam_Type column")
        End Select
        ReadOnlyAccessor.QualisysParamId(newObj) = rdr.GetInteger("Param_id")
        newObj.Name = rdr.GetString("strParam_nm")
        newObj.Group = rdr.GetString("strParam_grp")
        newObj.Comments = rdr.GetString("Comments")
        newObj.ParamType = paramType
        newObj.IntegerValue = rdr.GetInteger("NumParam_Value")
        newObj.StringValue = rdr.GetString("strParam_Value")
        newObj.DateValue = rdr.GetDate("datParam_Value")
        newObj.ResetDirtyFlag()
        Return newObj
    End Function
    Public Overrides Function [Select](ByVal paramName As String) As QualisysParam
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectQualiSysParam, paramName)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateQualiSysParam(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

End Class
