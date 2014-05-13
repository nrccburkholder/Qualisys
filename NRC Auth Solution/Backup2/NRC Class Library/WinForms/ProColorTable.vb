Imports System.Drawing

Namespace WinForms

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC Class Library
    ''' Class	 : WinForms.ProColorTable
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Supports the ProColors class
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	8/18/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Friend Class ProColorTable

#Region " ProColors Enum "
        Friend Enum ProColor
            msocbvcrCBBdrOuterDocked
            msocbvcrCBBdrOuterFloating
            msocbvcrCBBkgd
            msocbvcrCBCtlBdrMouseDown
            msocbvcrCBCtlBdrMouseOver
            msocbvcrCBCtlBdrSelected
            msocbvcrCBCtlBdrSelectedMouseOver
            msocbvcrCBCtlBkgd
            msocbvcrCBCtlBkgdLight
            msocbvcrCBCtlBkgdMouseDown
            msocbvcrCBCtlBkgdMouseOver
            msocbvcrCBCtlBkgdSelected
            msocbvcrCBCtlBkgdSelectedMouseOver
            msocbvcrCBCtlText
            msocbvcrCBCtlTextDisabled
            msocbvcrCBCtlTextLight
            msocbvcrCBCtlTextMouseDown
            msocbvcrCBCtlTextMouseOver
            msocbvcrCBDockSeparatorLine
            msocbvcrCBDragHandle
            msocbvcrCBDragHandleShadow
            msocbvcrCBDropDownArrow
            msocbvcrCBGradMainMenuHorzBegin
            msocbvcrCBGradMainMenuHorzEnd
            msocbvcrCBGradMenuIconBkgdDroppedBegin
            msocbvcrCBGradMenuIconBkgdDroppedEnd
            msocbvcrCBGradMenuIconBkgdDroppedMiddle
            msocbvcrCBGradMenuTitleBkgdBegin
            msocbvcrCBGradMenuTitleBkgdEnd
            msocbvcrCBGradMouseDownBegin
            msocbvcrCBGradMouseDownEnd
            msocbvcrCBGradMouseDownMiddle
            msocbvcrCBGradMouseOverBegin
            msocbvcrCBGradMouseOverEnd
            msocbvcrCBGradMouseOverMiddle
            msocbvcrCBGradOptionsBegin
            msocbvcrCBGradOptionsEnd
            msocbvcrCBGradOptionsMiddle
            msocbvcrCBGradOptionsMouseOverBegin
            msocbvcrCBGradOptionsMouseOverEnd
            msocbvcrCBGradOptionsMouseOverMiddle
            msocbvcrCBGradOptionsSelectedBegin
            msocbvcrCBGradOptionsSelectedEnd
            msocbvcrCBGradOptionsSelectedMiddle
            msocbvcrCBGradSelectedBegin
            msocbvcrCBGradSelectedEnd
            msocbvcrCBGradSelectedMiddle
            msocbvcrCBGradVertBegin
            msocbvcrCBGradVertEnd
            msocbvcrCBGradVertMiddle
            msocbvcrCBIconDisabledDark
            msocbvcrCBIconDisabledLight
            msocbvcrCBLabelBkgnd
            msocbvcrCBLowColorIconDisabled
            msocbvcrCBMainMenuBkgd
            msocbvcrCBMenuBdrOuter
            msocbvcrCBMenuBkgd
            msocbvcrCBMenuCtlText
            msocbvcrCBMenuCtlTextDisabled
            msocbvcrCBMenuIconBkgd
            msocbvcrCBMenuIconBkgdDropped
            msocbvcrCBMenuShadow
            msocbvcrCBMenuSplitArrow
            msocbvcrCBOptionsButtonShadow
            msocbvcrCBShadow
            msocbvcrCBSplitterLine
            msocbvcrCBSplitterLineLight
            msocbvcrCBTearOffHandle
            msocbvcrCBTearOffHandleMouseOver
            msocbvcrCBTitleBkgd
            msocbvcrCBTitleText
            msocbvcrDisabledFocuslessHighlightedText
            msocbvcrDisabledHighlightedText
            msocbvcrDlgGroupBoxText
            msocbvcrDocTabBdr
            msocbvcrDocTabBdrDark
            msocbvcrDocTabBdrDarkMouseDown
            msocbvcrDocTabBdrDarkMouseOver
            msocbvcrDocTabBdrLight
            msocbvcrDocTabBdrLightMouseDown
            msocbvcrDocTabBdrLightMouseOver
            msocbvcrDocTabBdrMouseDown
            msocbvcrDocTabBdrMouseOver
            msocbvcrDocTabBdrSelected
            msocbvcrDocTabBkgd
            msocbvcrDocTabBkgdMouseDown
            msocbvcrDocTabBkgdMouseOver
            msocbvcrDocTabBkgdSelected
            msocbvcrDocTabText
            msocbvcrDocTabTextMouseDown
            msocbvcrDocTabTextMouseOver
            msocbvcrDocTabTextSelected
            msocbvcrDWActiveTabBkgd
            msocbvcrDWActiveTabText
            msocbvcrDWActiveTabTextDisabled
            msocbvcrDWInactiveTabBkgd
            msocbvcrDWInactiveTabText
            msocbvcrDWTabBkgdMouseDown
            msocbvcrDWTabBkgdMouseOver
            msocbvcrDWTabTextMouseDown
            msocbvcrDWTabTextMouseOver
            msocbvcrFocuslessHighlightedBkgd
            msocbvcrFocuslessHighlightedText
            msocbvcrGDHeaderBdr
            msocbvcrGDHeaderBkgd
            msocbvcrGDHeaderCellBdr
            msocbvcrGDHeaderCellBkgd
            msocbvcrGDHeaderCellBkgdSelected
            msocbvcrGDHeaderSeeThroughSelection
            msocbvcrGSPDarkBkgd
            msocbvcrGSPGroupContentDarkBkgd
            msocbvcrGSPGroupContentLightBkgd
            msocbvcrGSPGroupContentText
            msocbvcrGSPGroupContentTextDisabled
            msocbvcrGSPGroupHeaderDarkBkgd
            msocbvcrGSPGroupHeaderLightBkgd
            msocbvcrGSPGroupHeaderText
            msocbvcrGSPGroupline
            msocbvcrGSPHyperlink
            msocbvcrGSPLightBkgd
            msocbvcrHyperlink
            msocbvcrHyperlinkFollowed
            msocbvcrJotNavUIBdr
            msocbvcrJotNavUIGradBegin
            msocbvcrJotNavUIGradEnd
            msocbvcrJotNavUIGradMiddle
            msocbvcrJotNavUIText
            msocbvcrListHeaderArrow
            msocbvcrNetLookBkgnd
            msocbvcrOABBkgd
            msocbvcrOBBkgdBdr
            msocbvcrOBBkgdBdrContrast
            msocbvcrOGMDIParentWorkspaceBkgd
            msocbvcrOGRulerActiveBkgd
            msocbvcrOGRulerBdr
            msocbvcrOGRulerBkgd
            msocbvcrOGRulerInactiveBkgd
            msocbvcrOGRulerTabBoxBdr
            msocbvcrOGRulerTabBoxBdrHighlight
            msocbvcrOGRulerTabStopTicks
            msocbvcrOGRulerText
            msocbvcrOGTaskPaneGroupBoxHeaderBkgd
            msocbvcrOGWorkspaceBkgd
            msocbvcrOLKFlagNone
            msocbvcrOLKFolderbarDark
            msocbvcrOLKFolderbarLight
            msocbvcrOLKFolderbarText
            msocbvcrOLKGridlines
            msocbvcrOLKGroupLine
            msocbvcrOLKGroupNested
            msocbvcrOLKGroupShaded
            msocbvcrOLKGroupText
            msocbvcrOLKIconBar
            msocbvcrOLKInfoBarBkgd
            msocbvcrOLKInfoBarText
            msocbvcrOLKPreviewPaneLabelText
            msocbvcrOLKTodayIndicatorDark
            msocbvcrOLKTodayIndicatorLight
            msocbvcrOLKWBActionDividerLine
            msocbvcrOLKWBButtonDark
            msocbvcrOLKWBButtonLight
            msocbvcrOLKWBDarkOutline
            msocbvcrOLKWBFoldersBackground
            msocbvcrOLKWBHoverButtonDark
            msocbvcrOLKWBHoverButtonLight
            msocbvcrOLKWBLabelText
            msocbvcrOLKWBPressedButtonDark
            msocbvcrOLKWBPressedButtonLight
            msocbvcrOLKWBSelectedButtonDark
            msocbvcrOLKWBSelectedButtonLight
            msocbvcrOLKWBSplitterDark
            msocbvcrOLKWBSplitterLight
            msocbvcrPlacesBarBkgd
            msocbvcrPPOutlineThumbnailsPaneTabAreaBkgd
            msocbvcrPPOutlineThumbnailsPaneTabBdr
            msocbvcrPPOutlineThumbnailsPaneTabInactiveBkgd
            msocbvcrPPOutlineThumbnailsPaneTabText
            msocbvcrPPSlideBdrActiveSelected
            msocbvcrPPSlideBdrActiveSelectedMouseOver
            msocbvcrPPSlideBdrInactiveSelected
            msocbvcrPPSlideBdrMouseOver
            msocbvcrPubPrintDocScratchPageBkgd
            msocbvcrPubWebDocScratchPageBkgd
            msocbvcrSBBdr
            msocbvcrScrollbarBkgd
            msocbvcrToastGradBegin
            msocbvcrToastGradEnd
            msocbvcrWPBdrInnerDocked
            msocbvcrWPBdrOuterDocked
            msocbvcrWPBdrOuterFloating
            msocbvcrWPBkgd
            msocbvcrWPCtlBdr
            msocbvcrWPCtlBdrDefault
            msocbvcrWPCtlBdrDisabled
            msocbvcrWPCtlBkgd
            msocbvcrWPCtlBkgdDisabled
            msocbvcrWPCtlText
            msocbvcrWPCtlTextDisabled
            msocbvcrWPCtlTextMouseDown
            msocbvcrWPGroupline
            msocbvcrWPInfoTipBkgd
            msocbvcrWPInfoTipText
            msocbvcrWPNavBarBkgnd
            msocbvcrWPText
            msocbvcrWPTextDisabled
            msocbvcrWPTitleBkgdActive
            msocbvcrWPTitleBkgdInactive
            msocbvcrWPTitleTextActive
            msocbvcrWPTitleTextInactive
            msocbvcrXLFormulaBarBkgd
        End Enum
#End Region

        Private professionalRGB As Hashtable

        Private Sub InitColorTable(ByVal table As Hashtable)
            'Determine the current theme and initialize the correct color table

            Select Case ThemeInfo.CurrentTheme
                Case ThemeInfo.XPTheme.Luna_Homestead
                    Me.InitOliveLunaColors(table)
                Case ThemeInfo.XPTheme.Luna_Metallic
                    Me.InitSilverLunaColors(table)
                Case ThemeInfo.XPTheme.Luna_NormalColor
                    Me.InitBlueLunaColors(table)
                Case Else
                    Me.InitSilverLunaColors(table)
            End Select
        End Sub

        Private ReadOnly Property ColorTable() As Hashtable
            Get
                If professionalRGB Is Nothing Then
                    professionalRGB = New Hashtable(212)
                    InitColorTable(professionalRGB)
                End If

                Return professionalRGB
            End Get
        End Property

#Region " InitOliveLunaColors "
        Friend Sub InitOliveLunaColors(ByRef rgbTable As Hashtable)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = Color.FromArgb(81, 94, 51)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = Color.FromArgb(81, 94, 51)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterFloating) = Color.FromArgb(116, 134, 94)
            rgbTable.Item(ProColor.msocbvcrCBBkgd) = Color.FromArgb(209, 222, 173)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseDown) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelected) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelectedMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgd) = Color.FromArgb(209, 222, 173)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelected) = Color.FromArgb(255, 192, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelectedMouseOver) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextDisabled) = Color.FromArgb(141, 141, 141)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextLight) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBDockSeparatorLine) = Color.FromArgb(96, 119, 66)
            rgbTable.Item(ProColor.msocbvcrCBDragHandle) = Color.FromArgb(81, 94, 51)
            rgbTable.Item(ProColor.msocbvcrCBDragHandleShadow) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBDropDownArrow) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzBegin) = Color.FromArgb(217, 217, 167)
            rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzEnd) = Color.FromArgb(242, 241, 228)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedBegin) = Color.FromArgb(230, 230, 209)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedEnd) = Color.FromArgb(160, 177, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedMiddle) = Color.FromArgb(186, 201, 143)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdBegin) = Color.FromArgb(237, 240, 214)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdEnd) = Color.FromArgb(181, 196, 143)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownBegin) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownEnd) = Color.FromArgb(255, 223, 154)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownMiddle) = Color.FromArgb(255, 177, 109)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverBegin) = Color.FromArgb(255, 255, 222)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverEnd) = Color.FromArgb(255, 203, 136)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverMiddle) = Color.FromArgb(255, 225, 172)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsBegin) = Color.FromArgb(186, 204, 150)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsEnd) = Color.FromArgb(96, 119, 107)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMiddle) = Color.FromArgb(141, 160, 107)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverBegin) = Color.FromArgb(255, 255, 222)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverEnd) = Color.FromArgb(255, 193, 118)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverMiddle) = Color.FromArgb(255, 225, 172)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedBegin) = Color.FromArgb(254, 140, 73)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedEnd) = Color.FromArgb(255, 221, 152)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedMiddle) = Color.FromArgb(255, 184, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedBegin) = Color.FromArgb(255, 223, 154)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedEnd) = Color.FromArgb(255, 166, 76)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedMiddle) = Color.FromArgb(255, 195, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradVertBegin) = Color.FromArgb(255, 255, 237)
            rgbTable.Item(ProColor.msocbvcrCBGradVertEnd) = Color.FromArgb(181, 196, 143)
            rgbTable.Item(ProColor.msocbvcrCBGradVertMiddle) = Color.FromArgb(206, 220, 167)
            rgbTable.Item(ProColor.msocbvcrCBIconDisabledDark) = Color.FromArgb(131, 144, 113)
            rgbTable.Item(ProColor.msocbvcrCBIconDisabledLight) = Color.FromArgb(243, 244, 240)
            rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = Color.FromArgb(218, 227, 187)
            rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = Color.FromArgb(218, 227, 187)
            rgbTable.Item(ProColor.msocbvcrCBLowColorIconDisabled) = Color.FromArgb(159, 174, 122)
            rgbTable.Item(ProColor.msocbvcrCBMainMenuBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrCBMenuBdrOuter) = Color.FromArgb(117, 141, 94)
            rgbTable.Item(ProColor.msocbvcrCBMenuBkgd) = Color.FromArgb(244, 244, 238)
            rgbTable.Item(ProColor.msocbvcrCBMenuCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBMenuCtlTextDisabled) = Color.FromArgb(141, 141, 141)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgd) = Color.FromArgb(216, 227, 182)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = Color.FromArgb(173, 181, 157)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = Color.FromArgb(173, 181, 157)
            rgbTable.Item(ProColor.msocbvcrCBMenuShadow) = Color.FromArgb(134, 148, 108)
            rgbTable.Item(ProColor.msocbvcrCBMenuSplitArrow) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBOptionsButtonShadow) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBShadow) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrCBSplitterLine) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrCBSplitterLineLight) = Color.FromArgb(244, 247, 222)
            rgbTable.Item(ProColor.msocbvcrCBTearOffHandle) = Color.FromArgb(197, 212, 159)
            rgbTable.Item(ProColor.msocbvcrCBTearOffHandleMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBTitleBkgd) = Color.FromArgb(116, 134, 94)
            rgbTable.Item(ProColor.msocbvcrCBTitleText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDisabledFocuslessHighlightedText) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrDisabledHighlightedText) = Color.FromArgb(220, 224, 208)
            rgbTable.Item(ProColor.msocbvcrDlgGroupBoxText) = Color.FromArgb(153, 84, 10)
            rgbTable.Item(ProColor.msocbvcrDocTabBdr) = Color.FromArgb(96, 119, 107)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDark) = Color.FromArgb(176, 194, 140)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseDown) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseDown) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseDown) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(63, 93, 56)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrSelected) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgd) = Color.FromArgb(218, 227, 187)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdSelected) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDocTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextSelected) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = Color.FromArgb(218, 227, 187)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = Color.FromArgb(218, 227, 187)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = Color.FromArgb(183, 198, 145)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = Color.FromArgb(183, 198, 145)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDWTabTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrGDHeaderBdr) = Color.FromArgb(191, 191, 223)
            rgbTable.Item(ProColor.msocbvcrGDHeaderBkgd) = Color.FromArgb(239, 235, 222)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBdr) = Color.FromArgb(126, 125, 104)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgd) = Color.FromArgb(239, 235, 222)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgdSelected) = Color.FromArgb(255, 192, 111)
            rgbTable.Item(ProColor.msocbvcrGDHeaderSeeThroughSelection) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = Color.FromArgb(159, 171, 128)
            rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = Color.FromArgb(159, 171, 128)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentDarkBkgd) = Color.FromArgb(217, 227, 187)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentLightBkgd) = Color.FromArgb(230, 234, 208)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentTextDisabled) = Color.FromArgb(150, 145, 133)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderDarkBkgd) = Color.FromArgb(161, 176, 128)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderLightBkgd) = Color.FromArgb(210, 223, 174)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = Color.FromArgb(90, 107, 70)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = Color.FromArgb(90, 107, 70)
            rgbTable.Item(ProColor.msocbvcrGSPGroupline) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrGSPGroupline) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrGSPHyperlink) = Color.FromArgb(0, 61, 178)
            rgbTable.Item(ProColor.msocbvcrGSPLightBkgd) = Color.FromArgb(243, 242, 231)
            rgbTable.Item(ProColor.msocbvcrHyperlink) = Color.FromArgb(0, 61, 178)
            rgbTable.Item(ProColor.msocbvcrHyperlinkFollowed) = Color.FromArgb(170, 0, 170)
            rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = Color.FromArgb(217, 217, 167)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = Color.FromArgb(217, 217, 167)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradEnd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = Color.FromArgb(242, 241, 228)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = Color.FromArgb(242, 241, 228)
            rgbTable.Item(ProColor.msocbvcrJotNavUIText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrListHeaderArrow) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrNetLookBkgnd) = Color.FromArgb(255, 255, 237)
            rgbTable.Item(ProColor.msocbvcrOABBkgd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOBBkgdBdr) = Color.FromArgb(211, 211, 211)
            rgbTable.Item(ProColor.msocbvcrOBBkgdBdrContrast) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOGMDIParentWorkspaceBkgd) = Color.FromArgb(151, 160, 123)
            rgbTable.Item(ProColor.msocbvcrOGRulerActiveBkgd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGRulerBdr) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrOGRulerBkgd) = Color.FromArgb(226, 231, 191)
            rgbTable.Item(ProColor.msocbvcrOGRulerInactiveBkgd) = Color.FromArgb(171, 192, 138)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdr) = Color.FromArgb(117, 141, 94)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdrHighlight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabStopTicks) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOGRulerText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrOGTaskPaneGroupBoxHeaderBkgd) = Color.FromArgb(218, 227, 187)
            rgbTable.Item(ProColor.msocbvcrOGWorkspaceBkgd) = Color.FromArgb(151, 160, 123)
            rgbTable.Item(ProColor.msocbvcrOLKFlagNone) = Color.FromArgb(242, 240, 228)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarDark) = Color.FromArgb(96, 119, 66)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarLight) = Color.FromArgb(175, 192, 130)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKGridlines) = Color.FromArgb(234, 233, 225)
            rgbTable.Item(ProColor.msocbvcrOLKGroupLine) = Color.FromArgb(181, 196, 143)
            rgbTable.Item(ProColor.msocbvcrOLKGroupNested) = Color.FromArgb(253, 238, 201)
            rgbTable.Item(ProColor.msocbvcrOLKGroupShaded) = Color.FromArgb(175, 186, 145)
            rgbTable.Item(ProColor.msocbvcrOLKGroupText) = Color.FromArgb(115, 137, 84)
            rgbTable.Item(ProColor.msocbvcrOLKIconBar) = Color.FromArgb(253, 247, 233)
            rgbTable.Item(ProColor.msocbvcrOLKInfoBarBkgd) = Color.FromArgb(151, 160, 123)
            rgbTable.Item(ProColor.msocbvcrOLKInfoBarText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKPreviewPaneLabelText) = Color.FromArgb(151, 160, 123)
            rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorDark) = Color.FromArgb(187, 85, 3)
            rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorLight) = Color.FromArgb(251, 200, 79)
            rgbTable.Item(ProColor.msocbvcrOLKWBActionDividerLine) = Color.FromArgb(200, 212, 172)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonDark) = Color.FromArgb(176, 191, 138)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = Color.FromArgb(234, 240, 207)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = Color.FromArgb(234, 240, 207)
            rgbTable.Item(ProColor.msocbvcrOLKWBDarkOutline) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrOLKWBFoldersBackground) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonDark) = Color.FromArgb(247, 190, 87)
            rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonLight) = Color.FromArgb(255, 255, 220)
            rgbTable.Item(ProColor.msocbvcrOLKWBLabelText) = Color.FromArgb(50, 69, 105)
            rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonDark) = Color.FromArgb(248, 222, 128)
            rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonLight) = Color.FromArgb(232, 127, 8)
            rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonDark) = Color.FromArgb(238, 147, 17)
            rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonLight) = Color.FromArgb(251, 230, 148)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterDark) = Color.FromArgb(64, 81, 59)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = Color.FromArgb(120, 142, 111)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = Color.FromArgb(120, 142, 111)
            rgbTable.Item(ProColor.msocbvcrPlacesBarBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabAreaBkgd) = Color.FromArgb(242, 240, 228)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabBdr) = Color.FromArgb(96, 128, 88)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabInactiveBkgd) = Color.FromArgb(206, 220, 167)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelected) = Color.FromArgb(107, 129, 107)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelectedMouseOver) = Color.FromArgb(107, 129, 107)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrInactiveSelected) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrMouseOver) = Color.FromArgb(107, 129, 107)
            rgbTable.Item(ProColor.msocbvcrPubPrintDocScratchPageBkgd) = Color.FromArgb(151, 160, 123)
            rgbTable.Item(ProColor.msocbvcrPubWebDocScratchPageBkgd) = Color.FromArgb(193, 198, 176)
            rgbTable.Item(ProColor.msocbvcrSBBdr) = Color.FromArgb(211, 211, 211)
            rgbTable.Item(ProColor.msocbvcrScrollbarBkgd) = Color.FromArgb(249, 249, 247)
            rgbTable.Item(ProColor.msocbvcrToastGradBegin) = Color.FromArgb(237, 242, 212)
            rgbTable.Item(ProColor.msocbvcrToastGradEnd) = Color.FromArgb(191, 206, 153)
            rgbTable.Item(ProColor.msocbvcrWPBdrInnerDocked) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrWPBdrOuterDocked) = Color.FromArgb(242, 241, 228)
            rgbTable.Item(ProColor.msocbvcrWPBdrOuterFloating) = Color.FromArgb(116, 134, 94)
            rgbTable.Item(ProColor.msocbvcrWPBkgd) = Color.FromArgb(243, 242, 231)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdr) = Color.FromArgb(164, 185, 127)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDisabled) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrWPCtlBkgd) = Color.FromArgb(197, 212, 159)
            rgbTable.Item(ProColor.msocbvcrWPCtlBkgdDisabled) = Color.FromArgb(222, 222, 222)
            rgbTable.Item(ProColor.msocbvcrWPCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlTextDisabled) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrWPCtlTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPGroupline) = Color.FromArgb(188, 187, 177)
            rgbTable.Item(ProColor.msocbvcrWPInfoTipBkgd) = Color.FromArgb(255, 255, 204)
            rgbTable.Item(ProColor.msocbvcrWPInfoTipText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPNavBarBkgnd) = Color.FromArgb(116, 134, 94)
            rgbTable.Item(ProColor.msocbvcrWPText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPTextDisabled) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrWPTitleBkgdActive) = Color.FromArgb(216, 227, 182)
            rgbTable.Item(ProColor.msocbvcrWPTitleBkgdInactive) = Color.FromArgb(188, 205, 131)
            rgbTable.Item(ProColor.msocbvcrWPTitleTextActive) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPTitleTextInactive) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrXLFormulaBarBkgd) = Color.FromArgb(217, 217, 167)
        End Sub

#End Region

#Region " InitSilverLunaColors "
        Friend Sub InitSilverLunaColors(ByRef rgbTable As Hashtable)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = Color.FromArgb(173, 174, 193)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterFloating) = Color.FromArgb(122, 121, 153)
            rgbTable.Item(ProColor.msocbvcrCBBkgd) = Color.FromArgb(219, 218, 228)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseDown) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelected) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelectedMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgd) = Color.FromArgb(219, 218, 228)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelected) = Color.FromArgb(255, 192, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelectedMouseOver) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextDisabled) = Color.FromArgb(141, 141, 141)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextLight) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBDockSeparatorLine) = Color.FromArgb(110, 109, 143)
            rgbTable.Item(ProColor.msocbvcrCBDragHandle) = Color.FromArgb(84, 84, 117)
            rgbTable.Item(ProColor.msocbvcrCBDragHandleShadow) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBDropDownArrow) = Color.FromArgb(224, 223, 227)
            rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzBegin) = Color.FromArgb(215, 215, 229)
            rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzEnd) = Color.FromArgb(243, 243, 247)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedBegin) = Color.FromArgb(215, 215, 226)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedEnd) = Color.FromArgb(118, 116, 151)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedMiddle) = Color.FromArgb(184, 185, 202)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdBegin) = Color.FromArgb(232, 233, 242)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdEnd) = Color.FromArgb(172, 170, 194)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownBegin) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownEnd) = Color.FromArgb(255, 223, 154)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownMiddle) = Color.FromArgb(255, 177, 109)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverBegin) = Color.FromArgb(255, 255, 222)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverEnd) = Color.FromArgb(255, 203, 136)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverMiddle) = Color.FromArgb(255, 225, 172)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsBegin) = Color.FromArgb(186, 185, 206)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsEnd) = Color.FromArgb(118, 116, 146)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMiddle) = Color.FromArgb(156, 155, 180)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverBegin) = Color.FromArgb(255, 255, 222)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverEnd) = Color.FromArgb(255, 193, 118)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverMiddle) = Color.FromArgb(255, 225, 172)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedBegin) = Color.FromArgb(254, 140, 73)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedEnd) = Color.FromArgb(255, 221, 152)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedMiddle) = Color.FromArgb(255, 184, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedBegin) = Color.FromArgb(255, 223, 154)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedEnd) = Color.FromArgb(255, 166, 76)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedMiddle) = Color.FromArgb(255, 195, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradVertBegin) = Color.FromArgb(249, 249, 255)
            rgbTable.Item(ProColor.msocbvcrCBGradVertEnd) = Color.FromArgb(147, 145, 176)
            rgbTable.Item(ProColor.msocbvcrCBGradVertMiddle) = Color.FromArgb(225, 226, 236)
            rgbTable.Item(ProColor.msocbvcrCBIconDisabledDark) = Color.FromArgb(122, 121, 153)
            rgbTable.Item(ProColor.msocbvcrCBIconDisabledLight) = Color.FromArgb(247, 245, 249)
            rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = Color.FromArgb(212, 212, 226)
            rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = Color.FromArgb(212, 212, 226)
            rgbTable.Item(ProColor.msocbvcrCBLowColorIconDisabled) = Color.FromArgb(168, 167, 190)
            rgbTable.Item(ProColor.msocbvcrCBMainMenuBkgd) = Color.FromArgb(198, 200, 215)
            rgbTable.Item(ProColor.msocbvcrCBMenuBdrOuter) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrCBMenuBkgd) = Color.FromArgb(253, 250, 255)
            rgbTable.Item(ProColor.msocbvcrCBMenuCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBMenuCtlTextDisabled) = Color.FromArgb(141, 141, 141)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgd) = Color.FromArgb(214, 211, 231)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = Color.FromArgb(185, 187, 200)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = Color.FromArgb(185, 187, 200)
            rgbTable.Item(ProColor.msocbvcrCBMenuShadow) = Color.FromArgb(154, 140, 176)
            rgbTable.Item(ProColor.msocbvcrCBMenuSplitArrow) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBOptionsButtonShadow) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBShadow) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrCBSplitterLine) = Color.FromArgb(110, 109, 143)
            rgbTable.Item(ProColor.msocbvcrCBSplitterLineLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBTearOffHandle) = Color.FromArgb(192, 192, 211)
            rgbTable.Item(ProColor.msocbvcrCBTearOffHandleMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBTitleBkgd) = Color.FromArgb(122, 121, 153)
            rgbTable.Item(ProColor.msocbvcrCBTitleText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDisabledFocuslessHighlightedText) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrDisabledHighlightedText) = Color.FromArgb(59, 59, 63)
            rgbTable.Item(ProColor.msocbvcrDlgGroupBoxText) = Color.FromArgb(7, 70, 213)
            rgbTable.Item(ProColor.msocbvcrDocTabBdr) = Color.FromArgb(118, 116, 146)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDark) = Color.FromArgb(186, 185, 206)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseDown) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseDown) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseDown) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(75, 75, 111)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrSelected) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgd) = Color.FromArgb(212, 212, 226)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdSelected) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDocTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextSelected) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = Color.FromArgb(212, 212, 226)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = Color.FromArgb(212, 212, 226)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = Color.FromArgb(148, 148, 148)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = Color.FromArgb(148, 148, 148)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = Color.FromArgb(171, 169, 194)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = Color.FromArgb(171, 169, 194)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDWTabTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = Color.FromArgb(224, 223, 227)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = Color.FromArgb(224, 223, 227)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrGDHeaderBdr) = Color.FromArgb(191, 191, 223)
            rgbTable.Item(ProColor.msocbvcrGDHeaderBkgd) = Color.FromArgb(239, 235, 222)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBdr) = Color.FromArgb(126, 125, 104)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgd) = Color.FromArgb(223, 223, 234)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgdSelected) = Color.FromArgb(255, 192, 111)
            rgbTable.Item(ProColor.msocbvcrGDHeaderSeeThroughSelection) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = Color.FromArgb(162, 162, 181)
            rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = Color.FromArgb(162, 162, 181)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentDarkBkgd) = Color.FromArgb(212, 213, 229)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentLightBkgd) = Color.FromArgb(227, 227, 236)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentTextDisabled) = Color.FromArgb(150, 145, 133)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderDarkBkgd) = Color.FromArgb(169, 168, 191)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderLightBkgd) = Color.FromArgb(208, 208, 223)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = Color.FromArgb(92, 91, 121)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = Color.FromArgb(92, 91, 121)
            rgbTable.Item(ProColor.msocbvcrGSPGroupline) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrGSPGroupline) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrGSPHyperlink) = Color.FromArgb(0, 61, 178)
            rgbTable.Item(ProColor.msocbvcrGSPLightBkgd) = Color.FromArgb(238, 238, 244)
            rgbTable.Item(ProColor.msocbvcrHyperlink) = Color.FromArgb(0, 61, 178)
            rgbTable.Item(ProColor.msocbvcrHyperlinkFollowed) = Color.FromArgb(170, 0, 170)
            rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = Color.FromArgb(215, 215, 229)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = Color.FromArgb(215, 215, 229)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradEnd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = Color.FromArgb(243, 243, 247)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = Color.FromArgb(243, 243, 247)
            rgbTable.Item(ProColor.msocbvcrJotNavUIText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrListHeaderArrow) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrNetLookBkgnd) = Color.FromArgb(249, 249, 255)
            rgbTable.Item(ProColor.msocbvcrOABBkgd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOBBkgdBdr) = Color.FromArgb(211, 211, 211)
            rgbTable.Item(ProColor.msocbvcrOBBkgdBdrContrast) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOGMDIParentWorkspaceBkgd) = Color.FromArgb(155, 154, 179)
            rgbTable.Item(ProColor.msocbvcrOGRulerActiveBkgd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGRulerBdr) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrOGRulerBkgd) = Color.FromArgb(223, 223, 234)
            rgbTable.Item(ProColor.msocbvcrOGRulerInactiveBkgd) = Color.FromArgb(177, 176, 195)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdr) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdrHighlight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabStopTicks) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOGRulerText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrOGTaskPaneGroupBoxHeaderBkgd) = Color.FromArgb(212, 212, 226)
            rgbTable.Item(ProColor.msocbvcrOGWorkspaceBkgd) = Color.FromArgb(155, 154, 179)
            rgbTable.Item(ProColor.msocbvcrOLKFlagNone) = Color.FromArgb(239, 239, 244)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarDark) = Color.FromArgb(110, 109, 143)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarLight) = Color.FromArgb(168, 167, 191)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKGridlines) = Color.FromArgb(234, 233, 225)
            rgbTable.Item(ProColor.msocbvcrOLKGroupLine) = Color.FromArgb(165, 164, 189)
            rgbTable.Item(ProColor.msocbvcrOLKGroupNested) = Color.FromArgb(253, 238, 201)
            rgbTable.Item(ProColor.msocbvcrOLKGroupShaded) = Color.FromArgb(229, 229, 235)
            rgbTable.Item(ProColor.msocbvcrOLKGroupText) = Color.FromArgb(112, 111, 145)
            rgbTable.Item(ProColor.msocbvcrOLKIconBar) = Color.FromArgb(253, 247, 233)
            rgbTable.Item(ProColor.msocbvcrOLKInfoBarBkgd) = Color.FromArgb(155, 154, 179)
            rgbTable.Item(ProColor.msocbvcrOLKInfoBarText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKPreviewPaneLabelText) = Color.FromArgb(155, 154, 179)
            rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorDark) = Color.FromArgb(187, 85, 3)
            rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorLight) = Color.FromArgb(251, 200, 79)
            rgbTable.Item(ProColor.msocbvcrOLKWBActionDividerLine) = Color.FromArgb(204, 206, 219)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonDark) = Color.FromArgb(147, 145, 176)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = Color.FromArgb(225, 226, 236)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = Color.FromArgb(225, 226, 236)
            rgbTable.Item(ProColor.msocbvcrOLKWBDarkOutline) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrOLKWBFoldersBackground) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonDark) = Color.FromArgb(247, 190, 87)
            rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonLight) = Color.FromArgb(255, 255, 220)
            rgbTable.Item(ProColor.msocbvcrOLKWBLabelText) = Color.FromArgb(50, 69, 105)
            rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonDark) = Color.FromArgb(248, 222, 128)
            rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonLight) = Color.FromArgb(232, 127, 8)
            rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonDark) = Color.FromArgb(238, 147, 17)
            rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonLight) = Color.FromArgb(251, 230, 148)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterDark) = Color.FromArgb(110, 109, 143)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = Color.FromArgb(168, 167, 191)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = Color.FromArgb(168, 167, 191)
            rgbTable.Item(ProColor.msocbvcrPlacesBarBkgd) = Color.FromArgb(224, 223, 227)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabAreaBkgd) = Color.FromArgb(243, 243, 247)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabBdr) = Color.FromArgb(124, 124, 148)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabInactiveBkgd) = Color.FromArgb(215, 215, 229)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelected) = Color.FromArgb(142, 142, 170)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelectedMouseOver) = Color.FromArgb(142, 142, 170)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrInactiveSelected) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrMouseOver) = Color.FromArgb(142, 142, 170)
            rgbTable.Item(ProColor.msocbvcrPubPrintDocScratchPageBkgd) = Color.FromArgb(155, 154, 179)
            rgbTable.Item(ProColor.msocbvcrPubWebDocScratchPageBkgd) = Color.FromArgb(195, 195, 210)
            rgbTable.Item(ProColor.msocbvcrSBBdr) = Color.FromArgb(236, 234, 218)
            rgbTable.Item(ProColor.msocbvcrScrollbarBkgd) = Color.FromArgb(247, 247, 249)
            rgbTable.Item(ProColor.msocbvcrToastGradBegin) = Color.FromArgb(239, 239, 247)
            rgbTable.Item(ProColor.msocbvcrToastGradEnd) = Color.FromArgb(179, 178, 204)
            rgbTable.Item(ProColor.msocbvcrWPBdrInnerDocked) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrWPBdrOuterDocked) = Color.FromArgb(243, 243, 247)
            rgbTable.Item(ProColor.msocbvcrWPBdrOuterFloating) = Color.FromArgb(122, 121, 153)
            rgbTable.Item(ProColor.msocbvcrWPBkgd) = Color.FromArgb(238, 238, 244)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdr) = Color.FromArgb(165, 172, 178)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDisabled) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrWPCtlBkgd) = Color.FromArgb(192, 192, 211)
            rgbTable.Item(ProColor.msocbvcrWPCtlBkgdDisabled) = Color.FromArgb(222, 222, 222)
            rgbTable.Item(ProColor.msocbvcrWPCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlTextDisabled) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrWPCtlTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPGroupline) = Color.FromArgb(161, 160, 187)
            rgbTable.Item(ProColor.msocbvcrWPInfoTipBkgd) = Color.FromArgb(255, 255, 204)
            rgbTable.Item(ProColor.msocbvcrWPInfoTipText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPNavBarBkgnd) = Color.FromArgb(122, 121, 153)
            rgbTable.Item(ProColor.msocbvcrWPText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPTextDisabled) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrWPTitleBkgdActive) = Color.FromArgb(184, 188, 234)
            rgbTable.Item(ProColor.msocbvcrWPTitleBkgdInactive) = Color.FromArgb(198, 198, 217)
            rgbTable.Item(ProColor.msocbvcrWPTitleTextActive) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPTitleTextInactive) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrXLFormulaBarBkgd) = Color.FromArgb(215, 215, 229)
        End Sub

#End Region

#Region " InitBlueLunaColors "
        Friend Sub InitBlueLunaColors(ByRef rgbTable As Hashtable)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = Color.FromArgb(196, 205, 218)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = Color.FromArgb(196, 205, 218)
            rgbTable.Item(ProColor.msocbvcrCBBdrOuterFloating) = Color.FromArgb(42, 102, 201)
            rgbTable.Item(ProColor.msocbvcrCBBkgd) = Color.FromArgb(196, 219, 249)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseDown) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelected) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelectedMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgd) = Color.FromArgb(196, 219, 249)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelected) = Color.FromArgb(255, 192, 111)
            rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelectedMouseOver) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextDisabled) = Color.FromArgb(141, 141, 141)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextLight) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBDockSeparatorLine) = Color.FromArgb(0, 53, 145)
            rgbTable.Item(ProColor.msocbvcrCBDragHandle) = Color.FromArgb(39, 65, 118)
            rgbTable.Item(ProColor.msocbvcrCBDragHandleShadow) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBDropDownArrow) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzBegin) = Color.FromArgb(158, 190, 245)
            rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzEnd) = Color.FromArgb(196, 218, 250)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedBegin) = Color.FromArgb(203, 221, 246)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedEnd) = Color.FromArgb(114, 155, 215)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedMiddle) = Color.FromArgb(161, 197, 249)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdBegin) = Color.FromArgb(227, 239, 255)
            rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdEnd) = Color.FromArgb(123, 164, 224)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownBegin) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownEnd) = Color.FromArgb(255, 223, 154)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseDownMiddle) = Color.FromArgb(255, 177, 109)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverBegin) = Color.FromArgb(255, 255, 222)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverEnd) = Color.FromArgb(255, 203, 136)
            rgbTable.Item(ProColor.msocbvcrCBGradMouseOverMiddle) = Color.FromArgb(255, 225, 172)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsBegin) = Color.FromArgb(127, 177, 250)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsEnd) = Color.FromArgb(0, 53, 145)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMiddle) = Color.FromArgb(82, 127, 208)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverBegin) = Color.FromArgb(255, 255, 222)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverEnd) = Color.FromArgb(255, 193, 118)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverMiddle) = Color.FromArgb(255, 225, 172)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedBegin) = Color.FromArgb(254, 140, 73)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedEnd) = Color.FromArgb(255, 221, 152)
            rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedMiddle) = Color.FromArgb(255, 184, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedBegin) = Color.FromArgb(255, 223, 154)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedEnd) = Color.FromArgb(255, 166, 76)
            rgbTable.Item(ProColor.msocbvcrCBGradSelectedMiddle) = Color.FromArgb(255, 195, 116)
            rgbTable.Item(ProColor.msocbvcrCBGradVertBegin) = Color.FromArgb(227, 239, 255)
            rgbTable.Item(ProColor.msocbvcrCBGradVertEnd) = Color.FromArgb(123, 164, 224)
            rgbTable.Item(ProColor.msocbvcrCBGradVertMiddle) = Color.FromArgb(203, 225, 252)
            rgbTable.Item(ProColor.msocbvcrCBIconDisabledDark) = Color.FromArgb(97, 122, 172)
            rgbTable.Item(ProColor.msocbvcrCBIconDisabledLight) = Color.FromArgb(233, 236, 242)
            rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = Color.FromArgb(186, 211, 245)
            rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = Color.FromArgb(186, 211, 245)
            rgbTable.Item(ProColor.msocbvcrCBLowColorIconDisabled) = Color.FromArgb(109, 150, 208)
            rgbTable.Item(ProColor.msocbvcrCBMainMenuBkgd) = Color.FromArgb(153, 204, 255)
            rgbTable.Item(ProColor.msocbvcrCBMenuBdrOuter) = Color.FromArgb(0, 45, 150)
            rgbTable.Item(ProColor.msocbvcrCBMenuBkgd) = Color.FromArgb(246, 246, 246)
            rgbTable.Item(ProColor.msocbvcrCBMenuCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrCBMenuCtlTextDisabled) = Color.FromArgb(141, 141, 141)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgd) = Color.FromArgb(203, 225, 252)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = Color.FromArgb(172, 183, 201)
            rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = Color.FromArgb(172, 183, 201)
            rgbTable.Item(ProColor.msocbvcrCBMenuShadow) = Color.FromArgb(95, 130, 234)
            rgbTable.Item(ProColor.msocbvcrCBMenuSplitArrow) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrCBOptionsButtonShadow) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrCBShadow) = Color.FromArgb(59, 97, 156)
            rgbTable.Item(ProColor.msocbvcrCBSplitterLine) = Color.FromArgb(106, 140, 203)
            rgbTable.Item(ProColor.msocbvcrCBSplitterLineLight) = Color.FromArgb(241, 249, 255)
            rgbTable.Item(ProColor.msocbvcrCBTearOffHandle) = Color.FromArgb(169, 199, 240)
            rgbTable.Item(ProColor.msocbvcrCBTearOffHandleMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrCBTitleBkgd) = Color.FromArgb(42, 102, 201)
            rgbTable.Item(ProColor.msocbvcrCBTitleText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDisabledFocuslessHighlightedText) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrDisabledHighlightedText) = Color.FromArgb(187, 206, 236)
            rgbTable.Item(ProColor.msocbvcrDlgGroupBoxText) = Color.FromArgb(0, 70, 213)
            rgbTable.Item(ProColor.msocbvcrDocTabBdr) = Color.FromArgb(0, 53, 154)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDark) = Color.FromArgb(117, 166, 241)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseDown) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseDown) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseDown) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = Color.FromArgb(0, 0, 128)
            rgbTable.Item(ProColor.msocbvcrDocTabBdrSelected) = Color.FromArgb(59, 97, 156)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgd) = Color.FromArgb(186, 211, 245)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDocTabBkgdSelected) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDocTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDocTabTextSelected) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = Color.FromArgb(186, 211, 245)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = Color.FromArgb(186, 211, 245)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = Color.FromArgb(94, 94, 94)
            rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = Color.FromArgb(94, 94, 94)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = Color.FromArgb(129, 169, 226)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = Color.FromArgb(129, 169, 226)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseDown) = Color.FromArgb(254, 128, 62)
            rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseOver) = Color.FromArgb(255, 238, 194)
            rgbTable.Item(ProColor.msocbvcrDWTabTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrDWTabTextMouseOver) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrGDHeaderBdr) = Color.FromArgb(89, 89, 172)
            rgbTable.Item(ProColor.msocbvcrGDHeaderBkgd) = Color.FromArgb(239, 235, 222)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBdr) = Color.FromArgb(126, 125, 104)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgd) = Color.FromArgb(239, 235, 222)
            rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgdSelected) = Color.FromArgb(255, 192, 111)
            rgbTable.Item(ProColor.msocbvcrGDHeaderSeeThroughSelection) = Color.FromArgb(191, 191, 223)
            rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = Color.FromArgb(74, 122, 201)
            rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = Color.FromArgb(74, 122, 201)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentDarkBkgd) = Color.FromArgb(185, 208, 241)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentLightBkgd) = Color.FromArgb(221, 236, 254)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrGSPGroupContentTextDisabled) = Color.FromArgb(150, 145, 133)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderDarkBkgd) = Color.FromArgb(101, 143, 224)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderLightBkgd) = Color.FromArgb(196, 219, 249)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = Color.FromArgb(0, 45, 134)
            rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = Color.FromArgb(0, 45, 134)
            rgbTable.Item(ProColor.msocbvcrGSPGroupline) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrGSPGroupline) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrGSPHyperlink) = Color.FromArgb(0, 61, 178)
            rgbTable.Item(ProColor.msocbvcrGSPLightBkgd) = Color.FromArgb(221, 236, 254)
            rgbTable.Item(ProColor.msocbvcrHyperlink) = Color.FromArgb(0, 61, 178)
            rgbTable.Item(ProColor.msocbvcrHyperlinkFollowed) = Color.FromArgb(170, 0, 170)
            rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = Color.FromArgb(59, 97, 156)
            rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = Color.FromArgb(59, 97, 156)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = Color.FromArgb(158, 190, 245)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = Color.FromArgb(158, 190, 245)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradEnd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = Color.FromArgb(196, 218, 250)
            rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = Color.FromArgb(196, 218, 250)
            rgbTable.Item(ProColor.msocbvcrJotNavUIText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrListHeaderArrow) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrNetLookBkgnd) = Color.FromArgb(227, 239, 255)
            rgbTable.Item(ProColor.msocbvcrOABBkgd) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOBBkgdBdr) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOBBkgdBdrContrast) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGMDIParentWorkspaceBkgd) = Color.FromArgb(144, 153, 174)
            rgbTable.Item(ProColor.msocbvcrOGRulerActiveBkgd) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGRulerBdr) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrOGRulerBkgd) = Color.FromArgb(216, 231, 252)
            rgbTable.Item(ProColor.msocbvcrOGRulerInactiveBkgd) = Color.FromArgb(158, 190, 245)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdr) = Color.FromArgb(75, 120, 202)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdrHighlight) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOGRulerTabStopTicks) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrOGRulerText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrOGTaskPaneGroupBoxHeaderBkgd) = Color.FromArgb(186, 211, 245)
            rgbTable.Item(ProColor.msocbvcrOGWorkspaceBkgd) = Color.FromArgb(144, 153, 174)
            rgbTable.Item(ProColor.msocbvcrOLKFlagNone) = Color.FromArgb(242, 240, 228)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarDark) = Color.FromArgb(0, 53, 145)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarLight) = Color.FromArgb(89, 135, 214)
            rgbTable.Item(ProColor.msocbvcrOLKFolderbarText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKGridlines) = Color.FromArgb(234, 233, 225)
            rgbTable.Item(ProColor.msocbvcrOLKGroupLine) = Color.FromArgb(123, 164, 224)
            rgbTable.Item(ProColor.msocbvcrOLKGroupNested) = Color.FromArgb(253, 238, 201)
            rgbTable.Item(ProColor.msocbvcrOLKGroupShaded) = Color.FromArgb(190, 218, 251)
            rgbTable.Item(ProColor.msocbvcrOLKGroupText) = Color.FromArgb(55, 104, 185)
            rgbTable.Item(ProColor.msocbvcrOLKIconBar) = Color.FromArgb(253, 247, 233)
            rgbTable.Item(ProColor.msocbvcrOLKInfoBarBkgd) = Color.FromArgb(144, 153, 174)
            rgbTable.Item(ProColor.msocbvcrOLKInfoBarText) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKPreviewPaneLabelText) = Color.FromArgb(144, 153, 174)
            rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorDark) = Color.FromArgb(187, 85, 3)
            rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorLight) = Color.FromArgb(251, 200, 79)
            rgbTable.Item(ProColor.msocbvcrOLKWBActionDividerLine) = Color.FromArgb(215, 228, 251)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonDark) = Color.FromArgb(123, 164, 224)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = Color.FromArgb(203, 225, 252)
            rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = Color.FromArgb(203, 225, 252)
            rgbTable.Item(ProColor.msocbvcrOLKWBDarkOutline) = Color.FromArgb(0, 45, 150)
            rgbTable.Item(ProColor.msocbvcrOLKWBFoldersBackground) = Color.FromArgb(255, 255, 255)
            rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonDark) = Color.FromArgb(247, 190, 87)
            rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonLight) = Color.FromArgb(255, 255, 220)
            rgbTable.Item(ProColor.msocbvcrOLKWBLabelText) = Color.FromArgb(50, 69, 105)
            rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonDark) = Color.FromArgb(248, 222, 128)
            rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonLight) = Color.FromArgb(232, 127, 8)
            rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonDark) = Color.FromArgb(238, 147, 17)
            rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonLight) = Color.FromArgb(251, 230, 148)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterDark) = Color.FromArgb(0, 53, 145)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = Color.FromArgb(89, 135, 214)
            rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = Color.FromArgb(89, 135, 214)
            rgbTable.Item(ProColor.msocbvcrPlacesBarBkgd) = Color.FromArgb(236, 233, 216)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabAreaBkgd) = Color.FromArgb(195, 218, 249)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabBdr) = Color.FromArgb(59, 97, 156)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabInactiveBkgd) = Color.FromArgb(158, 190, 245)
            rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelected) = Color.FromArgb(61, 108, 192)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelectedMouseOver) = Color.FromArgb(61, 108, 192)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrInactiveSelected) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrPPSlideBdrMouseOver) = Color.FromArgb(61, 108, 192)
            rgbTable.Item(ProColor.msocbvcrPubPrintDocScratchPageBkgd) = Color.FromArgb(144, 153, 174)
            rgbTable.Item(ProColor.msocbvcrPubWebDocScratchPageBkgd) = Color.FromArgb(189, 194, 207)
            rgbTable.Item(ProColor.msocbvcrSBBdr) = Color.FromArgb(211, 211, 211)
            rgbTable.Item(ProColor.msocbvcrScrollbarBkgd) = Color.FromArgb(251, 251, 248)
            rgbTable.Item(ProColor.msocbvcrToastGradBegin) = Color.FromArgb(220, 236, 254)
            rgbTable.Item(ProColor.msocbvcrToastGradEnd) = Color.FromArgb(167, 197, 238)
            rgbTable.Item(ProColor.msocbvcrWPBdrInnerDocked) = Color.FromArgb(185, 212, 249)
            rgbTable.Item(ProColor.msocbvcrWPBdrOuterDocked) = Color.FromArgb(196, 218, 250)
            rgbTable.Item(ProColor.msocbvcrWPBdrOuterFloating) = Color.FromArgb(42, 102, 201)
            rgbTable.Item(ProColor.msocbvcrWPBkgd) = Color.FromArgb(221, 236, 254)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdr) = Color.FromArgb(127, 157, 185)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlBdrDisabled) = Color.FromArgb(128, 128, 128)
            rgbTable.Item(ProColor.msocbvcrWPCtlBkgd) = Color.FromArgb(169, 199, 240)
            rgbTable.Item(ProColor.msocbvcrWPCtlBkgdDisabled) = Color.FromArgb(222, 222, 222)
            rgbTable.Item(ProColor.msocbvcrWPCtlText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPCtlTextDisabled) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrWPCtlTextMouseDown) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPGroupline) = Color.FromArgb(123, 164, 224)
            rgbTable.Item(ProColor.msocbvcrWPInfoTipBkgd) = Color.FromArgb(255, 255, 204)
            rgbTable.Item(ProColor.msocbvcrWPInfoTipText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPNavBarBkgnd) = Color.FromArgb(74, 122, 201)
            rgbTable.Item(ProColor.msocbvcrWPText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPText) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPTextDisabled) = Color.FromArgb(172, 168, 153)
            rgbTable.Item(ProColor.msocbvcrWPTitleBkgdActive) = Color.FromArgb(123, 164, 224)
            rgbTable.Item(ProColor.msocbvcrWPTitleBkgdInactive) = Color.FromArgb(148, 187, 239)
            rgbTable.Item(ProColor.msocbvcrWPTitleTextActive) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrWPTitleTextInactive) = Color.FromArgb(0, 0, 0)
            rgbTable.Item(ProColor.msocbvcrXLFormulaBarBkgd) = Color.FromArgb(158, 190, 245)
        End Sub

#End Region

#Region " InitSystemColors "
        'Friend Sub InitSystemColors(ByRef rgbTable As Hashtable)
        '    rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBBdrOuterDocked) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBBdrOuterFloating) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseDown) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBdrMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelected) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBdrSelectedMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgd) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgdLight) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseDown) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = IIf(flag1, SystemColors.ControlLight, SystemColors.Highlight)
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgdMouseOver) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelected) = IIf(flag1, SystemColors.ControlLight, SystemColors.Highlight)
        '    rgbTable.Item(ProColor.msocbvcrCBCtlBkgdSelectedMouseOver) = IIf(flag1, SystemColors.ControlLight, SystemColors.Highlight)
        '    rgbTable.Item(ProColor.msocbvcrCBCtlText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrCBCtlTextDisabled) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBCtlTextLight) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseDown) = SystemColors.HighlightText
        '    rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = SystemColors.HighlightText
        '    rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = SystemColors.MenuText
        '    rgbTable.Item(ProColor.msocbvcrCBCtlTextMouseOver) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrCBDockSeparatorLine) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBDragHandle) = IIf(flag1, Color.Black, SystemColors.ControlDark)
        '    rgbTable.Item(ProColor.msocbvcrCBDragHandleShadow) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrCBDropDownArrow) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzBegin) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBGradMainMenuHorzEnd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBGradMouseOverEnd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradMouseOverBegin) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradMouseOverMiddle) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsBegin) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsEnd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsMiddle) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverBegin) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverEnd) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsMouseOverMiddle) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedBegin) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedEnd) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradOptionsSelectedMiddle) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradSelectedBegin) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradSelectedEnd) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradSelectedMiddle) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBGradVertBegin) = color1
        '    rgbTable.Item(ProColor.msocbvcrCBGradVertMiddle) = color2
        '    rgbTable.Item(ProColor.msocbvcrCBGradVertEnd) = color3
        '    rgbTable.Item(ProColor.msocbvcrCBGradMouseDownBegin) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradMouseDownMiddle) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradMouseDownEnd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdBegin) = color1
        '    rgbTable.Item(ProColor.msocbvcrCBGradMenuTitleBkgdEnd) = color2
        '    rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedBegin) = color1
        '    rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedMiddle) = color2
        '    rgbTable.Item(ProColor.msocbvcrCBGradMenuIconBkgdDroppedEnd) = color3
        '    rgbTable.Item(ProColor.msocbvcrCBIconDisabledDark) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBIconDisabledLight) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBLabelBkgnd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBLowColorIconDisabled) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBMainMenuBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBMenuBdrOuter) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBMenuBkgd) = IIf(flag1, SystemColors.ControlLightLight, SystemColors.Window)
        '    rgbTable.Item(ProColor.msocbvcrCBMenuCtlText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrCBMenuCtlTextDisabled) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgd) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrCBMenuIconBkgdDropped) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBMenuShadow) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBMenuSplitArrow) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBOptionsButtonShadow) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBShadow) = SystemColors.Control
        '    rgbTable.Item(ProColor.msocbvcrCBSplitterLine) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBSplitterLineLight) = SystemColors.ButtonHighlight
        '    rgbTable.Item(ProColor.msocbvcrCBTearOffHandle) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBTearOffHandleMouseOver) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrCBTitleBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrCBTitleText) = SystemColors.ButtonHighlight
        '    rgbTable.Item(ProColor.msocbvcrDisabledFocuslessHighlightedText) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrDisabledHighlightedText) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrDlgGroupBoxText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrDark) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseDown) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrDarkMouseOver) = SystemColors.MenuText
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrLight) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseDown) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrLightMouseOver) = SystemColors.MenuText
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseDown) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrMouseOver) = SystemColors.MenuText
        '    rgbTable.Item(ProColor.msocbvcrDocTabBdrSelected) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrDocTabBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseDown) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabBkgdMouseOver) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrDocTabBkgdSelected) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrDocTabText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrDocTabTextMouseDown) = SystemColors.HighlightText
        '    rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = SystemColors.HighlightText
        '    rgbTable.Item(ProColor.msocbvcrDocTabTextMouseOver) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrDocTabTextSelected) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDWActiveTabBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDWActiveTabText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrDWActiveTabTextDisabled) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDWInactiveTabBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = SystemColors.ButtonHighlight
        '    rgbTable.Item(ProColor.msocbvcrDWInactiveTabText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseDown) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDWTabBkgdMouseOver) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrDWTabTextMouseDown) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrDWTabTextMouseOver) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedBkgd) = SystemColors.InactiveCaption
        '    rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrFocuslessHighlightedText) = SystemColors.InactiveCaptionText
        '    rgbTable.Item(ProColor.msocbvcrGDHeaderBdr) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrGDHeaderBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGDHeaderCellBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrGDHeaderCellBkgdSelected) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrGDHeaderSeeThroughSelection) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrGSPDarkBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupContentDarkBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupContentLightBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupContentText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupContentTextDisabled) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderDarkBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderLightBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupHeaderText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupline) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrGSPGroupline) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrGSPHyperlink) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrGSPLightBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrHyperlink) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrHyperlinkFollowed) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIBdr) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIGradBegin) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIGradEnd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIGradMiddle) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrJotNavUIText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrListHeaderArrow) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrNetLookBkgnd) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOABBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOBBkgdBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOBBkgdBdrContrast) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrOGMDIParentWorkspaceBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOGRulerActiveBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrOGRulerBdr) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrOGRulerBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOGRulerInactiveBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOGRulerTabBoxBdrHighlight) = SystemColors.ButtonHighlight
        '    rgbTable.Item(ProColor.msocbvcrOGRulerTabStopTicks) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOGRulerText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrOGTaskPaneGroupBoxHeaderBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOGWorkspaceBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKFlagNone) = SystemColors.ButtonHighlight
        '    rgbTable.Item(ProColor.msocbvcrOLKFolderbarDark) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKFolderbarLight) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKFolderbarText) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrOLKGridlines) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKGroupLine) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKGroupNested) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKGroupShaded) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKGroupText) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKIconBar) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKInfoBarBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKInfoBarText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrOLKPreviewPaneLabelText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorDark) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrOLKTodayIndicatorLight) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKWBActionDividerLine) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKWBButtonDark) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKWBButtonLight) = SystemColors.ButtonHighlight
        '    rgbTable.Item(ProColor.msocbvcrOLKWBDarkOutline) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKWBFoldersBackground) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonDark) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOLKWBHoverButtonLight) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOLKWBLabelText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonDark) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOLKWBPressedButtonLight) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonDark) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOLKWBSelectedButtonLight) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrOLKWBSplitterDark) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrOLKWBSplitterLight) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrPlacesBarBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabAreaBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabInactiveBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrPPOutlineThumbnailsPaneTabText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelected) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrPPSlideBdrActiveSelectedMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrPPSlideBdrInactiveSelected) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrPPSlideBdrMouseOver) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrPubPrintDocScratchPageBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrPubWebDocScratchPageBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrSBBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrScrollbarBkgd) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrToastGradBegin) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrToastGradEnd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrWPBdrInnerDocked) = Color.Empty
        '    rgbTable.Item(ProColor.msocbvcrWPBdrOuterDocked) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrWPBdrOuterFloating) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrWPBkgd) = SystemColors.Window
        '    rgbTable.Item(ProColor.msocbvcrWPCtlBdr) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrWPCtlBdrDefault) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrWPCtlBdrDisabled) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrWPCtlBkgd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrWPCtlBkgdDisabled) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrWPCtlText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrWPCtlTextDisabled) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrWPCtlTextMouseDown) = SystemColors.HighlightText
        '    rgbTable.Item(ProColor.msocbvcrWPGroupline) = SystemColors.ButtonShadow
        '    rgbTable.Item(ProColor.msocbvcrWPInfoTipBkgd) = SystemColors.Info
        '    rgbTable.Item(ProColor.msocbvcrWPInfoTipText) = SystemColors.InfoText
        '    rgbTable.Item(ProColor.msocbvcrWPNavBarBkgnd) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrWPText) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrWPText) = SystemColors.WindowText
        '    rgbTable.Item(ProColor.msocbvcrWPTextDisabled) = SystemColors.GrayText
        '    rgbTable.Item(ProColor.msocbvcrWPTitleBkgdActive) = SystemColors.Highlight
        '    rgbTable.Item(ProColor.msocbvcrWPTitleBkgdInactive) = SystemColors.ButtonFace
        '    rgbTable.Item(ProColor.msocbvcrWPTitleTextActive) = SystemColors.HighlightText
        '    rgbTable.Item(ProColor.msocbvcrWPTitleTextInactive) = SystemColors.ControlText
        '    rgbTable.Item(ProColor.msocbvcrXLFormulaBarBkgd) = SystemColors.ButtonFace
        'End Sub
#End Region

        Friend Function FromProColor(ByVal color As ProColor) As Color
            'Convert the ProColor to a color by looking it up in the table
            Return CType(Me.ColorTable.Item(color), Color)
        End Function

#Region " Color Properties "
        Public Overridable ReadOnly Property ButtonCheckedGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradSelectedBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonCheckedGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradSelectedEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonCheckedGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradSelectedMiddle)
            End Get
        End Property


        'Public Overridable ReadOnly Property ButtonCheckedHighlight() As Color
        '    Get
        '        Return Me.FromProColor(ProColor.ButtonCheckedHighlight)
        '    End Get
        'End Property


        Public Overridable ReadOnly Property ButtonCheckedHighlightBorder() As Color
            Get
                Return SystemColors.Highlight
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonPressedBorder() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBdrMouseOver)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonPressedGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseDownBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonPressedGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseDownEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonPressedGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseDownMiddle)
            End Get
        End Property


        'Public Overridable ReadOnly Property ButtonPressedHighlight() As Color
        '    Get
        '        Return Me.FromProColor(ProColor.ButtonPressedHighlight)
        '    End Get
        'End Property


        Public Overridable ReadOnly Property ButtonPressedHighlightBorder() As Color
            Get
                Return SystemColors.Highlight
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonSelectedBorder() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBdrMouseOver)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonSelectedGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseOverBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonSelectedGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseOverEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ButtonSelectedGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseOverMiddle)
            End Get
        End Property


        'Public Overridable ReadOnly Property ButtonSelectedHighlight() As Color
        '    Get
        '        Return Me.FromProColor(ProColor.ButtonSelectedHighlight)
        '    End Get
        'End Property


        Public Overridable ReadOnly Property ButtonSelectedHighlightBorder() As Color
            Get
                Return Me.ButtonPressedBorder
            End Get
        End Property


        Public Overridable ReadOnly Property CheckBackground() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBkgdSelected)
            End Get
        End Property


        Public Overridable ReadOnly Property CheckPressedBackground() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBkgdSelectedMouseOver)
            End Get
        End Property


        Public Overridable ReadOnly Property CheckSelectedBackground() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBkgdSelectedMouseOver)
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonGradientBegin() As Color
            Get
                Return Me.MenuItemPressedGradientBegin
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonGradientEnd() As Color
            Get
                Return Me.MenuItemPressedGradientEnd
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonOnOverflow() As Color
            Get
                Return Me.ToolStripDropDownBackground
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonPressedGradientBegin() As Color
            Get
                Return Me.ButtonPressedGradientBegin
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonPressedGradientEnd() As Color
            Get
                Return Me.ButtonPressedGradientEnd
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonSelectedGradientBegin() As Color
            Get
                Return Me.MenuItemSelectedGradientBegin
            End Get
        End Property

        Friend ReadOnly Property ComboBoxButtonSelectedGradientEnd() As Color
            Get
                Return Me.MenuItemSelectedGradientEnd
            End Get
        End Property


        Public Overridable ReadOnly Property GripDark() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBDragHandle)
            End Get
        End Property


        Public Overridable ReadOnly Property GripLight() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBDragHandleShadow)
            End Get
        End Property


        Public Overridable ReadOnly Property ImageMarginGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradVertBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ImageMarginGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradVertEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ImageMarginGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradVertMiddle)
            End Get
        End Property


        Public Overridable ReadOnly Property ImageMarginRevealedGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMenuIconBkgdDroppedBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ImageMarginRevealedGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMenuIconBkgdDroppedEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ImageMarginRevealedGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMenuIconBkgdDroppedMiddle)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuBorder() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBMenuBdrOuter)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemBorder() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBdrSelected)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemPressedGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMenuTitleBkgdBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemPressedGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMenuTitleBkgdEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemPressedGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMenuIconBkgdDroppedMiddle)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemSelected() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBCtlBkgdMouseOver)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemSelectedGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseOverBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuItemSelectedGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMouseOverEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuStripGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property MenuStripGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property OverflowButtonGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradOptionsBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property OverflowButtonGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradOptionsEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property OverflowButtonGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradOptionsMiddle)
            End Get
        End Property


        Public Overridable ReadOnly Property RaftingContainerGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property RaftingContainerGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property SeparatorDark() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBSplitterLine)
            End Get
        End Property


        Public Overridable ReadOnly Property SeparatorLight() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBSplitterLineLight)
            End Get
        End Property


        Public Overridable ReadOnly Property StatusStripGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property StatusStripGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripBorder() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBShadow)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripContentPanelGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripContentPanelGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripDropDownBackground() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBMenuBkgd)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradVertBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradVertEnd)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripGradientMiddle() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradVertMiddle)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripPanelGradientBegin() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzBegin)
            End Get
        End Property


        Public Overridable ReadOnly Property ToolStripPanelGradientEnd() As Color
            Get
                Return Me.FromProColor(ProColor.msocbvcrCBGradMainMenuHorzEnd)
            End Get
        End Property

#End Region

    End Class
End Namespace
