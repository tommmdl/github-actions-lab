# Sobre o histórico / About the history

Em 17/10/2026, as mensagens dos commits da branch `main` foram encurtadas para facilitar a leitura. Essa etapa preservou os arquivos de cada commit, seus autores e suas datas. Depois vieram as alterações de documentação. Os backups do histórico anterior foram salvos localmente antes do force push.

Os relatórios, logs e metadados de imagens continuam mostrando os SHAs usados nas execuções originais. Eles são registros históricos e não foram alterados para aparentar novas execuções. A tabela relaciona esses commits com os commits equivalentes do histórico revisado. O pipeline passa a usar uma revisão acessível do histórico novo em `source.json`.

On 2026-10-17, commit messages on `main` were shortened for readability. This step preserved each commit's files, authors and dates; documentation edits came afterward. Local backups were saved before the force push.

Reports, logs and image metadata still show the SHAs used by their original runs. They are historical records, not rewritten test results. The table maps those commits to their equivalents in the revised history. The pipeline's `source.json` uses an accessible revision from the new history.

| SHA anterior / Previous SHA | SHA equivalente / Equivalent SHA | Mensagem / Message |
| --- | --- | --- |
| `a5b18037857537047d3b91cfd8e73334c7173e20` | `1b059f9a175a5bac6ab84d44485bfeac9bc7efa7` | Cria o pipeline de testes e publicação no GHCR |
| `b598bf465215dbc1c6ab5540ba858074d2415cb8` | `37a17999e3f1fe576ac99fc63179f1a3d2b74a22` | Corrige o secret e confere a imagem publicada |
| `49e4aaad6646f521e1c814b65a69943a1a1cd84d` | `bbed43f796a7d4d814def91e7c4a3541bf97eb26` | Registra os testes e o uso da imagem do GHCR |
