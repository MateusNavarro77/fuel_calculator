# Documento de Requisitos — MVP

## Calculadora de Custo de Combustível

### 1. Objetivo

Desenvolver um aplicativo mobile que permita ao usuário estimar o custo de combustível de uma viagem a partir de uma rota entre dois endereços.

O aplicativo deverá calcular automaticamente a distância da rota, exibi-la no mapa e informar o custo estimado do combustível necessário para realizar o percurso.

---

# 2. Escopo do MVP

O MVP contempla apenas o cálculo do custo de combustível para uma viagem de carro.

Não fazem parte deste MVP:

* Cadastro de usuários
* Histórico de viagens
* Múltiplos veículos
* Comparação com aplicativos de transporte
* Pedágios
* Estacionamento
* Custos de manutenção
* Escolha entre diferentes combustíveis

---

# 3. Funcionalidades

## RF01 — Informar origem

O usuário deverá informar o endereço de origem da viagem.

---

## RF02 — Informar destino

O usuário deverá informar o endereço de destino da viagem.

---

## RF03 — Informar rendimento do veículo

O usuário deverá informar o rendimento médio do veículo em quilômetros por litro (km/L).

Exemplo:

```
12,5 km/L
```

---

## RF04 — Informar preço do combustível

O usuário deverá informar o preço atual do combustível em reais por litro.

Exemplo:

```
R$ 6,39/L
```

---

## RF05 — Selecionar ida e volta

O usuário poderá habilitar ou desabilitar a opção **Ida e Volta** através de um interruptor (Switch).

Quando desabilitado:

* apenas a rota de ida será considerada.

Quando habilitado:

* a rota de ida será calculada;
* a rota de volta deverá ser calculada separadamente utilizando o trajeto de retorno entre destino e origem, respeitando:

  * sentido das vias;
  * conversões permitidas;
  * restrições de trânsito informadas pela API de rotas.

A distância total será a soma das distâncias da ida e da volta.

---

## RF06 — Calcular rota

Ao solicitar o cálculo, o aplicativo deverá:

* obter a rota entre origem e destino;
* calcular sua distância;
* desenhar o trajeto no mapa.

Caso a opção **Ida e Volta** esteja habilitada:

* obter também a rota entre destino e origem;
* desenhar ambas as rotas no mapa.

---

## RF07 — Calcular custo do combustível

Após obter a(s) rota(s), o aplicativo deverá calcular:

* distância total percorrida;
* combustível necessário;
* custo estimado da viagem.

Utilizando as fórmulas:

```
Litros = Distância Total / Consumo

Custo = Litros × Preço do Combustível
```

---

## RF08 — Exibir resultado

O aplicativo deverá apresentar ao usuário:

* distância da viagem;
* distância de retorno (quando aplicável);
* distância total;
* litros estimados de combustível;
* custo estimado da viagem.

---

# 4. Fluxo de Uso

1. Usuário informa a origem.
2. Usuário informa o destino.
3. Usuário informa o consumo do veículo.
4. Usuário informa o preço do combustível.
5. Usuário escolhe se deseja calcular ida e volta.
6. Usuário pressiona **Calcular**.
7. O aplicativo consulta a API de rotas.
8. A rota é exibida no mapa.
9. O custo do combustível é calculado.
10. O resultado é apresentado ao usuário.

---

# 5. Regras de Negócio

**RN01**

O consumo do veículo deverá ser maior que zero.

---

**RN02**

O preço do combustível deverá ser maior que zero.

---

**RN03**

Origem e destino são obrigatórios.

---

**RN04**

A distância utilizada no cálculo deverá ser a retornada pela API de rotas.

---

**RN05**

Quando a opção **Ida e Volta** estiver habilitada, o retorno deverá ser obtido por uma nova consulta à API, utilizando o percurso de destino para origem. Não será permitido assumir que a distância de volta é igual à distância de ida, pois podem existir diferenças devido ao sentido das vias, conversões obrigatórias ou outras restrições da malha viária.

---

# 6. Requisitos Não Funcionais

* O aplicativo deverá ser desenvolvido em **Flutter**.
* A interface deverá ser simples e intuitiva.
* O mapa deverá exibir a rota calculada.
* O cálculo deverá ocorrer em poucos segundos após a consulta da rota.
* A aplicação deverá funcionar em dispositivos Android.

---

# 7. Critérios de Aceitação

O MVP será considerado concluído quando for possível:

* Informar origem e destino.
* Visualizar a rota no mapa.
* Informar rendimento do veículo.
* Informar preço do combustível.
* Calcular corretamente o custo da viagem.
* Habilitar a opção de ida e volta.
* Calcular o retorno utilizando uma nova rota entre destino e origem.
* Exibir a distância total, o combustível estimado e o custo final da viagem.
