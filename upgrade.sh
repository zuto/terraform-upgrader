eval $(ssh-agent -s)
chmod 0700 /ssh/$GIT_SSH_KEY
ssh-add /ssh/$GIT_SSH_KEY

mkdir ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts

cd /tf
rm -rf .terraform/

if [ $STARTVER -le 12 ]; then
  TFVER=0.12.31
  echo "[$TFVER] Checking initial state with v0.12.31"
  /usr/bin/terraform/$TFVER/terraform init -reconfigure
  /usr/bin/terraform/$TFVER/terraform workspace select $1
  /usr/bin/terraform/$TFVER/terraform plan -detailed-exitcode
  if [ $? -ne 0 ]; then
    echo "[$TFVER] Plan resulted in changes - please manually apply/discard these changes and rerun this image"
    exit 1
  fi
  echo "[$TFVER] Done"
  echo ""
fi

if [ $STARTVER -le 13 ] ; then
  TFVER=0.13.7
  echo "[$TFVER] Apply 0.13 upgrade"
  /usr/bin/terraform/$TFVER/terraform init -reconfigure
  /usr/bin/terraform/$TFVER/terraform workspace select $1
  /usr/bin/terraform/$TFVER/terraform 0.13upgrade -yes
  /usr/bin/terraform/$TFVER/terraform apply << EOF
no
EOF
  if [ $? -ne 0 ]; then
    echo "[$TFVER] Apply requested input, either for variables or because changes would have been made if confirmed - please review and rerun this image"
    exit 1
  fi
  echo "[$TFVER] Done"
  echo ""
fi

if [ $STARTVER -le 14 ]; then
  TFVER=0.14.11
  echo "[$TFVER] Try to apply with 0.14"
  /usr/bin/terraform/$TFVER/terraform init -reconfigure
  /usr/bin/terraform/$TFVER/terraform workspace select $1
  /usr/bin/terraform/$TFVER/terraform apply << EOF
no
EOF
  if [ $? -ne 0 ]; then
    echo "[$TFVER] Apply requested input, either for variables or because changes would have been made if confirmed - please review and rerun this image"
    exit 1
  fi
  echo "[$TFVER] Done"
  echo ""
fi 

TFVER=$TF_VER_LATEST
echo "[$TFVER] Try to apply with $TFVER"
/usr/bin/terraform/$TFVER/terraform init -reconfigure
/usr/bin/terraform/$TFVER/terraform workspace select $1
/usr/bin/terraform/$TFVER/terraform apply << EOF
no
EOF
if [ $? -ne 0 ]; then
  echo "[$TFVER] Apply requested input, either for variables or because changes would have been made if confirmed - please review and rerun this image"
  exit 1
fi
echo "[$TFVER] Done"



