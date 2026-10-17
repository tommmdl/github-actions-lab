# Validação — 17/10/2026

[English](validation.en.md)

## Execução real

[Workflow aprovado](https://github.com/tommmdl/github-actions-lab/actions/runs/39073184363), iniciado por push na main. Job `test`: 49 segundos; job `publish`: 30 segundos. Concluído às 19:00:29 no fuso America/Sao_Paulo (22:00:29 UTC).

- Commit do pipeline: `b598bf465215dbc1c6ab5540ba858074d2415cb8`.
- Commit da aplicação: `2c04e97d892796659bb2fc716f7ff18cc55d7305`.
- Runner GitHub hospedado: Ubuntu 24.04, arquitetura amd64.
- **23 testes de integração aprovados**, incluindo persistência e recuperação após falha do PostgreSQL.
- Arquivo de imagem validado por SHA-256; ID conferido após `docker load` e após pull do registry.
- Tags publicadas: `latest`, `app-2c04e97d892796659bb2fc716f7ff18cc55d7305` e `run-39073184363-1`.

Imagem publicada:

```text
ghcr.io/tommmdl/docker-lab@sha256:d8fdaffb99e0ac514b9e031ac9204b89fc2702112d198d1bebedd9d351fd19f0
```

## Consumo real do registry

O pull anônimo passou usando um diretório de configuração Docker separado e vazio, sem reutilizar login do GitHub. A imagem publicada foi executada pelo digest no Compose de demonstração da porta 8001. Readiness retornou 200; criação 201; a nota apareceu na listagem e foi excluída com 204. API e PostgreSQL ficaram healthy. Os ambientes locais anteriores nas portas 8000 e 8080 foram preservados.

## Falha inicial e correção

[A primeira execução](https://github.com/tommmdl/github-actions-lab/actions/runs/39073078828) falhou antes dos testes: o arquivo de senha 0600 no host não era legível pelo UID 10001 da API através do bind mount no runner Linux. O job `publish` foi pulado; nenhuma imagem foi publicada por essa execução.

A correção no upstream protege o diretório `.local/` com 0700 e permite leitura do arquivo montado com 0644. O commit corrigido foi fixado em `source.json` e a nova execução passou. A senha não foi incorporada à imagem nem incluída em artefatos.

## Arquivos de evidência

- [Metadados e etapas dos jobs](../evidence/run.json)
- [23 verificações](../evidence/integration-results.json)
- [ID da imagem testada](../evidence/tested-image-id.txt)
- [Digest publicado](../evidence/published-image.txt)
- [Logs do Compose no CI](../evidence/compose.log)
- [Smoke test local pelo GHCR](../evidence/registry-smoke.json)
- [Resumo da falha inicial](../evidence/first-run-failure.txt)

## Limites

Teste e publicação executados em main; o comportamento de PR foi verificado na configuração, sem abrir um PR de demonstração. O bloqueio após falha foi observado na execução inicial. A validação não inclui deploy em produção, múltiplas arquiteturas, testes visuais, assinatura ou análise de vulnerabilidades. Os testes completos rodaram no CI; o teste local da imagem publicada cobriu prontidão e operações básicas de notas. Artefatos do Actions expiram; estes arquivos registram os resultados dessa execução específica. Execução técnica realizada pelo assistente com autorização do proprietário.
