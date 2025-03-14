#!/bin/bash

# Função para verificar erros
check_error() {
    if [ $? -ne 0 ]; then
        echo "Erro na execução do comando: $1"
        exit 1
    fi
}

# Excluir o que foi criado anteriormente

# Excluindo usuários
echo "Excluindo usuários..."
for user in carlos maria joao debora sebastiana roberto josefina amanda rogerio; do
    userdel -rf $user 2>/dev/null
    check_error "Exclusão do usuário $user"
done

# Excluindo diretórios
echo "Excluindo diretórios..."
for dir in /publico /adm /ven /sec; do
    rm -Rf $dir
    check_error "Exclusão do diretório $dir"
done

# Excluindo grupos
echo "Excluindo grupos..."
for group in GRP_ADM GRP_VEN GRP_SEC; do
    groupdel $group
    check_error "Exclusão do grupo $group"
done

# Criar diretórios
echo "Criando diretórios..."
for dir in /publico /adm /ven /sec; do
    mkdir $dir
    check_error "Criação do diretório $dir"
done

# Criar grupos
echo "Criando grupos..."
for group in GRP_ADM GRP_VEN GRP_SEC; do
    groupadd $group
    check_error "Criação do grupo $group"
done

# Função para criar usuário com senha
create_user() {
    useradd -m -s /bin/bash -G $2 -p "$(openssl passwd -6 $3)" $1
    check_error "Criação do usuário $1"
}

# Criar usuários e definir a senha para Senha1234
echo "Criando usuários..."
create_user carlos GRP_ADM "Senha1234"
create_user maria GRP_ADM "Senha1234"
create_user joao GRP_ADM "Senha1234"
create_user debora GRP_VEN "Senha1234"
create_user sebastiana GRP_VEN "Senha1234"
create_user roberto GRP_VEN "Senha1234"
create_user josefina GRP_SEC "Senha1234"
create_user amanda GRP_SEC "Senha1234"
create_user rogerio GRP_SEC "Senha1234"

# Ajustar as permissões
echo "Setando permissões adequadas..."

# Proprietários dos diretórios
chown root:GRP_ADM /adm
check_error "Alteração de proprietário para /adm"
chown root:GRP_VEN /ven
check_error "Alteração de proprietário para /ven"
chown root:GRP_SEC /sec
check_error "Alteração de proprietário para /sec"

# Permissões
chmod 770 /adm
check_error "Alteração de permissões para /adm"
chmod 770 /ven
check_error "Alteração de permissões para /ven"
chmod 770 /sec
check_error "Alteração de permissões para /sec"

# Permissão para o diretório público
chmod 777 /publico
check_error "Alteração de permissões para /publico"

echo "Pronto..."
