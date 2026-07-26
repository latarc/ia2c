pipeline {
    agent any

    stages {
        stage('Node') {
            steps {
                sh 'hostname'
                sh 'pwd'
            }
        }
        stage('Realizando a autentiação no Git') {
            steps {
                script {
                    def destinationDir= 'IA2C'
                    git credentialsId: 'log-token-git',
                        url: 'git@github.com:Ronynetwork/IA2C.git',
                        branch: 'main'
                        directory: destinationDir
                }
            }
        }
        stage('Instalação do Docker') {
            steps {
                script {
                    sh 'chmod +x Estrutura/docker_setup.sh'
                    sh './Estrutura/docker_setup.sh'
                }
            }
        }
        stage('Configuração do SonarQube') {
            steps {
                script {
                    def sonarContainerExists = sh(script: 'docker ps --filter "name=sonarqube" --format "{{.Names}}"', returnStdout: true).trim()
                    if (sonarContainerExists != "") {
                        echo "O serviço SonarQube já está em execução."
                    }

                    else {
                        def sonarContainerIsDown = sh(script: 'docker ps -a --filter "name=sonarqube" --format "{{.Names}}"', returnStdout: true).trim()
                        if (sonarContainerIsDown != ""){
                            echo "Realizando restart no SonarQube"
                            sh 'docker restart sonarqube'
                        }
                        else{
                            echo "Realizando build do SonarQube"
                            sh 'docker compose -f Estrutura/docker-compose-sonar.yml up -d --remove-orphans'

                        }
                    }
                }
            }
        }
        stage('SonarQube Health Verification') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'sonarToken')]) {
                    script {
                        timeout(time: 1, unit: 'MINUTES'){
                            waitUntil{
                                def status = sh(
                                    script: '''
                                    curl -sf -u "${sonarToken}:" \
                                    http://localhost:9000/api/system/health \
                                    | grep "GREEN"
                                    ''',
                                    returnStatus: true
                                )
                                if (status != 0) {
                                    echo "Aguardando 5s para próxima tentativa..."
                                    sleep 5
                                }
                                return status == 0
                            }
                        }
                    }
                }
            }
        }
        stage('Análise do Código') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner';
                    echo "${scannerHome}"
                    withSonarQubeEnv('IA2C--Main') {
                        env.SONAR_PROJECT_KEY = "${SONAR_CONFIG_NAME}"
                        env.SONAR_URL = "${SONAR_HOST_URL}"
                        sh """
                            ${scannerHome}/bin/sonar-scanner
                        """
                    }
                }
                
            }
        }
        stage('Quality Gate') {
            steps{
                waitForQualityGate abortPipeline: true
            }
        }
    }
    post {
        failure {
            script{
                echo 'instalando pacotes necessários'
                sh 'chmod +x ./Estrutura/setup.sh ; ./Estrutura/setup.sh'

                withSonarQubeEnv('IA2C--Main') {
                    env.SONAR_AUTH_TOKEN = "${SONAR_AUTH_TOKEN}"
                    def output = sh(script: 'python3 Estrutura/source.py', returnStdout: true).trim()
                    env.ERROR_POINT=output
                    echo "${ERROR_POINT}"
                }
            }
            script{
                withCredentials([string(credentialsId: 'API-KEY', variable: 'API_KEY')]) {
                    echo 'Executando arquivo de ML'
                    sh """
                        . papemls/bin/activate
                        chmod +x Estrutura/ML.py
                        API_KEY=${API_KEY} python3 Estrutura/ML.py
                    """
                }

            }
            script {
                echo 'Subindo flask em background'
                sh '''
                    . papemls/bin/activate
                    pwd
                    ls Estrutura/notification
                    chmod +x Estrutura/notification/main.py
                    python3 Estrutura/notification/main.py &
                    sleep 5
                '''
            }
            script {
                echo 'Aguardando resposta do usuário... visite http://127.0.0.1:5000/'
                def startTime = System.currentTimeMillis()
                def duration = 60 * 1000  // 60 segundos

                while ((System.currentTimeMillis() - startTime) < duration) {
                    try {
                        def resposta = sh(script: 'curl -s -X GET http://127.0.0.1:5000/capturar_resposta', returnStdout: true).trim()

                        if (resposta) {
                            def resjson = readJSON text: resposta

                            echo "Resposta recebida do Flask: ${resjson.resposta}"
                            echo "Erros recebidos do Flask: ${resjson.erros}"

                            if (resjson.resposta == "corrigir") {
                                env.ERROS = resjson.erros  
                                sh '''
                                    chmod +x Estrutura/autocorrect.py Estrutura/git_branch.sh
                                    python3 Estrutura/autocorrect.py || echo "Erro no autocorrect"
                                    ./Estrutura/git_branch.sh || echo "Erro no git_branch"
                                '''
                                break
                            } else if (resjson.resposta == 'ignorar') {
                                echo 'Foi solicitada a ação de ignorar!'
                                break
                            } else {
                                echo "Resposta recebida mas com valor inesperado: ${resjson.resposta}"
                            }
                        } else {
                            echo "Resposta vazia do servidor Flask. Tentando novamente..."
                        }

                    } catch (err) {
                        echo "Erro ao tentar capturar ou processar resposta: ${err}"
                    }

                    sleep 5
                }
                echo "Loop finalizado."
            }
        }
    }
}
