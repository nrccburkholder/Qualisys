VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CQuestion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CQuestion.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This file contains the object definition used to
'\\                 contain a single questionaire.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mlSampleUnitID  As Long
    Private mlQstnCore      As Long
    Private mbMultiResponse As Boolean
    Private malValues()     As Long


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ValueCount
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Returns the total number of response values that
'\\                 currently exist for this question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ValueCount() As Long
    
    ValueCount = UBound(malValues)
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Values
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a specified response value for this
'\\                 question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Values(ByVal lIndex As Long, _
                           ByVal lData As Long)
    
    If lIndex > UBound(malValues) Then
        ReDim Preserve malValues(lIndex) As Long
    End If
    
    malValues(lIndex) = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Values
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a specified response value for this
'\\                 question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Values(ByVal lIndex As Long) As Long
    
    If lIndex < LBound(malValues) Or lIndex > UBound(malValues) Then
        Values = 0
    Else
        Values = malValues(lIndex)
    End If
    
End Property




'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  MultiResponse
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a flag indication whether or not this
'\\                 question allows for multiple responses.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get MultiResponse() As Boolean
    
    MultiResponse = mbMultiResponse
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SampleUnitID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SampleUnit_id for this question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let SampleUnitID(ByVal lData As Long)
    
    mlSampleUnitID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  SampleUnitID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the SampleUnit_id for this question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get SampleUnitID() As Long
    
    SampleUnitID = mlSampleUnitID
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  MultiResponse
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns a flag indication whether or not this
'\\                 question allows for multiple responses.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let MultiResponse(ByVal bData As Boolean)
    
    mbMultiResponse = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QstnCore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the QstnCore for this question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let QstnCore(ByVal lData As Long)
    
    mlQstnCore = lData
    
End Property

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  QstnCore
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    Sets/Returns the QstnCore for this question.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get QstnCore() As Long
    
    QstnCore = mlQstnCore
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Initialize
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 initialization of an instance of this class.  This
'\\                 is where we create the new collection object and
'\\                 set any required variables to thier default values.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Initialize()
    
    ReDim malValues(0) As Long
    
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Routine Name:   Class_Terminate
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   04-05-2000
'\\
'\\ Description:    This routine is called by the VB runtime upon
'\\                 termination of an instance of this class.  This
'\\                 is where we cleanup the collection object.
'\\
'\\ Parameters:
'\\     Name        Type        Description
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Private Sub Class_Terminate()
    
    Erase malValues
    
End Sub


