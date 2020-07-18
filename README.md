# Tesla Owner-API Wrapper

Fetches vehicle data via curl from the tesla owners API  and saves them as JSON-File. Periodic updates with cronjob.
Provides PHP endpoint to access saved vehicle data as JSON over http without authentication.
Provides setup script to fetch an OAuth2 access token and configure the desired vehicle from the account. No passwords are saved.

## Getting startet
Run `bin/setup.sh`

Setup cronjobs in cron folder on your server.
