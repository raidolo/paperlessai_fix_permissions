# paperlessai_fix_permissions
A little docker container to fix the tags permissions made by paperless-ai and allow multiple users in the same group to see the AI Generated tag applied by paperless-ai when you use it with a Paperless-NMGX Superuser to set the AI Tags. 
The original script has been made by @WernerWhite here https://github.com/clusterzx/paperless-ai/discussions/326#discussioncomment-12365575
I've improved the number of items retrieved as per my comment here: https://github.com/clusterzx/paperless-ai/discussions/326#discussioncomment-13552500

# Prebuilt image

The docker image build from the Dockerfile can be found here: https://hub.docker.com/r/raidolo/paperlessai-fix

then run the container with this command:

Replace the variables in the <> with your values
```
docker run --name paperlessai_fix -d \
  -e API_URL="http://<your_paperless_ip>:8000/api"  \
  -e API_TOKEN="<SuperUser Token>" \
  -e AIUSER="<superuser>" \
  -e PermissionGroup="<YourGroup>" \
  raidolo/paperlessai-fix 
```



# Container Build 
If you want to build the container yourself follow these instructions: 

```
git clone https://github.com/raidolo/paperlessai_fix_permissions.git
cd paperlessai_fix_permissions
docker build -t paperlessai-fix .
```

# Container run 
Replace the variables in the <> with your values
```
docker run --name paperlessai_fix -d \
  -e API_URL="http://<your_paperless_ip>:8000/api"  \
  -e API_TOKEN="<SuperUser Token>" \
  -e AIUSER="<superuser>" \
  -e PermissionGroup="<YourGroup>" \
  paperlessai-fix 
```

# Debug
You can check the log of the script simply running the docker logs output (wait the first run first!)
```
docker logs paperlessai_fix
```
