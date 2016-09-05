CREATE VIEW [cgs].[ContributorAddressee]
AS
SELECT 
  ISNULL(fx.IntValue, '')	AS [LOGOS Family ID],
  f.FamilyID,
  Convert(varchar, ISNULL(px.Data, '')) AS [LOGOS Member ID],
  p.PeopleId,
  Convert(varchar, ISNULL(s.Data, '')) AS [LOGOS Spouse ID],
  ISNULL(s.PeopleId, '') AS [SpousePeopleID],
  p.LastName,
  p.FirstName,
  p.ContributionOptionsID,
  CASE WHEN (ISNULL(s.PeopleID, 0) < 1) OR (p.PositionInFamilyId > 20) OR (p.ContributionOptionsID = 1) THEN p.Name
		WHEN p.LastName = s.LastName THEN p.FirstName + ' and ' + s.FirstName + ' ' + p.LastName
		ELSE p.Name + ' and ' + s.Name
		END AS [Addressee],
  CASE WHEN (ISNULL(s.PeopleID, 0) < 1) OR (p.PositionInFamilyId > 20) OR (p.ContributionOptionsID = 1) THEN p.FirstName
		ELSE p.FirstName + ' and ' + s.FirstName
		END AS [Salutation],
  f.AddressLineOne as [Address1],
  f.AddressLineTwo as [Address2],
  ISNULL(f.CityName, '') AS [City],
  ISNULL(f.StateCode, '') AS [State],
  ISNULL(f.ZipCode, '') AS [Zip],
  P.CellPhone AS [CellPhone],
  ISNULL(p.HomePhone, p.WorkPhone) AS [AltPhone],
  CASE WHEN (Len(p.EmailAddress) > 1) AND (p.SendEmailAddress1 <> 0) THEN p.EmailAddress ELSE p.EmailAddress2 END AS [EmailAddress],
  s.CellPhone AS [CellPhoneSpouse],
  s.EmailAddress as [EmailSpouse],
  p.MemberStatusId as [MemberStatusID],
  s.MemberStatusId as [SpouseStatusID],
  f.HeadOfHouseholdId
FROM 
  CMS_CGS.dbo.People p INNER JOIN
  CMS_CGS.dbo.Families f ON
      f.FamilyId = p.FamilyId LEFT OUTER JOIN
  CMS_CGS.dbo.FamilyExtra fx ON
      p.FamilyId = fx.FamilyID AND
      fx.Field = 'LOGOS Family ID' LEFT OUTER JOIN
  CMS_CGS.dbo.PeopleExtra px ON
      p.PeopleId = px.PeopleID AND
      px.Field = 'LOGOS Member ID' LEFT OUTER JOIN
  -- subquery gets all other people w/thier member ids
  (SELECT 
        p2.PeopleID, 
		px2.Data, 
		p2.LastName, 
		p2.FirstName, 
		p2.Name, 
		p2.Cellphone, 
		p2.MemberStatusID,
		CASE WHEN (Len(p2.EmailAddress) > 1) AND (p2.SendEmailAddress1 <> 0) THEN p2.EmailAddress ELSE p2.EmailAddress2 END AS [EmailAddress]
   FROM CMS_CGS.dbo.People p2 LEFT OUTER JOIN
		CMS_CGS.dbo.PeopleExtra px2 ON
			p2.PeopleId = px2.PeopleID AND
			px2.Field = 'LOGOS Member ID'
  ) s ON
		p.PositionInFamilyID = 10 AND
		p.PeopleId <> s.PeopleId AND
      ((f.HeadOfHouseholdSpouseId = s.PeopleId) OR
	  (f.HeadOfHouseholdId = s.PeopleId))
WHERE
	p.PeopleID not in(2,3,101)
