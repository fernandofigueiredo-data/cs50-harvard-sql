# From the Deep

**Etapa 7 · Escala** · [Enunciado oficial](https://cs50.harvard.edu/sql/psets/6/deep/)

particionamento (*sharding*) · distribuição de carga · consultas por intervalo × por chave · hash consistente

## Contexto

O AquaByte Explorer é um submarino de pesquisa fictício que envia milhares de observações por minuto do fundo do oceano. Os dados são distribuídos entre três barcos na superfície (A, B e C). Cada observação é identificada pelo seu timestamp, e a maior parte chega **entre meia-noite e 1h da manhã**.

## Problema a resolver

Avaliar três estratégias de particionamento, discutindo para cada uma se os dados ficam bem distribuídos entre os barcos e em quantos barcos uma consulta precisa rodar. A resposta está em [`answers.md`](answers.md).

## Resumo da análise

| Estratégia | Distribuição dos dados | Consulta por intervalo (ex.: 0h–1h) | Consulta por um timestamp exato |
|---|---|---|---|
| **Aleatória** | ✅ uniforme | ❌ todos os barcos | ❌ todos os barcos |
| **Por hora** (A: 0–7h, B: 8–15h, C: 16–23h) | ❌ o barco A recebe quase tudo | ✅ só o barco A | ✅ um barco |
| **Por hash do timestamp** | ✅ uniforme | ❌ todos os barcos | ✅ um barco (o hash indica qual) |

## Raciocínio

- **Não existe estratégia boa para tudo.** Partições por intervalo favorecem consultas por intervalo, mas concentram carga quando o dado chega concentrado no tempo, como aqui (o *hot spot* é o barco A). O hash distribui bem, mas espalha timestamps vizinhos por barcos diferentes, então uma consulta por intervalo precisa rodar em todos eles.
- **A escolha depende do padrão de acesso.** Se o uso mais comum for buscar uma observação específica, o hash vence. Se for analisar janelas de tempo e a carga for administrável, a partição por hora vence.

## Como ler

O texto completo, com 2 a 3 frases por estratégia como pede o enunciado, está em [`answers.md`](answers.md). Ele foi mantido em inglês, a língua da entrega original.

## Limitações

- A resposta não discute o custo de **inserir** dados em cada estratégia nem o rebalanceamento quando um barco é adicionado, que é onde o *hash consistente* se diferencia do hash simples. O enunciado não pede esses pontos, mas eles aparecem em qualquer projeto real de sharding.
