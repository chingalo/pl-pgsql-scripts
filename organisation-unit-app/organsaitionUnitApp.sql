DROP FUNCTION deleteOrganisationUnit(VARCHAR);

CREATE OR REPLACE FUNCTION deleteOrganisationUnit(orgUnitId VARCHAR) RETURNS VOID AS $$
$$
DECLARE

BEGIN
	
	
	RAISE INFO 'orgUnitId to be delete is ',orgUnitId;	
END;
$$
LANGUAGE plpgsql;

/*
 call delete function by pass orgunit id
*/
SELECT deleteOrganisationUnit('joseph');

