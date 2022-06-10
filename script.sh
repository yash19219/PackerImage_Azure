#------------HTTPD INSTALLATION----------------

sudo yum install -y httpd
sudo service httpd start
#sudo service httpd status
sudo chkconfig httpd on
servstat=$(service httpd status)
if [[ $servstat == *"active (running)"* ]]; then echo "HTTPD Process is running!!!!!!!!"
else echo "HTTPD Process is not running XXXXXXXXXXXXX"
fi



#------------JAVA INSTALLATION---------------

number=18
name=jdk-18.0.1.1

sudo wget https://download.oracle.com/java/${number}/latest/jdk-${number}_linux-x64_bin.rpm
sudo yum install -y jdk-${number}_linux-x64_bin.rpm
sudo update-alternatives --install /usr/bin/java java /usr/java/$name/bin/java 2
sudo update-alternatives --install /usr/bin/javac javac /usr/java/$name/bin/javac 2
sudo update-alternatives --install /usr/bin/jar jar /usr/java/$name/bin/jar 2
sudo update-alternatives --install /usr/bin/jshell jshell /usr/java/$name/bin/jshell 2

sudo echo JAVA_HOME"="/usr/java/$name>>~/.profile
sudo echo PATH"="${PATH}:/usr/java/$name/bin>>~/.profile
sudo echo JAVA_HOME"="/usr/java/$name>>~/.bashrc
sudo echo PATH"="${PATH}:/usr/java/$name/bin>>~/.bashrc
source ~/.profile
source ~/.bashrc



#------------TOMCAT INSTALLATION---------------

sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.64/bin/apache-tomcat-9.0.64.tar.gz
tar -xf apache-tomcat-9.0.64.tar.gz
sudo mv apache-tomcat-9.0.64 /opt/tomcat/
sudo ln -s /opt/tomcat/apache-tomcat-9.0.64 /opt/tomcat/latest
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
sudo touch /etc/systemd/system/tomcat.service
sudo echo -e "[Unit]\nDescription=Tomcat 9 servlet container\nAfter=network.target\n\n[Service]\nType=forking\n\nUser=tomcat\nGroup=tomcat\nEnvironment='JAVA_HOME=/usr/java/jdk-18.0.1.1'\nEnvironment='JAVA_OPTS=-Djava.security.egd=file:///dev/urandom'\nEnvironment='CATALINA_BASE=/opt/tomcat/latest'\nEnvironment='CATALINA_HOME=/opt/tomcat/latest'\nEnvironment='CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid'\nEnvironment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'\n\nExecStart=/opt/tomcat/latest/bin/startup.sh\nExecStop=/opt/tomcat/latest/bin/shutdown.sh\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo chkconfig tomcat on
servstat=$(service tomcat status)
if [[ $servstat == *"active (running)"* ]]; then echo "TOMCAT is running!!!!!!!!"
else echo "TOMCAT is not running XXXXXXXXXXXXX"
fi