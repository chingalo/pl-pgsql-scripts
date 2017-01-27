DROP FUNCTION organisationUnitsCodeGenerator();
DROP FUNCTION getOrganisationUnitsbyLevel();
DROP FUNCTION getParentOrganisationUnitCode(INT);
DROP FUNCTION updateOrganisationUnitCode(INT,VARCHAR);
DROP TYPE holder;

-- ward level = 4, Village level = 5, water pint level = 6

--holder for some properties of orgunits 
CREATE  TYPE holder AS (organisationunitid INT,uid VARCHAR(11),name VARCHAR(50),code VARCHAR(50),hierarchylevel INT,parentid INT);

-- function to get all ordered by orgunits with level greater then 3
CREATE OR REPLACE FUNCTION  getOrganisationUnitsbyLevel() RETURNS SETOF holder AS 

	'SELECT organisationunitid,uid,name,code,hierarchylevel,parentid FROM organisationunit WHERE hierarchylevel > 3 ORDER BY created ASC;' 
	language 'sql';
	

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
		villageLevel INT :=5;
		counter INT:= 0;
		code VARCHAR(50) :='';
		parentCode VARCHAR(50);
	BEGIN
		-- fix for testing parentid = 4096
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() LOOP			
			parentCode := getParentOrganisationUnitCode(organisationUnit.parentid);
			IF  organisationUnit.hierarchylevel = villageLevel THEN
				RAISE NOTICE '**************************************************************************************************';	
				RAISE NOTICE '****************** Starting code genration for  % village *******************',organisationUnit.name;
				RAISE NOTICE '**************************************************************************************************';
				--checking for code uniqueness
				code := upper(substr(organisationUnit.name,0,4));
				code := CONCAT(CONCAT(parentCode,'.'),code);
				RAISE NOTICE 'Code for % is % ',organisationUnit.name,code; 
				--update codes 
				
				RAISE NOTICE '==== codes generation water points in  % villages=======',organisationUnit.name;
				counter := 0;
				FOR waterPoint IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE parentid= organisationUnit.organisationunitid LOOP
					counter := counter + 1;
					parentCode := getParentOrganisationUnitCode(waterPoint.parentid);
					--counter::text typecast interger into string
					IF counter > 9 THEN
						code := counter::text;
					ELSE
						code := CONCAT('0',counter::text);
					END IF;	
					code := CONCAT(CONCAT(parentCode,'.'),code);
					--update code				
				RAISE NOTICE 'Code for % is % ',waterPoint.name,code;
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
