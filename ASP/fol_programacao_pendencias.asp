<%
' - Ao incluir uma nova jornada, ela deve ter flgestado = "N";

' ok - Verificar se existe alguma programação corrente para o Tripulante na data da jornada (problema de concorrência);
' ok - Verificar se o usuário possui acesso (Gravação);
' ok - Apresentar mensagem "Operação realizada com sucesso" após salvamento dos dados;
' ok - Não permitir gravar jornada sem Programação;
' ok - Ocorre erro ao gravar uma programação com Hora Início igual a Hora Fim: Verificar se Data Início é menor que Data Final;
' ok - Para o campo textojornadaaux:
' ok  a) Alimentar o campo com a data/hora início e fim das atividades, mesmo que não seja voo. 
' ok  b) Considerar data/hora executada, preferencialmente, quando houver.
' ok  c) Somente preencher com a Data início/fim se as duas estiverem preenchidas.
' ok - Não está preenchendo textojornada com a data início e fim corretamente;
' ok - Está gravando o codredfuncaobordo ao invés de codfuncaobordo do Voo no textojornadaaux;
' ok - Gravar os campos hrespdiurna, hrespnoturna, hrespdiurnaexec, hrespnoturnaexec
' 1) Implementar o salvamento dos dados.
' ok a) Se for nova jornada:
' ok    a1) Gera sequencial para Jornada;
' ok    a2) Seta flgestado para "N";
' ok	  a3) Insere programação para nova jornada;
' ok b) Se jornada existir e ela estiver publicada (flgestado="P"):
' ok   b1) Altera flgcorrente para "N";
' ok   b2) Insere nova jornada com os dados informados, flgcorrente="S" e flgestado="A" (Não avisado);
' ok c) Se jornada existir e ela não foi publicada (flgestado<>"P"):
' ok    c1) Se foi depois de publicar (flgestado<>"N"), muda flgestado="A" e seta nulo para nomeavisado e dthravisado;
' ok	  c2) Apaga toda programação informada, e insere novamente;
' ok 2) Tratar a recuperação do SeqVooDiaEsc e SeqTrecho para inserção na SIG_PROGRAMACAO.
' 3) Na sig_programacao, se for um voo:
' ok   kmnormal = Distância em km (sig_distancia);
' ok   kmdiurna = Distância proporcional percorrida entre 6:00 às 18:00hs;
' ok   kmnoturna = Distância proporcional percorrida entre 18:00 às 6:00hs;
' ok   kmespdiurna = Distância (especial) proporcional percorrida entre 6:00 às 18:00hs, nos domingos e feriados (da base do Tripulante);
' ok   kmespnoturna = Distância (especial) proporcional percorrida entre 18:00 às 6:00hs, nos domingos e feriados (da base do Tripulante);
' ok   hrdiurna = Total de horas entre 6:00 às 18:00hs;
' ok   hrnoturna = Total de horas entre 18:00 às 6:00hs;
' ok   kmdiurnaexec = Total de horas executada (considerar "partidamotor" ao invés de "partidaprev", e "cortemotor" ao invés de "chegadaprev");
' ok  kmnotornaexec = Idem kmdiurnaexec;
' ok   kmespdiurnaexec = Idem kmdiurnaexec;
' ok   kmespnoturnaexec = Idem kmnoturnaexec;
' ok   hrdiurnaexec = Idem kmdiurnaexec;
' ok   hrnoturnaexec = Idem kmdiurnaexec;
' ok 4) Na sig_programacao, se for uma atividade:
' ok   kmnormal = sig_atividadepagamento.kmhora * horas atividade informada;

' 5) Implementar as críticas escritas na "wf_criticas";

' 6) Na sig_jornada:
' ok   textojornada = Concatenação do "codfuncao" + "nrvoo" + "/", ou "Atividade" + "/"
' ok   textojornadaaux = Menor Hora/Minuto + Maior Hora Minuto da programação;
' ok   kmsav = Total de km qdo codtipoatividade = "SAV"
' ok   kmres = Total de km qdo codtipoatividade = "RES"
' ok   kmvoo = Total de km qdo sig_programacao.flgtipo = "V" (Voo)
' ok   seqchave = Manter o anterior ou criar com nulo;
' ok   dthrapresentacao (dia/hora que o trip deve se apresentar) = Primeiro horário das programações - o campo sig_parametros.tempoapresentacao
' ok   dthrapresentacaorealiz (dia/hora que chegou no aeroporto) = Manter o anterior ou criar com nulo
' ok   dthrcorte = Último horário das programações + o campo sig_parametros.tempocorte
' ok   sequsuario = Usuário logado no sistema
' ok   dthralteracao = Hora que foi feito a atualização
' ok   dtchave = Manter o anterior ou criar com nulo
' ok   flgotm = "N"
' ok   flgpedido = Tá na tela
' ok   observacao = Tá na tela
' ok   textojornadaant = Último textojornada
' ok   nomeavisado = NULL
' ok   dthravisado = NULL

' ok 7) Ordenar as programações por Data Início antes do salvamento
%>