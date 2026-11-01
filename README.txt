GULFJOBSHUB — FULL-STACK INDEED-STYLE JOB PORTAL

This project now includes the existing responsive GulfJobsHub website plus a Node.js/SQLite backend. It is not a GitHub-Pages-only static site. GitHub Pages cannot execute the backend; deploy the complete project to a Node.js 22+ server or Docker host.

KEY FEATURES
- Six GCC countries: Saudi Arabia, UAE, Qatar, Kuwait, Bahrain and Oman.
- Job seeker and employer registration/sign-in with hashed passwords and secure HTTP-only session cookies.
- Employer job submission and administrator approval/rejection.
- Public search for approved vacancies only. No fabricated/sample jobs have been added.
- Job applications, optional PDF CV upload (4 MB maximum), employer applicant inbox, protected CV downloads.
- Saved jobs, account dashboard, admin moderation dashboard.
- Job seeker profile preferences stored in SQLite; private PDF CV upload/download/delete from profile (4 MB maximum).
- Job alert preferences stored in account; email delivery is not enabled without an email provider.
- Existing Google verification HTML/meta, robots.txt and sitemap.xml retained.

START
See `server/DEPLOYMENT.md` for full setup. Requirements: Node.js 22.5+. Set ADMIN_EMAIL, ADMIN_PASSWORD and DATA_DIR, then run `cd server && npm test && npm start`. The server hosts the front end and API on one origin at http://localhost:3000.

ADMIN
The first server start creates the admin account from ADMIN_EMAIL and ADMIN_PASSWORD if the email does not already exist. Store credentials in deployment secrets; never place them in public files.

IMPORTANT
The old GitHub Pages hosting cannot run accounts, database, applications or CV storage. Keep the current live website unchanged until the new backend host and domain are configured and verified. This ZIP does not upload or commit anything to GitHub. Email delivery/verification, password reset, CAPTCHA, malware scanning, external vacancy feeds and independent penetration testing remain deployment/integration work. See TEST-REPORT.txt for exact test scope.

Security notes: API and static responses include CSP and common browser security headers. Login and registration have an in-memory IP rate limit (10 requests per 15 minutes). Use an upstream WAF/rate limiter in production because this local limiter resets on restart and is not shared across multiple instances.
