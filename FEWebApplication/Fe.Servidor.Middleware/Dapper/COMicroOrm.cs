using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;
using Npgsql;
using Dapper;
using Dapper.Contrib.Extensions;

namespace Fe.Servidor.Middleware.Dapper
{
    public class COMicroOrm
    {
        private readonly string stringConnection;

        public COMicroOrm(IConfiguration configuration)
        {
            stringConnection = configuration.GetConnectionString("ConexionString");
        }

        public IDbConnection GetConnection()
        {
            IDbConnection conn = new NpgsqlConnection(stringConnection);

            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

            return conn;
        }

        public IEnumerable<T> SqlQuery<T>(IDbConnection connection,
          string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null) => connection.Query<T>(sql, param, transaction, true, commandTimeout, commandType);


        /// <summary>
        /// Ejecutar una sentecia sql directo contra la base de datos retornando una secuencia de objetos dinámicos correspondiente a cada columna
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <param name="transaction"></param>
        /// <param name="commandTimeout"></param>
        /// <param name="commandType"></param>
        /// <returns></returns>
        public IEnumerable<dynamic> SqlQuery(string sql,
     object param = null,
     IDbTransaction transaction = null,
     int? commandTimeout = null,
     CommandType? commandType = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.Query(sql, param, transaction, true, commandTimeout, commandType);
        }

        /// <summary>
        /// Ejecutar una sentencia Sql directo contra la base de datos
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>Colección con los datos resultados de la consulta</returns>
        public IEnumerable<T> SqlQuery<T>(string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.Query<T>(sql, param, transaction, true, commandTimeout, commandType);
        }

        /// <summary>
        /// Ejecutar un procedimiento almacenado directo contra la base de datos
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <returns>Colección con los datos resultados de la consulta</returns>
        public IEnumerable<T> SqlQuerySP<T>(string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.Query<T>($"call {sql}", param, transaction, true, commandTimeout);
        }

        /// <summary>
        /// Ejecutar un procedimiento almacenado directo contra la base de datos
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="connection">Conexión a la base de datos</param>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <returns>Colección con los datos resultados de la consulta</returns>
        public IEnumerable<T> SqlQuerySP<T>(IDbConnection connection,
          string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null)
        {
            return connection.Query<T>($"call {sql}", param, transaction, true, commandTimeout);
        }


        /// <summary>
        /// Ejecutar una sentencia Sql directo contra la base de datos
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>El primer elementoo su valor por default si no retorna datos la consulta</returns>
        public T QueryFirstOrDefault<T>(string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.QueryFirstOrDefault<T>(sql, param, transaction, commandTimeout, commandType);
        }


        /// <summary>
        /// Ejecutar una sentencia Sql directo contra la base de datos
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="connection">Conexión a la base de datos</param>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>El primer elementoo su valor por default si no retorna datos la consulta</returns>
        public T QueryFirstOrDefault<T>(IDbConnection connection,
          string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            return connection.QueryFirstOrDefault<T>(sql, param, transaction, commandTimeout, commandType);
        }

        /// <summary>
        /// Ejecutar un comando Sql directo contra la base de datos
        /// </summary>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>Cantidad de filas afectadas por el comando</returns>
        public int Execute(string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.Execute(sql, param, transaction, commandTimeout, commandType);
        }


        /// <summary>
        /// Ejecutar un procedimiento almacenado directo contra la base de datos
        /// </summary>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <returns>Cantidad de filas afectadas por el comando</returns>
        public int ExecuteSP(string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.Execute($"call {sql}", param, transaction, commandTimeout);
        }

        /// <summary>
        /// Ejecutar un procedimiento almacenado directo contra la base de datos
        /// </summary>
        /// <param name="connection">Conexión a la base de datos</param>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <returns>Cantidad de filas afectadas por el comando</returns>
        public int ExecuteSP(IDbConnection connection,
          string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null)
        {
            return connection.Execute($"call {sql}", param, transaction, commandTimeout);
        }

        /// <summary>
        /// Ejecutar un comando Sql directo contra la base de datos
        /// </summary>
        /// <param name="connection">Conexión a la base de datos</param>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>Cantidad de filas afectadas por el comando</returns>
        public int Execute(IDbConnection connection,
          string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            return connection.Execute(sql, param, transaction, commandTimeout, commandType);
        }

        /// <summary>
        /// Ejecutar un comando Sql directo contra la base de datos y retorna el campo de la primera fila y primera columna
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>Valor de la primera fila y primera columna</returns>
        public T ExecuteScalar<T>(string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            using IDbConnection conn = GetConnection();
            return conn.ExecuteScalar<T>(sql, param, transaction, commandTimeout, commandType);
        }


        /// <summary>
        /// Ejecutar un comando Sql directo contra la base de datos y retorna el campo de la primera fila y primera columna
        /// </summary>
        /// <typeparam name="T">Tipo retornado por la ejecución del comando</typeparam>
        /// <param name="connection">Conexión a la base de datos</param>
        /// <param name="sql">Cadena con la sentencia sql</param>
        /// <param name="param">Objeto con los parámetros de la sentencia</param>
        /// <param name="transaction">Intancia de la transacción si es que exite</param>
        /// <param name="commandTimeout">Timeout del comando</param>
        /// <param name="commandType">Tipo de comando</param>
        /// <returns>Valor de la primera fila y primera columna</returns>
        public T ExecuteScalar<T>(IDbConnection connection,
          string sql,
          object param = null,
          IDbTransaction transaction = null,
          int? commandTimeout = null,
          CommandType? commandType = null)
        {
            return connection.ExecuteScalar<T>(sql, param, transaction, commandTimeout, commandType);
        }

        /// <summary>
        /// Insertar una entidad a la base de datos manejando convensines
        /// </summary>
        /// <typeparam name="T">Tipo de la entidad a insertarse a la base de datos</typeparam>
        /// <param name="entity">Instacia de la entidad</param>
        /// <param name="transaction">Transcción de la operación</param>
        /// <param name="commandTimeout">Timeout para la sentencia de insert</param>
        /// <returns>Código con el cual queda creada la entidad en la base de datos</returns>
        /// <remarks>El nombre de la instancia de la entidad debe corresponder al nombre de la tabla en la base de daos</remarks>
        public long Insert<T>(T entity,
          IDbTransaction transaction = null,
          int? commandTimeout = null) where T : class
        {
            using IDbConnection conn = GetConnection();
            return conn.Insert<T>(entity, transaction, commandTimeout);
        }



        /// <summary>
        /// Insertar una entidad a la base de datos manejando convensines
        /// </summary>
        /// <typeparam name="T">Tipo de la entidad a insertarse a la base de datos</typeparam>
        /// <param name="connection">Conexión a la base de datos</param>
        /// <param name="entity">Instacia de la entidad</param>
        /// <param name="transaction">Transcción de la operación</param>
        /// <param name="commandTimeout">Timeout para la sentencia de insert</param>
        /// <returns>Código con el cual queda creada la entidad en la base de datos</returns>
        /// <remarks>El nombre de la instancia de la entidad debe corresponder al nombre de la tabla en la base de daos</remarks>
        public long Insert<T>(IDbConnection connection,
          T entity,
          IDbTransaction transaction = null,
          int? commandTimeout = null) where T : class
        {
            return connection.Insert<T>(entity, transaction, commandTimeout);
        }
    }
}
