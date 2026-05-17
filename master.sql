-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - MASTER FILE
--  Run this single file to set up everything:
--    mysql -u root -p < master.sql
-- ============================================================

SOURCE schema.sql
SOURCE data.sql
SOURCE triggers.sql
SOURCE procedures.sql
SOURCE views.sql

SELECT '✅ College DB setup complete!' AS status;
