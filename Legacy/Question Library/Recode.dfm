�
 TFRMRECODE 0�  TPF0
TfrmRecode	frmRecodeLeft� TopjActiveControl	panHeaderBorderIconsbiSystemMenu BorderStylebsDialogCaption�Recoding How the Quick Brown Fox Jumps Over a Lazy dog this should be OK? shouldn't it??? why isn't it changing??? I don't understand.ClientHeight6ClientWidth`Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style PositionpoScreenCenterShowHint	OnClose	FormCloseOnCloseQueryFormCloseQueryOnCreate
FormCreateOnShowFormShowPixelsPerInch`
TextHeight TLabellblSpinLeftTop3WidthHeightCaption&lblSpinFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabel	lblSpinToLeftSTopEWidth	HeightCaptiontoFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabel	lblTargetLeft� Top!Width`HeightCaption&Target Scale Values  TLabel	lblSourceLeftTop!WidthcHeightCaption&Source Scale Values  TLabel
lblDefinedLeftTop� WidthmHeightCaption&Recoded Scale Values  TPanel	panHeaderLeft Top Width`HeightAlignalTop
BevelOuterbvNoneBorderWidthTabOrder  TSpeedButtonbtnAllLeft3TopWidthHeightHint(Empty Recodes|Removes all recoded valuesCaptionallEnabledOnClickAllClick  TSpeedButtonbtnCloseLeftFTopWidthHeightHintClose|Exits the Recoding Dialog
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 333  3333?wws�333 ���333w3?7s�30w��p3373337?3����333333w��w333�33�� ��337w�33wp ww337w333�����3s�����s30     337wwwww33333333333333333333333s�s333w� �s333s�w3s3330���33337?��33333  33333wws333333333333333333	NumGlyphsVisibleOnClick
CloseClick  TSpeedButton	btnRemoveLeftTopWidthHeightHintBDelete Recode|Removes the selected recode(s) from the Defined ListCaptionunEnabled	NumGlyphsOnClickRemoveClick  TSpeedButtonbtnAddLeftTopWidthHeightHintnCreate Recode|Recodes the Source Scale Value to the Target Scale Value and adds the result to the Defined ListCaptionlinkEnabledOnClickAddClick  TSpeedButton	btnDeleteLeftOTopWidthHeight
Glyph.Data
z  v  BMv      v   (                                        �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 30    3337wwww�330�wwp3337�����330���p3337�����330��pp3337�����330���p3337�����330��pp3337�����330���p333�������00��pp0377�����33 ���p33w����s330��pp3337�����330pppp3337�����33     33wwwww33��ww33����33     33wwwwws3330wp333337���33330  333337ww333	NumGlyphsOnClickDeleteClick  	TComboBox	cmbRecodeLeftkTopWidth� HeightHint7Target Selection|Select Target Scale to use in RecodingStylecsDropDownList
ItemHeightTabOrder OnClick
ComboClick   
TStatusBar	staRecodeLeft Top#Width`HeightPanels SimplePanel	
SimpleTextInstructionsSizeGrip  	TwwDBGrid
wdgrTargetLeft� Top0Width� HeightnSelected.StringsShort	60	Short 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBarShowVertScrollBar
DataSource
wsrcTargetOptionsdgRowSelectdgAlwaysShowSelectiondgConfirmDeletedgCancelOnExitdgPerfectRowFitdgMultiSelect ReadOnly	TabOrderTitleAlignmenttaLeftJustifyTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsOnExitAddGridsExit	OnMouseUpTargetMouseUpIndicatorColoricBlack  	TwwDBGridwdgrDefinedLeftTop� WidthZHeightnSelected.StringsSource	27	Source	YesEquals	2	Equals	YesTarget	30	Target	Yes 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBarShowVertScrollBar
DataSourcewsrcMapOptionsdgRowSelectdgAlwaysShowSelectiondgConfirmDeletedgCancelOnExitdgPerfectRowFitdgMultiSelect ReadOnly	TabOrderTitleAlignmenttaLeftJustifyTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsOnExitDefinedExit	OnMouseUpDefinedMouseUpIndicatorColoricBlack  TEditedtMinLeftTopBWidth<HeightTabOrderText0OnChange
SpinChangeOnEnter	SpinEnter  TEditedtMaxLeftaTopBWidth<HeightTabOrderText0OnChange
SpinChangeOnEnter	SpinEnter  TUpDownspnMinLeft?TopBWidthHeight	AssociateedtMinMin�Position TabOrder	ThousandsWrapOnEnter	SpinEnter  TUpDownspnMaxLeft� TopBWidthHeight	AssociateedtMaxMin�Position TabOrderWrapOnEnter	SpinEnter  	TwwDBGrid
wdgrSourceLeftTop0Width� HeightnSelected.StringsShort	60	Short 
TitleColor	clBtnFace	FixedCols ShowHorzScrollBarShowVertScrollBar
DataSource
wsrcSourceOptionsdgRowSelectdgAlwaysShowSelectiondgConfirmDeletedgCancelOnExitdgPerfectRowFitdgMultiSelect ReadOnly	TabOrderTitleAlignmenttaLeftJustifyTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtonsOnExitAddGridsExit	OnMouseUpSourceMouseUpIndicatorColoricBlack  TTable	tblValuesDatabaseNameQuestion	TableNameScaleValues.DBLeft� Top�   TwwDataSource
wsrcSourceDataSet
wqrySourceLeft� Top�   TwwDataSource
wsrcTargetDataSet
wtblTargetLeft4Top�   TwwDataSourcewsrcMapDataSetwtblMapLeft� Top�   TwwTable
wtblTargetFiltered	OnFilterRecordTargetFilterRecordDatabaseNameQuestion	TableNameScaleValues.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left4Top�  TIntegerFieldwtblTargetScale	FieldNameScale  TIntegerFieldwtblTargetItem	FieldNameItem  TSmallintFieldwtblTargetBubbleValue	FieldNameBubbleValue  TStringFieldwtblTargetShort	FieldNameShortSize<   TwwQuery
wqrySourceOnFilterRecordSourceFilterRecordDatabaseNameQuestion
DataSourcemodLibrary.wsrcQuestionSQL.Strings'SELECT S.BubbleValue, S.Short, S.Scale FROM ScaleValues AS S,WHERE ((S.Scale = :Scale) OR (S.Scale = 0)); Params.Data
     Scale       ValidateWithMask	Left� Top�  TStringFieldwqrySourceShortDisplayWidth<	FieldNameShortOrigin"ScaleValues.DB".ShortSize<  TSmallintFieldwqrySourceBubbleValue	AlignmenttaLeftJustifyDisplayWidth
	FieldNameBubbleValueOrigin"ScaleValues.DB".BubbleValueVisible  TIntegerFieldwqrySourceScaleDisplayWidth
	FieldNameScaleOrigin"ScaleValues.DB".ScaleVisible   TwwTablewtblMapAutoCalcFieldsOnCalcFieldsMapCalcFieldsDatabaseNameQuestionIndexFieldNamesCore;RecodeMasterFieldsCore;RecodeMasterSourcemodLibrary.wsrcRecode	TableNameRecodeMap.dbSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top�  TStringFieldwtblMapSource	AlignmenttaRightJustifyDisplayWidth	FieldNameSourceSize<
Calculated	  TStringFieldwtblMapEquals	AlignmenttaCenterDisplayWidth	FieldNameEqualsSize
Calculated	  TStringFieldwtblMapTargetDisplayWidth	FieldNameTargetSize<
Calculated	  TSmallintFieldwtblMapMinimumDisplayWidth	FieldNameMinimumVisibleDisplayFormat0;Null  TStringField	wtblMapTo	AlignmenttaCenterDisplayWidth	FieldNameToVisibleSize
Calculated	  TSmallintFieldwtblMapMaximum	AlignmenttaCenterDisplayWidth	FieldNameMaximumVisibleDisplayFormat0;Null  TSmallintFieldwtblMapNewValueDisplayWidth
	FieldNameNewValueVisible  TIntegerFieldwtblMapCore	FieldNameCore  TIntegerFieldwtblMapRecode	FieldNameRecode    