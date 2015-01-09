using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Xml;
using System.Configuration;
using Nrc.Framework.BusinessLogic.Configuration;

namespace QueueManagerLibrary.DataProviders
{
    public class SqlDataProvider : IDisposable
    {

        #region private members

        private System.Data.SqlClient.SqlDataAdapter _sqlDA;
        private System.Data.SqlClient.SqlConnection _sqlConn;
        private System.Data.SqlClient.SqlCommand _sqlComm;
        private SqlTransaction _sqlTrans;
        private int _commandTimeout = 0;
        private string _currentConnectionString;

        #endregion

        #region properties


        private string ConnectionString
        {
            get
            {
                return AppConfig.QualisysConnection;
            }
        }

        public int CommandTimeout
        {
            get { return _commandTimeout; }
            set { _commandTimeout = value; }
        }


        #endregion

        #region constructors

        public SqlDataProvider()
        {
            _currentConnectionString = ConnectionString;
        }

        #endregion

        #region Public Routines

        #region Execute Scalar

        public Object ExecuteScalar(string commandText, CommandType commType)
        {
            return ExecuteScalar(commandText, commType, new SqlParameter[] { });
        }
        public Object ExecuteScalar(string commandText, CommandType commType, SqlParameter param)
        {
            return ExecuteScalar(commandText, commType, new SqlParameter[] { param });
        }

        public Object ExecuteScalar(string commandText, CommandType commType, SqlParameter[] param)
        {
            Object oScalarVal;

            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.Connection = _sqlConn;
                _sqlComm.CommandTimeout = _commandTimeout;
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                oScalarVal = _sqlComm.ExecuteScalar();
                return oScalarVal;
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
        }
        #endregion

        #region Execute Reader

        public SqlDataReader ExecuteReader(string commandText, CommandType commType)
        {
            return ExecuteReader(commandText, commType, CommandBehavior.Default, new SqlParameter[] { });
        }

        public SqlDataReader ExecuteReader(string commandText, CommandType commType, CommandBehavior commBehavior)
        {
            return ExecuteReader(commandText, commType, commBehavior, new SqlParameter[] { });
        }
        public SqlDataReader ExecuteReader(string commandText, CommandType commType, SqlParameter param)
        {
            return ExecuteReader(commandText, commType, CommandBehavior.Default, new SqlParameter[] { param });
        }

        public SqlDataReader ExecuteReader(string commandText, CommandType commType, CommandBehavior commBehavior, SqlParameter param)
        {
            return ExecuteReader(commandText, commType, commBehavior, new SqlParameter[] { param });
        }

        public SqlDataReader ExecuteReader(string commandText, CommandType commType, SqlParameter[] param)
        {
            return ExecuteReader(commandText, commType, CommandBehavior.Default, param);
        }

        public SqlDataReader ExecuteReader(string commandText, CommandType commType, CommandBehavior commBehavior, SqlParameter[] param)
        {
            SqlDataReader drReturn;

            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.Connection = _sqlConn;
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                drReturn = _sqlComm.ExecuteReader(commBehavior);
                return drReturn;
            }
            catch (Exception e)
            {
                _sqlConn.Close();
                throw e;
            }
        }
        #endregion

        #region Execute NonQuery
        public int ExecuteNonQuery(string commandText, CommandType commType)
        {
            return ExecuteNonQuery(commandText, commType, new SqlParameter[] { });
        }

        public int ExecuteNonQuery(string commandText, CommandType commType, SqlParameter param)
        {
            return ExecuteNonQuery(commandText, commType, new SqlParameter[] { param });
        }


        public int ExecuteNonQuery(string commandText, CommandType commType, SqlParameter[] param)
        {
            int iReturn;

            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.Connection = _sqlConn;
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                iReturn = _sqlComm.ExecuteNonQuery();
                return iReturn;
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
        }
        #endregion

        #region Adapter Fill

        public int Fill(ref DataTable dt, string commandText, CommandType commType)
        {
            return Fill(ref dt, commandText, commType, new SqlParameter[] { });
        }
        public int Fill(ref DataTable dt, string commandText, CommandType commType, SqlParameter param)
        {
            return Fill(ref dt, commandText, commType, new SqlParameter[] { param });
        }

        public int Fill(ref DataTable dt, string commandText, CommandType commType, SqlParameter[] param)
        {
            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            if (dt == null)
                dt = new DataTable();

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;
                _sqlComm.Connection = _sqlConn;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                _sqlDA = new SqlDataAdapter(_sqlComm);
                return _sqlDA.Fill(dt);
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
            finally
            {
                if (_sqlDA != null)
                {
                    _sqlDA.Dispose();
                }
            }
        }
        public int Fill(ref DataSet ds, string commandText, CommandType commType)
        {
            return Fill(ref ds, commandText, commType, new SqlParameter[] { });
        }

        public int Fill(ref DataSet ds, string commandText, CommandType commType, SqlParameter param)
        {
            return Fill(ref ds, commandText, commType, new SqlParameter[] { param });
        }

        public int Fill(ref DataSet ds, string commandText, CommandType commType, SqlParameter[] param)
        {
            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            if (ds == null)
                ds = new DataSet();

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;
                _sqlComm.Connection = _sqlConn;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                _sqlDA = new SqlDataAdapter(_sqlComm);
                return _sqlDA.Fill(ds);
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
            finally
            {
                if (_sqlDA != null)
                {
                    _sqlDA.Dispose();
                }
            }
        }

        public int Fill(ref DataSet ds, string tableName, string commandText, CommandType commType)
        {
            return Fill(ref ds, tableName, commandText, commType, new SqlParameter[] { });
        }

        public int Fill(ref DataSet ds, string tableName, string commandText, CommandType commType, SqlParameter param)
        {
            return Fill(ref ds, tableName, commandText, commType, new SqlParameter[] { param });
        }

        public int Fill(ref DataSet ds, string tableName, string commandText, CommandType commType, SqlParameter[] param)
        {
            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            if (ds == null)
                ds = new DataSet();

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;
                _sqlComm.Connection = _sqlConn;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                _sqlDA = new SqlDataAdapter(_sqlComm);
                return _sqlDA.Fill(ds, tableName);
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
            finally
            {
                if (_sqlDA != null)
                {
                    _sqlDA.Dispose();
                }
            }
        }

        public int Fill(ref DataSet ds, string tableName, string commandText, CommandType commType, int startRecord, int MaxRecords)
        {
            return Fill(ref ds, tableName, commandText, commType, startRecord, MaxRecords, new SqlParameter[] { });
        }

        public int Fill(ref DataSet ds, string tableName, string commandText, CommandType commType, int startRecord, int MaxRecords, SqlParameter param)
        {
            return Fill(ref ds, tableName, commandText, commType, startRecord, MaxRecords, new SqlParameter[] { param });
        }

        public int Fill(ref DataSet ds, string tableName, string commandText, CommandType commType, int startRecord, int MaxRecords, SqlParameter[] param)
        {
            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            if (ds == null)
                ds = new DataSet();

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;
                _sqlComm.Connection = _sqlConn;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                _sqlDA = new SqlDataAdapter(_sqlComm);
                return _sqlDA.Fill(ds, startRecord, MaxRecords, tableName);
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
            finally
            {
                if (_sqlDA != null)
                {
                    _sqlDA.Dispose();
                }
            }
        }
        #endregion

        #region ExecuteXMLReader
        public XmlReader ExecuteXMLReader(string commandText, CommandType commType)
        {
            return ExecuteXMLReader(commandText, commType, new SqlParameter[] { });
        }

        public XmlReader ExecuteXMLReader(string commandText, CommandType commType, SqlParameter param)
        {
            return ExecuteXMLReader(commandText, commType, new SqlParameter[] { param });
        }

        public XmlReader ExecuteXMLReader(string commandText, CommandType commType, SqlParameter[] param)
        {
            XmlReader iReturn;

            ResetDAOs();
            CreateConnection(ConnectionString);
            ValidateCommand(commandText);

            try
            {
                _sqlComm = new SqlCommand();
                _sqlComm.Connection = _sqlConn;
                _sqlComm.CommandText = commandText;
                _sqlComm.CommandType = commType;
                _sqlComm.CommandTimeout = _commandTimeout;
                if (_sqlTrans != null)
                {
                    _sqlComm.Transaction = _sqlTrans;
                }

                foreach (SqlParameter tempParam in param)
                {
                    _sqlComm.Parameters.Add(tempParam);
                }
                if (_sqlConn.State != ConnectionState.Open)
                    _sqlConn.Open();

                iReturn = _sqlComm.ExecuteXmlReader();
                return iReturn;
            }
            catch (Exception e)
            {
                if (_sqlTrans != null)
                {
                    _sqlTrans.Rollback();
                    _sqlTrans.Dispose();
                }
                _sqlConn.Close();
                throw e;
            }
        }
        #endregion

        #region GetOutputValue
        public Object GetOutputValue(int index)
        {
            return GetOutputValue(_sqlComm.Parameters[index]);
        }
        public Object GetOutputValue(string IndexName)
        {
            return GetOutputValue(_sqlComm.Parameters[IndexName]);
        }
        public Object GetOutputValue(SqlParameter param)
        {
            return param.Value;
        }
        public Object[] GetOutputValues()
        {
            List<Object> retSQLOutput = new List<Object>();

            foreach (SqlParameter param in _sqlComm.Parameters)
            {
                if (param.Direction > ParameterDirection.Input && param.Direction <= ParameterDirection.ReturnValue)
                {
                    retSQLOutput.Add(param.Value);
                }
            }

            return retSQLOutput.ToArray<Object>();
        }
        #endregion

        public void DestroyConnection()
        {
            if (_sqlConn != null)
            {
                if (_sqlConn.State != ConnectionState.Closed)
                {
                    _sqlConn.Close();
                }
                _sqlConn.Dispose();
            }
        }

        public void BeginTransaction()
        {
            CreateConnection(ConnectionString);
            if (_sqlConn.State == ConnectionState.Closed)
                _sqlConn.Open();
            _sqlTrans = _sqlConn.BeginTransaction(IsolationLevel.ReadCommitted);
        }
        public void CommitTransaction()
        {
            if (_sqlTrans != null)
            {
                _sqlTrans.Commit();
                _sqlTrans.Dispose();
            }
        }
        public void RollbackTransaction()
        {
            if (_sqlTrans != null)
            {
                _sqlTrans.Rollback();
                _sqlTrans.Dispose();
            }
        }

        #endregion

        #region private routines

        private void CreateConnection(string connectionString)
        {
            if (_sqlConn != null)
            {
                if (_currentConnectionString != connectionString)
                {
                    if (_sqlConn.State != ConnectionState.Closed)
                    {
                        if (_sqlTrans != null)
                        {
                            _sqlTrans.Dispose();
                        }
                        _sqlConn.Close();
                        _sqlConn.Dispose();
                    }
                    _sqlConn = new SqlConnection(connectionString);
                    _currentConnectionString = connectionString;
                }
            }
            else
            {
                _sqlConn = new SqlConnection(connectionString);
                _currentConnectionString = connectionString;
            }

        }
        private void ResetDAOs()
        {
            if (_sqlComm != null)
            {
                _sqlComm.Parameters.Clear();
                _sqlComm.Dispose();
            }
            if (_sqlDA != null)
            {
                _sqlDA.Dispose();
            }
        }
        private void ValidateCommand(string CommandText)
        {
            if (CommandText == string.Empty)
            {
                throw new ArgumentNullException("Empty Command Text");
            }
            //if (_ConnectionStrings.Count == 0 || _sqlConn == null)
            //{
            //    throw new ArgumentNullException("No Valid Connection Available");
            //}
        }

        #endregion

        #region IDisposable and Deconstructor
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_sqlConn != null)
                {
                    if (_sqlConn.State != ConnectionState.Closed)
                    {
                        _sqlConn.Close();
                    }
                }
                if (_sqlConn != null)
                    _sqlConn.Dispose();
                if (_sqlComm != null)
                    _sqlComm.Dispose();
            }
        }
        ~SqlDataProvider()
        {
            Dispose(false);
        }
        #endregion

    }
}
