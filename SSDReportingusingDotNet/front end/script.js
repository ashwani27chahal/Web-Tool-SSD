//STEPS performed after completing the front-end design:
//------------------------------------------------------------
//1. We have a 'submit button' on the frontend clicking which will trigger an event. This event is defined in $("#SubmitResults").click(function(){
//2. This event raises an ajax request (of type POST)  - $.ajax()
//3. This request posts the data collected from the front end - input box and hits the teradata server
//4. In return of this request, we get a JSON document containing the server response 
//5. This JSON document is parsed using JSON.parse() which converts it to a JavaScript object 
//6. We can traverse through this objectusing $.each(object, function(key,value)) and saggregate the columns 
//7. The result is displayed in a tabular form on the webpage
//8. We have used JQuery (a library of JavaScript) to do our front end coding and send Ajax request
//9. Server side coding is done using NodeJS (a JavaScript based language for backend)
//10. The database used is - TeraData
//                                                 



$(document).ready(function(){
//we use ready to make sure that the the script loads only afther the webpage(document) is ready(loaded) 
			
			    //click event for the submit button
    $("#SubmitResults").click(function () {
                                
                                
                                
        //Data from the input box is being collected here 
                                var ids = $("#serialNumbers").val().split(/\n/);
                                console.log(ids);
                                var SAParray = [];
                                var MAMarray = [];
                                ids.forEach(function (entry) {
                                    if(entry != ""){
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
                                var SAPCommaSeparatedIds = SAParray.join(",");
                                var MAMCommaSeparatedIds = MAMarray.join(",");
        
                                console.log("SAP: " + SAPCommaSeparatedIds);
                                console.log("MAM: " + MAMCommaSeparatedIds);
                                $("#loadingIndicator").show();
                               
        
        //An ajax request to take the data from the frontend to backend asynchronously which in turn responds with a Json document 
                                $.ajax({ 
                                    type: 'GET',
                                    cache: false,
                                    timeout: 119000,
                                    crossDomain: true,
                                    error: function (jqXhr, statusText, errorThrown) { 
                                        alert(statusText + ": Teradata is slow. Please try again later after 5 minutes") ;  
                                        $("#loadingIndicator").hide();
                                    } ,

                                    url: 'http://localhost:53518/RestServiceImpl.svc/json/' + SAPCommaSeparatedIds + '/' + MAMCommaSeparatedIds, 
                                    success: function (response) {
                                        $("#loadingIndicator").hide();
                                        if(response.GetInventoryDataResult.length>0){
                                                var data = response.GetInventoryDataResult;
                                                console.log(data);
                                                populateTable(data); 

							             }
							             else
							             {                                    
							        	    alert("No data found.");
                                         }
                                    }

						      });
                            
                          
                            
                            

				});


				function populateTable(jsonData){
												$.each(JSON.parse(jsonData), function(k, v) {

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
												 	inWarranty="Invalid first character in MarketSegment.";
												 resultRow += yearsDiff+"</td><td>"+inWarranty+"</td></tr>";
                                                console.log(yearsDiff);
                                                    console.log(resultRow);

												//alert(resultRow);
									            $('#ResultTable tbody').append($(resultRow));
								        	});
								          	$('#demotable').show();
                                            
				}
    

                //click event for the Reset button
                $("#ClearResults").click(function(){
                    $('#serialNumbers').val(''); 
                    $('#demotable').hide();
                    $("#loadingIndicator").hide();
                    $("#ResultTable tr td").remove();
                });
		    
});


