/*Insert statements for Hospice CAHPS dispositions for sprint 19 story 14.1
Note a new disposition is also being added to the NRC Disposition table for "Ineligible: Never Involved in Decedent Care" Dispo
Also we want to track Hospice late mailings but not giving a final Disposition yet (See spread sheet in sprint 19 
Business Analyst folderfor more info on that.
*/

--New Disposition need to add to NRC Disposition Table First
Insert into Disposition (strDispositionLabel, Action_ID, strReportLabel, MustHaveResults)
values ('Ineligible: Never Involved in Decedent Care', 0, 'Respondant was not involved in Decedant Care', 1)

--Identify the columns needed for Insert Statments SurveyTypeDispositions for Hospice CAHPS additions.
Select *
From SurveyTypeDispositions

--Insert Statements for Hospice CAHPS into SurveyTypeDispositions Table
Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (8,  3,  1, 'Ineligible: Not in Eligible Population'              , 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (3,  2,  2, 'Ineligible: Deceased'                                , 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (2,  8,  3, 'Non-response: Refusal'                               , 0, NULL, 11)

--New Hospice CAHPS disposition crosswalked to above new NRC Disposition.
Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (37,  6,  4, 'Ineligible: Never Involved in Decedent Care'        , 1, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (13,  1,  5, 'Completed Survey'                                   , 1, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (11,  7,  6, 'Non-response: Break-off'                            , 1, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (10,  4,  7, 'Ineligible: Language Barrier'                       , 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values ( 4,  5,  8, 'Ineligible: Mental or Physical Incapacity'          , 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values ( 5, 10, 10, 'Non-response: Non-response: Bad Address'            , 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (14, 11,  9, 'Non-response: Non-response: Bad/No Telephone Number', 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (16, 11,  9, 'Non-response: Non-response: Bad/No Telephone Number', 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (12,  9, 11, 'Non-response: Non-response after max attempts'      , 0, NULL, 11)

Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (25,  9, 11, 'Non-response: Non-response after max attempts'      , 0, NULL, 11)

--More Info Needed on this one want to track Mailed late but not mapping to final Hospice dispo 
Insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
values (15, NULL, NULL, 'Hospice Mailed Late', 0, NULL, 11)