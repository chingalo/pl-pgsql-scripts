prepareSmsCode();
function prepareSmsCode (){
	var DHIS2URL = "http://localhost:8080/dhis/api/dataSets.json";
	var formCode = "HMIS";
 $.ajax({
		url: DHIS2URL ,
		type: 'GET',
		data:'paging=false&filter=name:ilike:HMIS&fields=id,name,dataSetElements[dataElement[id,name,translations,lastUpdated,created,externalAccess,displayName,categoryCombo[categoryOptionCombos[id,name]]]]',
	}).done( function(response) {
		var dataSets = response.dataSets;		
		for(dataSetIndex = 0;dataSetIndex < dataSets.length; dataSetIndex++ ){
			var secondValue = 0;
			var dataSet = dataSets[dataSetIndex];
			var smsCommand = {
			  "commandName": dataSet.id,
			  "parserType": "KEY_VALUE_PARSER",
			  "separator": ":",
			  "smsCode": []
			};
			var dataSetElements = dataSet.dataSetElements;				
			for(dataSetElementIndex = 0;dataSetElementIndex < dataSetElements.length; dataSetElementIndex++ ){				
				var dataElement = dataSetElements[dataSetElementIndex].dataElement;
				for(categoryOptionCombosIndex = 0;categoryOptionCombosIndex < dataElement.categoryCombo.categoryOptionCombos.length; categoryOptionCombosIndex++ ){
					var categoryOptionCombos = dataElement.categoryCombo.categoryOptionCombos[categoryOptionCombosIndex];
					secondValue ++;
					var smsCode = {
					  "smsCode": formCode+dataSetIndex+secondValue,
					  "dataElement": {
						"name": dataElement.name,
						"created": dataElement.created,
						"lastUpdated": dataElement.lastUpdate,
						"translations": dataElement.translations,
						"externalAccess": false,
						"displayName": dataElement.displayNa,
						"id": dataElement.id
					  },
					  "compulsory": false,
					  "categoryOptionCombos":categoryOptionCombos.id
					};
					//push sms code into given sms command
					smsCommand.smsCode.push(smsCode);
				}
			}
			
			console.log("");
			console.log(JSON.stringify(smsCommand))
		}
		
	});
}
