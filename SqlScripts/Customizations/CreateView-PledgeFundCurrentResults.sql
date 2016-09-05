CREATE VIEW [cgs].[PledgeFundCurrentResults]
AS
SELECT
	b.FundId,
	ISNULL(x2.StrValue, 'Regular') as [CapitalCampaignClass],
	CASE WHEN (b.TotalPledgedAmount <= TotalContributedAmount) THEN 'Completed'
		WHEN (DATEDIFF(MM, b.LastContributionDue, b.NextContributionDue) = 1) THEN 'Monthly'
		WHEN (DATEDIFF(MM, b.LastContributionDue, b.NextContributionDue) = 3) THEN 'Quarterly'
		WHEN (DATEDIFF(MM, b.LastContributionDue, b.NextContributionDue) = 6) THEN 'Semi-Annual'
		WHEN (DATEDIFF(MM, b.LastContributionDue, b.NextContributionDue) = 12) THEN 'Annual'
		ELSE 'One-Time' END AS [PledgePaymentSchedule],
	ISNULL(b.PledgePeopleID, ContributionOnlyID) AS [PeopleID], 
	ISNULL(x1.Data, '') AS [LogosMemberID],
	a.LastName,
	a.Addressee,
	a.Salutation,
	a.Address1 + CASE WHEN Len(a.Address2) > 0 THEN ', ' + Address2 ELSE '' END as [StreetAddress],
	a.City,
	a.State,
	a.Zip as [Zipcode],
	b.TotalPledgedAmount,
	b.PledgeToDateAmount,
	b.TotalContributedAmount,
	CASE WHEN b.PledgeToDateAmount > TotalContributedAmount THEN b.PledgeToDateAmount - TotalContributedAmount ELSE 0 END as [AmountDue],
	b.LastContributionDue,
	LastContributionRecv,
	b.NextContributionDue,
	DATEFROMPARTS(Year(getdate()), Month(getdate()), 1) AS [RunForDate]
FROM
	(	SELECT 
			c.FundId,
			p.FamilyId,
			MAX(CASE WHEN (h.BundleHeaderTypeID = 6) THEN c.PeopleID ELSE Null END) as [PledgePeopleID],
			MAX(CASE WHEN (h.BundleHeaderTypeID <> 6) THEN c.PeopleID ELSE Null END) as [ContributionOnlyID],
			SUM(CASE WHEN (h.BundleHeaderTypeID = 6) THEN 1 ELSE 0 END) as [PledgesScheduled],
			SUM(CASE WHEN h.BundleHeaderTypeID = 6 THEN c.ContributionAmount ELSE 0 END) as [TotalPledgedAmount],
			SUM(CASE WHEN (h.BundleHeaderTypeID = 6) AND (c.ContributionDate <= getdate()) THEN 1 ELSE 0 END) as [PledgesDueToDate],
			SUM(CASE WHEN (h.BundleHeaderTypeID = 6) AND (c.ContributionDate <= getdate()) THEN c.ContributionAmount ELSE 0 END) as [PledgeToDateAmount],
			SUM(CASE WHEN h.BundleHeaderTypeID = 2 THEN c.ContributionAmount ELSE 0 END) as [TotalContributedAmount],
			MAX(CASE WHEN (h.BundleHeaderTypeID = 6) AND (c.ContributionDate <= getdate()) THEN c.ContributionDate ELSE Null END) as [LastContributionDue],
			MIN(CASE WHEN (h.BundleHeaderTypeID = 6) AND (c.ContributionDate > getdate()) THEN c.ContributionDate ELSE Null END) as [NextContributionDue],
			MAX(CASE WHEN h.BundleHeaderTypeID = 2 THEN c.ContributionDate ELSE Null END) as [LastContributionRecv]
		FROM dbo.Contribution c
		JOIN dbo.ContributionFund t ON c.FundId = t.FundId
		JOIN dbo.People p ON p.PeopleId = c.PeopleId
		JOIN dbo.BundleDetail d ON d.ContributionId = c.ContributionId
		JOIN dbo.BundleHeader h ON h.BundleHeaderId = d.BundleHeaderId
		WHERE t.FundPledgeFlag = 1
		GROUP BY c.FundId, p.FamilyId
	) as [b] LEFT OUTER JOIN
	cgs.ContributorAddressee AS [a] ON 
		a.PeopleID = ISNULL(b.PledgePeopleID, ContributionOnlyID) LEFT OUTER JOIN
	dbo.PeopleExtra x1 ON
		x1.PeopleId = ISNULL(b.PledgePeopleID, ContributionOnlyID) And
		x1.Field = 'LOGOS Member ID' LEFT OUTER JOIN
	dbo.PeopleExtra x2 ON
		x2.PeopleId = ISNULL(b.PledgePeopleID, ContributionOnlyID) And
		x2.Field = 'Capital Campaign Classification'

GO
