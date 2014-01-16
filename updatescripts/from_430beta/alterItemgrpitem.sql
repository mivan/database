ALTER TABLE itemgrpitem ADD COLUMN itemgrpitem_item_type CHAR(1) NOT NULL DEFAULT 'I';

UPDATE itemgrpitem SET itemgrpitem_item_type='I';

DROP INDEX itemgrpitem_itemgrp_item_id_idx;

ALTER TABLE itemgrpitem
  ADD CONSTRAINT itemgrpitem_unique_key UNIQUE(itemgrpitem_itemgrp_id, itemgrpitem_item_id, itemgrpitem_item_type);

ALTER TABLE itemgrpitem
  ADD CONSTRAINT itemgrpitem_valid_item_type CHECK(itemgrpitem_item_type = ANY (ARRAY['I'::bpchar, 'G'::bpchar])); 