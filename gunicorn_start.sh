gunicorn_start.sh
#!/bin/sh
gunicorn --log-level debug api:app
