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
	


CREATE OR REPLACE FUNCTION updateOrganisationUnitCodes(orgunitId INT, newCode VARCHAR) RETURNS VOID AS
$$
BEGIN
    UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
     EXCEPTION WHEN  unique_violation THEN
		newCode :=CONCAT(newCode,orgunitId::TEXT);
		UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
   
		
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
		wardLevel INT :=4;
		villageLevel INT :=2;
		orgunitId INT;
		counter INT:= 0;
		newCode VARCHAR(50) :='';
		parentCode VARCHAR(50);
	BEGIN
		-- fix for testing parentid = 4096
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE hierarchylevel > 1 LOOP			
			parentCode := getParentOrganisationUnitCode(organisationUnit.parentid);
			IF  organisationUnit.hierarchylevel = villageLevel THEN
				orgunitId := organisationUnit.organisationunitid;
				RAISE NOTICE '**************************************************************************************************';	
				RAISE NOTICE '****************** Starting code genration for  % village *******************',organisationUnit.name;
				RAISE NOTICE '**************************************************************************************************';
				--checking for code uniqueness need to be redu
				newCode := upper(substr(organisationUnit.name,0,4));
				newCode := CONCAT(CONCAT('','.'),newCode);
				RAISE NOTICE 'Code for % is % ',organisationUnit.name,newCode; 
				
				--update codes 				
				PERFORM updateOrganisationUnitCodes(orgunitId,newCode);
				--UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
				
				RAISE NOTICE '==== codes generation water points in  % villages=======',organisationUnit.name;
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
					
					--update code				
					PERFORM updateOrganisationUnitCodes(orgunitId,newCode);
					--UPDATE organisationunit  SET code = newCode WHERE organisationunitid = orgunitId;
					RAISE NOTICE 'Code for % is % ',waterPoint.name,newCode;
					
				END LOOP;
				RAISE NOTICE '**************************************************************************************************';	
				RAISE NOTICE '******************* End code genration for  % village ******************',organisationUnit.name;
				RAISE NOTICE '**************************************************************************************************';				
			ELSE
			RAISE NOTICE '******************skip code generation for % ***********',organisationUnit.name;
			RAISE NOTICE'';
			END IF;	
			
		END LOOP;				
	END;
	$$ LANGUAGE plpgsql; 	

--- gerate codes
SELECT organisationUnitsCodeGenerator();
