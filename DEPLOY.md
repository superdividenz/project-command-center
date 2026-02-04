# Project Command Center — Deployment Guide

Deploy **backend** and **frontend** to [Railway](https://railway.app). Both use Node.js and Express; Railway sets `PORT` automatically.

---

## Prerequisites

- [Railway CLI](https://docs.railway.app/develop/cli) (optional): `npm i -g @railway/cli`
- GitHub repo connected to Railway, or use the Railway dashboard

---

## 1. Deploy Backend

1. In Railway: **New Project** → **Deploy from GitHub repo** (or use CLI).
2. Select this repo and set **Root Directory** to `backend` (or deploy only the `backend` folder).
3. Railway will:
   - Use **Nixpacks** (from `backend/railway.json`)
   - Run **`node server.js`** (reads `process.env.PORT`)
4. Add a **public domain** in the backend service → **Settings** → **Networking** → **Generate domain**.
5. Note the URL (e.g. `https://your-backend.up.railway.app`). Use it as the API base for the frontend.

**Local backend**

```bash
cd backend
npm install
node server.js
# Runs on http://localhost:3001 (or PORT from env)
```

---

## 2. Deploy Frontend

1. In the same or a new Railway project: **New Service** → **Deploy from same GitHub repo**.
2. Set **Root Directory** to `frontend`.
3. Railway will:
   - Use **Nixpacks** (from `frontend/railway.json`)
   - Run **`node server.js`** (serves `index.html` and static files on `process.env.PORT`)
4. Add a **public domain** for the frontend service.
5. (Optional) Set **Backend URL** in frontend env (e.g. `BACKEND_URL=https://your-backend.up.railway.app`) if the dashboard calls the API.

**Local frontend**

```bash
cd frontend
npm install
node server.js
# Runs on http://localhost:3000 (or PORT from env)
```

---

## 3. Project structure (reference)

```
project-command-center/
├── backend/
│   ├── server.js        # Express API (dynamic PORT for Railway)
│   ├── package.json     # Express dependency
│   └── railway.json     # Railway config
├── frontend/
│   ├── index.html       # Dashboard HTML
│   ├── server.js        # Node server for Railway (serves static)
│   ├── package.json     # Express dependency
│   └── railway.json     # Railway config
└── DEPLOY.md            # This guide
```

---

## 4. Environment variables (optional)

- **Backend:** Add any env vars in Railway → backend service → **Variables** (e.g. database URL).
- **Frontend:** Add `BACKEND_URL` or `API_URL` if the dashboard calls the backend; use that in `index.html` or future JS for API requests.

---

## 5. Monorepo / root directory

- Deploy **two services** from the same repo.
- Backend service: **Root Directory** = `backend`.
- Frontend service: **Root Directory** = `frontend`.
- Each service has its own `railway.json` and `package.json`; Nixpacks will install and run from the correct folder.

You’re done. Backend and frontend will be live on their Railway URLs.
