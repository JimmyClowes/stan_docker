docker build \
-t stan_docker \
--build-arg USER_ID=$(id -u) \
--build-arg GROUP_ID=$(id -g) \
.