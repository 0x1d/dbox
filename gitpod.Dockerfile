image:
  file: .gitpod.Dockerfile

checkoutLocation: "demopod"

workspaceLocation: "./demopod/.gitpod"

tasks:
  - name: Open the Readme
    command: gp open readme.md

  - name: Setup

    init: |
      ##
      ## install demopod
      make -C /workspace/demopod it so

    command: |
      ##
      # configure env vars.      
      echo "
      export APP_CUSTOM_URL=$(gp url)
      export RPC_ADDRESS=$(gp url 26657):443
      export API_ADDRESS=$(gp url 1317)
      " >> ~/.bashrc && source ~/.bashrc

ports:
  - port: 1317
  - port: 26657
  - port: 3000
  - port: 8443
    visibility: public