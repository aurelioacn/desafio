gunicorn.sh
#!/bin/sh
gunicorn --log-level debug api:app
