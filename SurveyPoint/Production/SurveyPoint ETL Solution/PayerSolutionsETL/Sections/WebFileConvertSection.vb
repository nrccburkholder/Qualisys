Imports System.Text
Imports System.IO
Imports System.Data

Public Class WebFileConvertSection

#Region " Fields "
    Dim mNavigator As WebFileConvertNavigator
#End Region

#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mNavigator = TryCast(navCtrl, WebFileConvertNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

#End Region

#Region " Event Handlers "

    Private Sub cmdOriginalFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOriginalFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtOriginalFile.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdConvertFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdConvertFile.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtConvertFile.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdConvert_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdConvert.Click
        If GUIValidateImport() Then
            Me.txtResults.Text = "Starting to process file."
            ImportFile()
            Me.txtResults.Text = Me.txtResults.Text & vbCrLf & "Process Complete."
        Else
            MessageBox.Show("You have not given a valid path to either the Original and/or the New file or, you have not selected the conversion type.")
        End If
    End Sub

    Private Sub WebFileConvertSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim sb As New StringBuilder()

        sb.AppendLine("The Web File Convert takes a Coventry 5-Star 2012, Excellus, WellPoint 2011, 5 Star, Highmark, Secblue, or Wellpoint file from Vovici and converts it into a format that Survey Tracker is able to accept.")

        sb.AppendLine("Coventry 5-Star 2012 original format is:")
        sb.AppendLine("Record ID,USER ID (Q2_1),1 (Q1),2 (Q4),3 (Q5),4 (Q66),4a (Q15),4b (Q29),5 (Q55),6 (Q57),7 (Q30_A_1),7 (Q30_A_2),7 (Q30_A_3),7 (Q30_A_4),8 (Q10),9 (Q9),10 (Q31),11 (Q58),12 (Q33),13 (Q11),14 (Q34),14a (Q64),15 (Q35_A_1),15 (Q35_A_2),15 (Q35_A_3),15 (Q35_A_4),15 (Q35_A_5),15 (Q35_A_6),15 (Q35_A_7),15 (Q35_A_8),15 (Q35_A_9),15 (Q35_A_10),15 (Q35_A_11),15 (Q35_A_12),16 (Q59),16a (Q36),17 (Q74),17a (Q38),18 (Q65),18a (Q16_1),18b (Q37),19 (Q75),19a (Q76),20 (Q39_1),20 (Q39_2),21 (Q40),22 (Q67),23 (Q41_A_1),23 (Q41_A_2),23 (Q41_A_3),23 (Q41_A_4),23 (Q41_A_5),24 (Q47),25 (Q43),26 (Q63),27 (Q70),28 (Q71),29 (Q72),30 (Q73),31 (Q3_A_1),31 (Q3_A_2),31 (Q3_A_3),31 (Q3_A_4),31 (Q3_A_5),31 (Q3_A_6),31 (Q3_A_7),31 (Q3_A_8),31 (Q3_A_9),31 (Q3_A_10),31 (Q3_A_11),31 (Q3_A_12),32 (Q51),33 (Q17),34 (Q62),35 (Q24),36 (Q44_1),36 (Q44_2),36 (Q44_3),36 (Q44_4),36 (Q44_5),36 (Q44_6),37 (Q18),38 (Q42),39 (Q19),40 (Q25),41 (Q6),42 (Q60_A_1),42 (Q60_A_2),43 (Q48),44 (Q49),45 (Q46),46 (Q50),47 (Q54),48 (Q26_1),48 (Q26_2),48 (Q26_3),49 (Q56),50 (Q28),51 (Q32),52 (Q52),53 (Q61_1),53 (Q61_2),53 (Q61_3),54 (Q27_1),54 (Q27_2),55 (Q53),Email,Started,Completed,Branched Out,Over Quota,Last Modified,Invitation Status,Campaign Status,Culture,Last Page,Response Source,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,ParticipantURL")
        sb.AppendLine("Coventry 5-Star 2012 converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(9),Key 3,Key 2,BLANK(3),1 (Q1),2 (Q4),BLANK(25),3 (Q5),4 (Q66),4a (Q15),4b (Q29),5 (Q55),6 (Q57),7 (Q30_A_1),7 (Q30_A_2),7 (Q30_A_3),7 (Q30_A_4),8 (Q10),9 (Q9),10 (Q31),11 (Q58),12 (Q33),13 (Q11),14 (Q34),14a (Q64),15 (Q35_A_1),15 (Q35_A_2),15 (Q35_A_3),15 (Q35_A_4),15 (Q35_A_5),15 (Q35_A_6),15 (Q35_A_7),15 (Q35_A_8),15 (Q35_A_9),15 (Q35_A_10),15 (Q35_A_11),15 (Q35_A_12),16 (Q59),16a (Q36),17 (Q74),17a (Q38),18 (Q65),18a (Q16_1),18b (Q37),19 (Q75),19a (Q76),20 (Q39_1),BLANK(23),20 (Q39_2),BLANK(23),21 (Q40),22 (Q67),23 (Q41_A_1),23 (Q41_A_2),23 (Q41_A_3),23 (Q41_A_4),23 (Q41_A_5),24 (Q47),25 (Q43),26 (Q63),27 (Q70),28 (Q71),29 (Q72),30 (Q73),31 (Q3_A_1),31 (Q3_A_2),31 (Q3_A_3),31 (Q3_A_4),31 (Q3_A_5),31 (Q3_A_6),31 (Q3_A_7),31 (Q3_A_8),31 (Q3_A_9),31 (Q3_A_10),31 (Q3_A_11),31 (Q3_A_12),32 (Q51),33 (Q17),34 (Q62),35 (Q24),BLANK(25),36 (Q44_1),36 (Q44_2),36 (Q44_3),36 (Q44_4),36 (Q44_5),36 (Q44_6),37 (Q18),38 (Q42),39 (Q19),40 (Q25),41 (Q6),42 (Q60_A_1),42 (Q60_A_2),43 (Q48),44 (Q49),45 (Q46),46 (Q50),47 (Q54),48 (Q26_1),48 (Q26_2),48 (Q26_3),49 (Q56),50 (Q28),51 (Q32),52 (Q52),53 (Q61_1),53 (Q61_2),53 (Q61_3),54 (Q27_1),54 (Q27_2),55 (Q53)")

        sb.AppendLine("Adult original format is:")
        sb.AppendLine("Record ID,User ID (Q11_1),1 (Q1),2 (Q2),3 (Q13),4 (Q14),4a (Q12),4b (Q3),4c (Q9),5 (Q16_A_1),5 (Q16_A_2),5 (Q16_A_3),5 (Q16_A_4),6 (Q6),7 (Q4),8 (Q10_A_1),8 (Q10_A_2),8 (Q10_A_3),8 (Q10_A_4),8 (Q10_A_5),8 (Q10_A_6),8 (Q10_A_7),8 (Q10_A_8),8 (Q10_A_9),8 (Q10_A_10),8 (Q10_A_11),8 (Q10_A_12),8 (Q10_A_13),8 (Q10_A_14),8 (Q10_A_15),8 (Q10_A_16),8 (Q10_A_17),8 (Q10_A_18),8 (Q10_A_19),8 (Q10_A_20),8 (Q10_A_21),8 (Q10_A_22),8 (Q10_A_23),8 (Q10_A_24),8 (Q10_A_25),8 (Q10_A_26),9 (Q8),10 (Q5),Email,Started,Completed,Branched Out,Over Quota,Last Modified,Invitation Status,Campaign Status,Culture,Last Page,Response Source,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,ParticipantURL")
        sb.AppendLine("Adult converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(9),Key 3,Key 2,BLANK(3),1 (Q1),2 (Q2),4 (Q14),4a (Q12),4b (Q3),4c (Q9),5 (Q16_A_1),5 (Q16_A_2),5 (Q16_A_3),5 (Q16_A_4),6 (Q6),8 (Q10_A_1),8 (Q10_A_2),8 (Q10_A_3),8 (Q10_A_4),8 (Q10_A_5),8 (Q10_A_6),8 (Q10_A_7),8 (Q10_A_8),8 (Q10_A_9),8 (Q10_A_10),8 (Q10_A_11),8 (Q10_A_12),8 (Q10_A_13),8 (Q10_A_14),8 (Q10_A_15),8 (Q10_A_17),8 (Q10_A_18),8 (Q10_A_19),8 (Q10_A_20),8 (Q10_A_21),8 (Q10_A_22),8 (Q10_A_23),8 (Q10_A_24),8 (Q10_A_25),8 (Q10_A_26),8 (Q10_A_16),9 (Q8),10 (Q5)")

        sb.AppendLine("Child original format is:")
        sb.AppendLine("Record ID,Intro (Q20_1),1 (Q1),2 (Q21),2a (Q2),2b (Q3),2c (Q9),3 (Q5),3a (Q6),3b (Q7),3c (Q4),4 (Q8),4a (Q10),4b (Q11),4c (Q12),5 (Q13),5a (Q14),5b (Q15),5c (Q16),6 (Q17),6a (Q22),6b (Q18),6c (Q19),Email,Started,Completed,Branched Out,Over Quota,Last Modified,Invitation Status,Campaign Status,Culture,Last Page,Response Source,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,ParticipantURL")
        sb.AppendLine("Child converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(9),Key 3,Key 2,BLANK(3),1 (Q1),2 (Q21),2a (Q2),2b (Q3),2c (Q9),3 (Q5),3a (Q6),3b (Q7),3c (Q4),4 (Q8),4a (Q10),4b (Q11),4c (Q12),5 (Q13),5a (Q14),5b (Q15),5c (Q16),6 (Q17),6a (Q22),6b (Q18),6c (Q19)")

        sb.AppendLine("Maternity original format is:")
        sb.AppendLine("Record ID,Intro (Q9_1),1 (Q3),2 (Q4),3 (Q18_1),4 (Q7),5 (Q5_1),5 (Q5_2),6 (Q8_1),7 (Q6),8 (Q10_A_1),8 (Q10_A_2),8 (Q10_A_3),8 (Q10_A_4),8 (Q10_A_5),8 (Q10_A_6),8 (Q10_A_7),8 (Q10_A_8),8 (Q10_A_9),8 (Q10_A_10),9 (Q2_A_1),9 (Q2_A_2),9 (Q2_A_3),9 (Q2_A_4),9 (Q2_A_5),9 (Q2_A_6),9 (Q2_A_7),9 (Q2_A_8),9 (Q2_A_9),9 (Q2_A_10),9 (Q2_A_11),10 (Q11_A_1),10 (Q11_A_2),10 (Q11_A_3),10 (Q11_A_4),10 (Q11_A_5),10 (Q11_A_6),10 (Q11_A_7),10 (Q11_A_8),10 (Q11_A_9),10 (Q11_A_10),10 (Q11_A_11),10 (Q11_A_12),10 (Q11_A_13),11 (Q20_A_1),11 (Q20_A_2),11 (Q20_A_3),11 (Q20_A_4),11 (Q20_A_5),11 (Q20_A_6),11 (Q20_A_7),11 (Q20_A_8),11 (Q20_A_9),11 (Q20_A_10),11 (Q20_A_11),11 (Q20_A_12),11 (Q20_A_13),12 (Q21),13 (Q22),14 (Q23),15 (Q12),16 (Q24),17 (Q25),18 (Q26),19 (Q27),20 (Q28),21 (Q29),22 (Q30),23 (Q14_A_1),23 (Q14_A_2),23 (Q14_A_3),24 (Q15_A_1),24 (Q15_A_2),24 (Q15_A_3),25 (Q16),26 (Q13),27 (Q31),28 (Q32),29 (Q33),30 (Q34),31 (Q35),32 (Q19_1),32 (Q19_2),32 (Q19_3),32 (Q19_4),32 (Q19_5),32 (Q19_6),33 (Q36),33 (Q36SPECIFIED_3),34 (Q1),34 (Q1SPECIFIED_3),Email,Started,Completed,Branched Out,Over Quota,Last Modified,Invitation Status,Campaign Status,Culture,Last Page,Response Source,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,ParticipantURL")
        sb.AppendLine("Maternity converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(9),Key 3,Key 2,BLANK(19),32 (Q19_1),32 (Q19_2),32 (Q19_3),32 (Q19_4),32 (Q19_5),32 (Q19_6),33 (Q36),33 (Q36SPECIFIED_3),34 (Q1),34 (Q1SPECIFIED_3),1 (Q3),2 (Q4),3 (Q18_1),7 (Q6),4 (Q7),5 (Q5_1),5 (Q5_2),6 (Q8_1),8 (Q10_A_1),9 (Q2_A_1),8 (Q10_A_2),9 (Q2_A_2),8 (Q10_A_3),9 (Q2_A_3),8 (Q10_A_4),9 (Q2_A_4),8 (Q10_A_5),8 (Q10_A_6),8 (Q10_A_7),8 (Q10_A_8),9 (Q2_A_5),8 (Q10_A_9),9 (Q2_A_6),8 (Q10_A_10),9 (Q2_A_7),9 (Q2_A_8),9 (Q2_A_9),9 (Q2_A_10),9 (Q2_A_11),10 (Q11_A_1),BLANK(1),11 (Q20_A_1),10 (Q11_A_2),BLANK(1),11 (Q20_A_2),10 (Q11_A_3),BLANK(1),11 (Q20_A_3),10 (Q11_A_4),BLANK(1),11 (Q20_A_4),10 (Q11_A_5),BLANK(1),11 (Q20_A_5),10 (Q11_A_6),BLANK(1),11 (Q20_A_6),10 (Q11_A_7),BLANK(1),11 (Q20_A_7),10 (Q11_A_8),BLANK(1),11 (Q20_A_8),10 (Q11_A_9),BLANK(1),11 (Q20_A_9),10 (Q11_A_10),BLANK(1),11 (Q20_A_10),10 (Q11_A_11),BLANK(1),11 (Q20_A_11),10 (Q11_A_12),BLANK(1),11 (Q20_A_12),10 (Q11_A_13),BLANK(1),11 (Q20_A_13),12 (Q21),13 (Q22),14 (Q23),15 (Q12),16 (Q24),17 (Q25),18 (Q26),19 (Q27),20 (Q28),21 (Q29),22 (Q30),23 (Q14_A_1),23 (Q14_A_2),23 (Q14_A_3),24 (Q15_A_1),24 (Q15_A_2),24 (Q15_A_3),25 (Q16),26 (Q13),27 (Q31),28 (Q32),29 (Q33),30 (Q34),31 (Q35)")

        sb.AppendLine("Excellus original format is:")
        sb.AppendLine("Record ID,WEBACCESSCODE (Q2_1),Email Address (Q13_1),Unique ID (Q14_1),Date Submitted (Q20_1),IP Address (Q21_1),Language (Q22_1),Submission Key (Q23_1),Skipfield (Q114_1),BATCHID (Q115_1),Skipfield1 (Q116_1),FAQs (Q45_1),TEMPLATEDID (Q112_1),RespondentID (Q113_1),FIRSTNAME (Q7_1),LASTNAME (Q8_1),DOB (Q12_1),Skipfield2 (Q117_1),WEBACCESSCODE (Q98_1),Rate health (Q1),Rate Mental Health  (Q57),Overnight in the last 12 mo (Q4),Heart failure hospitalization (Q5),Doctor Visits (Q18),Diabetes (Q9),Heart Health (Q19_A_1),Heart Health (Q19_A_2),Heart Health (Q19_A_3),Heart Health (Q19_A_4),Currently being treated for heart problems (Q10),Neighbor (Q15),Help bathe (Q29),Help taking Meds (Q31),Health Interfere Daily  (Q55),Trouble with Doctor and Shopping  (Q58),Help with Doctor and Shopping  (Q34),Exercise (Q16),Fallen in past 12 months (Q11),BMD Test  (Q33),Hip Fracture  (Q59),Stay at home (Q74),Bored (Q78),Helpless (Q79),Basically Satisfied (Q80),Feel Worthless (Q81),Bladder (Q37),Bladder - Doctor (Q64),Currently being treated for (Q35_A_1),Currently being treated for (Q35_A_2),Currently being treated for (Q35_A_3),Currently being treated for (Q35_A_4),Currently being treated for (Q35_A_5),Currently being treated for (Q35_A_6),Currently being treated for (Q35_A_7),Currently being treated for (Q35_A_8),Currently being treated for (Q35_A_9),Other health conditions (Q36),Describe other health conditions (Q38),Advance directives (Q26),Conversation - Health Care Proxy  (Q3),MOLST (Q6),Help with Questionnaire (Q17),Information on the person who helped fill out the form (Q61_1),Information on the person who helped fill out the form (Q61_2),Information on the person who helped fill out the form (Q61_3),Email,Started,Completed,Last Modified,Key 1,Key 2,Key 3")
        sb.AppendLine("Excellus converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(1),FAQs (Q45_1),TEMPLATEDID (Q112_1),RespondentID (Q113_1),BLANK(3),Rate health (Q1),Rate Mental Health  (Q57),Overnight in the last 12 mo (Q4),Heart failure hospitalization (Q5),Doctor Visits (Q18),Diabetes (Q9),Heart Health (Q19_A_1),Heart Health (Q19_A_2),Heart Health (Q19_A_3),Heart Health (Q19_A_4),Currently being treated for heart problems (Q10),Neighbor (Q15),Help bathe (Q29),Help taking Meds (Q31),Health Interfere Daily  (Q55),Trouble with Doctor and Shopping  (Q58),Help with Doctor and Shopping  (Q34),Exercise (Q16),Fallen in past 12 months (Q11),BMD Test  (Q33),Hip Fracture  (Q59),Stay at home (Q74),Bored (Q78),Helpless (Q79),Basically Satisfied (Q80),Feel Worthless (Q81),Bladder (Q37),Bladder - Doctor (Q64),Currently being treated for (Q35_A_1),Currently being treated for (Q35_A_2),Currently being treated for (Q35_A_3),Currently being treated for (Q35_A_4),Currently being treated for (Q35_A_5),Currently being treated for (Q35_A_6),Currently being treated for (Q35_A_7),Currently being treated for (Q35_A_8),Currently being treated for (Q35_A_9),Other health conditions (Q36),Describe other health conditions (Q38),Advance directives (Q26),Conversation - Health Care Proxy  (Q3),MOLST (Q6),Help with Questionnaire (Q17),Information on the person who helped fill out the form (Q61_1),Information on the person who helped fill out the form (Q61_2),Information on the person who helped fill out the form (Q61_3)")

        sb.AppendLine("WellPoint 2011 original format is:")
        sb.AppendLine("Record ID,WEBACCESSCODE (Q2_1),Email Address (Q13_1),Unique ID (Q14_1),Date Submitted (Q20_1),IP Address (Q21_1),Language (Q22_1),Submission Key (Q23_1),Skipfield (Q114_1),BATCHID (Q115_1),Skipfield1 (Q116_1),FAQs (Q45_1),TEMPLATEDID (Q112_1),RespondentID (Q113_1),FIRSTNAME (Q7_1),LASTNAME (Q8_1),DOB (Q12_1),Skipfield2 (Q117_1),WEBACCESSCODE (Q98_1),Rate health (Q1),Surgery in the last 12 mo (Q4),Lost 10 lbs (Q5),Diabetes (Q9),Protein test (Q15),Hemoglobin A1c (Q29),Cholesterol (Q55),Heart Health (Q30_A_1),Heart Health (Q30_A_2),Heart Health (Q30_A_3),Heart Health (Q30_A_4),Currently being treated for heart problems (Q10),Eyesight (Q31),Fallen in past 12 months (Q33),""Broken Hip, wrist, spine or rib  (Q11)"",Joint replacement (Q16),Bladder (Q34),Bladder - Doctor (Q64),Currently being treated for (Q35_A_1),Currently being treated for (Q35_A_2),Currently being treated for (Q35_A_3),Currently being treated for (Q35_A_4),Currently being treated for (Q35_A_5),Currently being treated for (Q35_A_6),Currently being treated for (Q35_A_7),Currently being treated for (Q35_A_8),Currently being treated for (Q35_A_9),Currently being treated for (Q35_A_10),Currently being treated for (Q35_A_11),Currently being treated for (Q35_A_12),Other health conditions (Q36),Describe other health conditions (Q38),Rheumatoid Arthritis (Q74),Arthritis Medication (Q68),COPD (Q67),Spirometry Testing (Q66),High Blood Pressure (Q65),Blood Pressure reading (Q37_1),Congestive Heart Failure (Q75),Hospitalized for CHF (Q76),Medicines (Q39_1),Medicines (Q39_2),Practitioner reviewed medicines (Q40),Treating with medicines? (Q41_A_1),Treating with medicines? (Q41_A_2),Treating with medicines? (Q41_A_3),Treating with medicines? (Q41_A_4),Treating with medicines? (Q41_A_5),Flu Shot (Q43),Pneumonia shot (Q47),Eye Exam (Q51),Bone Mineral Density Test (Q60),Talked to doctor about BMD (Q69),Meds for bone strength (Q63),Mammogram (Q70),Fecal Occult Blood Test (Q71),Sigmoidoscopy (Q72),Colonoscopy (Q73),Help with activities (Q3_A_1),Help with activities (Q3_A_2),Help with activities (Q3_A_3),Help with activities (Q3_A_4),Help with activities (Q3_A_5),Help with activities (Q3_A_6),Help with activities (Q3_A_7),Help with activities (Q3_A_8),Help with activities (Q3_A_9),Help with activities (Q3_A_10),Help with activities (Q3_A_11),Help with activities (Q3_A_12),Help with activities (Q3_A_13),Statement of health that fits best (Q17),Need help and unable to get help (Q62),Where do you currently live (Q24),Where do you currently live (Q24SPECIFIED_4),Describe your living arrangement (Q44_1),Describe your living arrangement (Q44_2),Describe your living arrangement (Q44_3),Describe your living arrangement (Q44_4),Describe your living arrangement (Q44_5),Describe your living arrangement (Q44_6),Health conditions interfere with daily activities (Q18),Inpatient (Q42),Emergency room (Q19),Doc Visits (Q25),Recent loss of a loved one (Q6),Little interest in doing things  (Q52),Feeling down (Q53),Are you a caregiver (Q48),Friend relative neighbor (Q49),Apply to nursing home (Q46),Nursing home/convalescent hospital (Q50),5 or more weeks in nursing home (Q54),Advance directives (Q26_1),Advance directives (Q26_2),Advance directives (Q26_3),Information on file with doctor (Q56),Receiving medical assistance (Q28),Help with form (Q32),Information on the person who helped fill out the form (Q61_1),Information on the person who helped fill out the form (Q61_2),Information on the person who helped fill out the form (Q61_3),Doctor's name and phone number (Q27_1),Doctor's name and phone number (Q27_2),Email,Started,Completed,Last Modified,Key 1,Key 2,Key 3")
        sb.AppendLine("WellPoint 2011 converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(1),FAQs (Q45_1),TEMPLATEDID (Q112_1),RespondentID (Q113_1),BLANK(3),Rate health (Q1),Surgery in the last 12 mo (Q4),Lost 10 lbs (Q5),Diabetes (Q9),Protein test (Q15),Hemoglobin A1c (Q29),Cholesterol (Q55),Heart Health (Q30_A_1),Heart Health (Q30_A_2),Heart Health (Q30_A_3),Heart Health (Q30_A_4),Currently being treated for heart problems (Q10),Eyesight (Q31),Fallen in past 12 months (Q33),""Broken Hip, wrist, spine or rib  (Q11)"",Joint replacement (Q16),Bladder (Q34),Bladder - Doctor (Q64),Currently being treated for (Q35_A_1),Currently being treated for (Q35_A_2),Currently being treated for (Q35_A_3),Currently being treated for (Q35_A_4),Currently being treated for (Q35_A_5),Currently being treated for (Q35_A_6),Currently being treated for (Q35_A_7),Currently being treated for (Q35_A_8),Currently being treated for (Q35_A_9),Currently being treated for (Q35_A_10),Currently being treated for (Q35_A_11),Currently being treated for (Q35_A_12),Other health conditions (Q36),Describe other health conditions (Q38),Rheumatoid Arthritis (Q74),Arthritis Medication (Q68),COPD (Q67),Spirometry Testing (Q66),High Blood Pressure (Q65),Blood Pressure reading (Q37_1),Congestive Heart Failure (Q75),Hospitalized for CHF (Q76),Medicines (Q39_1),Medicines (Q39_2),Practitioner reviewed medicines (Q40),Treating with medicines? (Q41_A_1),Treating with medicines? (Q41_A_2),Treating with medicines? (Q41_A_3),Treating with medicines? (Q41_A_4),Treating with medicines? (Q41_A_5),Flu Shot (Q43),Pneumonia shot (Q47),Eye Exam (Q51),Bone Mineral Density Test (Q60),Talked to doctor about BMD (Q69),Meds for bone strength (Q63),Mammogram (Q70),Fecal Occult Blood Test (Q71),Sigmoidoscopy (Q72),Colonoscopy (Q73),Help with activities (Q3_A_1),Help with activities (Q3_A_2),Help with activities (Q3_A_3),Help with activities (Q3_A_4),Help with activities (Q3_A_5),Help with activities (Q3_A_6),Help with activities (Q3_A_7),Help with activities (Q3_A_8),Help with activities (Q3_A_9),Help with activities (Q3_A_10),Help with activities (Q3_A_11),Help with activities (Q3_A_12),Help with activities (Q3_A_13),Statement of health that fits best (Q17),Need help and unable to get help (Q62),Where do you currently live (Q24),Where do you currently live (Q24SPECIFIED_4),Describe your living arrangement (Q44_1),Describe your living arrangement (Q44_2),Describe your living arrangement (Q44_3),Describe your living arrangement (Q44_4),Describe your living arrangement (Q44_5),Describe your living arrangement (Q44_6),Health conditions interfere with daily activities (Q18),Inpatient (Q42),Emergency room (Q19),Doc Visits (Q25),Recent loss of a loved one (Q6),Little interest in doing things  (Q52),Feeling down (Q53),Are you a caregiver (Q48),Friend relative neighbor (Q49),Apply to nursing home (Q46),Nursing home/convalescent hospital (Q50),5 or more weeks in nursing home (Q54),Advance directives (Q26_1),Advance directives (Q26_2),Advance directives (Q26_3),Information on file with doctor (Q56),Receiving medical assistance (Q28),Help with form (Q32),Information on the person who helped fill out the form (Q61_1),Information on the person who helped fill out the form (Q61_2),Information on the person who helped fill out the form (Q61_3),Doctor's name and phone number (Q27_1),Doctor's name and phone number (Q27_2)")

        sb.AppendLine("5 Star original format is:")
        sb.AppendLine("Record ID,WEBACCESSCODE (Q2_1),Email Address (Q13_1),RespondentID (Q113_1),TEMPLATEDID (Q112_1),FAQs (Q45_1),WEBACCESSCODE (Q98_1),Rate health (Q1),Diabetes (Q9),Protein test (Q15),Hemoglobin A1c (Q29),Fallen in past 12 months (Q33),Joint replacement (Q16),Bladder (Q34),Currently treated for Rueumatoid Arthritis (Q3),Meds for Rheumatoid (Q6),Currently treated for COPD (Q10),Spirometry Testing (Q11),Currently treated high blood pressure (Q17),Blood Pressure reading (Q37_1),Blood Pressure reading (Q37_2),Medicines (Q39_1),Medicines (Q39_2),Meds for bone strength (Q5),Practitioner reviewed medicines (Q4),Treating with medicines? (Q41_A_1),Treating with medicines? (Q41_A_2),Treating with medicines? (Q41_A_3),Treating with medicines? (Q41_A_4),Treating with medicines? (Q41_A_5),Flu Shot (Q43),Pneumonia shot (Q47),Eye Exam (Q51),Bone Mineral Density Test (Q60),Talk to Doc about BMD Test (Q24),Cholesterol check (Q18),Broken bone since age 45  (Q19),Mammogram (Q70),Fecal Occult Blood Test (Q71),Sigmoidoscopy (Q72),Colonoscopy (Q73),Customer service - received help? (Q57),Customer service - courtesy and respect? (Q58),Customer service - Forms (Q59),E-mail,Started,Completed,Last Modified,Key 1,Key 2,Key 3")
        sb.AppendLine("5 Star converted format is:")
        sb.AppendLine("BLANK(1),Last Modified,BLANK(1),FAQs (Q45_1),TEMPLATEDID (Q112_1),RespondentID (Q113_1),BLANK(2),Rate health (Q1),Diabetes (Q9),Protein test (Q15),Hemoglobin A1c (Q29),Fallen in past 12 months (Q33),Joint replacement (Q16),Bladder (Q34),Currently treated for Rueumatoid Arthritis (Q3),Meds for Rheumatoid (Q6),Currently treated for COPD (Q10),Spirometry Testing (Q11),Currently treated high blood pressure (Q17),Blood Pressure reading (Q37_1),Blood Pressure reading (Q37_2),Medicines (Q39_1),Medicines (Q39_2),Practitioner reviewed medicines (Q4),Treating with medicines? (Q41_A_1),Treating with medicines? (Q41_A_2),Treating with medicines? (Q41_A_3),Treating with medicines? (Q41_A_4),Treating with medicines? (Q41_A_5),Meds for bone strength (Q5),Flu Shot (Q43),Pneumonia shot (Q47),Eye Exam (Q51),Bone Mineral Density Test (Q60),Mammogram (Q70),Fecal Occult Blood Test (Q71),Sigmoidoscopy (Q72),Colonoscopy (Q73),Customer service - received help? (Q57),Customer service - courtesy and respect? (Q58),Customer service - Forms (Q59),Cholesterol check (Q18),Talk to Doc about BMD Test (Q24),Broken bone since age 45  (Q19)")

        sb.AppendLine("Highmark original format is:")
        sb.AppendLine("Record ID,WEBACCESSCODE (Q1_1),Email Address (Q8_1),Unique ID (Q10_1),Date Submitted (Q11_1),IP Address (Q12_1),Language (Q13_1),Submission Key (Q14_1),Skipfield (Q86_1),BATCHID (Q87_1),Skipfield1 (Q88_1),Skipfield2 (Q89_1),RespondentID (Q97_1),TemplateID (Q90_1),ProjectID (Q91_1),FAQSSTEMPLATEID (Q92_1),FIRSTNAME (Q5_1),LASTNAME (Q6_1),DOB (Q7_1),WEBACCESSCODE (Q95_1),5 - Rate health (Q9),117 - Health comparison (Q55),7 Rxs (Q2_1),205 Non-prescription meds (Q3_1),118 Forget to take meds (Q20),11 Inpatient (Q17),132 Emergency room (Q18),13 Doc visits (Q21),Need help with following tasks (Q23_A_1),Need help with following tasks (Q23_A_2),Need help with following tasks (Q23_A_3),Need help with following tasks (Q23_A_4),Need help with following tasks (Q23_A_5),Need help with following tasks (Q23_A_6),Need help with following tasks (Q23_A_7),Need help with following tasks (Q23_A_8),Need help with following tasks (Q23_A_9),Need help with following tasks (Q23_A_10),Need help with following tasks (Q23_A_11),Need help with following tasks (Q23_A_12),Need help with following tasks (Q23_A_13),48 Diabetes (Q22),Have you ever had (Q24_A_1),Have you ever had (Q24_A_2),Have you ever had (Q24_A_3),Have you ever had (Q24_A_4),Has a physician ever told you that you have (Q25_A_1),Has a physician ever told you that you have (Q25_A_2),Has a physician ever told you that you have (Q25_A_3),Has a physician ever told you that you have (Q25_A_4),206 Eye exam with Glaucoma screening (Q26),119 Meds for supplements for bones (Q27),207 Bone mineral density test (Q28),Currently receiving medical treatment for: (Q32_1),Currently receiving medical treatment for: (Q32_2),Currently receiving medical treatment for: (Q32_3),Currently receiving medical treatment for: (Q32_4),Currently receiving medical treatment for: (Q32_5),Currently receiving medical treatment for: (Q32_6),Currently receiving medical treatment for: (Q32_7),Currently receiving medical treatment for: (Q32_8),Currently receiving medical treatment for: (Q32_9),Currently receiving medical treatment for: (Q32_10),Currently receiving medical treatment for: (Q32_11),Currently receiving medical treatment for: (Q32_12),Currently receiving medical treatment for: (Q32_13),Currently receiving medical treatment for: (Q32_14),Currently receiving medical treatment for: (Q32_15),Currently receiving medical treatment for: (Q32_16),Currently receiving medical treatment for: (Q32_17),Currently receiving medical treatment for: (Q32_18),96 Health conditions interfere with daily activities (Q33),217 Pain during the past 4 wks (Q67),120 Broken bone since age 45 (Q68),218 Baldder control problems (Q69),219 Talked to your doctor about bladder control problem (Q70),113 Flu shot (Q30),114 Pneumonia vaccine (Q31),141 Use of tobacco products cigarettes (Q34),139 Use of tobacco products - pipe or cigar (Q98),140 Use of tobacco products smokeless (Q99),122 Drinks per day (Q35),10 Sad (Q36),80 feeling worthless (Q37),81 get bored (Q38),82 Feel helpless (Q39),83 Satisfied with your life (Q40),84 Prefer to stay at home (Q41),123 Exercise 30 minutes (Q42),220 Exercise programs (Q72),9 Fallen in the past 12 mo (Q43),8 - Lost 10 lbs  (Q15),124 Height decreased  (Q44),125 Height (Q46_1),125 Height (Q46_2),126 Weight (Q53_1),221 Be physically active (Q73_A_1),221 Be physically active (Q73_A_2),221 Be physically active (Q73_A_3),221 Be physically active (Q73_A_4),75 Where do you currently live (Q47),75 Where do you currently live (Q47SPECIFIED_4),133 Live with 5 choices (Q48_1),133 Live with 5 choices (Q48_2),133 Live with 5 choices (Q48_3),133 Live with 5 choices (Q48_4),133 Live with 5 choices (Q48_5),133 Live with 5 choices (Q48SPECIFIED_5),Additional comments (Q48COMMENT),95 Friend relative or neighbor (Q49),225 Advanced Directive Completed (Q4),226 Copy on file with Doc (Q76),227 Income for individuals living alone (Q78),228 Income living with spouse/others (Q79),131 Name of your PCP (Q80_1),System (QSYSTEM_1),System (QSYSTEM_2),System (QSYSTEM_3),Record ID,E-mail,Started,Completed,Last Modified,Invitation Status,Campaign Status,Culture,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,Last Page")
        sb.AppendLine("Highmark converted format is:")
        sb.AppendLine("Email Address ,Unique ID ,Date Submitted ,IP Address ,Language ,Submission Key ,Skipfield ,BATCHID,Skipfield1 ,Skipfield2 ,RespondentID ,TemplateID,ProjectID,FAQSSTEMPLATEID,WEBACCESSCODE (Q95_1),Rate Health  - 5,Health Comparison - 117,Rxs - 7,Non-Prescription Meds - 205,Forget to take meds - 118,Inpatient - 11,Emergency room - 132,Doc visits - 13,'For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 14','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 15','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 16','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 17','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 19','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 20','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 21','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 22','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 23','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 24','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 25','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 18','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 26',Diabetes - 48,Heart problems : 49,Heart problems : 50,Heart problems : 51,Heart problems : 52,Has a physician ever told you : 127,Has a physician ever told you : 128,Has a physician ever told you : 129,Has a physician ever told you : 130,Eye exam with glaucoma screening - 206,Meds or supplements for bones - 119,Bone Mineral Density Test - 207,Currently receiving medical treatment : 57,Currently receiving medical treatment : 53,Currently receiving medical treatment : 59,Currently receiving medical treatment : 60,Currently receiving medical treatment : 61,Currently receiving medical treatment : 62,Currently receiving medical treatment : 63,Currently receiving medical treatment : 208,Currently receiving medical treatment : 68,Currently receiving medical treatment : 69,Currently receiving medical treatment : 209,Currently receiving medical treatment : 210,Currently receiving medical treatment : 212,Currently receiving medical treatment : 212,Currently receiving medical treatment : 213,Currently receiving medical treatment : 214,Currently receiving medical treatment : 215,Currently receiving medical treatment : 216,Health conditions interfere with daily activities - 96,Pain during the past 4 wks - 217,Broken bone since age 45 - 120,Bladder control problems - 218,Talked with doctor about bladder problem - 219,Flu shot - 113,Pneumonia vaccine - 114,Average daily use of tobacco products - 141,Smoke a pipe or cigar - 139,Do you use smokeless tobacco products - 140,How many alcoholic drinks a day - 122,Sad - 10,Feel worthless - 80,Get bored - 81,Feel helpless - 82,Satisfied with life - 83,Prefer to stay at home - 84,Exercise for 30 min day - 123,Exercise programs - 220,Fallen in past 12 mo - 9,Lost 10 lbs - 8,Height decreased 2 or more inches since age 50 - 124,Height - 125 :,Height - 125 :,Weight - 126 :,Be physically active - 221 : 221,Be physically active - 221 : 222,Be physically active - 221 : 223,Be physically active - 221 : 224,Where do you currently live - 75,Where do you currently live - 75 : OtherText,Live with - 133 : 1,Live with - 133 : 1,Live with - 133 : 1,Live with - 133 : 1,Live with - 133 : 5,Live with - 133 : OtherText,Live with - 133 : CommentText,'Friend, relative, neighbor - 95',Advanced directives - 225,Copy of advanced directives on file with physician - 226,Income individuals alone - 227,Individuals living with others - 228,name of physician - 131'")

        sb.AppendLine("Secblue original format is:")
        sb.AppendLine("Record ID,WEBACCESSCODE (Q1_1),Email Address (Q10_1),Unique ID (Q11_1),Date Submitted (Q12_1),IP Address (Q13_1),Language (Q14_1),Submission Key (Q16_1),Skipfield (Q86_1),BATCHID (Q87_1),Skipfield1 (Q88_1),Skipfield2 (Q89_1),RespondentID (Q97_1),TemplateID (Q90_1),ProjectID (Q91_1),FAQSSTEMPLATEID (Q92_1),FIRSTNAME (Q6_1),LASTNAME (Q7_1),DOB (Q8_1),1 - Rate health (5) (Q9),117 - Health comparison (Q55),7 Rxs (Q2_1),205 Non-prescription meds (Q3_1),118 Forget to take meds (Q20),6 - Inpatient (11) (Q17),132 Emergency room (Q18),8 - Doc visits (13) (Q21),Need help with following tasks (Q23_A_1),Need help with following tasks (Q23_A_2),Need help with following tasks (Q23_A_3),Need help with following tasks (Q23_A_4),Need help with following tasks (Q23_A_5),Need help with following tasks (Q23_A_6),Need help with following tasks (Q23_A_7),Need help with following tasks (Q23_A_8),Need help with following tasks (Q23_A_9),Need help with following tasks (Q23_A_10),Need help with following tasks (Q23_A_11),Need help with following tasks (Q23_A_12),Need help with following tasks (Q23_A_13),48 Diabetes (Q22),Have you ever had (Q24_A_1),Have you ever had (Q24_A_2),Have you ever had (Q24_A_3),Have you ever had (Q24_A_4),Has a physician ever told you that you have (Q25_A_1),Has a physician ever told you that you have (Q25_A_2),Has a physician ever told you that you have (Q25_A_3),Has a physician ever told you that you have (Q25_A_4),206 Eye exam with Glaucoma screening (Q26),119 Meds for supplements for bones (Q27),207 Bone mineral density test (Q28),Currently receiving medical treatment for: (Q32_1),Currently receiving medical treatment for: (Q32_2),Currently receiving medical treatment for: (Q32_3),Currently receiving medical treatment for: (Q32_4),Currently receiving medical treatment for: (Q32_5),Currently receiving medical treatment for: (Q32_6),Currently receiving medical treatment for: (Q32_7),Currently receiving medical treatment for: (Q32_8),Currently receiving medical treatment for: (Q32_9),Currently receiving medical treatment for: (Q32_10),Currently receiving medical treatment for: (Q32_11),Currently receiving medical treatment for: (Q32_12),Currently receiving medical treatment for: (Q32_13),Currently receiving medical treatment for: (Q32_14),Currently receiving medical treatment for: (Q32_15),Currently receiving medical treatment for: (Q32_16),Currently receiving medical treatment for: (Q32_17),Currently receiving medical treatment for: (Q32_18),96 Health conditions interfere with daily activities (Q33),217 Pain during the past 4 wks (Q67),120 Broken bone since age 45 (Q68),218 Baldder control problems (Q69),219 Talked to your doctor about bladder control problem (Q70),113 Flu shot (Q30),114 Pneumonia vaccine (Q31),141 Use of tobacco products cigarettes (Q34),139 Use of tobacco products - pipe or cigar (Q98),140 Use of tobacco products smokeless (Q99),122 Drinks per day (Q35),10 Sad (Q36),80 feeling worthless (Q37),81 get bored (Q38),82 Feel helpless (Q39),83 Satisfied with your life (Q40),84 Prefer to stay at home (Q41),123 Exercise 30 minutes (Q42),220 Exercise programs (Q72),9 Fallen in the past 12 mo (Q43),8 - Lost 10 lbs  (Q15),124 Height decreased  (Q44),125 Height (Q46_1),125 Height (Q46_2),126 Weight (Q53_1),221 Be physically active (Q73_A_1),221 Be physically active (Q73_A_2),221 Be physically active (Q73_A_3),221 Be physically active (Q73_A_4),75 where do you currently live (Q5),75 where do you currently live (Q5SPECIFIED_4),133 Live with 5 choices (Q48_1),133 Live with 5 choices (Q48_2),133 Live with 5 choices (Q48_3),133 Live with 5 choices (Q48_4),133 Live with 5 choices (Q48_5),133 Live with 5 choices (Q48SPECIFIED_5),Additional comments (Q48COMMENT),95 Friend relative or neighbor (Q49),225 Advanced Directive Completed (Q4),226 Copy on file with Doc (Q76),227 Income for individuals living alone (Q78),228 Income living with spouse/others (Q79),131 Name of your PCP (Q80_1),System (QSYSTEM_1),System (QSYSTEM_2),System (QSYSTEM_3),Record ID,E-mail,Started,Completed,Last Modified,Invitation Status,Campaign Status,Culture,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,Last Page'")
        sb.AppendLine("Secblue converted format is:")
        sb.AppendLine("Email Address,Unique ID,Date Submitted,IP Address,Language,Submission Key,Skipfield,BATCHID,Skipfield1,Skipfield2,RespondentID,TemplateID,ProjectID,FAQSSTEMPLATEID,WEBACCESSCODE,Rate Health  - 5,Health Comparison - 117,Rxs - 7,Non-Prescription Meds - 205,Forget to take meds - 118,Inpatient - 11,Emergency room - 132,Doc visits - 13,'For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 14','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 15','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 16','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 17','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 19','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 20','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 21','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 22','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 23','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 24','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 25','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 18','For each of the activities below, indicate whether you are able to do this&nbsp;without help, need some help or cannot do this at all without help. : 26',Diabetes - 48,Heart problems : 49,Heart problems : 50,Heart problems : 51,Heart problems : 52,Has a physician ever told you : 127,Has a physician ever told you : 128,Has a physician ever told you : 129,Has a physician ever told you : 130,Eye exam with glaucoma screening - 206,Meds or supplements for bones - 119,Bone Mineral Density Test - 207,Currently receiving medical treatment : 57,Currently receiving medical treatment : 53,Currently receiving medical treatment : 59,Currently receiving medical treatment : 60,Currently receiving medical treatment : 61,Currently receiving medical treatment : 62,Currently receiving medical treatment : 63,Currently receiving medical treatment : 208,Currently receiving medical treatment : 68,Currently receiving medical treatment : 69,Currently receiving medical treatment : 209,Currently receiving medical treatment : 210,Currently receiving medical treatment : 212,Currently receiving medical treatment : 212,Currently receiving medical treatment : 213,Currently receiving medical treatment : 214,Currently receiving medical treatment : 215,Currently receiving medical treatment : 216,Health conditions interfere with daily activities - 96,Pain during the past 4 wks - 217,Broken bone since age 45 - 120,Bladder control problems - 218,Talked with doctor about bladder problem - 219,Flu shot - 113,Pneumonia vaccine - 114,Average daily use of tobacco products - 141,Smoke a pipe or cigar - 139,Do you use smokeless tobacco products - 140,How many alcoholic drinks a day - 122,Sad - 10,Feel worthless - 80,Get bored - 81,Feel helpless - 82,Satisfied with life - 83,Prefer to stay at home - 84,Exercise for 30 min day - 123,Exercise programs - 220,Fallen in past 12 mo - 9,Lost 10 lbs - 8,Height decreased 2 or more inches since age 50 - 124,Height - 125 :,Height - 125 :,Weight - 126 :,Be physically active - 221 : 221,Be physically active - 221 : 222,Be physically active - 221 : 223,Be physically active - 221 : 224,Where do you currently live - 75,Where do you currently live - 75 : OtherText,Live with - 133 : 1,Live with - 133 : 1,Live with - 133 : 1,Live with - 133 : 1,Live with - 133 : 5,Live with - 133 : OtherText,Live with - 133 : CommentText,'Friend, relative, neighbor - 95',Advanced directives - 225,Copy of advanced directives on file with physician - 226,Income individuals alone - 227,Individuals living with others - 228,name of physician - 131")

        sb.AppendLine("Wellpoint original format is:")
        sb.AppendLine("Record ID,WEBACCESSCODE (Q2_1),Email Address (Q13_1),Unique ID (Q14_1),Date Submitted (Q20_1),IP Address (Q21_1),Language (Q22_1),Submission Key (Q23_1),Skipfield (Q114_1),BATCHID (Q115_1),Skipfield1 (Q116_1),FAQSS_TEMPLATE_ID (Q111_1),TEMPLATEDID (Q112_1),RespondentID (Q113_1),FIRSTNAME (Q7_1),LASTNAME (Q8_1),DOB (Q12_1),Skipfield2 (Q117_1),WEBACCESSCODE (Q98_1),Doctor's name and phone number (Q106_1),Doctor's name and phone number (Q106_2),2 Plans for surgery in next 12 months (Q0),What surgery is planned (Q1_1),3 surgery in the last 12 mo (Q4),What surgery did you have (Q5_1),5 Rate health (Q9),6 Meds taken regularly (Q10),7 Rxs (Q11_1),8 Lost 10 lbs (Q15),9 Fallen in past 12 months (Q16),11 Inpatient (Q17),12 Emergency room (Q18),13 Doc Visits (Q19),Help with activities (Q3_A_1),Help with activities (Q3_A_2),Help with activities (Q3_A_3),Help with activities (Q3_A_4),Help with activities (Q3_A_5),Help with activities (Q3_A_6),Help with activities (Q3_A_7),Help with activities (Q3_A_8),Help with activities (Q3_A_9),Help with activities (Q3_A_10),Help with activities (Q3_A_11),Help with activities (Q3_A_12),Help with activities (Q3_A_13),27 Who is your helper (Q25_1),27 Who is your helper (Q25_2),27 Who is your helper (Q25_3),Special treatments (Q26_A_1),Special treatments (Q26_A_2),Special treatments (Q26_A_3),Special treatments (Q26_A_4),Special treatments (Q26_A_5),Special treatments (Q26_A_6),Special treatments (Q26_A_7),Special treatments (Q26_A_8),Special equipment (Q28_A_1),Special equipment (Q28_A_2),Special equipment (Q28_A_3),Special equipment (Q28_A_4),Special equipment (Q28_A_5),Special equipment (Q28_A_6),Special equipment (Q28_A_7),Special equipment (Q28_A_8),Special equipment (Q28_A_9),48 Diabetes (Q30),Have you ever had - heart conditions (Q32_A_1),Have you ever had - heart conditions (Q32_A_2),Have you ever had - heart conditions (Q32_A_3),Have you ever had - heart conditions (Q32_A_4),53 Currently being treated for heart problems (Q35),54 medication for heart problems (Q36),55 eyesight (Q38),Currently being treated for (Q39_A_1),Currently being treated for (Q39_A_2),Currently being treated for (Q39_A_3),Currently being treated for (Q39_A_4),Currently being treated for (Q39_A_5),Currently being treated for (Q39_A_6),Currently being treated for (Q39_A_7),Currently being treated for (Q39_A_8),Currently being treated for (Q39_A_9),Currently being treated for (Q39_A_10),Currently being treated for (Q39_A_11),Currently being treated for (Q39_A_12),Currently being treated for (Q39_A_13),Currently being treated for (Q39_A_14),Currently being treated for (Q39_A_15),Currently being treated for (Q39_A_16),Currently being treated for (Q39_A_17),73 Other health conditions (Q87),Describe other health conditions (Q41),74 Statement of health that fits best (Q42),75 Where do you currently live (Q24),75 Where do you currently live (Q24SPECIFIED_4),75 Where do you currently live (Q44),Describer your living arrangement (Q45_1),76 Apply to nursing home (Q46),77 Nursing home/convalescent hospital (Q48),78 5 or more weeks in nursing home (Q49),79 Recent loss of a loved one (Q50),80 Feeling worthless (Q52),81 Get bored (Q53),82 Feel helpless (Q54),83 Satisfied with your life (Q55),84 Prefer to stay at home (Q56),Receiving the following services (Q57_A_1),Receiving the following services (Q57_A_2),Receiving the following services (Q57_A_3),Receiving the following services (Q57_A_4),Receiving the following services (Q57_A_5),Receiving the following services (Q57_A_6),Receiving the following services (Q57_A_7),Receiving the following services (Q57_A_8),93 Current living arrangements (Q58_1),93 Current living arrangements (Q58_2),93 Current living arrangements (Q58_3),93 Current living arrangements (Q58_4),93 Current living arrangements (Q58_5),93 Current living arrangements (Q58_6),94 Are you a caregiver (Q59),95 Friend relative neighbor (Q6),96 Health conditions interfere with daily activities (Q61),97 Need help and unable to get help (Q62),98 Advance directives (Q63_1),98 Advance directives (Q63_2),98 Advance directives (Q63_3),99 Information on file with doctor (Q64),100 Receiving medical assistance (Q65),102 Anything else for us to know about you (Q66),103 Help with form (Q67),104 Information on the person who helped fill out the form (Q68_1),104 Information on the person who helped fill out the form (Q68_2),104 Information on the person who helped fill out the form (Q68_3),105 contact helper (Q69),Record ID,E-mail,Started,Completed,Last Modified,Invitation Status,Campaign Status,Culture,Key 1,Key 2,Key 3,Referring URL,Web Browser's User Agent,Respondent's IP Address,Respondent's Hostname,Initial Invitation Sent Date,Initial Invitation Status,First Reminder Sent Date,First Reminder Status,Second Reminder Sent Date,Second Reminder Status,Third Reminder Sent Date,Third Reminder Status,Fourth Reminder Sent Date,Fourth Reminder Status,Thank You Sent Date,Thank You Status,Last Access Date,Last Page")
        sb.AppendLine("Wellpoint converted format is:")
        sb.AppendLine("Email Address,Unique ID,Date Submitted,IP Address,Language,Submission Key,Skipfield,BATCHID,Skipfield1,FAQSS_TEMPLATE_ID,TEMPLATEDID,RespondentID,Skipfield2,WAC,What is the name and phone number of the physician you have gone to for most of your health care IN THE LAST 12 MONTHS? : Name,What is the name and phone number of the physician you have gone to for most of your health care IN THE LAST 12 MONTHS? : Phone number,484,What MAJOR surgery is planned?,485,What surgery did you have?,'In general, would you say your health is: (CHECK ONE ANSWER)',How many medicines (prescription and nonprescription) do you take regularly?&nbsp; (Regularly means most every day.),How many different prescription medicines do you take? (Put &quot;0&quot; if you do not take prescription medications.),'In the past SIX MONTHS, have you lost more than 10 pounds without trying?','During the past 12 MONTHS, have you fallen all the way to the ground or fallen and hit something like a chair or stair?','In the previous 12 months, have you stayed overnight as a patient in a hospital?','During the past 6 MONTHS, how many separate times did you use an emergency room at&nbsp;a hospital?','In the previous 12 months, how many times did you visit a physician or clinic?','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Using the toilet','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Bathing','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Dressing','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Eating','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Getting in/out of bed or chairs','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Walking','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Transportation','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Managing money','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Taking medications','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Preparing Meals','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Shopping and errands','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Housekeeping chores','For each of the activities below, indicate whether you are able to do this without help, need some help, or cannot do this at all without help. : Using the telephone','If you receive help with any of the activities in the previous two questions, who is your helper? (Give the name, relationship and phone number if we may contact your helper.) : Name','If you receive help with any of the activities in the previous two questions, who is your helper? (Give the name, relationship and phone number if we may contact your helper.) : Relationship','If you receive help with any of the activities in the previous two questions, who is your helper? (Give the name, relationship and phone number if we may contact your helper.) : Phone number',Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Tube in nose or abdomen for feeding,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Tracheostomy,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Colostomy or other ostomy,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Injections,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Oxygen,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Changing of bandages,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Catheter care,Do you have or regularly receive any of the following special treatments? (Mark yes or no for each.) : Chemotherapy for cancer,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Hoyer lift,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Bedside commode,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Wheelchair,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Walker,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Cane,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Grab bars,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Bath bench,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Hospital bed,Do you use any of the following special equipment because of a disability or health problem? (Mark yes or no for each.) : Ramps,'In the previous 12 months, did you have diabetes?',Have you ever had: : Coronary heart disease?,Have you ever had: : Angina pectoris?,Have you ever had: : A myocardial infarction?,Have you ever had: : Any other heart attack?,Are you currently being treated for heart problems?,'Do you take medication for your heart problems, or are you on a special diet?','How is your eyesight? (This means eyesight while wearing glasses or contacts, if you use them.)',Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : SERIOUS memory loss,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Arthritis,'Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : If you have arthritis, do you take medication for it?',Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Urinary problems,'Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Chronic bronchitis, emphysema, or smokers lung (also know as Chronic Obstructive Lung Disease or COPD)',Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Stroke,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : High Blood Pressure,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Cancer,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Circulation Problems,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Stomach/bowel problems,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Recent hip fracture (within 12 months),Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Parkinson's Disease,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Mental Problems,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Ankle/leg swelling,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : UNCORRECTED hearing loss/impairment,Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : Congestive heart failure,'Are you currently being treated for any of the following health conditions? (Mark yes or no for each.) : If you have congestive heart failure, have you been hospitalized for it in the past 12 months?',Are you being treated for any other health condition not listed in the previous question?,Please describe other health conditions.,Which of the following statements fits you best in terms of health? (MARK ONLY ONE of the following statements.),Where do you currently live?,Please describe your living arrangement.,Have you applied or are you currently considering applying for admission to a&nbsp;nursing home?,'During the PAST 12 MONTHS, were you in a nursing home or convalescent hospital?',Was your stay 5 OR MORE WEEKS?,The next few questions are about how you feel most of the time.Have you suffered a recent loss of a loved one?,Do you feel pretty worthless the way you are now?,Do you often get bored?,Do you often feel helpless?,Are you basically satisfied with your life?,'Do you prefer to stay at home, rather than going out and doing new things?',Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Visiting Nurse,'Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Therapist (Physical, Occupational, Speech)',Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Homemaker/Home Health Aide,Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Social Worker,Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Adult Day Care Center,Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Assistance with Transportation,Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Home Delivered Meals,Are you currently receiving any of the following services from an agency? (Mark yes or no for each.) : Money Management,What is your current living arrangement? (MARK EACH THAT APPLIES.) : 1,What is your current living arrangement? (MARK EACH THAT APPLIES.) : 2,What is your current living arrangement? (MARK EACH THAT APPLIES.) : 3,What is your current living arrangement? (MARK EACH THAT APPLIES.) : 4,What is your current living arrangement? (MARK EACH THAT APPLIES.) : 5,What is your current living arrangement? (MARK EACH THAT APPLIES.) : 6,Are YOU a care giver? (for a spouse or someone else),'Is there a friend, relative or neighbor who would take care of you for a few days, if necessary?',Do any of your health conditions interfere with your daily activities?,Do you need help at home because of health problems and are UNABLE to get help?,Have you completed any of the following? (Mark all that apply.) : 1,Have you completed any of the following? (Mark all that apply.) : 2,Have you completed any of the following? (Mark all that apply.) : 3,Is this information on file with your physician?,Are you currently receiving Medicaid (MediCal in California) or other government sponsored Medical Assistance other than Medicare?,Is there anything else you would like us to know about you?,Did you receive help filling out this form?,'What is the name, relationship and daytime phone of the person who helped you fill out this form? : Name','What is the name, relationship and daytime phone of the person who helped you fill out this form? : Relationship','What is the name, relationship and daytime phone of the person who helped you fill out this form? : Day Time Phone Number',May we call this person if we have questions?'")

        txtResults.Text = sb.ToString
    End Sub

#End Region
#Region " Private Methods "

    Private Function GUIValidateImport() As Boolean
        Dim retVal As Boolean = False
        Try
            If cboFileType.SelectedItem IsNot Nothing AndAlso CStr(cboFileType.SelectedItem).Length <> 0 Then
                If System.IO.File.Exists(Me.txtOriginalFile.Text) Then
                    Dim FolderPath = Me.txtConvertFile.Text.Substring(0, Me.txtConvertFile.Text.LastIndexOf("\"c))
                    If System.IO.Directory.Exists(FolderPath) Then
                        retVal = True
                        Me.txtResults.Text = ""
                    End If
                End If
            End If
        Catch ex As System.Exception
            'do nothing
        End Try
        Return retVal
    End Function

    Public Sub ImportFile()
        If CStr(cboFileType.SelectedItem).ToUpper() = "SECBLUE" Then
            'ConvertSecBlue()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "SECBLUE UPDATE 2013" Then
            ConvertSecBlueUpdate2013()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "HIGHMARK" Then
            'ConvertHiMark()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "HIGHMARK UPDATE 2013" Then
            ConvertHiMarkUpdate2013()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "WELLPOINT" Then
            ConvertWellpoint()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "5 STAR" Then
            Convert5Star()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "WELLPOINT 2011" Then
            ConvertWellPoint2011()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "WELLPOINT 2013" Then
            ConvertWellPoint2013()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "EXCELLUS" Then
            ConvertExcellus()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "COVENTRY 5-STAR 2012" Then
            ConvertCoventry2012()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "ADULT" Then
            ConvertAdult()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "CHILD" Then
            ConvertChild()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "MATERNITY" Then
            ConvertMaternity()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "COVENTRY ADULT UPDATE 2012" Then
            ConvertCoventryAdultUpdate2012()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "COVENTRY CHILD UPDATE 2012" Then
            ConvertCoventryChildUpdate2012()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "LOVELACE ADULT" Then
            '   ConvertLovelaceAdult()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "LOVELACE CHILD" Then
            '  ConvertLovelaceChild()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "LOVELACE ADULT UPDATE 2013" Then
            ConvertLovelaceAdultUpdate2013()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "LOVELACE CHILD UPDATE 2013" Then
            ConvertLovelaceChildUpdate2013()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "EXCELLUS UPDATE 2012" Then
            ConvertExcellusUpdate()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "FLORIDA BLUE" Then
            ConvertFloridaBlue()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "PHN 2013" Then
            ConvertPHN2013()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "PRIORITY HEALTH" Then
            ConvertPriorityHealth()
        ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "MED MUTUAL" Then
            ConvertMedMutual()
        End If
    End Sub

    Protected Friend Sub ConvertPHN2013()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(112).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified

                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(120), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(119), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))   'Blank(3)

                newLine.Append(PadString(row(2), 30, Direction.Left, " "))       ' Q40_1 Name of Physician
                newLine.Append(PadString(row(3), 10, Direction.Left, " ")) ' Q40_2 Phone number
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' Q1 2.2 Are you currently receiving medicaid
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' Q2 3.3 Do you have trouble getting your healthcare met

                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' (Q3) 4.4 Do you have enough money
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' (Q4) 5.5 Which of the following categories
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' (Q5) 6.6
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' (Q6) 7.7
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' (Q7) 8.8
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' (Q8) 9.9
                If (row(12) IsNot DBNull.Value) Then
                    If row(12) = "1" Then
                        tempVar = "1"
                    End If
                End If
                If (row(13) IsNot DBNull.Value) Then
                    If row(13) = "1" Then
                        tempVar = "2"
                    End If
                End If
                If (row(14) IsNot DBNull.Value) Then
                    If row(14) = "1" Then
                        tempVar = "3"
                    End If
                End If
                newLine.Append(PadString(tempVar, 1, Direction.Left, " ")) ' (Q9_1) 10. On average what is your daily use of tobacco

                ' newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' (Q9_2) Smoke less than one pack
                ' newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' (Q9_3)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' (Q9_4)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' (Q9_5)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' (Q10)
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' (Q11)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' (Q12)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' (Q13_A_1)

                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' (Q13_A_2)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' (Q14_1)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' (Q14_2)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' (Q14_3)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' (Q15)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' (Q16)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' (Q17)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' (Q18)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' (Q19_A_1)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' (Q19_A_2)

                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' (Q19_A_3)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' (Q19_A_4)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' (Q19_A_5)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' (Q19_A_6)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' (Q19_A_7)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' (Q19_A_8)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' (Q19_A_9)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' (Q19_A_10)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' (Q19_A_11)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' (Q19_A_12)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' (Q19_A_13)

                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' (Q20_A_1)
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' (Q20_A_2)
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' (Q20_A_3)
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' (Q20_A_4)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' (Q20_A_5)
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' (Q20_A_6)
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' (Q20_A_7)
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' (Q20_A_8)
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' (Q21)
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' (Q22)

                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' (Q23_A_1)
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' (Q23_A_2)
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' (Q23_A_3)
                newLine.Append(PadString(row(55), 1, Direction.Left, " ")) ' (Q23_A_4)
                newLine.Append(PadString(row(56), 1, Direction.Left, " ")) ' (Q23_A_5)
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) ' (Q23_A_6)
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' (Q23_A_7)
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' (Q23_A_8)
                newLine.Append(PadString(row(60), 1, Direction.Left, " ")) ' (Q23_A_9)
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' (Q24)

                newLine.Append(PadString(row(62), 1, Direction.Left, " ")) ' (Q25_A_1)
                newLine.Append(PadString(row(63), 1, Direction.Left, " ")) ' (Q25_A_2)
                newLine.Append(PadString(row(64), 1, Direction.Left, " ")) ' (Q25_A_3)
                newLine.Append(PadString(row(65), 1, Direction.Left, " ")) ' (Q25_A_4)
                newLine.Append(PadString(row(66), 1, Direction.Left, " ")) ' (Q38)
                newLine.Append(PadString(row(67), 1, Direction.Left, " ")) ' (Q41)
                newLine.Append(PadString(row(70), 1, Direction.Left, " ")) ' (Q26_A_1)
                newLine.Append(PadString(row(71), 1, Direction.Left, " ")) ' (Q26_A_2)

                newLine.Append(PadString(row(68), 1, Direction.Left, " ")) ' (Q42)
                newLine.Append(PadString(row(69), 1, Direction.Left, " ")) ' (Q43)

                newLine.Append(PadString(row(72), 1, Direction.Left, " ")) ' (Q26_A_3)
                newLine.Append(PadString(row(73), 1, Direction.Left, " ")) ' (Q26_A_4)
                newLine.Append(PadString(row(74), 1, Direction.Left, " ")) ' (Q26_A_5)
                newLine.Append(PadString(row(75), 1, Direction.Left, " ")) ' (Q26_A_6)
                newLine.Append(PadString(row(76), 1, Direction.Left, " ")) ' (Q26_A_7)
                newLine.Append(PadString(row(77), 1, Direction.Left, " ")) ' ((Q26_A_8)
                newLine.Append(PadString(row(78), 1, Direction.Left, " ")) ' (Q26_A_9)
                newLine.Append(PadString(row(79), 1, Direction.Left, " ")) ' (Q26_A_10)
                newLine.Append(PadString(row(80), 1, Direction.Left, " ")) ' (Q26_A_11)
                newLine.Append(PadString(row(81), 1, Direction.Left, " ")) ' (Q26_A_12)
                newLine.Append(PadString(row(82), 1, Direction.Left, " ")) ' (Q26_A_13)

                newLine.Append(PadString(row(83), 1, Direction.Left, " ")) ' (Q26_A_14)
                newLine.Append(PadString(row(84), 1, Direction.Left, " ")) ' (Q26_A_15)
                newLine.Append(PadString(row(85), 1, Direction.Left, " ")) ' (Q26_A_16)

                newLine.Append(PadString(row(86), 1, Direction.Left, " ")) ' (Q27)
                newLine.Append(PadString(row(87), 20, Direction.Left, " ")) ' (Q27SPECIFIED_1)
                newLine.Append(PadString(row(88), 1, Direction.Left, " ")) ' (Q28)
                newLine.Append(PadString(row(89), 1, Direction.Left, " ")) ' (Q29)
                newLine.Append(PadString(row(90), 1, Direction.Left, " ")) ' (Q30)
                newLine.Append(PadString(row(91), 1, Direction.Left, " ")) ' (Q32)
                newLine.Append(PadString(row(92), 1, Direction.Left, " ")) ' (Q33)
                newLine.Append(PadString(row(93), 1, Direction.Left, " ")) ' (Q31_A_1)
                newLine.Append(PadString(row(94), 1, Direction.Left, " ")) ' (Q31_A_2)
                newLine.Append(PadString(row(95), 1, Direction.Left, " ")) ' (Q31_A_3)
                newLine.Append(PadString(row(96), 1, Direction.Left, " ")) ' (Q31_A_4)

                newLine.Append(PadString(row(97), 1, Direction.Left, " ")) ' (Q31_A_5)
                newLine.Append(PadString(row(98), 1, Direction.Left, " ")) ' (Q31_A_6)
                newLine.Append(PadString(row(99), 1, Direction.Left, " ")) ' (Q31_A_7)
                newLine.Append(PadString(row(100), 1, Direction.Left, " ")) ' (Q31_A_8)
                newLine.Append(PadString(row(101), 1000, Direction.Left, " ")) ' (Q34)
                newLine.Append(PadString(row(102), 1, Direction.Left, " ")) ' (Q35)
                newLine.Append(PadString(row(103), 30, Direction.Left, " ")) ' (Q36_1)
                newLine.Append(PadString(row(104), 15, Direction.Left, " ")) ' (Q36_2)
                newLine.Append(PadString(row(105), 10, Direction.Left, " ")) ' (Q36_3)
                newLine.Append(PadString(row(106), 1, Direction.Left, " ")) ' (Q37)
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertFloridaBlue()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(22).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(row(30), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(29), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' (Q1) In General you would say
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' (Q18) Do any of your health condition
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' (Q42) 3.3 In the prev 12 months
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' (Q25) 
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' (Q66)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' (Q49)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' (Q30_A_1)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' (Q30_A_2) 
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' (Q30_A_3)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' (Q30_A_4)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' (Q10)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' (Q3) 
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' (Q4) 
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' (Q60_A_1) 
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' (Q60_A_2)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Protected Friend Sub ConvertCoventryAdultUpdate2012()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""
                'TODO: Check if I need to add these 6 lines...
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(49).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(57), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(56), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 2 (Q2)
                ' newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 3 (Q13)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 4 (Q14)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 4a (Q12)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 4b (Q3)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 4c (Q9)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 5 (Q16_A_1)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 5 (Q16_A_2)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 5 (Q16_A_3)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 5 (Q16_A_4)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 6 (Q6)
                'newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 7 (Q4) 'it does not need to be populated
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 8 (Q10_A_1)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 8 (Q10_A_2)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 8 (Q10_A_3)
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 8 (Q10_A_4)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 8 (Q10_A_5)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 8 (Q10_A_6)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 8 (Q10_A_7)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 8 (Q10_A_8)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 8 (Q10_A_9)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 8 (Q10_A_10)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 8 (Q10_A_11)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 8 (Q10_A_12)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 8 (Q10_A_13)

                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 8 (Q10_A_15)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 8 (Q10_A_16)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 8 (Q10_A_17)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 8 (Q10_A_18)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 8 (Q35_A_19)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 8 (Q10_A_20)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 8 (Q10_A_21)

                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 8 (Q10_A_22)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 8 (Q10_A_23)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 8 (Q10_A_24)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 8 (Q10_A_14) 'The file shows this column in this position

                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 9  (Q8)  ??
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 10 (Q5)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 11 (Q15_1)
                newLine.Append(PadString(row(42), 2, Direction.Left, " ")) ' 11 (Q15_2)
                newLine.Append(PadString(row(43), 3, Direction.Left, " ")) ' 12 (Q7_1)

                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertCoventryChildUpdate2012()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(34).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(42), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(41), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 2 (Q21)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 2a (Q2)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 2b (Q3)
                newLine.Append(PadString(row(6), 100, Direction.Left, " ")) ' 2c (Q9)

                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 3 (Q5)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 3a (Q6)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 3b (Q7)
                newLine.Append(PadString(row(10), 100, Direction.Left, " ")) ' 3c (Q4)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 4 (Q8)


                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 4a (Q10)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 4b (Q11)
                newLine.Append(PadString(row(14), 100, Direction.Left, " ")) ' 4c (Q12) 

                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 5 (Q13)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 5a (Q14)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 5b (Q15)
                newLine.Append(PadString(row(18), 100, Direction.Left, " ")) ' 5c (Q16)

                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 6 (Q17)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 6a (Q22)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 6b (Q18)
                newLine.Append(PadString(row(22), 100, Direction.Left, " ")) ' 6c (Q19)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 7 (Q23)


                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 8 (Q24_1)
                newLine.Append(PadString(row(25), 2, Direction.Left, " ")) ' 8 (Q24_2)
                newLine.Append(PadString(row(26), 3, Direction.Left, " ")) ' 9 (Q25_1)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 10 (Q26)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 11 (Q27)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertLovelaceAdultUpdate2013()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(51).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(59), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(58), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 2 (Q2)
                ' newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 3 (Q13)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 4 (Q14)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 4a (Q12)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 4b (Q3)

                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 4c (Q9)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 5 (Q16_A_1)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 5 (Q16_A_2)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 5 (Q16_A_3)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 5 (Q16_A_4)
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 6 (Q6)
                'newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 7 (Q4) 

                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 8 (Q10_A_1) artery
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 8 (Q10_A_2) asthma
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 8 (Q10_A_3) back
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 8 (Q10_A_4) bowel

                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 8 (Q10_A_5) congestive
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 8 (Q10_A_6) depression
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 8 (Q10_A_7) emphysema
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 8 (Q10_A_8) epilepsy
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 8 (Q10_A_9) heart attack


                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 8 (Q10_A_10) hemophilia
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 8 (Q10_A_11) high blood

                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 8 (Q10_A_13) kidney
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 8 (Q10_A_14) liver
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 8 (Q10_A_15) multiple sclerosis
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 8 (Q10_A_16) park
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 8 (Q10_A_17) rheum
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 8 (Q10_A_18) sickle
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 8 (Q10_A_19) skin can
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 8 (Q10_A_20) substance
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 8 (Q10_A_21) weight

                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 8 (Q10_A_12) hiv

                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 9 (Q8) Do you smoke
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 10 (Q5) Please mark which best fits your
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 11 (Q7) In the past 12 months
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 12 (Q15) In the last 6 months
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 13 (Q18) what is your primary language written
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 14 (Q17) spoken

                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' 15 (Q20) transportation
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' 16 (Q21) financial help
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' 17 (Q22) homeless

                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try

    End Sub

    Private Sub ConvertLovelaceAdult()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(48).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(56), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(55), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 2 (Q2)
                ' newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 3 (Q13)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 4 (Q14)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 4a (Q12)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 4b (Q3)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 4c (Q9)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 5 (Q16_A_1)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 5 (Q16_A_2)

                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 5 (Q16_A_3)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 5 (Q16_A_4)
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 6 (Q6)
                'newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 7 (Q4) 

                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 8 (Q10_A_1) artery
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 8 (Q10_A_2) asthma
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 8 (Q10_A_3) back
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 8 (Q10_A_4) bowel

                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 8 (Q10_A_5) congest
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 8 (Q10_A_6) depression
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 8 (Q10_A_7) emphysema
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 8 (Q10_A_8) epilepsy
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 8 (Q10_A_9) heart attack


                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 8 (Q10_A_10) hemophilia
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 8 (Q10_A_11) high blood

                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 8 (Q10_A_13) kidney
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 8 (Q10_A_14) liver
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 8 (Q10_A_15) ms
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 8 (Q10_A_16) park
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 8 (Q10_A_17) rheum
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 8 (Q10_A_18) sickle
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 8 (Q10_A_19) skin can
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 8 (Q10_A_20) substance
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 8 (Q10_A_21) weight

                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 8 (Q10_A_12) hiv

                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 9 (Q8) 
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 10 (Q5)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 11 (Q7)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 12 (Q15)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 13 (Q18)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 14 (Q17)

                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try

    End Sub

    Private Sub ConvertLovelaceChildUpdate2013()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(31).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(39), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(38), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 2 (Q21)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 2a (Q2)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 2b (Q3)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 3 (Q5)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 3a (Q6)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 3b (Q7)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 4 (Q8)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 4a (Q10)

                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 4b (Q11)


                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 5 (Q13)
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 5a (Q14)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 5b (Q15) 
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 6 (Q17) 
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 6a (Q22) 
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 6b (Q18) 
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 7 (Q23) 

                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 8 (Q24) 
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 9 (Q9) 
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 10 (Q4) 

                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 11 (Q16) 
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 12 (Q19) 
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 13 (Q25) 


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertLovelaceChild()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(28).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(36), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(35), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 2 (Q21)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 2a (Q2)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 2b (Q3)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 3 (Q5)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 3a (Q6)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 3b (Q7)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 4 (Q8)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 4a (Q10)

                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 4b (Q11)


                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 5 (Q13)
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 5a (Q14)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 5b (Q15) 
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 6 (Q17) 
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 6a (Q22) 
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 6b (Q18) 
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 7 (Q23) 

                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 8 (Q24) 
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 9 (Q9) 
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 10 (Q4) 



                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertWellpoint()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""
                newLine.Append(" ")
                Dim tempDate As Date = Now
                newLine.Append(tempDate.ToString("yyyyMMdd"))
                newLine.Append(" ")
                newLine.Append(PadString(row(11), 8, Direction.Left, " "))    'Property_FAQSS_TEMPLATE_ID
                newLine.Append(PadString(row(12), 5, Direction.Right, "0"))    'TemplateID
                newLine.Append(PadString(row(13), 8, Direction.Right, "0"))    'RESPONDENTID
                newLine.Append(PadString("", 3, Direction.Left, " "))
                newLine.Append(PadString(row(19), 40, Direction.Left, " "))
                If IsDBNull(row(20)) Then
                    tempVar = String.Empty
                Else
                    tempVar = CStr(row(20))
                    tempVar = Replace(tempVar, " ", "")
                    tempVar = Replace(tempVar, "(", "")
                    tempVar = Replace(tempVar, ")", "")
                    tempVar = Replace(tempVar, "-", "")
                    tempVar = Replace(tempVar, ".", "")
                    If tempVar.Length = 11 Then
                        tempVar = Mid(tempVar, 1, tempVar.Length - 1)
                    End If
                    If Not IsNumeric(tempVar) Then
                        Globals.ReportException(New System.Exception("An invalid phone number was given."))
                    End If
                End If
                newLine.Append(PadString(tempVar, 10, Direction.Left, " "))
                newLine.Append(PadString(row(21), 1, Direction.Left, " "))
                newLine.Append(PadString(row(22), 50, Direction.Left, " "))
                newLine.Append(PadString(row(23), 1, Direction.Left, " "))
                newLine.Append(PadString(row(24), 50, Direction.Left, " "))
                newLine.Append(PadString(row(25), 1, Direction.Left, " "))
                newLine.Append(PadString(row(26), 1, Direction.Left, " "))
                newLine.Append(PadString(row(27), 2, Direction.Left, " "))
                For i As Integer = 28 To 45
                    newLine.Append(PadString(row(i), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(46), 30, Direction.Left, " "))
                newLine.Append(PadString(row(47), 30, Direction.Left, " "))
                newLine.Append(PadString(row(48), 10, Direction.Left, " "))
                For j As Integer = 49 To 91
                    tempVar = PadString(row(j), 1, Direction.Left, " ")
                    If j >= 74 Then
                        If tempVar = "0" Then
                            tempVar = "2"
                        End If
                    End If
                    newLine.Append(tempVar)
                Next
                newLine.Append(PadString(row(92), 30, Direction.Left, " "))
                newLine.Append(PadString(row(93), 1, Direction.Left, " "))
                newLine.Append(PadString(row(94), 1, Direction.Left, " "))
                newLine.Append(PadString(row(95), 30, Direction.Left, " "))
                For j As Integer = 98 To 129
                    tempVar = PadString(row(j), 1, Direction.Left, " ")
                    If j >= 115 AndAlso j <= 120 Then
                        If tempVar = "0" Then
                            tempVar = " "
                        End If
                    ElseIf j >= 125 AndAlso j <= 127 Then
                        If tempVar = "0" Then
                            tempVar = "2"
                        End If
                    End If
                    newLine.Append(tempVar)
                Next
                newLine.Append(PadString(row(130), 1000, Direction.Left, " "))
                newLine.Append(PadString(row(131), 1, Direction.Left, " "))
                newLine.Append(PadString(row(132), 30, Direction.Left, " "))
                newLine.Append(PadString(row(133), 30, Direction.Left, " "))
                newLine.Append(PadString(row(134), 10, Direction.Left, " "))
                newLine.Append(PadString(row(135), 1, Direction.Left, " "))
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertSecBlue()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                newLine.Append(" ")
                Dim tempDate As Date = Now
                newLine.Append(tempDate.ToString("yyyyMMdd"))
                newLine.Append(" ")
                newLine.Append(PadString(row(15), 8, Direction.Left, " "))    'Property_FAQSS_TEMPLATE_ID
                newLine.Append(PadString(row(13), 5, Direction.Right, "0"))    'TemplateID
                newLine.Append(PadString(row(12), 8, Direction.Right, "0"))    'RESPONDENTID
                newLine.Append(PadString("", 3, Direction.Left, " "))
                newLine.Append(PadString(row(19), 1, Direction.Left, " "))
                newLine.Append(PadString(row(20), 1, Direction.Left, " "))
                newLine.Append(PadString(row(21), 2, Direction.Left, " "))
                newLine.Append(PadString(row(22), 2, Direction.Left, " "))
                For i As Integer = 23 To 92
                    Dim tempVar As String = PadString(row(i), 1, Direction.Left, " ")
                    If i >= 52 AndAlso i <= 69 Then
                        If tempVar = "0" Then
                            tempVar = "2"
                        End If
                    End If
                    newLine.Append(tempVar)
                Next
                newLine.Append(PadString(row(93), 2, Direction.Left, " "))
                newLine.Append(PadString(row(94), 3, Direction.Left, " "))
                For j As Integer = 95 To 99
                    newLine.Append(PadString(row(j), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(100), 32, Direction.Left, " "))
                For j As Integer = 101 To 104
                    Dim tempVar As String = PadString(row(j), 1, Direction.Left, " ")
                    If tempVar = "0" Then
                        tempVar = " "
                    End If
                    newLine.Append(tempVar)
                Next
                newLine.Append(PadString(row(106), 32, Direction.Left, " "))
                If PadString(row(105), 1, Direction.Left, " ") = "0" Then
                    newLine.Append(" ")
                Else
                    newLine.Append(PadString(row(105), 1, Direction.Left, " "))
                End If
                newLine.Append(PadString(row(107), 32, Direction.Left, " "))
                For j As Integer = 108 To 112
                    newLine.Append(PadString(row(j), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(113), 30, Direction.Left, " "))
                newLine.Append(PadString(row(114), 30, Direction.Left, " "))
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertSecBlueUpdate2013()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                'newLine.Append(" ")
                'Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(123).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified

                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(row(13), 5, Direction.Right, "0")) ' TemplateID
                newLine.Append(PadString(row(12), 8, Direction.Right, "0")) ' RespondentID

                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)

                newLine.Append(PadString(row(19), 1, Direction.Left, " "))
                newLine.Append(PadString(row(20), 1, Direction.Left, " "))
                newLine.Append(PadString(row(21), 2, Direction.Left, " "))
                newLine.Append(PadString(row(22), 2, Direction.Left, " "))
                newLine.Append(PadString(row(23), 1, Direction.Left, " "))
                newLine.Append(PadString(row(24), 1, Direction.Left, " "))
                newLine.Append(PadString(row(25), 1, Direction.Left, " "))
                newLine.Append(PadString(row(26), 1, Direction.Left, " "))
                newLine.Append(PadString(row(27), 1, Direction.Left, " "))

                newLine.Append(PadString(row(28), 1, Direction.Left, " "))
                newLine.Append(PadString(row(29), 1, Direction.Left, " "))
                newLine.Append(PadString(row(30), 1, Direction.Left, " "))
                newLine.Append(PadString(row(31), 1, Direction.Left, " "))
                newLine.Append(PadString(row(32), 1, Direction.Left, " "))
                newLine.Append(PadString(row(33), 1, Direction.Left, " "))
                newLine.Append(PadString(row(34), 1, Direction.Left, " "))
                newLine.Append(PadString(row(35), 1, Direction.Left, " "))
                newLine.Append(PadString(row(36), 1, Direction.Left, " "))
                newLine.Append(PadString(row(37), 1, Direction.Left, " "))
                newLine.Append(PadString(row(38), 1, Direction.Left, " "))
                newLine.Append(PadString(row(39), 1, Direction.Left, " "))
                newLine.Append(PadString(row(40), 1, Direction.Left, " "))
                newLine.Append(PadString(row(41), 1, Direction.Left, " "))
                newLine.Append(PadString(row(42), 1, Direction.Left, " "))
                newLine.Append(PadString(row(43), 1, Direction.Left, " "))
                newLine.Append(PadString(row(44), 1, Direction.Left, " "))
                newLine.Append(PadString(row(45), 1, Direction.Left, " "))
                newLine.Append(PadString(row(46), 1, Direction.Left, " "))
                newLine.Append(PadString(row(47), 1, Direction.Left, " "))
                newLine.Append(PadString(row(48), 1, Direction.Left, " "))
                newLine.Append(PadString(row(49), 1, Direction.Left, " "))
                newLine.Append(PadString(row(50), 1, Direction.Left, " "))

                newLine.Append(PadString(row(51), 1, Direction.Left, " "))
                newLine.Append(PadString(row(52), 1, Direction.Left, " "))
                newLine.Append(PadString(row(53), 1, Direction.Left, " "))
                newLine.Append(PadString(row(54), 1, Direction.Left, " "))
                newLine.Append(PadString(row(55), 1, Direction.Left, " "))
                newLine.Append(PadString(row(56), 1, Direction.Left, " "))
                newLine.Append(PadString(row(57), 1, Direction.Left, " "))
                newLine.Append(PadString(row(58), 1, Direction.Left, " "))
                newLine.Append(PadString(row(59), 1, Direction.Left, " "))
                newLine.Append(PadString(row(60), 1, Direction.Left, " "))


                newLine.Append(PadString(row(61), 1, Direction.Left, " "))
                newLine.Append(PadString(row(62), 1, Direction.Left, " "))
                newLine.Append(PadString(row(63), 1, Direction.Left, " "))
                newLine.Append(PadString(row(64), 1, Direction.Left, " "))
                newLine.Append(PadString(row(65), 1, Direction.Left, " "))
                newLine.Append(PadString(row(66), 1, Direction.Left, " "))
                newLine.Append(PadString(row(67), 1, Direction.Left, " "))
                newLine.Append(PadString(row(68), 1, Direction.Left, " "))
                newLine.Append(PadString(row(69), 1, Direction.Left, " "))
                newLine.Append(PadString(row(70), 1, Direction.Left, " "))

                newLine.Append(PadString(row(71), 1, Direction.Left, " "))
                newLine.Append(PadString(row(72), 1, Direction.Left, " "))
                newLine.Append(PadString(row(73), 1, Direction.Left, " "))
                newLine.Append(PadString(row(74), 1, Direction.Left, " "))
                newLine.Append(PadString(row(75), 1, Direction.Left, " "))
                newLine.Append(PadString(row(76), 1, Direction.Left, " "))
                newLine.Append(PadString(row(77), 1, Direction.Left, " "))
                newLine.Append(PadString(row(78), 1, Direction.Left, " "))
                newLine.Append(PadString(row(79), 1, Direction.Left, " "))
                newLine.Append(PadString(row(80), 1, Direction.Left, " "))

                newLine.Append(PadString(row(81), 1, Direction.Left, " "))
                newLine.Append(PadString(row(82), 1, Direction.Left, " "))
                newLine.Append(PadString(row(83), 1, Direction.Left, " "))
                newLine.Append(PadString(row(84), 1, Direction.Left, " "))
                newLine.Append(PadString(row(85), 1, Direction.Left, " "))
                newLine.Append(PadString(row(86), 1, Direction.Left, " "))
                newLine.Append(PadString(row(87), 1, Direction.Left, " "))
                newLine.Append(PadString(row(88), 1, Direction.Left, " "))
                newLine.Append(PadString(row(89), 1, Direction.Left, " "))
                newLine.Append(PadString(row(90), 1, Direction.Left, " "))

                newLine.Append(PadString(row(91), 1, Direction.Left, " "))
                newLine.Append(PadString(row(92), 1, Direction.Left, " "))
                newLine.Append(PadString(row(93), 2, Direction.Left, " "))
                newLine.Append(PadString(row(94), 3, Direction.Left, " "))
                newLine.Append(PadString(row(95), 1, Direction.Left, " "))
                newLine.Append(PadString(row(96), 1, Direction.Left, " "))
                newLine.Append(PadString(row(97), 1, Direction.Left, " "))
                newLine.Append(PadString(row(98), 1, Direction.Left, " "))
                newLine.Append(PadString(row(99), 1, Direction.Left, " "))
                newLine.Append(PadString(row(100), 32, Direction.Left, " "))

                newLine.Append(PadString(row(101), 1, Direction.Left, " "))
                newLine.Append(PadString(row(102), 1, Direction.Left, " "))
                newLine.Append(PadString(row(103), 1, Direction.Left, " "))
                newLine.Append(PadString(row(104), 1, Direction.Left, " "))
                newLine.Append(PadString(row(107), 32, Direction.Left, " "))

                newLine.Append(PadString(row(105), 1, Direction.Left, " "))
                newLine.Append(PadString(row(106), 32, Direction.Left, " "))

                newLine.Append(PadString(row(108), 1, Direction.Left, " "))
                newLine.Append(PadString(row(109), 1, Direction.Left, " "))
                newLine.Append(PadString(row(110), 1, Direction.Left, " "))

                newLine.Append(PadString(row(111), 1, Direction.Left, " "))
                newLine.Append(PadString(row(112), 1, Direction.Left, " "))
                newLine.Append(PadString(row(113), 30, Direction.Left, " "))
                newLine.Append(PadString(row(114), 30, Direction.Left, " "))

                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertHiMark()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                newLine.Append(" ")
                Dim tempDate As Date = Now
                newLine.Append(tempDate.ToString("yyyyMMdd"))
                newLine.Append(" ")
                newLine.Append(PadString(row(15), 8, Direction.Left, " "))    'Property_FAQSS_TEMPLATE_ID
                newLine.Append(PadString(row(13), 5, Direction.Right, "0"))    'TemplateID
                newLine.Append(PadString(row(12), 8, Direction.Right, "0"))    'RESPONDENTID
                newLine.Append(PadString("", 3, Direction.Left, " "))
                newLine.Append(PadString(row(20), 1, Direction.Left, " "))
                newLine.Append(PadString(row(21), 1, Direction.Left, " "))
                newLine.Append(PadString(row(22), 2, Direction.Left, " "))
                newLine.Append(PadString(row(23), 2, Direction.Left, " "))
                For i As Integer = 24 To 93
                    Dim tempVar As String = PadString(row(i), 1, Direction.Left, " ")
                    If i >= 53 AndAlso i <= 70 Then
                        If tempVar = "0" Then
                            tempVar = "2"
                        End If
                    End If
                    newLine.Append(tempVar)
                Next
                newLine.Append(PadString(row(94), 2, Direction.Left, " "))
                newLine.Append(PadString(row(95), 3, Direction.Left, " "))
                For j As Integer = 96 To 100
                    newLine.Append(PadString(row(j), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(101), 32, Direction.Left, " "))
                For j As Integer = 102 To 105
                    Dim tempVar As String = PadString(row(j), 1, Direction.Left, " ")
                    If tempVar = "0" Then
                        tempVar = " "
                    End If
                    newLine.Append(tempVar)
                Next
                newLine.Append(PadString(row(107), 32, Direction.Left, " "))
                If PadString(row(106), 1, Direction.Left, " ") = "0" Then
                    newLine.Append(" ")
                Else
                    newLine.Append(PadString(row(106), 1, Direction.Left, " "))
                End If
                newLine.Append(PadString(row(108), 32, Direction.Left, " "))
                For j As Integer = 109 To 113
                    newLine.Append(PadString(row(j), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(114), 30, Direction.Left, " "))
                newLine.Append(PadString(row(115), 30, Direction.Left, " "))
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertHiMarkUpdate2013()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                'newLine.Append(" ")
                'Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(124).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified

                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(row(13), 5, Direction.Right, "0")) ' TemplateID
                newLine.Append(PadString(row(12), 8, Direction.Right, "0")) ' RespondentID

                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)

                newLine.Append(PadString(row(20), 1, Direction.Left, " "))
                newLine.Append(PadString(row(21), 1, Direction.Left, " "))
                newLine.Append(PadString(row(22), 2, Direction.Left, " "))
                newLine.Append(PadString(row(23), 2, Direction.Left, " "))
                newLine.Append(PadString(row(24), 1, Direction.Left, " "))
                newLine.Append(PadString(row(25), 1, Direction.Left, " "))
                newLine.Append(PadString(row(26), 1, Direction.Left, " "))
                newLine.Append(PadString(row(27), 1, Direction.Left, " "))
                newLine.Append(PadString(row(28), 1, Direction.Left, " "))

                newLine.Append(PadString(row(29), 1, Direction.Left, " "))
                newLine.Append(PadString(row(30), 1, Direction.Left, " "))
                newLine.Append(PadString(row(31), 1, Direction.Left, " "))
                newLine.Append(PadString(row(32), 1, Direction.Left, " "))
                newLine.Append(PadString(row(33), 1, Direction.Left, " "))
                newLine.Append(PadString(row(34), 1, Direction.Left, " "))
                newLine.Append(PadString(row(35), 1, Direction.Left, " "))
                newLine.Append(PadString(row(36), 1, Direction.Left, " "))
                newLine.Append(PadString(row(37), 1, Direction.Left, " "))
                newLine.Append(PadString(row(38), 1, Direction.Left, " "))
                newLine.Append(PadString(row(39), 1, Direction.Left, " "))
                newLine.Append(PadString(row(40), 1, Direction.Left, " "))
                newLine.Append(PadString(row(41), 1, Direction.Left, " "))
                newLine.Append(PadString(row(42), 1, Direction.Left, " "))
                newLine.Append(PadString(row(43), 1, Direction.Left, " "))
                newLine.Append(PadString(row(44), 1, Direction.Left, " "))
                newLine.Append(PadString(row(45), 1, Direction.Left, " "))
                newLine.Append(PadString(row(46), 1, Direction.Left, " "))
                newLine.Append(PadString(row(47), 1, Direction.Left, " "))
                newLine.Append(PadString(row(48), 1, Direction.Left, " "))
                newLine.Append(PadString(row(49), 1, Direction.Left, " "))
                newLine.Append(PadString(row(50), 1, Direction.Left, " "))
                newLine.Append(PadString(row(51), 1, Direction.Left, " "))

                newLine.Append(PadString(row(52), 1, Direction.Left, " "))
                newLine.Append(PadString(row(53), 1, Direction.Left, " "))
                newLine.Append(PadString(row(54), 1, Direction.Left, " "))
                newLine.Append(PadString(row(55), 1, Direction.Left, " "))
                newLine.Append(PadString(row(56), 1, Direction.Left, " "))
                newLine.Append(PadString(row(57), 1, Direction.Left, " "))
                newLine.Append(PadString(row(58), 1, Direction.Left, " "))
                newLine.Append(PadString(row(59), 1, Direction.Left, " "))
                newLine.Append(PadString(row(60), 1, Direction.Left, " "))
                newLine.Append(PadString(row(61), 1, Direction.Left, " "))


                newLine.Append(PadString(row(62), 1, Direction.Left, " "))
                newLine.Append(PadString(row(63), 1, Direction.Left, " "))
                newLine.Append(PadString(row(64), 1, Direction.Left, " "))
                newLine.Append(PadString(row(65), 1, Direction.Left, " "))
                newLine.Append(PadString(row(66), 1, Direction.Left, " "))
                newLine.Append(PadString(row(67), 1, Direction.Left, " "))
                newLine.Append(PadString(row(68), 1, Direction.Left, " "))
                newLine.Append(PadString(row(69), 1, Direction.Left, " "))
                newLine.Append(PadString(row(70), 1, Direction.Left, " "))
                newLine.Append(PadString(row(71), 1, Direction.Left, " "))

                newLine.Append(PadString(row(72), 1, Direction.Left, " "))
                newLine.Append(PadString(row(73), 1, Direction.Left, " "))
                newLine.Append(PadString(row(74), 1, Direction.Left, " "))
                newLine.Append(PadString(row(75), 1, Direction.Left, " "))
                newLine.Append(PadString(row(76), 1, Direction.Left, " "))
                newLine.Append(PadString(row(77), 1, Direction.Left, " "))
                newLine.Append(PadString(row(78), 1, Direction.Left, " "))
                newLine.Append(PadString(row(79), 1, Direction.Left, " "))
                newLine.Append(PadString(row(80), 1, Direction.Left, " "))
                newLine.Append(PadString(row(81), 1, Direction.Left, " "))

                newLine.Append(PadString(row(82), 1, Direction.Left, " "))
                newLine.Append(PadString(row(83), 1, Direction.Left, " "))
                newLine.Append(PadString(row(84), 1, Direction.Left, " "))
                newLine.Append(PadString(row(85), 1, Direction.Left, " "))
                newLine.Append(PadString(row(86), 1, Direction.Left, " "))
                newLine.Append(PadString(row(87), 1, Direction.Left, " "))
                newLine.Append(PadString(row(88), 1, Direction.Left, " "))
                newLine.Append(PadString(row(89), 1, Direction.Left, " "))
                newLine.Append(PadString(row(90), 1, Direction.Left, " "))
                newLine.Append(PadString(row(91), 1, Direction.Left, " "))

                newLine.Append(PadString(row(92), 1, Direction.Left, " "))
                newLine.Append(PadString(row(93), 1, Direction.Left, " "))
                newLine.Append(PadString(row(94), 2, Direction.Left, " "))
                newLine.Append(PadString(row(95), 3, Direction.Left, " "))
                newLine.Append(PadString(row(96), 1, Direction.Left, " "))
                newLine.Append(PadString(row(97), 1, Direction.Left, " "))
                newLine.Append(PadString(row(98), 1, Direction.Left, " "))
                newLine.Append(PadString(row(99), 1, Direction.Left, " "))
                newLine.Append(PadString(row(100), 1, Direction.Left, " "))
                newLine.Append(PadString(row(101), 32, Direction.Left, " "))

                newLine.Append(PadString(row(102), 1, Direction.Left, " "))
                newLine.Append(PadString(row(103), 1, Direction.Left, " "))
                newLine.Append(PadString(row(104), 1, Direction.Left, " "))
                newLine.Append(PadString(row(105), 1, Direction.Left, " "))
                newLine.Append(PadString(row(108), 32, Direction.Left, " "))

                newLine.Append(PadString(row(106), 1, Direction.Left, " "))
                newLine.Append(PadString(row(107), 32, Direction.Left, " "))

                newLine.Append(PadString(row(109), 1, Direction.Left, " "))
                newLine.Append(PadString(row(110), 1, Direction.Left, " "))
                newLine.Append(PadString(row(111), 1, Direction.Left, " "))

                newLine.Append(PadString(row(112), 1, Direction.Left, " "))
                newLine.Append(PadString(row(113), 1, Direction.Left, " "))
                newLine.Append(PadString(row(114), 30, Direction.Left, " "))
                newLine.Append(PadString(row(115), 30, Direction.Left, " "))

                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub Convert5Star()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()
            'For Each col As DataColumn In readTable.Columns
            '    Debug.Print(col.ColumnName)
            'Next
            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""
                newLine.Append(" ")
                Dim tempDate As Date = Date.Parse(row(47))
                newLine.Append(tempDate.ToString("yyyyMMdd"))
                newLine.Append(" ")
                newLine.Append(PadString(row(5), 8, Direction.Left, " "))    'Property_FAQSS_TEMPLATE_ID
                newLine.Append(PadString(row(4), 5, Direction.Right, "0"))    'TemplateID
                newLine.Append(PadString(row(3), 8, Direction.Right, "0"))    'RESPONDENTID
                newLine.Append(PadString("", 3, Direction.Left, " "))
                For i As Integer = 7 To 18
                    newLine.Append(PadString(row(i), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(19) & "/" & row(20), 15, Direction.Left, " "))
                newLine.Append(PadString(row(21), 2, Direction.Left, " "))
                newLine.Append(PadString(row(22), 2, Direction.Left, " "))
                For i As Integer = 24 To 29
                    newLine.Append(PadString(row(i), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(23), 1, Direction.Left, " "))
                For i As Integer = 30 To 33
                    newLine.Append(PadString(row(i), 1, Direction.Left, " "))
                Next
                For i As Integer = 37 To 43
                    newLine.Append(PadString(row(i), 1, Direction.Left, " "))
                Next
                newLine.Append(PadString(row(35), 1, Direction.Left, " "))
                newLine.Append(PadString(row(34), 1, Direction.Left, " "))
                newLine.Append(PadString(row(36), 1, Direction.Left, " "))
                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertWellPoint2013()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(52).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(row(60), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(59), 8, Direction.Right, "0")) ' Key 2

                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)

                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1.1 When all is said and done, I am the person.... (Q1)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 2.2 Taking an active role in my own health care is the most...(Q3)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 3.3 I am confident that I can tell wheter I need to go...(Q4)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 4.4 I know what treatments are available for my health problems (Q5)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 5.5 I have been able to maintain (keep up with)...(Q6)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 6.6 I am confident that I can maintain, like eating...(Q7)


                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 7.7 How would you describe your overall health (Q8)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 8.8. Now thinking about your mental...(Q16)
                newLine.Append(PadString(row(10), 2, Direction.Left, " ")) ' 8 Number of days Specefiy..(Q16SPECIFIED_1)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 9.9 A personal doctor or nurse...(Q12)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 10.10 In thr last 6 months (Q19)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 11.11 Within the past 12 months how many times. (Q20)
                newLine.Append(PadString(row(14), 2, Direction.Left, " ")) ' 11. Number of days SPecify (Q20SPECIFIED_1)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 12.12 Are you currently being treated (Q13)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 13.13 How many prescription (Q21)
                newLine.Append(PadString(row(17), 2, Direction.Left, " ")) ' 13. Number of prescription medications. (Q21SPECIFIED_1)
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 14.14 Have you had your blood pressure checked (Q22)
                newLine.Append(PadString(row(19), 3, Direction.Left, " ")) ' 15a What was your Systolic pressure. (Q24_1)
                newLine.Append(PadString(row(20), 3, Direction.Left, " ")) ' 15b What was your Diastolic pressure (Q23_1)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 16 Have you had your cholesterol checked (Q25)
                newLine.Append(PadString(row(22), 3, Direction.Left, " ")) ' 17a What was your total cholesterol (Q26_1)
                newLine.Append(PadString(row(23), 3, Direction.Left, " ")) ' 17b What was your HDL (Q27_1)
                newLine.Append(PadString(row(24), 3, Direction.Left, " ")) ' 17c What was your LDL (Q28_1)

                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 18 Have you had your blood...(Q29)
                newLine.Append(PadString(row(26), 3, Direction.Left, " ")) ' 19 What was your blood sugar (Q30_1)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 20 Topic Diabetes or blood sugar
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 20 Topic b (Q33_A_2)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 20 Topic C Congestive Heart Failure (Q33_A_3)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 20 Topic D Coronary Artery Disease (Q33_A4_)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 20 Topic E Are you currently being treated.. (Q33_A_5)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 21 What is your current living arrangement (Q35)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) '22 Do you require assistance (Q36)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 23 A fall is when your body goes to the ground..(Q37)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 24 How many times within the previous (Q9)
                newLine.Append(PadString(row(36), 2, Direction.Left, " ")) ' 24 Number times Specify (Q9SPECIFIED_2) 
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 25 Has your doctor (Q40)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 26 Have you broken any bones (Q38)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 27 Topic a An eye exam including a screening (Q43_A_1)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 27 Topic b A colorectal cancer (Q43_A_27)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 28 Within the past 12 months (Q15)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 29 Many people experience problems... (Q10)
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' 30 a Was the urine leakage (Q11)
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' 31 b Have you received any (Q14)
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' 32 Topic a Do you use tobacco(Q44_A_1)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' 32 Topic b In the past 12 months did you talk


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertWellPoint2011()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(126).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(row(11), 8, Direction.Left, " "))  ' FAQs (Q45_1)
                newLine.Append(PadString(row(12), 5, Direction.Right, "0")) ' TEMPLATEDID (Q112_1)
                newLine.Append(PadString(row(13), 8, Direction.Right, "0")) ' RespondentID (Q113_1)
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' Rate health (Q1)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' Surgery in the last 12 mo (Q4)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' Lost 10 lbs (Q5)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' Diabetes (Q9)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' Protein test (Q15)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' Hemoglobin A1c (Q29)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' Cholesterol (Q55)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' Heart Health (Q30_A_1)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' Heart Health (Q30_A_2)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' Heart Health (Q30_A_3)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' Heart Health (Q30_A_4)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' Currently being treated for heart problems (Q10)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' Eyesight (Q31)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' Fallen in past 12 months (Q33)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' Broken Hip, wrist, spine or rib  (Q11)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' Joint replacement (Q16)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' Bladder (Q34)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' Bladder - Doctor (Q64)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_1)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_2)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_3)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_4)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_5)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_6)
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_7)
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_8)
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_9)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_10)
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_11)
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' Currently being treated for (Q35_A_12)
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' Other health conditions (Q36)
                newLine.Append(PadString(row(50), 30, Direction.Left, " ")) ' Describe other health conditions (Q38)
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' Rheumatoid Arthritis (Q74)
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' Arthritis Medication (Q68)
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' COPD (Q67)
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' Spirometry Testing (Q66)
                newLine.Append(PadString(row(55), 1, Direction.Left, " ")) ' High Blood Pressure (Q65)
                newLine.Append(PadString(row(56), 15, Direction.Left, " ")) ' Blood Pressure reading (Q37_1)
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) ' Congestive Heart Failure (Q75)
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' Hospitalized for CHF (Q76)
                newLine.Append(PadString(row(59), 2, Direction.Left, " ")) ' Medicines (Q39_1)
                newLine.Append(PadString(row(60), 2, Direction.Left, " ")) ' Medicines (Q39_2)
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' Practitioner reviewed medicines (Q40)
                newLine.Append(PadString(row(62), 1, Direction.Left, " ")) ' Treating with medicines? (Q41_A_1)
                newLine.Append(PadString(row(63), 1, Direction.Left, " ")) ' Treating with medicines? (Q41_A_2)
                newLine.Append(PadString(row(64), 1, Direction.Left, " ")) ' Treating with medicines? (Q41_A_3)
                newLine.Append(PadString(row(65), 1, Direction.Left, " ")) ' Treating with medicines? (Q41_A_4)
                newLine.Append(PadString(row(66), 1, Direction.Left, " ")) ' Treating with medicines? (Q41_A_5)
                newLine.Append(PadString(row(67), 1, Direction.Left, " ")) ' Flu Shot (Q43)
                newLine.Append(PadString(row(68), 1, Direction.Left, " ")) ' Pneumonia shot (Q47)
                newLine.Append(PadString(row(69), 1, Direction.Left, " ")) ' Eye Exam (Q51)
                newLine.Append(PadString(row(70), 1, Direction.Left, " ")) ' Bone Mineral Density Test (Q60)
                newLine.Append(PadString(row(71), 1, Direction.Left, " ")) ' Talked to doctor about BMD (Q69)
                newLine.Append(PadString(row(72), 1, Direction.Left, " ")) ' Meds for bone strength (Q63)
                newLine.Append(PadString(row(73), 1, Direction.Left, " ")) ' Mammogram (Q70)
                newLine.Append(PadString(row(74), 1, Direction.Left, " ")) ' Fecal Occult Blood Test (Q71)
                newLine.Append(PadString(row(75), 1, Direction.Left, " ")) ' Sigmoidoscopy (Q72)
                newLine.Append(PadString(row(76), 1, Direction.Left, " ")) ' Colonoscopy (Q73)
                newLine.Append(PadString(row(77), 1, Direction.Left, " ")) ' Help with activities (Q3_A_1)
                newLine.Append(PadString(row(78), 1, Direction.Left, " ")) ' Help with activities (Q3_A_2)
                newLine.Append(PadString(row(79), 1, Direction.Left, " ")) ' Help with activities (Q3_A_3)
                newLine.Append(PadString(row(80), 1, Direction.Left, " ")) ' Help with activities (Q3_A_4)
                newLine.Append(PadString(row(81), 1, Direction.Left, " ")) ' Help with activities (Q3_A_5)
                newLine.Append(PadString(row(82), 1, Direction.Left, " ")) ' Help with activities (Q3_A_6)
                newLine.Append(PadString(row(83), 1, Direction.Left, " ")) ' Help with activities (Q3_A_7)
                newLine.Append(PadString(row(84), 1, Direction.Left, " ")) ' Help with activities (Q3_A_8)
                newLine.Append(PadString(row(85), 1, Direction.Left, " ")) ' Help with activities (Q3_A_9)
                newLine.Append(PadString(row(86), 1, Direction.Left, " ")) ' Help with activities (Q3_A_10)
                newLine.Append(PadString(row(87), 1, Direction.Left, " ")) ' Help with activities (Q3_A_11)
                newLine.Append(PadString(row(88), 1, Direction.Left, " ")) ' Help with activities (Q3_A_12)
                newLine.Append(PadString(row(89), 1, Direction.Left, " ")) ' Help with activities (Q3_A_13)
                newLine.Append(PadString(row(90), 1, Direction.Left, " ")) ' Statement of health that fits best (Q17)
                newLine.Append(PadString(row(91), 1, Direction.Left, " ")) ' Need help and unable to get help (Q62)
                newLine.Append(PadString(row(92), 1, Direction.Left, " ")) ' Where do you currently live (Q24)
                newLine.Append(PadString(row(93), 30, Direction.Left, " ")) ' Where do you currently live (Q24SPECIFIED_4)
                newLine.Append(PadString(row(94), 1, Direction.Left, " ")) ' Describe your living arrangement (Q44_1)
                newLine.Append(PadString(row(95), 1, Direction.Left, " ")) ' Describe your living arrangement (Q44_2)
                newLine.Append(PadString(row(96), 1, Direction.Left, " ")) ' Describe your living arrangement (Q44_3)
                newLine.Append(PadString(row(97), 1, Direction.Left, " ")) ' Describe your living arrangement (Q44_4)
                newLine.Append(PadString(row(98), 1, Direction.Left, " ")) ' Describe your living arrangement (Q44_5)
                newLine.Append(PadString(row(99), 1, Direction.Left, " ")) ' Describe your living arrangement (Q44_6)
                newLine.Append(PadString(row(100), 1, Direction.Left, " ")) ' Health conditions interfere with daily activities (Q18)
                newLine.Append(PadString(row(101), 1, Direction.Left, " ")) ' Inpatient (Q42)
                newLine.Append(PadString(row(102), 1, Direction.Left, " ")) ' Emergency room (Q19)
                newLine.Append(PadString(row(103), 1, Direction.Left, " ")) ' Doc Visits (Q25)
                newLine.Append(PadString(row(104), 1, Direction.Left, " ")) ' Recent loss of a loved one (Q6)
                newLine.Append(PadString(row(105), 1, Direction.Left, " ")) ' Little interest in doing things  (Q52)
                newLine.Append(PadString(row(106), 1, Direction.Left, " ")) ' Feeling down (Q53)
                newLine.Append(PadString(row(107), 1, Direction.Left, " ")) ' Are you a caregiver (Q48)
                newLine.Append(PadString(row(108), 1, Direction.Left, " ")) ' Friend relative neighbor (Q49)
                newLine.Append(PadString(row(109), 1, Direction.Left, " ")) ' Apply to nursing home (Q46)
                newLine.Append(PadString(row(110), 1, Direction.Left, " ")) ' Nursing home/convalescent hospital (Q50)
                newLine.Append(PadString(row(111), 1, Direction.Left, " ")) ' 5 or more weeks in nursing home (Q54)
                newLine.Append(PadString(row(112), 1, Direction.Left, " ")) ' Advance directives (Q26_1)
                newLine.Append(PadString(row(113), 1, Direction.Left, " ")) ' Advance directives (Q26_2)
                newLine.Append(PadString(row(114), 1, Direction.Left, " ")) ' Advance directives (Q26_3)
                newLine.Append(PadString(row(115), 1, Direction.Left, " ")) ' Information on file with doctor (Q56)
                newLine.Append(PadString(row(116), 1, Direction.Left, " ")) ' Receiving medical assistance (Q28)
                newLine.Append(PadString(row(117), 1, Direction.Left, " ")) ' Help with form (Q32)
                newLine.Append(PadString(row(118), 30, Direction.Left, " ")) ' Information on the person who helped fill out the form (Q61_1)
                newLine.Append(PadString(row(119), 30, Direction.Left, " ")) ' Information on the person who helped fill out the form (Q61_2)
                newLine.Append(PadString(row(120), 10, Direction.Left, " ")) ' Information on the person who helped fill out the form (Q61_3)
                newLine.Append(PadString(row(121), 30, Direction.Left, " ")) ' Doctor's name and phone number (Q27_1)
                newLine.Append(PadString(row(122), 10, Direction.Left, " ")) ' Doctor's name and phone number (Q27_2)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertExcellusUpdate()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' 1: BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(68).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' 2-9: Last Modified
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' 10: BLANK(1)
                newLine.Append(PadString(row(11), 8, Direction.Left, " "))  ' 11-18: FAQs (Q45_1)
                newLine.Append(PadString(row(12), 5, Direction.Right, "0")) ' 19-23: TEMPLATEDID (Q112_1)
                newLine.Append(PadString(row(13), 8, Direction.Right, "0")) ' 24-31: RespondentID (Q113_1)

                newLine.Append(PadString("", 3, Direction.Left, " "))       ' 32-34: BLANK(3)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 35: Rate health (Q1)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 36: Rate Mental Health (Q57)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 37: Overnight in the last 12 mo (Q4)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 38: Heart failure Hospitilization (Q5)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 39: Doctor Visits (Q18)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 40: Diabetes (Q9)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 41: Heart Health (Q19_A_1)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 42: Heart Health (Q19_A_2)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 43: Heart Health (Q19_A_3)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 44: Heart Health (Q19_A_4)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 45: Currently being treated for heart problems (Q10)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 46: Neighbor (Q15)

                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 47: Help bathe (Q29)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 48: Help taking Meds (Q31)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 49: Health Interfere Daily (Q55)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 50: Trouble with Doctor and Shopping (Q58)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 51: Help with Doctor and Shopping (Q34)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 52: Excercise (Q16)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 53: Fallen in past 12 months (Q11)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 54: BMD TEST (Q33)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 55: Hip Fracture (Q59)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 56: 1 (Q24)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 57: 2(Q25_A_1)

                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 58: 2 (Q25_A_2)
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' 59: Bladder (Q37)
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' 60: Bladder - Doctor (Q64)

                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' 61: Currently being treated for (Q35_A_1)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' 62: Currently being treated for (Q35_A_2)
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' 63: Currently being treated for (Q35_A_3)
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' 64: Currently being treated for (Q35_A_4)
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' 65: Currently being treated for (Q35_A_5)
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' 66: Currently being treated for (Q35_A_6)
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' 67: Currently being treated for (Q35_A_7)
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' 68: Currently being treated for (Q35_A_8)
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' 69: Currently being treated for (Q35_A_9)
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' 70: Other health conditions (Q36)

                newLine.Append(PadString(row(55), 30, Direction.Left, " ")) ' 71-100: Describe other health conditions (Q38)

                newLine.Append(PadString(row(56), 1, Direction.Left, " ")) ' 101: Advance directives (Q26)
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) '102: Conversation - Health Care Proxy  (Q3)
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' 103: MOLST (Q6)
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' 104: Help with Questionnaire (Q17)
                newLine.Append(PadString(row(60), 30, Direction.Left, " ")) ' 105-134: Information on the person who helped fill out the form (Q61_1)
                newLine.Append(PadString(row(61), 15, Direction.Left, " ")) ' 135-149: Information on the person who helped fill out the form (Q61_2)
                newLine.Append(PadString(row(62), 10, Direction.Left, " ")) ' 150-159: Information on the person who helped fill out the form (Q61_3)

                writer.WriteLine(newLine.ToString)

            Next
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertExcellus()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' 1: BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(68).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' 2-9: Last Modified
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' 10: BLANK(1)
                newLine.Append(PadString(row(11), 8, Direction.Left, " "))  ' 11-18: FAQs (Q45_1)
                newLine.Append(PadString(row(12), 5, Direction.Right, "0")) ' 19-23: TEMPLATEDID (Q112_1)
                newLine.Append(PadString(row(13), 8, Direction.Right, "0")) ' 24-31: RespondentID (Q113_1)
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' 32-34: BLANK(3)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 35: Rate health (Q1)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 36: Rate Mental Health (Q57)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 37: Overnight in the last 12 mo (Q4)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 38: Heart failure Hospitilization (Q5)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 39: Doctor Visits (Q18)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 40: Diabetes (Q9)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 41: Heart Health (Q19_A_1)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 42: Heart Health (Q19_A_2)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 43: Heart Health (Q19_A_3)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 44: Heart Health (Q19_A_4)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 45: Currently being treated for heart problems (Q10)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 46: Neighbor (Q15)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 47: Help bathe (Q29)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 48: Help taking Meds (Q31)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 49: Health Interfere Daily (Q55)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 50: Trouble with Doctor and Shopping (Q58)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 51: Help with Doctor and Shopping (Q34)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 52: Excercise (Q16)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 53: Fallen in past 12 months (Q11)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 54: BMD TEST (Q33)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 55: Hip Fracture (Q59)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 56: Stay Home (Q74)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 57: Bored (Q78)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 58: Helpless (Q79)
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' 59: Basically Satisfied (Q80)
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' 60: Feel Worthless (Q81)
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' 61: Bladder (Q37)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' 62: Bladder-Doctor (Q64)
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' 63: Currently being treated for (Q35_A_1)
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' 64: Currently being treated for (Q35_A_2)
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' 65: Currently being treated for (Q35_A_3)
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' 66: Currently being treated for (Q35_A_4)
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' 67: Currently being treated for (Q35_A_5)
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' 68: Currently being treated for (Q35_A_6)
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' 69: Currently being treated for (Q35_A_7)
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' 70: Currently being treated for (Q35_A_8)
                newLine.Append(PadString(row(55), 1, Direction.Left, " ")) ' 71: Currently being treated for (Q35_A_9)
                newLine.Append(PadString(row(56), 1, Direction.Left, " ")) ' 72: Other health Conditions (Q36)
                newLine.Append(PadString(row(57), 30, Direction.Left, " ")) ' 73-102: Describe other health conditions (Q38)
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' 103: Advance directives (Q26)
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' 104: Conversation-Health Care Proxy (Q3)
                newLine.Append(PadString(row(60), 1, Direction.Left, " ")) ' 105: MOLST (Q6)
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' 106: Help with Questionnaire (Q17)
                newLine.Append(PadString(row(62), 30, Direction.Left, " ")) ' 107-136: Information on the person who helped fill out the form (Q61_1)
                newLine.Append(PadString(row(63), 15, Direction.Left, " ")) ' 137-151: Information on the person who helped fill out the form (Q61_2)
                newLine.Append(PadString(row(64), 10, Direction.Left, " ")) ' 152-161: Information on the person who helped fill out the form (Q61_3)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertCoventry2012()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(111).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(119), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(118), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 2 (Q4)
                newLine.Append(PadString("", 25, Direction.Left, " ")) ' BLANK(25)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 3 (Q5)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 4 (Q66)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 4a (Q15)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 4b (Q29)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 5 (Q55)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 6 (Q57)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 7 (Q30_A_1)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 7 (Q30_A_2)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 7 (Q30_A_3)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 7 (Q30_A_4)
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 8 (Q10)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 9 (Q9)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 10 (Q31)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 11 (Q58)
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 12 (Q33)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 13 (Q11)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 14 (Q34)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 14a (Q64)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 15 (Q35_A_1)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 15 (Q35_A_2)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 15 (Q35_A_3)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 15 (Q35_A_4)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 15 (Q35_A_5)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 15 (Q35_A_6)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 15 (Q35_A_7)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 15 (Q35_A_8)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 15 (Q35_A_9)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 15 (Q35_A_10)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 15 (Q35_A_11)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 15 (Q35_A_12)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 16 (Q59)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 16a (Q36)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 17 (Q74)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 17a (Q38)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 18 (Q65)
                newLine.Append(PadString(row(39), 25, Direction.Left, " ")) ' 18a (Q16_1)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 18b (Q37)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 19 (Q75)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 19a (Q76)
                newLine.Append(PadString(row(43), 2, Direction.Left, " ")) ' 20 (Q39_1)
                newLine.Append(PadString("", 23, Direction.Left, " ")) ' BLANK(23)
                newLine.Append(PadString(row(44), 2, Direction.Left, " ")) ' 20 (Q39_2)
                newLine.Append(PadString("", 23, Direction.Left, " ")) ' BLANK(23)
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' 21 (Q40)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' 22 (Q67)
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' 23 (Q41_A_1)
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' 23 (Q41_A_2)
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' 23 (Q41_A_3)
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' 23 (Q41_A_4)
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' 23 (Q41_A_5)
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' 24 (Q47)
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' 25 (Q43)
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' 26 (Q63)
                newLine.Append(PadString(row(55), 1, Direction.Left, " ")) ' 27 (Q70)
                newLine.Append(PadString(row(56), 1, Direction.Left, " ")) ' 28 (Q71)
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) ' 29 (Q72)
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' 30 (Q73)
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' 31 (Q3_A_1)
                newLine.Append(PadString(row(60), 1, Direction.Left, " ")) ' 31 (Q3_A_2)
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' 31 (Q3_A_3)
                newLine.Append(PadString(row(62), 1, Direction.Left, " ")) ' 31 (Q3_A_4)
                newLine.Append(PadString(row(63), 1, Direction.Left, " ")) ' 31 (Q3_A_5)
                newLine.Append(PadString(row(64), 1, Direction.Left, " ")) ' 31 (Q3_A_6)
                newLine.Append(PadString(row(65), 1, Direction.Left, " ")) ' 31 (Q3_A_7)
                newLine.Append(PadString(row(66), 1, Direction.Left, " ")) ' 31 (Q3_A_8)
                newLine.Append(PadString(row(67), 1, Direction.Left, " ")) ' 31 (Q3_A_9)
                newLine.Append(PadString(row(68), 1, Direction.Left, " ")) ' 31 (Q3_A_10)
                newLine.Append(PadString(row(69), 1, Direction.Left, " ")) ' 31 (Q3_A_11)
                newLine.Append(PadString(row(70), 1, Direction.Left, " ")) ' 31 (Q3_A_12)
                newLine.Append(PadString(row(71), 1, Direction.Left, " ")) ' 32 (Q51)
                newLine.Append(PadString(row(72), 1, Direction.Left, " ")) ' 33 (Q17)
                newLine.Append(PadString(row(73), 1, Direction.Left, " ")) ' 34 (Q62)
                newLine.Append(PadString(row(74), 1, Direction.Left, " ")) ' 35 (Q24)
                newLine.Append(PadString("", 25, Direction.Left, " ")) ' BLANK(25)
                newLine.Append(PadString(row(75), 1, Direction.Left, " ")) ' 36 (Q44_1)
                newLine.Append(PadString(row(76), 1, Direction.Left, " ")) ' 36 (Q44_2)
                newLine.Append(PadString(row(77), 1, Direction.Left, " ")) ' 36 (Q44_3)
                newLine.Append(PadString(row(78), 1, Direction.Left, " ")) ' 36 (Q44_4)
                newLine.Append(PadString(row(79), 1, Direction.Left, " ")) ' 36 (Q44_5)
                newLine.Append(PadString(row(80), 1, Direction.Left, " ")) ' 36 (Q44_6)
                newLine.Append(PadString(row(81), 1, Direction.Left, " ")) ' 37 (Q18)
                newLine.Append(PadString(row(82), 1, Direction.Left, " ")) ' 38 (Q42)
                newLine.Append(PadString(row(83), 1, Direction.Left, " ")) ' 39 (Q19)
                newLine.Append(PadString(row(84), 1, Direction.Left, " ")) ' 40 (Q25)
                newLine.Append(PadString(row(85), 1, Direction.Left, " ")) ' 41 (Q6)
                newLine.Append(PadString(row(86), 1, Direction.Left, " ")) ' 42 (Q60_A_1)
                newLine.Append(PadString(row(87), 1, Direction.Left, " ")) ' 42 (Q60_A_2)
                newLine.Append(PadString(row(88), 1, Direction.Left, " ")) ' 43 (Q48)
                newLine.Append(PadString(row(89), 1, Direction.Left, " ")) ' 44 (Q49)
                newLine.Append(PadString(row(90), 1, Direction.Left, " ")) ' 45 (Q46)
                newLine.Append(PadString(row(91), 1, Direction.Left, " ")) ' 46 (Q50)
                newLine.Append(PadString(row(92), 1, Direction.Left, " ")) ' 47 (Q54)
                newLine.Append(PadString(row(93), 1, Direction.Left, " ")) ' 48 (Q26_1)
                newLine.Append(PadString(row(94), 1, Direction.Left, " ")) ' 48 (Q26_2)
                newLine.Append(PadString(row(95), 1, Direction.Left, " ")) ' 48 (Q26_3)
                newLine.Append(PadString(row(96), 1, Direction.Left, " ")) ' 49 (Q56)
                newLine.Append(PadString(row(97), 1, Direction.Left, " ")) ' 50 (Q28)
                newLine.Append(PadString(row(98), 1, Direction.Left, " ")) ' 51 (Q32)
                newLine.Append(PadString(row(99), 1, Direction.Left, " ")) ' 52 (Q52)
                newLine.Append(PadString(row(100), 30, Direction.Left, " ")) ' 53 (Q61_1)
                newLine.Append(PadString(row(101), 15, Direction.Left, " ")) ' 53 (Q61_2)
                newLine.Append(PadString(row(102), 10, Direction.Left, " ")) ' 53 (Q61_3)
                newLine.Append(PadString(row(103), 30, Direction.Left, " ")) ' 54 (Q27_1)
                newLine.Append(PadString(row(104), 10, Direction.Left, " ")) ' 54 (Q27_2)
                newLine.Append(PadString(row(105), 1000, Direction.Left, " ")) ' 55 (Q53)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertAdult()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(48).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(56), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(55), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 2 (Q2)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 4 (Q14)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 4a (Q12)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 4b (Q3)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 4c (Q9)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 5 (Q16_A_1)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 5 (Q16_A_2)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 5 (Q16_A_3)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 5 (Q16_A_4)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 6 (Q6)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 8 (Q10_A_1)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 8 (Q10_A_2)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 8 (Q10_A_3)
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 8 (Q10_A_4)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 8 (Q10_A_5)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 8 (Q10_A_6)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 8 (Q10_A_7)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 8 (Q10_A_8)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 8 (Q10_A_9)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 8 (Q10_A_10)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 8 (Q10_A_11)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 8 (Q10_A_12)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 8 (Q10_A_13)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 8 (Q10_A_14)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 8 (Q10_A_15)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 8 (Q10_A_17)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 8 (Q10_A_18)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 8 (Q10_A_19)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 8 (Q10_A_20)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 8 (Q10_A_21)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 8 (Q10_A_22)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 8 (Q10_A_23)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 8 (Q10_A_24)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 8 (Q10_A_25)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 8 (Q10_A_26)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 8 (Q10_A_16)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 9 (Q8)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 10 (Q5)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertChild()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(28).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(36), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(35), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1 (Q1)
                newLine.Append(PadString(row(3), 1, Direction.Left, " ")) ' 2 (Q21)
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' 2a (Q2)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 2b (Q3)
                newLine.Append(PadString(row(6), 100, Direction.Left, " ")) ' 2c (Q9)
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' 3 (Q5)
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' 3a (Q6)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 3b (Q7)
                newLine.Append(PadString(row(10), 100, Direction.Left, " ")) ' 3c (Q4)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 4 (Q8)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 4a (Q10)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 4b (Q11)
                newLine.Append(PadString(row(14), 100, Direction.Left, " ")) ' 4c (Q12)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 5 (Q13)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 5a (Q14)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 5b (Q15)
                newLine.Append(PadString(row(18), 100, Direction.Left, " ")) ' 5c (Q16)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 6 (Q17)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 6a (Q22)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 6b (Q18)
                newLine.Append(PadString(row(22), 100, Direction.Left, " ")) ' 6c (Q19)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertMaternity()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(96).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)
                newLine.Append(PadString(row(104), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(103), 8, Direction.Right, "0")) ' Key 2
                newLine.Append(PadString("", 19, Direction.Left, " "))       ' BLANK(19)
                newLine.Append(PadString(row(81), 1, Direction.Left, " ")) ' 32 (Q19_1)
                newLine.Append(PadString(row(82), 1, Direction.Left, " ")) ' 32 (Q19_2)
                newLine.Append(PadString(row(83), 1, Direction.Left, " ")) ' 32 (Q19_3)
                newLine.Append(PadString(row(84), 1, Direction.Left, " ")) ' 32 (Q19_4)
                newLine.Append(PadString(row(85), 1, Direction.Left, " ")) ' 32 (Q19_5)
                newLine.Append(PadString(row(86), 1, Direction.Left, " ")) ' 32 (Q19_6)
                newLine.Append(PadString(row(87), 1, Direction.Left, " ")) ' 33 (Q36)
                newLine.Append(PadString(row(88), 22, Direction.Left, " ")) ' 33 (Q36SPECIFIED_3)
                newLine.Append(PadString(row(89), 1, Direction.Left, " ")) ' 34 (Q1)
                newLine.Append(PadString(row(90), 22, Direction.Left, " ")) ' 34 (Q1SPECIFIED_3)
                newLine.Append(PadString(row(2), 1, Direction.Left, " ")) ' 1 (Q3)
                newLine.Append(PadString(row(3), 32, Direction.Left, " ")) ' 2 (Q4)
                newLine.Append(PadString(row(4), 6, Direction.Left, " ")) ' 3 (Q18_1)
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' 7 (Q6)
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' 4 (Q7)
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' 5 (Q5_1)
                newLine.Append(PadString(row(7), 2, Direction.Left, " ")) ' 5 (Q5_2)
                newLine.Append(PadString(row(8), 3, Direction.Left, " ")) ' 6 (Q8_1)
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' 8 (Q10_A_1)
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' 9 (Q2_A_1)
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' 8 (Q10_A_2)
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' 9 (Q2_A_2)
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' 8 (Q10_A_3)
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' 9 (Q2_A_3)
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' 8 (Q10_A_4)
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' 9 (Q2_A_4)
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' 8 (Q10_A_5)
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' 8 (Q10_A_6)
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' 8 (Q10_A_7)
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' 8 (Q10_A_8)
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' 9 (Q2_A_5)
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' 8 (Q10_A_9)
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' 9 (Q2_A_6)
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' 8 (Q10_A_10)
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' 9 (Q2_A_7)
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' 9 (Q2_A_8)
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' 9 (Q2_A_9)
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' 9 (Q2_A_10)
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' 9 (Q2_A_11)
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' 10 (Q11_A_1)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' 11 (Q20_A_1)
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' 10 (Q11_A_2)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' 11 (Q20_A_2)
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' 10 (Q11_A_3)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' 11 (Q20_A_3)
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' 10 (Q11_A_4)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' 11 (Q20_A_4)
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' 10 (Q11_A_5)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' 11 (Q20_A_5)
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' 10 (Q11_A_6)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' 11 (Q20_A_6)
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' 10 (Q11_A_7)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' 11 (Q20_A_7)
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' 10 (Q11_A_8)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' 11 (Q20_A_8)
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' 10 (Q11_A_9)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' 11 (Q20_A_9)
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' 10 (Q11_A_10)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' 11 (Q20_A_10)
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' 10 (Q11_A_11)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' 11 (Q20_A_11)
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' 10 (Q11_A_12)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(55), 1, Direction.Left, " ")) ' 11 (Q20_A_12)
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' 10 (Q11_A_13)
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' BLANK(1)
                newLine.Append(PadString(row(56), 1, Direction.Left, " ")) ' 11 (Q20_A_13)
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) ' 12 (Q21)
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' 13 (Q22)
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' 14 (Q23)
                newLine.Append(PadString(row(60), 1, Direction.Left, " ")) ' 15 (Q12)
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' 16 (Q24)
                newLine.Append(PadString(row(62), 1, Direction.Left, " ")) ' 17 (Q25)
                newLine.Append(PadString(row(63), 1, Direction.Left, " ")) ' 18 (Q26)
                newLine.Append(PadString(row(64), 1, Direction.Left, " ")) ' 19 (Q27)
                newLine.Append(PadString(row(65), 1, Direction.Left, " ")) ' 20 (Q28)
                newLine.Append(PadString(row(66), 1, Direction.Left, " ")) ' 21 (Q29)
                newLine.Append(PadString(row(67), 1, Direction.Left, " ")) ' 22 (Q30)
                newLine.Append(PadString(row(68), 1, Direction.Left, " ")) ' 23 (Q14_A_1)
                newLine.Append(PadString(row(69), 1, Direction.Left, " ")) ' 23 (Q14_A_2)
                newLine.Append(PadString(row(70), 1, Direction.Left, " ")) ' 23 (Q14_A_3)
                newLine.Append(PadString(row(71), 1, Direction.Left, " ")) ' 24 (Q15_A_1)
                newLine.Append(PadString(row(72), 1, Direction.Left, " ")) ' 24 (Q15_A_2)
                newLine.Append(PadString(row(73), 1, Direction.Left, " ")) ' 24 (Q15_A_3)
                newLine.Append(PadString(row(74), 1, Direction.Left, " ")) ' 25 (Q16)
                newLine.Append(PadString(row(75), 1, Direction.Left, " ")) ' 26 (Q13)
                newLine.Append(PadString(row(76), 1, Direction.Left, " ")) ' 27 (Q31)
                newLine.Append(PadString(row(77), 1, Direction.Left, " ")) ' 28 (Q32)
                newLine.Append(PadString(row(78), 1, Direction.Left, " ")) ' 29 (Q33)
                newLine.Append(PadString(row(79), 1, Direction.Left, " ")) ' 30 (Q34)
                newLine.Append(PadString(row(80), 1, Direction.Left, " ")) ' 31 (Q35)


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertPriorityHealth()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(116).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified
                newLine.Append(PadString("", 9, Direction.Left, " "))       ' BLANK(9)

                newLine.Append(PadString(row(127), 5, Direction.Right, "0")) ' Key 3
                newLine.Append(PadString(row(126), 8, Direction.Right, "0")) ' Key 2

                newLine.Append(PadString("", 3, Direction.Left, " "))       ' BLANK(3)

                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' Q1 Start: 35 End: 35
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' Q4 Start: 36 End: 36
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' Q5 Start: 37 End: 37
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' Q66 Start: 38 End: 38
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' Q15 Start: 39 End: 39
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' Q29 Start: 40 End: 40
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' Q55 Start: 41 End: 41
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' Q30_A_1 Start: 42 End: 42
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' Q30_A_2 Start: 43 End: 43
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' Q30_A_3 Start: 44 End: 44
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' Q30_A_4 Start: 45 End: 45
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' Q10 Start: 46 End: 46
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' Q9 Start: 47 End: 47
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' Q58 Start: 48 End: 48
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' Q33 Start: 49 End: 49
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' Q11 Start: 50 End: 50
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' Q34 Start: 51 End: 51
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' Q64 Start: 52 End: 52
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' Q35_A_1 Start: 53 End: 53
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' Q35_A_2 Start: 54 End: 54
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' Q35_A_3 Start: 55 End: 55
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' Q35_A_4 Start: 56 End: 56
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' Q35_A_5 Start: 57 End: 57
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' Q35_A_6 Start: 58 End: 58
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' Q35_A_7 Start: 59 End: 59
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' Q35_A_8 Start: 60 End: 60
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' Q35_A_9 Start: 61 End: 61
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' Q35_A_10 Start: 62 End: 62
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' Q35_A_11 Start: 63 End: 63
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' Q35_A_12 Start: 64 End: 64
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' Q35_A_13 Start: 65 End: 65
                newLine.Append(PadString(row(36), 30, Direction.Left, " ")) ' Q13_1 Start: 66 End: 95
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' Q59 Start: 96 End: 96
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' Q36 Start: 97 End: 97
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' Q74 Start: 98 End: 98
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' Q38 Start: 99 End: 99
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' Q65 Start: 100 End: 100
                newLine.Append(PadString(row(42), 15, Direction.Left, " ")) ' Q16_1 Start: 101 End: 115
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' Q75 Start: 116 End: 116
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' Q76 Start: 117 End: 117
                newLine.Append(PadString(row(45), 2, Direction.Left, " ")) ' Q39_1 Start: 118 End: 119
                newLine.Append(PadString(row(46), 2, Direction.Left, " ")) ' Q39_2 Start: 120 End: 121
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' Q40 Start: 122 End: 122
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' Q41_A_1 Start: 123 End: 123
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' Q41_A_2 Start: 124 End: 124
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' Q41_A_3 Start: 125 End: 125
                newLine.Append(PadString(row(51), 1, Direction.Left, " ")) ' Q41_A_4 Start: 126 End: 126
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' Q41_A_5 Start: 127 End: 127
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' Q47 Start: 128 End: 128
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' Q43 Start: 129 End: 129
                newLine.Append(PadString(row(55), 1, Direction.Left, " ")) ' Q63 Start: 130 End: 130
                newLine.Append(PadString(row(56), 1, Direction.Left, " ")) ' Q14 Start: 131 End: 131
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) ' Q20 Start: 132 End: 132
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' Q21 Start: 133 End: 133
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' Q70 Start: 134 End: 134
                newLine.Append(PadString(row(60), 1, Direction.Left, " ")) ' Q71 Start: 135 End: 135
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' Q72 Start: 136 End: 136
                newLine.Append(PadString(row(62), 1, Direction.Left, " ")) ' Q73 Start: 137 End: 137
                newLine.Append(PadString(row(64), 1, Direction.Left, " ")) ' Q3_A_1 Start: 138 End: 138
                newLine.Append(PadString(row(65), 1, Direction.Left, " ")) ' Q3_A_2 Start: 139 End: 139
                newLine.Append(PadString(row(66), 1, Direction.Left, " ")) ' Q3_A_3 Start: 140 End: 140
                newLine.Append(PadString(row(67), 1, Direction.Left, " ")) ' Q3_A_4 Start: 141 End: 141
                newLine.Append(PadString(row(68), 1, Direction.Left, " ")) ' Q3_A_5 Start: 142 End: 142
                newLine.Append(PadString(row(69), 1, Direction.Left, " ")) ' Q3_A_6 Start: 143 End: 143
                newLine.Append(PadString(row(70), 1, Direction.Left, " ")) ' Q3_A_7 Start: 144 End: 144
                newLine.Append(PadString(row(71), 1, Direction.Left, " ")) ' Q3_A_8 Start: 145 End: 145
                newLine.Append(PadString(row(72), 1, Direction.Left, " ")) ' Q3_A_9 Start: 146 End: 146
                newLine.Append(PadString(row(73), 1, Direction.Left, " ")) ' Q3_A_10 Start: 147 End: 147
                newLine.Append(PadString(row(74), 1, Direction.Left, " ")) ' Q3_A_11 Start: 148 End: 148
                newLine.Append(PadString(row(75), 1, Direction.Left, " ")) ' Q3_A_12 Start: 149 End: 149
                newLine.Append(PadString(row(76), 1, Direction.Left, " ")) ' Q3_A_13 Start: 150 End: 150
                newLine.Append(PadString(row(77), 1, Direction.Left, " ")) ' Q17 Start: 151 End: 151
                newLine.Append(PadString(row(78), 1, Direction.Left, " ")) ' Q62 Start: 152 End: 152
                newLine.Append(PadString(row(79), 1, Direction.Left, " ")) ' Q24 Start: 153 End: 153
                newLine.Append(PadString(row(80), 30, Direction.Left, " ")) ' Q24SPECIFIED_4 Start: 154 End: 183
                newLine.Append(PadString(row(81), 1, Direction.Left, " ")) ' Q44_1 Start: 184 End: 184
                newLine.Append(PadString(row(82), 1, Direction.Left, " ")) ' Q44_2 Start: 185 End: 185
                newLine.Append(PadString(row(83), 1, Direction.Left, " ")) ' Q44_3 Start: 186 End: 186
                newLine.Append(PadString(row(84), 1, Direction.Left, " ")) ' Q44_4 Start: 187 End: 187
                newLine.Append(PadString(row(85), 1, Direction.Left, " ")) ' Q44_5 Start: 188 End: 188
                newLine.Append(PadString(row(86), 1, Direction.Left, " ")) ' Q44_6 Start: 189 End: 189
                newLine.Append(PadString(row(87), 1, Direction.Left, " ")) ' Q18 Start: 190 End: 190
                newLine.Append(PadString(row(88), 1, Direction.Left, " ")) ' Q42 Start: 191 End: 191
                newLine.Append(PadString(row(89), 1, Direction.Left, " ")) ' Q19 Start: 192 End: 192
                newLine.Append(PadString(row(90), 1, Direction.Left, " ")) ' Q25 Start: 193 End: 193
                newLine.Append(PadString(row(91), 1, Direction.Left, " ")) ' Q6 Start: 194 End: 194
                newLine.Append(PadString(row(92), 1, Direction.Left, " ")) ' Q60_A_1 Start: 195 End: 195
                newLine.Append(PadString(row(93), 1, Direction.Left, " ")) ' Q60_A_2 Start: 196 End: 196
                newLine.Append(PadString(row(94), 1, Direction.Left, " ")) ' Q48 Start: 197 End: 197
                newLine.Append(PadString(row(95), 1, Direction.Left, " ")) ' Q49 Start: 198 End: 198
                newLine.Append(PadString(row(96), 1, Direction.Left, " ")) ' Q46 Start: 199 End: 199
                newLine.Append(PadString(row(97), 1, Direction.Left, " ")) ' Q50 Start: 200 End: 200
                newLine.Append(PadString(row(98), 1, Direction.Left, " ")) ' Q54 Start: 201 End: 201
                newLine.Append(PadString(row(99), 1, Direction.Left, " ")) ' Q26_1 Start: 202 End: 202
                newLine.Append(PadString(row(100), 1, Direction.Left, " ")) ' Q26_2 Start: 203 End: 203
                newLine.Append(PadString(row(101), 1, Direction.Left, " ")) ' Q26_3 Start: 204 End: 204
                newLine.Append(PadString(row(102), 1, Direction.Left, " ")) ' Q56 Start: 205 End: 205
                newLine.Append(PadString(row(103), 1, Direction.Left, " ")) ' Q28 Start: 206 End: 206
                newLine.Append(PadString(row(104), 1, Direction.Left, " ")) ' Q32 Start: 207 End: 207
                newLine.Append(PadString(row(105), 30, Direction.Left, " ")) ' Q61_1 Start: 208 End: 237
                newLine.Append(PadString(row(106), 30, Direction.Left, " ")) ' Q61_2 Start: 238 End: 267
                newLine.Append(PadString(row(107), 10, Direction.Left, " ")) ' Q61_3 Start: 268 End: 277
                newLine.Append(PadString(row(108), 28, Direction.Left, " ")) ' Q27_1 Start: 278 End: 305
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' Q12 Start: 306 End: 306
                newLine.Append(PadString(row(63), 1, Direction.Left, " ")) ' Q22 Start: 307 End: 307
                newLine.Append(PadString(row(109), 10, Direction.Left, " ")) ' Q27_2 Start: 308 End: 317


                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Sub ConvertMedMutual()
        Dim writer As System.IO.StreamWriter = Nothing
        Dim blnSkipHeader As Boolean = True
        Try
            writer = New StreamWriter(Me.txtConvertFile.Text, False)
            Dim readTable As System.Data.DataTable = GetImportTable()

            For Each col As DataColumn In readTable.Columns
                Debug.Print(col.ColumnName)
            Next

            For Each row As Data.DataRow In readTable.Rows
                Dim newLine As New StringBuilder()
                Dim tempVar As String = ""

                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)
                newLine.Append(PadString(Convert.ToDateTime(row(123).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " ")) ' Last Modified Start: 2 End: 9
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' BLANK(1)  Start 10 End 10
                newLine.Append(PadString(row(2), 8, Direction.Left, " ")) ' (Q7_1) FAQSS Template ID Start: 11 End: 18
                newLine.Append(PadString(row(134), 5, Direction.Left, " ")) ' Key 3 Start: 19 End: 23
                newLine.Append(PadString(row(133), 8, Direction.Left, " ")) ' Key 2 Start: 24 End: 31
                newLine.Append(PadString("", 4, Direction.Left, " "))       ' BLANK(3) Start 32 END 35
                newLine.Append(PadString(row(4), 1, Direction.Left, " ")) ' (Q23_A_1) 1-10 Start: 36 End: 36
                newLine.Append(PadString(row(5), 1, Direction.Left, " ")) ' (Q23_A_2) 1-10 Start: 37 End: 37
                newLine.Append(PadString(row(6), 1, Direction.Left, " ")) ' (Q23_A_3) 1-10 Start: 38 End: 38
                newLine.Append(PadString(row(7), 1, Direction.Left, " ")) ' (Q23_A_4) 1-10 Start: 39 End: 39
                newLine.Append(PadString(row(8), 1, Direction.Left, " ")) ' (Q23_A_5) 1-10 Start: 40 End: 40
                newLine.Append(PadString(row(9), 1, Direction.Left, " ")) ' (Q23_A_6) 1-10 Start: 41 End: 41
                newLine.Append(PadString(row(10), 1, Direction.Left, " ")) ' (Q23_A_7) 1-10 Start: 42 End: 42
                newLine.Append(PadString(row(11), 1, Direction.Left, " ")) ' (Q23_A_8) 1-10 Start: 43 End: 43
                newLine.Append(PadString(row(12), 1, Direction.Left, " ")) ' (Q23_A_9) 1-10 Start: 44 End: 44
                newLine.Append(PadString(row(13), 1, Direction.Left, " ")) ' (Q23_A_10) 1-10 Start: 45 End: 45
                newLine.Append(PadString(row(14), 1, Direction.Left, " ")) ' (Q1) 11 Start: 46 End: 46
                newLine.Append(PadString(row(15), 1, Direction.Left, " ")) ' (Q5) 12 Start: 47 End: 47
                newLine.Append(PadString(row(16), 1, Direction.Left, " ")) ' (Q66) 13 Start: 48 End: 48
                newLine.Append(PadString(row(17), 1, Direction.Left, " ")) ' (Q15) 13a Start: 49 End: 49
                newLine.Append(PadString(row(18), 1, Direction.Left, " ")) ' (Q29) 13b Start: 50 End: 50
                newLine.Append(PadString(row(19), 1, Direction.Left, " ")) ' (Q31) 13c Start: 51 End: 51
                newLine.Append(PadString(row(20), 1, Direction.Left, " ")) ' (Q55) 14 Start: 52 End: 52
                newLine.Append(PadString(row(21), 1, Direction.Left, " ")) ' (Q37) 15 Start: 53 End: 53
                newLine.Append(PadString(row(22), 1, Direction.Left, " ")) ' (Q30_A_1) 16 Start: 54 End: 54
                newLine.Append(PadString(row(23), 1, Direction.Left, " ")) ' (Q30_A_2) 16 Start: 55 End: 55
                newLine.Append(PadString(row(24), 1, Direction.Left, " ")) ' (Q30_A_3) 16 Start: 56 End: 56
                newLine.Append(PadString(row(25), 1, Direction.Left, " ")) ' (Q30_A_4) 16 Start: 57 End: 57
                newLine.Append(PadString(row(26), 1, Direction.Left, " ")) ' (Q10) 17 Start: 58 End: 58
                newLine.Append(PadString(row(27), 1, Direction.Left, " ")) ' (Q9) 18 Start: 59 End: 59
                newLine.Append(PadString(row(28), 1, Direction.Left, " ")) ' (Q45) 19 Start: 60 End: 60
                newLine.Append(PadString(row(29), 1, Direction.Left, " ")) ' (Q58) 20 Start: 61 End: 61
                newLine.Append(PadString(row(30), 1, Direction.Left, " ")) ' (Q33) 21 Start: 62 End: 62
                newLine.Append(PadString(row(31), 1, Direction.Left, " ")) ' (Q11) 22 Start: 63 End: 63
                newLine.Append(PadString(row(32), 1, Direction.Left, " ")) ' (Q34) 23 Start: 64 End: 64
                newLine.Append(PadString(row(33), 1, Direction.Left, " ")) ' (Q64) 23a Start: 65 End: 65
                newLine.Append(PadString(row(34), 1, Direction.Left, " ")) ' (Q35_A_1) 24 Start: 66 End: 66
                newLine.Append(PadString(row(35), 1, Direction.Left, " ")) ' (Q35_A_2) 24 Start: 67 End: 67
                newLine.Append(PadString(row(36), 1, Direction.Left, " ")) ' (Q35_A_3) 24 Start: 68 End: 68
                newLine.Append(PadString(row(37), 1, Direction.Left, " ")) ' (Q35_A_4) 24 Start: 69 End: 69
                newLine.Append(PadString(row(38), 1, Direction.Left, " ")) ' (Q35_A_5) 24 Start: 70 End: 70
                newLine.Append(PadString(row(39), 1, Direction.Left, " ")) ' (Q35_A_6) 24 Start: 71 End: 71
                newLine.Append(PadString(row(40), 1, Direction.Left, " ")) ' (Q35_A_7) 24 Start: 72 End: 72
                newLine.Append(PadString(row(41), 1, Direction.Left, " ")) ' (Q35_A_8) 24 Start: 73 End: 73
                newLine.Append(PadString(row(42), 1, Direction.Left, " ")) ' (Q35_A_9) 24 Start: 74 End: 74
                newLine.Append(PadString(row(43), 1, Direction.Left, " ")) ' (Q35_A_10) 24 Start: 75 End: 75
                newLine.Append(PadString(row(44), 1, Direction.Left, " ")) ' (Q35_A_11) 24 Start: 76 End: 76
                newLine.Append(PadString(row(45), 1, Direction.Left, " ")) ' (Q35_A_12) 24 Start: 77 End: 77
                newLine.Append(PadString(row(46), 1, Direction.Left, " ")) ' (Q59) 25 Start: 78 End: 78
                newLine.Append(PadString(row(47), 1, Direction.Left, " ")) ' (Q36) 25a Start: 79 End: 79
                newLine.Append(PadString(row(48), 1, Direction.Left, " ")) ' (Q74) 26 Start: 80 End: 80
                newLine.Append(PadString(row(49), 1, Direction.Left, " ")) ' (Q38) 26a Start: 81 End: 81
                newLine.Append(PadString(row(50), 1, Direction.Left, " ")) ' (Q65) 27 Start: 82 End: 82
                newLine.Append(PadString(row(51), 15, Direction.Left, " ")) ' (Q16_1) 27a Start: 83 End: 97
                newLine.Append(PadString(row(52), 1, Direction.Left, " ")) ' (Q51) 27b Start: 98 End: 98
                newLine.Append(PadString(row(53), 1, Direction.Left, " ")) ' (Q75) 28 Start: 99 End: 99
                newLine.Append(PadString(row(54), 1, Direction.Left, " ")) ' (Q76) 28a Start: 100 End: 100
                newLine.Append(PadString(row(55), 2, Direction.Left, " ")) ' (Q39_1) 29 Start: 101 End: 102
                newLine.Append(PadString(row(56), 2, Direction.Left, " ")) ' (Q39_2) 29 Start: 103 End: 104
                newLine.Append(PadString(row(57), 1, Direction.Left, " ")) ' (Q40) 30 Start: 105 End: 105
                newLine.Append(PadString(row(58), 1, Direction.Left, " ")) ' (Q52) 31 Start: 106 End: 106
                newLine.Append(PadString(row(59), 1, Direction.Left, " ")) ' (Q41_A_1) 32 Start: 107 End: 107
                newLine.Append(PadString(row(60), 1, Direction.Left, " ")) ' (Q41_A_2) 32 Start: 108 End: 108
                newLine.Append(PadString(row(61), 1, Direction.Left, " ")) ' (Q41_A_3) 32 Start: 109 End: 109
                newLine.Append(PadString(row(62), 1, Direction.Left, " ")) ' (Q41_A_4) 32 Start: 110 End: 110
                newLine.Append(PadString(row(63), 1, Direction.Left, " ")) ' (Q41_A_5) 32 Start: 111 End: 111
                newLine.Append(PadString(row(64), 1, Direction.Left, " ")) ' (Q47) 33 Start: 112 End: 112
                newLine.Append(PadString(row(65), 1, Direction.Left, " ")) ' (Q43) 34 Start: 113 End: 113
                newLine.Append(PadString(row(66), 1, Direction.Left, " ")) ' (Q21) 35 Start: 114 End: 114
                newLine.Append(PadString(row(67), 1, Direction.Left, " ")) ' (Q70) 36 Start: 115 End: 115
                newLine.Append(PadString(row(68), 1, Direction.Left, " ")) ' (Q71) 37 Start: 116 End: 116
                newLine.Append(PadString(row(69), 1, Direction.Left, " ")) ' (Q73) 38 Start: 117 End: 117
                newLine.Append(PadString(row(70), 1, Direction.Left, " ")) ' (Q72) 39 Start: 118 End: 118
                newLine.Append(PadString(row(71), 1, Direction.Left, " ")) ' (Q3_A_1) 40 Start: 119 End: 119
                newLine.Append(PadString(row(72), 1, Direction.Left, " ")) ' (Q3_A_2) 40 Start: 120 End: 120
                newLine.Append(PadString(row(73), 1, Direction.Left, " ")) ' (Q3_A_3) 40 Start: 121 End: 121
                newLine.Append(PadString(row(74), 1, Direction.Left, " ")) ' (Q3_A_4) 40 Start: 122 End: 122
                newLine.Append(PadString(row(75), 1, Direction.Left, " ")) ' (Q3_A_5) 40 Start: 123 End: 123
                newLine.Append(PadString(row(76), 1, Direction.Left, " ")) ' (Q3_A_6) 40 Start: 124 End: 124
                newLine.Append(PadString(row(77), 1, Direction.Left, " ")) ' (Q3_A_7) 40 Start: 125 End: 125
                newLine.Append(PadString(row(78), 1, Direction.Left, " ")) ' (Q3_A_8) 40 Start: 126 End: 126
                newLine.Append(PadString(row(79), 1, Direction.Left, " ")) ' (Q3_A_9) 40 Start: 127 End: 127
                newLine.Append(PadString(row(80), 1, Direction.Left, " ")) ' (Q3_A_10) 40 Start: 128 End: 128
                newLine.Append(PadString(row(81), 1, Direction.Left, " ")) ' (Q3_A_11) 40 Start: 129 End: 129
                newLine.Append(PadString(row(82), 1, Direction.Left, " ")) ' (Q3_A_12) 40 Start: 130 End: 130
                newLine.Append(PadString(row(83), 1, Direction.Left, " ")) ' (Q53) 41 Start: 131 End: 131
                newLine.Append(PadString(row(84), 1, Direction.Left, " ")) ' (Q17) 42 Start: 132 End: 132
                newLine.Append(PadString(row(85), 1, Direction.Left, " ")) ' (Q62) 43 Start: 133 End: 133
                newLine.Append(PadString(row(86), 1, Direction.Left, " ")) ' (Q24) 44 Start: 134 End: 134
                newLine.Append(PadString(row(87), 1, Direction.Left, " ")) ' (Q44_1) 45 Start: 135 End: 135
                newLine.Append(PadString(row(88), 1, Direction.Left, " ")) ' (Q44_2) 45 Start: 136 End: 136
                newLine.Append(PadString(row(89), 1, Direction.Left, " ")) ' (Q44_3) 45 Start: 137 End: 137
                newLine.Append(PadString(row(90), 1, Direction.Left, " ")) ' (Q44_4) 45 Start: 138 End: 138
                newLine.Append(PadString(row(91), 1, Direction.Left, " ")) ' (Q44_5) 45 Start: 139 End: 139
                newLine.Append(PadString(row(92), 1, Direction.Left, " ")) ' (Q44_6) 45 Start: 140 End: 140
                newLine.Append(PadString(row(93), 1, Direction.Left, " ")) ' (Q18) 46 Start: 141 End: 141
                newLine.Append(PadString(row(94), 1, Direction.Left, " ")) ' (Q42) 47 Start: 142 End: 142
                newLine.Append(PadString(row(95), 1, Direction.Left, " ")) ' (Q19) 48 Start: 143 End: 143
                newLine.Append(PadString(row(96), 1, Direction.Left, " ")) ' (Q25) 49 Start: 144 End: 144
                newLine.Append(PadString(row(97), 1, Direction.Left, " ")) ' (Q6) 50 Start: 145 End: 145
                newLine.Append(PadString(row(98), 1, Direction.Left, " ")) ' (Q60_A_1) 51 Start: 146 End: 146
                newLine.Append(PadString(row(99), 1, Direction.Left, " ")) ' (Q60_A_2) 51 Start: 147 End: 147
                newLine.Append(PadString(row(100), 1, Direction.Left, " ")) ' (Q48) 52 Start: 148 End: 148
                newLine.Append(PadString(row(101), 1, Direction.Left, " ")) ' (Q49) 53 Start: 149 End: 149
                newLine.Append(PadString(row(102), 1, Direction.Left, " ")) ' (Q46) 54 Start: 150 End: 150
                newLine.Append(PadString(row(103), 1, Direction.Left, " ")) ' (Q50) 55 Start: 151 End: 151
                newLine.Append(PadString(row(104), 1, Direction.Left, " ")) ' (Q26_1) 56 Start: 152 End: 152
                newLine.Append(PadString(row(105), 1, Direction.Left, " ")) ' (Q26_2) 56 Start: 153 End: 153
                newLine.Append(PadString(row(106), 1, Direction.Left, " ")) ' (Q26_3) 56 Start: 154 End: 154
                newLine.Append(PadString(row(107), 1, Direction.Left, " ")) ' (Q56) 57 Start: 155 End: 155
                newLine.Append(PadString(row(108), 1, Direction.Left, " ")) ' (Q28) 58 Start: 156 End: 156
                newLine.Append(PadString(row(109), 1, Direction.Left, " ")) ' (Q32) 59 Start: 157 End: 157
                newLine.Append(PadString(row(110), 1, Direction.Left, " ")) ' (Q54) 60 Start: 158 End: 158
                newLine.Append(PadString(row(111), 30, Direction.Left, " ")) ' (Q57_1) 61 Start: 159 End: 188
                newLine.Append(PadString(row(112), 15, Direction.Left, " ")) ' (Q57_2) 61 Start: 189 End: 203
                newLine.Append(PadString(row(113), 10, Direction.Left, " ")) ' (Q57_3) 61 Start: 204 End: 213
                newLine.Append(PadString(row(114), 30, Direction.Left, " ")) ' (Q61_1) 62 Start: 214 End: 243
                newLine.Append(PadString(row(115), 10, Direction.Left, " ")) ' (Q61_2) 62 Start: 244 End: 253
                newLine.Append(PadString(row(116), 1000, Direction.Left, " ")) ' (Q63) 63 Start: 254 End: 1253

                writer.WriteLine(newLine.ToString)
            Next
            MessageBox.Show("Proccess Complete")
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not writer Is Nothing Then
                writer.Close()
            End If
        End Try
    End Sub

    Private Function PadString(ByVal value As Object, ByVal length As Integer, ByVal padDir As Direction, ByVal fillChar As String, Optional ByVal truncateNonNumeric As Boolean = False) As String
        Dim retVal As String = "'"
        If IsDBNull(value) Then
            retVal = ""
        Else
            retVal = Trim(CStr(value))
        End If
        If truncateNonNumeric Then
            Dim newVal As String = String.Empty
            For Each c As Char In retVal.ToCharArray
                If IsNumeric(c) Then
                    newVal += c
                Else
                    Exit For
                End If
            Next
            retVal = newVal
        End If
        If retVal.Length > length Then
            Return retVal.Substring(0, length)
        End If
        If retVal.Length < length Then
            Dim tempString As String = ""
            For i As Integer = 1 To (length - retVal.Length)
                tempString += fillChar
            Next
            If padDir = Direction.Left Then
                Return (retVal & tempString)
            Else
                Return (tempString & retVal)
            End If

        Else
            Return retVal
        End If
    End Function

    Private Function GetImportTable() As System.Data.DataTable
        Dim path As String = Me.txtOriginalFile.Text.Substring(0, Me.txtOriginalFile.Text.LastIndexOf("\"c))
        Dim headerVal As String
        Dim fileName As String = Me.txtOriginalFile.Text.Substring(Me.txtOriginalFile.Text.LastIndexOf("\"c) + 1)

        Dim ds As New DataSet
        headerVal = "Yes"
        'Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
        '    path & ";Extended Properties=""Text;HDR=" & headerVal & ";FMT=Delimited"""

        Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
            path & ";Extended Properties=""Text;HDR=" & headerVal & ";FMT=Delimited"""


        Dim conn As New OleDb.OleDbConnection(connStr)
        Dim da As New OleDb.OleDbDataAdapter("Select * from " & "[" & fileName & "]", conn)
        da.Fill(ds, "WebFileConvert")
        Return ds.Tables(0)
    End Function
#End Region





End Class
