DROP FUNCTION organisationUnitsCodeGenerator();
DROP FUNCTION getOrganisationUnitsbyLevel();
DROP FUNCTION getParentOrganisationUnitCode(INT);
DROP TYPE holder;

--Village level = 5, water pint level = 6

--holder for some properties of orgunits 
CREATE  TYPE holder AS (organisationunitid INT,uid VARCHAR(11),name VARCHAR(50),code VARCHAR(50),hierarchylevel INT,parentid INT);

-- function to get all ordered by orgunits
CREATE OR REPLACE FUNCTION  getOrganisationUnitsbyLevel() RETURNS SETOF holder AS 'SELECT organisationunitid,uid,name,code,hierarchylevel,parentid FROM organisationunit ORDER BY created ASC;' language 'sql';



--replace loops wijht appropriate function
CREATE OR REPLACE FUNCTION getParentOrganisationUnitCode(parentid INT) RETURNS TEXT AS $$
	DECLARE
		organisationUnit holder%ROWTYPE;
		code TEXT := '';
	BEGIN
		
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() LOOP
			IF organisationUnit.organisationunitid=parentid  THEN
				code := organisationUnit.name;
				--code := organisationUnit.code;				
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
		parentOrganisationUnit holder%ROWTYPE;
		villageLevel INT :=3;
		waterPointLevel INT := 4;
		counter INT:= 0;
		code VARCHAR(50) :='';
		parentCode VARCHAR(50);
	BEGIN	
		counter := 0;
		RAISE NOTICE '==== codes generation startts =======';
		FOR organisationUnit IN SELECT * FROM getOrganisationUnitsbyLevel() LOOP
			parentCode = getParentOrganisationUnitCode(organisationUnit.parentid);
			IF  organisationUnit.hierarchylevel = villageLevel THEN				
				code := upper(substr(organisationUnit.name,0,4));
				code := CONCAT(CONCAT(parentCode,'.'),code);
				RAISE NOTICE 'code for % is % parentCode : %',organisationUnit.name,code,parentCode;
			
			ELSIF organisationUnit.hierarchylevel = waterPointLevel THEN	
				counter :=counter + 1;
				--counter::text typecast interger into string
				IF counter > 9 THEN
					code := counter::text;
				ELSE
					code := CONCAT('0',counter::text);
				END IF;		
				code := CONCAT(CONCAT(parentCode,'.'),code);				
				RAISE NOTICE 'code for % is % parentCode %',organisationUnit.name,code,parentCode;
			END IF;	

		END LOOP;				
	END;
	$$ LANGUAGE plpgsql; 	

--- gerate codes
SELECT organisationUnitsCodeGenerator();
