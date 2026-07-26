import requests, os, base64, json, logging

#Configurações de logging
log = logging.getLogger(__file__.split("/")[-1]) 
logging.basicConfig(encoding="utf-8", level=logging.INFO)

# Configurações do SonarQube
SONARQUBE_URL = os.getenv('SONAR_URL')
TOKEN = os.getenv('SONAR_AUTH_TOKEN')
PROJECT_KEY = os.getenv('SONAR_PROJECT_KEY')
log.info(f"{PROJECT_KEY} sendo analizado")

auth_header = base64.b64encode(f"{TOKEN}:".encode()).decode()
params = {
    "project": PROJECT_KEY,
    "sort": "date",  # Ordena pela data da análise mais recente
    "statuses": "OPEN",
    "resolved": 'false'
}

def code_source(file, line):    
    # Requisição para pegar o código do arquivo
    log.info("Executando função code_source para get do código fonte...")
    response = requests.get(
        f'{SONARQUBE_URL}/api/sources/raw',  # Endpoint correto
        params={
            'key': file  # Aqui é necessário usar o 'key' com o formato correto
        },
        headers = {'Authorization': f'Basic {auth_header}'}
    )

    code = response.text

    code_lines = code.splitlines()
    if line:
        line_with_error = code_lines[line-1]
    else:
        line_with_error = None
    if response.status_code == 200:
        # Se a resposta for bem-sucedida, imprime o conteúdo do arquivo
        return line_with_error# Exibe o conteúdo do arquivo
    else:
        return f"Erro {response.status_code}: {response.text}"

def code_request():

    params = {
        "componentKeys": PROJECT_KEY,
        "sort": "date",  # Ordena pela data da análise mais recente
        "statuses": "OPEN",
        "resolved": 'false'
    }   
    # Função para fazer uma requisição à API do SonarQube e processar os problemas encontrados
    log.info("Executando função code_request para get da análise...")
    try:
        response = requests.get(f"{SONARQUBE_URL}/api/issues/search", 
                                params=params, 
                                headers={
                                     'Authorization': f'Basic {auth_header}'
                                })
    except Exception as e:
        log.error('Erro na requisição:', e)

    # Verifica se a requisição foi bem-sucedida
    if response.status_code == 200:
        log.info("Relatório retornado com sucesso")
        # Processa a resposta da API como um JSON
        arq = response.json()
        # Filtra as issues para garantir que apenas as do projeto atual sejam processadas
        try:
            filtred_issues = [issue for issue in arq.get('issues', [])]
        except Exception as e:
            log.error("Erro no filtro de issues", e)
        dict_error = {}

        if filtred_issues:
            log.info("Iterando sobre os erros filtrados")
            # Itera sobre as issues filtradas
            for issue in filtred_issues:
                message = issue['message']  # Mensagem de erro do SonarQube
                line = issue.get('line') # Linha onde o problema foi identificado
                component = issue['component']  # Componente (arquivo) onde o problema está localizado
                
                try:
                    linha_com_erro = code_source(component, line)
                except Exception as e:
                    print("Erro ao buscar informações da análise:", e)
                
                if component not in dict_error:
                    log.info("Criação de chave do componente")
                    dict_error[component] = []
                else:
                    log.info("Append de erro no componente")
                    dict_error[component].append((line, message, linha_com_erro))
        if dict_error.keys(): # Executando e enviando todo o dicionário de dados
            log.info("Retornando erros")
            msg = json.dumps(dict_error)
        else:
            msg = f'O repositório não possui issues abertas!'
        return msg
    else:
        # Caso a requisição não seja bem-sucedida, exibe uma mensagem de erro
        return f"Erro ao acessar o código-fonte: {response.status_code} - {response.text}"

# Chama a função para iniciar o processo de requisição e resolução de erros
try:
    print(code_request())
except Exception as e:
    log.error("Erro ao buscar informações da análise:", e)