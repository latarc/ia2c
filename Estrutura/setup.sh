#!/bin/bash

# Cria o ambiente virtual
python3 -m venv papemls

# Ativa o ambiente virtual
source papemls/bin/activate

# Instala as dependências do arquivo requirements.txt
pip install flask==3.1.2 requests==2.32.5 openai==1.108.0
