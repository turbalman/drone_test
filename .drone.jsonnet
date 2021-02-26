local code_style_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'echo "add a list of commands for code style check here"',
        'echo "DRONE_BRANCH' + ${DRONE_BRANCH}',
 ],
    when: when
};

local code_duplication_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
           'echo "add a list of commands for code duplication check here"',
 ],
    when: when
};

local code_bug_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
           'echo "add a list of commands for code bug check here"',
 ],
    when: when
};

local unit_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
          'echo "add a list of commands for unit test here"',
  ],
    when: when
};

local integration_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
         'echo "add a list of commands for integration test here"',
   ],
    when: when
};

local pressure_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
         'echo "add a list of commands for pressure test here"',
   ],
    when: when
};

local regression_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
         'echo "add a list of commands for regression test here"',
   ],
    when: when
};
local build(branch, name, image, when) = {
    name: name,
    image:image,
    pull: "always",
    commands: [
           'echo "add a list of commands for build here"',
    ],
    when: when
};

local getImageName(branch) = {
    imageName: "${DRONE_COMMIT_SHA:0:7}"
};

local publish(branch, name, when, repo, dockerfile) = {
    name: name,
    image: "plugins/docker",
    pull: "if-not-exist",
    settings: {
        username: {
            from_secret: "DOCKERHUB_USERNAME",
        },
        password: {
            from_secret: "DOCKERHUB_PASSWORD",
        },
        repo: repo,
        tags: getImageName(branch).imageName,
        dockerfile: dockerfile
    },
    when: when
};

local deploy(branch, name, image, when) = {
    name: name,
    image: image,
    pull: "always",
    commands: [
        'echo "add a list of commands for deploy here"',
     ],
    environment: {
        CLUSTER_NAME: {
            from_secret: "CLUSTER_NAME"
        }
    },
    when: when,
};

local pipeline(branch, type, repo, dockerfile) = {
    kind: 'pipeline',
    type: type,
    name: branch,
    steps: if branch=="main" then [
        code_style_check(branch, "code_style_check", "turbalman/yf", {event: ["push"]}),
        code_duplication_check(branch, "code_duplication_check", "bitnami/jsonnet", {event: ["custom"]}),
        code_bug_check(branch, "code_bug_check", "bitnami/jsonnet", {event: ["custom"]}),
        unit_test(branch, "unit_test", "bitnami/jsonnet", {event: ["custom"]}),
        integration_test(branch, "integration_test", "bitnami/jsonnet", {event: ["custom"]}),
        pressure_test(branch, "pressure_test", "bitnami/jsonnet", {event: ["custom"]}),
        regression_test(branch, "regression_test", "bitnami/jsonnet", {event: ["custom"]}),
        build(branch, "build", "bitnami/jsonnet", {event: ["custom"]}),
        publish(branch, "publish", {event: ["custom"]}, repo, dockerfile),
        deploy(branch, "deploy", "bitnami/jsonnet", {event: ["custom"]}),
    ],
    trigger: {
        branch: branch
    },
    image_pull_secrets: ["dockerconfig"]
};

local type = "docker";
[
    pipeline(branch="main", type=type, repo="turbalman/yf", dockerfile="./Dockerfile")
]
