Attribute VB_Name = "StudyObjectGlobals"
Option Explicit

' lookup relation types
Public Const G_FOREIGN = "Foreign"
Public Const G_LOOKUP = "Lookup"
Public Const G_DETAIL = "Detail"
Public Const G_FOREIGN_CHAR = "F"
Public Const G_LOOKUP_CHAR = "L"
Public Const G_DETAIL_CHAR = "D"

' Pre defined table names and key fields
Public Const POPULATION_TABLE = "POPULATION"
Public Const ENCOUNTER_TABLE = "ENCOUNTER"
Public Const PROVIDER_TABLE = "PROVIDER"
Public Const POPULATION_TABLE_KEY = "pop_id"
Public Const ENCOUNTER_TABLE_KEY = "enc_id"
Public Const PROVIDER_TABLE_KEY = "prov_id"

Public Const FIELD_NEW_RECORD_DATE = "'FieldNewRecordDate'"
Public Const FIELD_LANGUAGE_CODE = "'FieldLanguageCode'"
Public Const FIELD_AGE = "'FieldAge'"

Public Const FIELD_GENDER = "'FieldGender'"
Public Const FIELD_POPID = "'FieldPopID'"

Global cn As New ADODB.Connection
Global strConnection As String
Global rsUsers As New ADODB.Recordset
Global AccountDirector As String
Global ADEmpID As Integer

Public Sub Main()
    Dim o As New QualiSysFunctions.Library
    
    strConnection = o.GetDBString
    cn.ConnectionTimeout = 0
    cn.Open strConnection
    cn.CommandTimeout = 0
    
    Set o = Nothing
End Sub

Public Function BooleanToString(aValue As Boolean) As String
    If aValue = True Then
        BooleanToString = "True"
    Else
        BooleanToString = "False"
    End If
End Function
