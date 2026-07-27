<p align="center">
  <img src="https://github.com/latarc/ia2c/blob/main/assets/logo.svg" alt="Arquitetura IA2C" width="300">
</p><h2 align="center">

<a href="#"><img align="center" alt="desenvolvedor" src="https://img.shields.io/badge/🧑🏻‍💻_Desenvolvedor-Ronyldo_Oliveira-red"/></a>
<a href="#"><img align="center" alt="orientador" src="https://img.shields.io/badge/💡_Orientador-Felipe_Dantas-black"/></a>
<a href="#"><img align="center" alt="license" src="https://img.shields.io/badge/⚖️_LICENSE-MIT_License-black"/></a>
<a href="#"><img align="center" alt="pl" src="https://img.shields.io/badge/python-3.12+-blue"/></a>
<a href="#"><img align="center" alt="status" src="https://img.shields.io/badge/status-active-green"/></a>
<a href="#"><img align="center" alt="open_source" src="https://img.shields.io/badge/open_source-yes-green"/></a>

</h2>

<h1 align="left">🔍 IA2C: Ferramenta Inteligente para Detecção e Remediação Assistida de Violações de Código em Pipelines DevSecOps</h1>


# Introdução
O **IA2C** integra modelos de linguagem ao processo de análise estática (SAST), fornecendo explicações e sugestões de correção para violações identificadas pelo SonarQube durante a execução da pipeline. Além disso, automatiza a configuração do ambiente por meio de scripts que instalam e configuram todas as dependências necessárias para sua utilização, adicionalmente, fornece a interface interativa para correção assistida.


---

# Segurança e Avisos

A execução do IA2C requer privilégios administrativos durante o processo de instalação, uma vez que são realizadas alterações no ambiente operacional, incluindo a instalação de serviços do sistema, Docker Engine e Jenkins.

Recomenda-se utilizar um ambiente de testes ou desenvolvimento antes da execução em ambientes de produção.

Também é responsabilidade do usuário garantir a confidencialidade dos repositórios analisados e das credenciais configuradas durante a integração entre Jenkins, GitHub e SonarQube.

---

# Ambiente de Validação

O ambiente utilizado para desenvolvimento e validação da ferramenta foi composto por:

| Componente | Versão |
|------------|---------|
| Ubuntu | 20.04.1 LTS |
| Docker Engine | 27.4.0 |
| Jenkins | 2.479.3 |
| Java | 21 |
| SonarQube Community | 9.9.8 |
| WSL | WSL2 |
| Ngrok (localhost) | 3.4.0 |
| Hardware utilizado | Intel Xeon E5-2630 v3 • 16 GB RAM • 80 GB SSD |

---

# Arquitetura

O IA2C utiliza a seguinte arquitetura durante sua execução:

```

Ubuntu / WSL
│
├── Python
├── Jenkins
├── Docker Engine
│
└── Docker Compose
│
└── SonarQube (Container)

```

O Jenkins é instalado diretamente no sistema operacional hospedeiro e é responsável pela execução da pipeline.

O SonarQube é disponibilizado através de um container Docker criado automaticamente durante o processo de instalação.

---

# Instalação

## Pré-requisitos

É necessário possuir apenas:

- Ubuntu 20.04 LTS (nativo, WSL2 ou Máquina Virtual);
- Git instalado;
- conexão com a Internet.

Não é necessário instalar previamente:

- Python;
- Docker;
- Docker Compose;
- Jenkins.

Todos esses componentes são instalados automaticamente pelo instalador do IA2C.

---

## Clonando o projeto

```bash
git clone https://github.com/latarc/ia2c.git

cd ia2c
```

---

## Executando o instalador

Conceda permissão de execução ao script:

```bash
chmod +x install.sh
```

Execute o instalador:

```bash
./install.sh
```

Durante a instalação serão executadas automaticamente as seguintes etapas:

- instalação do Python e suas dependências;
- instalação do Docker Engine;
- instalação do Docker Compose;
- instalação do Jenkins;
- inicialização do serviço Jenkins;
- criação da instância do SonarQube utilizando Docker Compose;
- preparação do ambiente para execução da pipeline.

Ao término da instalação estarão disponíveis:

- Jenkins

```
http://localhost:8080
```

- SonarQube

```
http://localhost:9000
```

Caso o instalador adicione o usuário atual ao grupo `docker`, poderá ser necessário realizar logout/login (ou reiniciar a sessão) para utilizar o Docker sem privilégios administrativos.

# Configuração Inicial do Jenkins

Após a instalação, acesse:

```
http://localhost:8080
```

Realize a configuração inicial do Jenkins seguindo a documentação oficial:

- [Configuração inicial do Jenkins](https://www.jenkins.io/doc/book/using/)
- [Configuração de pipelines](https://www.jenkins.io/doc/book/pipeline/)

Ao final da configuração, certifique-se de que:

- o plugin **Pipeline** está instalado (incluído nos plugins sugeridos);
- o plugin **SonarQube Scanner** está instalado;
- as credenciais de acesso ao Git e ao SonarQube foram cadastradas.

---

# Configuração do Jenkinsfile

Antes da primeira execução da Pipeline, atualize o arquivo `Jenkinsfile` com as informações do seu ambiente.

É necessário alterar:

- usuário ou organização do GitHub;
- URL do repositório;
- Local de análise (Atualmente diretório "scripts")
- branch utilizada (quando diferente da padrão);
- identificadores das credenciais cadastradas no Jenkins.

> **Importante:** As variáveis referentes ao repositório Git devem ser atualizadas para o usuário responsável pelo repositório. Caso contrário, o Jenkins não conseguirá autenticar e realizar o checkout do código.

---

# Teste Mínimo

Após concluir a instalação e a configuração inicial do Jenkins:

1. Crie um novo projeto do tipo **Pipeline**;
2. Configure o Pipeline para utilizar o `Jenkinsfile` presente no repositório Git;
3. Execute **Build Now**;
4. Acesse o SonarQube em:

```
http://localhost:9000
```

No SonarQube defina o projeto como "IA2C - Main" e configure a instalação do plugin no Jenkins apontando para o mesmo local de instalação do SonarQube.

# Resultado

O fluxo de execução será:

![image](https://github.com/latarc/ia2c/blob/main/assets/working-flow-500.png)

<p>
  Ao final do processo o pipeline deve analisar seus arquivos presentes no diretório indicado e apresentar problemas encontrados na interface web. Além disso, deve ser possível corrigir os mesmos com a seleção da opção "corrigir".
</p>

# License

[MIT License](LICENSE)
