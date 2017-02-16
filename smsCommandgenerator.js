prepareSmsCode();
function prepareSmsCode (){
	var DHIS2URL = "http://localhost:8080/dhis/api/dataSets.json";
	var formCode = "HMIS";
	var smsCommndsObject = [];
	var smsCommandDefault = {
		  "commandName": "",
		  "parserType": "KEY_VALUE_PARSER",
		  "separator": ":",
		  "smsCode": []
		}
		var smsCodeDefault = {
		  "smsCode": formCode,
		  "dataElement": {
			"name": "",
			"created": "",
			"lastUpdated": "",
			"translations": [],
			"externalAccess": false,
			"displayName": "",
			"id": ""
		  },
		  "compulsory": false,
		  "categoryOptionCombos":""
		};
 $.ajax({
		url: DHIS2URL ,
		type: 'GET',
		data:'paging=false&filter=name:ilike:HMIS&fields=id,name,dataSetElements[dataElement[id,name,translations,lastUpdated,created,externalAccess,displayName,categoryCombo[categoryOptionCombos[id,name]]]]',
	}).done( function(response) {
		response.dataSets.forEach(function(dataSet,dataSetIndex){
			var smsCommand = smsCommandDefault;
			smsCommand.commandName = dataSet.id;
			dataSet.dataSetElements.forEach(function(dataSetElement,dataSetElementIndex){
				var dataElement = dataSetElement.dataElement;
				dataElement.categoryCombo.categoryOptionCombos.forEach(function(categoryOptionCombos,categoryOptionCombosIndex){
					var smsCode = smsCodeDefault;
					smsCode.smsCode = smsCode.smsCode+dataSetIndex+categoryOptionCombosIndex;
					smsCode.dataElement.name = dataElement.name;
					smsCode.dataElement.created = dataElement.created;
					smsCode.dataElement.lastUpdated = dataElement.lastUpdated;
					smsCode.dataElement.translations = dataElement.translations;
					smsCode.dataElement.externalAccess = dataElement.externalAccess;
					smsCode.dataElement.displayName = dataElement.displayName;
					smsCode.dataElement.id = dataElement.id;
					smsCode.dataElement.categoryOptionCombos = categoryOptionCombos.id;
					//push sms code into given sms command
					smsCommand.push(smsCode);
				});
			});
			//smscomand to overall sms command object
			smsCommndsObject.push(smsCommand);
			console.log("=========================");
		});
		console.log(smsCommndsObject);
	});
}
