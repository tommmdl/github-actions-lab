# GitHub Actions: do teste à imagem publicada

[English](README.en.md) · Português

Depois de colocar a aplicação para rodar com Docker, o próximo passo é parar de repetir tudo à mão. Este projeto leva os testes para o GitHub Actions e publica a imagem no GHCR quando eles passam.

A parte principal é manter o que foi testado: o primeiro job constrói e verifica a imagem; o segundo recebe essa mesma imagem e a publica, sem reconstruir. O código da aplicação continua no [docker-lab](https://github.com/tommmdl/docker-lab).

[![CI + GHCR](https://github.com/tommmdl/github-actions-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/tommmdl/github-actions-lab/actions/workflows/ci.yml)

## Para começar

Para acompanhar o pipeline, basta acessar o repositório. Para a demonstração local, use Linux/WSL, Docker, Compose, Bash, Python 3, curl e porta 8001 livre.

Na raiz deste repositório:

```bash
gh workflow run ci.yml --repo tommmdl/github-actions-lab --ref main
gh run list --repo tommmdl/github-actions-lab
```

Você também pode abrir **Actions → Test and publish Docker Lab → Run workflow** no GitHub.

A imagem publicada está disponível sem login:

```bash
docker pull ghcr.io/tommmdl/docker-lab:latest
```

Para rodar o ambiente de demonstração:

```bash
bash scripts/prepare.sh
bash scripts/compose.sh -f compose.ghcr.yaml up -d --wait --wait-timeout 180
```

Abra http://localhost:8001. Use o digest publicado no lugar de `latest` para escolher uma imagem específica.

## Experimente

1. Acompanhe os testes e confira os artefatos da execução.
2. Compare o ID da imagem testada com o publicado.
3. Baixe a imagem do GHCR e execute a aplicação.
4. Atualize o commit em `source.json` quando quiser testar outra revisão do `docker-lab`.

## O que já foi testado

O pipeline passou pelos 23 testes e publicou a imagem. O pull anônimo funcionou, e a aplicação publicada foi testada localmente. A documentação também mostra uma execução que falhou e bloqueou a publicação.

Os [resultados e seus limites](docs/validation.md) estão registrados com os comandos e evidências da execução. Eles se referem às revisões indicadas nos relatórios.

## Quando terminar

```bash
bash scripts/compose.sh -f compose.ghcr.yaml down
```

A demonstração mantém as notas em um volume próprio; adicionar `-v` apaga esses dados. Pull requests só testam. A publicação fica restrita à main e usa o `GITHUB_TOKEN` temporário, sem PAT.

## Para ir além

O [guia de uso](docs/guide.md) reúne arquitetura, configuração, testes, limitações e ajuda para investigar problemas. O [portfólio](https://github.com/tommmdl/devops-portfolio) conecta este projeto aos outros laboratórios.

[Sobre a revisão do histórico](docs/history.md)

## Conferir a segurança da imagem

O [security-lab](https://github.com/tommmdl/security-lab) analisa a imagem publicada deste projeto com Trivy e aplica um gate de HIGH/CRITICAL. O bloqueio e seus relatórios ficam no CI daquele repositório; esta pipeline de publicação ainda não depende desse gate.
