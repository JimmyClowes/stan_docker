docker run \
--name stan \
-d --rm \
-v ~/proj_repos:/home/user/source \
-v ~/.config/gcloud:/home/user/.config/gcloud \
-v ${SSH_AUTH_SOCK}:/home/user/ssh-agent \
-e SSH_AUTH_SOCK=/home/user/ssh-agent \
stan_docker