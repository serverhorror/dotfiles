[user]
    name = "Marcher,Martin (IT CTO) BIG-AT-V"
    email = "martin.marcher@boehringer-ingelheim.com"

[credential "https://bitbucket.biscrum.com"]
    bitbucketAuthModes = "oauth"
    helper = "cache --timeout 86399"
    helper = "oauth --device"
    provider = "bitbucket"
    useHttpPath = "true"

[credential "https://config-repo.werum.com/scm/big/com.kphs.big.deployment.environment.git"]
    provider = bitbucket
