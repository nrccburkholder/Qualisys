'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data
Imports Nrc.Framework.BusinessLogic.Configuration

Friend Class QUALPRO_PARAMSProvider
    Inherits EnvironmentManager.Library.QualproParamsProvider
    Private Const SettingID As String = "PARAM_ID"
    Private Const SettingName As String = "STRPARAM_NM"
    Private Const SettingType As String = "STRPARAM_TYPE"
    Private Const SettingGroup As String = "STRPARAM_GRP"
    Private Const StringValue As String = "STRPARAM_VALUE"
    Private Const NumericValue As String = "NUMPARAM_VALUE"
    Private Const DateValue As String = "DATPARAM_VALUE"
    Private Const Comments As String = "COMMENTS"

    Private ReadOnly Property Db() As Database
        Get
            If String.IsNullOrEmpty(QualisysConnectionString) Then
                Return Nothing
            End If
            DatabaseHelper.QualisysConnectionString = QualisysConnectionString
            Return DatabaseHelper.Db
        End Get
    End Property

	
#Region " QUALPRO_PARAMS Procs "
    Private Function PopulateQUALPRO_PARAMS(ByVal rdr As SafeDataReader) As QualproParams
        Dim newObject As QualproParams = QualproParams.NewQualproParams
        Dim privateInterface As IQUALPRO_PARAMS = newObject
        newObject.BeginPopulate()
        privateInterface.ParamId = rdr.GetInteger(SettingID)
        newObject.STRPARAM_NM = rdr.GetString(SettingName)
        newObject.STRPARAM_TYPE = rdr.GetString(SettingType)
        newObject.STRPARAM_GRP = rdr.GetString(SettingGroup)
        newObject.STRPARAM_VALUE = rdr.GetString(StringValue)
        newObject.NUMPARAM_VALUE = rdr.GetNullableInteger(NumericValue)
        newObject.DATPARAM_VALUE = rdr.GetNullableDate(DateValue)
        newObject.COMMENTS = rdr.GetString(Comments)
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectQUALPRO_PARAMS(ByVal ParamID As Integer) As QualproParams
        If EnvironmentIsSetupInCorrectly() Then Return Nothing
        'Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQUALPRO_PARAMS, pARAMId)
        Using cmd As DbCommand = Db.GetSqlStringCommand("Select * from QUALPRO_PARAMS Where Param_ID = @ParamID ")
            Dim param As New SqlClient.SqlParameter("ParamID", SqlDbType.VarChar)
            param.Value = ParamID
            cmd.Parameters.Add(param)

            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                If Not rdr.Read Then
                    Return Nothing
                Else
                    Return PopulateQUALPRO_PARAMS(rdr)
                End If
            End Using
        End Using
    End Function
    Public Overrides Function SelectParamByName(ByVal ParamName As String) As QualproParams
        If EnvironmentIsSetupInCorrectly() Then Return Nothing
        'Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQUALPRO_PARAMSByName, ParamName)
        Using cmd As DbCommand = Db.GetSqlStringCommand("Select * from QUALPRO_PARAMS Where strParam_Nm = @ParamName ")
            Dim param As New SqlClient.SqlParameter("ParamName", SqlDbType.VarChar)
            param.Value = ParamName
            cmd.Parameters.Add(param)

            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                If Not rdr.Read Then
                    Return Nothing
                Else
                    Return PopulateQUALPRO_PARAMS(rdr)
                End If
            End Using

        End Using
    End Function
    Public Overrides Function SelectParamsLike(ByVal partialName As String) As QUALPRO_PARAMSCollection
        If EnvironmentIsSetupInCorrectly() Then Return Nothing
        Using cmd As DbCommand = Db.GetSqlStringCommand("Select * from QUALPRO_PARAMS Where strParam_Nm Like '%'+@partialName+'%'")
            Dim param As New SqlClient.SqlParameter("partialName", SqlDbType.VarChar)
            param.Value = partialName
            cmd.Parameters.Add(param)
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                Return PopulateCollection(Of QUALPRO_PARAMSCollection, QualproParams)(rdr, AddressOf PopulateQUALPRO_PARAMS)
            End Using
        End Using
    End Function

    Public Overrides Function SelectAllQUALPRO_PARAMS() As QUALPRO_PARAMSCollection
        If EnvironmentIsSetupInCorrectly() Then Return Nothing
        Using cmd As DbCommand = Db.GetSqlStringCommand("Select * from QUALPRO_PARAMS ")
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                Return PopulateCollection(Of QUALPRO_PARAMSCollection, QualproParams)(rdr, AddressOf PopulateQUALPRO_PARAMS)
            End Using
        End Using
    End Function

    Public Overrides Function InsertQUALPRO_PARAMS(ByVal instance As QualproParams) As Integer
        'Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertQUALPRO_PARAMS, instance.ParamName, instance.Param_Type, instance.ParamGroup, instance.strParamValue, instance.NumParamValue, SafeDataReader.ToDBValue(instance.DatParamValue), instance.Comments)
        'Return ExecuteInteger(cmd)
        Dim SettingDateValue As Object = IIf(instance.DATPARAM_VALUE.HasValue, instance.DATPARAM_VALUE, DBNull.Value)
        Dim NumValue As Object = IIf(instance.NUMPARAM_VALUE.HasValue, instance.NUMPARAM_VALUE, DBNull.Value)
        Try
            Using cmd As DbCommand = Db.GetSqlStringCommand( _
            " INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, " & _
            "                                strParam_Value, numParam_Value, datParam_Value, Comments)" & _
            "    VALUES (@strParam_Nm, @strParam_Type, @strParam_Grp, @strParam_Value, @numParam_Value, " & _
            "            @datParam_Value, @Comments) " & _
            " SELECT SCOPE_IDENTITY()   ")
                Dim Params As System.Data.SqlClient.SqlParameterCollection = cmd.Parameters

                Params.AddWithValue(SettingName, instance.STRPARAM_NM)
                Params.AddWithValue(SettingType, instance.STRPARAM_TYPE)
                Params.AddWithValue(SettingGroup, instance.STRPARAM_GRP)
                Params.AddWithValue(StringValue, instance.STRPARAM_VALUE)
                Params.AddWithValue(NumericValue, NumValue)
                Params.AddWithValue(DateValue, SettingDateValue)
                Params.AddWithValue(Comments, instance.COMMENTS)

                Return ExecuteInteger(cmd)
            End Using

        Catch ex As Exception
            Throw New Exception("Failed to insert Into QUALPRO_PARAMS Table", ex)
        End Try
    End Function

    Public Overrides Sub UpdateQUALPRO_PARAMS(ByVal instance As QualproParams)
        Dim UpdateStatementBuilder As New Text.StringBuilder
        UpdateStatementBuilder.Append("UPDATE QUALPRO_PARAMS Set ")
        UpdateStatementBuilder.AppendFormat(" STRPARAM_NM = '{0}',", instance.STRPARAM_NM)
        UpdateStatementBuilder.AppendFormat(" STRPARAM_TYPE = '{0}',", instance.STRPARAM_TYPE)
        UpdateStatementBuilder.AppendFormat(" STRPARAM_GRP = '{0}',", instance.STRPARAM_GRP)
        UpdateStatementBuilder.AppendFormat(" STRPARAM_VALUE = '{0}',", instance.STRPARAM_VALUE)
        UpdateStatementBuilder.AppendFormat(" NUMPARAM_VALUE = {0},", DatabaseHelper.GetStringValue(instance.NUMPARAM_VALUE))
        UpdateStatementBuilder.AppendFormat(" DATPARAM_VALUE = {0},", DatabaseHelper.GetStringValue(instance.DATPARAM_VALUE))
        UpdateStatementBuilder.AppendFormat(" COMMENTS = '{0}'", instance.COMMENTS)
        UpdateStatementBuilder.AppendFormat(" WHERE Param_ID = {0} ", instance.PARAM_ID)
        'Using cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateQUALPRO_PARAMS, instance.STRPARAM_NM, instance.STRPARAM_TYPE, instance.STRPARAM_GRP, instance.STRPARAM_VALUE, instance.NUMPARAM_VALUE, SafeDataReader.ToDBValue(instance.DATPARAM_VALUE), instance.COMMENTS)

        Using cmd As DbCommand = Db.GetSqlStringCommand(UpdateStatementBuilder.ToString)
            ExecuteNonQuery(cmd)
        End Using
    End Sub


    Public Overrides Sub DeleteQualproParams(ByVal QUALPRO_PARAMS As QualproParams)
        If QUALPRO_PARAMS IsNot Nothing Then
            Using cmd As DbCommand = Db.GetSqlStringCommand("Delete from QUALPRO_PARAMS Where Param_ID = @ParamID ")
                Dim param As New SqlClient.SqlParameter("ParamID", SqlDbType.VarChar)
                param.Value = QUALPRO_PARAMS.PARAM_ID
                cmd.Parameters.Add(param)
                ExecuteNonQuery(cmd)
            End Using
        End If
    End Sub

#End Region
    Private Function EnvironmentIsSetupInCorrectly() As Boolean
        Try
            If Db Is Nothing Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Return True
        End Try
    End Function

End Class
