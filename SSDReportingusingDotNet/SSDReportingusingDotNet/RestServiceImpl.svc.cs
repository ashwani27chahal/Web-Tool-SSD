using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using Teradata.Client.Provider;

namespace SSDReportingusingDotNet
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "RestServiceImpl" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select RestServiceImpl.svc or RestServiceImpl.svc.cs at the Solution Explorer and start debugging.
    public class RestServiceImpl : IRestServiceImpl
    {
        public string GetInventoryData(string SAPserialNumbers, string MAMserialNumbers)
        {

            TeraDataRetriever tds = new TeraDataRetriever("BOTERAPROD09", "TERADATAREADER", "TeradataReader", "DataTera01");
            if (!tds.connectionError)
            {
                string stringSQL;
               // stringSQL = "select * from WW_BE_DM.SAP_BATCH_SERIAL WHERE SERIAL_NO \n IN (" + SAPserialNumbers + ");";
                stringSQL = "WITH\n";
                stringSQL = stringSQL + " CTE_SAP AS\n";
                stringSQL = stringSQL + " (\n";
                stringSQL = stringSQL + "        SELECT      DISTINCT CUW.SERIAL_NO, CUW.WarrantyShipDate, S.SOLD_TO_NO, S.SOLD_TO_NAME\n";
                stringSQL = stringSQL + "        FROM        CTE_Union_Warranty                         CUW\n";
                stringSQL = stringSQL + "        INNER JOIN  WW_BE_DM.SAP_BATCH_SERIAL                  B\n";
                stringSQL = stringSQL + "        ON         (CUW.SERIAL_NO = B.SERIAL_NO)\n";
                stringSQL = stringSQL + "        INNER JOIN  WW_BE_DM.SAP_SHIPMENT                      S\n";
                stringSQL = stringSQL + "        ON         (S.BATCH_ID = B.BATCH_ID)\n";
                stringSQL = stringSQL + "        AND        (CUW.WarrantyShipDate = S.AGI_DATE)\n";
                stringSQL = stringSQL + "    ),\n";

                stringSQL = stringSQL + "    CTE_Union_Warranty AS\n";
                stringSQL = stringSQL + "    (\n";
                stringSQL = stringSQL + "           SELECT * FROM CTE_NonCPG_Serial\n";
                stringSQL = stringSQL + "           Union\n";
                stringSQL = stringSQL + "           SELECT * FROM CTE_CPG_SERIAL\n";
                stringSQL = stringSQL + "    ),\n";

                stringSQL = stringSQL + "    CTE_NonCPG_Serial AS\n";
                stringSQL = stringSQL + "    (\n";
                stringSQL = stringSQL + "           SELECT       B.SERIAL_NO, MAX(S.AGI_DATE) AS WarrantyShipDate\n";
                stringSQL = stringSQL + "           FROM         WW_BE_DM.SAP_SHIPMENT     S\n";
                stringSQL = stringSQL + "           INNER JOIN   WW_BE_DM.SAP_BATCH_SERIAL B\n";
                stringSQL = stringSQL + "           ON           (S.BATCH_ID = B.BATCH_ID)\n";
                stringSQL = stringSQL + "           WHERE        B.SERIAL_NO IN  (" + SAPserialNumbers + ")\n";
                stringSQL = stringSQL + "           AND          B.SERIAL_NO NOT IN (Select SERIAL_NO from CTE_CPG_SERIAL)\n";
                stringSQL = stringSQL + "           GROUP BY     B.SERIAL_NO\n";
                stringSQL = stringSQL + "    ),\n";

                stringSQL = stringSQL + "    CTE_CPG_SERIAL AS\n";
                stringSQL = stringSQL + "    (\n";
                stringSQL = stringSQL + "            SELECT       B.SERIAL_NO, MIN(S.AGI_DATE) AS WarrantyShipDate\n";
                stringSQL = stringSQL + "            FROM         WW_BE_DM.SAP_SHIPMENT     S\n";
                stringSQL = stringSQL + "            INNER JOIN   WW_BE_DM.SAP_BATCH_SERIAL B\n";
                stringSQL = stringSQL + "            ON           (S.BATCH_ID = B.BATCH_ID)\n";
                stringSQL = stringSQL + "            WHERE        B.SERIAL_NO IN  (" + SAPserialNumbers + ")\n";
                stringSQL = stringSQL + "                             \n";
                stringSQL = stringSQL + "           AND          S.SOLD_TO_No = '99991041'\n";
                stringSQL = stringSQL + "           GROUP BY    B.SERIAL_NO\n";
                stringSQL = stringSQL + "    ),\n";

                stringSQL = stringSQL + "    CTE_MAM AS\n";
                stringSQL = stringSQL + "    (\n";
                stringSQL = stringSQL + "    SELECT      DISTINCT CTE_RMA.*, MAM.ATTR_VALUE  AS Market_Segment\n";
                stringSQL = stringSQL + "    FROM        CTE_RMA\n";
                stringSQL = stringSQL + "    INNER JOIN  WW_BE_DM.MA_attr MAM\n";
                stringSQL = stringSQL + "    ON          CTE_RMA.MA_ID = MAM.MA_ID\n";
                stringSQL = stringSQL + "    WHERE       MAM.ATTR_ID   = 'MARKET SEGMENT'\n";
                stringSQL = stringSQL + "    AND         MAM.SYSTEM_NAME IN ('MAMQA','MAMQASI')\n";
                stringSQL = stringSQL + "    ),\n";

                stringSQL = stringSQL + "    CTE_RMA\n";
                stringSQL = stringSQL + "    AS\n";
                stringSQL = stringSQL + "    (\n";
                stringSQL = stringSQL + "           Select      CTE_MA.SerialID, CTE_MA.MA_ID,\n";
                stringSQL = stringSQL + "MA.ATTR_VALUE as RMA_ReceiveDate\n";
                stringSQL = stringSQL + "           FROM        CTE_MA\n";
                stringSQL = stringSQL + "           INNER JOIN  WW_BE_DM.MA_attr      MA\n";
                stringSQL = stringSQL + "           ON          CTE_MA.MA_ID = MA.MA_ID\n";
                stringSQL = stringSQL + "           WHERE       MA.ATTR_ID   = 'RMA RECEIVE DATE'\n";
                stringSQL = stringSQL + "           OR          MA.ATTR_ID   = 'RMA Receive Date'\n";
                stringSQL = stringSQL + "    ),\n";

                stringSQL = stringSQL + "    CTE_MA\n";
                stringSQL = stringSQL + "    AS\n";
                stringSQL = stringSQL + "    (\n";
                stringSQL = stringSQL + "    SELECT ATTR_VALUE as SerialID, MA_ID from\n";
                stringSQL = stringSQL + "    WW_BE_DM.MA_attr\n";
                stringSQL = stringSQL + "    WHERE ATTR_ID     IN ('MODULE SERIAL NUMBER' OR 'CUSTOMER SERIAL NO')\n";
                stringSQL = stringSQL + "    AND   SYSTEM_NAME IN ('MAMQA','MAMQASI')\n";
                stringSQL = stringSQL + "    AND   ATTR_VALUE IN  (" + MAMserialNumbers + ")\n";
                stringSQL = stringSQL + "    )\n";

                stringSQL = stringSQL + "    -- JOINING SAP AND MAM\n";

                stringSQL = stringSQL + "    SELECT      S.* , M.MA_ID, M.RMA_ReceiveDate, M.Market_Segment\n";
                stringSQL = stringSQL + "    FROM        CTE_MAM       M\n";
                stringSQL = stringSQL + "    INNER JOIN  CTE_SAP       S\n";
                stringSQL = stringSQL + "    ON          M.SERIALID = S.SERIAL_NO\n";

                stringSQL = stringSQL + "    Union\n";

                stringSQL = stringSQL + "    SELECT      S.* , M.MA_ID, M.RMA_ReceiveDate, M.Market_Segment\n";
                stringSQL = stringSQL + "    FROM        CTE_MAM       M\n";
                stringSQL = stringSQL + "    INNER JOIN  CTE_SAP       S\n";
                stringSQL = stringSQL + "    ON          M.SERIALID = SUBSTRING (S.SERIAL_NO FROM 4) ;\n";


                string jsonResult = tds.GetQueryResult(stringSQL);
                tds.Dispose();
                return jsonResult;
            }
            else
                return "{\"Exception\":\"" + tds.connectionErrorMessage + "\"}";
        }
    }
}
