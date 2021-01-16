# Ideias que gostaria de implementar
* A solucao para a demanda eu implementei com ansible diretamente num servidor web (IaaS) com suas validacoes e testes.
  Numa estrutura PaaS com kubernetes seria um pouco mais alto nivel ja que poderiamos usar uma imagem para esse microservico e ja teria todas as dependencias versionadas no seu mini mundo. O deploy tambem
  seria com ansible porem ja utilizaria o modulo "template" com jinja2 para fazer um parse de todo o yml.

# Tempo de trabalho gasto
- 60% Planejamento. Aqui estou pensando como atacar a demanda, possibilidades, arquitetura, tecnologias. Nessa etapa vc me ve parado olhando para o nada 
       mas com a cabeça a mil :D
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
> 
> Documentar na wiki:
> - Observacoes sobre o codigo/sugestoes para reportar para o desenvolvedor/PO: 
>     Criar api /status/ pra servir como liveness probe para uma app de monitoramento?
>     Cr
> - Requisitos da automatizacao: Ansible (versao), Conectividade ao servidor web, Inventorio criado no ansible com o(s) servidor(es) web. Credencias criadas para esse inventorio.
> - Como devera ser executado o playbook do ansible (variaveis necessarias etc). (Com AWX ou linha de comando).
> -Considerando que todo o armazenamento dessa app esta em memoria e nao em um SGDB, os dados sao volateis e serao perdidos quando o servidor web eh reiniciado.
