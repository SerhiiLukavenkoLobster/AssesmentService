Getting started
================

Requirements
------------

* terraform 0.12+
* docker
* Azure account
* Docker hub account with access to https://cloud.docker.com/u/stanpogrebnyak/repository/docker/stanpogrebnyak/lobster
* create env variables with identity for your azure account:

    export TF_VAR_azure_subscription_id="XXX"

    export TF_VAR_azure_client_id="XXX"

    export TF_VAR_azure_client_secret="XXX"

    export TF_VAR_azure_tenant_id="XXX"

Docker
------

Build the container:

   docker build . -t lobster:latest

Tag container with proper tags:

   docker tag lobster:latest stanpogrebnyak/lobster:latest

Push container to Dockerhub:

  docker push stanpogrebnyak/lobster:latest

Container will be available for infrastructure (https://cloud.docker.com/u/stanpogrebnyak/repository/docker/stanpogrebnyak/lobster)

Infra
-----

Run init to download and enable modules:

    terraform init

Run apply to spin up infrastructure:

    terraform apply

After you done run destroy to cleanup:

    terraform destroy

Container redeploy
------------------

So far the redeploy works via tainting resource in Azure

    terraform taint module.infra.azurerm_container_group.events

And apply, that will recreate container instance with latest from dockerhub

    terraform apply