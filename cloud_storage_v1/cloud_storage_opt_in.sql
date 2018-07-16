SELECT substr(payload.branch, 8, 26) AS branch, COUNT(payload.data.attributes['message']) AS promptOptInclicks
FROM default.telemetry_shield_study_addon_parquet_v1
WHERE payload.study_name = 'cloud-storage-study'
  AND application.channel = 'release'
  AND payload.testing = false
  AND creation_date  > '2017-10-29'
  AND creation_date  < '2017-11-15'
  AND payload.data.attributes['message'] = 'prompt_opted_in'
GROUP BY 1
