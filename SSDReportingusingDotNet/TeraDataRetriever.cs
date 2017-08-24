using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using Teradata.Client.Provider;

namespace SSDReportingusingDotNet
{
    //This is a class i made to abstract the teradata data retrieval part
    public class TeraDataRetriever : IDisposable
    {
        //This is the teradata connection object named con
        TdConnection con;
        public Boolean connectionError;
        public String connectionErrorMessage;
        //dataSource DB Username and password details are provided here as arguments
        public TeraDataRetriever(String dataSource, String Database, String Username, String Password)
        {
            try
            {
                //connectionString Builder object
                TdConnectionStringBuilder conStrBuilder = new TdConnectionStringBuilder();

                

                conStrBuilder.DataSource = dataSource;

                conStrBuilder.Database = Database;

                conStrBuilder.UserId = Username;

                conStrBuilder.Password = Password;

                conStrBuilder.AuthenticationMechanism = "LDAP";

                //conStrBuilder.SessionMode = "TERA";

                Console.WriteLine("conn string was: " + conStrBuilder.ConnectionString);

                //assigning con to a new object by feeding connection string to the constructor
                con = new TdConnection
                {
                    ConnectionString = conStrBuilder.ConnectionString
                };
                con.Open();
                connectionError = false;
                connectionErrorMessage = "";
            }
            catch (Exception e)
            {
                connectionError = true;
                connectionErrorMessage = e.Message;
            }
        }

        public String GetQueryResult(String query)
        {
            try
            {
                var queryData = new DataTable();
                var command = new TdCommand(query, con);
                command.CommandTimeout = 1200;
                var adapter = new TdDataAdapter(command);
                adapter.Fill(queryData);

                // USING STRING BUILDER
                //var JSONString = new StringBuilder();
                //if (queryData.Rows.Count > 0)
                //{
                //    JSONString.Append("[");
                //    for (int i = 0; i < queryData.Rows.Count; i++)
                //    {
                //        JSONString.Append("{");
                //        for (int j = 0; j < queryData.Columns.Count; j++)
                //        {
                //            if (j < queryData.Columns.Count - 1)
                //            {
                //                JSONString.Append("\"" + queryData.Columns[j].ColumnName.ToString() + "\":" + "\"" + queryData.Rows[i][j].ToString() + "\",");
                //            }
                //            else if (j == queryData.Columns.Count - 1)
                //            {
                //                JSONString.Append("\"" + queryData.Columns[j].ColumnName.ToString() + "\":" + "\"" + queryData.Rows[i][j].ToString() + "\"");
                //            }
                //        }
                //        if (i == queryData.Rows.Count - 1)
                //        {
                //            JSONString.Append("}");
                //        }
                //        else
                //        {
                //            JSONString.Append("},");
                //        }
                //    }
                //    JSONString.Append("]");
                //}
                //return JSONString.ToString();

                //USIING JsonConvert from Newtonsoft.Json
                string myString = DataTableToJSONWithJSONNet(queryData);
                return myString;
            }
            catch (Exception e)
            {
                return "{\"Exception\":\"" + e.Message + "\"}";
            }

        }

        public string DataTableToJSONWithJSONNet(DataTable table)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(table);
            return JSONString;
        }



        public void Dispose()
        {
            if (con != null)
            {
                con.Close();
            }
        }
    }
}