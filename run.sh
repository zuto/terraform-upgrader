SSH_DIR="c:\Users\tim.borrowdale\.ssh"
GIT_SSH_KEY=github

docker run \
-e STARTVER=12 \
-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
-e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
-e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
-e GIT_SSH_KEY=$GIT_SSH_KEY \
-v "$1:/tf" \
-v "$SSH_DIR:/ssh" \
tfu $2