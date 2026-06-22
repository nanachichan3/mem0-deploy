# Full Mem0 platform API (main:app) — auth, dashboard API routes, Alembic migrations.
# Replaces mem0/mem0-api-server, which only exposes OSS memory REST routes (no /auth/*).

FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --filter=blob:none --sparse https://github.com/mem0ai/mem0.git /tmp/mem0 \
    && cd /tmp/mem0 \
    && git sparse-checkout set server \
    && mv server/* /app/ \
    && rm -rf /tmp/mem0

COPY entrypoint-mem0-api.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir \
        "google-genai>=1.0" \
        "psycopg[binary,pool]" \
        "mem0ai[graph]" \
        rank-bm25 \
        langchain-neo4j \
        neo4j

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
