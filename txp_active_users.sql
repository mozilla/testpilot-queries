/*
 * Owner: rrayborn@mozilla.com
 * Reviewer: msamuel@mozilla.com
 * Status: Reviewed
 * Edited: 8/3/2017 by ssuh@mozilla.com -- Modified to use txp_mau_dau_simple
 * Edited: 5/30/2018 by teon@mozilla.com -- Added two new experiments: Firefox Color and Side-View
 * URL: https://sql.telemetry.mozilla.org/queries/732/source
 * Dashboards: https://sql.telemetry.mozilla.org/dashboard/txp-executive-summary
 */

SELECT
  test_group,
  date,
  mau,
  dau,
  --num_new_users,
  engagement_ratio,
  smoothed_dau,
  smoothed_dau/mau AS smoothed_engagment_ratio
FROM
  ( -- Individual Experiments calculations
    SELECT
      CASE txpExperiments.test
        WHEN '@activity-streams'            THEN 'Activity Stream'
        WHEN 'universal-search@mozilla.com' THEN 'Universal Search'
        WHEN 'tabcentertest1@mozilla.com'   THEN 'Tab Center'
        WHEN 'wayback_machine@mozilla.org'  THEN 'No More 404s'
        WHEN '@min-vid'                     THEN 'Min Vid'
        WHEN 'blok@mozilla.org'             THEN 'Tracking Protection'
        WHEN 'jid1-NeEaf3sAHdKHPA@jetpack'  THEN 'Page Shot'
        WHEN 'testpilot@cliqz.com'          THEN 'Cliqz'
        WHEN 'snoozetabs@mozilla.com'       THEN 'SnoozeTabs'
        WHEN 'pulse@mozilla.com'            THEN 'Pulse'
        WHEN '@testpilot-containers'        THEN 'Containers'
        WHEN 'speaktome@mozilla.com'        THEN 'Voice Fill'
        WHEN 'notes@mozilla.com'            THEN 'Notes'
        WHEN 'FirefoxColor@mozilla.com'     THEN 'Color'
        WHEN 'side-view@mozilla.org'        THEN 'Side View'
        ELSE                                txpExperiments.test
      END                                      AS test_group,
      DATE_PARSE(txpExperiments.submission_date_s3, '%Y%m%d') AS date,
      mau                                      AS mau,
      dau                                      AS dau,
      --COALESCE(newUsers.num_new_users,0)       AS num_new_users,
      1.0*dau/mau                              AS engagement_ratio,
      AVG(dau) OVER (
        PARTITION BY txpExperiments.test
        ORDER BY txpExperiments.submission_date_s3
        ROWS BETWEEN 6 PRECEDING AND 0 FOLLOWING
      )                                        AS smoothed_dau
    FROM
      txp_mau_dau_simple txpExperiments
      /*LEFT JOIN tmp_user_start newUsers ON (
        txpExperiments.day = newUsers.day
        AND txpExperiments.test = newUsers.test
      )*/
    WHERE
      txpExperiments.submission_date_s3 < DATE_FORMAT(CURRENT_TIMESTAMP, '%Y%m%d')
      AND txpExperiments.submission_date_s3 > DATE_FORMAT(DATE_ADD('day', -7*10, CURRENT_TIMESTAMP), '%Y%m%d')
      AND test NOT IN('universal-search@mozilla.com' , 'wayback_machine@mozilla.org' , 'blok@mozilla.org')
    GROUP BY
      txpExperiments.test,
      txpExperiments.submission_date_s3,
      txpExperiments.mau,
      txpExperiments.dau
      --newUsers.num_new_users
  )
WHERE date > DATE_ADD('day', -7*9, CURRENT_TIMESTAMP) -- Last 60 days
ORDER BY 1, 2
