UPDATE itemsite SET
  itemsite_recvlocation_id = CASE WHEN (itemsite_recvlocation_id = -1) THEN itemsite_location_id
                                  ELSE itemsite_recvlocation_id
                             END,
  itemsite_issuelocation_id = CASE WHEN (itemsite_issuelocation_id = -1) THEN itemsite_location_id
                                   ELSE itemsite_issuelocation_id
                              END
WHERE (itemsite_location_id > 0)
  AND ((itemsite_recvlocation_id = -1) OR (itemsite_issuelocation_id = -1));
