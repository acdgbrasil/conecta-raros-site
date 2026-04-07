---
title: "No hardcoded secrets or API keys"
scope: "pull_request"
severity_min: "critical"
buckets: ["security"]
enabled: true
---

## Instructions

Scan PR diff for hardcoded secrets, API keys, tokens, or credentials.

Flag: API keys, bearer tokens, database passwords, .env files committed, hardcoded URLs with credentials.

Allowed: environment variable references, .env.example with placeholders, config.js reading from runtime config.
