<h1 align="center">🔍 IA2C: Ferramenta Inteligente para Detecção e Remediação Assistida de Violações de Código em Pipelines DevSecOps</h1>

<h2 align="center">

<a href="https://hub.docker.com/" target="_blank"><img align="center" alt="Docker" src="https://img.shields.io/badge/Docker-Containerização-black?style=for-the-badge&logo=docker&logoColor=blue"/></a>
<a href="https://www.jenkins.io/doc/" target="_blank"><img align="center" alt="Jenkins" src="https://img.shields.io/badge/Jenkins-CI/CD-black?style=for-the-badge&logo=jenkins&logoColor=orange"/></a>
<a href="https://docs.sonarsource.com/sonarqube-server/" target="_blank"><img align="center" alt="SonarQube" src="https://img.shields.io/badge/SonarQube-SAST-black?style=for-the-badge&logo=sonarqube&logoColor=4E9BCD"/></a>
<a href="#"><img align="center" alt="Python" src="https://img.shields.io/badge/Python-Automação-black?style=for-the-badge&logo=python&logoColor=yellow"/></a>
<a href="https://github.com/Ronynetwork/PAPEMLS" target="_blank"><img align="center" alt="GitHub" src="https://img.shields.io/badge/GitHub-Repositório-black?style=for-the-badge&logo=github"/></a>

<br><br>

<a href="#"><img align="center" alt="Desenvolvedor" src="https://img.shields.io/badge/👨🏻‍💻_Desenvolvedor-Ronyldo_Oliveira-black?style=for-the-badge"/></a>
<a href="#"><img align="center" alt="Orientador" src="https://img.shields.io/badge/💡_Orientador-Felipe_Dantas-black?style=for-the-badge"/></a>

</h2>

# Introdução

O **PAPEMLS** é uma ferramenta voltada ao apoio do processo de análise estática de código em pipelines DevSecOps, integrando tecnologias de **Machine Learning**, **Inteligência Artificial**, **SonarQube** e **Jenkins** para auxiliar desenvolvedores na compreensão e remediação de violações identificadas durante a execução da pipeline.

Ferramentas de análise estática (SAST) são amplamente utilizadas para identificar vulnerabilidades, problemas de qualidade e más práticas de desenvolvimento antes da disponibilização de uma aplicação. Entretanto, compreender a causa de cada violação e definir a melhor estratégia de correção ainda representa um desafio, principalmente em projetos de grande porte.

O PAPEMLS propõe uma abordagem que integra modelos de linguagem ao processo de análise estática, fornecendo explicações contextualizadas e sugestões de correção para as violações detectadas pelo SonarQube durante a execução da pipeline.

Além de automatizar o fluxo de análise, o projeto busca reduzir o esforço necessário para configurar o ambiente de execução, disponibilizando scripts capazes de instalar automaticamente todas as dependências necessárias para sua utilização.

---

# Segurança e Avisos

A execução do PAPEMLS requer privilégios administrativos durante o processo de instalação, uma vez que são realizadas alterações no ambiente operacional, incluindo a instalação de serviços do sistema, Docker Engine e Jenkins.

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

O PAPEMLS utiliza a seguinte arquitetura durante sua execução:

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

Todos esses componentes são instalados automaticamente pelo instalador do PAPEMLS.

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

![image](https://github.com/latarc/ia2c/blob/main/working-flow-500.png)

---

# License

[MIT License](LICENSE)
