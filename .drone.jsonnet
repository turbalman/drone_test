local getBranch() = {
    branch: "${DRONE_BRANCH:0:4}"
};

local getImageName() = {
    imageName: "${DRONE_COMMIT_SHA:0:7}"
};

local code_style_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_SOURCE_BRANCH=${DRONE_SOURCE_BRANCH} DRONE_TARGET_BRANCH=${DRONE_TARGET_BRANCH} DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./code_style_check.sh',
    ],
    when: when
};

local code_duplication_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./code_duplication_check.sh',
 ],
    when: when
};

local code_bug_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./code_bug_check.sh',
 ],
    when: when
};

local unit_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./unit_test.sh',
  ],
    when: when
};

local integration_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./integration_test.sh',
   ],
    when: when
};

local pressure_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./pressure_test.sh',
   ],
    when: when
};

local regression_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./regression_test.sh',
   ],
    when: when
};
local build(branch, name, image, when) = {
    name: name,
    image:image,
    pull: "always",
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./build.sh',
    ],
    when: when
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
        tags: getImageName().imageName,
        dockerfile: dockerfile
    },
    when: when
};

local deploy(branch, name, image, when) = {
    name: name,
    image: image,
    pull: "always",
    commands: [
        'export DRONE_BUILD_KEY=${DRONE_BUILD_KEY} && cd ./cicd/steps && bash -x -v ./deploy.sh',
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
        code_style_check(branch, "code_style_check", "turbalman/yf", {event: ["custom"]}),
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
