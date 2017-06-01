-- Delete one organisatiounit at any level
---------------------------------------------
-- Taking completeness backup of that organisationunit
copy(select * from completedatasetregistration where sourceid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/datasetregistration_SRXfdg0CnbP.csv' with csv header;
--  Deleting completeness of that organisationunit
delete from completedatasetregistration where sourceid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking backup of assigned dataset source to that organisationunit
copy(select * from datasetsource where sourceid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/datasetsource_SRXfdg0CnbP.csv' with csv header;
-- Unassigning dataset to that organisationunit that has to be deleted
delete from datasetsource where sourceid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking backup of datavalue that is associated with that organisationunit
copy(select * from datavalue where sourceid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/datavalue_SRXfdg0CnbP.csv' with csv header;
-- Deleting all datavalue that is associated with organisationunit that has to be deleted
delete from datavalue where sourceid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
copy(select * from datavalueaudit where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/datavalueaudit_SRXfdg0CnbP.csv' with csv header;
-- Delete all children datavalueaudit that associated with that organisationunit that has to be deleted
delete from datavalueaudit where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all children program organisationunits associated with the organisationunit that has to be deleted
copy(select * from program_organisationunits where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/program_organisationunit_SRXfdg0CnbP.csv' with csv header;
-- Delete(Unssign all program that associated to children of the organisationunit that has to be deleted)
delete from program_organisationunits where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking trackedentitydatavalue(auto-growing table value) of children associated with organisationunit that has to be deleted.
copy(select * from trackedentitydatavalue where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/trackedentitydatavalue_SRXfdg0CnbP.csv' with csv header;
-- Delete all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
delete from trackedentitydatavalue where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking trackedentitydatavalueaudit(auto-growing table value audit) of children associated with organisationunit that has to be deleted.
copy(select * from trackedentitydatavalueaudit where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/trackedentitydatavalueaudit_SRXfdg0CnbP.csv' with csv header;
-- Delete all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
delete from trackedentitydatavalueaudit where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
--    Taking all programstageinstance backup that is associated with children of the organisationunit that has to be deleted
copy(select * from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/programstageinstance_SRXfdg0CnbP.csv' with csv header;
-- Delete all programstageinstance of children that is associated with organisationunit that has to be deleted(This may take While)
delete from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all charts fevarites for all children that is associated with organisationunit that has to be deleted.
copy(select * from chart_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/chart_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all charts fevarites for all children that is associated with organisationunit that has to be deleted.
delete from chart_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
copy(select * from eventchart_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/event_chart_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
delete from eventchart_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all event report fevarites for all children that is associated with organisationunit that has to be deleted.
copy(select * from eventreport_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/event_report_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event report fevarites for all children that is associated with organisationunit that has to be deleted.
delete from eventreport_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all interpretation for all children that is associated with organisationunit that has to be deleted.
copy(select * from interpretation where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/interpretation_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all interpretation for all children that is associated with organisationunit that has to be deleted.
delete from interpretation where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from mapview_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/mapview_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
delete from mapview_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
copy(select * from orgunitgroupmembers where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/orgunitgroupmembers_SRXfdg0CnbP.csv' with csv header;
-- Deleting all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
delete from orgunitgroupmembers where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from reporttable_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/reporttable_organisationunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
delete from reporttable_organisationunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from userdatavieworgunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/userdatavieworgunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
delete from userdatavieworgunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all usermembership for all children that is associated with organisationunit that has to be deleted.
copy(select * from usermembership where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/usermembership_SRXfdg0CnbP.csv' with csv header;
-- Deleting all usermembership for all children that is associated with organisationunit that has to be deleted.
delete from usermembership where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from userteisearchorgunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) to '/tmp/userteisearchorgunits_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
delete from userteisearchorgunits where organisationunitid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'));
-- Delete that organisationunit
delete from organisationunit where uid='SRXfdg0CnbP';







-- Delete all childeren contents associated with that uid of organisationunit at Level 3
-------------------------------------------------------------------------------------------
-- Taking completeness backup of that organisationunit
copy(select * from completedatasetregistration where sourceid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/datasetregistration_children_SRXfdg0CnbP.csv' with csv header;
--  Deleting completeness of that organisationunit
delete from completedatasetregistration where sourceid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking backup of assigned dataset source to that organisationunit
copy(select * from datasetsource where sourceid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/datasetsource_children_SRXfdg0CnbP.csv' with csv header;
-- Unassigning dataset to that organisationunit that has to be deleted
delete from datasetsource where sourceid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking backup of datavalue that is associated with that organisationunit
copy(select * from datavalue where sourceid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/datavalue_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all datavalue that is associated with organisationunit that has to be deleted
delete from datavalue where sourceid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Copy all children datavaleaudit that associated with that organisationunit that has to be deleted
copy(select * from datavalueaudit where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/datavalueaudit_children_SRXfdg0CnbP.csv' with csv header;
-- Delete all children datavalueaudit that associated with that organisationunit that has to be deleted
delete from datavalueaudit where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all children program organisationunits associated with the organisationunit that has to be deleted
copy(select * from program_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/program_children_organisationunit_SRXfdg0CnbP.csv' with csv header;
-- Delete(Unssign all program that associated to children of the organisationunit that has to be deleted)
delete from program_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking trackedentitydatavalue(auto-growing table value) of children associated with organisationunit that has to be deleted.
copy(select * from trackedentitydatavalue where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))))) to '/tmp/trackedentitydatavalue_children_SRXfdg0CnbP.csv' with csv header;
-- Delete all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
delete from trackedentitydatavalue where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))));
-- Taking trackedentitydatavalueaudit(auto-growing table value audit) of children associated with organisationunit that has to be deleted.
copy(select * from trackedentitydatavalueaudit where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))))) to '/tmp/trackedentitydatavalueaudit_children_SRXfdg0CnbP.csv' with csv header;
-- Delete all trackedentitydatavalue for all children that is associated with organisationunit that has to be deleted
delete from trackedentitydatavalueaudit where programstageinstanceid in(select programstageinstanceid from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'))));
--    Taking all programstageinstance backup that is associated with children of the organisationunit that has to be deleted
copy(select * from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/programstageinstance_children_SRXfdg0CnbP.csv' with csv header;
-- Delete all programstageinstance of children that is associated with organisationunit that has to be deleted(This may take While)
delete from programstageinstance where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP')));
-- Delete all children that associated with organisationunit that has to be deleted
delete from organisationunit where parentid in(select organisationunitid from organisationunit where uid in('SRXfdg0CnbP'));
-- Taking all charts fevarites for all children that is associated with organisationunit that has to be deleted.
copy(select * from chart_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/chart_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all charts fevarites for all children that is associated with organisationunit that has to be deleted.
delete from chart_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
copy(select * from eventchart_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/event_chart_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event charts fevarites for all children that is associated with organisationunit that has to be deleted.
delete from eventchart_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all event report fevarites for all children that is associated with organisationunit that has to be deleted.
copy(select * from eventreport_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/event_report_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all event report fevarites for all children that is associated with organisationunit that has to be deleted.
delete from eventreport_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all interpretation for all children that is associated with organisationunit that has to be deleted.
copy(select * from interpretation where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/interpretation_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all interpretation for all children that is associated with organisationunit that has to be deleted.
delete from interpretation where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from mapview_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/mapview_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all mapview_organisationunits for all children that is associated with organisationunit that has to be deleted.
delete from mapview_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
copy(select * from orgunitgroupmembers where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/orgunitgroupmembers_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all orgunitgroupmembers for all children that is associated with organisationunit that has to be deleted.
delete from orgunitgroupmembers where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from reporttable_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/reporttable_organisationunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all reporttable_organisationunits for all children that is associated with organisationunit that has to be deleted.
delete from reporttable_organisationunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from userdatavieworgunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/userdatavieworgunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userdatavieworgunits for all children that is associated with organisationunit that has to be deleted.
delete from userdatavieworgunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all usermembership for all children that is associated with organisationunit that has to be deleted.
copy(select * from usermembership where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/usermembership_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all usermembership for all children that is associated with organisationunit that has to be deleted.
delete from usermembership where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));
-- Taking all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
copy(select * from userteisearchorgunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))) to '/tmp/userteisearchorgunits_children_SRXfdg0CnbP.csv' with csv header;
-- Deleting all userteisearchorgunits for all children that is associated with organisationunit that has to be deleted.
delete from userteisearchorgunits where organisationunitid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')));


-- Delete all childeren contents associated with that uid of organisationunit at Level 2(SRXfdg0CnbP-uid of organisationunit of second level)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Repeate all of the query by checking again double parentid ie replace 
--  (select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) --with 
--  (select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP')))
-- 
--  But this might be painfull since it will take alot of time passing all of its grandchildren, children and finally itself



-- Delete all childeren contents associated with that uid of organisationunit at Level 1(SRXfdg0CnbP-uid of organisationunit of first level)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Repeate all of the query by checking again double parentid ie replace 
--  (select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))) --with 
--  (select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where parentid in(select organisationunitid from organisationunit where parentid in(select organisationunitid  from organisationunit where uid in('SRXfdg0CnbP'))))
-- 
--  But this might be painfull since it will take alot of time passing all of its grand-grandchildren,grandchildren, children and finally itself
