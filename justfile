set shell := ["bash", "-lc"]
set ignore-comments := true

[doc('Show all available commands.')]
default:
    @just --list

[doc('Setup tools.')]
[group('dev')]
setup:
    mise install --locked
    pre-commit install

[doc('Scan for vulnerabilities and secret leaks.')]
[group('security')]
scan:
    gitleaks git
    trivy repo --config trivy.yaml .

[doc('View documentation.')]
[group('docs')]
docs-view:
    pnpm dlx mdts