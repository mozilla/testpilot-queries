SELECT payload.branch AS branch, payload.data.attributes['provider_keys'] AS provider, count(distinct client_id) as client
FROM default.telemetry_shield_study_addon_parquet_v1
WHERE payload.study_name = 'cloud-storage-study'
  AND application.channel = 'release'
  AND payload.data.attributes['message'] = 'addon_init'
  AND payload.testing = false
  AND creation_date  > '2017-10-29'
  AND creation_date  < '2017-11-15'
  AND payload.data.attributes['provider_keys'] in ('Dropbox,GDrive', 'GDrive', 'Dropbox')
GROUP BY 1,2
