DROP FUNCTION organisationUnitsCodeGenerator(INT);
DROP FUNCTION getOrganisationUnitsbyLevel();
DROP TYPE holder;

--Village level = 5, water pint level = 6

--holder for some properties of orgunits 
CREATE  TYPE holder AS (organisationunitid INT,uid VARCHAR(11),name VARCHAR(50),code VARCHAR(50),hierarchylevel INT,parentid INT);

-- function to get all ordered by orgunits
CREATE OR REPLACE FUNCTION  getOrganisationUnitsbyLevel() RETURNS SETOF holder AS 'SELECT organisationunitid,uid,name,code,hierarchylevel,parentid FROM organisationunit ORDER BY created ASC;' language 'sql';

-- function for code generations
CREATE OR REPLACE FUNCTION organisationUnitsCodeGenerator(orgUnitLevel INT) RETURNS VOID AS $$
	DECLARE
		--variable to holder types
		row holder%ROWTYPE;
		villageLevel INT :=3;
		waterPointLevel INT := 4;
		counter INT:= 0;
		code text :='';
	BEGIN
		
		IF orgUnitLevel = villageLevel THEN		
			code = '';
			RAISE NOTICE '***** start Village with  level  : % ********', orgUnitLevel;
			FOR row IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE hierarchylevel = orgUnitLevel LOOP
				IF  row.hierarchylevel = orgUnitLevel THEN
					RAISE NOTICE 'Name : % Code : % Level : % Parentid : % Organisationunitid : %', row.name,row.code,row.hierarchylevel,row.parentid,row.organisationunitid;
					code = upper(substr(row.name,0,4));
					RAISE NOTICE 'New code %',code;
				END IF;			
			END LOOP;
			RAISE NOTICE '***** End of level  : % ********', orgUnitLevel;
			
		ELSIF orgUnitLevel = waterPointLevel THEN
			code = '';
			RAISE NOTICE '***** start waterpoints with level  : % ********', orgUnitLevel;
			FOR row IN SELECT * FROM getOrganisationUnitsbyLevel() WHERE hierarchylevel = orgUnitLevel LOOP
				counter := counter + 1;
				IF  row.hierarchylevel = orgUnitLevel THEN
					RAISE NOTICE 'Name : % Code : % Level : % Parentid : % Organisationunitid : %', row.name,row.code,row.hierarchylevel,row.parentid,row.organisationunitid;
					--code = '' + counter;
					RAISE NOTICE 'New code %',counter;
				END IF;			
			END LOOP;
			RAISE NOTICE '***** End of level  : % ********', orgUnitLevel;
		END IF;
		
		
	END;
	$$ LANGUAGE plpgsql; 
	
	

--- gerate codes
SELECT organisationUnitsCodeGenerator(3);
SELECT organisationUnitsCodeGenerator(4);
