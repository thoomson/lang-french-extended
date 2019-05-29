VERSION=master

TEMP_DIR=`mktemp -d`
WORK_DIR=`pwd`

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if ! [ -x "$(command -v same-yaml)" ]; then
  echo 'Error: same-yaml is not installed.' >&2
  exit 1
fi

if [[ ! "$TEMP_DIR" || ! -d "$TEMP_DIR" ]]; then
  exit 1
fi

function cleanup {
  rm -rf "$TEMP_DIR"
}

cd "$TEMP_DIR"

curl -s -L "https://raw.githubusercontent.com/Fajuu/ContactButton/master/locale/en.yml"

RC=0

for $1 in en.yml
for $2 in fajuu-contactbutton.yml.yml
do
  echo "Testing $1 against $2:"
  same-yaml --ref "$1.yml" --tra "$WORK_DIR/$2.yml"
  if [ $? -eq 1 ]
  then
    RC=1
    printf "${RED}⨉ failed${NC}\n"
  else
    printf "${GREEN}✓ passed${NC}\n"
  fi
  echo
done

trap cleanup EXIT

exit $RC
