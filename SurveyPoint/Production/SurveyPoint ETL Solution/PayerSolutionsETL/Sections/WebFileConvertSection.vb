Imports System.Text
Imports System.IO
Imports System.Data

Public Class WebFileConvertSection

#Region " Enums "

    Enum ExcelColumns
        [B] = 1
        [C] = 2
        [D] = 3
        [E] = 4
        [F] = 5
        [G] = 6
        [H] = 7
        [I] = 8
        [J] = 9
        [K] = 10
        [L] = 11
        [M] = 12
        [N] = 13
        [O] = 14
        [P] = 15
        [Q] = 16
        [R] = 17
        [S] = 18
        [T] = 19
        [U] = 20
        [V] = 21
        [W] = 22
        [X] = 23
        [Y] = 24
        [Z] = 25
        [AA] = 26
        [AB] = 27
        [AC] = 28
        [AD] = 29
        [AE] = 30
        [AF] = 31
        [AG] = 32
        [AH] = 33
        [AI] = 34
        [AJ] = 35
        [AK] = 36
        [AL] = 37
        [AM] = 38
        [AN] = 39
        [AO] = 40
        [AP] = 41
        [AQ] = 42
        [AR] = 43
        [AS] = 44
        [AT] = 45
        [AU] = 46
        [AV] = 47
        [AW] = 48
        [AX] = 49
        [AY] = 50
        [AZ] = 51
        [BA] = 52
        [BB] = 53
        [BC] = 54
        [BD] = 55
        [BE] = 56
        [BF] = 57
        [BG] = 58
        [BH] = 59
        [BI] = 60
        [BJ] = 61
        [BK] = 62
        [BL] = 63
        [BM] = 64
        [BN] = 65
        [BO] = 66
        [BP] = 67
        [BQ] = 68
        [BR] = 69
        [BS] = 70
        [BT] = 71
        [BU] = 72
        [BV] = 73
        [BW] = 74
        [BX] = 75
        [BY] = 76
        [BZ] = 77
        [CA] = 78
        [CB] = 79
        [CC] = 80
        [CD] = 81
        [CE] = 82
        [CF] = 83
        [CG] = 84
        [CH] = 85
        [CI] = 86
        [CJ] = 87
        [CK] = 88
        [CL] = 89
        [CM] = 90
        [CN] = 91
        [CO] = 92
        [CP] = 93
        [CQ] = 94
        [CR] = 95
        [CS] = 96
        [CT] = 97
        [CU] = 98
        [CV] = 99
        [CW] = 100
        [CX] = 101
        [CY] = 102
        [CZ] = 103
        [DA] = 104
        [DB] = 105
        [DC] = 106
        [DD] = 107
        [DE] = 108
        [DF] = 109
        [DG] = 110
        [DH] = 111
        [DI] = 112
        [DJ] = 113
        [DK] = 114
        [DL] = 115
        [DM] = 116
        [DN] = 117
        [DO] = 118
        [DP] = 119
        [DQ] = 120
        [DR] = 121
        [DS] = 122
        [DT] = 123
        [DU] = 124
        [DV] = 125
        [DW] = 126
        [DX] = 127
        [DY] = 128
        [DZ] = 129
        [EA] = 130
        [EB] = 131
        [EC] = 132
        [ED] = 133
        [EE] = 134
        [EF] = 135
        [EG] = 136
        [EH] = 137
        [EI] = 138
        [EJ] = 139
        [EK] = 140
        [EL] = 141
        [EM] = 142
        [EN] = 143
        [EO] = 144
        [EP] = 145
        [EQ] = 146
        [ER] = 147
        [ES] = 148
        [ET] = 149
        [EU] = 150
        [EV] = 151
        [EW] = 152
        [EX] = 153
        [EY] = 154
        [EZ] = 155
        [FA] = 156
        [FB] = 157
        [FC] = 158
        [FD] = 159
        [FE] = 160
        [FF] = 161
        [FG] = 162
        [FH] = 163
        [FI] = 164
        [FJ] = 165
        [FK] = 166
        [FL] = 167
        [FM] = 168
        [FN] = 169
        [FO] = 170
        [FP] = 171
        [FQ] = 172
        [FR] = 173
        [FS] = 174
        [FT] = 175
        [FU] = 176
        [FV] = 177
        [FW] = 178
        [FX] = 179
        [FY] = 180
        [FZ] = 181
        [GA] = 182
        [GB] = 183
        [GC] = 184
        [GD] = 185
        [GE] = 186
        [GF] = 187
        [GG] = 188
        [GH] = 189
        [GI] = 190
        [GJ] = 191
        [GK] = 192
        [GL] = 193
        [GM] = 194
        [GN] = 195
        [GO] = 196
        [GP] = 197
        [GQ] = 198
        [GR] = 199
        [GS] = 200
        [GT] = 201
        [GU] = 202
        [GV] = 203
        [GW] = 204
        [GX] = 205
        [GY] = 206
        [GZ] = 207
        [HA] = 208
        [HB] = 209
        [HC] = 210
        [HD] = 211
        [HE] = 212
        [HF] = 213
        [HG] = 214
        [HH] = 215
        [HI] = 216
        [HJ] = 217
        [HK] = 218
        [HL] = 219
        [HM] = 220
        [HN] = 221
        [HO] = 222
        [HP] = 223
        [HQ] = 224
        [HR] = 225
        [HS] = 226
        [HT] = 227
        [HU] = 228
        [HV] = 229
        [HW] = 230
        [HX] = 231
        [HY] = 232
        [HZ] = 233
        [IA] = 234
        [IB] = 235
        [IC] = 236
        [ID] = 237
        [IE] = 238
        [IF] = 239
        [IG] = 240
        [IH] = 241
        [II] = 242
        [IJ] = 243
        [IK] = 244
        [IL] = 245
        [IM] = 246
        [IN] = 247
        [IO] = 248
        [IP] = 249
        [IQ] = 250
        [IR] = 251
        [IS] = 252
        [IT] = 253
        [IU] = 254
        [IV] = 255
        [IW] = 256
        [IX] = 257
        [IY] = 258
        [IZ] = 259
        [JA] = 260
        [JB] = 261
        [JC] = 262
        [JD] = 263
        [JE] = 264
        [JF] = 265
        [JG] = 266
        [JH] = 267
        [JI] = 268
        [JJ] = 269
        [JK] = 270
        [JL] = 271
        [JM] = 272
        [JN] = 273
        [JO] = 274
        [JP] = 275
        [JQ] = 276
        [JR] = 277
        [JS] = 278
        [JT] = 279
        [JU] = 280
        [JV] = 281
        [JW] = 282
        [JX] = 283
        [JY] = 284
        [JZ] = 285
        [KA] = 286
        [KB] = 287
        [KC] = 288
        [KD] = 289
        [KE] = 290
        [KF] = 291
        [KG] = 292
        [KH] = 293
        [KI] = 294
        [KJ] = 295
        [KK] = 296
        [KL] = 297
        [KM] = 298
        [KN] = 299
        [KO] = 300
        [KP] = 301
        [KQ] = 302
        [KR] = 303
        [KS] = 304
        [KT] = 305
        [KU] = 306
        [KV] = 307
        [KW] = 308
        [KX] = 309
        [KY] = 310
        [KZ] = 311
        [LA] = 312
        [LB] = 313
        [LC] = 314
        [LD] = 315
        [LE] = 316
        [LF] = 317
        [LG] = 318
        [LH] = 319
        [LI] = 320
        [LJ] = 321
        [LK] = 322
        [LL] = 323
        [LM] = 324
        [LN] = 325
        [LO] = 326
        [LP] = 327
        [LQ] = 328
        [LR] = 329
        [LS] = 330
        [LT] = 331
        [LU] = 332
        [LV] = 333
        [LW] = 334
        [LX] = 335
        [LY] = 336
        [LZ] = 337
        [MA] = 338
        [MB] = 339
        [MC] = 340
        [MD] = 341
        [ME] = 342
        [MF] = 343
        [MG] = 344
        [MH] = 345
        [MI] = 346
        [MJ] = 347
        [MK] = 348
        [ML] = 349
        [MM] = 350
        [MN] = 351
        [MO] = 352
        [MP] = 353
        [MQ] = 354
        [MR] = 355
        [MS] = 356
        [MT] = 357
        [MU] = 358
        [MV] = 359
        [MW] = 360
        [MX] = 361
        [MY] = 362
        [MZ] = 363
        [NA] = 364
        [NB] = 365
        [NC] = 366
        [ND] = 367
        [NE] = 368
        [NF] = 369
        [NG] = 370
        [NH] = 371
        [NI] = 372
        [NJ] = 373
        [NK] = 374
        [NL] = 375
        [NM] = 376
        [NN] = 377
        [NO] = 378
        [NP] = 379
        [NQ] = 380
        [NR] = 381
        [NS] = 382
        [NT] = 383
        [NU] = 384
        [NV] = 385
        [NW] = 386
        [NX] = 387
        [NY] = 388
        [NZ] = 389
        [OA] = 390
        [OB] = 391
        [OC] = 392
        [OD] = 393
        [OE] = 394
        [OF] = 395
        [OG] = 396
        [OH] = 397
        [OI] = 398
        [OJ] = 399
        [OK] = 400
        [OL] = 401
        [OM] = 402
        [ON] = 403
        [OO] = 404
        [OP] = 405
        [OQ] = 406
        [OR] = 407
        [OS] = 408
        [OT] = 409
        [OU] = 410
        [OV] = 411
        [OW] = 412
        [OX] = 413
        [OY] = 414
        [OZ] = 415
        [PA] = 416
        [PB] = 417
        [PC] = 418
        [PD] = 419
        [PE] = 420
        [PF] = 421
        [PG] = 422
        [PH] = 423
        [PI] = 424
        [PJ] = 425
        [PK] = 426
        [PL] = 427
        [PM] = 428
        [PN] = 429
        [PO] = 430
        [PP] = 431
        [PQ] = 432
        [PR] = 433
        [PS] = 434
        [PT] = 435
        [PU] = 436
        [PV] = 437
        [PW] = 438
        [PX] = 439
        [PY] = 440
        [PZ] = 441
        [QA] = 442
        [QB] = 443
        [QC] = 444
        [QD] = 445
        [QE] = 446
        [QF] = 447
        [QG] = 448
        [QH] = 449
        [QI] = 450
        [QJ] = 451
        [QK] = 452
        [QL] = 453
        [QM] = 454
        [QN] = 455
        [QO] = 456
        [QP] = 457
        [QQ] = 458
        [QR] = 459
        [QS] = 460
        [QT] = 461
        [QU] = 462
        [QV] = 463
        [QW] = 464
        [QX] = 465
        [QY] = 466
        [QZ] = 467
        [RA] = 468
        [RB] = 469
        [RC] = 470
        [RD] = 471
        [RE] = 472
        [RF] = 473
        [RG] = 474
        [RH] = 475
        [RI] = 476
        [RJ] = 477
        [RK] = 478
        [RL] = 479
        [RM] = 480
        [RN] = 481
        [RO] = 482
        [RP] = 483
        [RQ] = 484
        [RR] = 485
        [RS] = 486
        [RT] = 487
        [RU] = 488
        [RV] = 489
        [RW] = 490
        [RX] = 491
        [RY] = 492
        [RZ] = 493
        [SA] = 494
        [SB] = 495
        [SC] = 496
        [SD] = 497
        [SE] = 498
        [SF] = 499
        [SG] = 500
        [SH] = 501
        [SI] = 502
        [SJ] = 503
        [SK] = 504
        [SL] = 505
        [SM] = 506
        [SN] = 507
        [SO] = 508
        [SP] = 509
        [SQ] = 510
        [SR] = 511
        [SS] = 512
        [ST] = 513
        [SU] = 514
        [SV] = 515
        [SW] = 516
        [SX] = 517
        [SY] = 518
        [SZ] = 519
        [TA] = 520
        [TB] = 521
        [TC] = 522
        [TD] = 523
        [TE] = 524
        [TF] = 525
        [TG] = 526
        [TH] = 527
        [TI] = 528
        [TJ] = 529
        [TK] = 530
        [TL] = 531
        [TM] = 532
        [TN] = 533
        [TO] = 534
        [TP] = 535
        [TQ] = 536
        [TR] = 537
        [TS] = 538
        [TT] = 539
        [TU] = 540
        [TV] = 541
        [TW] = 542
        [TX] = 543
        [TY] = 544
        [TZ] = 545

    End Enum

#End Region

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
        Try
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
            ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "AZ BLUE" Then
                ConvertAZBlue()
            ElseIf CStr(cboFileType.SelectedItem).ToUpper() = "EXCELLUS UPDATE 2016" Then
                ConvertExcellusUpdate2016()
            End If
        Catch ex As Exception
            Throw ex
        End Try

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
                newLine.Append(PadString(row(134), 5, Direction.Right, "0")) ' Key 3 Start: 19 End: 23
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

    Private Sub ConvertAZBlue()
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


                newLine.Append(PadString("", 1, Direction.Left, " ")) ' (Q2_1) USER ID (Blank) Start: 1 End: 1 Length: 1
                newLine.Append(PadString(Convert.ToDateTime(row(ExcelColumns.CW).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " "))  ' Last Modified Start: 2 End: 9 Length: 8
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' Blank Start: 10 End: 10 Length: 1
                newLine.Append(PadString(row(ExcelColumns.C), 8, Direction.Left, " ")) ' (Q7_1) FAQSS Template ID Start: 11 End: 18 Length: 8
                newLine.Append(PadString(row(ExcelColumns.DG), 5, Direction.Left, " ")) ' Key 3 Start: 19 End: 23 Length: 5
                newLine.Append(PadString(row(ExcelColumns.DF), 8, Direction.Left, " ")) ' Key 2 Start: 24 End: 31 Length: 8
                newLine.Append(PadString("", 3, Direction.Left, " ")) ' Blank Start: 32 End: 34 Length: 3
                newLine.Append(PadString(row(ExcelColumns.D), 1, Direction.Left, " ")) ' (Q1) 1 Start: 35 End: 35 Length: 1
                newLine.Append(PadString(row(ExcelColumns.E), 1, Direction.Left, " ")) ' (Q66) 2 Start: 36 End: 36 Length: 1
                newLine.Append(PadString(row(ExcelColumns.F), 1, Direction.Left, " ")) ' (Q15) 2a Start: 37 End: 37 Length: 1
                newLine.Append(PadString(row(ExcelColumns.G), 1, Direction.Left, " ")) ' (Q29) 2b Start: 38 End: 38 Length: 1
                newLine.Append(PadString(row(ExcelColumns.H), 1, Direction.Left, " ")) ' (Q55) 3 Start: 39 End: 39 Length: 1
                newLine.Append(PadString(row(ExcelColumns.I), 1, Direction.Left, " ")) ' (Q37) 4 Start: 40 End: 40 Length: 1
                newLine.Append(PadString(row(ExcelColumns.J), 1, Direction.Left, " ")) ' (Q30_A_1) 5 Start: 41 End: 41 Length: 1
                newLine.Append(PadString(row(ExcelColumns.K), 1, Direction.Left, " ")) ' (Q30_A_2) 5 Start: 42 End: 42 Length: 1
                newLine.Append(PadString(row(ExcelColumns.L), 1, Direction.Left, " ")) ' (Q30_A_3) 5 Start: 43 End: 43 Length: 1
                newLine.Append(PadString(row(ExcelColumns.M), 1, Direction.Left, " ")) ' (Q30_A_4) 5 Start: 44 End: 44 Length: 1
                newLine.Append(PadString(row(ExcelColumns.N), 1, Direction.Left, " ")) ' (Q10) 6 Start: 45 End: 45 Length: 1
                newLine.Append(PadString(row(ExcelColumns.O), 1, Direction.Left, " ")) ' (Q45) 7 Start: 46 End: 46 Length: 1
                newLine.Append(PadString(row(ExcelColumns.P), 1, Direction.Left, " ")) ' (Q58) 8 Start: 47 End: 47 Length: 1
                newLine.Append(PadString(row(ExcelColumns.Q), 1, Direction.Left, " ")) ' (Q35_A_1) 9 Start: 48 End: 48 Length: 1
                newLine.Append(PadString(row(ExcelColumns.R), 1, Direction.Left, " ")) ' (Q35_A_2) 9 Start: 49 End: 49 Length: 1
                newLine.Append(PadString(row(ExcelColumns.S), 1, Direction.Left, " ")) ' (Q35_A_3) 9 Start: 50 End: 50 Length: 1
                newLine.Append(PadString(row(ExcelColumns.T), 1, Direction.Left, " ")) ' (Q35_A_4) 9 Start: 51 End: 51 Length: 1
                newLine.Append(PadString(row(ExcelColumns.U), 1, Direction.Left, " ")) ' (Q35_A_5) 9 Start: 52 End: 52 Length: 1
                newLine.Append(PadString(row(ExcelColumns.V), 1, Direction.Left, " ")) ' (Q35_A_6) 9 Start: 53 End: 53 Length: 1
                newLine.Append(PadString(row(ExcelColumns.W), 1, Direction.Left, " ")) ' (Q35_A_7) 9 Start: 54 End: 54 Length: 1
                newLine.Append(PadString(row(ExcelColumns.X), 1, Direction.Left, " ")) ' (Q35_A_8) 9 Start: 55 End: 55 Length: 1
                newLine.Append(PadString(row(ExcelColumns.Y), 1, Direction.Left, " ")) ' (Q35_A_9) 9 Start: 56 End: 56 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AA), 1, Direction.Left, " ")) ' (Q35_A_10) 9 Start: 57 End: 57 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AB), 1, Direction.Left, " ")) ' (Q35_A_11) 9 Start: 58 End: 58 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AC), 1, Direction.Left, " ")) ' (Q35_A_12) 9 Start: 59 End: 59 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AD), 1, Direction.Left, " ")) ' (Q59) 10 Start: 60 End: 60 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AE), 1, Direction.Left, " ")) ' (Q36) 11 Start: 61 End: 61 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AF), 1, Direction.Left, " ")) ' (Q74) 11 Start: 62 End: 62 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AG), 1, Direction.Left, " ")) ' (Q38) 11a Start: 63 End: 63 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AH), 1, Direction.Left, " ")) ' (Q65) 12 Start: 64 End: 64 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AI), 15, Direction.Left, " ")) ' (Q16_1) 12a Start: 65 End: 79 Length: 15
                newLine.Append(PadString(row(ExcelColumns.AJ), 1, Direction.Left, " ")) ' (Q51) 12b Start: 80 End: 80 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AK), 1, Direction.Left, " ")) ' (Q75) 13 Start: 81 End: 81 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AL), 1, Direction.Left, " ")) ' (Q76) 13a Start: 82 End: 82 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AM), 2, Direction.Left, " ")) ' (Q39_1) 14 Start: 83 End: 84 Length: 2
                newLine.Append(PadString(row(ExcelColumns.AN), 2, Direction.Left, " ")) ' (Q39_2) 14 Start: 85 End: 86 Length: 2
                newLine.Append(PadString(row(ExcelColumns.AO), 1, Direction.Left, " ")) ' (Q40) 15 Start: 87 End: 87 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AP), 1, Direction.Left, " ")) ' (Q52) 16 Start: 88 End: 88 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AQ), 1, Direction.Left, " ")) ' (Q41_A_1) 17 Start: 89 End: 89 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AR), 1, Direction.Left, " ")) ' (Q41_A_2) 17 Start: 90 End: 90 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AS), 1, Direction.Left, " ")) ' (Q41_A_3) 17 Start: 91 End: 91 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AT), 1, Direction.Left, " ")) ' (Q41_A_4) 17 Start: 92 End: 92 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AU), 1, Direction.Left, " ")) ' (Q41_A_5) 17 Start: 93 End: 93 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AV), 1, Direction.Left, " ")) ' (Q47) 18 Start: 94 End: 94 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AW), 1, Direction.Left, " ")) ' (Q43) 19 Start: 95 End: 95 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AX), 1, Direction.Left, " ")) ' (Q21) 20 Start: 96 End: 96 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AY), 1, Direction.Left, " ")) ' (Q70) 21 Start: 97 End: 97 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AZ), 1, Direction.Left, " ")) ' (Q71) 22 Start: 98 End: 98 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BA), 1, Direction.Left, " ")) ' (Q73) 23 Start: 99 End: 99 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BB), 1, Direction.Left, " ")) ' (Q3_A_1) 24 Start: 100 End: 100 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BC), 1, Direction.Left, " ")) ' (Q3_A_2) 24 Start: 101 End: 101 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BD), 1, Direction.Left, " ")) ' (Q3_A_3) 24 Start: 102 End: 102 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BE), 1, Direction.Left, " ")) ' (Q3_A_4) 24 Start: 103 End: 103 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BF), 1, Direction.Left, " ")) ' (Q3_A_5) 24 Start: 104 End: 104 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BG), 1, Direction.Left, " ")) ' (Q3_A_6) 24 Start: 105 End: 105 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BH), 1, Direction.Left, " ")) ' (Q3_A_7) 24 Start: 106 End: 106 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BI), 1, Direction.Left, " ")) ' (Q3_A_8) 24 Start: 107 End: 107 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BJ), 1, Direction.Left, " ")) ' (Q3_A_9) 24 Start: 108 End: 108 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BK), 1, Direction.Left, " ")) ' (Q3_A_10) 24 Start: 109 End: 109 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BL), 1, Direction.Left, " ")) ' (Q3_A_11) 24 Start: 110 End: 110 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BM), 1, Direction.Left, " ")) ' (Q3_A_12) 24 Start: 111 End: 111 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BN), 1, Direction.Left, " ")) ' (Q17) 25 Start: 112 End: 112 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BO), 1, Direction.Left, " ")) ' (Q62) 26 Start: 113 End: 113 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BP), 1, Direction.Left, " ")) ' (Q24) 27 Start: 114 End: 114 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BQ), 1, Direction.Left, " ")) ' (Q44_1) 28 Start: 115 End: 115 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BR), 1, Direction.Left, " ")) ' (Q44_2) 28 Start: 116 End: 116 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BS), 1, Direction.Left, " ")) ' (Q44_3) 28 Start: 117 End: 117 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BT), 1, Direction.Left, " ")) ' (Q44_4) 28 Start: 118 End: 118 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BU), 1, Direction.Left, " ")) ' (Q44_5) 28 Start: 119 End: 119 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BV), 1, Direction.Left, " ")) ' (Q44_6) 28 Start: 120 End: 120 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BW), 1, Direction.Left, " ")) ' (Q18) 29 Start: 121 End: 121 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BX), 1, Direction.Left, " ")) ' (Q42) 30 Start: 122 End: 122 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BY), 1, Direction.Left, " ")) ' (Q19) 31 Start: 123 End: 123 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BZ), 1, Direction.Left, " ")) ' (Q25) 32 Start: 124 End: 124 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CA), 1, Direction.Left, " ")) ' In the last 12 months, have you been offered Hospice or Palliative care? Start: 125 End: 125 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CB), 1, Direction.Left, " ")) ' (Q6) 33 Start: 126 End: 126 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CC), 1, Direction.Left, " ")) ' (Q60_A_1) 34 Start: 127 End: 127 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CD), 1, Direction.Left, " ")) ' (Q60_A_2) 34 Start: 128 End: 128 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CE), 1, Direction.Left, " ")) ' (Q48) 35 Start: 129 End: 129 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CF), 1, Direction.Left, " ")) ' (Q49) 36 Start: 130 End: 130 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CG), 1, Direction.Left, " ")) ' (Q32) 37 Start: 131 End: 131 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CH), 1, Direction.Left, " ")) ' (Q54) 38 Start: 132 End: 132 Length: 1
                newLine.Append(PadString(row(ExcelColumns.CI), 30, Direction.Left, " ")) ' (Q57_1) 39 Start: 133 End: 162 Length: 30
                newLine.Append(PadString(row(ExcelColumns.CJ), 15, Direction.Left, " ")) ' (Q57_2) 39 Start: 163 End: 177 Length: 15
                newLine.Append(PadString(row(ExcelColumns.CK), 10, Direction.Left, " ")) ' (Q57_3) 39 Start: 178 End: 187 Length: 10
                newLine.Append(PadString(row(ExcelColumns.CL), 30, Direction.Left, " ")) ' (Q61_1) 40 Start: 188 End: 217 Length: 30
                newLine.Append(PadString(row(ExcelColumns.CM), 10, Direction.Left, " ")) ' (Q61_2) 40 Start: 218 End: 227 Length: 10
                newLine.Append(PadString(row(ExcelColumns.CN), 1000, Direction.Left, " ")) ' (Q63) 41 Start: 228 End: 1227 Length: 1000
                newLine.Append(PadString(row(ExcelColumns.CO), 2, Direction.Left, " ")) ' Who is completing the health assessment (web only) Start: 1228 End: 1229 Length: 2
                newLine.Append(PadString(row(ExcelColumns.CP), 30, Direction.Left, " ")) ' Please provide your name (optional & web only; open answer) Start: 1229 End: 1258 Length: 30


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


    Private Sub ConvertExcellusUpdate2016()
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
                newLine.Append(PadString(Convert.ToDateTime(row(ExcelColumns.BR).ToString()).ToString("yyyyMMdd"), 8, Direction.Left, " "))  'Last Modified --> Start: 2 End: 9 Length: 8
                newLine.Append(PadString("", 1, Direction.Left, " "))       ' 10: BLANK(1)
                newLine.Append(PadString(row(ExcelColumns.L), 8, Direction.Left, " ")) ' (Q45_1) FAQs --> Start: 11 End: 18 Length: 8
                newLine.Append(PadString(row(ExcelColumns.M), 5, Direction.Right, "0")) ' (Q112_1) TEMPLATEDID --> Start: 19 End: 23 Length: 5
                newLine.Append(PadString(row(ExcelColumns.N), 8, Direction.Right, "0")) ' (Q113_1) RespondentID --> Start: 24 End: 31 Length: 8
                newLine.Append(PadString("", 3, Direction.Left, " "))       ' 32-34: BLANK(3)
                newLine.Append(PadString(row(ExcelColumns.T), 1, Direction.Left, " ")) ' (Q1) Rate health --> Start: 35 End: 35 Length: 1
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' Blank --> Start: 36 End: 36 Length: 1
                newLine.Append(PadString(row(ExcelColumns.V), 1, Direction.Left, " ")) ' (Q4) Overnight in the last 12 mo --> Start: 37 End: 37 Length: 1
                newLine.Append(PadString(row(ExcelColumns.U), 1, Direction.Left, " ")) ' (Q57) Rate Mental Health  --> Start: 38 End: 38 Length: 1
                newLine.Append(PadString(row(ExcelColumns.X), 1, Direction.Left, " ")) ' (Q18) Doctor Visits --> Start: 39 End: 39 Length: 1
                newLine.Append(PadString(row(ExcelColumns.Y), 1, Direction.Left, " ")) ' (Q9) Diabetes --> Start: 40 End: 40 Length: 1
                newLine.Append(PadString(row(ExcelColumns.Z), 1, Direction.Left, " ")) ' (Q19_A_1) Heart Health --> Start: 41 End: 41 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AA), 1, Direction.Left, " ")) ' (Q19_A_2) Heart Health --> Start: 42 End: 42 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AB), 1, Direction.Left, " ")) ' (Q19_A_3) Heart Health --> Start: 43 End: 43 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AC), 1, Direction.Left, " ")) ' (Q19_A_4) Heart Health --> Start: 44 End: 44 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AD), 1, Direction.Left, " ")) ' (Q10) Currently being treated for heart problems --> Start: 45 End: 45 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AE), 1, Direction.Left, " ")) ' (Q15) Neighbor --> Start: 46 End: 46 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AF), 1, Direction.Left, " ")) ' (Q29) Help bathe --> Start: 47 End: 47 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AG), 1, Direction.Left, " ")) ' (Q31) Help taking Meds --> Start: 48 End: 48 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AH), 1, Direction.Left, " ")) ' (Q55) Health Interfere Daily  --> Start: 49 End: 49 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AI), 1, Direction.Left, " ")) ' (Q58) Trouble with Doctor and Shopping  --> Start: 50 End: 50 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AJ), 1, Direction.Left, " ")) ' (Q34) Help with Doctor and Shopping  --> Start: 51 End: 51 Length: 1
                newLine.Append(PadString("", 5, Direction.Left, " ")) ' Blank --> Start: 52 End: 56 Length: 5
                newLine.Append(PadString(row(ExcelColumns.AP), 1, Direction.Left, " ")) ' (Q25_A_1) 2 --> Start: 57 End: 57 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AQ), 1, Direction.Left, " ")) ' (Q25_A_2) 2 --> Start: 58 End: 58 Length: 1
                newLine.Append(PadString("", 47, Direction.Left, " ")) ' Blank --> Start: 59 End: 105 Length: 47
                newLine.Append(PadString(row(ExcelColumns.AT), 1, Direction.Left, " ")) ' (Q35_A_1) Currently being treated for --> Start: 106 End: 106 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AU), 1, Direction.Left, " ")) ' (Q35_A_2) Currently being treated for --> Start: 107 End: 107 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AV), 1, Direction.Left, " ")) ' (Q35_A_3) Currently being treated for --> Start: 108 End: 108 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AW), 1, Direction.Left, " ")) ' (Q35_A_4) Currently being treated for --> Start: 109 End: 109 Length: 1
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' Blank --> Start: 110 End: 110 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AY), 1, Direction.Left, " ")) ' (Q35_A_6) Currently being treated for --> Start: 111 End: 111 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AZ), 1, Direction.Left, " ")) ' (Q35_A_7) Currently being treated for --> Start: 112 End: 112 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BA), 1, Direction.Left, " ")) ' (Q35_A_8) Currently being treated for --> Start: 113 End: 113 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BB), 1, Direction.Left, " ")) ' (Q35_A_9) Currently being treated for --> Start: 114 End: 114 Length: 1
                newLine.Append(PadString("", 1, Direction.Left, " ")) ' Blank --> Start: 115 End: 115 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BC), 1, Direction.Left, " ")) ' (Q36) Other health conditions --> Start: 116 End: 116 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BD), 30, Direction.Left, " ")) ' (Q38) Describe other health conditions --> Start: 117 End: 146 Length: 30
                newLine.Append(PadString("", 36, Direction.Left, " ")) ' Blank --> Start: 145 End: 182 Length: 38
                newLine.Append(PadString(row(ExcelColumns.AK), 1, Direction.Left, " ")) ' (Q16) Exercise --> Start: 183 End: 183 Length: 1
                newLine.Append(PadString("", 2, Direction.Left, " ")) ' Blank --> Start: 184 End: 185 Length: 2
                newLine.Append(PadString(row(ExcelColumns.AL), 1, Direction.Left, " ")) ' (Q11) Fallen in past 12 months --> Start: 186 End: 186 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AM), 1, Direction.Left, " ")) ' (Q33) BMD Test  --> Start: 187 End: 187 Length: 1
                newLine.Append(PadString(row(ExcelColumns.AN), 1, Direction.Left, " ")) ' (Q59) Hip Fracture  --> Start: 188 End: 188 Length: 1
                newLine.Append(PadString("", 125, Direction.Left, " ")) ' Blank --> Start: 189 End: 313 Length: 125
                newLine.Append(PadString(row(ExcelColumns.BE), 1, Direction.Left, " ")) ' (Q26) Advance directives --> Start: 314 End: 314 Length: 1
                newLine.Append(PadString("", 3, Direction.Left, " ")) ' Blank --> Start: 315 End: 317 Length: 3
                newLine.Append(PadString(row(ExcelColumns.BG), 1, Direction.Left, " ")) ' (Q6) MOLST --> Start: 318 End: 318 Length: 1
                newLine.Append(PadString(row(ExcelColumns.BH), 1, Direction.Left, " ")) ' (Q17) Help with Questionnaire --> Start: 319 End: 319 Length: 1
                newLine.Append(PadString("", 5, Direction.Left, " ")) ' Blank --> Start: 320 End: 324 Length: 5
                newLine.Append(PadString(row(ExcelColumns.BI), 30, Direction.Left, " ")) ' (Q61_1) who helped fill out the form --> Start: 325 End: 354 Length: 30
                newLine.Append(PadString(row(ExcelColumns.BJ), 15, Direction.Left, " ")) ' (Q61_2)  who helped fill out the form --> Start: 355 End: 369 Length: 15
                newLine.Append(PadString(row(ExcelColumns.BK), 13, Direction.Left, " ")) ' (Q61_3) who helped fill out the form --> Start: 370 End: 379 Length: 10



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

        ' When running this from Visual Studio, if you get the error "The 'Microsoft.Jet.OLEDB.4.0' provider is not registered on the local machine." 
        ' make sure the Development environment is selected as the configuration.

        ' Before committing changes and pushing to GIT, change the environment configuration back to production.


        Dim path As String = Me.txtOriginalFile.Text.Substring(0, Me.txtOriginalFile.Text.LastIndexOf("\"c))
        Dim headerVal As String
        Dim fileName As String = Me.txtOriginalFile.Text.Substring(Me.txtOriginalFile.Text.LastIndexOf("\"c) + 1)

        Dim ds As New DataSet
        headerVal = "Yes"

        Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
            path & ";Extended Properties=""Text;HDR=" & headerVal & ";FMT=Delimited"""


        Dim conn As New OleDb.OleDbConnection(connStr)
        Dim da As New OleDb.OleDbDataAdapter("Select * from " & "[" & fileName & "]", conn)
        da.Fill(ds, "WebFileConvert")
        Return ds.Tables(0)
    End Function
#End Region





End Class
