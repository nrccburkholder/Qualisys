ÿ
 TFRMRELATED 0ê  TPF0TfrmRelated
frmRelatedLeftöTopnBorderIconsbiSystemMenu BorderStylebsToolWindowCaptionAssociated QuestionsClientHeightIClientWidth² Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Heightõ	Font.NameMS Sans Serif
Font.Style OnShowFormShowPixelsPerInch`
TextHeight TPanel	panHeaderLeft Top Width² Height AlignalTop
BevelOuterbvNoneBorderWidthTabOrder  TSpeedButtonbtnGoToLeftTopWidthHeightHint7Go To|Moves to the selected question in the main window
Glyph.Data
j  f  BMf      v   (               ð   Î  Ä                             ÀÀÀ   ÿ  ÿ   ÿÿ ÿ   ÿ ÿ ÿÿ  ÿÿÿ  DÈ     *  (
ªª' w
ªúp(0w ª w*0p  p8 7p0ws8p8 Dw ww!p  p   p	wqpw wwº    c)tLµParentShowHintShowHint	OnClick	GoToClick  TSpeedButton
btnRefreshLeft;TopWidthHeightHint3Refresh|Updates information on associated questionsCaptionReParentShowHintShowHint	OnClickRefreshClick  TSpeedButton	btnDeleteLeftXTopWidthHeightHint=Remove|Removes the current reference to the selected Question
Glyph.Data
z  v  BMv      v   (                                                      ÀÀÀ   ÿ  ÿ   ÿÿ ÿ   ÿ ÿ ÿÿ  ÿÿÿ 30    3337wwwwó330÷wwp3337óóó÷ó330ðp3337÷÷÷÷ó330ðpp3337÷÷÷÷ó330ðp3337÷÷÷÷ó330ðpp3337÷÷÷÷ó330ðp333÷÷÷÷÷óó00ðpp0377÷÷÷÷÷33 ðp33w÷÷÷÷s330ðpp3337÷÷÷÷ó330pppp3337÷÷÷÷ÿ33     33wwwww33ww33ÿÿÿÿ33     33wwwwws3330wp333337ÿ÷ó33330  333337ww333	NumGlyphsParentShowHintShowHint	OnClickDeleteClick  TSpeedButtonbtnCloseLeft TopWidthHeightHint/Close|Exits the Associated Questions dialog box
Glyph.Data
z  v  BMv      v   (                                                  ¿¿¿   ÿ  ÿ   ÿÿ ÿ   ÿ ÿ ÿÿ  ÿÿÿ 333  3333?wwsÿ333 333w3?7só30wp3373337?3333333ww333ó33 337wó33wp ww337w3333sÿÿÿÿÿs30     337wwwww33333333333333333333333sÿs333w s333s÷w3s333033337?ÿ÷33333  33333wws333333333333333333	NumGlyphsParentShowHintShowHint	VisibleOnClick
CloseClick  TSpeedButtonbtnPrintLeftTopWidthHeightHint/Print|Prints a list of all associated questions
Glyph.Data

    BM      v   (   (                                                 ÀÀÀ   ÿ  ÿ   ÿÿ ÿ   ÿ ÿ ÿÿ  ÿÿÿ 3333333333333333333333333333333?ÿ33333ÿó3 33330 33wÿÿÿÿ÷wÿ0        7wwwwwwww0ø7ó33333330ø7ó33333330ø7ó33333330ÿÿÿÿÿÿÿÿ7ÿÿÿÿÿÿÿÿ7 wwwwww s7wwwwwwwws30      337wwwwww330ÿÿÿÿð337?ÿÿÿ÷s333    ð3333wwww7ó333ÿÿÿÿð3333?ÿÿÿ÷ó333    ð3333wwww7ó333ÿÿÿÿð3333?ó337ó333 ÿÿÿð3333w3337ó333ÿÿÿÿð3333ÿÿÿÿ÷ó333      3333wwwwww333333333333333333333333333333333333333333	NumGlyphsParentShowHintShowHint	OnClick
PrintClick  TSpeedButtonbtnContinueLeftqTopWidthHeightHint:Remove All|Removes all references to the selected QuestionCaptionallParentShowHintShowHint	OnClickContinueClick   TDBGrid	dgrRecodeLeft TopØ Width² Height^CursorcrArrowAlignalTop
DataSource	srcRecodeOptionsdgTitlesdgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit ReadOnly	TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.HeightõTitleFont.NameMS Sans SerifTitleFont.Style Columns	AlignmenttaCenter	FieldNameCoreWidth 	FieldNameDescriptionTitle.CaptionRecodes these Questions  Width     TDBGrid	dgrFollowLeft Top{Width² Height]CursorcrArrowAlignalTop
DataSource	srcFollowOptionsdgTitlesdgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit ReadOnly	TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.HeightõTitleFont.NameMS Sans SerifTitleFont.Style Columns	AlignmenttaCenter	FieldNameCoreWidth 	FieldNameDescriptionTitle.CaptionFollows these QuestionsWidth     TDBGrid	dgrPrecedLeft Top Width² Height[CursorcrArrowAlignalTop
DataSource	srcProcedOptionsdgTitlesdgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit ReadOnly	TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.HeightõTitleFont.NameMS Sans SerifTitleFont.Style Columns	AlignmenttaCenter	FieldNameCoreWidth 	FieldNameDescriptionTitle.CaptionProceds these QuestionsWidth     
TStatusBar
staRelatedLeft Top6Width² HeightPanels SimplePanel	
SimpleTextNumber of Related Questions:SizeGrip  TDataSource	srcFollowDataSet	qryFollowLeftTop¦   TDataSource	srcProcedDataSet	qryPrecedLeftTopK  TDataSource	srcRecodeDataSet	qryRecodeLeftTop  TQuery	qryRecodeDatabaseNameQuestion
DataSourcemodLibrary.wsrcQuestionSQL.Strings"SELECT R.Core, Description, Short 8FROM Recodes AS R JOIN Questions AS Q ON R.Core = Q.CoreWHERE R.Recode = :vCore; Params.Data
     vCore      UpdateObject	updRecodeLeftITop TIntegerFieldqryRecodeCore	FieldNameCoreOrigin"Recodes.DB".Core  TStringFieldqryRecodeDescription	FieldNameDescriptionOrigin"Questions.DB".DescriptionSize  TStringFieldqryRecodeShort	FieldNameShortOrigin"Questions.DB".ShortSize<   TQuery	qryPrecedDatabaseNameQuestion
DataSourcemodLibrary.wsrcQuestionRequestLive	SQL.Strings6SELECT Core, Description, Short, PrecededBy AS Relate FROM QuestionsWHERE PrecededBy = :vCore; Params.Data
     vCore      LeftBTopK TIntegerFieldqryPrecedCore	FieldNameCoreOrigin"Questions.DB".Core  TStringFieldqryPrecedDescription	FieldNameDescriptionOrigin"Questions.DB".DescriptionSize  TStringFieldqryPrecedShort	FieldNameShortOrigin"Questions.DB".ShortSize<   TQuery	qryFollowDatabaseNameQuestion
DataSourcemodLibrary.wsrcQuestionRequestLive	SQL.Strings6SELECT Core, Description, Short, FollowedBy AS Relate FROM QuestionsWHERE FollowedBy = :vCore; Params.Data
     vCore      LeftVTop¦  TIntegerFieldqryFollowCore	FieldNameCoreOrigin"Questions.DB".Core  TStringFieldqryFollowDescription	FieldNameDescriptionOrigin"Questions.DB".DescriptionSize  TStringFieldqryFollowShort	FieldNameShortOrigin"Questions.DB".ShortSize<   
TUpdateSQL	updRecodeDeleteSQL.StringsDELETE FROM Recodes0WHERE Core = :OLD_Core AND Recode = :OLD_Recode; Left Top   