ALTER TABLE char ADD COLUMN char_quotes boolean default false;
ALTER TABLE char ADD COLUMN char_salesorders boolean default false;
ALTER TABLE char ADD COLUMN char_invoices boolean default false;
ALTER TABLE char ADD COLUMN char_vendors boolean default false;
ALTER TABLE char ADD COLUMN char_purchaseorders boolean default false;
ALTER TABLE char ADD COLUMN char_vouchers boolean default false;
ALTER TABLE char ADD COLUMN char_projects BOOLEAN default false;
ALTER TABLE char ADD COLUMN char_tasks    BOOLEAN default false;