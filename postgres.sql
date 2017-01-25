   -- Function increments the input value by 1
   DROP FUNCTION increment(integer);
   CREATE OR REPLACE FUNCTION increment(i INT) RETURNS VOID AS $$
    BEGIN
	RAISE NOTICE 'Input values : %', i;     
    END;
    $$ LANGUAGE plpgsql;
 
    -- An example how to use the function (Returns: 11)
    SELECT increment(10);
