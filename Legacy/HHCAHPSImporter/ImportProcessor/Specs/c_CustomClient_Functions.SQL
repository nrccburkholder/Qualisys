INSERT INTO TransformLibrary(TransformLibraryName, Code, CreateUser)
VALUES( 'c_HHCAHPS_Functions','Function HCAHPSVisitCMHCloquet(ByVal strVisitType As String,ByVal intLOS as Integer) As String
    If intLOS >= 1 Then
        If UCase(strVisitType) = "INP" Then
            Return "I"
        End If
    End If
	Return ""
End Function', 'nrc\aaliabadi')
