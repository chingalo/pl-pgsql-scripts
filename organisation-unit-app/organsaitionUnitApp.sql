DROP FUNCTION deleteOrganisationUnit(VARCHAR);

CREATE OR REPLACE FUNCTION deleteOrganisationUnit(orgunit VARCHAR) RETURNS VOID AS $$
DECLARE
	organsationUnit RECORD;

BEGIN
	RAISE INFO 'orgUnitId to be delete is %',orgunit;
	EXECUTE format('COPY((SELECT * FROM organisationunit WHERE uid = %L)) TO %L WITH CSV HEADER;',orgunit,CONCAT(CONCAT('/home/chingalo/development/scripts/organisation-unit-app/data/orgunit_',orgunit),'.csv'));	
END;
$$
LANGUAGE plpgsql;

/*
 call delete function by pass orgunit id
*/
SELECT deleteOrganisationUnit('CAWjYmd5Dea');


