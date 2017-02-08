DROP FUNCTION organisationUnitsCodeGenerator();
DROP FUNCTION getOrganisationUnits();
DROP TYPE holder;

-- ward level = 4, Village level = 5, water pint level = 6

--holder for some properties of orgunits 
CREATE  TYPE holder AS (organisationunitid INT,uid VARCHAR(11),name VARCHAR(50),code VARCHAR(50),hierarchylevel INT,parentid INT);

-- function to get all ordered by orgunits created dates
CREATE OR REPLACE FUNCTION  getOrganisationUnits() RETURNS SETOF holder AS 

	'SELECT organisationunitid,uid,name,code,hierarchylevel,parentid FROM organisationunit ORDER BY created ASC;' 
	language 'sql';
	

--function to update codes
CREATE OR REPLACE FUNCTION updateOrganisationUnitCodes(orgunitId INT, newCode VARCHAR) RETURNS VOID AS
$$
BEGIN
    UPDATE organisationunit  SET code = orgunitId WHERE organisationunitid = orgunitId;
    EXCEPTION WHEN  unique_violation THEN
		RAISE NOTICE 'vaolate uniqueness on orgunit with % and code %',orgunitId,newCode;   
END;
$$
LANGUAGE plpgsql;

-- function for code generations
CREATE OR REPLACE FUNCTION organisationUnitsCodeGenerator() RETURNS VOID AS $$
	DECLARE
		--variable to holder types
		organisationUnit holder%ROWTYPE;
		village holder%ROWTYPE;
		waterPoint holder%ROWTYPE;
		districtLevel INT :=3;
		wardLevel INT :=4;
		villageLevel INT :=5;
		orgunitId INT;
	BEGIN
		-- fix values  for testing parentid = 4096
		FOR organisationUnit IN SELECT * FROM getOrganisationUnits() WHERE hierarchylevel = wardLevel LOOP			
			RAISE INFO 'Starting preset codes in villages and water points in % ward ',organisationUnit.name;
			FOR village IN SELECT * FROM getOrganisationUnits() WHERE parentid = organisationUnit.organisationunitid LOOP
				orgunitId = village.organisationunitid;
				PERFORM updateOrganisationUnitCodes(orgunitId,'');
				FOR waterPoint IN SELECT * FROM getOrganisationUnits() WHERE parentid = village.organisationunitid LOOP
					orgunitId = waterPoint.organisationunitid;
					PERFORM updateOrganisationUnitCodes(orgunitId,'');
					
				END LOOP;				
			END LOOP;
		
			RAISE INFO 'Ending preset codes in villages and water points in % ward ',organisationUnit.name;			
		END LOOP;				
	END;
	$$ LANGUAGE plpgsql; 	

--- gerate codes
SELECT organisationUnitsCodeGenerator();
