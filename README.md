## Projeto para TA da OLT EPON GCOM & 4840 E ##

> Projeto sendo executado no servidor infinity II

## GitLab ##

> https://git.intelbras.com.br/olt-software/automated-tests/gcom

## Jenkins acess ##

> http://10.100.34.170:9090/ \
> login admin\
> passwd intelbras

### SSH Connection ###

> 10.100.34.170:22 \
> login inet \
> passwd Lock1net

## Validações  de acesso ##
> Está sendo um token, gerado neste repositório olt-software/automated-tests/gcom e sendo passado para sincronização com o repositório do git ser aceita.

## Executando o teste ##
> Acessar jenkins (10.100.34.170:9090) \
> Selecionar o TA desejado [EPON/GPON] \
> Select regression \
> Build with parameters \
> OK

## Configurações do teste ##
> Acesse http://10.100.34.170:9090/ \
> Selecione o projeto desejado realizar as modificações \
> Clique em Configure \
> Na etapa de Build > Execute Shell está presente as configurações de shell script aplicadas no servidor para rodar os testes

## Configurações de cenário ##

> IP do servidor:  10.100.34.170:22 \
> inet/Lock1net \
> IP da OLT EPON: 10.100.34.99 \
> admin/admin \
> IP da OLT GPON G08: 10.100.34.66 \
> admin/admin
