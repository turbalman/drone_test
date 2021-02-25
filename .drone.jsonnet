local code_style_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};

local code_duplication_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};

local code_bug_check(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};

local unit_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};

local integration_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};

local pressure_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};

local regression_test(branch, name, image, when) = {
    name: name,
    image:image,
    commands: [
    ],
    when: when
};
local build(branch, name, image, when) = {
    name: name,
    image:image,
    pull: "always",
    commands: [
    ],
    when: when
};

local getImageName(branch) = {
    imageName: "${DRONE_COMMIT_SHA:0:7}"
};

local publish(branch, name, image, when, repo, dockerfile) = {
    name: name,
    image:image,
    pull: "of-not-exist",
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
    image:image,
    pull: "always",
    commands: [
        "kubectl get all --namespace=$NAMESPACE",
     ],
    environment: {
        CLUSTER_NAME: {
            from_secret: "CLUSTER_NAME"
        }
    },
    when: when,
};

local pipeline(branch, instance) = {
    kind: 'pipeline',
    type: 'kubernetes',
    name: branch,
    steps: if branch=="dev" then [
        code_style_check(branch, "Test", "bitnami/jsonnet", {instance: instance, event: ["push"]})
    ] else [
    ],
    trigger: {
        branch: branch
    },
    image_pull_secrets: ["dockerconfigjson"]
};

local dev_drone = ["dev-drone"];
local prod_drone = ["prod-drone"];

[
    pipeline(branch="dev", instance=dev_drone),
    pipeline(branch="prod", instance=prod_drone)
]
