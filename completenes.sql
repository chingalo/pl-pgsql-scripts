SELECT
      (SELECT name
       FROM organisationunit
       WHERE organisationunitid=parent.parentid
      ) as grandparentname,
       parent.name as parentname,
        outer_orgunit.name,
	completed_by_and_date.storedby,completed_by_and_date.date

FROM organisationunit outer_orgunit
INNER JOIN _orgunitstructure using(organisationunitid)
LEFT JOIN organisationunit as parent on outer_orgunit.parentid=parent.organisationunitid
LEFT JOIN
	(
		SELECT completedatasetregistration.sourceid,
		completedatasetregistration.storedby storedby,
		completedatasetregistration.date date
		FROM completedatasetregistration
		INNER JOIN organisationunit inner_orgunit_completed_by
		ON inner_orgunit_completed_by.organisationunitid=completedatasetregistration.sourceid
		INNER JOIN dataset
		ON dataset.datasetid=completedatasetregistration.datasetid
		INNER JOIN _periodstructure
		ON _periodstructure.periodid=completedatasetregistration.periodid
		WHERE dataset.uid='zeEp4Xu2GOm'
			AND _periodstructure.iso='201704'
	) as completed_by_and_date ON completed_by_and_date.sourceid=outer_orgunit.organisationunitid
WHERE (outer_orgunit.path ilike '%m4ow47nd3DC%'
	and outer_orgunit.hierarchylevel='4')
        or outer_orgunit.uid='m4ow47nd3DC'
ORDER BY outer_orgunit.hierarchylevel desc,  grandparentname asc, parent.name asc, outer_orgunit.name asc