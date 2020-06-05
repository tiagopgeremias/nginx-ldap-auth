# nginx-auth-ldap

### Objetivo
Compilar uma versão do Nginx para CentOS utilizando o modulo de autenticação do LDAP.
Gera o pacote RPM do Nginx com algumas configurações iniciais setadas.

--- 

### Ajuda
Para obter ajuda e verificar quais os valores pré-definidos no script execute o seguinte comando no terminal Linux:

    ./create_rpm -h
    
    :: Parametros
    -v) Informe a versao do Nginx
    -o) Informe o caminho para salvar o binario do Nginx
    
    :: Valores definidos
    Versao Nginx: 1.17.9
    Salvar em: /root/nginx-auth-ldap/nginx-1.17.9-1.el7.noarch.rpm

**Gerando o pacote RPM do Nginx**
Para executar o build que cria o pacote RPM do Nginx é necessario ter o Docker instalado.
Executar o seguinte script:

    ./create_rpm -v <VERSAO NGINX> -o <CAMINHO SAIDA DO BINARIO>

