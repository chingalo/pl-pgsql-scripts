DROP FUNCTION organisationUnitsCodeGenerator();
DROP FUNCTION getOrganisationUnitsbyLevel();
DROP FUNCTION getParentOrganisationUnitCode(INT);
DROP FUNCTION updateOrganisationUnitCodes(INT,VARCHAR);
DROP FUNCTION getVillageCode(INT,INT,INT,VARCHAR,VARCHAR);
DROP FUNCTION generateVillageCode(INT,INT,INT,VARCHAR,VARCHAR);
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
    UPDATE organisationunit  SET code = orgunitId WHERE organisationunitid = orgunitId; --AND code = '';
    EXCEPTION WHEN  unique_violation THEN
		RAISE NOTICE 'vaolate uniqueness on orgunit with % and code %',orgunitId,newCode;
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

--generate codes based on postion of characters
CREATE OR REPLACE FUNCTION getVillageCode(firstLetterPosition INT,secondLetterPosition INT,thirdLetterPosition INT,villageName VARCHAR,parentCode VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
	code VARCHAR := '';
BEGIN	
	code := UPPER(CONCAT(CONCAT(CONCAT(substr(villageName,firstLetterPosition,1)),substr(villageName,secondLetterPosition,1)),substr(villageName,thirdLetterPosition,1)));
	RETURN UPPER(CONCAT(CONCAT(parentCode,'.'),code));
END;
$$
LANGUAGE plpgsql;

--function to get unique village code 
CREATE OR REPLACE FUNCTION generateVillageCode(firstLetterPosition INT,secondLetterPosition INT,thirdLetterPosition INT,villageName VARCHAR,parentCode VARCHAR) RETURNS VARCHAR AS
$$
DECLARE
	villageCode VARCHAR := '';
BEGIN	
	villageCode :=getVillageCode(firstLetterPosition,secondLetterPosition,thirdLetterPosition,villageName,parentCode);
	IF ((SELECT COUNT(code) FROM getOrganisationUnitsbyLevel() WHERE code = villageCode ) > 0) THEN
		thirdLetterPosition := thirdLetterPosition + 1;
		IF(thirdLetterPosition >= char_length(villageName)) THEN 
			secondLetterPosition := secondLetterPosition + 1;
			thirdLetterPosition := secondLetterPosition + 1;
		ELSIF (secondLetterPosition >= char_length(villageName)) THEN
			firstLetterPosition := firstLetterPosition + 1;
			secondLetterPosition := firstLetterPosition + 1;
			thirdLetterPosition := secondLetterPosition + 1;
		END IF;
		RETURN getVillageCode(firstLetterPosition,secondLetterPosition,thirdLetterPosition,villageName,parentCode);
	ELSE 
		RETURN villageCode;
	END IF;	
	
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
		counter INT:= 0;
		newCode VARCHAR(50) :='';
		parentCode VARCHAR(50);
	BEGIN
		-- fix values  for testing parentid = 4096 parentid = 4096 LOOP--
		
		--codes for villages
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: Villages codes :::::::::::::::::';
		RAISE INFO ':::::::::::::::::::::::::::::::::::::::::';
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE hierarchylevel = wardLevel LOOP			
			--RAISE INFO 'Starting code generation for % ward ',organisationUnit.name;
			FOR village IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE parentid = organisationUnit.organisationunitid LOOP			
				parentCode := organisationUnit.code;
				orgunitId := village.organisationunitid;
				newCode := generateVillageCode(1,2,3,village.name,parentCode);				
				raise info 'village %  ::: code %  ::  parentcode %',village.name,newCode,parentCode;
				--update codes 				
				PERFORM updateOrganisationUnitCodes(orgunitId,newCode);				
			END LOOP;
		
			--RAISE INFO 'Ending code generation for % ward ',organisationUnit.name;			
		END LOOP;
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: Water points codes:::::::::::::;';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		--water points codesrtions
		FOR village IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE hierarchylevel = villageLevel LOOP			
			counter := 0;
			--update codes for villages
			FOR waterPoint IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE parentid = village.organisationunitid LOOP
				orgunitId = waterPoint.organisationunitid;
				counter := counter + 1;
				parentCode := village.code;
				--counter::text typecast interger into string
				IF counter > 9 THEN
					newCode := counter::text;
				ELSE
					newCode := CONCAT('0',counter::text);
				END IF;	
				newCode := CONCAT(CONCAT(parentCode,'.'),newCode);
				RAISE INFO 'water point %  ::: code %  ::  parentcode %',waterPoint.name,newCode,parentCode;
				--update codes 				
				PERFORM updateOrganisationUnitCodes(orgunitId,newCode);
				
			END LOOP;
		END LOOP;
		
		
	END;
	$$ LANGUAGE plpgsql; 	

--- gerate codes
SELECT organisationUnitsCodeGenerator();
