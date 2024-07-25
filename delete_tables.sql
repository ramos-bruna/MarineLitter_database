DO $$ DECLARE
    r RECORD;
BEGIN
    -- Loop sobre todas as tabelas no esquema 'public'
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;
