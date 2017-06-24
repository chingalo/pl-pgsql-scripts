DROP FUNCTION deleteOrganisationUnit(VARCHAR);

CREATE OR REPLACE FUNCTION deleteOrganisationUnit(orgunit VARCHAR) RETURNS VARCHAR AS $$
DECLARE
	orgUnit_regex VARCHAR;	
	temp_dir VARCHAR := '/home/chingalo/development/scripts/organisation-unit-app/data/'; --'data' folder is all backup storage folder during deletion process, it must have read and write permission 
	_c text;
	results VARCHAR;
BEGIN

	BEGIN
		---prepare filter for organisaion unit
		orgUnit_regex := CONCAT(CONCAT('%',orgunit),'%');
		
		
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: starting deletion process :::::::::::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::::::::::::::';
		
		
		--create backup and delete completeness of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM completedatasetregistration WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'completedatasetregistration_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM completedatasetregistration WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete data set assignemnts for given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM datasetsource WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'datasetsource_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM datasetsource WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete datavalues of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM datavalue WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'datavalue_'),orgunit),'.csv'));	
		EXECUTE format('DELETE FROM datavalue WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete datavalueaudit of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM datavalueaudit WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'datavalueaudit_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM datavalueaudit WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete program_organisationunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM program_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'program_organisationunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM program_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete trackedentitydatavalue of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM trackedentitydatavalue WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'trackedentitydatavalue_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM trackedentitydatavalue WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))',orgUnit_regex);
		
		--create backup and delete trackedentitydatavalueaudit of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM trackedentitydatavalueaudit WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'trackedentitydatavalueaudit_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM trackedentitydatavalueaudit WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))',orgUnit_regex);
		
		--create backup and delete programstageinstance of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'programstageinstance_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete chart_organisationunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM chart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'chart_organisationunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM chart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete eventchart_organisationunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM eventchart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'eventchart_organisationunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM eventchart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete eventreport_organisationunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM eventreport_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'eventreport_organisationunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM eventreport_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete interpretation of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM interpretation WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'interpretation_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM interpretation WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete mapview_organisationunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM mapview_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'mapview_organisationunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM mapview_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete orgunitgroupmembers of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM orgunitgroupmembers WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'orgunitgroupmembers_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM orgunitgroupmembers WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete reporttable_organisationunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM reporttable_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'reporttable_organisationunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM reporttable_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete userdatavieworgunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM userdatavieworgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'userdatavieworgunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM userdatavieworgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete usermembership of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM usermembership WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'usermembership_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM usermembership WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete userteisearchorgunits of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM userteisearchorgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'userteisearchorgunits_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM userteisearchorgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)',orgUnit_regex);
		
		--create backup and delete organisationunit of a given organisation unit and its children if any
		EXECUTE format('COPY(SELECT * FROM organisationunit WHERE path ILIKE %L) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'organisationunit_'),orgunit),'.csv'));
		EXECUTE format('DELETE FROM organisationunit WHERE path ILIKE %L',orgUnit_regex);
		
		--create backup and delete eventreport_organisationunits of a given organisation unit and its children if any
		--EXECUTE format(' TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT(CONCAT(temp_dir,'_'),orgunit),'.csv'));
		--EXECUTE format('',orgUnit_regex);
		
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: 	The end, Bye!!!!!!!!!! :::::::::::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::::::::::::::';
		results := 'success';
	
	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS _c = PG_EXCEPTION_CONTEXT;
		RAISE NOTICE 'context: >>%<<', _c;
		results := CONCAT('Fail to delete  : ',_c);
	END;
	
	RETURN results;
	
END;
$$
LANGUAGE plpgsql;

/*
 call delete function by pass orgunit id  zs9X8YYBOnK
 copy datavalue from '/tmp/old_population_datavalues_2015.csv' DELIMITER ',' CSV HEADER;
*/
SELECT deleteOrganisationUnit('zs9X8YYBOnK');


