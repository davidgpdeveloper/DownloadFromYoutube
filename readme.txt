If it fails, you will need to do the following from the terminal:

1. Install "Node.js LTS"

Install Node.js:
winget install OpenJS.NodeJS.LTS -e

Verify:
node -v

2. Install "Deno"

https://docs.deno.com/runtime/

Install Deno
Install the runtime with one command:

# pwsh
irm https://deno.land/install.ps1 | iex

Verify:
deno --version