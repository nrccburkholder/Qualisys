VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CReadMethod"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ File Name:      CReadMethod.cls
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    This file contains the definition of the read method
'\\                 class.
'\\
'\\ Required References:
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private mlReadMethodID  As Long     'local copy
    Private msKey           As String   'local copy
    Private mbMultiResponce As Boolean  'local copy
    
    
    
    
    
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  MultiResponce
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the bit associated with this read method
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let MultiResponce(ByVal bData As Boolean)
    
    mbMultiResponce = bData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  MultiResponce
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the bit associated with this read method
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get MultiResponce() As Boolean
    
    MultiResponce = mbMultiResponce
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the key associated with this read method
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let Key(ByVal sData As String)
    
    msKey = sData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  Key
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the key associated with this read method
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get Key() As String
    
    Key = msKey
    
End Property



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ReadMethodID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the id associated with this read method
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Let ReadMethodID(ByVal lData As Long)
    
    mlReadMethodID = lData
    
End Property


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\ Copyright © National Research Corporation
'\\
'\\ Property Name:  ReadMethodID
'\\
'\\ Created By:     Jeffrey J. Fleming
'\\         Date:   03-07-2002
'\\
'\\ Description:    Sets/Returns the id associated with this read method
'\\                 object.
'\\
'\\ Revisions:
'\\     Date        By      Description
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Public Property Get ReadMethodID() As Long
    
    ReadMethodID = mlReadMethodID
    
End Property



