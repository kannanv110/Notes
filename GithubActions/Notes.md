# Github Actions

## Github Actions LinkedIn course link
https://www.linkedin.com/learning/github-actions-cert-prep-by-microsoft-press

https://github.com/timothywarner/actions-cert-prep

https://github.com/timothywarner-org/actions-cert-prep

LinkedIn AI Assist keyword: 
  - Help me understand this better
  - Can you simplify this?

## GitHub Overview
GitHub is a collaborative platform for developers, owned by Microsoft. It offers public and private repositories and various plans (Free, Pro, Team, Enterprise). GitHub is known for source code control using Git and features like GitHub Copilot for AI-powered coding assistance.

## GitHub Actions

### Platform

GitHub Actions is an automation platform within GitHub for CI/CD workflows.

### Actions

Scripts invoked within workflows to automate tasks. Actions can be lowercase (specific scripts) or uppercase (the entire platform).

## Workflows

### Definition

Automated scripts in YAML format that run when specific events occur in a repository.

### Common Use Cases

CI/CD, versioning, release management, general automation, and notifications.

### Event Types
 - Push: Triggered when a new commit is pushed to a branch.
 - Pull Request: Triggered during the pull request lifecycle.
 - Issues and Releases: Events can cascade off issues and releases.
 - Manual Triggers: Using the workflow dispatch event.
 - Scheduled Events: Using cron scheduling.
 - Webhooks: HTTP requests from external services to trigger workflows.


### Example of a Push Event

#### YAML Configuration
The on keyword specifies the CI trigger, and conditions determine if the workflow runs (e.g., push to main or develop branches).
#### Use Case
Running tests after every push to a branch or deploying code to a staging environment.


### Scheduled Workflows
These are workflows that run at specific times or intervals. For example, you might want to run nightly software builds or perform hourly backups.

#### Cron Expressions
To schedule these workflows, you use cron expressions. Cron syntax can be a bit tricky, but it allows you to specify the exact timing for your workflow. For example, 0 0 * * * means the workflow will run every day at midnight.

#### Example
In your workflow file, you would have something like this:
```yaml
on:
schedule:
- cron: '0 0 * * *'
```

This line tells GitHub Actions to run the workflow every day at midnight.

#### Use Cases
Scheduled workflows are useful for tasks that need to happen regularly without manual intervention, such as:

Running nightly builds to ensure your codebase is always in a deployable state.
Performing regular backups to prevent data loss.
Running periodic maintenance tasks.

Understanding these concepts will help you automate tasks that need to be performed at regular intervals, making your workflows more efficient and reliable.

## Manual Event Workflows in GitHub Actions
### Purpose of Manual Events:

#### Utility Workflows
Sometimes, you have workflows that should only run when triggered manually by a user. For example, deploying to production is a critical task that you might want a human to initiate rather than automating it.
#### One-time Automation Scripts
These are scripts that you might not want to run automatically but rather on-demand, such as specific maintenance tasks.

### workflow_dispatch

#### Definition
The workflow_dispatch event is used in GitHub Actions to define workflows that can be manually triggered.

#### YAML Configuration
You specify this in your workflow YAML file to enable manual triggering. Here's an example:
```yaml
on:
  workflow_dispatch:
```

#### Usage
When you include workflow_dispatch in your workflow file, it allows users to manually trigger the workflow from the GitHub Actions tab in the repository.


#### Practical Example

##### Deploying to Production
You might have a workflow that deploys your application to a production environment. Since this is a critical task, you want to ensure a human reviews and initiates it.
##### Running Maintenance Scripts
For example, if you have a script that needs to clean up old data or perform a specific task that isn't needed regularly, you can set it up to run manually.


## How to Trigger a Manual Workflow
### Navigate to the Actions Tab:

Go to the GitHub repository where your workflow is defined.
Click on the "Actions" tab.

### Select the Workflow:

Find the workflow you want to run manually. It should have a "Run workflow" button if workflow_dispatch is configured.

### Run the Workflow:

Click the "Run workflow" button.
You may be prompted to provide input parameters if your workflow requires them.


## Benefits of Manual Workflows
### Control
Gives you control over when critical workflows are executed.
### Flexibility
Allows you to run specific tasks on-demand without waiting for an automated trigger.
### Safety
Ensures that sensitive operations, like deployments, are only performed after a human review.

By understanding these concepts, you'll be able to configure and utilize manual workflows effectively in GitHub Actions.

## Webhook Events in GitHub Actions
### What are Webhooks?

#### Definition
Webhooks are HTTP callbacks that send real-time data from one application to another when a specific event occurs.
#### Usage
They are often used to trigger workflows in response to events happening outside of GitHub, such as an external service or application.

### Configuring Webhook Events

#### YAML Configuration
In your workflow file, you use the webhook keyword to specify that the workflow should be triggered by an external event.
```yaml
on:
  webhook:
    url: http://exmple.com/my-webhook
```

#### URL Specification
You need to specify the URL endpoint that the external service will call to trigger the workflow.

### Practical Use Case:

#### Example Scenario
Imagine you have an external service that creates an issue in your GitHub repository. You can configure a webhook to trigger a build or deployment workflow whenever a new issue is created.

#### Steps
The external service sends an HTTP request to the specified webhook URL.
GitHub Actions listens for this HTTP request.
When the request is received, the specified workflow is triggered.


### Benefits of Using Webhooks:

#### Integration
Allows seamless integration with external services and APIs.
#### Real-Time Automation
Enables real-time automation of workflows based on external events.
#### Flexibility
Provides flexibility to trigger workflows from various sources outside of GitHub.

## Demonstrate a GitHub event to trigger a workflow based on a practical use case

### Scenario

The goal is to automatically deploy a website to Netlify whenever a new commit is pushed to the main branch of a GitHub repository.

```yaml
name: Deploy to Netlify

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Install dependencies
        run: npm install

      - name: Build project
        run: npm run build

      - name: Deploy to Netlify
        uses: netlify/actions/cli@1.1
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```
### Workflow Configuration

A workflow is a series of automated steps defined in a YAML file in your GitHub repository. The YAML file specifies that the workflow should trigger on a push event to the main branch.

### Runners

Runners are virtual machines provided by GitHub to execute your workflows. You can choose from Windows, macOS, and Linux runners. In this example, the workflow uses an Ubuntu runner.

### Steps in the Workflow

#### Checkout Action
This step uses the checkout@v3 action to pull the latest code from the repository.

#### Build and Deploy
The next steps involve running commands to build the project (e.g., npm install and npm build) and then deploy it to Netlify using the Netlify CLI.

#### Secrets:
Sensitive information like API keys and site IDs should be stored as secrets in your GitHub repository to keep them secure. These secrets are referenced in the workflow without exposing them in plain text.

### GitHub Docs and Marketplace

The GitHub Docs (docs.github.com/actions) provide detailed information and examples for configuring workflows.
The GitHub Marketplace (github.com/marketplace) offers a variety of actions that you can use to automate different tasks.


## Identify the correct syntax for workflow jobs

### Workflow Files Location
Each repository can optionally have a .github/workflows subdirectory that contains your workflow files.
### Jobs in Workflows
Jobs are the units of work within a workflow that execute specific tasks. These tasks are essentially scripts that perform different types of automation.
### Job Declaration
#### Keyword
Use the keyword jobs to declare a job.
#### Unique Name
Each job must have a unique name, referred to as job_name.
#### Runner Specification
The runs-on keyword specifies the runner (e.g., GitHub-hosted or self-hosted). GitHub-hosted runners come in various operating systems and platforms, offering the benefit of not having to maintain servers.

### Steps within Jobs
Each job contains a series of steps that are executed within the job. These steps can include actions and shell commands.

### Parallel Execution
Jobs in a workflow can run in parallel if they do not have dependencies. This allows for massively parallel processing, where jobs run independently on separate runner VMs.
### Workflow Example

#### Trigger
The on keyword determines when the workflow runs (e.g., on a push to the main branch).

#### Job Structure

A job, such as example-job, contains steps that call specific GitHub actions. Common actions are published by GitHub and have the prefix actions.

## Use job steps for actions and shell commands

### Automation in GitHub Actions
Automation in GitHub Actions involves creating workflows that run specific tasks automatically. These tasks are defined in jobs and steps within a workflow.

### CI/CD Process
Continuous Integration/Continuous Deployment (CI/CD) processes often trigger on events like code commits or pull requests. This automation ensures that tasks like dependency checking, testing, and security scans are performed automatically.

### Job Steps

#### Actions

You can use prebuilt actions from the GitHub Actions marketplace. These actions are 
predefined scripts that perform specific tasks.

#### Shell Commands

You can also run shell commands within your job steps. For example, you might use a shell command to install dependencies or run tests.

### YAML Syntax

The uses keyword is important for pulling prebuilt actions from the marketplace.
The run keyword allows you to execute shell commands within a step.

#### Example Workflow

A job might include steps to install dependencies using a shell command (run: npm install) and then run tests.
Each step in the job performs a specific task, contributing to the overall automation goal.

#### Practical Application

For IT operations, you might use GitHub Actions to manage infrastructure as code. For instance, when a playbook is updated, a workflow can automatically apply those changes to the target nodes.

## Use conditional keywords for steps

### Key Concepts
### Conditional Statements in GitHub Actions

GitHub Actions uses an expression language to control the execution of steps in your workflows based on specific conditions.
Common keywords include if, else, and needs.

### Using if Statements

The if keyword is used to evaluate an expression and determine whether a step should run.
For example, you can use if: github.ref == 'refs/heads/main' to run a step only if the branch is main.

### Dependencies with needs

The needs keyword is crucial for defining dependencies between jobs.
Jobs in GitHub Actions run in parallel by default. To ensure a job runs only after another job completes, you use needs.
Example: conditional_job needs initial_job to complete before it starts.


### Detailed Explanation
#### Expression Language
GitHub Actions allows you to use a syntax similar to programming languages to add logic to your workflows. This is particularly useful for automating complex CI/CD processes.

#### if Keyword
Just like in Python or PowerShell, if statements in GitHub Actions evaluate conditions. If the condition is true, the step runs. If false, it skips the step.

#### needs Keyword
This keyword helps manage dependencies. For instance, if you have a job that checks out code and another job that builds the code, you can ensure the build job only starts after the checkout job completes by using needs.


### Practical Example
#### Imagine you have two jobs

##### Initial Job
Checks out code and echoes a command.
##### Conditional Job
Runs only if the initial job completes successfully.

```yaml
jobs:
  initial_job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Echo command
        run: echo "Hello, world!"

  conditional_job:
    needs: initial_job
    runs-on: ubuntu-latest
    steps:
      - name: Execute if on main branch
      if: github.ref == 'refs/heads/main'
      run: echo "This is the main branch"
      - name: Execute if not on main branch
      if: github.ref != 'refs/heads/main'
      run: echo "This is not the main branch"
```
In this example:

The conditional_job will only run after initial_job completes.
Within conditional_job, the steps will execute based on the branch name.

This approach gives you flexibility to automate and control your workflows efficiently, making it easier to manage complex CI/CD pipelines.

## how they work together in GitHub Actions

### Key Components
#### Workflow

A workflow is a YAML script that defines the automation process. It contains one or more jobs that run in response to specific events.

#### Jobs

Jobs are units of work within a workflow. Each job runs on a specific runner and can contain multiple steps.

#### Steps

Steps are individual tasks within a job. They can be actions, shell commands, or scripts that execute in sequence.

#### Actions

Actions are reusable units of code that perform specific tasks. They can be sourced from the GitHub Actions marketplace or created custom.

#### Runs

A run is an execution of a workflow. Each time a workflow is triggered, it creates a new run.

#### GitHub Marketplace:

The marketplace is a central repository where you can discover and share actions. It provides a wide range of pre-built actions to use in your workflows.


### How They Work Together
#### Workflow:
The overall YAML script that defines what should happen when a specific event occurs (e.g., push to a repository).
#### Jobs
Within the workflow, jobs define the tasks to be performed. Each job can run independently or depend on the completion of other jobs.
#### Steps
Each job consists of steps that execute sequentially. Steps can include actions from the marketplace or custom scripts.
#### Actions
These are the building blocks of steps. Actions perform specific tasks, like checking out code or running tests.
#### Runs
When a workflow is triggered, it creates a run. The run executes the defined jobs and steps.
#### Marketplace
The marketplace provides a collection of actions that you can use in your workflows to simplify and speed up development.

### Practical Example
Imagine you have a workflow that builds and deploys your application:

 - Workflow: Defined in a YAML file, triggered by a push to the main branch.
 - Jobs: One job to build the application, another to deploy it.
 - Steps: The build job might have steps to check out the code, install dependencies, and run tests. The deploy job might have steps to package the application and deploy it to a server.
 - Actions: You might use actions from the marketplace to check out code (actions/checkout@v2) and set up a specific environment (actions/setup-node@v2).
 - Runs: Each push to the main branch triggers a new run of the workflow.
 - Marketplace: Provides pre-built actions to streamline the workflow.

This structure allows you to automate complex processes efficiently and reuse code across different workflows.

## Identify scenarios suited for using GitHub-hosted and self-hosted runners

### GitHub-Hosted Runners

 - Managed entirely by GitHub and free to use, but with limited capacity, especially during peak usage times.
 - Pre-configured with common dependencies and frameworks, making them suitable for straightforward workflows and open-source projects.
 - Costs can increase when using private repositories, so it's important to manage cost versus performance.

### Self-Hosted Runners

 - Installed on your own physical or virtual machines, giving you maximum control over the build and release environment.
 - Ideal for businesses with compliance requirements or special automation needs that GitHub-hosted runners can't meet.
 - Involves higher maintenance but can be cost-effective if you already own the infrastructure.

These points should help you understand when to use each type of runner based on your specific needs and constraints.

### Implement workflow commands as a run step to communicate with the runner

#### Workflow Commands
These are special commands you can use within your GitHub Actions workflows to interact with the runner (the machine executing your workflow).
#### Common Commands
##### set-output
Sets an output parameter that can be used in subsequent steps.
##### upload-artifact and download-artifact
Used to transfer files to and from the runner.

### Example:
Imagine you have a workflow file where you want to print a message to the logs. You can use the run command with echo to do this:
```yaml
jobs:
  example-job:
  runs-on: ubuntu-latest
  steps:
    - name: Print a message
      run: echo "Hello, GitHub Actions!"
```
Here, echo "Hello, GitHub Actions!" instructs the runner to print "Hello, GitHub Actions!" in the workflow logs.

### Practical Use
#### File Transfers
You can instruct the runner to upload or download files, which is useful for sharing artifacts between different steps or jobs in your workflow.
#### Setting Outputs
By setting output parameters, you can pass data from one step to another, making your workflows more dynamic and interconnected.
