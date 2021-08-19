#!/bin/bash

docker exec -it mysql bash -c \
"expect -c \
'spawn mysql -u root -p
expect \"Enter password:\"
send \"root\n\"
expect \"mysql>\"
send \"use study_management_app_development;\n\"
send \"show tables;\n\"
interact'"