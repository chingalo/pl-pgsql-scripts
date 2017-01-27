--drop code generator function if preseent
	DROP FUNCTION organisationUnitsCodeGenerator(INT);
	CREATE OR REPLACE organisationUnitsCodeGenerator(level INT) RETURN VOID AS $$
		DECLARE
			
		BEGIN
			RAISE NOTICE "Hello world";
		END
		$$ LANGUAGE plpgsql; 
