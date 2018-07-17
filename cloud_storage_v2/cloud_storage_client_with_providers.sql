SELECT payload.branch AS branch, payload.data.attributes['provider_keys'] AS provider, count(distinct client_id) as client
FROM default.telemetry_shield_study_addon_parquet
WHERE payload.study_name = 'cloudstorage-webextensionExperiment@shield.mozilla.org'
  AND application.channel = 'release'
  AND payload.data.attributes['message'] = 'addon_init'
  AND payload.testing = false
  AND creation_date  > '2018-06-27'
  AND creation_date  < '2018-07-17'
  AND payload.data.attributes['provider_keys'] in ('Dropbox,GDrive', 'GDrive', 'Dropbox')
GROUP BY 1,2
