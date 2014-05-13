Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports Nrc.Framework.Data

Namespace Configuration

    Friend Class ParamProvider

#Region " Singleton Implementation "

        Private Shared mInstance As ParamProvider

        Public Shared ReadOnly Property Instance() As ParamProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = New ParamProvider
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region " Constructors "

        Protected Sub New()

        End Sub

#End Region

#Region " Private Properties "

        Private ReadOnly Property Db() As Database
            Get
                Return ParamDBHelper.Db
            End Get
        End Property

#End Region

#Region " Param Procs "

        Private Function PopulateParam(ByVal rdr As SafeDataReader) As Param

            Dim newObject As Param = Param.NewParam
            Dim privateInterface As IParam = newObject
            newObject.BeginPopulate()
            privateInterface.ParamID = rdr.GetInteger("Param_ID")
            newObject.Name = rdr.GetString("strParam_Nm")
            Select Case UCase(rdr.GetString("strParam_Type"))
                Case "N"
                    newObject.Type = ParamTypes.Numeric

                Case "S"
                    newObject.Type = ParamTypes.String

                Case "D"
                    newObject.Type = ParamTypes.Date

                Case Else
                    Throw New ArgumentOutOfRangeException("strParam_Type", "The value '" & rdr.GetString("strParam_Type") & "' is not valid for the strParam_Type column")

            End Select
            newObject.Group = rdr.GetString("strParam_Grp")
            newObject.StringValue = rdr.GetString("strParam_Value")
            newObject.IntegerValue = rdr.GetInteger("numParam_Value")
            newObject.DateValue = rdr.GetDate("datParam_Value")
            newObject.Comment = rdr.GetString("Comments")
            newObject.EndPopulate()

            Return newObject

        End Function

        Public Function [Select](ByVal paramID As Integer) As Param

            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectParam, paramID)
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                If Not rdr.Read Then
                    Return Nothing
                Else
                    Return PopulateParam(rdr)
                End If
            End Using

        End Function

        Public Function SelectByName(ByVal name As String) As Param

            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectParamByName, name)
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                If Not rdr.Read Then
                    Return Nothing
                Else
                    Return PopulateParam(rdr)
                End If
            End Using

        End Function

        Public Function SelectAll() As ParamCollection

            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllParams)
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                Dim list As New ParamCollection

                While rdr.Read
                    list.Add(PopulateParam(rdr))
                End While

                Return list
            End Using

        End Function

#End Region

#Region " SP Declarations "

        Private NotInheritable Class SP

            Private Sub New()

            End Sub

            Public Const SelectParam As String = "dbo.FRM_SelectParameter"
            Public Const SelectParamByName As String = "dbo.FRM_SelectParameterByName"
            Public Const SelectAllParams As String = "dbo.FRM_SelectAllParameters"

        End Class

#End Region

    End Class

End Namespace
