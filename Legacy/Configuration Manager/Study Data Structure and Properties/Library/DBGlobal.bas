Attribute VB_Name = "DBGlobal"
Option Explicit

Public Function DB2VB_Date(rs As ADODB.Recordset, fieldname As String) As Date
    If IsNull(rs(fieldname)) Then
        DB2VB_Date = 0
    Else
        DB2VB_Date = rs(fieldname)
    End If
End Function

Public Function VB2DB_Date(aVal As Date) As Variant
    VB2DB_Date = IIf((aVal = 0), Null, aVal)
End Function

Public Function DB2VB_Long(rs As ADODB.Recordset, fieldname As String) As Long
    If IsNull(rs(fieldname)) Then
        DB2VB_Long = -1
    Else
        DB2VB_Long = rs(fieldname)
    End If
End Function

Public Function VB2DB_Long(aVal As Long) As Variant
    VB2DB_Long = IIf((aVal = -1), Null, aVal)
End Function

Public Function DB2VB_Amount(rs As ADODB.Recordset, fieldname As String) As Currency
    If IsNull(rs(fieldname)) Then
        DB2VB_Amount = -1
    Else
        DB2VB_Amount = rs(fieldname)
    End If
End Function

Public Function VB2DB_Amount(aVal As Currency) As Variant
    VB2DB_Amount = IIf((aVal = -1), Null, aVal)
End Function

Public Function DB2VB_Boolean(rs As ADODB.Recordset, fieldname As String) As Long
    If IsNull(rs(fieldname)) Then
        DB2VB_Boolean = 0
    Else
        DB2VB_Boolean = rs(fieldname)
    End If
End Function
