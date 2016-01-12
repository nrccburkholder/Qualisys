using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.Xml;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;

namespace HHCAHPSImporter.ImportProcessor.DAL
{
    public class QP_DataLoadManager
    {
        // private Generated.QP_DataLoad db = null;
        private string _connectionString;
        public TextWriter Log
        {
            set { this.db.Log = value; }
        }
        // private static Dictionary<string, DAL.Generated.ClientDetail> _ccnToClientCache = new Dictionary<string, Generated.ClientDetail>();

        private QP_DataLoadManager(string connectionString)
        {
            _connectionString = connectionString;
        }

        public static QP_DataLoadManager Create(string connectionString)
        {
            return new QP_DataLoadManager(connectionString);
        }

        public Generated.QP_DataLoad db
        {
            get
            {
                return new Generated.QP_DataLoad(ConnectionString);
            }
        }

        private string ConnectionString
        {
            get
            {
                return this._connectionString;
            }
        }

        public DAL.Generated.ClientDetail GetClientDetailFromCCN(string ccn)
        {
            if (!string.IsNullOrEmpty(ccn))
            {
                //if (_ccnToClientCache.Keys.Contains(ccn))
                //{
                //    return _ccnToClientCache[ccn];
                //}

                var v = db.ClientDetail.Where(t => t.CCN.Equals(ccn)).FirstOrDefault();
                return v;
                //if (v != null)
                //{
                //    _ccnToClientCache[ccn] = v;
                //    return _ccnToClientCache[ccn];
                //}
            }

            return null;
        }

        public Generated.ClientFormat GetClientFormatFromCCN(string ccn)
        {
            return db.ClientFormat.FirstOrDefault(t => t.CCN.Equals(ccn));
        }


        #region Transform Functionality

        public XDocument GetTransforms(Generated.ClientDetail client)
        {
            var db = this.db;

            XDocument xdoc = new XDocument();
            XElement xroot = new XElement("transforms");

            Dictionary<string, XElement> transforms = new Dictionary<string, XElement>();

            var transformMapping = db.GetTransforms(client.Client_id, client.Study_id, client.Survey_id).ToList();
            if (transformMapping.Count() == 0)
            {
                throw new Exception( string.Format(@"No transform defined for css {0}, {1}, {2}", client.Client_id, client.Study_id, client.Survey_id) );
            }

            string transformName = transformMapping.First().TransformName;
            xroot.Add(new XAttribute("transformname", transformName));

            #region Get any Imports for the tranform
            XElement xImports = new XElement("imports");
            var imports = db.GetTransformImports(transformMapping.First().TransformId);
            foreach (var import in imports)
            {
                XElement xImport = new XElement("import", new XAttribute("name", import.TransformLibraryName));
                xImport.Value = import.Code;

                xImports.Add(xImport);
            }
            xroot.Add(xImports);
            #endregion

            foreach (var transform in transformMapping)
            {
                XElement fieldTransform = new XElement("field", new XAttribute("targetfield", transform.TargetFieldName));

                // this is the script/source code that will do the field transform
                if (transform.Transform != null)
                {
                    fieldTransform.Value = transform.Transform;
                }
                else
                {
                    fieldTransform.Value = string.Empty;
                }

                if (!string.IsNullOrEmpty(transform.SourceFieldName))
                {
                    fieldTransform.Add(new XAttribute("sourcefield", transform.SourceFieldName));
                }

                if (!transforms.Keys.Contains(transform.TransformTargetName))
                {
                    transforms.Add(transform.TransformTargetName, new XElement("transform",
                        new XAttribute("target", transform.TransformTargetTable),
                        new XAttribute("transformtargetid", transform.TransformTargetId),
                        new XAttribute("transformtargetname", transform.TransformTargetName)));
                }
                transforms[transform.TransformTargetName].Add(fieldTransform);
            }

            foreach (string key in transforms.Keys)
            {
                xroot.Add(transforms[key]);
            }
            xdoc.Add(xroot);
            return xdoc;
        }

        public void LoadStudyOwnedTables(DAL.Generated.ClientDetail client, XDocument data)
        {
            // CreateStudyOwnedTables(client);
            LoadData(data);
        }

        private void LoadData(XDocument data)
        {
            Dictionary<string, string> targetSchemas = new Dictionary<string, string>();
            Dictionary<string, string> targetColumns = new Dictionary<string, string>();

            int clientId = Convert.ToInt32(data.Root.Attribute("client_id").Value);
            int studyId = Convert.ToInt32(data.Root.Attribute("study_id").Value);
            int surveyId = Convert.ToInt32(data.Root.Attribute("survey_id").Value);
            int uploadFileId = Convert.ToInt32(data.Root.Attribute("uploadfile_id").Value);
            int dataFileId = Convert.ToInt32(data.Root.Attribute("datafile_id").Value);

            using (SqlConnection conn = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                var targets = data.Root.Elements("target");

                foreach (var target in targets)
                {
                    string targetTable = target.Attribute("table").Value;
                    string targetSchema = string.Empty;
                    string targetColumnList = string.Empty;

                    List<string> databaseTableTargetColumns = new List<string>();

                    using (SqlCommand getTableDef = new SqlCommand())
                    {
                        conn.Open();

                        getTableDef.Connection = conn;
                        getTableDef.CommandType = CommandType.Text;
                        getTableDef.CommandText = string.Format(@"select 
	b.name as ColumnName, 
	c.name as DataType, 
	b.max_length as MaxLength,
	b.is_identity as IsIdentity
from sys.tables as a with(nolock)
    inner join sys.columns as b with(nolock) on a.object_id=b.object_id
    inner join sys.types as c with(nolock) on b.system_type_id=c.system_type_id
    inner join sys.schemas as d with(nolock) on a.schema_id=d.schema_id
where a.name ='{0}' and d.name='S{1}'", targetTable, studyId);

                        using (SqlDataReader dr = getTableDef.ExecuteReader())
                        {
                            if (!dr.HasRows)
                            {
                                throw new Exception(string.Format("study owned table S{0}.{1} was not found", studyId, targetTable));
                            }

                            while (dr.Read())
                            {
                                string ColumnName = dr["ColumnName"].ToString().ToLower();
                                string DataType = dr["DataType"].ToString();
                                int MaxLength = Convert.ToInt32(dr["MaxLength"]);
                                bool isIdentity = Convert.ToBoolean(dr["IsIdentity"]);

                                if (!isIdentity)
                                {
                                    targetSchema += string.Format("{0} {1} '{0}',", ColumnName, DataType.Equals("varchar") ? string.Format("varchar({0})", MaxLength) : DataType);
                                    targetColumnList += string.Format("{0},", ColumnName);
                                }

                                databaseTableTargetColumns.Add(ColumnName);
                            }
                        }

                        targetSchema = targetSchema.Trim(',');
                        targetColumnList = targetColumnList.Trim(',');

                        conn.Close();
                    }

                    // Validate that database schema and the XML schema match
                    foreach (var xRow in target.Elements("r"))
                    {
                        foreach (var xField in xRow.Elements())
                        {
                            if (!databaseTableTargetColumns.Contains(xField.Name.LocalName))
                            {
                                throw new Exception(string.Format("Schema mismatch: The field {0} is missing from S{1}.{2}", xField.Name.LocalName, studyId, targetTable));
                            }
                        }
                    }

                    targetSchemas[targetTable] = targetSchema;
                    targetColumns[targetTable] = targetColumnList;
                }

                // now insert data for each target into each of the study owned tables.
                using (SqlCommand insertCommand = new SqlCommand())
                {

                    string sql = @"DECLARE @idoc INT
EXEC sp_xml_preparedocument @idoc OUTPUT, @doc
INSERT INTO S{0}.{1}({2})
SELECT {2}
FROM
OPENXML (@idoc, '/target/r',1)
WITH( {3} )";

                    insertCommand.CommandType = CommandType.Text;

                    insertCommand.Parameters.Add(new SqlParameter("@doc",
                        SqlDbType.Xml,
                        -1,
                        ParameterDirection.Input,
                        new byte(),
                        new byte(),
                        null,
                        DataRowVersion.Current,
                        true,
                        string.Empty,
                        null,
                        null,
                        null));

                    conn.Open();
                    insertCommand.Connection = conn;
                    insertCommand.Transaction = conn.BeginTransaction();

                    try
                    {
                        foreach (var target in targets)
                        {
                            string targetTable = target.Attribute("table").Value;

                            insertCommand.CommandText = string.Format(sql,
                                                            studyId,
                                                            targetTable,
                                                            targetColumns[targetTable],
                                                            targetSchemas[targetTable]);


                            // remove empty nodes, this will produce a null db value when inserting
                            target.Elements("r").Elements().Where(t => string.IsNullOrEmpty(t.Value.Trim())).Remove();

                            insertCommand.Parameters["@doc"].Value = target.ToString();

                            insertCommand.ExecuteNonQuery();
                        }

                        insertCommand.Transaction.Commit();

                    }
                    catch
                    {
                        insertCommand.Transaction.Rollback();
                        throw;
                    }
                    finally
                    {
                        conn.Close();
                    }
                }
            }
        }

        private void CreateStudyOwnedTables(Generated.ClientDetail client)
        {
            string sql = @"
IF NOT EXISTS( SELECT name FROM sys.schemas WHERE name = 'S{0}' ) 
BEGIN
     EXEC sp_executesql N'CREATE SCHEMA [S{0}] AUTHORIZATION [dbo]'
END

IF NOT EXISTS(
SELECT a.name 
FROM sys.tables as a 
inner join sys.schemas as b on a.schema_id=b.schema_id
where a.name='ENCOUNTER_Load' and b.name='S{0}')
BEGIN
    CREATE TABLE [S{0}].[ENCOUNTER_Load](
	[DataFile_id] [int] NOT NULL,
	[DF_id] [int] NOT NULL,
	[enc_id] [int] IDENTITY(2,1) NOT NULL,
	[NewRecordDate] [datetime] NULL,
	[AdmitSource] [varchar](42) NULL,
	[DischargeDate] [datetime] NULL,
	[ICD9] [varchar](10) NULL,
	[ICD9_2] [varchar](10) NULL,
	[ICD9_3] [varchar](10) NULL,
	[ServiceDate] [datetime] NULL,
	[pop_id] [int] NULL,
	[VisitType] [varchar](42) NULL,
	[ServiceInd_2] [varchar](42) NULL,
	[ServiceInd_3] [varchar](42) NULL,
	[ServiceInd_4] [varchar](42) NULL,
	[ServiceInd_5] [varchar](42) NULL,
	[ServiceInd_6] [varchar](42) NULL,
	[ServiceInd_7] [varchar](42) NULL,
	[ServiceInd_8] [varchar](42) NULL,
	[ServiceInd_9] [varchar](42) NULL,
	[ServiceInd_10] [varchar](42) NULL,
	[ServiceInd_11] [varchar](42) NULL,
	[ICD9_4] [varchar](10) NULL,
	[ICD9_5] [varchar](10) NULL,
	[ICD9_6] [varchar](10) NULL,
	[ICD9_7] [varchar](10) NULL,
	[ICD9_8] [varchar](10) NULL,
	[ICD9_9] [varchar](10) NULL,
	[ICD9_10] [varchar](10) NULL,
	[ICD9_11] [varchar](10) NULL,
	[ICD9_12] [varchar](10) NULL,
	[ICD9_13] [varchar](10) NULL,
	[ICD9_14] [varchar](10) NULL,
	[ICD9_15] [varchar](10) NULL,
	[ICD9_16] [varchar](10) NULL,
	[Enc_Mtch] [varchar](42) NULL,
	[ICD9_17] [varchar](10) NULL,
	[ICD9_18] [varchar](10) NULL,
	[NPI] [varchar](10) NULL,
	[HHAgencyNm] [varchar](100) NULL,
	[HHSampleMonth] [varchar](10) NULL,
	[HHSampleYear] [varchar](4) NULL,
	[HHPatServed] [int] NULL,
	[HHPatInFile] [int] NULL,
	[HHVisitCnt] [int] NULL,
	[HHLookbackCnt] [int] NULL,
	[HHAdm_Hosp] [varchar](1) NULL,
	[HHAdm_Rehab] [varchar](1) NULL,
	[HHAdm_SNF] [varchar](1) NULL,
	[HHAdm_OthLTC] [varchar](1) NULL,
	[HHAdm_OthIP] [varchar](1) NULL,
	[HHAdm_Comm] [varchar](1) NULL,
	[HHPay_Mcare] [varchar](1) NULL,
	[HHPay_Mcaid] [varchar](1) NULL,
	[HHPay_Ins] [varchar](1) NULL,
	[HHPay_Other] [varchar](1) NULL,
	[HHHMO] [varchar](1) NULL,
	[HHDual] [varchar](1) NULL,
	[HHSurg] [varchar](1) NULL,
	[HHESRD] [varchar](1) NULL,
	[HHADL_Deficit] [varchar](1) NULL,
	[HHADL_DressUp] [varchar](1) NULL,
	[HHADL_DressLow] [varchar](1) NULL,
	[HHADL_Bath] [varchar](1) NULL,
	[HHADL_Toilet] [varchar](1) NULL,
	[HHADL_Transfer] [varchar](1) NULL,
	[HHADL_Feed] [varchar](1) NULL,
	[HHBranchNum] [varchar](42) NULL,
	[HHEOMAge] [int] NULL,
	[HHCatAge] [varchar](2) NULL,
	[HHMaternity] [varchar](1) NULL,
	[HHHospice] [varchar](1) NULL,
	[HHDeceased] [varchar](1) NULL,
	[HHDischargeStat] [varchar](42) NULL,
	[HHNQL] [varchar](42) NULL,
	[HHOASISPatID] [varchar](42) NULL,
	[HHSOCDate] [datetime] NULL,
	[HHAssesReason] [varchar](42) NULL,
	[CCN] [varchar](10) NULL,
	[Enc_mtch_Val] [varchar](100) NULL,
     CONSTRAINT [PK_S{0}ENCOUNTER_Load] PRIMARY KEY CLUSTERED 
    (
	    [enc_id] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
    ) ON [PRIMARY]
END

IF NOT EXISTS(
SELECT a.name 
FROM sys.tables as a 
inner join sys.schemas as b on a.schema_id=b.schema_id
where a.name='POPULATION_Load' and b.name='S{0}')
BEGIN
CREATE TABLE [S{0}].[POPULATION_Load](
	[DataFile_id] [int] NOT NULL,
	[DF_id] [int] NOT NULL,
	[pop_id] [int] IDENTITY(2,1) NOT NULL,
	[MRN] [varchar](42) NULL,
	[LName] [varchar](42) NULL,
	[FName] [varchar](42) NULL,
	[Middle] [varchar](1) NULL,
	[Addr] [varchar](60) NULL,
	[City] [varchar](42) NULL,
	[ST] [varchar](2) NULL,
	[ZIP5] [varchar](5) NULL,
	[DOB] [datetime] NULL,
	[Sex] [varchar](1) NULL,
	[Age] [int] NULL,
	[AddrStat] [varchar](42) NULL,
	[AddrErr] [varchar](42) NULL,
	[Zip4] [varchar](4) NULL,
	[NewRecordDate] [datetime] NULL,
	[LangID] [int] NULL,
	[Del_Pt] [varchar](3) NULL,
	[Phone] [varchar](10) NULL,
	[PHONSTAT] [int] NULL,
	[AreaCode] [varchar](3) NULL,
	[Addr2] [varchar](42) NULL,
	[NameStat] [varchar](42) NULL,
	[Zip5_Foreign] [varchar](5) NULL,
	[Province] [varchar](2) NULL,
	[Postal_Code] [varchar](7) NULL,
	[Pop_Mtch] [varchar](42) NULL,
	[HHLangHandE] [varchar](42) NULL,
	[HHHelpedHandE] [varchar](99) NULL,
	[Pop_mtch_Val] [varchar](100) NULL,
 CONSTRAINT [PK_S{0}POPULATION_Load] PRIMARY KEY CLUSTERED 
(
	[pop_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END";
            sql = string.Format(sql, client.Study_id);

            using (SqlConnection conn = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = sql;

                    conn.Open();
                    cmd.Connection = conn;
                    cmd.ExecuteNonQuery();
                }
            }
        }        
        #endregion


        #region Existing NRC Functionality
        public int InsertUploadFile(FileInfo file)
        {
            Generated.UploadFile uploadFile = new Generated.UploadFile()
                {
                    File_Nm = file.Name,
                    FileSize = Convert.ToInt32(file.Length),
                    OrigFile_Nm = file.Name, // just the name, not the path...
                    UploadAction_id = (int)UploadAction.ProductionFile
                };

            var db = this.db;
            db.UploadFile.InsertOnSubmit(uploadFile);
            db.SubmitChanges();

            return uploadFile.UploadFile_id;
        }

        public void UpdateUploadFile(int uploadFileId, FileInfo file)
        {
            var db = this.db;

            Generated.UploadFile uploadFile = db.UploadFile
                .Where(t => t.UploadFile_id.Equals(uploadFileId))
                .FirstOrDefault();

            if (uploadFile != null)
            {
                uploadFile.File_Nm = file.Name;
            }
            db.SubmitChanges();
        }

        public DAL.Generated.UploadFile GetUploadFile(int uploadFileId)
        {
            return db.UploadFile.Where(t => t.UploadFile_id.Equals(uploadFileId) ).FirstOrDefault();
        }

        public void LD_UpdateUploadFileState(int uploadFileId, UploadState state, string param)
        {
            db.LD_UpdateUploadFileState(uploadFileId, (int)state, param);
        }

        public int InsertDataFile(DAL.Generated.ClientDetail client, string pervasiveMapName, string fileLocation, string fileName, int fileSize ) // FileInfo fi)
        {
            var db = this.db;

            Generated.DataFile dataFile = new Generated.DataFile()
                {
                    Client_ID = Convert.ToInt32(client.Client_id),
                    Study_ID = Convert.ToInt32(client.Study_id),
                    Survey_ID = Convert.ToInt32(client.Survey_id),
                    PervasiveMapName = pervasiveMapName,
                    FileType_id = 1,
                    DatReceived = DateTime.Now,
                    IntFileSize = fileSize, //Convert.ToInt32(file.Length),
                    StrFile_nm = fileName,
                    StrFileLocation = fileLocation
                };

            db.DataFile.InsertOnSubmit(dataFile);
            db.SubmitChanges();
            return dataFile.DataFile_id;
        }

        public void UpdateDataFile(int dataFileId, FileInfo file, DateTime? receiveDate, DateTime? beginDate, DateTime? endDate)
        {
            Generated.DataFile dataFile = db.DataFile.Where(t => t.DataFile_id.Equals(dataFileId)).First();

            db.LD_UpdateDataFile(
                dataFileId,
                dataFile.Client_ID,
                dataFile.Study_ID,
                dataFile.Survey_ID,
                dataFile.FileType_id,
                dataFile.PervasiveMapName,
                file.DirectoryName,
                file.Name,
                Convert.ToInt32(file.Length),
                dataFile.IntRecords,
                receiveDate.HasValue?receiveDate:dataFile.DatReceived,
                beginDate.HasValue?beginDate:dataFile.DatBegin,
                endDate.HasValue?endDate:dataFile.DatEnd,
                dataFile.IntLoaded,
                dataFile.DatMinDate,
                dataFile.DatMaxDate,
                dataFile.DatDeleted,
                dataFile.DataSet_id,
                dataFile.AssocDataFiles);

        }

        public void InsertUploadFilesToDataFiles(int uploadFileId, int dataFileId)
        {
            Generated.UploadFilesToDataFiles uftodf = new Generated.UploadFilesToDataFiles()
                {
                    UploadFile_id = uploadFileId,
                    DataFile_id = dataFileId
                };

            var db = this.db;
            db.UploadFilesToDataFiles.InsertOnSubmit(uftodf);
            db.SubmitChanges();
        }

        public void LD_UpdateDataFileStateChange(int dataFileId, DataFileState state, string stateParam)
        {
            db.LD_UpdateDataFileStateChange(dataFileId, (int)state, stateParam);
        }

        public void LD_UpdateDataFilePostLoad(int dataFileId, string mapName)
        {
            using (SqlConnection conn = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (SqlCommand sproc = new SqlCommand())
                {
                    sproc.CommandType = CommandType.StoredProcedure;
                    sproc.CommandText = @"LD_UpdateDataFilePostLoad";

                    var paramDataFileID = sproc.CreateParameter();
                    paramDataFileID.Direction = ParameterDirection.Input;
                    paramDataFileID.ParameterName = "@DataFile_id";
                    paramDataFileID.Value = dataFileId;

                    var paramMapName = sproc.CreateParameter();
                    paramMapName.Direction = ParameterDirection.Input;
                    paramMapName.ParameterName = "@PervasiveMapName";
                    paramMapName.Value = mapName;

                    var indebug = sproc.CreateParameter();
                    indebug.Direction = ParameterDirection.Input;
                    indebug.ParameterName = "@indebug";
                    indebug.Value = 0;

                    sproc.Parameters.Add(paramDataFileID);
                    sproc.Parameters.Add(paramMapName);
                    sproc.Parameters.Add(indebug);

                    conn.Open();
                    sproc.Connection = conn;
                    sproc.ExecuteNonQuery();
                }
            }
        }

        public void LD_PostDTS(int dataFileId)
        {
            using (SqlConnection conn = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (SqlCommand sproc = new SqlCommand())
                {
                    sproc.CommandType = CommandType.StoredProcedure;
                    sproc.CommandText = @"LD_PostDTS";

                    var paramDataFileID = sproc.CreateParameter();
                    paramDataFileID.Direction = ParameterDirection.Input;
                    paramDataFileID.ParameterName = "@File_id";
                    paramDataFileID.Value = dataFileId;

                    sproc.Parameters.Add(paramDataFileID);

                    conn.Open();
                    sproc.Connection = conn;
                    sproc.ExecuteNonQuery();
                }
            }
        }

        public void LD_ApplyShell(int dataFileId)
        {
            using (SqlConnection conn = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (SqlCommand sproc = new SqlCommand())
                {
                    sproc.CommandType = CommandType.StoredProcedure;
                    sproc.CommandText = @"LD_ApplyShell";

                    var paramDataFileID = sproc.CreateParameter();
                    paramDataFileID.Direction = ParameterDirection.Input;
                    paramDataFileID.ParameterName = "@DataFile_id";
                    paramDataFileID.Value = dataFileId;

                    sproc.Parameters.Add(paramDataFileID);
                    
                    var indebug = sproc.CreateParameter();
                    indebug.Direction = ParameterDirection.Input;
                    indebug.ParameterName = "@indebug";
                    indebug.Value = 0;

                    sproc.Parameters.Add(indebug);

                    conn.Open();
                    sproc.Connection = conn;
                    sproc.ExecuteNonQuery();
                }
            }
        }

        public void UpdateOCSEncounterData(int dataFileId)
        {
            using (SqlConnection conn = new System.Data.SqlClient.SqlConnection(this.ConnectionString))
            {
                using (SqlCommand sproc = new SqlCommand())
                {
                    sproc.CommandType = CommandType.StoredProcedure;
                    sproc.CommandText = @"UpdateOCSEncounterData";

                    var paramDataFileID = sproc.CreateParameter();
                    paramDataFileID.Direction = ParameterDirection.Input;
                    paramDataFileID.ParameterName = "@datafile_id";
                    paramDataFileID.Value = dataFileId;

                    sproc.Parameters.Add(paramDataFileID);

                    conn.Open();
                    sproc.Connection = conn;
                    sproc.ExecuteNonQuery();
                }
            }
        }
        #endregion

    }
}
