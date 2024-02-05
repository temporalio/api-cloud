# Temporal Cloud Operations API (Cloud Ops API) proto files (Public Preview)

> These apis are currently offered as a Public Preview. While they are production worthy, they could change. Please reach out to Temporal Support if you have questions.

## How to use

To use the Cloud Ops API in your project, preform the following 4 steps:
1. Copy over the protobuf files under [temporal](temporal) directory to your desired project directory
2. Use [grpc](https://grpc.io/docs/) to compile and generate code in your desired programming language, adding the generated .proto files to your project
3. Create a client connection in your code using a Temporal Cloud API Key (see Samples below)
4. Use the Cloud Operations API services to automate Cloud Operations, such as creating users or namespaces

### API Version

The client is expected to pass in a `temporal-cloud-api-version` header with the api version identifier with every request it makes to the apis. The backend will use the version to safely mutate resources.

Current Version:

https://github.com/temporalio/api-cloud/blob/main/VERSION#L1C1-L1C14

### URL

The grpc URL the clients should connect to:
```
saas-api.tmprl.cloud:443
```

## Samples

Refer [cloud-samples-go](https://github.com/temporalio/cloud-samples-go/blob/main/cmd/worker/README.md) sample repository demonstrating how to use the cloud ops api in a Go client. 
    This sample demonstrates how to automate Cloud Operations using Temporal Workflows with Cloud Operations API requests made within Workflow Activities.
    See [here](https://github.com/temporalio/cloud-samples-go/blob/60d5cbca8696c87fb184efc56f5ae117561213d2/client/api/client.go#L16) for a quick reference to connect to Temporal Cloud with an API Key
Refer [temporal-cloud-api-client-java](https://github.com/steveandroulakis/temporal-cloud-api-client-java) sample repository demonstrating how to use the cloud ops api in a Java client.
Refer [temporal-cloud-api-client-typescript](https://github.com/steveandroulakis/temporal-cloud-api-client-typescript) sample repository demonstrating how to use the cloud ops api in a Typescript client.
Refer [temporal-cloud-api-client-kotlin](https://github.com/steveandroulakis/temporal-cloud-api-client-kotlin) sample repository demonstrating how to use the cloud ops api in a Kotlin client.


