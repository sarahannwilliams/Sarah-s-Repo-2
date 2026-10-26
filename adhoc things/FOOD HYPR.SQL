SELECT
    DATE_TRUNC('week', a.dt::date) AS week_of,

    COUNT(DISTINCT a.unique_visitor_cookie_id) AS unique_browsers,

    COUNT(DISTINCT a.hashed_id) AS accounts,

    COUNT(
        DISTINCT CASE
            WHEN d.age_range IN (
                '11-15',
                '13-15',
                '16-19',
                '20-24',
                '25-29',
                '30-34'
            )
            THEN a.hashed_id
        END
    ) AS under_35_accounts,

    ROUND(
        100.0 * COUNT(
            DISTINCT CASE
                WHEN d.age_range IN (
                    '11-15',
                    '13-15',
                    '16-19',
                    '20-24',
                    '25-29',
                    '30-34'
                )
                THEN a.hashed_id
            END
        )
        / NULLIF(COUNT(DISTINCT a.hashed_id), 0),
        1
    ) AS under_35_accounts_pct,

    COUNT(DISTINCT a.visit_id) AS visits

FROM s3_audience.audience_activity a

LEFT JOIN prez.profile_extension d
    ON a.hashed_id = d.bbc_hid3

WHERE a.dt::date >= '2023-04-03'
  AND a.dt::date < '2024-04-01'
  AND a.destination = 'PS_FOOD'
  AND LOWER(a.geo_country_site_visited) IN (
      'united kingdom',
      'jersey',
      'guernsey',
      'isle of man'
  )

GROUP BY 1
ORDER BY 1;
