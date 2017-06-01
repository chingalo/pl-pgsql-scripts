-- DELETE one organisatiounit at any level
---------------------------------------------
-- Taking completeness backup of that organisationunit
COPY(SELECT * FROM completedatasetregistration WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) to '/tmp/datasetregistration_SRXfdg0CnbP.csv' with csv header;
--  Deleting completeness of that organisationunit
DELETE FROM completedatasetregistration WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);
-- Taking backup of assigned dataset source to that organisationunit

COPY(SELECT * FROM datasetsource WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) to '/tmp/datasetsource_SRXfdg0CnbP.csv' with csv header;
-- Unassigning dataset to that organisationunit that has to be deleted
DELETE FROM datasetsource WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);


-- Taking backup of datavalue that is associated with that organisationunit
COPY(SELECT * FROM datavalue WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) to '/tmp/datavalue_SRXfdg0CnbP.csv' with csv header;
-- Deleting all datavalue that is associated with organisationunit that has to be deleted
DELETE FROM datavalue WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);
COPY(SELECT * FROM datavalueaudit WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) to '/tmp/datavalueaudit_SRXfdg0CnbP.csv' with csv header;
-- DELETE all children datavalueaudit that associated with that organisationunit that has to be deleted
DELETE FROM datavalueaudit WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);
-- Taking all children program organisationunits associated with the organisationunit that has to be deleted
COPY(SELECT * FROM program_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) to '/tmp/program_organisationunit_SRXfdg0CnbP.csv' with csv header;
-- Delete(Unssign all program that associated to children of the organisationunit that has to be deleted)
DELETE FROM program_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);
-- Taking trackedentitydatavalue(auto-growing table value) of children associated with organisationunit that has to be deleted.
COPY(SELECT * FROM trackedentitydatavalue WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/trackedentitydatavalue_SRXfdg0CnbP.csv' with csv header;
-- DELETE all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
DELETE FROM trackedentitydatavalue WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- Taking trackedentitydatavalueaudit(auto-growing table value audit) of children associated with organisationunit that has to be deleted.
COPY(SELECT * FROM trackedentitydatavalueaudit WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/trackedentitydatavalueaudit_SRXfdg0CnbP.csv' with csv header;
-- DELETE all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
DELETE FROM trackedentitydatavalueaudit WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
--    Taking all programstageinstance backup that is associated with children of the organisationunit that has to be deleted
COPY(SELECT * FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)) to '/tmp/programstageinstance_SRXfdg0CnbP.csv' with csv header;
-- DELETE all programstageinstance of children that is associated with organisationunit that has to be deleted(This may take While)
DELETE FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);
-- Taking all charts fevarites for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM chart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/chart_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all charts fevarites for all children that is associated with organisationunit that has to be deleted.
DELETE FROM chart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM eventchart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/event_chart_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
DELETE FROM eventchart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all event report fevarites for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM eventreport_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/event_report_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event report fevarites for all children that is associated with organisationunit that has to be deleted.
DELETE FROM eventreport_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all interpretation for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM interpretation WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/interpretation_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all interpretation for all children that is associated with organisationunit that has to be deleted.
DELETE FROM interpretation WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM mapview_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/mapview_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM mapview_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM orgunitgroupmembers WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/orgunitgroupmembers_SRXfdg0CnbP.csv' with csv header;
-- Deleting all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
DELETE FROM orgunitgroupmembers WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM reporttable_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/reporttable_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM reporttable_organisationunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM userdatavieworgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/userdatavieworgunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM userdatavieworgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all usermembership for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM usermembership WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/usermembership_SRXfdg0CnbP.csv' with csv header;
-- Deleting all usermembership for all children that is associated with organisationunit that has to be deleted.
DELETE FROM usermembership WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- Taking all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM userteisearchorgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) to '/tmp/userteisearchorgunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM userteisearchorgunits WHERE organisationunitid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L);
-- DELETE that organisationunit
DELETE FROM organisationunit WHERE uid='SRXfdg0CnbP';







-- DELETE all childeren contents associated with that uid of organisationunit at Level 3
-------------------------------------------------------------------------------------------
-- Taking completeness backup of that organisationunit
COPY(SELECT * FROM completedatasetregistration WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/datasetregistration_children_SRXfdg0CnbP.csv' with csv header;
--  Deleting completeness of that organisationunit
DELETE FROM completedatasetregistration WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- Taking backup of assigned dataset source to that organisationunit
COPY(SELECT * FROM datasetsource WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/datasetsource_children_SRXfdg0CnbP.csv' with csv header;
-- Unassigning dataset to that organisationunit that has to be deleted
DELETE FROM datasetsource WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- Taking backup of datavalue that is associated with that organisationunit
COPY(SELECT * FROM datavalue WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/datavalue_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all datavalue that is associated with organisationunit that has to be deleted
DELETE FROM datavalue WHERE sourceid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- Copy all children datavaleaudit that associated with that organisationunit that has to be deleted
COPY(SELECT * FROM datavalueaudit WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/datavalueaudit_children_SRXfdg0CnbP.csv' with csv header;
-- DELETE all children datavalueaudit that associated with that organisationunit that has to be deleted
DELETE FROM datavalueaudit WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- Taking all children program organisationunits associated with the organisationunit that has to be deleted
COPY(SELECT * FROM program_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/program_children_organisationunit_SRXfdg0CnbP.csv' with csv header;
-- Delete(Unssign all program that associated to children of the organisationunit that has to be deleted)
DELETE FROM program_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- Taking trackedentitydatavalue(auto-growing table value) of children associated with organisationunit that has to be deleted.
COPY(SELECT * FROM trackedentitydatavalue WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)))) to '/tmp/trackedentitydatavalue_children_SRXfdg0CnbP.csv' with csv header;
-- DELETE all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
DELETE FROM trackedentitydatavalue WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)));
-- Taking trackedentitydatavalueaudit(auto-growing table value audit) of children associated with organisationunit that has to be deleted.
COPY(SELECT * FROM trackedentitydatavalueaudit WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)))) to '/tmp/trackedentitydatavalueaudit_children_SRXfdg0CnbP.csv' with csv header;
-- DELETE all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
DELETE FROM trackedentitydatavalueaudit WHERE programstageinstanceid IN(SELECT programstageinstanceid FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L)));
--    Taking all programstageinstance backup that is associated with children of the organisationunit that has to be deleted
COPY(SELECT * FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L))) to '/tmp/programstageinstance_children_SRXfdg0CnbP.csv' with csv header;
-- DELETE all programstageinstance of children that is associated with organisationunit that has to be deleted(This may take While)
DELETE FROM programstageinstance WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L));
-- DELETE all children that associated with organisationunit that has to be deleted
DELETE FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE path ILIKE %L);
-- Taking all charts fevarites for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM chart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/chart_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all charts fevarites for all children that is associated with organisationunit that has to be deleted.
DELETE FROM chart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM eventchart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/event_chart_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
DELETE FROM eventchart_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all event report fevarites for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM eventreport_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/event_report_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event report fevarites for all children that is associated with organisationunit that has to be deleted.
DELETE FROM eventreport_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all interpretation for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM interpretation WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/interpretation_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all interpretation for all children that is associated with organisationunit that has to be deleted.
DELETE FROM interpretation WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM mapview_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/mapview_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM mapview_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM orgunitgroupmembers WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/orgunitgroupmembers_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
DELETE FROM orgunitgroupmembers WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM reporttable_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/reporttable_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM reporttable_organisationunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM userdatavieworgunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/userdatavieworgunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM userdatavieworgunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all usermembership for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM usermembership WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/usermembership_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all usermembership for all children that is associated with organisationunit that has to be deleted.
DELETE FROM usermembership WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));
-- Taking all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
COPY(SELECT * FROM userteisearchorgunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))) to '/tmp/userteisearchorgunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
DELETE FROM userteisearchorgunits WHERE organisationunitid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L));


-- DELETE all childeren contents associated with that uid of organisationunit at Level 2(SRXfdg0CnbP-uid of organisationunit of second level)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Repeate all of the query by checking again double parentid ie replace 
--  (SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) --with 
--  (SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L))
-- 
--  But this might be painfull since it will take alot of time passing all of its grandchildren, children and finally itself



-- DELETE all childeren contents associated with that uid of organisationunit at Level 1(SRXfdg0CnbP-uid of organisationunit of first level)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Repeate all of the query by checking again double parentid ie replace 
--  (SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)) --with 
--  (SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid FROM organisationunit WHERE parentid IN(SELECT organisationunitid  FROM organisationunit WHERE path ILIKE %L)))
-- 
--  But this might be painfull since it will take alot of time passing all of its grand-grandchildren,grandchildren, children and finally itself
