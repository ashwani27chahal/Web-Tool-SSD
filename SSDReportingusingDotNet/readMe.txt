


--------------------------------------------
To create the the RESTful service we have to create the WCF service as it is created then we have to make certain changes in Service interface and web.config.

Just a basic example: 





The Iservice interface
-----------------------


Using System;
using System.ServiceModel.Web;

namespace BasicRest
{
     [ServiceContract]
     interface IService
     {    

         // this contract is using Http get  method of Restful services
          [OperationContract()]
          [WebGet(UriTemplate="/welcom/{name}?format=json", ResponseFormat=WebMessageFormat.Json)]
          public string Welcom(string name);
          
          // this contract is using Http put  method of Restful services
          [OperationContract()]
          [WebInvoke(UriTemplate="/message/{name}?format=json,") ResponseFormat=WebMessageFormat.Json, method="PUT"]
          public string Message(string name); 
     }
}

 

Implement this interface in in you service class and define the method Welcom and Message As per your way.


Then make these changes to web .config file:

<configuration>


<system.serviceModel>
<services>
<service name="service">
<endpoint address="http://localhost:1234/" contract="IService" binding="webHttpBinding" behaviorConfiguration="myconfig"/>

</service>
</services>
<behaviors>
 <endpointBehavior>
   <behavior name="myconfig">
   <webHttp/>
   </behavior>
  </endpointBehavior>
</behaviors>
</system.ServiceModel>

<configuration>

* the important note use of webHttpbinding  and WebInvoke And WebGet attribute


----------------------------------------------------------------------------------------------------
A Guide to Designing and Building RESTful Web Services with WCF 3.5:
https://msdn.microsoft.com/en-us/library/dd203052.aspx



How to create a JSON WCF RESTful Service in 60 seconds (returns JSON) -- easiest one
https://www.codeproject.com/Articles/167159/How-to-create-a-JSON-WCF-RESTful-Service-in-60-sec



Create RESTful WCF Service API: Step By Step Guide (returns JSON)
https://www.codeproject.com/Articles/105273/Create-RESTful-WCF-Service-API-Step-By-Step-Guide



WCF Web Services (JSON)    -- best resource that explains every statement
http://mikesknowledgebase.com/pages/Services/WebServices-Page1.htm


-------------------------------------------------------------------------
3 WAYS TO CONVERT A DATA TABLE TO JSON:

http://www.c-sharpcorner.com/UploadFile/9bff34/3-ways-to-convert-datatable-to-json-string-in-Asp-Net-C-Sharp/







------------------------------- FORMAT RECEIVED ----------------------------

{"GetInventoryDataResult":"[{\"SERIAL_NO\":\"ZAV090QS\",\"WarrantyShipDate\":\"2016-05-11T00:00:00\",\"SOLD_TO_NO\":\"99991041\",\"SOLD_TO_NAME\":\"MICRON CONSUMER PRODUCTS GROUP,\",\"MA_ID\":\"CVAENL3A01\",\"RMA_ReceiveDate\":\"2016-12-07 00:00:00\",\"Market_Segment\":\"S650DC\"}]"}


-----------------------------------------------------


GITHUB REPO USING ISUAL STUDIO 2015
https://www.infragistics.com/community/blogs/dhananjay_kumar/archive/2016/07/21/step-by-step-working-with-github-repository-and-visual-studio-2015.aspx