using System.Data;
using System.Data.SqlTypes;
using System.Runtime.Serialization;
using System.Xml.Linq;
using Microsoft.Data.SqlClient;
namespace StaffApi.DO
{
    public class DbHelper : IDisposable
    {
        public SqlConnection _sqlConnect;
        public SqlCommand _sqlCommand;
        public SqlDataAdapter _sqlDataAdapter;
        public DataTable _dataTable;
        private readonly string _connectionString;

        public DbHelper(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        private void OpenConnection()
        {
            if (_sqlConnect == null)
            {
                _sqlConnect = new SqlConnection(_connectionString);
            }

            if (_sqlConnect.State == ConnectionState.Closed)
            {
                _sqlConnect.Open();
            }
        }

        private void CloseConnection()
        {
            if (_sqlConnect != null && _sqlConnect.State == ConnectionState.Open)
            {
                _sqlConnect.Close();
            }
        }

        public async Task<IEnumerable<T>> ExecuteReaderAsync<T>(string spName, string[] parameters, object[] values)
        {
            try
            {
                OpenConnection();

                _sqlCommand = new SqlCommand(spName, _sqlConnect)
                {
                    CommandType = CommandType.StoredProcedure
                };

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (!string.IsNullOrEmpty(parameters[i]))
                    {
                        var param = new SqlParameter
                        {
                            ParameterName = parameters[i],
                            Value = values[i] ?? DBNull.Value
                        };
                        _sqlCommand.Parameters.Add(param);
                    }
                }

                var reader = await _sqlCommand.ExecuteReaderAsync();
                return GetList<T>(reader);
            }
            catch (Exception ex)
            {
                // Log error (ex.Message)
                return null;
            }
            finally
            {
                CloseConnection();
            }
        }

        public async Task<DataTable> ReturnDataTableAsync(string spName, string[] parameters, object[] values)
        {
            try
            {
                OpenConnection();

                _sqlCommand = new SqlCommand(spName, _sqlConnect)
                {
                    CommandType = CommandType.StoredProcedure
                };

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (!string.IsNullOrEmpty(parameters[i]))
                    {
                        var param = new SqlParameter
                        {
                            ParameterName = parameters[i],
                            Value = values[i] ?? DBNull.Value
                        };
                        _sqlCommand.Parameters.Add(param);
                    }
                }

                _sqlDataAdapter = new SqlDataAdapter(_sqlCommand);
                _dataTable = new DataTable();
                await Task.Run(() => _sqlDataAdapter.Fill(_dataTable));
                return _dataTable;
            }
            catch (Exception ex)
            {
                // Log error (ex.Message)
                throw new Exception(ex.Message);
            }
            finally
            {
                CloseConnection();
            }
        }

        public static IEnumerable<T> GetList<T>(SqlDataReader reader)
        {
            var list = new List<T>();
            while (reader.Read())
            {
                var item = CreateInstance<T>();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    var colName = reader.GetName(i);
                    var value = reader.GetValue(i);
                    var property = item.GetType().GetProperty(colName);
                    if (property != null && value != DBNull.Value)
                    {
                        property.SetValue(item, value);
                    }
                }
                list.Add(item);
            }
            return list;
        }

        public static T CreateInstance<T>()
        {
            var type = typeof(T);
            return type == typeof(string) ? (T)(object)string.Empty : (T)FormatterServices.GetUninitializedObject(type);
        }

        public async Task<int> ExecStoreProcedureAsync(string spName, string[] parameters, object[] values)
        {
            try
            {
                OpenConnection();

                _sqlCommand = new SqlCommand(spName, _sqlConnect)
                {
                    CommandType = CommandType.StoredProcedure
                };

                for (int i = 0; i < parameters.Length; i++)
                {
                    if (!string.IsNullOrEmpty(parameters[i]))
                    {
                        var param = new SqlParameter
                        {
                            ParameterName = parameters[i],
                            Value = values[i] ?? DBNull.Value
                        };
                        _sqlCommand.Parameters.Add(param);
                    }
                }

                return await _sqlCommand.ExecuteNonQueryAsync();
            }
            catch (Exception ex)
            {
                // Log error (ex.Message)
                throw new Exception(ex.Message);
            }
            finally
            {
                CloseConnection();
            }
        }

        public void Dispose()
        {
            _sqlDataAdapter?.Dispose();
            _sqlCommand?.Dispose();
            _sqlConnect?.Dispose();
        }
    }
}
