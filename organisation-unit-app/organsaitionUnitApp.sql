DROP FUNCTION deleteOrganisationUnit(VARCHAR);

CREATE OR REPLACE FUNCTION deleteOrganisationUnit(orgunit VARCHAR) RETURNS VOID AS $$
DECLARE
	orgUnit_regex VARCHAR;

BEGIN
	RAISE INFO 'orgUnitId to be delete is %',orgunit;
	orgUnit_regex := CONCAT(CONCAT('%',orgunit),'%');
	RAISE INFO 'orgUnit_regex to be delete is %',orgUnit_regex;
	
	EXECUTE format('COPY((SELECT * FROM organisationunit WHERE path ILIKE %L)) TO %L WITH CSV HEADER;',orgUnit_regex,CONCAT(CONCAT('/home/chingalo/development/scripts/organisation-unit-app/data/orgunit_',orgunit),'.csv'));	
END;
$$
LANGUAGE plpgsql;

/*
 call delete function by pass orgunit id
*/
SELECT deleteOrganisationUnit('CAWjYmd5Dea');


