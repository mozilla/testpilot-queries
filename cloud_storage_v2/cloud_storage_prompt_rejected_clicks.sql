SELECT payload.branch AS branch, COUNT(payload.data.attributes['message']) AS rejectClicks
FROM default.telemetry_shield_study_addon_parquet
WHERE payload.study_name = 'cloudstorage-webextensionExperiment@shield.mozilla.org'
  AND application.channel = 'release'
  AND payload.testing = false
  AND creation_date  > '2018-06-27'
  AND creation_date  < '2018-07-12'
  AND payload.data.attributes['message'] = 'prompt_rejected'
GROUP BY 1
