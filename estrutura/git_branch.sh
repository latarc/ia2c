# Configura o Git para usar SSH em vez de HTTPS 
git remote set-url origin ["GIT_URL"]
git config user.name "Jenkins"
git config user.email "jenkins@correction"

# Muda para a branch dev
git switch main
git checkout main

# Restaura todos os arquivos exceto os da pasta scripts/
git restore --source=HEAD --staged --worktree -- :!scripts/

# Adiciona e commita primeiro
git add scripts/
if ! git diff --cached --quiet; then
  git commit -m "FIX: Correction commit"
fi

# Depois atualiza a branch e faz push
git push origin main
git pull origin main --rebase
