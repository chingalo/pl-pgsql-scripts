DROP FUNCTION villagesAndWaterPointsCodeGenerator();
DROP FUNCTION getOrganisationUnits();
DROP FUNCTION updateOrganisationUnitCodes(INT,VARCHAR);
DROP FUNCTION getVillageCode(INT,INT,INT,VARCHAR,VARCHAR);
DROP FUNCTION getAndUpdateUniqueVillageCode(INT,INT,INT,VARCHAR,VARCHAR,INT);
DROP TYPE holder;

-- ward level = 4, Village level = 5, water pint level = 6

--holder for some properties of orgunits 
CREATE  TYPE holder AS (organisationunitid INT,uid VARCHAR(11),name VARCHAR(50),code VARCHAR(50),hierarchylevel INT,parentid INT);

-- function to get all ordered by orgunits created dates
CREATE OR REPLACE FUNCTION  getOrganisationUnits() RETURNS SETOF holder AS 
	'SELECT organisationunitid,uid,name,code,hierarchylevel,parentid FROM organisationunit ORDER BY created ASC;' 
	language 'sql';


--function to update code for a given organisation unit
CREATE OR REPLACE FUNCTION updateOrganisationUnitCodes(orgunitId INT, newCode VARCHAR) RETURNS VOID AS
$$
BEGIN
    UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
    EXCEPTION WHEN  unique_violation THEN
		newCode := newCode;
		RAISE NOTICE 'unique_violation on orgunit with % and code %',orgunitId,newCode;
END;
$$
LANGUAGE plpgsql;


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
CREATE OR REPLACE FUNCTION getAndUpdateUniqueVillageCode(firstLetterPosition INT,secondLetterPosition INT,thirdLetterPosition INT,villageName VARCHAR,parentCode VARCHAR,orgunitId INT) RETURNS VARCHAR AS
$$
DECLARE
	villageCode VARCHAR := '';
BEGIN	
	RAISE INFO 'Start find code for village %  ',villageName;
	villageCode :=getVillageCode(firstLetterPosition,secondLetterPosition,thirdLetterPosition,villageName,parentCode);
	WHILE ((SELECT COUNT(code) FROM getOrganisationUnits() WHERE code = villageCode ) > 0) LOOP 	
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';		
		RAISE INFO 'Re-find code for village %  ',villageName;
		thirdLetterPosition := thirdLetterPosition + 1;
		IF(thirdLetterPosition >= char_length(villageName)) THEN 
			secondLetterPosition := secondLetterPosition + 1;
			thirdLetterPosition := secondLetterPosition + 1;
		ELSIF (secondLetterPosition >= char_length(villageName)) THEN
			firstLetterPosition := firstLetterPosition + 1;
			secondLetterPosition := firstLetterPosition + 1;
			thirdLetterPosition := secondLetterPosition + 1;
		END IF;
		RAISE INFO '% % % ',firstLetterPosition,secondLetterPosition,thirdLetterPosition;
		villageCode :=getVillageCode(firstLetterPosition,secondLetterPosition,thirdLetterPosition,villageName,parentCode);
	
	END LOOP; 
	
	RETURN villageCode;
	
END;
$$
LANGUAGE plpgsql;


-- function for code generations
CREATE OR REPLACE FUNCTION villagesAndWaterPointsCodeGenerator() RETURNS VOID AS $$
	DECLARE
		--variable to holder types
		ward holder%ROWTYPE;
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
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: Resetting illages codes to uid :::::::::::::::::';
		RAISE INFO ':::::::::::::::::::::::::::::::::::::::::';
		FOR village IN SELECT * FROM getOrganisationUnits() WHERE parentid IN (SELECT organisationunitid FROM getOrganisationUnits() WHERE hierarchylevel = wardLevel AND code != '') LOOP
			UPDATE organisationunit  SET code = village.uid WHERE organisationunitid = village.organisationunitid;			
			RAISE INFO 'village %  has been reset to %',village.name,(SELECT code FROM getOrganisationUnits() WHERE organisationunitid = village.organisationunitid);
		END LOOP;
		
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO '::::::::Resetting Water points codes to uid:::::::::::::;';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		FOR village IN SELECT * FROM getOrganisationUnits() WHERE parentid IN (SELECT organisationunitid FROM getOrganisationUnits() WHERE hierarchylevel = wardLevel AND code != '') LOOP			
			RAISE INFO ':::::::::::::On Village : %:::::::::::::::::::',village.name;	
			FOR waterPoint IN SELECT * FROM getOrganisationUnits() WHERE parentid = village.organisationunitid LOOP
				UPDATE organisationunit  SET code = waterPoint.uid WHERE organisationunitid = waterPoint.organisationunitid;
				RAISE INFO ':::::::::::::% has been reset to % :::::::::::::::',waterPoint.name, (SELECT code FROM getOrganisationUnits() WHERE organisationunitid = waterPoint.organisationunitid);				
			END LOOP;
		END LOOP;
		
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::: Starting apply new codes ::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		
		
		--codes for villages
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: Villages codes :::::::::::::::::';
		RAISE INFO ':::::::::::::::::::::::::::::::::::::::::';
		
		FOR village IN SELECT * FROM getOrganisationUnits() WHERE parentid IN (SELECT organisationunitid FROM getOrganisationUnits() WHERE hierarchylevel = wardLevel AND code != '') LOOP			
			parentCode := (SELECT code FROM getOrganisationUnits() WHERE organisationunitid = village.parentid);
			orgunitId := village.organisationunitid;
			newCode := getAndUpdateUniqueVillageCode(1,2,3,village.name,parentCode,orgunitId);
			--update codes 				
			UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
			RAISE INFO 'New code village %  is %  . It has been saved as  %',village.name,newCode,(SELECT code FROM getOrganisationUnits() WHERE organisationunitid = orgunitId);
		END LOOP;
		
		--water points codesrtions
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: Water points codes:::::::::::::;';
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';		
		FOR village IN SELECT * FROM getOrganisationUnits() WHERE parentid IN (SELECT organisationunitid FROM getOrganisationUnits() WHERE hierarchylevel = wardLevel AND code != '') LOOP			
			counter := 0;
			RAISE INFO 'Water point code generation for % village',village.name;
			--update codes for villages
			FOR waterPoint IN SELECT * FROM getOrganisationUnits() WHERE parentid = village.organisationunitid LOOP
				orgunitId = waterPoint.organisationunitid;
				counter := counter + 1;
				parentCode := village.code;
				--counter::text typecast interger into string
				IF counter > 9 THEN
					newCode := counter::text;
				ELSE
					newCode := CONCAT('0',counter::text);
				END IF;	
				newCode := CONCAT(parentCode,newCode);				
				--update codes
				PERFORM updateOrganisationUnitCodes(orgunitId,newCode);
				RAISE INFO 'New code water point %  is %  . It has been saved as  %',waterPoint.name,newCode,(SELECT code FROM getOrganisationUnits() WHERE organisationunitid = orgunitId);				
				
			END LOOP;
			RAISE INFO '**** End of Water point code generation for % village***',village.name;
		END LOOP;
		
		
		RAISE INFO '::::::::::::::::::::::::::::::::::::::::';
		RAISE INFO ':::::::: The end good bye !!! :::::::::::::::::';
		RAISE INFO ':::::::::::::::::::::::::::::::::::::::::';		
		
	END;
	$$ LANGUAGE plpgsql; 	

--- intiate code generation for villages and water points
SELECT villagesAndWaterPointsCodeGenerator();
