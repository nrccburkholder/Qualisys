�
 TDMOPENQ 0�@  TPF0TDMOpenQDMOpenQOnCreateDMOpenQCreate	OnDestroyDMOpenQDestroyLefttTop� Height�WidthY 	TDatabasedbPriv	AliasNamePRIV	Connected	DatabaseName_PRIVLoginPromptSessionNameDefaultTransIsolationtiDirtyReadLeft(Top`  	TDatabase	dbQualPro	AliasNameQualProDatabaseName_QualProLoginPromptParams.StringsDATABASE NAME=ODBC DSN=QualProOPEN MODE=READ/WRITEBATCH COUNT=200LANGDRIVER=MAX ROWS=-1SCHEMA CACHE DIR=SCHEMA CACHE SIZE=8SCHEMA CACHE TIME=-1"SQLPASSTHRU MODE=SHARED AUTOCOMMITSQLQRYMODE=ENABLE SCHEMA CACHE=FALSEENABLE BCD=FALSEROWSET SIZE=20BLOBS TO CACHE=64BLOB SIZE=32PASSWORD=qpsaUSER NAME=qpsa  SessionNameDefaultLeft�TopX  TwwDataSource
wwDS_QstnsDataSet	wwT_QstnsLeft Top:  TwwTable	wwT_QstnsFiltered		AfterOpenwwT_QstnsAfterOpenBeforeClosewwT_QstnsBeforeClose	AfterPost	AfterPostBeforeDeletewwT_QstnsBeforeDeleteOnFilterRecordwwT_QstnsFilterRecordDatabaseName_PRIV	TableNamesel_Qstns.dbSyncSQLByRange	NarrowSearchValidateWithMask	Left Top TStringFieldwwT_QstnsPlusMinusDisplayLabel DisplayWidth	FieldName	PlusMinusSize  TStringFieldwwT_QstnsSubSectNumDisplayLabel DisplayWidth	FieldName
SubSectNumReadOnly		OnGetTextwwT_QstnsSubSectNumGetTextSize
Calculated	  TStringFieldwwT_QstnsLabelDisplayLabelQuestionDisplayWidth<	FieldNameLabelSize<  TIntegerFieldwwT_QstnsQstnCoreDisplayLabelCoreDisplayWidth	FieldNameQstnCore  TStringFieldwwT_QstnsstrScalePos	AlignmenttaCenterDisplayLabel	Scale PosDisplayWidth
	FieldNamestrScalePosReadOnly		OnGetTextwwT_QstnsstrScalePosGetTextSize

Calculated	  TStringFieldwwT_QstnsSkipFrom	AlignmenttaCenterDisplayWidth	FieldNameSkipsLookupDataSetwwT_SkipLookupKeyFieldsSelQstns_IDLookupResultFieldnumSkipType	KeyFieldsSelQstns_IDReadOnly		OnGetTextwwT_QstnsSkipFromGetTextSize
Lookup	  TStringFieldwwT_QstnsProblemScore	AlignmenttaCenterDisplayLabelProblem ScoresDisplayWidth	FieldNameProblemScoreLookupDataSetwwT_ProblemScoresLookupKeyFieldsCoreLookupResultFieldShort	KeyFieldsQstnCoreReadOnly		OnGetTextwwT_QstnsProblemScoreGetTextSizeLookup	  TIntegerFieldwwT_QstnsSampleUnit_idDisplayWidth
	FieldNameSampleUnit_idVisible  TIntegerFieldwwT_QstnsSurvey_IDDisplayWidth
	FieldName	Survey_IDVisible  TIntegerFieldwwT_QstnsIDDisplayWidth
	FieldNameSelQstns_IDVisible  TIntegerFieldwwT_QstnsLanguageDisplayWidth
	FieldNameLanguageVisible  TIntegerFieldwwT_QstnsSectionDisplayWidth
	FieldName
Section_IDVisible  TStringFieldwwT_QstnsTypeDisplayWidth
	FieldNameTypeVisibleSize
  TIntegerFieldwwT_QstnsSubsectionDisplayWidth
	FieldName
SubsectionVisible  TIntegerFieldwwT_QstnsItemDisplayWidth
	FieldNameItemVisible  TIntegerFieldwwT_QstnsSubtypeDisplayWidth
	FieldNameSubtypeVisible  TIntegerFieldwwT_QstnsScaleIDDisplayWidth
	FieldNameScaleIDVisible  TIntegerFieldwwT_QstnsWidthDisplayWidth
	FieldNameWidthVisible  TIntegerFieldwwT_QstnsHeightDisplayWidth
	FieldNameHeightVisible  
TBlobFieldwwT_QstnsRichTextDisplayWidth
	FieldNameRichTextVisibleOnChangewwT_QstnsRichTextChangeBlobTypeftBlobSized  TIntegerFieldwwT_QstnsScalePosDisplayWidth
	FieldNameScalePosVisible  TBooleanFieldwwT_QstnsbitLangReviewDisplayWidth	FieldNamebitLangReviewVisible  TIntegerFieldwwT_QstnsnumMarkCountDisplayWidth
	FieldNamenumMarkCountVisible  TBooleanFieldwwT_QstnsbitMeanable	FieldNamebitMeanableVisible  TIntegerFieldwwT_QstnsnumBubbleCount	FieldNamenumBubbleCountVisible  TIntegerFieldwwT_QstnsScaleFlipped	FieldNameScaleFlippedVisible   TwwQueryww_QueryValidateWithMask	Left Top(  TSaveDialog
SaveDialogTag
DefaultExtdbFilterSurvey (*.db)|*.dbOptionsofOverwritePromptofHideReadOnly Left�Top  TOpenDialog
OpenDialog
DefaultExtdbFileName*.dbFilterSurvey (*.db)|*.dbOptionsofPathMustExistofFileMustExist Left�Top8  TwwDataSource	wwDS_SclsDataSetwwT_SclsLeftXTop:  TwwTablewwT_SclsFiltered		AfterOpenwwT_SclsAfterOpenBeforeClosewwT_SclsBeforeClose	AfterPost	AfterPostBeforeDeletewwT_SclsBeforeDeleteOnFilterRecordEnglishFilterRecordDatabaseName_PRIVIndexFieldNamesQPC_ID;Item	TableNameSel_Scls.DBSyncSQLByRange	NarrowSearchValidateWithMask	LeftXTop TIntegerFieldwwT_SclsSurvey_ID	FieldName	Survey_ID  TIntegerField
wwT_SclsID	FieldNameQPC_ID  TIntegerFieldwwT_SclsItem	FieldNameItem  TIntegerFieldwwT_SclsLanguage	FieldNameLanguage  TStringFieldwwT_SclsType	FieldNameTypeSize
  TStringFieldwwT_SclsLabel	FieldNameLabelSize<  TIntegerFieldwwT_SclsCharSet	FieldNameCharSet  TIntegerFieldwwT_SclsVal	FieldNameVal  
TBlobFieldwwT_SclsRichText	FieldNameRichTextBlobTypeftBlobSized  TIntegerFieldwwT_SclsScaleOrder	FieldName
ScaleOrder  TBooleanFieldwwT_SclsMissing	FieldNameMissing  TIntegerFieldwwT_SclsIntRespType	FieldNameIntRespType   TwwTabletmptbl
AfterClosetmptblAfterCloseDatabaseName_PRIV	TableNamesel_SectOrder.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left�Toph  
TBatchMove	BatchMoveLeft�Top�   TwwDataSource	wwDS_LogoDataSetwwT_LogoLeft� Top:  TwwTablewwT_Logo	AfterPost	AfterPostBeforeDelete	AfterPostDatabaseName_PRIV	TableNameSel_LogoSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top TIntegerField	wwT_LogoX	FieldNameX  TIntegerField	wwT_LogoY	FieldNameY  TIntegerFieldwwT_LogoScaling	FieldNameScaling  TIntegerField
wwT_LogoIDDisplayLabelID	FieldNameQPC_ID  TStringFieldwwT_LogoType	FieldNameTypeSize
  TIntegerFieldwwT_LogoCoverID	FieldNameCoverID  TStringFieldwwT_LogoDescription	FieldNameDescriptionSize<  TIntegerFieldwwT_LogoWidth	FieldNameWidth  TIntegerFieldwwT_LogoHeight	FieldNameHeight  TBooleanFieldwwT_LogoVisible	FieldNameVisible  TIntegerFieldwwT_LogoSurvey_ID	FieldName	Survey_ID  TGraphicFieldwwT_LogoBitmap	FieldNameBitmapBlobType	ftGraphicSize  
TBlobFieldwwT_LogoPCLStream	FieldName	PCLStreamBlobTypeftBlobSized   TwwDataSourcewwDS_TextBoxDataSetwwT_TextBoxLeft� Top:  TwwTablewwT_TextBoxFiltered		AfterOpenwwT_TextBoxAfterOpenBeforeClosewwT_TextBoxBeforeClose	AfterPost	AfterPostBeforeDeletewwT_TextBoxBeforeDeleteOnFilterRecordEnglishFilterRecordDatabaseName_PRIV	TableNameSel_TextBoxSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top TIntegerFieldwwT_TextBoxID	FieldNameQPC_ID  TStringFieldwwT_TextBoxType	FieldNameTypeSize
  TIntegerFieldwwT_TextBoxCoverID	FieldNameCoverID  TIntegerFieldwwT_TextBoxLanguage	FieldNameLanguage  TIntegerFieldwwT_TextBoxX	FieldNameX  TIntegerFieldwwT_TextBoxY	FieldNameY  TIntegerFieldwwT_TextBoxWidth	FieldNameWidth  TIntegerFieldwwT_TextBoxHeight	FieldNameHeight  
TBlobFieldwwT_TextBoxRichText	FieldNameRichTextOnChangewwT_TextBoxRichTextChangeBlobTypeftBlobSized  TIntegerFieldwwT_TextBoxBorder	FieldNameBorder  TIntegerFieldwwT_TextBoxShading	FieldNameShading  TIntegerFieldwwT_TextBoxSurvey_ID	FieldName	Survey_ID  TBooleanFieldwwT_TextBoxBitLangReview	FieldNameBitLangReview  TStringFieldwwT_TextBoxLabel	FieldNameLabelSize<   TwwDataSourcewwDS_PCLDataSetwwT_PCLLeftTop:  TwwTablewwT_PCLFiltered		AfterOpenwwT_PCLAfterOpen
AfterClosewwT_PCLAfterClose	AfterPost	AfterPostBeforeDeletewwT_PCLBeforeDeleteOnFilterRecordEnglishFilterRecordDatabaseName_PRIV	TableNameSel_PCLSyncSQLByRange	NarrowSearchValidateWithMask	LeftTop TIntegerField	wwT_PCLID	FieldNameqpc_ID  TStringFieldwwT_PCLType	FieldNameTypeSize
  TIntegerFieldwwT_PCLCoverID	FieldNameCoverID  TStringFieldwwT_PCLDescription	FieldNameDescriptionSize<  TIntegerFieldwwT_PCLLanguage	FieldNameLanguage  TIntegerFieldwwT_PCLX	FieldNameX  TIntegerFieldwwT_PCLY	FieldNameY  TIntegerFieldwwT_PCLWidth	FieldNameWidth  TIntegerFieldwwT_PCLHeight	FieldNameHeight  
TBlobFieldwwT_PCLPCLStream	FieldName	PCLStreamBlobTypeftBlobSized  TBooleanFieldwwT_PCLKnownDimensions	FieldNameKnownDimensions  TIntegerFieldwwT_PCLSurvey_ID	FieldName	Survey_ID   TwwDataSourcewwDS_TableDefDataSetwwT_TableDefLeftxTop�   TwwTablewwT_TableDefFiltered	DatabaseName_PRIVIndexFieldNamesID	TableNameTableDef.dbSyncSQLByRange	NarrowSearchValidateWithMask	LeftxTop�   TwwDataSource
wwDS_CoverDataSet	wwT_CoverLeftxTop:  TwwTable	wwT_Cover	AfterPost	AfterPostBeforeDelete	AfterPostDatabaseName_PRIVIndexFieldNamesSurvey_ID;SelCover_ID	TableNameSel_Cover.DBSyncSQLByRange	NarrowSearchValidateWithMask	LeftxTop  TwwDataSourcewwDS_TransTBDataSetwwt_TransTBLeft� Top�   TwwTablewwt_TransTB	AfterPost	AfterPostDatabaseName_PRIVIndexFieldNamesSurvey_ID;ID;Language	TableNameSel_TextBoxSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top�  TIntegerFieldwwt_TransTBID	FieldNameID  TStringFieldwwt_TransTBType	FieldNameTypeSize
  TIntegerFieldwwt_TransTBCoverID	FieldNameCoverID  TIntegerFieldwwt_TransTBLanguage	FieldNameLanguage  TIntegerFieldwwt_TransTBX	FieldNameX  TIntegerFieldwwt_TransTBY	FieldNameY  TIntegerFieldwwt_TransTBWidth	FieldNameWidth  TIntegerFieldwwt_TransTBHeight	FieldNameHeight  
TBlobFieldwwt_TransTBRichText	FieldNameRichTextBlobTypeftBlobSized  TIntegerFieldwwt_TransTBBorder	FieldNameBorder  TIntegerFieldwwt_TransTBShading	FieldNameShading  TIntegerFieldwwt_TransTBSurvey_id	FieldName	Survey_ID  TBooleanFieldwwt_TransTBBitLangReview	FieldNameBitLangReview  TStringFieldwwt_TransTBLabel	FieldNameLabelSize<   TwwDataSourcewwDS_TransQDataSet
wwT_TransQLeftTop�   TwwTable
wwT_TransQ	AfterPost	AfterPostDatabaseName_PRIVIndexFieldNamesSurvey_ID;SelQstns_ID;Language	TableNamesel_Qstns.dbSyncSQLByRange	NarrowSearchValidateWithMask	LeftTop�  TStringFieldwwt_TransQPlusMinusDisplayLabel DisplayWidth	FieldName	PlusMinusSize  TStringFieldwwt_TransQLabelDisplayWidth(	FieldNameLabelSize<  TIntegerFieldwwt_TransQScaleIDDisplayWidth
	FieldNameScaleIDVisible  TStringFieldwwt_TransQType	FieldNameTypeVisibleSize
  TIntegerFieldwwt_TransQSectionDisplayWidth	FieldNameSectionVisible  TIntegerFieldwwt_TransQSubsectionDisplayWidth
	FieldName
SubSectionVisible  TIntegerFieldwwt_TransQItemDisplayWidth
	FieldNameItemVisible  TIntegerFieldwwt_TransQLanguage	FieldNameLanguageVisible  TIntegerFieldwwt_TransQWidth	FieldNameWidthVisible  
TBlobFieldwwt_TransQRichText	FieldNameRichTextVisibleBlobType	ftFmtMemoSized  TIntegerFieldwwt_TransQQstnCore	FieldNameQstnCoreVisible  TIntegerFieldwwt_TransQScalePos	FieldNameScalePosVisible  TIntegerFieldwwt_TransQSubtype	FieldNameSubtypeVisible  TIntegerFieldwwt_TransQHeight	FieldNameHeightVisible  TIntegerFieldwwt_TransQSurvey_ID	FieldName	Survey_IDVisible  TIntegerFieldwwt_TransQSelQstns_ID	FieldNameSelQstns_IDVisible  TIntegerFieldwwt_TransQnumMarkCount	FieldNamenumMarkCountVisible  TBooleanFieldwwt_TransQbitLangReview	FieldNameBitLangReview  TBooleanFieldwwT_TransQbitMeanable	FieldNamebitMeanable  TIntegerFieldwwT_TransQnumBubbleCount	FieldNamenumBubbleCount  TIntegerFieldwwT_TransQScaleFlipped	FieldNameScaleFlipped  TIntegerFieldwwT_TransQSampleUnit_id	FieldNameSampleUnit_id   TwwDataSourcewwDS_TransSDataSet
wwT_TransSLeftHTop�   TwwTable
wwT_TransS	AfterPost	AfterPostDatabaseName_PRIVIndexFieldNamesSurvey_ID;ID;Item;Language	TableNameSel_Scls.DBSyncSQLByRange	NarrowSearchValidateWithMask	LeftHTop�  TIntegerFieldwwt_TransSSurvey_id	FieldName	Survey_ID  TIntegerFieldwwt_TransSID	FieldNameID  TStringFieldwwt_TransSType	FieldNameTypeSize
  TIntegerFieldwwt_TransSItem	FieldNameItem  TStringFieldwwt_TransSLabel	FieldNameLabelSize<  TIntegerFieldwwt_TransSCharSet	FieldNameCharSet  TIntegerFieldwwt_TransSVal	FieldNameVal  TIntegerFieldwwt_TransSLanguage	FieldNameLanguage  
TBlobFieldwwt_TransSRichText	FieldNameRichTextBlobTypeftBlobSized  TIntegerFieldwwt_TransSScaleOrder	FieldName
ScaleOrder  TBooleanFieldwwt_TransSMissing	FieldNameMissing  TIntegerFieldwwT_TransSintRespType	FieldNameintRespType   TTable
t_LanguageDatabaseName_PRIV	TableNameSel_Language.DBLeft Top�   TwwDataSourcewwDS_TransPDataSet
wwT_TransPLeft|Top�   TwwTable
wwT_TransP	AfterPost	AfterPostDatabaseName_PRIVIndexFieldNamesSurvey_ID;ID;Language	TableName
Sel_PCL.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left|Top�   TwwDataSource	wwDS_SkipDataSetwwT_SkipLeft<Top:  TwwTablewwT_SkipDatabaseName_PRIVIndexFieldNames*Survey_ID;SelQstns_ID;SelScls_ID;ScaleItem	TableNameSel_Skip.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left<Top TIntegerFieldwwT_SkipSurvey_ID	FieldName	Survey_ID  TIntegerFieldwwT_SkipSelQstns_ID	FieldNameSelQstns_ID  TIntegerFieldwwT_SkipSelScls_ID	FieldName
SelScls_ID  TIntegerFieldwwT_SkipScaleItem	FieldName	ScaleItem  TStringFieldwwT_SkipType	FieldNameTypeSize
  TIntegerFieldwwT_SkipnumSkip	FieldNamenumSkip  TIntegerFieldwwT_SkipnumSkipType	FieldNamenumSkipType   
TBatchMoveBatchMove_SelLogoDestination
t_Logo_SQLMappings.Strings	Survey_IDIDCoverIDDescriptionXYWidthHeightScalingBitmapVisible SourcewwT_LogoLeft�Top�   TTable
t_Logo_SQLDatabaseName_QualProIndexFieldNamesID;CoverID;Survey_id	TableNamedbo.Sel_LogoLeftpTop�   TTablet_PCLObjectDatabaseName_QualPro	TableNamedbo.PCLObjectLeftTop�  TIntegerFieldt_PCLObjectPCLOBJECT_ID	FieldNamePCLOBJECT_IDRequired	  TStringFieldt_PCLObjectPCLObject_dsc	FieldNamePCLObject_dscSize  
TBlobFieldt_PCLObjectPCLStream	FieldName	PCLStreamBlobTypeftBlobSize   TwwTablewwt_PopSectionDatabaseName_PRIV	TableName
PopSectionSyncSQLByRange	NarrowSearchValidateWithMask	Left`Top�   TwwTablewwt_PopCoverDatabaseName_PRIV	TableNamePopCoverSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top�   TwwTablewwt_PopCodeDatabaseName_PRIV	TableNamePopCodeSyncSQLByRange	NarrowSearchValidateWithMask	Left� Top�   	TDatabasedbScan	AliasNameQualProDatabaseName_ScanLoginPromptParams.StringsDATABASE NAME=ODBC DSN=QualProOPEN MODE=READ/WRITEBATCH COUNT=200LANGDRIVER=MAX ROWS=-1SCHEMA CACHE DIR=SCHEMA CACHE SIZE=8SCHEMA CACHE TIME=-1"SQLPASSTHRU MODE=SHARED AUTOCOMMITSQLQRYMODE=ENABLE SCHEMA CACHE=FALSEENABLE BCD=FALSEROWSET SIZE=20BLOBS TO CACHE=64BLOB SIZE=32 SessionNameDefaultLeft�TopX  	TDatabasedbQueue	AliasNameQualProDatabaseName_QueueLoginPromptParams.StringsDATABASE NAME=ODBC DSN=QualProOPEN MODE=READ/WRITEBATCH COUNT=200LANGDRIVER=MAX ROWS=-1SCHEMA CACHE DIR=SCHEMA CACHE SIZE=8SCHEMA CACHE TIME=-1"SQLPASSTHRU MODE=SHARED AUTOCOMMITSQLQRYMODE=ENABLE SCHEMA CACHE=FALSEENABLE BCD=FALSEROWSET SIZE=20BLOBS TO CACHE=64BLOB SIZE=32 SessionNameDefaultLeftHTopX  TwwDataSourcewwDS_ProblemScoresDataSetwwT_ProblemScoresLeft Top�   TwwTablewwT_ProblemScoresFiltered	DatabaseName_PRIV	TableNameProblemScores.DBSyncSQLByRange	NarrowSearchValidateWithMask	Left Top�  TIntegerFieldwwT_ProblemScoresCore	FieldNameCoreRequired	Visible  TIntegerFieldwwT_ProblemScoresVal	AlignmenttaLeftJustifyDisplayWidth	FieldNameValRequired	  TStringFieldwwT_ProblemScoresShortDisplayLabelResponseDisplayWidth#	FieldNameShortSize<  TIntegerField#wwT_ProblemScoresProblem_Score_Flag	FieldNameProblem_Score_FlagVisible  TStringField wwT_ProblemScoresstrProblemScoreDisplayLabelProblem?	FieldNamestrProblemScore  TIntegerFieldwwT_ProblemScoresTransferred	FieldNameTransferredVisible   	TDatabase
dbDataMart	AliasNameDataMartDatabaseName	_DataMartLoginPromptParams.StringsDATABASE NAME=ODBC DSN=DataMartOPEN MODE=READ/WRITEBATCH COUNT=200LANGDRIVER=MAX ROWS=-1SCHEMA CACHE DIR=SCHEMA CACHE SIZE=8SCHEMA CACHE TIME=-1"SQLPASSTHRU MODE=SHARED AUTOCOMMITSQLQRYMODE=ENABLE SCHEMA CACHE=FALSEENABLE BCD=FALSEROWSET SIZE=20BLOBS TO CACHE=64BLOB SIZE=32 SessionNameDefaultLeft� TopX  TStoredProc	sp_QPProdDatabaseName_QualProLeft� Top`   