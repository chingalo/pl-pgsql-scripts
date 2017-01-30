DROP FUNCTION organisationUnitsCodeGenerator();
DROP FUNCTION getOrganisationUnitsbyLevel();
DROP FUNCTION getParentOrganisationUnitCode(INT);
DROP FUNCTION updateOrganisationUnitCodes(INT,VARCHAR);
DROP TYPE holder;

-- ward level = 4, Village level = 5, water pint level = 6

--holder for some properties of orgunits 
CREATE  TYPE holder AS (organisationunitid INT,uid VARCHAR(11),name VARCHAR(50),code VARCHAR(50),hierarchylevel INT,parentid INT);

-- function to get all ordered by orgunits created dates
CREATE OR REPLACE FUNCTION  getOrganisationUnitsbyLevel() RETURNS SETOF holder AS 

	'SELECT organisationunitid,uid,name,code,hierarchylevel,parentid FROM organisationunit ORDER BY created ASC;' 
	language 'sql';
	

--function to update codes
CREATE OR REPLACE FUNCTION updateOrganisationUnitCodes(orgunitId INT, newCode VARCHAR) RETURNS VOID AS
$$
BEGIN
    UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId; --AND code = '';
     EXCEPTION WHEN  unique_violation THEN
		newCode :=CONCAT(newCode,orgunitId::TEXT);
		RAISE NOTICE 'vaolate uniqueness on orgunit with % and code %',orgunitId,newCode;
		--UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
   
		
		--UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
END;
$$
LANGUAGE plpgsql;


--replace loops with appropriate function
CREATE OR REPLACE FUNCTION getParentOrganisationUnitCode(parentid INT) RETURNS TEXT AS $$
	DECLARE
		organisationUnit holder%ROWTYPE;
		code TEXT := '';
	BEGIN		
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() LOOP
			IF organisationUnit.organisationunitid=parentid  THEN
				code := organisationUnit.code;
			END IF;
		END LOOP;		
		RETURN code;
	END;
	$$ LANGUAGE plpgsql; 


-- function for code generations
CREATE OR REPLACE FUNCTION organisationUnitsCodeGenerator() RETURNS VOID AS $$
	DECLARE
		--variable to holder types
		organisationUnit holder%ROWTYPE;
		waterPoint holder%ROWTYPE;
		districtLevel INT :=3;
		wardLevel INT :=4;
		villageLevel INT :=5;
		orgunitId INT;
		counter INT:= 0;
		newCode VARCHAR(50) :='';
		parentCode VARCHAR(50);
	BEGIN
		-- fix for testing parentid = 4096
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE hierarchylevel > wardLevel LOOP			
			parentCode := getParentOrganisationUnitCode(organisationUnit.parentid);
			IF  organisationUnit.hierarchylevel = villageLevel THEN
				orgunitId := organisationUnit.organisationunitid;
				RAISE INFO 'Starting code generation for % village at % ',organisationUnit.name,now();
				--checking for code uniqueness need to be redu
				newCode := upper(substr(organisationUnit.name,0,4));
				newCode := CONCAT(CONCAT(parentCode,'.'),newCode);
				
				--update codes 				
				PERFORM updateOrganisationUnitCodes(orgunitId,newCode);
				
				--RAISE INFO 'Starting code generation of water points for% village  at % ',organisationUnit.name,now();
				counter := 0;
				FOR waterPoint IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE parentid= organisationUnit.organisationunitid LOOP
					orgunitId = waterPoint.organisationunitid;
					counter := counter + 1;
					parentCode := getParentOrganisationUnitCode(waterPoint.parentid);
					--counter::text typecast interger into string
					IF counter > 9 THEN
						newCode := counter::text;
					ELSE
						newCode := CONCAT('0',counter::text);
					END IF;	
					newCode := CONCAT(CONCAT(parentCode,'.'),newCode);
					
					--update codes 				
					PERFORM updateOrganisationUnitCodes(orgunitId,newCode);
					
				END LOOP;
				RAISE INFO 'Ending code generation for % village at % ',organisationUnit.name,now();
			ELSE
			RAISE WARNING '******************skip code generation for % ***********',organisationUnit.name;
			END IF;	
			
		END LOOP;				
	END;
	$$ LANGUAGE plpgsql; 	

--- gerate codes
SELECT organisationUnitsCodeGenerator();
