ALTER TABLE terms ADD COLUMN terms_fincharg BOOLEAN;

UPDATE terms SET terms_fincharg=TRUE;

ALTER TABLE terms ALTER COLUMN terms_fincharg SET NOT NULL;
ALTER TABLE terms ALTER COLUMN terms_fincharg SET DEFAULT TRUE;
