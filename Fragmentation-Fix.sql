-- REBUILD INDEX  (If Fragmentation > 30%)

ALTER INDEX iClustered ON dbo.FragTest REBUILD;

-- REORGANIZE INDEX (If Fragmentation is between 5% - 30%) 

ALTER INDEX iClustered ON dbo.FragTest REORGANIZE;