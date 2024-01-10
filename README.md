# Template showing how to start developing with Terraform and the given devcontainer

The purpose of this template is to allow for a quick start with AWS IaC projects using the provided devcontainer.

## Quick Start

- ensure the prerequisites:
  - Development box (PC, remote dev machine etc.):
    - PC able to run docker compose projects
    - git client(s) to clone the repository
    - Visual Studio Code
  - AWS
    - account where permissions do administer resources is granted 
- generate a new repository from the template
- clone the generated repository
- open the folder in Visual Studio Code
  - the IDE detects the presence of a devcontainer and asks to "reopen in container"
- once Visual Studio Code reopens in container:
  - Select AWS extensions and execute the necessary log ins
  - Select the checkov extension and add the API token. If you don't have one, register to the service
    - Details [here](https://marketplace.visualstudio.com/items?itemName=Bridgecrew.checkov#:~:text=Open%20a%20file%20you%20wish,now%20appear%20in%20your%20editor.)
  - In a terminal:
    - execute `aws configure` and connect the shell to AWS
    - execute `cd /workshop && terraform init`

## Other Aspects

If you want to use this template for multiple projects, it is recommended to change the submodule mount path to unique names, otherwise the docker compose operations on the same directory may go in conflict with one another. This can be easily achieved with a `git move` command as explained in [this article](https://themightyprogrammer.dev/snippet/moving-git-submodule).