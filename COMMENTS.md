# Tags / Branches
* desafio_aurelio_basic_docker_image_stable -> Tag com a versao basica da prova de conceito da api com gunicorn e todos os requirements.txt funcionam com docker. Aqui nao tem automatizacao de ansible ainda. Aqui crio o microservico com docker da forma mais basica. A implementacao com ansible e toda automatizacao entrara logo mais.
* desafio_aurelio: baseline uptodate do projeto.

# Documentaçao: Como fazer deploy 
* Todo o processo automatizado consiste em: Executar comando no ansible para fazer deploy em um servidor especifico (dev/tests). Ansible conecta nesse servidor, cria a estrutura de ficheiros, gera uma imagem docker, para a app caso ja tenha sido instalada anteriormente (versao anterior), instala imagem que contem a api do desafio, testa a app em execucao. Todo teste ok, ansible cria uma tag e faz um push para o repositorio docker.hub com a versao que foi solicitada pelo operador.

Como executar o playbook por linha de comando:
|Passo | Acao |
| -------------| ------------- |
| 1 | Baixar https://github.com/aurelioacn/desafio.git branch desafio_aurelio no host que o ansible esta instalado|
| 2 | cd desafio/ansible_playbook|
| 3 | sudo ansible-playbook --extra-vars "host_to_deploy=localhost app=comentarios version=1.0 web_port=8000" test_app_and_generate_atifact.yml|

|Parametro|Comentario|
|---|---|
|host_to_deploy|Nome do servidor onde sera feito deploy|
|app|Nome da applicacao que esta sendo feito deploy (Levara este nome a imagem do docker)|
|version|Versao da app que sera instalada (Somente para fins didaticos)|
|web_port|Porta onde o servidor devera expor a aplicaçao web.|

# Requisitos/Consideracoes
* Ansible version 2.9.7 ou superior.
* Ansible esta propriamente configurado e com o inventorio e suas credenciais criados.
* O host do Ansible tem acesso a este repositorio git assim como as credenciais para acessa-lo criadas.
* O host onde a app sera instalada tem o servico docker instalado.
* O todos os diretorios e scripts sao criados com chmod +744
* O host onde sera feito o deploy tem acesso ao docker.hub repositorio.

A maioria abaixo seria possivel fazer nessa demanda como IaC porem eu precisaria de mais informacoes.

* Nao existe nenhum bloqueio de FW entre o host do ansible e seu inventorio.
* Todo o inventario tem acesso as bibliotecas/frameworks requisitados pela app. (repositorio interno da empresa ou ate mesmo o publico).
* A porta default do gunicorn 8000 esta aprovada pela equipe de segurança e aberta no iptables do servidor(es) que recebera a app.
* Se essa API for consumida por uma outra app em outro servidor ou ate mesmo um reverse-proxy, nao tem nenhum tipo de bloqueio de FW ate a porta 8000 no(s) servidore(s) que sera feito o deploy.

# Ideias que gostaria de implementar
* Um CI/CD pra orchestrar todo o pipeline:
|Deploy ambiente de teste| -> |Executar testes de api, acceptance, integracao| -> |Construir imagem do docker e publicar no repositorio| -> |Tudo ok?| -> |Deploy em Produçao| -> |Executar testes de api, acceptance em producao| -> delivered
* No final de todo o o processo atualizar o que foi feito deploy, onde, resultado dos testes etc em um servidor web para usuarios consultarem.
* A instalacao do servico docker no host pode ser automatizada tambem com o deploy da app porem por boa pratica um servico de host deve ser criado a nivel de imagem desse host e nao como uma dependencia de app. Isso eu me baseio na minha experiencia porem estou aberto a discussao sobre esse tema.
* A solucao para a demanda eu implementei com ansible diretamente num servidor web (IaaS) com suas validacoes, testes e push para um repositorio publico.
  Numa estrutura PaaS com kubernetes seria um pouco mais alto nivel ja que poderiamos usar uma imagem para esse microservico (em IaaS temos o docker) e ja teria todas as dependencias versionadas no seu mini mundo. O deploy tambem
  seria com ansible porem ja utilizaria o modulo "template" com jinja2 para fazer um parse de todo o yml. Muito mais facil para leitura e reuso.
* Observacoes sobre o codigo/sugestoes para reportar para o desenvolvedor/PO: 
   - Criar api /status/ pra servir como liveness probe para uma app de monitoramento? A response seria por exemplo o total de comentarios feitos, um response OK etc.

# Tempo de trabalho gasto
- 60% Planejamento. Aqui estou pensando como atacar a demanda, possibilidades, arquitetura, tecnologias e algumas provas de conceito. Nessa etapa vc me ve parado olhando para o nada.
- 20% Açao. Aqui eu ja estou demonstrando sinal de vida, estou criando as instruçoes para as ferramentas me baseando no que foi planejado.
- 10% Teste. Nessa parte do tempo estou testando tudo que foi feito e "azeitando" 
- 10% Documentacao. Tudo funcionando e testado faço com que tudo seja documentado de uma forma que ate meu filho entenda.

# Extra: Meu bloco de notas pessoal onde ponho em ordem tudo que eh pra ser feito e algumas reflexoes (aqui nao faz parte da documentacao, aqui sera output para documentacao).
> Tasks de deploy:
>	1. Variaveis a serem passadas pro ansible: 
>		hostname de qual servidor web sera instalada a app, 
>		app/versao do deploy, 
>		porta que vai subir o gunicorn? se nao vai na default (8000) 
>		
>	2. Requisitos para o ansible verificar na maquina a ser instalada (se nao existir, dale install):
>		click==7.1.2
>		Flask==1.1.2
>		gunicorn==20.0.4
>		itsdangerous==1.1.0
>		Jinja2==2.11.2
>		MarkupSafe==1.1.1
>		Werkzeug==1.0.1
>		
>	3. Fazer versionamento (zip) da applicacao e push no git (nexus) -- Essa task depende do escopo da equipe de devops, quem versiona e faz delivery eh a equipe dev?
>	4. Verificar que existe o ficheiro onde sera feita a instalacao, se nao existir criar (/opt/globoHUB/desafio/PACKX_X/).
>	5. Deploy da app no servidor (manter instalacoes anteriores? Eh bom manter pra servir como "historico de fato" no proprio servidor web) /opt/globoHUB/desafio/PACKX_X/api.py
>	6. Iniciar app (servidor web). Qual porta tem que escutar (default 8000)? Tem mais de uma interface de rede?
>	7. Testar aplicacao pra confirmar que subiu bem, se nao -> deploy falhou
>	8. Fazer gerenciamento de configuracao (adicionar versao instalada e em qual servidor web (log startup?))
>	
> Monitoramento:
> -Schedule do ansible de consulta API?
> -Monitorar disco/cpu/memoria do servidor? 
> -LogicMonitor para live monitoring?
> 
> Documentar na wiki:
> - Observacoes sobre o codigo/sugestoes para reportar para o desenvolvedor/PO: 
>     Criar api /status/ pra servir como liveness probe para uma app de monitoramento?
>
> - Requisitos da automatizacao: Ansible (versao), Conectividade ao servidor web, Inventorio criado no ansible com o(s) servidor(es) web. Credencias criadas para esse inventorio.
> - Como devera ser executado o playbook do ansible (variaveis necessarias etc). (Com AWX ou linha de comando).
> - Considerando que todo o armazenamento dessa app esta em memoria e nao em um SGDB, os dados sao volateis e serao perdidos quando o servidor web eh reiniciado.

# Referencias
- Instalar docker no ubuntu 18.04: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
- Docker: https://docs.docker.com/engine/
- Ansible modulos: https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html
- Dockerhub: https://hub.docker.com/repository/docker/aurelioneto/comentarios

# Meu ambiente de trabalho
- WSL2 Ubuntu 18.04
- PyCharm 2020.2.3
