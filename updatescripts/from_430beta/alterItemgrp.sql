ALTER TABLE itemgrp ADD COLUMN itemgrp_catalog BOOLEAN NOT NULL DEFAULT FALSE;

UPDATE itemgrp SET itemgrp_catalog=FALSE;
