
centos7="not"
centos6="not"
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
            centos7="exist"
            echo "##################################"
            echo "Identificação do CentOS 7 encontrado"
            echo "##################################"
        fi
    fi
fi
if [ -f /etc/centos-release ]
then
    id_os=$(cut -d" " -f1 /etc/centos-release) # Procura o identificador ID e remove o próprio identificador

    if [ ${#id_os} -gt 0 ]
    then
        if [ $id_os = "CentOS" ]
        then
            centos6="exist"
            echo "##################################"
            echo "Identificação do CentOS 6 encontrado"
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

if [ $centos7 = "exist" ]
then
    sudo yum update -y
    sudo yum install -y ansible
    echo "ansible instalado"
fi

if [ $centos6 = "exist" ]
then
    sudo yum update -y
    sudo yum install -y epel-release
    sudo yum install -y ansible
    echo "ansible instalado"
fi

if [ $ubuntu = "exist" ]
then
    sudo apt update -y
    sudo apt install -y ansible
    echo "ansible instalado"

fi

if [ $amzn = "exist" ]
then
    sudo yum update -y 
    sudo yum install -y python-pip
    sudo pip install ansible
    echo "ansible instalado"
fi

echo "##################"
echo "Script finalizado"
echo "##################"