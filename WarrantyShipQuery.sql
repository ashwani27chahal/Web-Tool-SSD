-- Final table from SAP Database
WITH
CTE_SAP AS
(
       SELECT      DISTINCT CUW.SERIAL_NO, CUW.WarrantyShipDate, S.SOLD_TO_NO, S.SOLD_TO_NAME
       FROM        CTE_Union_Warranty                         CUW
       INNER JOIN  WW_BE_DM.SAP_BATCH_SERIAL                  B
       ON         (CUW.SERIAL_NO = B.SERIAL_NO)
       INNER JOIN  WW_BE_DM.SAP_SHIPMENT                      S
       ON         (S.BATCH_ID = B.BATCH_ID)
       AND        (CUW.WarrantyShipDate = S.AGI_DATE)
),

CTE_Union_Warranty AS
(
       SELECT * FROM CTE_NonCPG_Serial
       UNION
       SELECT * FROM CTE_CPG_SERIAL
),
       
CTE_NonCPG_Serial AS 
(
       SELECT       B.SERIAL_NO, MAX(S.AGI_DATE) AS WarrantyShipDate 
       FROM         WW_BE_DM.SAP_SHIPMENT     S
       INNER JOIN   WW_BE_DM.SAP_BATCH_SERIAL B
       ON           (S.BATCH_ID = B.BATCH_ID)
       WHERE        B.SERIAL_NO IN  (Serial IDs here')                                                             
       AND          B.SERIAL_NO NOT IN (Select SERIAL_NO from CTE_CPG_SERIAL)
       GROUP BY     B.SERIAL_NO
),
       
CTE_CPG_SERIAL AS
(
		SELECT       B.SERIAL_NO, MIN(S.AGI_DATE) AS WarrantyShipDate 
		FROM         WW_BE_DM.SAP_SHIPMENT     S
		INNER JOIN   WW_BE_DM.SAP_BATCH_SERIAL B
		ON           (S.BATCH_ID = B.BATCH_ID)
		WHERE        B.SERIAL_NO IN   (Batch IDs here)                   
	    AND          S.SOLD_TO_No = '99991041'      
	    GROUP BY     B.SERIAL_NO
),


-- Final table from MAM Database
CTE_MAM AS
(
		SELECT      DISTINCT CTE_RMA.*, MAM.ATTR_VALUE  AS Market_Segment
		FROM        CTE_RMA
		INNER JOIN  WW_BE_DM.MA_attr MAM
		ON          CTE_RMA.MA_ID = MAM.MA_ID
		WHERE       MAM.ATTR_ID = 'MARKET SEGMENT'
		AND         MAM.SYSTEM_NAME IN ('MAMQA','MAMQASI')
),


CTE_RMA 
AS
(
       Select      CTE_MA.SerialID, CTE_MA.MA_ID,  MA.ATTR_VALUE as RMA_ReceiveDate
       FROM        CTE_MA                
       INNER JOIN  WW_BE_DM.MA_attr      MA
       ON          CTE_MA.MA_ID = MA.MA_ID
       WHERE       MA.ATTR_ID = 'RMA RECEIVE DATE'
       AND         MA.SYSTEM_NAME IN ('MAMQA','MAMQASI')
),

CTE_MA
AS
(
	SELECT * FROM CTE_MA_ALL WHERE MA_ID NOT IN (SELECT MA_ID FROM CTE_MA_Rework)
),


CTE_MA_Rework 
AS
(			SELECT MA_ID  
			FROM   WW_BE_DM.MA_attr 
			WHERE  MA_ID IN (SELECT MA_ID FROM CTE_MA_ALL)
			AND    SYSTEM_NAME IN ('MAMQA','MAMQASI')
			AND    ATTR_ID     = 'REWORK TYPE'
			AND    ATTR_VALUE = 'COMPONENT REMOVAL'
		
),


CTE_MA_ALL
AS
(
		SELECT ATTR_VALUE as SerialID, MA_ID from 
		WW_BE_DM.MA_attr 
		WHERE ATTR_ID     IN ('MODULE SERIAL NUMBER', 'CUSTOMER SERIAL NO')
		AND   SYSTEM_NAME IN ('MAMQA','MAMQASI')
		AND   ATTR_VALUE IN  ()              
)


-- JOINING SAP AND MAM

SELECT      S.* , M.MA_ID, M.RMA_ReceiveDate, M.Market_Segment 
FROM        CTE_MAM       M 
INNER JOIN  CTE_SAP       S
ON          M.SERIALID = S.SERIAL_NO 

UNION

SELECT      S.* , M.MA_ID, M.RMA_ReceiveDate, M.Market_Segment 
FROM        CTE_MAM       M 
INNER JOIN  CTE_SAP       S
ON          M.SERIALID = SUBSTRING (S.SERIAL_NO FROM 4) ;


