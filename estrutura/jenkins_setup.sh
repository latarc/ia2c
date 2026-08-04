# Update the local environment
sudo apt update

# Install Java 21
sudo apt install fontconfig openjdk-21-jre
java -version

# Download the Jenkins GPG key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the local environment
sudo apt update

# Install Jenkins
sudo apt install jenkins