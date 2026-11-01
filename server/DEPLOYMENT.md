# GulfJobsHub full-stack deployment

## What this package contains
- Existing GulfJobsHub responsive front-end and SEO files.
- Node.js 22+ HTTP server and SQLite database (no third-party runtime packages).
- Job seeker and employer registration/login; password hashing with scrypt; HttpOnly session cookies.
- Employer job submissions with pending moderation; public search only returns approved jobs.
- Admin approval/rejection; application submission; private PDF CV storage; applicant/employer/admin application views; saved jobs; alert preference API.
- Account, dashboard and employer/admin workflows at `account.html` and `portal.html`.
- Job-seeker profile preferences and private profile CV upload/download/removal (PDF only, max 4 MB).

## Important hosting requirement
GitHub Pages cannot run this backend. To operate the complete site, deploy this folder to a Node.js 22+ host or a Docker host, and point the domain to that server. The server serves the website and `/api/*` from the same origin. Do not upload only the HTML files to GitHub Pages expecting login, posting or applications to work.

## Start locally
1. Install Node.js 22.5 or newer.
2. In this `server` directory, set `ADMIN_EMAIL` and `ADMIN_PASSWORD` environment variables. Use a unique password of at least 16 characters.
3. Run `npm test`.
4. Run `npm start` and open `http://localhost:3000`.

Example:
```sh
ADMIN_EMAIL=admin@yourdomain.com ADMIN_PASSWORD='a-unique-long-password' DATA_DIR=./data npm start
```

The first start creates the administrator account if it does not already exist. Changing the environment password later does not reset an existing account; use the database/user-management process to rotate it.

## Docker
From the project root:
```sh
docker build -f server/Dockerfile -t gulfjobshub .
docker run -d --name gulfjobshub -p 3000:3000 \
  -e ADMIN_EMAIL=admin@yourdomain.com \
  -e ADMIN_PASSWORD='a-unique-long-password' \
  -v gjh-data:/data gulfjobshub
```
Put HTTPS reverse proxy (Caddy/Nginx) in front of the container. Ensure `/data` is persistent and backed up. Never expose SQLite or upload files as public static paths.

## Workflow
1. Admin signs in at `/account.html` using the bootstrap credentials.
2. Employer registers as Employer, signs in, and submits a vacancy in `/portal.html`.
3. Admin reviews and approves/rejects the pending vacancy in `/portal.html`.
4. Approved jobs appear in public search. Job seekers register, sign in and apply from a vacancy detail page.
5. Employers can review applications and download attached PDF CVs from their dashboard. CV access is limited to the applicant, that job's employer, and admin.

## Security and operational notes
- Use HTTPS in production. The session cookie is Secure when `NODE_ENV=production`.
- Keep `DATA_DIR` on persistent private storage; back up the SQLite database and uploads together.
- Configure host-level rate limiting, firewall, automated backups, monitoring and malware scanning for uploads before public launch.
- For CV malware scanning, install ClamAV on the host/container, keep its virus definitions updated, and set `REQUIRE_MALWARE_SCAN=true` (optionally set `CLAMSCAN_PATH`). With this setting, CV uploads fail closed with HTTP 503 if ClamAV is missing or unavailable, and infected files are rejected. Do not enable this setting until ClamAV is installed and its definitions are current.
- The application accepts PDF CVs only, max 4 MB, validates strict Base64 encoding, the PDF header and EOF marker, and can require ClamAV scanning before saving either profile or application CVs. No public CV URLs are created. Profile CVs are private to the owning job seeker; application CVs are available only to the applicant, that job’s employer and admin.
- Email verification, password reset, transactional email alerts, CAPTCHA, company document verification and external job feeds are not included. Email alerts are stored as preferences only; delivery requires an email provider integration.
- The admin bootstrap password is not displayed or stored in source code. Set it through deployment secrets.
- This is a functional self-hosted starter system, not a claim of legal/security certification or a production penetration test.
