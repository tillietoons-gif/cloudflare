# cloudflare-rdp

Runs a Cloudflare Tunnel (`cloudflared`) in Docker so Windows Remote Desktop
(port 3389) on the same host can be reached through Cloudflare Access.

**Requirement:** this container must run on the same machine as the Windows
RDP service. It cannot reach a GitHub-hosted `windows-latest` runner's localhost.

## 1. Cloudflare route

In Cloudflare Zero Trust, create a published application:

| Setting      | Value                            |
|--------------|----------------------------------|
| Hostname     | rdp.example.com                  |
| Service type | RDP                              |
| Destination  | rdp://host.docker.internal:3389  |

Restrict the Access policy to your own email address.

## 2. Start the tunnel

```powershell
Copy-Item .env.example .env
notepad .env   # paste your real tunnel token
docker compose up -d --build
docker compose ps
docker compose logs -f cloudflared
```

Stop with `docker compose down`.

## 3. Connect from a client

```powershell
winget install --id Cloudflare.cloudflared -e
cloudflared access rdp --hostname rdp.example.com --url rdp://localhost:3390
```

In another terminal:

```powershell
mstsc.exe /v:localhost:3390
```

Authenticate through Cloudflare Access, then enter your Windows credentials.

## Security notes

- Never commit `.env`; it is excluded by `.gitignore` and `.dockerignore`.
- RDP port 3389 is not published by Docker; access goes only through the tunnel.
