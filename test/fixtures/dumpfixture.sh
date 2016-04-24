pg_dump --host localhost --port 5432 --username "j" --no-password --clean --schema-only --format plain --verbose --file "./test/fixtures/schema.sql" "postgrest_test"
