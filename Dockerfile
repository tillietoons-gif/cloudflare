FROM cloudflare/cloudflared:latest

ENTRYPOINT ["cloudflared"]

CMD ["tunnel", "--no-autoupdate", "run"]
