---
title: "Prevent XSS in dynamic HTML content"
scope: "file"
path: ["src/**/*.js"]
severity_min: "critical"
languages: ["jsts"]
buckets: ["security"]
enabled: true
---

## Instructions

This is a vanilla JS site that manipulates DOM directly. Flag potential XSS vectors.

Flag:
- `innerHTML` with user-supplied or API-sourced data without sanitization
- `document.write()` with dynamic content
- `eval()` or `Function()` constructor with dynamic strings
- Template literals inserted into DOM without escaping
- URL parameters used directly in DOM without validation

Allowed:
- `textContent` assignments (safe by default)
- Static HTML strings with no dynamic values
- `innerHTML` with hardcoded HTML only
