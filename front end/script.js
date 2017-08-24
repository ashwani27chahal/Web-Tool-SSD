//STEPS performed after completing the front-end design:
//--------------------------------------------------------------------------------------------------------------------------------------------------
//1. We have a 'submit button' on the frontend clicking which will trigger an event. This event is defined in $("#SubmitResults").click(function(){
//2. This event raises an ajax request (of type POST)  - $.ajax()
//3. This request posts the data collected from the front end - input box and hits the teradata server
//4. In return of this request, we get a JSON document containing the server response 
//5. This JSON document is parsed using JSON.parse() which converts it to a JavaScript object 
//6. We can traverse through this object using $.each(object, function(key,value)) and saggregate the columns 
//7. The result is displayed in a tabular form on the webpage
//8. We have used JQuery (a library of JavaScript) to do our front end coding and send Ajax request
//9. Server side coding is done using NodeJS (a JavaScript based language for backend)
//10. The database used is - TeraData

                                                

//we use ready to make sure that the the script loads only afther the webpage(document) is ready(loaded) 
$(document).ready(function () {
    'use strict';
    
    
    //Click event for the submit button - BOISE SERVER
    $("#SubmitBoiseResults").click(function () {                                
        //Data from the input box is being collected here 
        var ids = $("#serialNumbers").val().split(/\n/);
		if (ids[0].length === 0){
			alert ("no serial IDs entered.");
        }

		else {
            var SAParray = [];
            var MAMarray = [];
            var countInput = 0;
           
            ids.forEach(function (entry) {
                if(entry != ""){
                    countInput = countInput + 1;
                    entry = entry.trim();
                    SAParray.push("'" + entry + "'");
                    if (entry.substr(0,3) === "11S") {
                        MAMarray.push("'" + entry.substr(3) + "'");
                    }
                    else{
                        MAMarray.push("'" + entry + "'");
                    }
                }
            });
            
            console.log("Values Entered: " + countInput);
            $( "#inputCount" ).append(countInput);
            var SAPCommaSeparatedIds = SAParray.join(",");
            var MAMCommaSeparatedIds = MAMarray.join(",");
            console.log("SAP: " + SAPCommaSeparatedIds);
            console.log("MAM: " + MAMCommaSeparatedIds);
            $("#loadingIndicator").show();                       

            //An ajax request to take the data from the frontend to backend asynchronously which in turn responds with a Json document 
            $.ajax({ 
                type: 'GET',
                cache: false,
                timeout: 1200000,
                crossDomain: true,
                // http://localhost:53518/RestServiceImpl.svc/json/ 
                url: 'http://localhost:53518/RestServiceImpl.svc/boise/' + SAPCommaSeparatedIds + '/' + MAMCommaSeparatedIds, 
                success: function (response) {
                    $("#loadingIndicator").hide();
                    console.log("response is:" + response);
                    if (response.GetInventoryDataResult.length > 2) {
                        var tableData = response.GetInventoryDataResult;
                        populateTable(tableData); 
                    }
                    else
                    {                                    
                        $('#demotable').show();
                        alert("No data found for the entered SerialIDs.");

                    }
                },
                error: function (jqXhr, statusText, errorThrown) { 
                    console.log("readyState:" + jqXhr.readyState + "responseText:" +  jqXhr.responseText + "StatusCode:" + jqXhr.status + "statusText:" + jqXhr.statusText);
                    if (jqXhr.readyState === 4) {
                        alert("Please enter some valid Serial Numbers");
                    }
                    else if (jqXhr.readyState === 0) {
                        alert ("Either Teradata is slow or Web Server is down. Please try again after 5 minutes or contact us for support");
                    }
                    else {
                        alert("Some error occured. Please contact us");
                    } 
                    $("#loadingIndicator").hide();
                }

            });
        }
    });

    
    //Click event for the submit button - SINGAPORE SERVER
    $("#SubmitSingaporeResults").click(function () {                                
        //Data from the input box is being collected here 
        var ids = $("#serialNumbers").val().split(/\n/);
		if (ids[0].length === 0){
			alert ("no serial IDs entered.");
        }

		else {
            var SAParray = [];
            var MAMarray = [];
            var countInput = 0;
           
            ids.forEach(function (entry) {
                if(entry != ""){
                    countInput = countInput + 1;
                    entry = entry.trim();
                    SAParray.push("'" + entry + "'");
                    if (entry.substr(0,3) === "11S") {
                        MAMarray.push("'" + entry.substr(3) + "'");
                    }
                    else{
                        MAMarray.push("'" + entry + "'");
                    }
                }
            });
            
            console.log("Values Entered: " + countInput);
            $( "#inputCount" ).append(countInput);
            var SAPCommaSeparatedIds = SAParray.join(",");
            var MAMCommaSeparatedIds = MAMarray.join(",");
            console.log("SAP: " + SAPCommaSeparatedIds);
            console.log("MAM: " + MAMCommaSeparatedIds);
            $("#loadingIndicator").show();                       

            //An ajax request to take the data from the frontend to backend asynchronously which in turn responds with a Json document 
            $.ajax({ 
                type: 'GET',
                cache: false,
                timeout: 1200000,
                crossDomain: true,
                // http://localhost:53518/RestServiceImpl.svc/json/ 
                url: 'http://localhost:53518/RestServiceImpl.svc/singapore/' + SAPCommaSeparatedIds + '/' + MAMCommaSeparatedIds, 
                success: function (response) {
                    $("#loadingIndicator").hide();
                    console.log("response is:" + response);
                    if (response.GetInventoryDatafromSingaporeResult.length > 2) {
                        var tableData = response.GetInventoryDatafromSingaporeResult;
                        populateTable(tableData); 
                    }
                    else
                    {                                    
                        $('#demotable').show();
                        alert("No data found for the entered SerialIDs.");

                    }
                },
                error: function (jqXhr, statusText, errorThrown) { 
                    console.log("readyState:" + jqXhr.readyState + "responseText:" +  jqXhr.responseText + "StatusCode:" + jqXhr.status + "statusText:" + jqXhr.statusText);
                    if (jqXhr.readyState === 4) {
                        alert("Please enter some valid Serial Numbers");
                    }
                    else if (jqXhr.readyState === 0) {
                        alert ("Either Teradata is slow or Web Server is down. Please try again after 5 minutes or contact us for support");
                    }
                    else {
                        alert("Some error occured. Please contact us");
                    } 
                    $("#loadingIndicator").hide();
                }

            });
        }
    });
    
    
	
    //Dsiplaying results of the request in form of table
    function populateTable(jsonData){
         var countOutput = 0;
        $.each(JSON.parse(jsonData), function(k, v) {
            countOutput = countOutput + 1;
            var resultRow="<tr class=\"text-center\"><td>"+v.MA_ID+"</td><td>"+
                v.SERIAL_NO+"</td><td>"+v.WarrantyShipDate+"</td><td>"+v.RMA_ReceiveDate+
                "</td><td>"+v.SOLD_TO_NO+"</td><td>"+v.SOLD_TO_NAME+"</td><td>"+v.Market_Segment+
                "</td><td>";
            var rma = v.RMA_ReceiveDate.split(' ').join('T');
            var rmaReceivedDate = new Date(rma);
            var WarrantyShipmentDate = new Date(v.WarrantyShipDate);
            var r = rmaReceivedDate.getFullYear() ;
            var w = WarrantyShipmentDate.getFullYear();
            var yearsDiff =  r - w;
            var marketSegmentFirstChar = v.Market_Segment.substring(0, 1).toUpperCase();
            var inWarranty="";
            if(marketSegmentFirstChar=="C" || marketSegmentFirstChar=="M" || marketSegmentFirstChar=="1")
            {
                if(yearsDiff>3)
                    inWarranty="No";
                else
                    inWarranty="Yes";
                
            }
                                                        
            else if(marketSegmentFirstChar=="P" || marketSegmentFirstChar=="9" || marketSegmentFirstChar=="S")
            {
                if(yearsDiff>5)
                    inWarranty="No";
                else
                    inWarranty="Yes";
            }
            else
            {
                inWarranty="Invalid first character in MarketSegment.";
            }
            
            resultRow += yearsDiff+"</td><td>"+inWarranty+"</td></tr>";
			if (resultRow.length === 0) {
				alert ("No data found for the entered SerialIDs.");
			}
            $('#ResultTable tbody').append($(resultRow));
        });
        $( "#outputCount").append(countOutput);
        console.log("Number of rows returned: " + countOutput)
        $('#demotable').show();
                                                
    }
        

    //Click event for the Reset button
    $("#ClearResults").click(function(){
        location.reload(true);   //refreshes the page and 'true' parameter is to release the cache
    });
    
    //Click event for export results
    $("#exportButton").click(function() {
        $('#ResultTable').tableExport({type:'xlsx'});
    });
    
	   	    
});