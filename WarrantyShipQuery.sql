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
       WHERE        B.SERIAL_NO IN  ('1332038439F4',
       								'133203843F98',
       								'133303866CBC',
       								'1338038A8868',
       								'1341038CE73C',
       								'1341038CFB28',
       								'1343038F9A40',
       								'1343038FD384',
       								'13510398CD00',
       								'1352039905DC',
       								'1406039E3205',
       								'14090C067014',
       								'14300CE603C2',
       								'14320CF53F21',
       								'143311DDD077',
       								'14340D009065',
       								'14340DAEC23E',
       								'14340DB4770A',
       								'14360D2BAD20',
       								'14360E5D381B',
       								'14410D7C1278',
       								'14430EE0BE80',
       								'1443101E252D',
       								'14500E0C90FD',
       								'14510E2039B0',
       								'15010E5B828F',
       								'15010E5BBDCA',
       								'15060EA9D5E0',
       								'15060EAC630A',
       								'15060EB44D2C',
       								'15070EC0D92E',
       								'15070EC0D938',
       								'15090EDEAE94',
       								'151012759DD1',
       								'15140F3CE065',
       								'15150F3F56A2',
       								'15170F6E80DB',
       								'15170FDE3CA1',
       								'15170FDE3D29',
       								'151911522117',
       								'15200F8D4AAC',
       								'152510DB692B',
       								'152810491EA6',
       								'152810492ACD',
       								'154510FBF34E',
       								'15461116E6C6',
       								'154711453C32',
       								'15501138F74E',
       								'155111910153',
       								'160311BE74F6',
       								'16051213751C',
       								'160711D78E7B',
       								'1607122FFAEA',
       								'160811E83B4D',
       								'1609120A6ADC',
       								'160912472FEC',
       								'161812B949B7',
       								'16321393CA2C',
       								'163213955BB9',
       								'1633139D7CA8',
       								'163513DBB376',
       								'1638140ECAE5',
       								'164214515215',
       								'164414953DB3',
       								'164614A215BE',
       								'164614AA2A74',
       								'164814D1C34C',
       								'16521523D000',
       								'1701153D4F46',
       								'1703157E0CA7',
       								'170415A25D6F',
       								'170415A2D6E2',
       								'170615B47883',
       								'17091615D688',
       								'1719170A43CD')                                                                
       AND          B.SERIAL_NO NOT IN (Select SERIAL_NO from CTE_CPG_SERIAL)
       GROUP BY     B.SERIAL_NO
),
       
CTE_CPG_SERIAL AS
(
		SELECT       B.SERIAL_NO, MIN(S.AGI_DATE) AS WarrantyShipDate 
		FROM         WW_BE_DM.SAP_SHIPMENT     S
		INNER JOIN   WW_BE_DM.SAP_BATCH_SERIAL B
		ON           (S.BATCH_ID = B.BATCH_ID)
		WHERE        B.SERIAL_NO IN   ('1332038439F4',
       								'133203843F98',
       								'133303866CBC',
       								'1338038A8868',
       								'1341038CE73C',
       								'1341038CFB28',
       								'1343038F9A40',
       								'1343038FD384',
       								'13510398CD00',
       								'1352039905DC',
       								'1406039E3205',
       								'14090C067014',
       								'14300CE603C2',
       								'14320CF53F21',
       								'143311DDD077',
       								'14340D009065',
       								'14340DAEC23E',
       								'14340DB4770A',
       								'14360D2BAD20',
       								'14360E5D381B',
       								'14410D7C1278',
       								'14430EE0BE80',
       								'1443101E252D',
       								'14500E0C90FD',
       								'14510E2039B0',
       								'15010E5B828F',
       								'15010E5BBDCA',
       								'15060EA9D5E0',
       								'15060EAC630A',
       								'15060EB44D2C',
       								'15070EC0D92E',
       								'15070EC0D938',
       								'15090EDEAE94',
       								'151012759DD1',
       								'15140F3CE065',
       								'15150F3F56A2',
       								'15170F6E80DB',
       								'15170FDE3CA1',
       								'15170FDE3D29',
       								'151911522117',
       								'15200F8D4AAC',
       								'152510DB692B',
       								'152810491EA6',
       								'152810492ACD',
       								'154510FBF34E',
       								'15461116E6C6',
       								'154711453C32',
       								'15501138F74E',
       								'155111910153',
       								'160311BE74F6',
       								'16051213751C',
       								'160711D78E7B',
       								'1607122FFAEA',
       								'160811E83B4D',
       								'1609120A6ADC',
       								'160912472FEC',
       								'161812B949B7',
       								'16321393CA2C',
       								'163213955BB9',
       								'1633139D7CA8',
       								'163513DBB376',
       								'1638140ECAE5',
       								'164214515215',
       								'164414953DB3',
       								'164614A215BE',
       								'164614AA2A74',
       								'164814D1C34C',
       								'16521523D000',
       								'1701153D4F46',
       								'1703157E0CA7',
       								'170415A25D6F',
       								'170415A2D6E2',
       								'170615B47883',
       								'17091615D688',
       								'1719170A43CD')                   
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
		AND   ATTR_VALUE IN  ('1332038439F4',
       								'133203843F98',
       								'133303866CBC',
       								'1338038A8868',
       								'1341038CE73C',
       								'1341038CFB28',
       								'1343038F9A40',
       								'1343038FD384',
       								'13510398CD00',
       								'1352039905DC',
       								'1406039E3205',
       								'14090C067014',
       								'14300CE603C2',
       								'14320CF53F21',
       								'143311DDD077',
       								'14340D009065',
       								'14340DAEC23E',
       								'14340DB4770A',
       								'14360D2BAD20',
       								'14360E5D381B',
       								'14410D7C1278',
       								'14430EE0BE80',
       								'1443101E252D',
       								'14500E0C90FD',
       								'14510E2039B0',
       								'15010E5B828F',
       								'15010E5BBDCA',
       								'15060EA9D5E0',
       								'15060EAC630A',
       								'15060EB44D2C',
       								'15070EC0D92E',
       								'15070EC0D938',
       								'15090EDEAE94',
       								'151012759DD1',
       								'15140F3CE065',
       								'15150F3F56A2',
       								'15170F6E80DB',
       								'15170FDE3CA1',
       								'15170FDE3D29',
       								'151911522117',
       								'15200F8D4AAC',
       								'152510DB692B',
       								'152810491EA6',
       								'152810492ACD',
       								'154510FBF34E',
       								'15461116E6C6',
       								'154711453C32',
       								'15501138F74E',
       								'155111910153',
       								'160311BE74F6',
       								'16051213751C',
       								'160711D78E7B',
       								'1607122FFAEA',
       								'160811E83B4D',
       								'1609120A6ADC',
       								'160912472FEC',
       								'161812B949B7',
       								'16321393CA2C',
       								'163213955BB9',
       								'1633139D7CA8',
       								'163513DBB376',
       								'1638140ECAE5',
       								'164214515215',
       								'164414953DB3',
       								'164614A215BE',
       								'164614AA2A74',
       								'164814D1C34C',
       								'16521523D000',
       								'1701153D4F46',
       								'1703157E0CA7',
       								'170415A25D6F',
       								'170415A2D6E2',
       								'170615B47883',
       								'17091615D688',
       								'1719170A43CD')              
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


