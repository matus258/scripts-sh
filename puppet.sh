### Instalar Puppet Agent no Ubuntu e CentOS

centos="not"
ubuntu="not"
amzn="not"

# Check CentOS system
if [ -f /etc/os-release ]
then
    id_os=$(egrep "^ID=\"\w{1,}\"$" /etc/os-release | cut -d\" -f2) # Procura o identificador ID e remove o próprio identificador

    if [ ${#id_os} -gt 0 ]
    then
        if [ $id_os = "centos" ]
        then
            centos="exist"
            echo "##################################"
            echo "Identificação do CentOS encontrado"
            echo "##################################"
        fi
    fi
fi

# Check Ubuntu system
if [ -f /etc/lsb-release ]
then
    id_os=$(egrep "^DISTRIB_ID=\w{1,}$" /etc/lsb-release | cut -d\= -f2) # Procura o identificador DISTRIB_ID e remove o próprio identificador

    if [ $id_os = "Ubuntu" ]
    then
        ubuntu="exist"
        echo "##################################"
        echo "Identificação do Ubuntu encontrado"
        echo "##################################"
    fi
fi
# Check Amazon linux system
if [ -f /etc/os-release ]
then
    id_os=$(egrep "^ID=\"\w{1,}\"$" /etc/os-release | cut -d\" -f2) # Procura o identificador ID e remove o próprio identificador

    if [ ${#id_os} -gt 0 ]
    then
        if [ $id_os = "amzn" ]
        then
            amzn="exist"
            echo "##################################"
            echo "Identificação do Amzn encontrado"
            echo "##################################"
        fi
    fi
fi


# Verifica situação improvável de ter encontrado os dois sistemas
if [ $centos = "exist" -a $ubuntu = "exist" ]
then
    echo "Erro: Os dois sistemas foram identificados"
    exit 1
fi

resolv_content=$(egrep "^nameserver\s{1,}10\.113\.128\.2$" /etc/resolv.conf)
if [ ${#resolv_content} -eq 0 ]
then
    echo "#######################################################################"
    echo "Arquivo /etc/resolv.conf ainda não preenchido. Preenchendo o arquivo..."
    echo "#######################################################################"
    cat << EOF >> /etc/resolv.conf
nameserver 10.113.128.2
EOF
else
    echo "##############################################"
    echo "O arquivo /etc/resolv.conf já está preenchido."
    echo "##############################################"
fi

hosts_content=$(egrep "^10\.113\.128\.58\s{1,}ip-10-113-128-58\.ec2\.internal" /etc/hosts)
if [ ${#hosts_content} -eq 0 ]
then
    echo "##############################################################"
    echo "Arquivo /ect/hosts sem o repositório. Incluindo repositório..."
    echo "##############################################################"

    cat << EOF >> /etc/hosts
10.113.128.58   ip-10-113-128-58.ec2.internal
EOF
else
    echo "##############################################################"
    echo "Arquivo /etc/hosts já preenchido. O arquivo não será alterado."
    echo "##############################################################"
fi

path_content=$(egrep "PATH\=.*\/opt\/puppetlabs\/puppet\/bin.*" /root/.bashrc)
if [ ${#path_content} -eq 0 ]
then
    echo "##############################################################################"
    echo "Arquivo /root/.bashrc ainda não preenchido. Incluindo o Puppet na variável PATH"
    echo "##############################################################################"
    echo "PATH=/opt/puppetlabs/puppet/bin:$PATH" >> /root/.bashrc
fi

if [ $centos = "exist" ]
then
    path_content=""
    path_content=$(egrep "PATH\=.*\/opt\/puppetlabs\/puppet\/bin.*" /home/centos/.bashrc)
    if [ ${#path_content} -eq 0 ]
    then
        echo "PATH=/opt/puppetlabs/puppet/bin:$PATH" >> /home/centos/.bashrc
    fi
elif [ $ubuntu = "exist" ]
then
    path_content=""
    path_content=$(egrep "PATH\=.*\/opt\/puppetlabs\/puppet\/bin.*" /home/ubuntu/.bashrc)
    if [ ${#path_content} -eq 0 ]
    then
        echo "PATH=/opt/puppetlabs/puppet/bin:$PATH" >> /home/ubuntu/.bashrc
    fi
elif [ $amzn = "exist" ]
then
    path_content=""
    path_content=$(egrep "PATH\=.*\/opt\/puppetlabs\/puppet\/bin.*" /home/ec2-user/.bashrc)
    if [ ${#path_content} -eq 0 ]
    then
        echo "PATH=/opt/puppetlabs/puppet/bin:$PATH" >> /home/ec2-user/.bashrc
    fi
fi
# Executando ações para CentOS
if [ $centos = "exist" ]
then
    rpm -ivh http://repo.techne.com.br/repos/extras/Packages/puppet-agent-6.0.2-1.el7.x86_64.rpm &> /dev/null

    echo "#########################################"
    echo "Criando arquivo de configuração do Puppet"
    echo "#########################################"

    cat << EOF > /etc/puppetlabs/puppet/puppet.conf
[main]
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = $vardir/ssl

[agent]
classfile = $vardir/classes.txt
localconfig = $vardir/localconfig
server            = ip-10-113-128-58.ec2.internal
runinterval       = 600
environment       = production
EOF

    echo "###########################################"
    echo "Script de instalação para CentOS finalizado"
    echo "###########################################"
fi

# Executando ações para Amazon linux
if [ $amzn = "exist" ]
then
    rpm -ivh http://repo.techne.com.br/repos/extras/Packages/puppet-agent-6.0.2-1.el7.x86_64.rpm &> /dev/null

    echo "#########################################"
    echo "Criando arquivo de configuração do Puppet"
    echo "#########################################"

    cat << EOF > /etc/puppetlabs/puppet/puppet.conf
[main]
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = $vardir/ssl

[agent]
classfile = $vardir/classes.txt
localconfig = $vardir/localconfig
server            = ip-10-113-128-58.ec2.internal
runinterval       = 600
environment       = production
EOF

    echo "###########################################"
    echo "Script de instalação para CentOS finalizado"
    echo "###########################################"
fi

# Executando ações para Ubuntu
if [ $ubuntu = "exist" ]
then
    wget http://repo.techne.com.br/repos/deb/puppet-agent_6.0.2-1xenial_amd64.deb &> /dev/null
    dpkg -i puppet-agent_6.0.2-1xenial_amd64.deb
    rm -f puppet-agent_6.0.2-1xenial_amd64.deb

    echo "#########################################"
    echo "Criando arquivo de configuração do Puppet"
    echo "#########################################"

    cat << EOF > /etc/puppetlabs/puppet/puppet.conf
[main]
logdir = /var/log/puppet
rundir = /var/run/puppet
ssldir = $vardir/ssl

[agent]
classfile = $vardir/classes.txt
localconfig = $vardir/localconfig
server            = ip-10-113-128-58.ec2.internal
runinterval       = 600
environment       = production
EOF

    echo "###########################################"
    echo "Script de instalação para Ubuntu finalizado"
    echo "###########################################"
fi

# Executa Puppet Agent
if [ -f "/opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock" ]
then
    echo "O Puppet já está em execução. Processo finalizado!"
    systemctl enable puppet
else
    /opt/puppetlabs/puppet/bin/puppet agent -t 2> /dev/null
    systemctl enable puppet
fi
