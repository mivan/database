ALTER TABLE itemalias ADD COLUMN itemalias_crmacct_id INTEGER REFERENCES crmacct(crmacct_id);

COMMENT ON COLUMN itemalias.itemalias_crmacct_id IS 'Associated crmacct for item alias.';
