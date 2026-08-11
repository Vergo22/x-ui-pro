# XUI-PRO Custom Panel

This is the custom management UI for the existing XUI-PRO installation.

It does not replace XUI/Xray, Nginx, the database, subscriptions, WARP, v2rayA, or the installer. It uses the authenticated X-UI API from the same origin.

## Pages
- Login
- Dashboard
- Inbounds
- Clients
- Useful Tools
- Panel Settings

## Deployment
Use `install-panel.sh` on the XUI-PRO server. It detects the existing X-UI port and web base path and creates an Nginx `/panel/` route.
