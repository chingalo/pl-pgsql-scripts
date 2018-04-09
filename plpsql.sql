 DROP FUNCTION check_beneficiary_program(character,character);
CREATE OR REPLACE FUNCTION check_beneficiary_program (tID CHARACTER, beneficiary_id CHARACTER)
RETURNS TABLE(
  trackedEntityInstance CHARACTER varying(11),
  program CHARACTER varying(11),
  programName CHARACTER varying(230),
  orgUnit CHARACTER varying(11),
  fullname TEXT,
  age CHARACTER varying(250),
  programStatus CHARACTER varying(230),
  hivStatus CHARACTER varying(230)
) AS $$
BEGIN
    RETURN QUERY
        SELECT tu.uid, pr.uid, pr.name, ou.uid,CONCAT(firstNameAttrValue.value,' ',lastNameAttrValue.value), ageAttrValue.value, prStatusAttrValue.value, hivStatusAttrValue.value
        FROM programinstance pi INNER JOIN trackedentityinstance tu ON tu.trackedentityinstanceid=pi.trackedentityinstanceid
        INNER JOIN program pr ON pr.programid = pi.programid INNER JOIN organisationunit ou ON ou.organisationunitid = tu.organisationunitid
        INNER JOIN trackedentityattribute ageAttr ON ageAttr.uid = 'qgtS1LRH9Qj'
        INNER JOIN trackedentityattribute hivStatusAttr ON hivStatusAttr.uid = 'LzQxOyZ2zB7'
        INNER JOIN trackedentityattribute prStatusAttr ON prStatusAttr.uid = 'Z4VnoV1KpjQ'
        INNER JOIN trackedentityattribute firstNameAttr ON firstNameAttr.uid = 'wKZOf7Xd6RJ'
        INNER JOIN trackedentityattribute lastNameAttr ON lastNameAttr.uid = 'Xtoh0miFXff'
        LEFT JOIN trackedentityattributevalue ageAttrValue ON ageAttrValue.trackedentityinstanceid = tu.trackedentityinstanceid
            AND  ageAttr.trackedentityattributeid = ageAttrValue.trackedentityattributeid
        LEFT JOIN trackedentityattributevalue prStatusAttrValue ON prStatusAttrValue.trackedentityinstanceid = tu.trackedentityinstanceid
            AND  prStatusAttr.trackedentityattributeid = prStatusAttrValue.trackedentityattributeid
        LEFT JOIN trackedentityattributevalue hivStatusAttrValue ON hivStatusAttrValue.trackedentityinstanceid = tu.trackedentityinstanceid
            AND  hivStatusAttr.trackedentityattributeid = hivStatusAttrValue.trackedentityattributeid
        LEFT JOIN trackedentityattributevalue firstNameAttrValue ON firstNameAttrValue.trackedentityinstanceid = tu.trackedentityinstanceid
            AND  firstNameAttr.trackedentityattributeid = firstNameAttrValue.trackedentityattributeid
        LEFT JOIN trackedentityattributevalue lastNameAttrValue ON lastNameAttrValue.trackedentityinstanceid = tu.trackedentityinstanceid
            AND  lastNameAttr.trackedentityattributeid = lastNameAttrValue.trackedentityattributeid
        WHERE tu.trackedentityinstanceid = (SELECT ti.trackedentityinstanceid
        FROM trackedentityinstance ti
        INNER JOIN trackedentityattributevalue tiav ON tiav.trackedentityinstanceid = ti.trackedentityinstanceid
        INNER JOIN trackedentityattribute attr ON attr.trackedentityattributeid = tiav.trackedentityattributeid
        WHERE attr.uid = tID  AND tiav.value = beneficiary_id);

END;
$$
LANGUAGE plpgsql;