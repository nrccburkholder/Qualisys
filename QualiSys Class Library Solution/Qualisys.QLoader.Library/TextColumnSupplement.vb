Option Explicit On 
Option Strict On

Public Class TextColumnDefaultValue
    'Friend Const CHAR_WIDTH As Integer = 8
    'Friend Const CHAR_HEIGHT As Integer = 15
    Friend Const CHAR_SPACING As Integer = 0
    Friend Const LINE_SPACING As Integer = 0
    Friend Const HEADER_VERTICAL_PADDING As Integer = 2
    Friend Const COLUMN_HORIZONTAL_PADDING As Integer = 2
    Friend Const X_OFFSET As Integer = 2    'I don't know why but for some reason if you say draw a character at (0,0) you get a char at (2,0)
    Friend Const BREAK_LINE_WIDTH As Integer = 1
End Class

Public Structure TextColumnSize
    Dim Left As Integer             'left border coordinate (pixel)
    Dim Right As Integer            'right border coordinate (pixel)
    Dim Width As Integer            'column width (pixel)
    Dim Length As Integer           'character number

    'Dim HScrollPosMax As Integer    '0 - 100
    'if HScrollPos > HScrollPosMax, 
    '  this column is scrolled to the left side invisible area
    'if HScrollPos <= HScrollPosMax,
    '  this column is in either visible area or right side invisible area
End Structure

