using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace DbNullConverter
{

    /// <summary>
    /// Safe null values by data type.
    /// </summary>
    public class SafeNull
    {

        private SafeNull()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        /// <summary>
        /// return safe null value for DateTime
        /// </summary>
        public static DateTime NullDateTime()
        {
            return DateTime.MinValue;
        }

        /// <summary>
        /// return safe null value for int16
        /// </summary>
        public static Int16 NullInt16()
        {
            return -1;
        }

        /// <summary>
        /// return safe null value for int32
        /// </summary>
        public static Int32 NullInt32()
        {
            return -1;
        }

        /// <summary>
        /// return safe null value for int64
        /// </summary>
        public static Int64 NullInt64()
        {
            return -1;
        }

        /// <summary>
        /// return safe null value for UInt16
        /// </summary>
        public static UInt16 NullUnSignedInt16()
        {
            return UInt16.MaxValue;
        }

        /// <summary>
        /// return safe null value for UInt32
        /// </summary>
        public static UInt32 NullUnSignedInt32()
        {
            return UInt32.MaxValue;
        }


        /// <summary>
        /// return safe null value for UInt64
        /// </summary>
        public static UInt64 NullUnSignedInt64()
        {
            return UInt64.MaxValue;
        }

        /// <summary>
        /// return safe null value for string
        /// </summary>
        public static string NullString()
        {
            return "";
        }

        /// <summary>
        /// return safe null value for bool
        /// </summary>
        public static bool NullBoolean()
        {
            return false;
        }

        /// <summary>
        /// return safe null value for Guid
        /// </summary>
        public static Guid NullGuid()
        {
            return Guid.Empty;
        }
    }


    /// <summary>
    /// DbNull helper functions to convert dbnulls to safe null values, and vis versa.
    /// </summary>
    public class DbNullHelper
    {
        private DbNullHelper()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        /// <summary>
        /// return safe data row column value
        /// </summary>
        public static object GetDBValue(System.Data.IDataRecord row, string columnName)
        {
            int columnIndex = row.GetOrdinal(columnName);
            string typeName = row.GetFieldType(columnIndex).Name;
            if (typeName == "DateTime")
                return (row.IsDBNull(columnIndex)) ? GetDBValueByTypeName(typeName) : CDate(row[columnIndex]);
            else
                return (row.IsDBNull(columnIndex)) ? GetDBValueByTypeName(typeName) : row[columnIndex];
        }

        public static object GetDBValueByTypeName(string sTypeName)
        {
            switch (sTypeName)
            {
                case "String":
                    return SafeNull.NullString();
                case "Char":
                    return SafeNull.NullString();
                case "Int16":
                    return SafeNull.NullInt16();
                case "Int32":
                    return SafeNull.NullInt32();
                case "Int64":
                    return SafeNull.NullInt64();
                case "UInt16":
                    return SafeNull.NullUnSignedInt16();
                case "UInt32":
                    return SafeNull.NullUnSignedInt32();
                case "UInt64":
                    return SafeNull.NullUnSignedInt64();
                case "Single":
                    return SafeNull.NullInt32();
                case "Double":
                    return SafeNull.NullInt32();
                case "Decimal":
                    return SafeNull.NullInt32();
                case "Boolean":
                    return SafeNull.NullBoolean();
                case "DateTime":
                    return SafeNull.NullDateTime();
                case "Guid":
                    return SafeNull.NullGuid();
                case "SByte":
                    return SafeNull.NullInt32();
                case "Byte":
                    return SafeNull.NullInt32();
                default:
                    throw new NullReferenceException("DbNullConverter.GetDBValue: Unable to determine column type");
            }
        }

        public static object GetDBValue(object columnValue)
        {
            if (columnValue == DBNull.Value || columnValue == null)
                return GetNull(columnValue);
            else
                return columnValue;
        }

        /// <summary>
        /// convert safe null to db null value
        /// </summary>
        public static object ConvertDBValue(object columnValue, object dbNull)
        {
            if (IsNull(columnValue))
            {
                return dbNull;
            }
            return columnValue;
        }

        /// <summary>
        /// convert safe null to System.DbNull.Value
        /// </summary>
        public static object ConvertDBValue(object columnValue)
        {
            return ConvertDBValue(columnValue, System.DBNull.Value);
        }

        /// <summary>
        /// checks if value is a safe null value
        /// </summary>
        public static bool IsNull(object columnValue)
        {
            if (columnValue.Equals(GetNull(columnValue)))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// return safe null based on value type
        /// </summary>
        public static object GetNull(object columnValue)
        {
            if (columnValue != null)
            {
                string typeName = columnValue.GetType().Name;

                if ((typeName == "Int32")
                    || (typeName == "Single")
                    || (typeName == "Double")
                    || (typeName == "Decimal"))
                {
                    return SafeNull.NullInt32();
                }
                else if (typeName == "Int16")
                {
                    return SafeNull.NullInt16();
                }
                else if (typeName == "Int64")
                {
                    return SafeNull.NullInt64();
                }
                else if (typeName == "UInt16")
                {
                    return SafeNull.NullUnSignedInt16();
                }
                else if (typeName == "UInt32")
                {
                    return SafeNull.NullUnSignedInt32();
                }
                else if (typeName == "UInt64")
                {
                    return SafeNull.NullUnSignedInt64();
                }
                else if ((typeName == "String") || (typeName == "Char"))
                {
                    return SafeNull.NullString();
                }
                else if (typeName == "Boolean")
                {
                    return SafeNull.NullBoolean();
                }
                else if (typeName == "Guid")
                {
                    return SafeNull.NullGuid();
                }
                else if (typeName == "DateTime")
                {
                    return SafeNull.NullDateTime();
                }
                else
                {
                    throw new NullReferenceException("DbNullConverter.GetNull: Unable to determine column type");
                }
            }
            else
            {
                throw new NullReferenceException("DbNullConverter.GetNull: Unable to determine column type because the value was null.");
            }
        }

        /// <summary>
        /// converts value to datetime value, returns safe null datetime if not a date value
        /// </summary>
        internal static System.DateTime CDate(object oValue)
        {
            string sString = oValue.ToString().Trim();
            try
            {
                return System.DateTime.Parse(sString);
            }
            catch
            {
                return SafeNull.NullDateTime();
            }

        }
    }
}

