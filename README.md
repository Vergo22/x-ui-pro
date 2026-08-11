# XUI-PRO Custom Panel

This is the custom management UI for the existing XUI-PRO/X-UI backend.

## Install

After XUI-PRO has been installed, run:

```bash
sudo bash /path/to/panel/install-panel.sh
```

The installer:

- reads the existing X-UI port/base path from `/etc/x-ui/x-ui.db`;
- keeps the existing XUI authentication/session;
- serves the custom UI at `/panel/`;
- proxies `/panel/login`, `/panel/logout`, and `/panel/api/*` to the existing XUI backend;
- adds the Nginx locations inside the existing XUI-PRO `server {}` block;
- validates and reloads Nginx.

No XUI credentials are stored in this repository.

## URL

After installation:

`https://YOUR-DOMAIN/panel/`
