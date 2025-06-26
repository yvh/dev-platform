# dev-platform

Basic install without desktop environment

```bash
# as root
curl -fsSL "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/install.sh" | bash

# override default user if uid != 1000
USER_OVERRIDE=<user> curl -fsSL "https://raw.githubusercontent.com/yvh/dev-platform/debian-vm/install.sh" | bash

# as user
# oh-my-zsh
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
